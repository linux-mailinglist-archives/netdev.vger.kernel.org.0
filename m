Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9232E169F60
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgBXHgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38941 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbgBXHgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:19 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so8194710wme.4
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yxzG9DjjECpsqgZJez+Ra+WN1J+Noam+z45g5iSOceE=;
        b=IiMez2bZQ1YhlFJygRB/4cMY1dPqgMEibqoYqOjB2pfZ0B8xJuWgRYBo3V17OMI/E7
         7ZGbL6tFSJa9HCKhAzzX37YFbvpKexQv96VmiD2ywl58+au54MYWyLbAjT+GRb1tvHcu
         2POqyYuDJ0S7RHP9dceaWDpXXimoQSOajJoDt8+AGeLmsGdo692N1hMbqqnThpIIIQ0k
         XVTrNEzxoU0ola30ny4tDGWSKztrpMPUBzL9/dN1SgsYXMFhAkegChkTtmLhNkJOs9Fn
         BStfJ4Dr4pImA/fA5xcY7uKo94itBH72X9j6h1RntEekhkaqc9Q6dRGwXpLtzz7dXiRg
         0Wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yxzG9DjjECpsqgZJez+Ra+WN1J+Noam+z45g5iSOceE=;
        b=V3hOvDs1iDC3KuGnOicKL98TNB+SR0csXm68nZUrd11/DxsS7Kwb3gT2kw9Qemlq6a
         2kb4GXUhZQdqi19mVdIyXWo2SSOXZyVmGB8/RQZTUi+7/HLMQ9eD1tDBfhanQb/HJ0Sh
         wmeb8Dav4U/f5ef++gWzAlrdx6dSvJTFw5I3JK++5NcmIvZWnPpCLi1QLyzLUXjySXc9
         bRgKGg/VGIf39SjotUBy387jj7c/gbeF0iYhbYS6IyYCnYRM78o4aytiuO1+V4CApCj5
         VGyrcvz4VchJKP7sWnthHeWVAHC9mkjag93pmF1LIh+9ijOS+UGKzsSn0OrtCUYOGCHq
         TKaA==
X-Gm-Message-State: APjAAAV3iCMEvA3T4kKgPnFeZDyxk2rAJxPuI42eF6SosKPdFdBrIJKB
        2cYv638BDwCWMJGsWL1BISYuZgQZ/WE=
X-Google-Smtp-Source: APXvYqw0Kjgc5oZSN+akE8+EY7BKDrRtWODjaBdd0RRhxIsdmwJCVmuL3nAEXJR4tZAMYfG1HUlAaA==
X-Received: by 2002:a1c:988c:: with SMTP id a134mr19677159wme.163.1582529777214;
        Sun, 23 Feb 2020 23:36:17 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c6sm924411wrx.39.2020.02.23.23.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:16 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 15/16] selftests: pass pref and handle to devlink_trap_drop_* helpers
Date:   Mon, 24 Feb 2020 08:35:57 +0100
Message-Id: <20200224073558.26500-16-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the helpers assume pref 1 and handle 101. Make that explicit
and pass the values from callers.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 28 ++++++------
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 44 +++++++++----------
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    |  4 +-
 .../selftests/net/forwarding/devlink_lib.sh   |  7 ++-
 4 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index 58cdbfb608e9..e7aecb065409 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -107,11 +107,11 @@ source_mac_is_multicast_test()
 
 	RET=0
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	log_test "Source MAC is multicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 }
 
 __vlan_tag_mismatch_test()
@@ -132,7 +132,7 @@ __vlan_tag_mismatch_test()
 	$MZ $h1 "$opt" -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Add PVID and make sure packets are no longer dropped.
 	bridge vlan add vid 1 dev $swp1 pvid untagged master
@@ -148,7 +148,7 @@ __vlan_tag_mismatch_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 }
 
 vlan_tag_mismatch_untagged_test()
@@ -193,7 +193,7 @@ ingress_vlan_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Add the VLAN on the bridge port and make sure packets are no longer
 	# dropped.
@@ -212,7 +212,7 @@ ingress_vlan_filter_test()
 
 	log_test "Ingress VLAN filter"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -237,7 +237,7 @@ __ingress_stp_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Change STP state to forwarding and make sure packets are no longer
 	# dropped.
@@ -254,7 +254,7 @@ __ingress_stp_filter_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -308,7 +308,7 @@ port_list_is_empty_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -326,7 +326,7 @@ port_list_is_empty_uc_test()
 
 	log_test "Port list is empty - unicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 
 	ip link set dev $swp1 type bridge_slave flood on
 }
@@ -354,7 +354,7 @@ port_list_is_empty_mc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave mcast_flood on
@@ -372,7 +372,7 @@ port_list_is_empty_mc_test()
 
 	log_test "Port list is empty - multicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 
 	ip link set dev $swp1 type bridge_slave mcast_flood on
 }
@@ -401,7 +401,7 @@ port_loopback_filter_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2
+	devlink_trap_drop_test $trap_name $group_name $swp2 101
 
 	# Allow packets to be flooded.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -419,7 +419,7 @@ port_loopback_filter_uc_test()
 
 	log_test "Port loopback filter - unicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2 ip
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip 1 101
 }
 
 port_loopback_filter_test()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index d88d8e47d11b..053e5c7b303d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -176,11 +176,11 @@ non_ip_test()
 		00:00 de:ad:be:ef" &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "Non IP"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ip"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ip" 1 101
 }
 
 __uc_dip_over_mc_dmac_test()
@@ -206,11 +206,11 @@ __uc_dip_over_mc_dmac_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "Unicast destination IP over multicast destination MAC: $desc"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 $proto
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
 }
 
 uc_dip_over_mc_dmac_test()
@@ -242,11 +242,11 @@ __sip_is_loopback_test()
 		-b $rp1mac -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "Source IP is loopback address: $desc"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 $proto
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
 }
 
 sip_is_loopback_test()
@@ -277,11 +277,11 @@ __dip_is_loopback_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "Destination IP is loopback address: $desc"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 $proto
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
 }
 
 dip_is_loopback_test()
@@ -313,11 +313,11 @@ __sip_is_mc_test()
 		-b $rp1mac -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "Source IP is multicast: $desc"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 $proto
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
 }
 
 sip_is_mc_test()
@@ -345,11 +345,11 @@ ipv4_sip_is_limited_bc_test()
 		-B $h2_ipv4 -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "IPv4 source IP is limited broadcast"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ip"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ip" 1 101
 }
 
 ipv4_payload_get()
@@ -399,11 +399,11 @@ __ipv4_header_corrupted_test()
 	$MZ $h1 -c 0 -d 1msec -a $h1mac -b $rp1mac -q p=$payload &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "IP header corrupted: $desc: IPv4"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ip"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ip" 1 101
 }
 
 ipv6_payload_get()
@@ -446,11 +446,11 @@ __ipv6_header_corrupted_test()
 	$MZ $h1 -c 0 -d 1msec -a $h1mac -b $rp1mac -q p=$payload &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "IP header corrupted: $desc: IPv6"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ip"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ip" 1 101
 }
 
 ip_header_corrupted_test()
@@ -485,11 +485,11 @@ ipv6_mc_dip_reserved_scope_test()
 		"33:33:00:00:00:00" -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "IPv6 multicast destination IP reserved scope"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ipv6"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ipv6" 1 101
 }
 
 ipv6_mc_dip_interface_local_scope_test()
@@ -511,11 +511,11 @@ ipv6_mc_dip_interface_local_scope_test()
 		"33:33:00:00:00:00" -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 
 	log_test "IPv6 multicast destination IP interface-local scope"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 "ipv6"
+	devlink_trap_drop_cleanup $mz_pid $rp2 "ipv6" 1 101
 }
 
 __blackhole_route_test()
@@ -542,10 +542,10 @@ __blackhole_route_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2
+	devlink_trap_drop_test $trap_name $group_name $rp2 101
 	log_test "Blackhole route: IPv$flags"
 
-	devlink_trap_drop_cleanup $mz_pid $rp2 $proto
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
 	ip -$flags route del blackhole $subnet
 }
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
index fd19161dd4ec..e11a416323cf 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
@@ -314,11 +314,11 @@ overlay_smac_is_mc_test()
 		-B 192.0.2.17 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp1
+	devlink_trap_drop_test $trap_name $group_name $swp1 101
 
 	log_test "Overlay source MAC is multicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp1 "ip"
+	devlink_trap_drop_cleanup $mz_pid $swp1 "ip" 1 101
 }
 
 trap cleanup EXIT
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 40b076983239..24798ae846de 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -373,6 +373,7 @@ devlink_trap_drop_test()
 	local trap_name=$1; shift
 	local group_name=$1; shift
 	local dev=$1; shift
+	local handle=$1; shift
 
 	# This is the common part of all the tests. It checks that stats are
 	# initially idle, then non-idle after changing the trap action and
@@ -397,7 +398,7 @@ devlink_trap_drop_test()
 	devlink_trap_group_stats_idle_test $group_name
 	check_err $? "Trap group stats not idle after setting action to drop"
 
-	tc_check_packets "dev $dev egress" 101 0
+	tc_check_packets "dev $dev egress" $handle 0
 	check_err $? "Packets were not dropped"
 }
 
@@ -406,7 +407,9 @@ devlink_trap_drop_cleanup()
 	local mz_pid=$1; shift
 	local dev=$1; shift
 	local proto=$1; shift
+	local pref=$1; shift
+	local handle=$1; shift
 
 	kill $mz_pid && wait $mz_pid &> /dev/null
-	tc filter del dev $dev egress protocol $proto pref 1 handle 101 flower
+	tc filter del dev $dev egress protocol $proto pref $pref handle $handle flower
 }
-- 
2.21.1

