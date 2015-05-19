##################################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		    ##
##                                                                                                      	    ##
## December, 2014                     	                                                                	    ##
##                                                                                                      	    ##
## Version 1.0                                                                                          	    ##
##																									    	    ##
## DESCRIPTION: Monitor server uptime, blocked processes and run queue length									##
##																											    ##
## SYNTAX: ./system_linux.sh <METRIC_STATE>             													    ##
##																											    ##
## EXAMPLE: ./system_linux.sh "1,1,1"         														    	    ##
##																											    ##
##                                      ############                                                    	    ##
##                                      ## README ##                                                    	    ##
##                                      ############                                                    	    ##
##																											    ##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	    ##
##																											    ##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	    ##
##																											    ##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	    ##
##																											    ##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "system_linux.sh" "192.168.1.1" "1,1,1" "" "" "" "" "1"                  ##
## 			(REMOTE) sh "runremote.sh" "system_linux.sh" "192.168.1.1" "1,1,1" "user" "pass" "/tmp" "null" "0"  ##
##																											    ##
## HOST - hostname or ip address where script will be executed.                                         	    ##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	    ##
##         		  1 - metric is on ; 0 - metric is off					              						    ##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	    ##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	    ##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		    ##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                 	##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	    ##
##################################################################################################################


#METRIC_ID
UPTIMEID="6:Uptime:7"
BlockedProcs="52:Blocked Processes:4"
CPUQL="1:Run Queue Length:4"

#INPUTS
uptime_on=`echo $1 | awk -F',' '{print $1}'`
queuelength_on=`echo $1 | awk -F',' '{print $3}'`
procsblocked_on=`echo $1 | awk -F',' '{print $2}'`


uptime=`cat /proc/uptime | awk '{print $1}'`
queuelength=`vmstat |tail -1|awk '{print $1}'`
procsblocked=`cat /proc/stat | grep procs_blocked | awk '{print $2}'`
 

 
# Validate if all metrics were collected correctly
	if [ $uptime_on -eq 1 ] && [ "$uptime" = "" ]
	then
			#Unable to collect metrics
			exit 8 
	fi
	if [ $procsblocked_on -eq 1 ] && [ "$procsblocked" = "" ]
	then
			#Unable to collect metrics
			exit 8 
	fi
	if [ $queuelength_on -eq 1 ] && [ "$queuelength" = "" ]
	then
			#Unable to collect metrics
			exit 8 
	fi

# Send Metrics
if [ $queuelength_on -eq 1 ]
then
	echo "$CPUQL|$queuelength|"
fi 
if [ $uptime_on -eq 1 ]
then
	echo "$UPTIMEID|$uptime|"
fi
if [ $procsblocked_on -eq 1 ]
then
	echo "$BlockedProcs|$procsblocked|"
fi
