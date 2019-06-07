Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F26D39953
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbfFGXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731394AbfFGXGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 19:06:17 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 198A121670;
        Fri,  7 Jun 2019 23:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559948777;
        bh=vQLp9DD++oINzF5qe8zhaM73Q1ZtQS1Hocnu1l+UavE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vs7b93vFaqWnbepjBhNLY0YZHyV19tCDg5X7pcnZiz2OKLN8fm0QtdYAWkwvYWn6O
         qQ3MmxinvlbmCHlkDpkqK5gmbRxiUEcJstK2PXBVTXxPTyMba1F0sB1f964BXAosnC
         bgZPCdKohjFBrxCZroQ3Hul0bUpdZckl8/0sm/uE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 19/20] selftests: Add test with multiple prefixes using single nexthop
Date:   Fri,  7 Jun 2019 16:06:09 -0700
Message-Id: <20190607230610.10349-20-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607230610.10349-1-dsahern@kernel.org>
References: <20190607230610.10349-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add tests where multiple FIB entries use the same nexthop object. Generate
per-cpu cached routes for each by running ping on each cpu, and then
generate exceptions unique to each prefix (remote host) with different
mtus.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 .../selftests/net/fib_nexthop_multiprefix.sh       | 290 +++++++++++++++++++++
 1 file changed, 290 insertions(+)
 create mode 100755 tools/testing/selftests/net/fib_nexthop_multiprefix.sh

diff --git a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
new file mode 100755
index 000000000000..e6828732843e
--- /dev/null
+++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
@@ -0,0 +1,290 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Validate cached routes in fib{6}_nh that is used by multiple prefixes.
+# Validate a different # exception is generated in h0 for each remote host.
+#
+#               h1
+#            /
+#    h0 - r1 -  h2
+#            \
+#               h3
+#
+# routing in h0 to hN is done with nexthop objects.
+
+PAUSE_ON_FAIL=no
+VERBOSE=0
+
+################################################################################
+# helpers
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
+
+	[ "$VERBOSE" = "1" ] && echo
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
+################################################################################
+# config
+
+create_ns()
+{
+	local ns=${1}
+
+	ip netns del ${ns} 2>/dev/null
+
+	ip netns add ${ns}
+	ip -netns ${ns} addr add 127.0.0.1/8 dev lo
+	ip -netns ${ns} link set lo up
+
+	ip netns exec ${ns} sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
+	case ${ns} in
+	h*)
+		ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=0
+		;;
+	r*)
+		ip netns exec $ns sysctl -q -w net.ipv4.ip_forward=1
+		ip netns exec $ns sysctl -q -w net.ipv6.conf.all.forwarding=1
+		;;
+	esac
+}
+
+setup()
+{
+	local ns
+	local i
+
+	#set -e
+
+	for ns in h0 r1 h1 h2 h3
+	do
+		create_ns ${ns}
+	done
+
+	#
+	# create interconnects
+	#
+
+	for i in 0 1 2 3
+	do
+		ip -netns h${i} li add eth0 type veth peer name r1h${i}
+		ip -netns h${i} li set eth0 up
+		ip -netns h${i} li set r1h${i} netns r1 name eth${i} up
+
+		ip -netns h${i}    addr add dev eth0 172.16.10${i}.1/24
+		ip -netns h${i} -6 addr add dev eth0 2001:db8:10${i}::1/64
+		ip -netns r1    addr add dev eth${i} 172.16.10${i}.254/24
+		ip -netns r1 -6 addr add dev eth${i} 2001:db8:10${i}::64/64
+	done
+
+	ip -netns h0 nexthop add id 4 via 172.16.100.254 dev eth0
+	ip -netns h0 nexthop add id 6 via 2001:db8:100::64 dev eth0
+
+	# routing from h0 to h1-h3 and back
+	for i in 1 2 3
+	do
+		ip -netns h0    ro add 172.16.10${i}.0/24 nhid 4
+		ip -netns h${i} ro add 172.16.100.0/24 via 172.16.10${i}.254
+
+		ip -netns h0    -6 ro add 2001:db8:10${i}::/64 nhid 6
+		ip -netns h${i} -6 ro add 2001:db8:100::/64 via 2001:db8:10${i}::64
+	done
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo
+		echo "host 1 config"
+		ip -netns h0 li sh
+		ip -netns h0 ro sh
+		ip -netns h0 -6 ro sh
+	fi
+
+	#set +e
+}
+
+cleanup()
+{
+	for n in h1 r1 h2 h3 h4
+	do
+		ip netns del ${n} 2>/dev/null
+	done
+}
+
+change_mtu()
+{
+	local hostid=$1
+	local mtu=$2
+
+	run_cmd ip -netns h${hostid} li set eth0 mtu ${mtu}
+	run_cmd ip -netns r1 li set eth${hostid} mtu ${mtu}
+}
+
+################################################################################
+# validate exceptions
+
+validate_v4_exception()
+{
+	local i=$1
+	local mtu=$2
+	local ping_sz=$3
+	local dst="172.16.10${i}.1"
+	local h0=172.16.100.1
+	local r1=172.16.100.254
+	local rc
+
+	if [ ${ping_sz} != "0" ]; then
+		run_cmd ip netns exec h0 ping -s ${ping_sz} -c5 -w5 ${dst}
+	fi
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "Route get"
+		ip -netns h0 ro get ${dst}
+		echo "Searching for:"
+		echo "    cache .* mtu ${mtu}"
+		echo
+	fi
+
+	ip -netns h0 ro get ${dst} | \
+	grep -q "cache .* mtu ${mtu}"
+	rc=$?
+
+	log_test $rc 0 "IPv4: host 0 to host ${i}, mtu ${mtu}"
+}
+
+validate_v6_exception()
+{
+	local i=$1
+	local mtu=$2
+	local ping_sz=$3
+	local dst="2001:db8:10${i}::1"
+	local h0=2001:db8:100::1
+	local r1=2001:db8:100::64
+	local rc
+
+	if [ ${ping_sz} != "0" ]; then
+		run_cmd ip netns exec h0 ping6 -s ${ping_sz} -c5 -w5 ${dst}
+	fi
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "Route get"
+		ip -netns h0 -6 ro get ${dst}
+		echo "Searching for:"
+		echo "    ${dst} from :: via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
+		echo
+	fi
+
+	ip -netns h0 -6 ro get ${dst} | \
+	grep -q "${dst} from :: via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
+	rc=$?
+
+	log_test $rc 0 "IPv6: host 0 to host ${i}, mtu ${mtu}"
+}
+
+################################################################################
+# main
+
+while getopts :pv o
+do
+	case $o in
+		p) PAUSE_ON_FAIL=yes;;
+		v) VERBOSE=1;;
+	esac
+done
+
+cleanup
+setup
+sleep 2
+
+cpus=$(cat  /sys/devices/system/cpu/online)
+cpus="$(seq ${cpus/-/ })"
+ret=0
+for i in 1 2 3
+do
+	# generate a cached route per-cpu
+	for c in ${cpus}; do
+		run_cmd taskset -c ${c} ip netns exec h0 ping -c1 -w1 172.16.10${i}.1
+		[ $? -ne 0 ] && printf "\nERROR: ping to h${i} failed\n" && ret=1
+
+		run_cmd taskset -c ${c} ip netns exec h0 ping6 -c1 -w1 2001:db8:10${i}::1
+		[ $? -ne 0 ] && printf "\nERROR: ping6 to h${i} failed\n" && ret=1
+
+		[ $ret -ne 0 ] && break
+	done
+	[ $ret -ne 0 ] && break
+done
+
+if [ $ret -eq 0 ]; then
+	# generate different exceptions in h0 for h1, h2 and h3
+	change_mtu 1 1300
+	validate_v4_exception 1 1300 1350
+	validate_v6_exception 1 1300 1350
+	echo
+
+	change_mtu 2 1350
+	validate_v4_exception 2 1350 1400
+	validate_v6_exception 2 1350 1400
+	echo
+
+	change_mtu 3 1400
+	validate_v4_exception 3 1400 1450
+	validate_v6_exception 3 1400 1450
+	echo
+
+	validate_v4_exception 1 1300 0
+	validate_v6_exception 1 1300 0
+	echo
+
+	validate_v4_exception 2 1350 0
+	validate_v6_exception 2 1350 0
+	echo
+
+	validate_v4_exception 3 1400 0
+	validate_v6_exception 3 1400 0
+
+	# targeted deletes to trigger cleanup paths in kernel
+	ip -netns h0 ro del 172.16.102.0/24 nhid 4
+	ip -netns h0 -6 ro del 2001:db8:102::/64 nhid 6
+
+	ip -netns h0 nexthop del id 4
+	ip -netns h0 nexthop del id 6
+fi
+
+cleanup
-- 
2.11.0

