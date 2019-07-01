Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83484274CC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfEWD2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbfEWD2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:06 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D67A921841;
        Thu, 23 May 2019 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582085;
        bh=3KHCVAr6Es+iZNGx1VvCtqpx5x6t6gaxj4kDJxf5iXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yE8k7vPDCk6JMku1duqZxFwvzz11AeFp9LNEoBN60syDryWRCF0BuKdZRJDJhAuTh
         9/9KCwPfk2dowC6v5pT9aWLEBAFT4xus2pWXVxJ33mef333eRYtseq5PGdRLBEFUsi
         75wVGlA9Of2C6v3fXWrvc4v/2WPottlajPBu9gLc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 7/7] selftests: Add redirect tests
Date:   Wed, 22 May 2019 20:28:01 -0700
Message-Id: <20190523032801.11122-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add test for ICMP redirects and exception processing. Test is setup
for later addition of tests using nexthop objects for routing.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/icmp_redirect.sh | 455 +++++++++++++++++++++++++++
 1 file changed, 455 insertions(+)
 create mode 100755 tools/testing/selftests/net/icmp_redirect.sh

diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
new file mode 100755
index 000000000000..e8d8496f5b16
--- /dev/null
+++ b/tools/testing/selftests/net/icmp_redirect.sh
@@ -0,0 +1,455 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# redirect test
+#
+#                     .253 +----+
+#                     +----| r1 |
+#                     |    +----+
+# +----+              |       |.1
+# | h1 |--------------+       |   10.1.1.0/30 2001:db8:1::0/126
+# +----+ .1           |       |.2
+#         172.16.1/24 |    +----+                   +----+
+#    2001:db8:16:1/64 +----| r2 |-------------------| h2 |
+#                     .254 +----+ .254           .2 +----+
+#                                    172.16.2/24
+#                                  2001:db8:16:2/64
+#
+# Route from h1 to h2 goes through r1, eth1 - connection between r1 and r2.
+# Route on r1 changed to go to r2 via eth0. This causes a redirect to be sent
+# from r1 to h1 telling h1 to use r2 when talking to h2.
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
+R1_R2_N1_IP=10.1.1.1
+R2_R1_N1_IP=10.1.1.2
+
+R1_R2_N1_IP6=2001:db8:1::1
+R2_R1_N1_IP6=2001:db8:1::2
+
+H2_N2=172.16.2.0/24
+H2_N2_6=2001:db8:16:2::/64
+H2_N2_IP=172.16.2.2
+R2_N2_IP=172.16.2.254
+H2_N2_IP6=2001:db8:16:2::2
+R2_N2_IP6=2001:db8:16:2::254
+
+VRF=red
+VRF_TABLE=1111
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
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "$out"
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
+}
+
+get_linklocal()
+{
+	local ns=$1
+	local dev=$2
+	local addr
+
+	addr=$(ip -netns $ns -6 -br addr show dev ${dev} | \
+	awk '{
+		for (i = 3; i <= NF; ++i) {
+			if ($i ~ /^fe80/)
+				print $i
+		}
+	}'
+	)
+	addr=${addr/\/*}
+
+	[ -z "$addr" ] && return 1
+
+	echo $addr
+
+	return 0
+}
+
+################################################################################
+# setup and teardown
+
+cleanup()
+{
+	local ns
+
+	for ns in h1 h2 r1 r2; do
+		ip netns del $ns 2>/dev/null
+	done
+}
+
+create_vrf()
+{
+	local ns=$1
+
+	ip -netns ${ns} link add ${VRF} type vrf table ${VRF_TABLE}
+	ip -netns ${ns} link set ${VRF} up
+	ip -netns ${ns} route add vrf ${VRF} unreachable default metric 8192
+	ip -netns ${ns} -6 route add vrf ${VRF} unreachable default metric 8192
+
+	ip -netns ${ns} addr add 127.0.0.1/8 dev ${VRF}
+	ip -netns ${ns} -6 addr add ::1 dev ${VRF} nodad
+
+	ip -netns ${ns} ru del pref 0
+	ip -netns ${ns} ru add pref 32765 from all lookup local
+	ip -netns ${ns} -6 ru del pref 0
+	ip -netns ${ns} -6 ru add pref 32765 from all lookup local
+}
+
+setup()
+{
+	local ns
+
+	#
+	# create nodes as namespaces
+	#
+	for ns in h1 h2 r1 r2; do
+		ip netns add $ns
+		ip -netns $ns li set lo up
+
+		case "${ns}" in
+		h[12]) ip netns exec $ns sysctl -q -w net.ipv4.conf.all.accept_redirects=1
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.accept_redirects=1
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
+			;;
+		r[12]) ip netns exec $ns sysctl -q -w net.ipv4.ip_forward=1
+		       ip netns exec $ns sysctl -q -w net.ipv4.conf.all.send_redirects=1
+
+		       ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=1
+		       ip netns exec $ns sysctl -q -w net.ipv6.route.mtu_expires=10
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
+	ip -netns h2 li add eth0 type veth peer name r2h2
+	ip -netns h2 li set eth0 up
+	ip -netns h2 li set r2h2 netns r2 name eth2 up
+
+	ip -netns r1 li add eth1 type veth peer name r2r1
+	ip -netns r1 li set eth1 up
+	ip -netns r1 li set r2r1 netns r2 name eth1 up
+
+	#
+	# h1
+	#
+	if [ "${WITH_VRF}" = "yes" ]; then
+		create_vrf "h1"
+		H1_VRF_ARG="vrf ${VRF}"
+		H1_PING_ARG="-I ${VRF}"
+	else
+		H1_VRF_ARG=
+		H1_PING_ARG=
+	fi
+	ip -netns h1 li add br0 type bridge
+	if [ "${WITH_VRF}" = "yes" ]; then
+		ip -netns h1 li set br0 vrf ${VRF} up
+	else
+		ip -netns h1 li set br0 up
+	fi
+	ip -netns h1 addr add dev br0 ${H1_N1_IP}/24
+	ip -netns h1 -6 addr add dev br0 ${H1_N1_IP6}/64 nodad
+	ip -netns h1 li set eth0 master br0 up
+	ip -netns h1 li set eth1 master br0 up
+
+	#
+	# h2
+	#
+	ip -netns h2 addr add dev eth0 ${H2_N2_IP}/24
+	ip -netns h2 ro add default via ${R2_N2_IP} dev eth0
+	ip -netns h2 -6 addr add dev eth0 ${H2_N2_IP6}/64 nodad
+	ip -netns h2 -6 ro add default via ${R2_N2_IP6} dev eth0
+
+	#
+	# r1
+	#
+	ip -netns r1 addr add dev eth0 ${R1_N1_IP}/24
+	ip -netns r1 -6 addr add dev eth0 ${R1_N1_IP6}/64 nodad
+	ip -netns r1 addr add dev eth1 ${R1_R2_N1_IP}/30
+	ip -netns r1 -6 addr add dev eth1 ${R1_R2_N1_IP6}/126 nodad
+
+	#
+	# r2
+	#
+	ip -netns r2 addr add dev eth0 ${R2_N1_IP}/24
+	ip -netns r2 -6 addr add dev eth0 ${R2_N1_IP6}/64 nodad
+	ip -netns r2 addr add dev eth1 ${R2_R1_N1_IP}/30
+	ip -netns r2 -6 addr add dev eth1 ${R2_R1_N1_IP6}/126 nodad
+	ip -netns r2 addr add dev eth2 ${R2_N2_IP}/24
+	ip -netns r2 -6 addr add dev eth2 ${R2_N2_IP6}/64 nodad
+
+	sleep 2
+
+	R1_LLADDR=$(get_linklocal r1 eth0)
+	if [ $? -ne 0 ]; then
+		echo "Error: Failed to get link-local address of r1's eth0"
+		exit 1
+	fi
+
+	R2_LLADDR=$(get_linklocal r2 eth0)
+	if [ $? -ne 0 ]; then
+		echo "Error: Failed to get link-local address of r2's eth0"
+		exit 1
+	fi
+}
+
+change_h2_mtu()
+{
+	local mtu=$1
+
+	run_cmd ip -netns h2 li set eth0 mtu ${mtu}
+	run_cmd ip -netns r2 li set eth2 mtu ${mtu}
+}
+
+check_exception()
+{
+	local mtu="$1"
+	local with_redirect="$2"
+	local desc="$3"
+
+	# From 172.16.1.101: icmp_seq=1 Redirect Host(New nexthop: 172.16.1.102)
+	if [ "$VERBOSE" = "1" ]; then
+		echo "Commands to check for exception:"
+		run_cmd ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP}
+		run_cmd ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6}
+	fi
+
+	if [ -n "${mtu}" ]; then
+		mtu=" mtu ${mtu}"
+	fi
+	if [ "$with_redirect" = "yes" ]; then
+		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
+		grep -q "cache <redirected> expires [0-9]*sec${mtu}"
+	elif [ -n "${mtu}" ]; then
+		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
+		grep -q "cache expires [0-9]*sec${mtu}"
+	else
+		ip -netns h1 ro get ${H1_VRF_ARG} ${H2_N2_IP} | \
+		grep -q "cache"
+	fi
+	log_test $? 0 "IPv4: ${desc}"
+
+	if [ "$with_redirect" = "yes" ]; then
+		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | grep -q "${H2_N2_IP6} from :: via ${R2_LLADDR} dev br0.*${mtu}"
+	else
+		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | grep -q "${mtu}"
+	fi
+	log_test $? 0 "IPv6: ${desc}"
+}
+
+run_ping()
+{
+	local sz=$1
+
+	run_cmd ip netns exec h1 ping -q -M want -i 0.2 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP}
+	run_cmd ip netns exec h1 ${ping6} -q -M want -i 0.2 -c 10 -w 2 -s ${sz} ${H1_PING_ARG} ${H2_N2_IP6}
+}
+
+replace_route_legacy()
+{
+	# r1 to h2 via r2 and eth0
+	run_cmd ip -netns r1    ro replace ${H2_N2}   via ${R2_N1_IP}  dev eth0
+	run_cmd ip -netns r1 -6 ro replace ${H2_N2_6} via ${R2_LLADDR} dev eth0
+}
+
+initial_route_legacy()
+{
+	# r1 to h2 via r2 and eth1
+	run_cmd ip -netns r1    ro add ${H2_N2}   via ${R2_R1_N1_IP}  dev eth1
+	run_cmd ip -netns r1 -6 ro add ${H2_N2_6} via ${R2_R1_N1_IP6} dev eth1
+
+	# h1 to h2 via r1
+	# - IPv6 redirect only works if gateway is the LLA
+	run_cmd ip -netns h1    ro add ${H1_VRF_ARG} ${H2_N2} via ${R1_N1_IP} dev br0
+	run_cmd ip -netns h1 -6 ro add ${H1_VRF_ARG} ${H2_N2_6} via ${R1_LLADDR} dev br0
+}
+
+check_connectivity()
+{
+	local rc
+
+	run_cmd ip netns exec h1 ping -c1 -w1 ${H1_PING_ARG} ${H2_N2_IP}
+	rc=$?
+	run_cmd ip netns exec h1 ${ping6} -c1 -w1 ${H1_PING_ARG} ${H2_N2_IP6}
+	[ $? -ne 0 ] && rc=$?
+
+	return $rc
+}
+
+do_test()
+{
+	local ttype="$1"
+
+	eval initial_route_${ttype}
+
+	# verify connectivity
+	check_connectivity
+	if [ $? -ne 0 ]; then
+		echo "Error: Basic connectivity is broken"
+		ret=1
+		return
+	fi
+
+	# redirect exception followed by mtu
+	eval replace_route_${ttype}
+	run_ping 64
+	check_exception "" "yes" "redirect exception"
+
+	check_connectivity
+	if [ $? -ne 0 ]; then
+		echo "Error: Basic connectivity is broken after redirect"
+		ret=1
+		return
+	fi
+
+	change_h2_mtu 1300
+	run_ping 1350
+	check_exception "1300" "yes" "redirect exception plus mtu"
+
+	# remove exceptions and restore routing
+	change_h2_mtu 1500
+	ip -netns h1 li set br0 down
+	ip -netns h1 li set br0 up
+	eval initial_route_${ttype}
+
+	check_connectivity
+	if [ $? -ne 0 ]; then
+		echo "Error: Basic connectivity is broken after reset"
+		ret=1
+		return
+	fi
+	check_exception "" "no" "routing reset"
+
+	# MTU exception followed by redirect
+	change_h2_mtu 1300
+	run_ping 1350
+	check_exception "1300" "no" "mtu exception"
+
+	eval replace_route_${ttype}
+	run_ping 64
+	check_exception "1300" "yes" "mtu exception plus redirect"
+
+	check_connectivity
+	if [ $? -ne 0 ]; then
+		echo "Error: Basic connectivity is broken after redirect"
+		ret=1
+		return
+	fi
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
+	-p          Pause on fail
+	-v          verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# main
+
+# Some systems don't have a ping6 binary anymore
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
+ret=0
+nsuccess=0
+nfail=0
+
+while getopts :pv o
+do
+	case $o in
+                p) PAUSE_ON_FAIL=yes;;
+                v) VERBOSE=$(($VERBOSE + 1));;
+                *) usage; exit 1;;
+	esac
+done
+
+trap cleanup EXIT
+
+cleanup
+WITH_VRF=no
+setup
+
+log_section "Legacy routing"
+do_test "legacy"
+
+cleanup
+log_section "Legacy routing with VRF"
+WITH_VRF=yes
+setup
+do_test "legacy"
+
+printf "\nTests passed: %3d\n" ${nsuccess}
+printf "Tests failed: %3d\n"   ${nfail}
+
+exit $ret
-- 
2.11.0

