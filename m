Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F26219591
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgGIBS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgGIBSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:50 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20BA22080D;
        Thu,  9 Jul 2020 01:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257528;
        bh=xZZr1NGg4wDEEmyRBrDfATZt+llLYAHJWqUdlNRNV6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRGE/UGdO1SkDPv4BsJuhEcX2Vtd0DdmDnvE0UsoTyQxjiMyZ4w3HlXkYV0wTXmTH
         LqNmc//DbN9Eq4DbSIW7E6nqzcVmcMJldCH1SRdpzejSozAqOLEmq0nYEyvG06RY9e
         dPTE7PWlCtdIrzjx54pFDUlc0C7ZqrJq44/e50cE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 06/10] selftests: net: add a test for UDP tunnel info infra
Date:   Wed,  8 Jul 2020 18:18:10 -0700
Message-Id: <20200709011814.4003186-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add validating the UDP tunnel infra works.

$ ./udp_tunnel_nic.sh
PASSED all 383 checks

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 786 ++++++++++++++++++
 1 file changed, 786 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
new file mode 100644
index 000000000000..ba1d53b9f815
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
@@ -0,0 +1,786 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+
+VNI_GEN=$RANDOM
+NSIM_ID=$((RANDOM % 1024))
+NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
+NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID
+NSIM_NETDEV=
+HAS_ETHTOOL=
+EXIT_STATUS=0
+num_cases=0
+num_errors=0
+
+clean_up_devs=( )
+
+function err_cnt {
+    echo "ERROR:" $@
+    EXIT_STATUS=1
+    ((num_errors++))
+    ((num_cases++))
+}
+
+function pass_cnt {
+    ((num_cases++))
+}
+
+function cleanup_tuns {
+    for dev in "${clean_up_devs[@]}"; do
+	[ -e /sys/class/net/$dev ] && ip link del dev $dev
+    done
+    clean_up_devs=( )
+}
+
+function cleanup_nsim {
+    if [ -e $NSIM_DEV_SYS ]; then
+	echo $NSIM_ID > /sys/bus/netdevsim/del_device
+    fi
+}
+
+function cleanup {
+    cleanup_tuns
+    cleanup_nsim
+}
+
+trap cleanup EXIT
+
+function new_vxlan {
+    local dev=$1
+    local dstport=$2
+    local lower=$3
+    local ipver=$4
+    local flags=$5
+
+    local group ipfl
+
+    [ "$ipver" != '6' ] && group=239.1.1.1 || group=fff1::1
+    [ "$ipver" != '6' ] || ipfl="-6"
+
+    [[ ! "$flags" =~ "external" ]] && flags="$flags id $((VNI_GEN++))"
+
+    ip $ipfl link add $dev type vxlan \
+       group $group \
+       dev $lower \
+       dstport $dstport \
+       $flags
+
+    ip link set dev $dev up
+
+    clean_up_devs=("${clean_up_devs[@]}" $dev)
+
+    check_tables
+}
+
+function new_geneve {
+    local dev=$1
+    local dstport=$2
+    local ipver=$3
+    local flags=$4
+
+    local group ipfl
+
+    [ "$ipver" != '6' ] && remote=1.1.1.2 || group=::2
+    [ "$ipver" != '6' ] || ipfl="-6"
+
+    [[ ! "$flags" =~ "external" ]] && flags="$flags vni $((VNI_GEN++))"
+
+    ip $ipfl link add $dev type geneve \
+       remote $remote  \
+       dstport $dstport \
+       $flags
+
+    ip link set dev $dev up
+
+    clean_up_devs=("${clean_up_devs[@]}" $dev)
+
+    check_tables
+}
+
+function del_dev {
+    local dev=$1
+
+    ip link del dev $dev
+    check_tables
+}
+
+# Helpers for netdevsim port/type encoding
+function mke {
+    local port=$1
+    local type=$2
+
+    echo $((port << 16 | type))
+}
+
+function pre {
+    local val=$1
+
+    echo -e "port: $((val >> 16))\ttype: $((val & 0xffff))"
+}
+
+function pre_ethtool {
+    local val=$1
+    local port=$((val >> 16))
+    local type=$((val & 0xffff))
+
+    case $type in
+	1)
+	    type_name="vxlan"
+	    ;;
+	2)
+	    type_name="geneve"
+	    ;;
+	4)
+	    type_name="vxlan-gpe"
+	    ;;
+	*)
+	    type_name="bit X"
+	    ;;
+    esac
+
+    echo "port $port, $type_name"
+}
+
+function check_table {
+    local path=$NSIM_DEV_DFS/ports/$port/udp_ports_table$1
+    local -n expected=$2
+    local last=$3
+
+    read -a have < $path
+
+    if [ ${#expected[@]} -ne ${#have[@]} ]; then
+	echo "check_table: BAD NUMBER OF ITEMS"
+	return 0
+    fi
+
+    for i in "${!expected[@]}"; do
+	if [ -n "$HAS_ETHTOOL" -a ${expected[i]} -ne 0 ]; then
+	    pp_expected=`pre_ethtool ${expected[i]}`
+	    ethtool --show-tunnels $NSIM_NETDEV | grep "$pp_expected" >/dev/null
+	    if [ $? -ne 0 -a $last -ne 0 ]; then
+		err_cnt "ethtool table $1 on port $port: $pfx - $msg"
+		echo "       check_table: ethtool does not contain '$pp_expected'"
+		ethtool --show-tunnels $NSIM_NETDEV
+		return 0
+
+	    fi
+	fi
+
+	if [ ${expected[i]} != ${have[i]} ]; then
+	    if [ $last -ne 0 ]; then
+		err_cnt "table $1 on port $port: $pfx - $msg"
+		echo "       check_table: wrong entry $i"
+		echo "       expected: `pre ${expected[i]}`"
+		echo "       have:     `pre ${have[i]}`"
+		return 0
+	    fi
+	    return 1
+	fi
+    done
+
+    pass_cnt
+    return 0
+}
+
+function check_tables {
+    # Need retries in case we have workqueue making the changes
+    local retries=10
+
+    while ! check_table 0 exp0 $((retries == 0)); do
+	sleep 0.02
+	((retries--))
+    done
+    while ! check_table 1 exp1 $((retries == 0)); do
+	sleep 0.02
+	((retries--))
+    done
+}
+
+function print_table {
+    local path=$NSIM_DEV_DFS/ports/$port/udp_ports_table$1
+    read -a have < $path
+
+    tree $NSIM_DEV_DFS/
+
+    echo "Port $port table $1:"
+
+    for i in "${!have[@]}"; do
+	echo "    `pre ${have[i]}`"
+    done
+
+}
+
+function print_tables {
+    print_table 0
+    print_table 1
+}
+
+function get_netdev_name {
+    local -n old=$1
+
+    new=$(ls /sys/class/net)
+
+    for netdev in $new; do
+	for check in $old; do
+            [ $netdev == $check ] && break
+	done
+
+	if [ $netdev != $check ]; then
+	    echo $netdev
+	    break
+	fi
+    done
+}
+
+###
+### Code start
+###
+
+# Probe ethtool support
+ethtool -h | grep show-tunnels 2>&1 >/dev/null && HAS_ETHTOOL=y
+
+modprobe netdevsim
+
+# Basic test
+pfx="basic"
+
+for port in 0 1; do
+    old_netdevs=$(ls /sys/class/net)
+    if [ $port -eq 0 ]; then
+	echo $NSIM_ID > /sys/bus/netdevsim/new_device
+    else
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+	echo 1 > $NSIM_DEV_SYS/new_port
+    fi
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
+
+    msg="new NIC device created"
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+    check_tables
+
+    msg="VxLAN v4 devices"
+    exp0=( `mke 4789 1` 0 0 0 )
+    new_vxlan vxlan0 4789 $NSIM_NETDEV
+    new_vxlan vxlan1 4789 $NSIM_NETDEV
+
+    msg="VxLAN v4 devices go down"
+    exp0=( 0 0 0 0 )
+    ifconfig vxlan1 down
+    ifconfig vxlan0 down
+    check_tables
+
+    msg="VxLAN v6 devices"
+    exp0=( `mke 4789 1` 0 0 0 )
+    new_vxlan vxlanA 4789 $NSIM_NETDEV 6
+
+    for ifc in vxlan0 vxlan1; do
+	ifconfig $ifc up
+    done
+
+    new_vxlan vxlanB 4789 $NSIM_NETDEV 6
+
+    msg="another VxLAN v6 devices"
+    exp0=( `mke 4789 1` `mke 4790 1` 0 0 )
+    new_vxlan vxlanC 4790 $NSIM_NETDEV 6
+
+    msg="Geneve device"
+    exp1=( `mke 6081 2` 0 0 0 )
+    new_geneve gnv0 6081
+
+    msg="NIC device goes down"
+    ifconfig $NSIM_NETDEV down
+    if [ $port -eq 1 ]; then
+	exp0=( 0 0 0 0 )
+	exp1=( 0 0 0 0 )
+    fi
+    check_tables
+    msg="NIC device goes up again"
+    ifconfig $NSIM_NETDEV up
+    exp0=( `mke 4789 1` `mke 4790 1` 0 0 )
+    exp1=( `mke 6081 2` 0 0 0 )
+    check_tables
+
+    cleanup_tuns
+
+    msg="tunnels destroyed"
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+    check_tables
+
+    modprobe -r geneve
+    modprobe -r vxlan
+    modprobe -r udp_tunnel
+
+    check_tables
+done
+
+modprobe -r netdevsim
+
+# Module tests
+pfx="module tests"
+
+if modinfo netdevsim | grep udp_tunnel >/dev/null; then
+    err_cnt "netdevsim depends on udp_tunnel"
+else
+    pass_cnt
+fi
+
+modprobe netdevsim
+
+old_netdevs=$(ls /sys/class/net)
+port=0
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+echo 1000 > $NSIM_DEV_DFS/udp_ports_sleep
+echo 0 > $NSIM_DEV_SYS/new_port
+NSIM_NETDEV=`get_netdev_name old_netdevs`
+
+msg="create VxLANs"
+exp0=( 0 0 0 0 ) # sleep is longer than out wait
+new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+modprobe -r vxlan
+modprobe -r udp_tunnel
+
+msg="remove tunnels"
+exp0=( 0 0 0 0 )
+check_tables
+
+msg="create VxLANs"
+exp0=( 0 0 0 0 ) # sleep is longer than out wait
+new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+exp0=( 0 0 0 0 )
+
+modprobe -r netdevsim
+modprobe netdevsim
+
+# Overflow the table
+
+function overflow_table0 {
+    local pfx=$1
+
+    msg="create VxLANs 1/5"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    msg="create VxLANs 2/5"
+    exp0=( `mke 10000 1` `mke 10001 1` 0 0 )
+    new_vxlan vxlan1 10001 $NSIM_NETDEV
+
+    msg="create VxLANs 3/5"
+    exp0=( `mke 10000 1` `mke 10001 1` `mke 10002 1` 0 )
+    new_vxlan vxlan2 10002 $NSIM_NETDEV
+
+    msg="create VxLANs 4/5"
+    exp0=( `mke 10000 1` `mke 10001 1` `mke 10002 1` `mke 10003 1` )
+    new_vxlan vxlan3 10003 $NSIM_NETDEV
+
+    msg="create VxLANs 5/5"
+    new_vxlan vxlan4 10004 $NSIM_NETDEV
+}
+
+function overflow_table1 {
+    local pfx=$1
+
+    msg="create GENEVE 1/5"
+    exp1=( `mke 20000 2` 0 0 0 )
+    new_geneve gnv0 20000
+
+    msg="create GENEVE 2/5"
+    exp1=( `mke 20000 2` `mke 20001 2` 0 0 )
+    new_geneve gnv1 20001
+
+    msg="create GENEVE 3/5"
+    exp1=( `mke 20000 2` `mke 20001 2` `mke 20002 2` 0 )
+    new_geneve gnv2 20002
+
+    msg="create GENEVE 4/5"
+    exp1=( `mke 20000 2` `mke 20001 2` `mke 20002 2` `mke 20003 2` )
+    new_geneve gnv3 20003
+
+    msg="create GENEVE 5/5"
+    new_geneve gnv4 20004
+}
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    overflow_table0 "overflow NIC table"
+    overflow_table1 "overflow NIC table"
+
+    msg="replace VxLAN in overflow table"
+    exp0=( `mke 10000 1` `mke 10004 1` `mke 10002 1` `mke 10003 1` )
+    del_dev vxlan1
+
+    msg="vacate VxLAN in overflow table"
+    exp0=( `mke 10000 1` `mke 10004 1` 0 `mke 10003 1` )
+    del_dev vxlan2
+
+    msg="replace GENEVE in overflow table"
+    exp1=( `mke 20000 2` `mke 20004 2` `mke 20002 2` `mke 20003 2` )
+    del_dev gnv1
+
+    msg="vacate GENEVE in overflow table"
+    exp1=( `mke 20000 2` `mke 20004 2` 0 `mke 20003 2` )
+    del_dev gnv2
+
+    msg="table sharing - share"
+    exp1=( `mke 20000 2` `mke 20004 2` `mke 30001 4` `mke 20003 2` )
+    new_vxlan vxlanG0 30001 $NSIM_NETDEV 4 "gpe external"
+
+    msg="table sharing - overflow"
+    new_vxlan vxlanG1 30002 $NSIM_NETDEV 4 "gpe external"
+    msg="table sharing - overflow v6"
+    new_vxlan vxlanG2 30002 $NSIM_NETDEV 6 "gpe external"
+
+    exp1=( `mke 20000 2` `mke 30002 4` `mke 30001 4` `mke 20003 2` )
+    del_dev gnv4
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# Sync all
+pfx="sync all"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+echo 1 > $NSIM_DEV_DFS/udp_ports_sync_all
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    overflow_table0 "overflow NIC table"
+    overflow_table1 "overflow NIC table"
+
+    msg="replace VxLAN in overflow table"
+    exp0=( `mke 10000 1` `mke 10004 1` `mke 10002 1` `mke 10003 1` )
+    del_dev vxlan1
+
+    msg="vacate VxLAN in overflow table"
+    exp0=( `mke 10000 1` `mke 10004 1` 0 `mke 10003 1` )
+    del_dev vxlan2
+
+    msg="replace GENEVE in overflow table"
+    exp1=( `mke 20000 2` `mke 20004 2` `mke 20002 2` `mke 20003 2` )
+    del_dev gnv1
+
+    msg="vacate GENEVE in overflow table"
+    exp1=( `mke 20000 2` `mke 20004 2` 0 `mke 20003 2` )
+    del_dev gnv2
+
+    msg="table sharing - share"
+    exp1=( `mke 20000 2` `mke 20004 2` `mke 30001 4` `mke 20003 2` )
+    new_vxlan vxlanG0 30001 $NSIM_NETDEV 4 "gpe external"
+
+    msg="table sharing - overflow"
+    new_vxlan vxlanG1 30002 $NSIM_NETDEV 4 "gpe external"
+    msg="table sharing - overflow v6"
+    new_vxlan vxlanG2 30002 $NSIM_NETDEV 6 "gpe external"
+
+    exp1=( `mke 20000 2` `mke 30002 4` `mke 30001 4` `mke 20003 2` )
+    del_dev gnv4
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# Destroy full NIC
+pfx="destroy full"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    overflow_table0 "destroy NIC"
+    overflow_table1 "destroy NIC"
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# IPv4 only
+pfx="IPv4 only"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+echo 1 > $NSIM_DEV_DFS/udp_ports_ipv4_only
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    msg="create VxLANs v6"
+    new_vxlan vxlanA0 10000 $NSIM_NETDEV 6
+
+    msg="create VxLANs v6"
+    new_vxlan vxlanA1 10000 $NSIM_NETDEV 6
+
+    ip link set dev vxlanA0 down
+    ip link set dev vxlanA0 up
+    check_tables
+
+    msg="create VxLANs v4"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    msg="down VxLANs v4"
+    exp0=( 0 0 0 0 )
+    ip link set dev vxlan0 down
+    check_tables
+
+    msg="up VxLANs v4"
+    exp0=( `mke 10000 1` 0 0 0 )
+    ip link set dev vxlan0 up
+    check_tables
+
+    msg="destroy VxLANs v4"
+    exp0=( 0 0 0 0 )
+    del_dev vxlan0
+
+    msg="recreate VxLANs v4"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    del_dev vxlanA0
+    del_dev vxlanA1
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# Failures
+pfx="error injection"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    echo 110 > $NSIM_DEV_DFS/ports/$port/udp_ports_inject_error
+
+    msg="1 - create VxLANs v6"
+    exp0=( 0 0 0 0 )
+    new_vxlan vxlanA0 10000 $NSIM_NETDEV 6
+
+    msg="1 - create VxLANs v4"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    msg="1 - remove VxLANs v4"
+    del_dev vxlan0
+
+    msg="1 - remove VxLANs v6"
+    exp0=( 0 0 0 0 )
+    del_dev vxlanA0
+
+    msg="2 - create GENEVE"
+    exp1=( `mke 20000 2` 0 0 0 )
+    new_geneve gnv0 20000
+
+    msg="2 - destroy GENEVE"
+    echo 2 > $NSIM_DEV_DFS/ports/$port/udp_ports_inject_error
+    exp1=( `mke 20000 2` 0 0 0 )
+    del_dev gnv0
+
+    msg="2 - create second GENEVE"
+    exp1=( 0 `mke 20001 2` 0 0 )
+    new_geneve gnv0 20001
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# netdev flags
+pfx="netdev flags"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    msg="create VxLANs v6"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlanA0 10000 $NSIM_NETDEV 6
+
+    msg="create VxLANs v4"
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    msg="turn off"
+    exp0=( 0 0 0 0 )
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload off
+    check_tables
+
+    msg="turn on"
+    exp0=( `mke 10000 1` 0 0 0 )
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload on
+    check_tables
+
+    msg="remove both"
+    del_dev vxlanA0
+    exp0=( 0 0 0 0 )
+    del_dev vxlan0
+    check_tables
+
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload off
+
+    msg="create VxLANs v4 - off"
+    exp0=( 0 0 0 0 )
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    msg="created off - turn on"
+    exp0=( `mke 10000 1` 0 0 0 )
+    ethtool -K $NSIM_NETDEV rx-udp_tunnel-port-offload on
+    check_tables
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+cleanup_nsim
+
+# device initiated reset
+pfx="reset notification"
+
+echo $NSIM_ID > /sys/bus/netdevsim/new_device
+echo 0 > $NSIM_DEV_SYS/del_port
+
+for port in 0 1; do
+    if [ $port -ne 0 ]; then
+	echo 1 > $NSIM_DEV_DFS/udp_ports_open_only
+	echo 1 > $NSIM_DEV_DFS/udp_ports_sleep
+    fi
+
+    echo $port > $NSIM_DEV_SYS/new_port
+    ifconfig $NSIM_NETDEV up
+
+    msg="create VxLANs v6"
+    exp0=( `mke 10000 1` 0 0 0 )
+    new_vxlan vxlanA0 10000 $NSIM_NETDEV 6
+
+    msg="create VxLANs v4"
+    new_vxlan vxlan0 10000 $NSIM_NETDEV
+
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    check_tables
+
+    msg="NIC device goes down"
+    ifconfig $NSIM_NETDEV down
+    if [ $port -eq 1 ]; then
+	exp0=( 0 0 0 0 )
+	exp1=( 0 0 0 0 )
+    fi
+    check_tables
+
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    check_tables
+
+    msg="NIC device goes up again"
+    ifconfig $NSIM_NETDEV up
+    exp0=( `mke 10000 1` 0 0 0 )
+    check_tables
+
+    msg="remove both"
+    del_dev vxlanA0
+    exp0=( 0 0 0 0 )
+    del_dev vxlan0
+    check_tables
+
+    echo 1 > $NSIM_DEV_DFS/ports/$port/udp_ports_reset
+    check_tables
+
+    msg="destroy NIC"
+    echo $port > $NSIM_DEV_SYS/del_port
+
+    cleanup_tuns
+    exp0=( 0 0 0 0 )
+    exp1=( 0 0 0 0 )
+done
+
+modprobe -r netdevsim
+
+if [ $num_errors -eq 0 ]; then
+    echo "PASSED all $num_cases checks"
+else
+    echo "FAILED $num_errors/$num_cases checks"
+fi
+
+exit $EXIT_STATUS
-- 
2.26.2

