Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77D6827A7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfHEWjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbfHEWjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 18:39:53 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD78B216B7;
        Mon,  5 Aug 2019 22:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565044792;
        bh=+90GwxaY1WXR/jFLVeBEoRk7rtCz/XPBlWqfd0syzyg=;
        h=From:To:Cc:Subject:Date:From;
        b=a2yBO2AcVMfap0/E34cfSRBiUDKLg9xlM/pMSD/In2sojv4Zf7MCaHFQy7KB79a/8
         L4wfFBOHnH3z7s+ar/9H3zu+b8PkkutR0kfVeCPTqjoDclOtWmGj9Nl+AqLknQVUAq
         a/4rE13j5Vf5c8paVgGYTNRdqJk4LB9rf++z5hto=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next] selftests: Add l2tp tests
Date:   Mon,  5 Aug 2019 15:41:37 -0700
Message-Id: <20190805224137.15236-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add IPv4 and IPv6 l2tp tests. Current set is over IP and with
IPsec.

v2
- add l2tp.sh to TEST_PROGS in Makefile

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/Makefile |   2 +-
 tools/testing/selftests/net/l2tp.sh  | 382 +++++++++++++++++++++++++++++++++++
 2 files changed, 383 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/l2tp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 70f2d6656170..0bd6b23c97ef 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -10,7 +10,7 @@ TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
-TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh
+TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/l2tp.sh b/tools/testing/selftests/net/l2tp.sh
new file mode 100644
index 000000000000..5782433886fc
--- /dev/null
+++ b/tools/testing/selftests/net/l2tp.sh
@@ -0,0 +1,382 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# L2TPv3 tunnel between 2 hosts
+#
+#            host-1          |   router   |     host-2
+#                            |            |
+#      lo          l2tp      |            |      l2tp           lo
+# 172.16.101.1  172.16.1.1   |            | 172.16.1.2    172.16.101.2
+#  fc00:101::1   fc00:1::1   |            |   fc00:1::2    fc00:101::2
+#                            |            |
+#                  eth0      |            |     eth0
+#                10.1.1.1    |            |   10.1.2.1
+#              2001:db8:1::1 |            | 2001:db8:2::1
+
+VERBOSE=0
+PAUSE_ON_FAIL=no
+
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
+################################################################################
+#
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+}
+
+run_cmd()
+{
+	local ns
+	local cmd
+	local out
+	local rc
+
+	ns="$1"
+	shift
+	cmd="$*"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "    COMMAND: $cmd\n"
+	fi
+
+	out=$(eval ip netns exec ${ns} ${cmd} 2>&1)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "    $out"
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
+}
+
+################################################################################
+# create namespaces and interconnects
+
+create_ns()
+{
+	local ns=$1
+	local addr=$2
+	local addr6=$3
+
+	[ -z "${addr}" ] && addr="-"
+	[ -z "${addr6}" ] && addr6="-"
+
+	ip netns add ${ns}
+
+	ip -netns ${ns} link set lo up
+	if [ "${addr}" != "-" ]; then
+		ip -netns ${ns} addr add dev lo ${addr}
+	fi
+	if [ "${addr6}" != "-" ]; then
+		ip -netns ${ns} -6 addr add dev lo ${addr6}
+	fi
+
+	ip -netns ${ns} ro add unreachable default metric 8192
+	ip -netns ${ns} -6 ro add unreachable default metric 8192
+
+	ip netns exec ${ns} sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+}
+
+# create veth pair to connect namespaces and apply addresses.
+connect_ns()
+{
+	local ns1=$1
+	local ns1_dev=$2
+	local ns1_addr=$3
+	local ns1_addr6=$4
+	local ns2=$5
+	local ns2_dev=$6
+	local ns2_addr=$7
+	local ns2_addr6=$8
+
+	ip -netns ${ns1} li add ${ns1_dev} type veth peer name tmp
+	ip -netns ${ns1} li set ${ns1_dev} up
+	ip -netns ${ns1} li set tmp netns ${ns2} name ${ns2_dev}
+	ip -netns ${ns2} li set ${ns2_dev} up
+
+	if [ "${ns1_addr}" != "-" ]; then
+		ip -netns ${ns1} addr add dev ${ns1_dev} ${ns1_addr}
+		ip -netns ${ns2} addr add dev ${ns2_dev} ${ns2_addr}
+	fi
+
+	if [ "${ns1_addr6}" != "-" ]; then
+		ip -netns ${ns1} addr add dev ${ns1_dev} ${ns1_addr6}
+		ip -netns ${ns2} addr add dev ${ns2_dev} ${ns2_addr6}
+	fi
+}
+
+################################################################################
+# test setup
+
+cleanup()
+{
+	local ns
+
+	for ns in host-1 host-2 router
+	do
+		ip netns del ${ns} 2>/dev/null
+	done
+}
+
+setup_l2tp_ipv4()
+{
+	#
+	# configure l2tpv3 tunnel on host-1
+	#
+	ip -netns host-1 l2tp add tunnel tunnel_id 1041 peer_tunnel_id 1042 \
+			 encap ip local 10.1.1.1 remote 10.1.2.1
+	ip -netns host-1 l2tp add session name l2tp4 tunnel_id 1041 \
+			 session_id 1041 peer_session_id 1042
+	ip -netns host-1 link set dev l2tp4 up
+	ip -netns host-1 addr add dev l2tp4 172.16.1.1 peer 172.16.1.2
+
+	#
+	# configure l2tpv3 tunnel on host-2
+	#
+	ip -netns host-2 l2tp add tunnel tunnel_id 1042 peer_tunnel_id 1041 \
+			 encap ip local 10.1.2.1 remote 10.1.1.1
+	ip -netns host-2 l2tp add session name l2tp4 tunnel_id 1042 \
+			 session_id 1042 peer_session_id 1041
+	ip -netns host-2 link set dev l2tp4 up
+	ip -netns host-2 addr add dev l2tp4 172.16.1.2 peer 172.16.1.1
+
+	#
+	# add routes to loopback addresses
+	#
+	ip -netns host-1 ro add 172.16.101.2/32 via 172.16.1.2
+	ip -netns host-2 ro add 172.16.101.1/32 via 172.16.1.1
+}
+
+setup_l2tp_ipv6()
+{
+	#
+	# configure l2tpv3 tunnel on host-1
+	#
+	ip -netns host-1 l2tp add tunnel tunnel_id 1061 peer_tunnel_id 1062 \
+			 encap ip local 2001:db8:1::1 remote 2001:db8:2::1
+	ip -netns host-1 l2tp add session name l2tp6 tunnel_id 1061 \
+			 session_id 1061 peer_session_id 1062
+	ip -netns host-1 link set dev l2tp6 up
+	ip -netns host-1 addr add dev l2tp6 fc00:1::1 peer fc00:1::2
+
+	#
+	# configure l2tpv3 tunnel on host-2
+	#
+	ip -netns host-2 l2tp add tunnel tunnel_id 1062 peer_tunnel_id 1061 \
+			 encap ip local 2001:db8:2::1 remote 2001:db8:1::1
+	ip -netns host-2 l2tp add session name l2tp6 tunnel_id 1062 \
+			 session_id 1062 peer_session_id 1061
+	ip -netns host-2 link set dev l2tp6 up
+	ip -netns host-2 addr add dev l2tp6 fc00:1::2 peer fc00:1::1
+
+	#
+	# add routes to loopback addresses
+	#
+	ip -netns host-1 -6 ro add fc00:101::2/128 via fc00:1::2
+	ip -netns host-2 -6 ro add fc00:101::1/128 via fc00:1::1
+}
+
+setup()
+{
+	# start clean
+	cleanup
+
+	set -e
+	create_ns host-1 172.16.101.1/32 fc00:101::1/128
+	create_ns host-2 172.16.101.2/32 fc00:101::2/128
+	create_ns router
+
+	connect_ns host-1 eth0 10.1.1.1/24 2001:db8:1::1/64 \
+	           router eth1 10.1.1.2/24 2001:db8:1::2/64
+
+	connect_ns host-2 eth0 10.1.2.1/24 2001:db8:2::1/64 \
+	           router eth2 10.1.2.2/24 2001:db8:2::2/64
+
+	ip -netns host-1 ro add 10.1.2.0/24 via 10.1.1.2
+	ip -netns host-1 -6 ro add 2001:db8:2::/64 via 2001:db8:1::2
+
+	ip -netns host-2 ro add 10.1.1.0/24 via 10.1.2.2
+	ip -netns host-2 -6 ro add 2001:db8:1::/64 via 2001:db8:2::2
+
+	setup_l2tp_ipv4
+	setup_l2tp_ipv6
+	set +e
+}
+
+setup_ipsec()
+{
+	#
+	# IPv4
+	#
+	run_cmd host-1 ip xfrm policy add \
+		src 10.1.1.1 dst 10.1.2.1 dir out \
+		tmpl proto esp mode transport
+
+	run_cmd host-1 ip xfrm policy add \
+		src 10.1.2.1 dst 10.1.1.1 dir in \
+		tmpl proto esp mode transport
+
+	run_cmd host-2 ip xfrm policy add \
+		src 10.1.1.1 dst 10.1.2.1 dir in \
+		tmpl proto esp mode transport
+
+	run_cmd host-2 ip xfrm policy add \
+		src 10.1.2.1 dst 10.1.1.1 dir out \
+		tmpl proto esp mode transport
+
+	ip -netns host-1 xfrm state add \
+		src 10.1.1.1 dst 10.1.2.1 \
+		spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-1 xfrm state add \
+		src 10.1.2.1 dst 10.1.1.1 \
+		spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-2 xfrm state add \
+		src 10.1.1.1 dst 10.1.2.1 \
+		spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-2 xfrm state add \
+		src 10.1.2.1 dst 10.1.1.1 \
+		spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	#
+	# IPV6
+	#
+	run_cmd host-1 ip -6 xfrm policy add \
+		src 2001:db8:1::1 dst 2001:db8:2::1 dir out \
+		tmpl proto esp mode transport
+
+	run_cmd host-1 ip -6 xfrm policy add \
+		src 2001:db8:2::1 dst 2001:db8:1::1 dir in \
+		tmpl proto esp mode transport
+
+	run_cmd host-2 ip -6 xfrm policy add \
+		src 2001:db8:1::1 dst 2001:db8:2::1 dir in \
+		tmpl proto esp mode transport
+
+	run_cmd host-2 ip -6 xfrm policy add \
+		src 2001:db8:2::1 dst 2001:db8:1::1 dir out \
+		tmpl proto esp mode transport
+
+	ip -netns host-1 -6 xfrm state add \
+		src 2001:db8:1::1 dst 2001:db8:2::1 \
+		spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-1 -6 xfrm state add \
+		src 2001:db8:2::1 dst 2001:db8:1::1 \
+		spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-2 -6 xfrm state add \
+		src 2001:db8:1::1 dst 2001:db8:2::1 \
+		spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+
+	ip -netns host-2 -6 xfrm state add \
+		src 2001:db8:2::1 dst 2001:db8:1::1 \
+		spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' \
+		0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode transport
+}
+
+teardown_ipsec()
+{
+	run_cmd host-1 ip xfrm state flush
+	run_cmd host-1 ip xfrm policy flush
+	run_cmd host-2 ip xfrm state flush
+	run_cmd host-2 ip xfrm policy flush
+}
+
+################################################################################
+# generate traffic through tunnel for various cases
+
+run_ping()
+{
+	local desc="$1"
+
+	run_cmd host-1 ping -c1 -w1 172.16.1.2
+	log_test $? 0 "IPv4 basic L2TP tunnel ${desc}"
+
+	run_cmd host-1 ping -c1 -w1 -I 172.16.101.1 172.16.101.2
+	log_test $? 0 "IPv4 route through L2TP tunnel ${desc}"
+
+	run_cmd host-1 ${ping6} -c1 -w1 fc00:1::2
+	log_test $? 0 "IPv6 basic L2TP tunnel ${desc}"
+
+	run_cmd host-1 ${ping6} -c1 -w1 -I fc00:101::1 fc00:101::2
+	log_test $? 0 "IPv6 route through L2TP tunnel ${desc}"
+}
+
+run_tests()
+{
+	local desc
+
+	setup
+	run_ping
+
+	setup_ipsec
+	run_ping "- with IPsec"
+	run_cmd host-1 ping -c1 -w1 172.16.1.2
+	log_test $? 0 "IPv4 basic L2TP tunnel ${desc}"
+
+	run_cmd host-1 ping -c1 -w1 -I 172.16.101.1 172.16.101.2
+	log_test $? 0 "IPv4 route through L2TP tunnel ${desc}"
+
+	run_cmd host-1 ${ping6} -c1 -w1 fc00:1::2
+	log_test $? 0 "IPv6 basic L2TP tunnel - with IPsec"
+
+	run_cmd host-1 ${ping6} -c1 -w1 -I fc00:101::1 fc00:101::2
+	log_test $? 0 "IPv6 route through L2TP tunnel - with IPsec"
+
+	teardown_ipsec
+	run_ping "- after IPsec teardown"
+}
+
+################################################################################
+# main
+
+declare -i nfail=0
+declare -i nsuccess=0
+
+while getopts :pv o
+do
+	case $o in
+		p) PAUSE_ON_FAIL=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		*) exit 1;;
+	esac
+done
+
+run_tests
+cleanup
+
+printf "\nTests passed: %3d\n" ${nsuccess}
+printf "Tests failed: %3d\n"   ${nfail}
-- 
2.11.0

