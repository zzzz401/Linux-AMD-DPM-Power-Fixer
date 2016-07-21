#!/bin/bash
# Script For Displaying and Setting Current AMD DPM Preset Values on Linux.
# Meant to to be run a boot with the PowerState and PowerLevel set to a desired preset.

set -e;

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root";
   exit 1;
fi

PowerState="performance";
PowerLevel="high";
VideoCards=$(lspci | grep -c "VGA");


function readStates {
  local COUNTER=0;
  while [ $COUNTER -lt $VideoCards ]; do
    echo -e "\nVideo Card $COUNTER";
    echo "Power State: $(cat /sys/class/drm/card$COUNTER/device/power_dpm_state)";
    echo "Performance Level: $(cat /sys/class/drm/card$COUNTER/device/power_dpm_force_performance_level)";
    let COUNTER=COUNTER+1;
  done
}

function setStates {
  local COUNTER=0;
  while [ $COUNTER -lt $VideoCards ]; do
    echo "$PowerState" > "/sys/class/drm/card$COUNTER/device/power_dpm_state";
    echo "$PowerLevel" > "/sys/class/drm/card$COUNTER/device/power_dpm_force_performance_level";
    let COUNTER=COUNTER+1;
  done
}

echo -e "\nCurrent Power States:";
readStates;
echo -e "\nSetting Power States!";
setStates;
echo -e "\nNew Power States:";
readStates;
exit 0;
