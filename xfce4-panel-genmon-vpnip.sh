#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONLINE_ICON="${BASEDIR}/icons/online.png"
OFFLINE_ICON="${BASEDIR}/icons/offline.png"
{ 
  IFS=":"
    read -r vpn_status_label vpn_status 
    read -r vpn_hostname_label vpn_hostname 
    read -r vpn_ip_label vpn_ip 
    read -r vpn_country_label vpn_country 
    read -r vpn_city_label vpn_city  
    read -r vpn_tech_label vpn_tech 
    read -r vpn_proto_label vpn_proto 
    read -r vpn_transfer_label vpn_transfer 
    read -r vpn_uptime_label vpn_uptime 
  } < <(nordvpn status)

STATUS=($(nordvpn status))
# declare -p STATUS
echo $vpn_status
echo $vpn_uptime
ip=$(echo ${STATUS} | grep IP: | cut -d: -f2)
if [ "${vpn_ip}" != "" ]; then
  printf "<img>${ONLINE_ICON}</img>"
  if command -v xclip; then
    printf "<click>sh -c 'printf ${vpn_ip} | xclip -selection clipboard'</click>"
    printf "<txtclick>sh -c 'printf ${vpn_ip} | xclip -selection clipboard'</txtclick>"

    INFO="VPN IP: ${vpn_ip}\n"
    INFO+="Country: ${vpn_country} \n"
    INFO+="Uptime: ${vpn_uptime} \n"
    printf "<tool>${INFO}</tool>"
  else
    printf "<tool>VPN IP (install xclip to copy to clipboard)</tool>"
  fi
else
  printf "<img>${OFFLINE_ICON}</img>"
  printf "<click>sh -c 'nordvpn c'</click>"
  printf "<txtclick>sh -c 'nordvpn c'</txtclick>"
  printf "<tool><span weight='Bold' fgcolor='Red'>Unprotected</span> - Click to connect</tool>"
fi
