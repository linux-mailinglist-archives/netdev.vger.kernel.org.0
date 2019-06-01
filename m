Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCCD3194E
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfFADg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbfFADg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC631270E5;
        Sat,  1 Jun 2019 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360185;
        bh=nQdustvawyGEUDyBg5QZ8TagDkayd8SH3EbSFpbEg60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Psw47ThCg/vl7y08JaBNV1xAXLdQ3yaQ2mC4H4SiKgjP+hYCHuaEMfHqW9oxaix/0
         BNx8aYVBLfk6d6FDY7or2yxqiFhpwp+ZjUKaTp+bamG82snq5mtTm0sVtpWLgwFpyB
         VhoRlDojr0o8rlTfJ3qkaHJ15FmGEYNhk8pVD47Y=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 27/27] selftests: Add version of router_multipath.sh using nexthop objects
Date:   Fri, 31 May 2019 20:36:18 -0700
Message-Id: <20190601033618.27702-28-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a version of router_multipath.sh that uses nexthop objects for
routes. Ido requested a version that does not cause regressions with
their testing since mlxsw does not support nexthop objects yet.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 .../selftests/net/forwarding/router_mpath_nh.sh    | 370 +++++++++++++++++++++
 1 file changed, 370 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh.sh

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
new file mode 100755
index 000000000000..4bd356e574d9
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -0,0 +1,370 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="ping_ipv4 ping_ipv6 multipath_test"
+NUM_NETIFS=8
+
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
+	ip link set dev $rp23 down
+	ip link set dev $rp22 down
+	ip link set dev $rp21 down
+
+	vrf_destroy "vrf-r2"
+}
+
+routing_nh_obj()
+{
+	# h1
+	ip nexthop add id 14 via 192.0.2.1 dev $h1
+	ip route add 198.51.100.0/24 vrf vrf-h1 nhid 14
+
+	ip nexthop add id 16 via 2001:db8:1::1 dev $h1
+	ip route add 2001:db8:2::/64 vrf vrf-h1 nhid 16
+
+	# h2
+	ip nexthop add id 24 via 198.51.100.1 dev $h2
+	ip route add 192.0.2.0/24 vrf vrf-h2 nhid 24
+
+	ip nexthop add id 26 via 2001:db8:2::1 dev $h2
+	ip route add 2001:db8:1::/64 vrf vrf-h2 nhid 26
+
+	# router 1
+	ip nexthop add id 101 via 169.254.2.22 dev $rp12
+	ip nexthop add id 102 via 169.254.3.23 dev $rp13
+	ip nexthop add id 103 group 101/102
+	ip route add 198.51.100.0/24 vrf vrf-r1 nhid 103
+
+	ip nexthop add id 104 via fe80:2::22 dev $rp12
+	ip nexthop add id 105 via fe80:3::23 dev $rp13
+	ip nexthop add id 106 group 104/105
+	ip route add 2001:db8:2::/64 vrf vrf-r1 nhid 104
+
+	# router 2
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
+       local desc="$1"
+       local weight_rp12=$2
+       local weight_rp13=$3
+       local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+       local packets_rp12 packets_rp13
+
+       # Transmit multiple flows from h1 to h2 and make sure they are
+       # distributed between both multipath links (rp12 and rp13)
+       # according to the configured weights.
+       sysctl_set net.ipv4.fib_multipath_hash_policy 1
+       ip route replace 198.51.100.0/24 vrf vrf-r1 \
+               nexthop via 169.254.2.22 dev $rp12 weight $weight_rp12 \
+               nexthop via 169.254.3.23 dev $rp13 weight $weight_rp13
+
+       t0_rp12=$(link_stats_tx_packets_get $rp12)
+       t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+       ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+	       -d 1msec -t udp "sp=1024,dp=0-32768"
+
+       t1_rp12=$(link_stats_tx_packets_get $rp12)
+       t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+       let "packets_rp12 = $t1_rp12 - $t0_rp12"
+       let "packets_rp13 = $t1_rp13 - $t0_rp13"
+       multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+       # Restore settings.
+       ip route replace 198.51.100.0/24 vrf vrf-r1 \
+               nexthop via 169.254.2.22 dev $rp12 \
+               nexthop via 169.254.3.23 dev $rp13
+       sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+multipath6_l4_test()
+{
+       local desc="$1"
+       local weight_rp12=$2
+       local weight_rp13=$3
+       local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+       local packets_rp12 packets_rp13
+
+       # Transmit multiple flows from h1 to h2 and make sure they are
+       # distributed between both multipath links (rp12 and rp13)
+       # according to the configured weights.
+       sysctl_set net.ipv6.fib_multipath_hash_policy 1
+
+       ip route replace 2001:db8:2::/64 vrf vrf-r1 \
+	       nexthop via fe80:2::22 dev $rp12 weight $weight_rp12 \
+	       nexthop via fe80:3::23 dev $rp13 weight $weight_rp13
+
+       t0_rp12=$(link_stats_tx_packets_get $rp12)
+       t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+       $MZ $h1 -6 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	       -d 1msec -t udp "sp=1024,dp=0-32768"
+
+       t1_rp12=$(link_stats_tx_packets_get $rp12)
+       t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+       let "packets_rp12 = $t1_rp12 - $t0_rp12"
+       let "packets_rp13 = $t1_rp13 - $t0_rp13"
+       multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+       ip route replace 2001:db8:2::/64 vrf vrf-r1 \
+	       nexthop via fe80:2::22 dev $rp12 \
+	       nexthop via fe80:3::23 dev $rp13
+
+       sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+multipath6_test()
+{
+       local desc="$1"
+       local weight_rp12=$2
+       local weight_rp13=$3
+       local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+       local packets_rp12 packets_rp13
+
+       ip route replace 2001:db8:2::/64 vrf vrf-r1 \
+	       nexthop via fe80:2::22 dev $rp12 weight $weight_rp12 \
+	       nexthop via fe80:3::23 dev $rp13 weight $weight_rp13
+
+       t0_rp12=$(link_stats_tx_packets_get $rp12)
+       t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+       # Generate 16384 echo requests, each with a random flow label.
+       for _ in $(seq 1 16384); do
+	       ip vrf exec vrf-h1 $PING6 2001:db8:2::2 -F 0 -c 1 -q &> /dev/null
+       done
+
+       t1_rp12=$(link_stats_tx_packets_get $rp12)
+       t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+       let "packets_rp12 = $t1_rp12 - $t0_rp12"
+       let "packets_rp13 = $t1_rp13 - $t0_rp13"
+       multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+       ip route replace 2001:db8:2::/64 vrf vrf-r1 \
+	       nexthop via fe80:2::22 dev $rp12 \
+	       nexthop via fe80:3::23 dev $rp13
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
+
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
+if [ $? -eq 0 ]; then
+	trap cleanup EXIT
+
+	cleanup
+	setup_prepare
+	setup_wait
+
+	tests_run
+else
+	echo "Nexthop objects not supported; skipping tests"
+fi
+
+exit $EXIT_STATUS
-- 
2.11.0

