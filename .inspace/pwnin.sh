#! /bin/sh
#
# pwnin.sh
# Copyright (C) 2020 wlz <wlz@wlz-OMEN>
#
# Distributed under terms of the MIT license.
#

path=$(pwd)

export DISABLE_AUTO_TITLE="true"

session="pwn"

tmux has-session -t $session

if [ $? = 0]
then
    tmux attach-session -t $session
    exit
fi

arch=$2

tmux new-session -d -s $session -n home
tmux split-window -t $session:1 -h
tmux send-keys -t $session:1.1 'ls -la' C-m
tmux send-keys -t $session:1.2 'git status' C-m
tmux new-window -t $session:2 -n edit 
tmux split-window -t $session:2 -h -p 20
tmux send-keys -t $session:2.1 'la' C-m
tmux send-keys -t $session:2.1 'vim '$arch'.py' C-m
tmux send-keys -t $session:2.2 'ipython3' C-m
tmux new-window -t $session:3 -n gdb
tmux split-window -t $session:3 -h -p 20
tmux send-keys -t $session:3.2 'ipython3' C-m
tmux send-keys -t $session:3.2 'ls' C-m

gdb16=16
gdb18=18
echo $path
if [ $1 -eq $gdb16  ]
then
    tmux send-keys -t $session:1.1 'echo "into gdb16 pwn it"' C-m
    tmux send-keys -t $session:3.1 'docker run -it -v '$path':/home/ lingze/gdb:16 /bin/bash' C-m
elif [ $1 -eq $gdb18 ]
then
    tmux send-keys -t $session:1.1 ''echo "into gdb18 pwn it" C-m
    tmux send-keys -t $session:3.1 'docker run -it -v '$path':/home/ lingze/gdb:18 /bin/bash' C-m
else
    echo 
    tmux send-keys -t $session:1.1 'echo "no this gdb' C-m
fi


tmux send-keys -t $session:3.1 'cd home/' C-m
tmux send-keys -t $session:3.1 'ls' C-m
tmux send-keys -t $session:3.1 'gdb '$arch C-m
tmux send-keys -t $session:3.1 'chmod +x '$arch C-m

tmux select-window -t $session:1
tmux attach-session -t $session
