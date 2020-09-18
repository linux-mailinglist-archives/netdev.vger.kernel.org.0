Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4917B2703EA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgIRSZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:25:13 -0400
Received: from mail.efficios.com ([167.114.26.124]:59978 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:25:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7BE052722EB;
        Fri, 18 Sep 2020 14:18:12 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id h_HXxvXnVAXA; Fri, 18 Sep 2020 14:18:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BC9AF2725C7;
        Fri, 18 Sep 2020 14:18:11 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com BC9AF2725C7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600453091;
        bh=y+aC+JhQOFlD15KBj3nejJKSzsxsVtGLbUvCAx5zp1k=;
        h=From:To:Date:Message-Id;
        b=MlzvjXCwBFTPgEo8YvgcN0Zt6prR8pn67FKJQf3bLXd4nt8k7F3JRgdCeZxgynOcy
         fbvoMBAez9YyXx1/8Z8+pKcJoVjec1+QQO8ZqJPhnj4rJTBNTkkKReCj3q4jSKCdPS
         W9U/B9Ppbh3kPQ60yN2SdGa4zgfOALgmF4eJBEnSVBQYF9jI1elw8az9pCUxmzWq63
         k3zF2+IlhkmgxsLhDhbBvKxUJJ94fzjtgPGN8suFwC7rBBm9em65g61/ylxVZyL56S
         lKwcluZRivthFowWAeV04rLlhbhv7zz/xF2GITGkVVkOdhRV9gIOv0IQKwo6Za4fqG
         PzhhRqkAvmCAg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dBi8f60TKXzG; Fri, 18 Sep 2020 14:18:11 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id EF18D2726CF;
        Fri, 18 Sep 2020 14:18:08 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Subject: [RFC PATCH v2 3/3] selftests: Add VRF icmp error route lookup test
Date:   Fri, 18 Sep 2020 14:18:01 -0400
Message-Id: <20200918181801.2571-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Jeanson <mjeanson@efficios.com>

The objective is to check that the incoming vrf routing table is selected
to send an ICMP error back to the source. We test two scenarios: when the
ttl of a packet reaches 1 while it is forwarded between different vrfs
and when a packet is bigger than the mtu of the second interface is
forwarded between different vrfs.

The first ttl test sends a ping with a ttl of 1 from h1 to h2 and parses the
output of the command to check that a ttl expired error is received.

The second ttl test runs traceroute from h1 to h2 and parses the output to
check for a hop on r1.

The mtu test sends a ping with a payload of 1450 from h1 to h2, through
r1 which has an interface with a mtu of 1400 and parses the output of the
command to check that a fragmentation needed error is received.

Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org

---
Changes since v1:
- Formating and indentation fixes
- Added '-t' to getopts
- Reworked verbose output of grep'd commands with a new function
- Expanded ip command names
- Added fragmentation tests
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/vrf_icmp_error_route.sh     | 475 ++++++++++++++++++
 2 files changed, 476 insertions(+)
 create mode 100755 tools/testing/selftests/net/vrf_icmp_error_route.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9491bbaa0831..a716fbf780b3 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -19,6 +19,7 @@ TEST_PROGS += txtimestamp.sh
 TEST_PROGS += vrf-xfrm-tests.sh
 TEST_PROGS += rxtimestamp.sh
 TEST_PROGS += devlink_port_split.py
+TEST_PROGS += vrf_icmp_error_route.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/vrf_icmp_error_route.sh b/tools/testing/selftests/net/vrf_icmp_error_route.sh
new file mode 100755
index 000000000000..42c412bd79ab
--- /dev/null
+++ b/tools/testing/selftests/net/vrf_icmp_error_route.sh
@@ -0,0 +1,475 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2019 David Ahern <dsahern@gmail.com>. All rights reserved.
+# Copyright (c) 2020 Michael Jeanson <mjeanson@efficios.com>. All rights reserved.
+#
+#                     blue         red
+#                     .253 +----+ .253
+#                     +----| r1 |----+
+#                     |    +----+    |
+# +----+              |              |              +----+
+# | h1 |--------------+              +--------------| h2 |
+# +----+ .1           |              |           .2 +----+
+#         172.16.1/24 |    +----+    | 172.16.2/24
+#    2001:db8:16:1/64 +----| r2 |----+ 2001:db8:16:2/64
+#                     .254 +----+ .254
+#
+#
+# Route from h1 to h2 goes through r1, incoming vrf blue has a route to the
+# outgoing vrf red for the n2 network but red doesn't have a route back to n1.
+# Route from h2 to h1 goes through r2.
+#
+# The objective is to check that the incoming vrf routing table is selected
+# to send an ICMP error back to the source when the ttl of a packet reaches 1
+# while it is forwarded between different vrfs.
+#
+# The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
+# output of the command to check that a ttl expired error is received.
+#
+# The second test runs traceroute from h1 to h2 and parses the output to check
+# for a hop on r1.
+#
+# Requires CONFIG_NET_VRF, CONFIG_VETH, CONFIG_BRIDGE and CONFIG_NET_NS.
+
+VERBOSE=0
+PAUSE_ON_FAIL=no
+
+H1_N1_IP=172.16.1.1
+R1_N1_IP=172.16.1.253
+R2_N1_IP=172.16.1.254
+
+H1_N1_IP6=2001:db8:16:1::1
+R1_N1_IP6=2001:db8:16:1::253
+R2_N1_IP6=2001:db8:16:1::254
+
+H2_N2=172.16.2.0/24
+H2_N2_6=2001:db8:16:2::/64
+
+H2_N2_IP=172.16.2.2
+R1_N2_IP=172.16.2.253
+R2_N2_IP=172.16.2.254
+
+H2_N2_IP6=2001:db8:16:2::2
+R1_N2_IP6=2001:db8:16:2::253
+R2_N2_IP6=2001:db8:16:2::254
+
+################################################################################
+# helpers
+
+log_section()
+{
+	echo
+	echo "###########################################################################"
+	echo "$*"
+	echo "###########################################################################"
+	echo
+}
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ "${rc}" -eq "${expected}" ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read -r a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+}
+
+run_cmd()
+{
+	local cmd="$*"
+	local out
+	local rc
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "COMMAND: $cmd"
+	fi
+
+	out=$(eval $cmd 2>&1)
+	rc=$?
+	if [ "$VERBOSE" = "1" ] && [ -n "$out" ]; then
+		echo "$out"
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
+}
+
+run_cmd_grep()
+{
+	local grep_pattern="$1"
+	shift
+	local cmd="$*"
+	local out
+	local rc
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "COMMAND: $cmd"
+	fi
+
+	out=$(eval $cmd 2>&1)
+	if [ "$VERBOSE" = "1" ] && [ -n "$out" ]; then
+		echo "$out"
+	fi
+
+	echo "$out" | grep -q "$grep_pattern"
+	rc=$?
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
+}
+
+################################################################################
+# setup and teardown
+
+cleanup()
+{
+	local ns
+
+	setup=0
+
+	for ns in h1 h2 r1 r2; do
+		ip netns del $ns 2>/dev/null
+	done
+}
+
+setup_vrf()
+{
+	local ns=$1
+
+	ip -netns "${ns}" rule del pref 0
+	ip -netns "${ns}" rule add pref 32765 from all lookup local
+	ip -netns "${ns}" -6 rule del pref 0
+	ip -netns "${ns}" -6 rule add pref 32765 from all lookup local
+}
+
+create_vrf()
+{
+	local ns=$1
+	local vrf=$2
+	local table=$3
+
+	ip -netns "${ns}" link add "${vrf}" type vrf table "${table}"
+	ip -netns "${ns}" link set "${vrf}" up
+	ip -netns "${ns}" route add vrf "${vrf}" unreachable default metric 8192
+	ip -netns "${ns}" -6 route add vrf "${vrf}" unreachable default metric 8192
+
+	ip -netns "${ns}" addr add 127.0.0.1/8 dev "${vrf}"
+	ip -netns "${ns}" -6 addr add ::1 dev "${vrf}" nodad
+}
+
+setup()
+{
+	local ns
+
+	if [ "${setup}" -eq 1 ]; then
+		return 0
+	fi
+
+	# make sure we are starting with a clean slate
+	cleanup
+
+	setup=1
+
+	#
+	# create nodes as namespaces
+	#
+	for ns in h1 h2 r1 r2; do
+		ip netns add $ns
+		ip -netns $ns link set lo up
+
+		case "${ns}" in
+		h[12]) ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=0
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
+			;;
+		r[12]) ip netns exec $ns sysctl -q -w net.ipv4.ip_forward=1
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=1
+		esac
+	done
+
+	#
+	# create interconnects
+	#
+	ip -netns h1 link add eth0 type veth peer name r1h1
+	ip -netns h1 link set r1h1 netns r1 name eth0 up
+
+	ip -netns h1 link add eth1 type veth peer name r2h1
+	ip -netns h1 link set r2h1 netns r2 name eth0 up
+
+	ip -netns h2 link add eth0 type veth peer name r1h2
+	ip -netns h2 link set r1h2 netns r1 name eth1 up
+
+	ip -netns h2 link add eth1 type veth peer name r2h2
+	ip -netns h2 link set r2h2 netns r2 name eth1 up
+
+	#
+	# h1
+	#
+	ip -netns h1 link add br0 type bridge
+	ip -netns h1 link set br0 up
+	ip -netns h1 addr add dev br0 ${H1_N1_IP}/24
+	ip -netns h1 -6 addr add dev br0 ${H1_N1_IP6}/64 nodad
+	ip -netns h1 link set eth0 master br0 up
+	ip -netns h1 link set eth1 master br0 up
+
+	# h1 to h2 via r1
+	ip -netns h1    route add ${H2_N2} via ${R1_N1_IP} dev br0
+	ip -netns h1 -6 route add ${H2_N2_6} via "${R1_N1_IP6}" dev br0
+
+	#
+	# h2
+	#
+	ip -netns h2 link add br0 type bridge
+	ip -netns h2 link set br0 up
+	ip -netns h2 addr add dev br0 ${H2_N2_IP}/24
+	ip -netns h2 -6 addr add dev br0 ${H2_N2_IP6}/64 nodad
+	ip -netns h2 link set eth0 master br0 up
+	ip -netns h2 link set eth1 master br0 up
+
+	ip -netns h2 route add default via ${R2_N2_IP} dev br0
+	ip -netns h2 -6 route add default via ${R2_N2_IP6} dev br0
+
+	#
+	# r1
+	#
+	setup_vrf r1
+	create_vrf r1 blue 1101
+	create_vrf r1 red 1102
+	ip -netns r1 link set mtu 1400 dev eth1
+	ip -netns r1 link set eth0 vrf blue up
+	ip -netns r1 link set eth1 vrf red up
+	ip -netns r1 addr add dev eth0 ${R1_N1_IP}/24
+	ip -netns r1 -6 addr add dev eth0 ${R1_N1_IP6}/64 nodad
+	ip -netns r1 addr add dev eth1 ${R1_N2_IP}/24
+	ip -netns r1 -6 addr add dev eth1 ${R1_N2_IP6}/64 nodad
+
+	# Route leak from blue to red
+	ip -netns r1 route add vrf blue ${H2_N2} dev red
+	ip -netns r1 -6 route add vrf blue ${H2_N2_6} dev red
+
+	#
+	# r2
+	#
+	ip -netns r2 addr add dev eth0 ${R2_N1_IP}/24
+	ip -netns r2 -6 addr add dev eth0 ${R2_N1_IP6}/64 nodad
+	ip -netns r2 addr add dev eth1 ${R2_N2_IP}/24
+	ip -netns r2 -6 addr add dev eth1 ${R2_N2_IP6}/64 nodad
+
+	# Wait for ip config to settle
+	sleep 2
+}
+
+check_connectivity4()
+{
+	ip netns exec h1 ping -c1 -w1 ${H2_N2_IP} >/dev/null 2>&1
+}
+
+check_connectivity6()
+{
+	ip netns exec h1 "${ping6}" -c1 -w1 ${H2_N2_IP6} >/dev/null 2>&1
+}
+
+ipv4_traceroute()
+{
+	log_section "IPv4: VRF ICMP error route lookup traceroute"
+
+	if [ ! -x "$(command -v traceroute)" ]; then
+		echo "SKIP: Could not run IPV4 test without traceroute"
+		return
+	fi
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity4; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "${R1_N1_IP}" ip netns exec h1 traceroute ${H2_N2_IP}
+	log_test $? 0 "Traceroute reports a hop on r1"
+}
+
+ipv6_traceroute()
+{
+	log_section "IPv6: VRF ICMP error route lookup traceroute"
+
+	if [ ! -x "$(command -v traceroute6)" ]; then
+		echo "SKIP: Could not run IPV6 test without traceroute6"
+		return
+	fi
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity6; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "${R1_N1_IP6}" ip netns exec h1 traceroute6 ${H2_N2_IP6}
+	log_test $? 0 "Traceroute6 reports a hop on r1"
+}
+
+ipv4_ping_ttl()
+{
+	log_section "IPv4: VRF ICMP ttl error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity4; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "Time to live exceeded" ip netns exec h1 ping -t1 -c1 -W2 ${H2_N2_IP}
+	log_test $? 0 "Ping received ICMP ttl exceeded"
+}
+
+ipv4_ping_frag()
+{
+	log_section "IPv4: VRF ICMP fragmentation error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity4; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "Frag needed" ip netns exec h1 ping -s 1450 -Mdo -c1 -W2 ${H2_N2_IP}
+	log_test $? 0 "Ping received ICMP frag needed"
+}
+
+ipv6_ping_ttl()
+{
+	log_section "IPv6: VRF ICMP ttl error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity6; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "Time exceeded: Hop limit" ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6}
+	log_test $? 0 "Ping received ICMP frag"
+}
+
+ipv6_ping_frag()
+{
+	log_section "IPv6: VRF ICMP fragmentation error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity6; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	run_cmd_grep "Packet too big" ip netns exec h1 "${ping6}" -s 1450 -Mdo -c1 -W2 ${H2_N2_IP6}
+	log_test $? 0 "Ping received ICMP frag needed"
+}
+
+################################################################################
+# usage
+
+usage()
+{
+        cat <<EOF
+usage: ${0##*/} OPTS
+
+	-4          IPv4 tests only
+	-6          IPv6 tests only
+	-p          Pause on fail
+	-v          verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# main
+
+# Some systems don't have a ping6 binary anymore
+command -v ping6 > /dev/null 2>&1 && ping6=$(command -v ping6) || ping6=$(command -v ping)
+
+TESTS_IPV4="ipv4_ping_ttl ipv4_ping_frag ipv4_traceroute"
+TESTS_IPV6="ipv6_ping_ttl ipv6_ping_frag ipv6_traceroute"
+
+ret=0
+nsuccess=0
+nfail=0
+setup=0
+
+while getopts :46t:pvh o
+do
+	case $o in
+		4) TESTS=ipv4;;
+		6) TESTS=ipv6;;
+		t) TESTS=$OPTARG;;
+		p) PAUSE_ON_FAIL=yes;;
+		v) VERBOSE=1;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+#
+# show user test config
+#
+if [ -z "$TESTS" ]; then
+        TESTS="$TESTS_IPV4 $TESTS_IPV6"
+elif [ "$TESTS" = "ipv4" ]; then
+        TESTS="$TESTS_IPV4"
+elif [ "$TESTS" = "ipv6" ]; then
+        TESTS="$TESTS_IPV6"
+fi
+
+for t in $TESTS
+do
+	case $t in
+	ipv4_ping_ttl|ping)         ipv4_ping_ttl;;&
+	ipv4_ping_frag|ping)        ipv4_ping_frag;;&
+	ipv4_traceroute|traceroute) ipv4_traceroute;;&
+
+	ipv6_ping_ttl|ping)         ipv6_ping_ttl;;&
+	ipv6_ping_frag|ping)        ipv6_ping_frag;;&
+	ipv6_traceroute|traceroute) ipv6_traceroute;;&
+
+	# setup namespaces and config, but do not run any tests
+	setup)                      setup; exit 0;;
+
+	help)                       echo "Test names: $TESTS"; exit 0;;
+	esac
+done
+
+cleanup
+
+printf "\nTests passed: %3d\n" ${nsuccess}
+printf "Tests failed: %3d\n"   ${nfail}
+
+exit $ret
-- 
2.17.1

