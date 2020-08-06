Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370B223E184
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgHFSv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:51:57 -0400
Received: from mail.efficios.com ([167.114.26.124]:39108 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgHFSv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:51:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 001C329BCDA;
        Thu,  6 Aug 2020 14:51:54 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5PD73NyQvyqC; Thu,  6 Aug 2020 14:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 50ED629BCD9;
        Thu,  6 Aug 2020 14:51:54 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 50ED629BCD9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1596739914;
        bh=bld7xqCzU4hyPpz7h43GVxMFfXD0eRkS1jq/9gg8780=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=XB8NzyUX3oW3N2u/vwu19m31m/mW2a0I99Hh2DIimuXGsYvKNkoYxA+EWumrm1DuI
         zCA0+Uyu3XQh89p8Vmkq/PEsIp31lXtrP0VBsKEiPZrAOoYJpX3zGg4+dIPqb9zkLh
         jiYxb36pVvBVLVbnKzd4ZVCJHWOKyBmVjpkK789S04JTi/e3QdzKMXIDQFNrbGRF3f
         zqdbAWap8DN7Bd8YmhRmwTIdWewgkBOGq3j4MtHekcskxzJNMUrnSyy1G792rSN7r8
         Zi2VCvst82rJGMO61KhWecdY9HBByIVkqFBJaNobMF21p38uWxghJ4/yMOspTLiY9X
         QoTQjir72SefA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0E6QIPtzdjbl; Thu,  6 Aug 2020 14:51:54 -0400 (EDT)
Received: from localhost.localdomain (96-127-212-112.qc.cable.ebox.net [96.127.212.112])
        by mail.efficios.com (Postfix) with ESMTPSA id 0F7E929BCD8;
        Thu,  6 Aug 2020 14:51:54 -0400 (EDT)
From:   Michael Jeanson <mjeanson@efficios.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Jeanson <mjeanson@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] selftests: Add VRF icmp error route lookup test
Date:   Thu,  6 Aug 2020 14:51:21 -0400
Message-Id: <20200806185121.19688-1-mjeanson@efficios.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
References: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The objective is to check that the incoming vrf routing table is selected
to send an ICMP error back to the source when the ttl of a packet reaches=
 1
while it is forwarded between different vrfs.

The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
output of the command to check that a ttl expired error is received.

[This may be flaky, I'm open to suggestions of a more robust approch.]

The second test runs traceroute from h1 to h2 and parses the output to
check for a hop on r1.

Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/vrf_icmp_error_route.sh     | 429 ++++++++++++++++++
 2 files changed, 430 insertions(+)
 create mode 100755 tools/testing/selftests/net/vrf_icmp_error_route.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index 895ec992b2f1..2fc72bc2908c 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS +=3D route_localnet.sh
 TEST_PROGS +=3D reuseaddr_ports_exhausted.sh
 TEST_PROGS +=3D txtimestamp.sh
 TEST_PROGS +=3D vrf-xfrm-tests.sh
+TEST_PROGS +=3D vrf_icmp_error_route.sh
 TEST_PROGS_EXTENDED :=3D in_netns.sh
 TEST_GEN_FILES =3D  socket nettest
 TEST_GEN_FILES +=3D psock_fanout psock_tpacket msg_zerocopy reuseport_ad=
dr_any
diff --git a/tools/testing/selftests/net/vrf_icmp_error_route.sh b/tools/=
testing/selftests/net/vrf_icmp_error_route.sh
new file mode 100755
index 000000000000..0b15a886bf5b
--- /dev/null
+++ b/tools/testing/selftests/net/vrf_icmp_error_route.sh
@@ -0,0 +1,429 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2019 David Ahern <dsahern@gmail.com>. All rights reserve=
d.
+# Copyright (c) 2020 Michael Jeanson <mjeanson@efficios.com>. All rights=
 reserved.
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
+# Route from h1 to h2 goes through r1, incoming vrf blue has a route to =
the
+# outgoing vrf red for the n2 network but red doesn't have a route back =
to n1.
+# Route from h2 to h1 goes through r2.
+#
+# The objective is to check that the incoming vrf routing table is selec=
ted
+# to send an ICMP error back to the source when the ttl of a packet reac=
hes 1
+# while it is forwarded between different vrfs.
+#
+# The first test sends a ping with a ttl of 1 from h1 to h2 and parses t=
he
+# output of the command to check that a ttl expired error is received.
+#
+# The second test runs traceroute from h1 to h2 and parses the output to=
 check
+# for a hop on r1.
+#
+# Requires CONFIG_NET_VRF, CONFIG_VETH, CONFIG_BRIDGE and CONFIG_NET_NS.
+
+VERBOSE=3D0
+PAUSE_ON_FAIL=3Dno
+
+H1_N1_IP=3D172.16.1.1
+R1_N1_IP=3D172.16.1.253
+R2_N1_IP=3D172.16.1.254
+
+H1_N1_IP6=3D2001:db8:16:1::1
+R1_N1_IP6=3D2001:db8:16:1::253
+R2_N1_IP6=3D2001:db8:16:1::254
+
+H2_N2=3D172.16.2.0/24
+H2_N2_6=3D2001:db8:16:2::/64
+
+H2_N2_IP=3D172.16.2.2
+R1_N2_IP=3D172.16.2.253
+R2_N2_IP=3D172.16.2.254
+
+H2_N2_IP6=3D2001:db8:16:2::2
+R1_N2_IP6=3D2001:db8:16:2::253
+R2_N2_IP6=3D2001:db8:16:2::254
+
+########################################################################=
########
+# helpers
+
+log_section()
+{
+	echo
+	echo "#################################################################=
##########"
+	echo "$*"
+	echo "#################################################################=
##########"
+	echo
+}
+
+log_test()
+{
+	local rc=3D$1
+	local expected=3D$2
+	local msg=3D"$3"
+
+	if [ "${rc}" -eq "${expected}" ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=3D$((nsuccess+1))
+	else
+		ret=3D1
+		nfail=3D$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" =3D "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read -r a
+			[ "$a" =3D "q" ] && exit 1
+		fi
+	fi
+}
+
+run_cmd()
+{
+	local cmd=3D"$*"
+	local out
+	local rc
+
+	if [ "$VERBOSE" =3D "1" ]; then
+		echo "COMMAND: $cmd"
+	fi
+
+	out=3D$(eval $cmd 2>&1)
+	rc=3D$?
+	if [ "$VERBOSE" =3D "1" ] && [ -n "$out" ]; then
+		echo "$out"
+	fi
+
+	[ "$VERBOSE" =3D "1" ] && echo
+
+	return $rc
+}
+
+########################################################################=
########
+# setup and teardown
+
+cleanup()
+{
+	local ns
+
+	setup=3D0
+
+	for ns in h1 h2 r1 r2; do
+		ip netns del $ns 2>/dev/null
+	done
+}
+
+setup_vrf()
+{
+	local ns=3D$1
+
+	ip -netns "${ns}" ru del pref 0
+	ip -netns "${ns}" ru add pref 32765 from all lookup local
+	ip -netns "${ns}" -6 ru del pref 0
+	ip -netns "${ns}" -6 ru add pref 32765 from all lookup local
+}
+
+create_vrf()
+{
+	local ns=3D$1
+	local vrf=3D$2
+	local table=3D$3
+
+	ip -netns "${ns}" link add "${vrf}" type vrf table "${table}"
+	ip -netns "${ns}" link set "${vrf}" up
+	ip -netns "${ns}" route add vrf "${vrf}" unreachable default metric 819=
2
+	ip -netns "${ns}" -6 route add vrf "${vrf}" unreachable default metric =
8192
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
+	setup=3D1
+
+	#
+	# create nodes as namespaces
+	#
+	for ns in h1 h2 r1 r2; do
+		ip netns add $ns
+		ip -netns $ns li set lo up
+
+		case "${ns}" in
+		h[12]) ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=3D0
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.keep_addr_on_d=
own=3D1
+			;;
+		r[12]) ip netns exec $ns sysctl -q -w net.ipv4.ip_forward=3D1
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=3D1
+		esac
+	done
+
+	#
+	# create interconnects
+	#
+	ip -netns h1 li add eth0 type veth peer name r1h1
+	ip -netns h1 li set r1h1 netns r1 name eth0 up
+
+	ip -netns h1 li add eth1 type veth peer name r2h1
+	ip -netns h1 li set r2h1 netns r2 name eth0 up
+
+	ip -netns h2 li add eth0 type veth peer name r1h2
+	ip -netns h2 li set r1h2 netns r1 name eth1 up
+
+	ip -netns h2 li add eth1 type veth peer name r2h2
+	ip -netns h2 li set r2h2 netns r2 name eth1 up
+
+	#
+	# h1
+	#
+	ip -netns h1 li add br0 type bridge
+	ip -netns h1 li set br0 up
+	ip -netns h1 addr add dev br0 ${H1_N1_IP}/24
+	ip -netns h1 -6 addr add dev br0 ${H1_N1_IP6}/64 nodad
+	ip -netns h1 li set eth0 master br0 up
+	ip -netns h1 li set eth1 master br0 up
+
+	# h1 to h2 via r1
+	ip -netns h1    ro add ${H2_N2} via ${R1_N1_IP} dev br0
+	ip -netns h1 -6 ro add ${H2_N2_6} via "${R1_N1_IP6}" dev br0
+
+	#
+	# h2
+	#
+	ip -netns h2 li add br0 type bridge
+	ip -netns h2 li set br0 up
+	ip -netns h2 addr add dev br0 ${H2_N2_IP}/24
+	ip -netns h2 -6 addr add dev br0 ${H2_N2_IP6}/64 nodad
+	ip -netns h2 li set eth0 master br0 up
+	ip -netns h2 li set eth1 master br0 up
+
+	ip -netns h2 ro add default via ${R2_N2_IP} dev br0
+	ip -netns h2 -6 ro add default via ${R2_N2_IP6} dev br0
+
+	#
+	# r1
+	#
+	setup_vrf r1
+	create_vrf r1 blue 1101
+	create_vrf r1 red 1102
+	ip -netns r1 li set eth0 vrf blue up
+	ip -netns r1 li set eth1 vrf red up
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
+		ret=3D1
+		return
+	fi
+
+	if [ "$VERBOSE" =3D "1" ]; then
+		run_cmd ip netns exec h1 traceroute ${H2_N2_IP}
+	fi
+
+	ip netns exec h1 traceroute ${H2_N2_IP} | grep -q "${R1_N1_IP}"
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
+		ret=3D1
+		return
+	fi
+
+	if [ "$VERBOSE" =3D "1" ]; then
+		run_cmd ip netns exec h1 traceroute6 ${H2_N2_IP6}
+	fi
+
+	ip netns exec h1 traceroute6 ${H2_N2_IP6} | grep -q "${R1_N1_IP6}"
+	log_test $? 0 "Traceroute6 reports a hop on r1"
+}
+
+ipv4_ping()
+{
+	log_section "IPv4: VRF ICMP error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity4; then
+		echo "Error: Basic connectivity is broken"
+		ret=3D1
+		return
+	fi
+
+	if [ "$VERBOSE" =3D "1" ]; then
+		echo "Command to check for ICMP ttl exceeded:"
+		run_cmd ip netns exec h1 ping -t1 -c1 -W2 ${H2_N2_IP}
+	fi
+
+	ip netns exec h1 ping -t1 -c1 -W2 ${H2_N2_IP} | grep -q "Time to live e=
xceeded"
+	log_test $? 0 "Ping received ICMP ttl exceeded"
+}
+
+ipv6_ping()
+{
+	log_section "IPv6: VRF ICMP error route lookup ping"
+
+	setup
+
+	# verify connectivity
+	if ! check_connectivity6; then
+		echo "Error: Basic connectivity is broken"
+		ret=3D1
+		return
+	fi
+
+	if [ "$VERBOSE" =3D "1" ]; then
+		echo "Command to check for ICMP ttl exceeded:"
+		run_cmd ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6}
+	fi
+
+	ip netns exec h1 "${ping6}" -t1 -c1 -W2 ${H2_N2_IP6} | grep -q "Time ex=
ceeded: Hop limit"
+	log_test $? 0 "Ping received ICMP ttl exceeded"
+}
+########################################################################=
########
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
+########################################################################=
########
+# main
+
+# Some systems don't have a ping6 binary anymore
+command -v ping6 > /dev/null 2>&1 && ping6=3D$(command -v ping6) || ping=
6=3D$(command -v ping)
+
+TESTS_IPV4=3D"ipv4_ping ipv4_traceroute"
+TESTS_IPV6=3D"ipv6_ping ipv6_traceroute"
+
+ret=3D0
+nsuccess=3D0
+nfail=3D0
+setup=3D0
+
+while getopts :46pvh o
+do
+	case $o in
+		4) TESTS=3Dipv4;;
+		6) TESTS=3Dipv6;;
+                p) PAUSE_ON_FAIL=3Dyes;;
+                v) VERBOSE=3D1;;
+		h) usage; exit 0;;
+                *) usage; exit 1;;
+	esac
+done
+
+#
+# show user test config
+#
+if [ -z "$TESTS" ]; then
+        TESTS=3D"$TESTS_IPV4 $TESTS_IPV6"
+elif [ "$TESTS" =3D "ipv4" ]; then
+        TESTS=3D"$TESTS_IPV4"
+elif [ "$TESTS" =3D "ipv6" ]; then
+        TESTS=3D"$TESTS_IPV6"
+fi
+
+for t in $TESTS
+do
+	case $t in
+	ipv4_ping|ping)             ipv4_ping;;
+	ipv4_traceroute|traceroute) ipv4_traceroute;;
+
+	ipv6_ping|ping)             ipv6_ping;;
+	ipv6_traceroute|traceroute) ipv6_traceroute;;
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
--=20
2.27.0

