Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C13336C8CD
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbhD0PkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:40:10 -0400
Received: from mx0.infotecs.ru ([91.244.183.115]:36670 "EHLO mx0.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhD0PkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:40:09 -0400
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id D930A108A044;
        Tue, 27 Apr 2021 18:39:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru D930A108A044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1619537964; bh=Pl/TUTcLqKlASpFXDEN2HVzQh9aaPrigjWUeJxg4nMY=;
        h=Date:From:To:CC:Subject:From;
        b=HLVzyms0vQNFrVSnOInPh+B+dcLnqIiOeGYNi3obqUqa4ab6b3Gywp35/OO32BeRB
         HUwqiMu1zXJRvrIqDa/1gMvOxzy+lpj0KM0fAlEfTT5fiVwc/JTX2ASKWXkyf8ID+3
         CW3duCDusftm6xyPBjsJn7xabxeHrrer/JbqutHo=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id D7263316F917;
        Tue, 27 Apr 2021 18:39:23 +0300 (MSK)
Date:   Tue, 27 Apr 2021 18:37:29 +0300
From:   Balaev Pavel <balaevpa@infotecs.ru>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v5 net-next 3/3] selftests/net/forwarding: configurable seed
 tests
Message-ID: <YIgvub8Em26Kt3Mk@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [11.0.8.107]
X-EXCLAIMER-MD-CONFIG: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 163354 [Apr 27 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: BalaevPA@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0, {Tracking_from_domain_doesnt_match_to}
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/04/27 12:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/27 11:47:00 #16580367
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test equal and different seed values for IPv4/IPv6
multipath routing.

Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
---
 .../testing/selftests/net/forwarding/Makefile |   1 +
 tools/testing/selftests/net/forwarding/lib.sh |  28 ++
 .../net/forwarding/router_mpath_seed.sh       | 347 ++++++++++++++++++
 3 files changed, 376 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_seed.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index d97bd6889..080af970c 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -38,6 +38,7 @@ TEST_PROGS = bridge_igmp.sh \
 	router_mpath_nh.sh \
 	router_multicast.sh \
 	router_multipath.sh \
+	router_mpath_seed.sh \
 	router.sh \
 	router_vid_1.sh \
 	sch_ets.sh \
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 42e28c983..b7445b1c5 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -10,6 +10,7 @@ PING6=${PING6:=ping6}
 MZ=${MZ:=mausezahn}
 ARPING=${ARPING:=arping}
 TEAMD=${TEAMD:=teamd}
+OPENSSL=${OPENSSL:=openssl}
 WAIT_TIME=${WAIT_TIME:=5}
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 PAUSE_ON_CLEANUP=${PAUSE_ON_CLEANUP:=no}
@@ -698,6 +699,33 @@ link_stats_rx_errors_get()
 	link_stats_get $1 rx errors
 }
 
+ns_link_stats_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+	local dir=$1; shift
+	local stat=$1; shift
+
+	ip netns exec $netns ip -j -s link show dev $if_name \
+		| jq '.[]["stats64"]["'$dir'"]["'$stat'"]'
+}
+
+ns_link_stats_tx_packets_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+
+	ns_link_stats_get $netns $if_name tx packets
+}
+
+ns_link_stats_rx_errors_get()
+{
+	local netns=$1; shift
+	local if_name=$1; shift
+
+	ns_link_stats_get $netns $if_name rx errors
+}
+
 tc_rule_stats_get()
 {
 	local dev=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/router_mpath_seed.sh b/tools/testing/selftests/net/forwarding/router_mpath_seed.sh
new file mode 100755
index 000000000..b2f99f428
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_mpath_seed.sh
@@ -0,0 +1,347 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="multipath_seed_test"
+NUM_NETIFS=8
+source lib.sh
+
+veth_prepare()
+{
+	ip link add ecmp1l type veth peer name ecmp1r
+	ip link add ecmp2l type veth peer name ecmp2r
+	ip link add ecmphost1l type veth peer name ecmphost1r
+	ip link add ecmphost2l type veth peer name ecmphost2r
+}
+
+cl1_create()
+{
+	local ns_exec="ip netns exec ecmp_cl1"
+
+	ip netns add ecmp_cl1
+	ip l set dev ecmphost1l netns ecmp_cl1
+	$ns_exec ip l set dev ecmphost1l up
+	$ns_exec ip a a 10.100.0.2/30 dev ecmphost1l
+	$ns_exec ip a a 2001:db8:3::2/64 dev ecmphost1l
+	$ns_exec ip r add default via 10.100.0.1
+	$ns_exec ip r add default via 2001:db8:3::1
+}
+
+cl2_create()
+{
+	local ns_exec="ip netns exec ecmp_cl2"
+
+	ip netns add ecmp_cl2
+	ip l set dev ecmphost2l netns ecmp_cl2
+	$ns_exec ip l set dev ecmphost2l up
+	$ns_exec ip a a 10.200.0.2/30 dev ecmphost2l
+	$ns_exec ip a a 2001:db8:4::2/64 dev ecmphost2l
+	$ns_exec ip r add default via 10.200.0.1
+	$ns_exec ip r add default via 2001:db8:4::1
+}
+
+r1_create()
+{
+	local ns_exec="ip netns exec ecmp1"
+
+	ip netns add ecmp1
+	ip l set dev ecmp1l netns ecmp1
+	ip l set dev ecmp2l netns ecmp1
+	ip l set dev ecmphost1r netns ecmp1
+	$ns_exec ip l set dev ecmphost1r up
+	$ns_exec ip l set dev ecmp1l up
+	$ns_exec ip l set dev ecmp2l up
+	$ns_exec ip a a 10.100.0.1/30 dev ecmphost1r
+	$ns_exec ip a a 10.10.0.1/30 dev ecmp1l
+	$ns_exec ip a a 10.20.0.1/30 dev ecmp2l
+	$ns_exec ip a a 2001:db8:3::1/64 dev ecmphost1r
+	$ns_exec ip a a 2001:db8:1::1/64 dev ecmp1l
+	$ns_exec ip a a 2001:db8:2::1/64 dev ecmp2l
+	$ns_exec sysctl -q net.ipv4.ip_forward=1
+	$ns_exec sysctl -q net.ipv6.conf.all.forwarding=1
+	$ns_exec sysctl -q net.ipv4.fib_multipath_hash_policy=1
+	$ns_exec sysctl -q net.ipv6.fib_multipath_hash_policy=1
+	$ns_exec ip route add 10.200.0.0/30 nexthop via 10.10.0.2 \
+		  weight 1 nexthop via 10.20.0.2 weight 1
+	$ns_exec ip route add 2001:db8:4::/64 nexthop via 2001:db8:1::2 \
+		  weight 1 nexthop via 2001:db8:2::2 weight 1
+}
+
+r2_create()
+{
+	local ns_exec="ip netns exec ecmp2"
+
+	ip netns add ecmp2
+	ip l set dev ecmp1r netns ecmp2
+	ip l set dev ecmp2r netns ecmp2
+	ip l set dev ecmphost2r netns ecmp2
+	$ns_exec ip l set dev ecmphost2r up
+	$ns_exec ip l set dev ecmp1r up
+	$ns_exec ip l set dev ecmp2r up
+	$ns_exec ip a a 10.200.0.1/30 dev ecmphost2r
+	$ns_exec ip a a 10.10.0.2/30 dev ecmp1r
+	$ns_exec ip a a 10.20.0.2/30 dev ecmp2r
+	$ns_exec ip a a 2001:db8:4::1/64 dev ecmphost2r
+	$ns_exec ip a a 2001:db8:1::2/64 dev ecmp1r
+	$ns_exec ip a a 2001:db8:2::2/64 dev ecmp2r
+	$ns_exec sysctl -q net.ipv4.ip_forward=1
+	$ns_exec sysctl -q net.ipv6.conf.all.forwarding=1
+	$ns_exec sysctl -q net.ipv4.fib_multipath_hash_policy=1
+	$ns_exec sysctl -q net.ipv6.fib_multipath_hash_policy=1
+	$ns_exec ip route add 10.100.0.0/30 nexthop via 10.10.0.1 \
+		  weight 1 nexthop via 10.20.0.1 weight 1
+	$ns_exec ip route add 2001:db8:3::/64 nexthop via 2001:db8:1::1 \
+		  weight 1 nexthop via 2001:db8:2::1 weight 1
+}
+
+cl1_destroy()
+{
+	ip netns del ecmp_cl1
+}
+
+cl2_destroy()
+{
+	ip netns del ecmp_cl2
+}
+
+r1_destroy()
+{
+	ip netns del ecmp1
+}
+
+r2_destroy()
+{
+	ip netns del ecmp2
+}
+
+gen_udp4()
+{
+	local sp=$1; shift
+	local dp=$1; shift
+	local tx1_1_start tx1_2_start tx2_1_start tx2_2_start
+	local tx1_1_end tx1_2_end tx2_1_end tx2_2_end
+	local tx1_1 tx1_2 tx2_1 tx2_2
+	local tx1_1_res tx1_2_res tx2_1_res tx2_2_res
+	local chan1 chan2
+	local cl1_exec="ip netns exec ecmp_cl1"
+	local cl2_exec="ip netns exec ecmp_cl2"
+
+	tx1_1_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	$cl1_exec $MZ ecmphost1l -q -c 20 -p 64 -A 10.100.0.2 -B 10.200.0.2 \
+		-t udp "sp=${sp},dp=${dp}"
+
+	$cl2_exec $MZ ecmphost2l -q -c 20 -p 64 -A 10.200.0.2 -B 10.100.0.2 \
+		-t udp "sp=${dp},dp=${sp}"
+
+	tx1_1_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	let "tx1_1 = $tx1_1_end - $tx1_1_start"
+	let "tx1_2 = $tx1_2_end - $tx1_2_start"
+	let "tx2_1 = $tx2_1_end - $tx2_1_start"
+	let "tx2_2 = $tx2_2_end - $tx2_2_start"
+
+	[ "$tx1_1" -ge 20 ] && tx1_1_res=1 || tx1_1_res=0
+	[ "$tx1_2" -ge 20 ] && tx1_2_res=1 || tx1_2_res=0
+	[ "$tx2_1" -ge 20 ] && tx2_1_res=1 || tx2_1_res=0
+	[ "$tx2_2" -ge 20 ] && tx2_2_res=1 || tx2_2_res=0
+
+	let "chan1 = $tx1_1_res + $tx2_1_res"
+	let "chan2 = $tx1_2_res + $tx2_2_res"
+
+	if [ $chan1 -eq 2 ] || [ $chan2 -eq 2 ]; then
+		return 0
+	fi
+
+	return 1;
+}
+
+gen_udp6()
+{
+	local sp=$1; shift
+	local dp=$1; shift
+	local tx1_1_start tx1_2_start tx2_1_start tx2_2_start
+	local tx1_1_end tx1_2_end tx2_1_end tx2_2_end
+	local tx1_1 tx1_2 tx2_1 tx2_2
+	local tx1_1_res tx1_2_res tx2_1_res tx2_2_res
+	local chan1 chan2
+	local cl1_exec="ip netns exec ecmp_cl1"
+	local cl2_exec="ip netns exec ecmp_cl2"
+
+	tx1_1_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_start=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_start=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	$cl1_exec $MZ ecmphost1l -6 -q -c 20 -p 64 -A 2001:db8:3::2 -B 2001:db8:4::2 \
+		-t udp "sp=${sp},dp=${dp}"
+
+	$cl2_exec $MZ ecmphost2l -6 -q -c 20 -p 64 -A 2001:db8:4::2 -B 2001:db8:3::2 \
+		-t udp "sp=${dp},dp=${sp}"
+
+	tx1_1_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp1l)
+	tx1_2_end=$(ns_link_stats_tx_packets_get ecmp1 ecmp2l)
+	tx2_1_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp1r)
+	tx2_2_end=$(ns_link_stats_tx_packets_get ecmp2 ecmp2r)
+
+	let "tx1_1 = $tx1_1_end - $tx1_1_start"
+	let "tx1_2 = $tx1_2_end - $tx1_2_start"
+	let "tx2_1 = $tx2_1_end - $tx2_1_start"
+	let "tx2_2 = $tx2_2_end - $tx2_2_start"
+
+	[ "$tx1_1" -ge 20 ] && tx1_1_res=1 || tx1_1_res=0
+	[ "$tx1_2" -ge 20 ] && tx1_2_res=1 || tx1_2_res=0
+	[ "$tx2_1" -ge 20 ] && tx2_1_res=1 || tx2_1_res=0
+	[ "$tx2_2" -ge 20 ] && tx2_2_res=1 || tx2_2_res=0
+
+	let "chan1 = $tx1_1_res + $tx2_1_res"
+	let "chan2 = $tx1_2_res + $tx2_2_res"
+
+	if [ $chan1 -eq 2 ] || [ $chan2 -eq 2 ]; then
+		return 0
+	fi
+
+	return 1;
+}
+
+
+seed4_test_equal()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed=$(${OPENSSL} rand -hex 16)
+
+	seed=${seed:0:16},${seed:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res != 30 ] && RET=1
+	log_test "IPv4 multipath seed tests [equal seed]"
+}
+
+seed4_test_diff()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed1=$(${OPENSSL} rand -hex 16)
+	local seed2=$(${OPENSSL} rand -hex 16)
+
+	seed1=${seed1:0:16},${seed1:16:16}
+	seed2=${seed2:0:16},${seed2:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed1}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv4.fib_multipath_hash_seed=${seed2}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res -eq 30 ] && RET=1
+	log_test "IPv4 multipath seed tests [different seed]"
+}
+
+seed6_test_equal()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed=$(${OPENSSL} rand -hex 16)
+
+	seed=${seed:0:16},${seed:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp6 $sp $dp && let res++
+	done
+
+	[ $res != 30 ] && RET=1
+	log_test "IPv6 multipath seed tests [equal seed]"
+}
+
+seed6_test_diff()
+{
+	RET=0
+	local sp
+	local dp
+	local i
+	local res=0
+	local seed1=$(${OPENSSL} rand -hex 16)
+	local seed2=$(${OPENSSL} rand -hex 16)
+
+	seed1=${seed1:0:16},${seed1:16:16}
+	seed2=${seed2:0:16},${seed2:16:16}
+
+	ip netns exec ecmp1 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed1}
+	ip netns exec ecmp2 sysctl -q \
+		net.ipv6.fib_multipath_hash_seed=${seed2}
+
+	for i in {1..30}; do
+		sp=$(shuf -i 1024-65000 -n 1)
+		dp=$(shuf -i 1024-65000 -n 1)
+		gen_udp4 $sp $dp && let res++
+	done
+
+	[ $res -eq 30 ] && RET=1
+	log_test "IPv6 multipath seed tests [different seed]"
+}
+
+multipath_seed_test()
+{
+	require_command $OPENSSL
+	veth_prepare
+	cl1_create
+	cl2_create
+	r1_create
+	r2_create
+
+	log_info "Running IPv4 multipath seed tests [equal seed]"
+	seed4_test_equal
+	log_info "Running IPv4 multipath seed tests [different seed]"
+	seed4_test_diff
+	log_info "Running IPv6 multipath seed tests [equal seed]"
+	seed6_test_equal
+	log_info "Running IPv6 multipath seed tests [different seed]"
+	seed6_test_diff
+
+	cl1_destroy
+	cl2_destroy
+	r1_destroy
+	r2_destroy
+}
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

