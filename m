Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8D3A24D
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfFHWW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfFHWWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565472186A;
        Sat,  8 Jun 2019 21:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030829;
        bh=OrYyeWuD4KiQCCkkORqJqpNesxA4H9qBEy6LFlYpoCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COlGBdP9OTxRxMn/3jl6WUfV/c85K/G4ee2MarMTF1lifX5KE4GWIiZS43r1ZOsy3
         Ujk9kepBelTFV8KStIjYPB2vivPF/jD2onXbFiEUW0/QszS/4OOndwd39wsNs7OD2c
         8usPYCc+IstgV3ge/cy+a0cBTK4T591tBU19nGuw=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 20/20] selftests: Add version of router_multipath.sh using nexthop objects
Date:   Sat,  8 Jun 2019 14:53:41 -0700
Message-Id: <20190608215341.26592-21-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a version of router_multipath.sh that uses nexthop objects for
routes.

Ido requested a version that does not cause regressions with mlxsw
testing since it does not support nexthop objects yet.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 .../selftests/net/forwarding/router_mpath_nh.sh    | 359 +++++++++++++++++++++
 1 file changed, 359 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh.sh

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
new file mode 100755
index 000000000000..cf3d26c233e8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -0,0 +1,359 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="ping_ipv4 ping_ipv6 multipath_test"
+NUM_NETIFS=8
+source lib.sh
+
+h1_create()
+{
+	vrf_create "vrf-h1"
+	ip link set dev $h1 master vrf-h1
+
+	ip link set dev vrf-h1 up
+	ip link set dev $h1 up
+
+	ip address add 192.0.2.2/24 dev $h1
+	ip address add 2001:db8:1::2/64 dev $h1
+
+	ip route add 198.51.100.0/24 vrf vrf-h1 nexthop via 192.0.2.1
+	ip route add 2001:db8:2::/64 vrf vrf-h1 nexthop via 2001:db8:1::1
+}
+
+h1_destroy()
+{
+	ip route del 2001:db8:2::/64 vrf vrf-h1
+	ip route del 198.51.100.0/24 vrf vrf-h1
+
+	ip address del 2001:db8:1::2/64 dev $h1
+	ip address del 192.0.2.2/24 dev $h1
+
+	ip link set dev $h1 down
+	vrf_destroy "vrf-h1"
+}
+
+h2_create()
+{
+	vrf_create "vrf-h2"
+	ip link set dev $h2 master vrf-h2
+
+	ip link set dev vrf-h2 up
+	ip link set dev $h2 up
+
+	ip address add 198.51.100.2/24 dev $h2
+	ip address add 2001:db8:2::2/64 dev $h2
+
+	ip route add 192.0.2.0/24 vrf vrf-h2 nexthop via 198.51.100.1
+	ip route add 2001:db8:1::/64 vrf vrf-h2 nexthop via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip route del 2001:db8:1::/64 vrf vrf-h2
+	ip route del 192.0.2.0/24 vrf vrf-h2
+
+	ip address del 2001:db8:2::2/64 dev $h2
+	ip address del 198.51.100.2/24 dev $h2
+
+	ip link set dev $h2 down
+	vrf_destroy "vrf-h2"
+}
+
+router1_create()
+{
+	vrf_create "vrf-r1"
+	ip link set dev $rp11 master vrf-r1
+	ip link set dev $rp12 master vrf-r1
+	ip link set dev $rp13 master vrf-r1
+
+	ip link set dev vrf-r1 up
+	ip link set dev $rp11 up
+	ip link set dev $rp12 up
+	ip link set dev $rp13 up
+
+	ip address add 192.0.2.1/24 dev $rp11
+	ip address add 2001:db8:1::1/64 dev $rp11
+
+	ip address add 169.254.2.12/24 dev $rp12
+	ip address add fe80:2::12/64 dev $rp12
+
+	ip address add 169.254.3.13/24 dev $rp13
+	ip address add fe80:3::13/64 dev $rp13
+}
+
+router1_destroy()
+{
+	ip route del 2001:db8:2::/64 vrf vrf-r1
+	ip route del 198.51.100.0/24 vrf vrf-r1
+
+	ip address del fe80:3::13/64 dev $rp13
+	ip address del 169.254.3.13/24 dev $rp13
+
+	ip address del fe80:2::12/64 dev $rp12
+	ip address del 169.254.2.12/24 dev $rp12
+
+	ip address del 2001:db8:1::1/64 dev $rp11
+	ip address del 192.0.2.1/24 dev $rp11
+
+	ip nexthop del id 103
+	ip nexthop del id 101
+	ip nexthop del id 102
+	ip nexthop del id 106
+	ip nexthop del id 104
+	ip nexthop del id 105
+
+	ip link set dev $rp13 down
+	ip link set dev $rp12 down
+	ip link set dev $rp11 down
+
+	vrf_destroy "vrf-r1"
+}
+
+router2_create()
+{
+	vrf_create "vrf-r2"
+	ip link set dev $rp21 master vrf-r2
+	ip link set dev $rp22 master vrf-r2
+	ip link set dev $rp23 master vrf-r2
+
+	ip link set dev vrf-r2 up
+	ip link set dev $rp21 up
+	ip link set dev $rp22 up
+	ip link set dev $rp23 up
+
+	ip address add 198.51.100.1/24 dev $rp21
+	ip address add 2001:db8:2::1/64 dev $rp21
+
+	ip address add 169.254.2.22/24 dev $rp22
+	ip address add fe80:2::22/64 dev $rp22
+
+	ip address add 169.254.3.23/24 dev $rp23
+	ip address add fe80:3::23/64 dev $rp23
+}
+
+router2_destroy()
+{
+	ip route del 2001:db8:1::/64 vrf vrf-r2
+	ip route del 192.0.2.0/24 vrf vrf-r2
+
+	ip address del fe80:3::23/64 dev $rp23
+	ip address del 169.254.3.23/24 dev $rp23
+
+	ip address del fe80:2::22/64 dev $rp22
+	ip address del 169.254.2.22/24 dev $rp22
+
+	ip address del 2001:db8:2::1/64 dev $rp21
+	ip address del 198.51.100.1/24 dev $rp21
+
+	ip nexthop del id 201
+	ip nexthop del id 202
+	ip nexthop del id 204
+	ip nexthop del id 205
+
+	ip link set dev $rp23 down
+	ip link set dev $rp22 down
+	ip link set dev $rp21 down
+
+	vrf_destroy "vrf-r2"
+}
+
+routing_nh_obj()
+{
+	ip nexthop add id 101 via 169.254.2.22 dev $rp12
+	ip nexthop add id 102 via 169.254.3.23 dev $rp13
+	ip nexthop add id 103 group 101/102
+	ip route add 198.51.100.0/24 vrf vrf-r1 nhid 103
+
+	ip nexthop add id 104 via fe80:2::22 dev $rp12
+	ip nexthop add id 105 via fe80:3::23 dev $rp13
+	ip nexthop add id 106 group 104/105
+	ip route add 2001:db8:2::/64 vrf vrf-r1 nhid 106
+
+	ip nexthop add id 201 via 169.254.2.12 dev $rp22
+	ip nexthop add id 202 via 169.254.3.13 dev $rp23
+	ip nexthop add id 203 group 201/202
+	ip route add 192.0.2.0/24 vrf vrf-r2 nhid 203
+
+	ip nexthop add id 204 via fe80:2::12 dev $rp22
+	ip nexthop add id 205 via fe80:3::13 dev $rp23
+	ip nexthop add id 206 group 204/205
+	ip route add 2001:db8:1::/64 vrf vrf-r2 nhid 206
+}
+
+multipath4_test()
+{
+	local desc="$1"
+	local weight_rp12=$2
+	local weight_rp13=$3
+	local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+	local packets_rp12 packets_rp13
+
+	# Transmit multiple flows from h1 to h2 and make sure they are
+	# distributed between both multipath links (rp12 and rp13)
+	# according to the configured weights.
+	sysctl_set net.ipv4.fib_multipath_hash_policy 1
+	ip nexthop replace id 103 group 101,$weight_rp12/102,$weight_rp13
+
+	t0_rp12=$(link_stats_tx_packets_get $rp12)
+	t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+	ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	t1_rp12=$(link_stats_tx_packets_get $rp12)
+	t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+	let "packets_rp12 = $t1_rp12 - $t0_rp12"
+	let "packets_rp13 = $t1_rp13 - $t0_rp13"
+	multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+	# Restore settings.
+	ip nexthop replace id 103 group 101/102
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+multipath6_l4_test()
+{
+	local desc="$1"
+	local weight_rp12=$2
+	local weight_rp13=$3
+	local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+	local packets_rp12 packets_rp13
+
+	# Transmit multiple flows from h1 to h2 and make sure they are
+	# distributed between both multipath links (rp12 and rp13)
+	# according to the configured weights.
+	sysctl_set net.ipv6.fib_multipath_hash_policy 1
+
+	ip nexthop replace id 106 group 104,$weight_rp12/105,$weight_rp13
+
+	t0_rp12=$(link_stats_tx_packets_get $rp12)
+	t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+	$MZ $h1 -6 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	t1_rp12=$(link_stats_tx_packets_get $rp12)
+	t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+	let "packets_rp12 = $t1_rp12 - $t0_rp12"
+	let "packets_rp13 = $t1_rp13 - $t0_rp13"
+	multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+	ip nexthop replace id 106 group 104/105
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+multipath6_test()
+{
+	local desc="$1"
+	local weight_rp12=$2
+	local weight_rp13=$3
+	local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+	local packets_rp12 packets_rp13
+
+	ip nexthop replace id 106 group 104,$weight_rp12/105,$weight_rp13
+
+	t0_rp12=$(link_stats_tx_packets_get $rp12)
+	t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+	# Generate 16384 echo requests, each with a random flow label.
+	for _ in $(seq 1 16384); do
+		ip vrf exec vrf-h1 $PING6 2001:db8:2::2 -F 0 -c 1 -q >/dev/null 2>&1
+	done
+
+	t1_rp12=$(link_stats_tx_packets_get $rp12)
+	t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+	let "packets_rp12 = $t1_rp12 - $t0_rp12"
+	let "packets_rp13 = $t1_rp13 - $t0_rp13"
+	multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+	ip nexthop replace id 106 group 104/105
+}
+
+multipath_test()
+{
+	log_info "Running IPv4 multipath tests"
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+
+	log_info "Running IPv6 multipath tests"
+	multipath6_test "ECMP" 1 1
+	multipath6_test "Weighted MP 2:1" 2 1
+	multipath6_test "Weighted MP 11:45" 11 45
+
+	log_info "Running IPv6 L4 hash multipath tests"
+	multipath6_l4_test "ECMP" 1 1
+	multipath6_l4_test "Weighted MP 2:1" 2 1
+	multipath6_l4_test "Weighted MP 11:45" 11 45
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp11=${NETIFS[p2]}
+
+	rp12=${NETIFS[p3]}
+	rp22=${NETIFS[p4]}
+
+	rp13=${NETIFS[p5]}
+	rp23=${NETIFS[p6]}
+
+	rp21=${NETIFS[p7]}
+	h2=${NETIFS[p8]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	router1_create
+	router2_create
+	routing_nh_obj
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	router2_destroy
+	router1_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 198.51.100.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::2
+}
+
+ip nexthop ls >/dev/null 2>&1
+if [ $? -ne 0 ]; then
+	echo "Nexthop objects not supported; skipping tests"
+	exit 0
+fi
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+routing_nh_obj
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.11.0

