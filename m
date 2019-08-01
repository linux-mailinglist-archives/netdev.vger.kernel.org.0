Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB957E2C2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387930AbfHASzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732969AbfHASzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EBE2087E;
        Thu,  1 Aug 2019 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685712;
        bh=9o6a9xledfK9oLnZ30AHSfvs7wXUfWdJJcnsn88kMrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eu1aL0q23jwWsmBfHrP8boPVYI7VHRmDDv9b+mU1+ZUmUXjepl9KWAw/1sp4L5/24
         VeHgvd4VB82rR5opEJYv4BRfTvwxyWynBmpDv1rL+OuSUX55lNBqj1bcOCyPwiMotu
         +oO9ihFo9sVlRzvybnE7KrAyvZbKmOHFgDroK1is=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 02/15] selftests: Setup for functional tests for fib and socket lookups
Date:   Thu,  1 Aug 2019 11:56:35 -0700
Message-Id: <20190801185648.27653-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Initial commit for functional test suite for fib and socket lookups.
This commit contains the namespace setup, networking config, test options
and other basic infrastructure.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/Makefile      |   2 +-
 tools/testing/selftests/net/fcnal-test.sh | 520 ++++++++++++++++++++++++++++++
 2 files changed, 521 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/fcnal-test.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ba9ee36c9e94..70f2d6656170 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -10,7 +10,7 @@ TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
-TEST_PROGS += tcp_fastopen_backup_key.sh
+TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
new file mode 100755
index 000000000000..22cfbd2fd09c
--- /dev/null
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -0,0 +1,520 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2019 David Ahern <dsahern@gmail.com>. All rights reserved.
+#
+# IPv4 and IPv6 functional tests focusing on VRF and routing lookups
+# for various permutations:
+#   1. icmp, tcp, udp and netfilter
+#   2. client, server, no-server
+#   3. global address on interface
+#   4. global address on 'lo'
+#   5. remote and local traffic
+#   6. VRF and non-VRF permutations
+#
+# Setup:
+#                     ns-A     |     ns-B
+# No VRF case:
+#    [ lo ]         [ eth1 ]---|---[ eth1 ]      [ lo ]
+#                                                remote address
+# VRF case:
+#         [ red ]---[ eth1 ]---|---[ eth1 ]      [ lo ]
+#
+# ns-A:
+#     eth1: 172.16.1.1/24, 2001:db8:1::1/64
+#       lo: 127.0.0.1/8, ::1/128
+#           172.16.2.1/32, 2001:db8:2::1/128
+#      red: 127.0.0.1/8, ::1/128
+#           172.16.3.1/32, 2001:db8:3::1/128
+#
+# ns-B:
+#     eth1: 172.16.1.2/24, 2001:db8:1::2/64
+#      lo2: 127.0.0.1/8, ::1/128
+#           172.16.2.2/32, 2001:db8:2::2/128
+#
+# server / client nomenclature relative to ns-A
+
+VERBOSE=0
+
+NSA_DEV=eth1
+NSB_DEV=eth1
+VRF=red
+VRF_TABLE=1101
+
+# IPv4 config
+NSA_IP=172.16.1.1
+NSB_IP=172.16.1.2
+VRF_IP=172.16.3.1
+
+# IPv6 config
+NSA_IP6=2001:db8:1::1
+NSB_IP6=2001:db8:1::2
+VRF_IP6=2001:db8:3::1
+
+NSA_LO_IP=172.16.2.1
+NSB_LO_IP=172.16.2.2
+NSA_LO_IP6=2001:db8:2::1
+NSB_LO_IP6=2001:db8:2::2
+
+MCAST=ff02::1
+# set after namespace create
+NSA_LINKIP6=
+NSB_LINKIP6=
+
+NSA=ns-A
+NSB=ns-B
+
+NSA_CMD="ip netns exec ${NSA}"
+NSB_CMD="ip netns exec ${NSB}"
+
+which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
+
+################################################################################
+# utilities
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	[ "${VERBOSE}" = "1" ] && echo
+
+	if [ ${rc} -eq ${expected} ]; then
+		nsuccess=$((nsuccess+1))
+		printf "TEST: %-70s  [ OK ]\n" "${msg}"
+	else
+		nfail=$((nfail+1))
+		printf "TEST: %-70s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+
+	kill_procs
+}
+
+log_test_addr()
+{
+	local addr=$1
+	local rc=$2
+	local expected=$3
+	local msg="$4"
+	local astr
+
+	astr=$(addr2str ${addr})
+	log_test $rc $expected "$msg - ${astr}"
+}
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
+log_subsection()
+{
+	echo
+	echo "#################################################################"
+	echo "$*"
+	echo
+}
+
+log_start()
+{
+	# make sure we have no test instances running
+	kill_procs
+
+	if [ "${VERBOSE}" = "1" ]; then
+		echo
+		echo "#######################################################"
+	fi
+}
+
+log_debug()
+{
+	if [ "${VERBOSE}" = "1" ]; then
+		echo
+		echo "$*"
+		echo
+	fi
+}
+
+show_hint()
+{
+	if [ "${VERBOSE}" = "1" ]; then
+		echo "HINT: $*"
+		echo
+	fi
+}
+
+kill_procs()
+{
+	killall nettest ping ping6 >/dev/null 2>&1
+	sleep 1
+}
+
+do_run_cmd()
+{
+	local cmd="$*"
+	local out
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "COMMAND: ${cmd}"
+	fi
+
+	out=$($cmd 2>&1)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "$out"
+	fi
+
+	return $rc
+}
+
+run_cmd()
+{
+	do_run_cmd ${NSA_CMD} $*
+}
+
+run_cmd_nsb()
+{
+	do_run_cmd ${NSB_CMD} $*
+}
+
+setup_cmd()
+{
+	local cmd="$*"
+	local rc
+
+	run_cmd ${cmd}
+	rc=$?
+	if [ $rc -ne 0 ]; then
+		# show user the command if not done so already
+		if [ "$VERBOSE" = "0" ]; then
+			echo "setup command: $cmd"
+		fi
+		echo "failed. stopping tests"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue"
+			read a
+		fi
+		exit $rc
+	fi
+}
+
+setup_cmd_nsb()
+{
+	local cmd="$*"
+	local rc
+
+	run_cmd_nsb ${cmd}
+	rc=$?
+	if [ $rc -ne 0 ]; then
+		# show user the command if not done so already
+		if [ "$VERBOSE" = "0" ]; then
+			echo "setup command: $cmd"
+		fi
+		echo "failed. stopping tests"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue"
+			read a
+		fi
+		exit $rc
+	fi
+}
+
+# set sysctl values in NS-A
+set_sysctl()
+{
+	echo "SYSCTL: $*"
+	echo
+	run_cmd sysctl -q -w $*
+}
+
+################################################################################
+# Setup for tests
+
+addr2str()
+{
+	case "$1" in
+	127.0.0.1) echo "loopback";;
+	::1) echo "IPv6 loopback";;
+
+	${NSA_IP})	echo "ns-A IP";;
+	${NSA_IP6})	echo "ns-A IPv6";;
+	${NSA_LO_IP})	echo "ns-A loopback IP";;
+	${NSA_LO_IP6})	echo "ns-A loopback IPv6";;
+	${NSA_LINKIP6}|${NSA_LINKIP6}%*) echo "ns-A IPv6 LLA";;
+
+	${NSB_IP})	echo "ns-B IP";;
+	${NSB_IP6})	echo "ns-B IPv6";;
+	${NSB_LO_IP})	echo "ns-B loopback IP";;
+	${NSB_LO_IP6})	echo "ns-B loopback IPv6";;
+	${NSB_LINKIP6}|${NSB_LINKIP6}%*) echo "ns-B IPv6 LLA";;
+
+	${VRF_IP})	echo "VRF IP";;
+	${VRF_IP6})	echo "VRF IPv6";;
+
+	${MCAST}%*)	echo "multicast IP";;
+
+	*) echo "unknown";;
+	esac
+}
+
+get_linklocal()
+{
+	local ns=$1
+	local dev=$2
+	local addr
+
+	addr=$(ip -netns ${ns} -6 -br addr show dev ${dev} | \
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
+# create namespaces and vrf
+
+create_vrf()
+{
+	local ns=$1
+	local vrf=$2
+	local table=$3
+	local addr=$4
+	local addr6=$5
+
+	ip -netns ${ns} link add ${vrf} type vrf table ${table}
+	ip -netns ${ns} link set ${vrf} up
+	ip -netns ${ns} route add vrf ${vrf} unreachable default metric 8192
+	ip -netns ${ns} -6 route add vrf ${vrf} unreachable default metric 8192
+
+	ip -netns ${ns} addr add 127.0.0.1/8 dev ${vrf}
+	ip -netns ${ns} -6 addr add ::1 dev ${vrf} nodad
+	if [ "${addr}" != "-" ]; then
+		ip -netns ${ns} addr add dev ${vrf} ${addr}
+	fi
+	if [ "${addr6}" != "-" ]; then
+		ip -netns ${ns} -6 addr add dev ${vrf} ${addr6}
+	fi
+
+	ip -netns ${ns} ru del pref 0
+	ip -netns ${ns} ru add pref 32765 from all lookup local
+	ip -netns ${ns} -6 ru del pref 0
+	ip -netns ${ns} -6 ru add pref 32765 from all lookup local
+}
+
+create_ns()
+{
+	local ns=$1
+	local addr=$2
+	local addr6=$3
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
+cleanup()
+{
+	# explicit cleanups to check those code paths
+	ip netns | grep -q ${NSA}
+	if [ $? -eq 0 ]; then
+		ip -netns ${NSA} link delete ${VRF}
+		ip -netns ${NSA} ro flush table ${VRF_TABLE}
+
+		ip -netns ${NSA} addr flush dev ${NSA_DEV}
+		ip -netns ${NSA} -6 addr flush dev ${NSA_DEV}
+		ip -netns ${NSA} link set dev ${NSA_DEV} down
+		ip -netns ${NSA} link del dev ${NSA_DEV}
+
+		ip netns del ${NSA}
+	fi
+
+	ip netns del ${NSB}
+}
+
+setup()
+{
+	local with_vrf=${1}
+
+	# make sure we are starting with a clean slate
+	kill_procs
+	cleanup 2>/dev/null
+
+	log_debug "Configuring network namespaces"
+	set -e
+
+	create_ns ${NSA} ${NSA_LO_IP}/32 ${NSA_LO_IP6}/128
+	create_ns ${NSB} ${NSB_LO_IP}/32 ${NSB_LO_IP6}/128
+	connect_ns ${NSA} ${NSA_DEV} ${NSA_IP}/24 ${NSA_IP6}/64 \
+		   ${NSB} ${NSB_DEV} ${NSB_IP}/24 ${NSB_IP6}/64
+
+	NSA_LINKIP6=$(get_linklocal ${NSA} ${NSA_DEV})
+	NSB_LINKIP6=$(get_linklocal ${NSB} ${NSB_DEV})
+
+	# tell ns-A how to get to remote addresses of ns-B
+	if [ "${with_vrf}" = "yes" ]; then
+		create_vrf ${NSA} ${VRF} ${VRF_TABLE} ${VRF_IP} ${VRF_IP6}
+
+		ip -netns ${NSA} link set dev ${NSA_DEV} vrf ${VRF}
+		ip -netns ${NSA} ro add vrf ${VRF} ${NSB_LO_IP}/32 via ${NSB_IP} dev ${NSA_DEV}
+		ip -netns ${NSA} -6 ro add vrf ${VRF} ${NSB_LO_IP6}/128 via ${NSB_IP6} dev ${NSA_DEV}
+
+		ip -netns ${NSB} ro add ${VRF_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
+		ip -netns ${NSB} -6 ro add ${VRF_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
+	else
+		ip -netns ${NSA} ro add ${NSB_LO_IP}/32 via ${NSB_IP} dev ${NSA_DEV}
+		ip -netns ${NSA} ro add ${NSB_LO_IP6}/128 via ${NSB_IP6} dev ${NSA_DEV}
+	fi
+
+
+	# tell ns-B how to get to remote addresses of ns-A
+	ip -netns ${NSB} ro add ${NSA_LO_IP}/32 via ${NSA_IP} dev ${NSB_DEV}
+	ip -netns ${NSB} ro add ${NSA_LO_IP6}/128 via ${NSA_IP6} dev ${NSB_DEV}
+
+	set +e
+
+	sleep 1
+}
+
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+	-4          IPv4 tests only
+	-6          IPv6 tests only
+	-t <test>   Test name/set to run
+	-p          Pause on fail
+	-P          Pause after each test
+	-v          Be verbose
+EOF
+}
+
+################################################################################
+# main
+
+TESTS_IPV4=""
+TESTS_IPV6=""
+PAUSE_ON_FAIL=no
+PAUSE=no
+
+while getopts :46t:pPvh o
+do
+	case $o in
+		4) TESTS=ipv4;;
+		6) TESTS=ipv6;;
+		t) TESTS=$OPTARG;;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=1;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# make sure we don't pause twice
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+#
+# show user test config
+#
+if [ -z "$TESTS" ]; then
+	TESTS="$TESTS_IPV4 $TESTS_IPV6 $TESTS_OTHER"
+elif [ "$TESTS" = "ipv4" ]; then
+	TESTS="$TESTS_IPV4"
+elif [ "$TESTS" = "ipv6" ]; then
+	TESTS="$TESTS_IPV6"
+fi
+
+declare -i nfail=0
+declare -i nsuccess=0
+
+for t in $TESTS
+do
+	case $t in
+	# setup namespaces and config, but do not run any tests
+	setup)		 setup; exit 0;;
+	vrf_setup)	 setup "yes"; exit 0;;
+
+	help)            echo "Test names: $TESTS"; exit 0;;
+	esac
+done
+
+cleanup 2>/dev/null
+
+printf "\nTests passed: %3d\n" ${nsuccess}
+printf "Tests failed: %3d\n"   ${nfail}
-- 
2.11.0

