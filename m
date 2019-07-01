Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED22028C6C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbfEWVgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:06 -0400
Received: from mail.us.es ([193.147.175.20]:46970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388331AbfEWVgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:36:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FF24C1A70
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:36:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B95ADA708
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:36:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31533DA70C; Thu, 23 May 2019 23:36:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8A66DA704;
        Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 991374265A32;
        Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/11] selftests: netfilter: add flowtable test script
Date:   Thu, 23 May 2019 23:35:47 +0200
Message-Id: <20190523213547.15523-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Exercises 3 cases:

1. no pmtu discovery (need to frag)
2. no PMTUd + NAT (don't flag packets as invalid from conntrack)
3. PMTU + NAT (need to send icmp error)

The first two cases make sure we handle fragments correctly, i.e.
pass them to classic forwarding path.

Third case checks we offload everything (in the test case,
PMTUd will kick in so all packets should be within link mtu).

Nftables rules will filter packets that are supposed to be
handled by the fast-path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 324 +++++++++++++++++++++
 2 files changed, 325 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_flowtable.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 3e6d1bcc2894..4144984ebee5 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -2,6 +2,6 @@
 # Makefile for netfilter selftests
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
-	conntrack_icmp_related.sh
+	conntrack_icmp_related.sh nft_flowtable.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
new file mode 100755
index 000000000000..fe52488a6f72
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -0,0 +1,324 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This tests basic flowtable functionality.
+# Creates following topology:
+#
+# Originator (MTU 9000) <-Router1-> MTU 1500 <-Router2-> Responder (MTU 2000)
+# Router1 is the one doing flow offloading, Router2 has no special
+# purpose other than having a link that is smaller than either Originator
+# and responder, i.e. TCPMSS announced values are too large and will still
+# result in fragmentation and/or PMTU discovery.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+ns1in=""
+ns2in=""
+ns1out=""
+ns2out=""
+
+log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+which nc > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nc (netcat)"
+	exit $ksft_skip
+fi
+
+ip netns add nsr1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace"
+	exit $ksft_skip
+fi
+
+ip netns add ns1
+ip netns add ns2
+
+ip netns add nsr2
+
+cleanup() {
+	for i in 1 2; do
+		ip netns del ns$i
+		ip netns del nsr$i
+	done
+
+	rm -f "$ns1in" "$ns1out"
+	rm -f "$ns2in" "$ns2out"
+
+	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
+}
+
+trap cleanup EXIT
+
+sysctl -q net.netfilter.nf_log_all_netns=1
+
+ip link add veth0 netns nsr1 type veth peer name eth0 netns ns1
+ip link add veth1 netns nsr1 type veth peer name veth0 netns nsr2
+
+ip link add veth1 netns nsr2 type veth peer name eth0 netns ns2
+
+for dev in lo veth0 veth1; do
+  for i in 1 2; do
+    ip -net nsr$i link set $dev up
+  done
+done
+
+ip -net nsr1 addr add 10.0.1.1/24 dev veth0
+ip -net nsr1 addr add dead:1::1/64 dev veth0
+
+ip -net nsr2 addr add 10.0.2.1/24 dev veth1
+ip -net nsr2 addr add dead:2::1/64 dev veth1
+
+# set different MTUs so we need to push packets coming from ns1 (large MTU)
+# to ns2 (smaller MTU) to stack either to perform fragmentation (ip_no_pmtu_disc=1),
+# or to do PTMU discovery (send ICMP error back to originator).
+# ns2 is going via nsr2 with a smaller mtu, so that TCPMSS announced by both peers
+# is NOT the lowest link mtu.
+
+ip -net nsr1 link set veth0 mtu 9000
+ip -net ns1 link set eth0 mtu 9000
+
+ip -net nsr2 link set veth1 mtu 2000
+ip -net ns2 link set eth0 mtu 2000
+
+# transfer-net between nsr1 and nsr2.
+# these addresses are not used for connections.
+ip -net nsr1 addr add 192.168.10.1/24 dev veth1
+ip -net nsr1 addr add fee1:2::1/64 dev veth1
+
+ip -net nsr2 addr add 192.168.10.2/24 dev veth0
+ip -net nsr2 addr add fee1:2::2/64 dev veth0
+
+for i in 1 2; do
+  ip netns exec nsr$i sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+  ip netns exec nsr$i sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+  ip -net ns$i link set lo up
+  ip -net ns$i link set eth0 up
+  ip -net ns$i addr add 10.0.$i.99/24 dev eth0
+  ip -net ns$i route add default via 10.0.$i.1
+  ip -net ns$i addr add dead:$i::99/64 dev eth0
+  ip -net ns$i route add default via dead:$i::1
+  ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null
+
+  # don't set ip DF bit for first two tests
+  ip netns exec ns$i sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
+done
+
+ip -net nsr1 route add default via 192.168.10.2
+ip -net nsr2 route add default via 192.168.10.1
+
+ip netns exec nsr1 nft -f - <<EOF
+table inet filter {
+  flowtable f1 {
+     hook ingress priority 0
+     devices = { veth0, veth1 }
+   }
+
+   chain forward {
+      type filter hook forward priority 0; policy drop;
+
+      # flow offloaded? Tag ct with mark 1, so we can detect when it fails.
+      meta oif "veth1" tcp dport 12345 flow offload @f1 counter
+
+      # use packet size to trigger 'should be offloaded by now'.
+      # otherwise, if 'flow offload' expression never offloads, the
+      # test will pass.
+      tcp dport 12345 meta length gt 200 ct mark set 1 counter
+
+      # this turns off flow offloading internally, so expect packets again
+      tcp flags fin,rst ct mark set 0 accept
+
+      # this allows large packets from responder, we need this as long
+      # as PMTUd is off.
+      # This rule is deleted for the last test, when we expect PMTUd
+      # to kick in and ensure all packets meet mtu requirements.
+      meta length gt 1500 accept comment something-to-grep-for
+
+      # next line blocks connection w.o. working offload.
+      # we only do this for reverse dir, because we expect packets to
+      # enter slow path due to MTU mismatch of veth0 and veth1.
+      tcp sport 12345 ct mark 1 counter log prefix "mark failure " drop
+
+      ct state established,related accept
+
+      # for packets that we can't offload yet, i.e. SYN (any ct that is not confirmed)
+      meta length lt 200 oif "veth1" tcp dport 12345 counter accept
+
+      meta nfproto ipv4 meta l4proto icmp accept
+      meta nfproto ipv6 meta l4proto icmpv6 accept
+   }
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not load nft ruleset"
+	exit $ksft_skip
+fi
+
+# test basic connectivity
+ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
+if [ $? -ne 0 ];then
+  echo "ERROR: ns1 cannot reach ns2" 1>&2
+  bash
+  exit 1
+fi
+
+ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null
+if [ $? -ne 0 ];then
+  echo "ERROR: ns2 cannot reach ns1" 1>&2
+  exit 1
+fi
+
+if [ $ret -eq 0 ];then
+	echo "PASS: netns routing/connectivity: ns1 can reach ns2"
+fi
+
+ns1in=$(mktemp)
+ns1out=$(mktemp)
+ns2in=$(mktemp)
+ns2out=$(mktemp)
+
+make_file()
+{
+	name=$1
+	who=$2
+
+	SIZE=$((RANDOM % (1024 * 8)))
+	TSIZE=$((SIZE * 1024))
+
+	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+
+	SIZE=$((RANDOM % 1024))
+	SIZE=$((SIZE + 128))
+	TSIZE=$((TSIZE + SIZE))
+	dd if=/dev/urandom conf=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
+}
+
+check_transfer()
+{
+	in=$1
+	out=$2
+	what=$3
+
+	cmp "$in" "$out" > /dev/null 2>&1
+	if [ $? -ne 0 ] ;then
+		echo "FAIL: file mismatch for $what" 1>&2
+		ls -l "$in"
+		ls -l "$out"
+		return 1
+	fi
+
+	return 0
+}
+
+test_tcp_forwarding()
+{
+	local nsa=$1
+	local nsb=$2
+	local lret=0
+
+	ip netns exec $nsb nc -w 5 -l -p 12345 < "$ns2in" > "$ns2out" &
+	lpid=$!
+
+	sleep 1
+	ip netns exec $nsa nc -w 4 10.0.2.99 12345 < "$ns1in" > "$ns1out" &
+	cpid=$!
+
+	sleep 3
+
+	kill $lpid
+	kill $cpid
+	wait
+
+	check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"
+	if [ $? -ne 0 ];then
+		lret=1
+	fi
+
+	check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"
+	if [ $? -ne 0 ];then
+		lret=1
+	fi
+
+	return $lret
+}
+
+make_file "$ns1in" "ns1"
+make_file "$ns2in" "ns2"
+
+# First test:
+# No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
+test_tcp_forwarding ns1 ns2
+if [ $? -eq 0 ] ;then
+	echo "PASS: flow offloaded for ns1/ns2"
+else
+	echo "FAIL: flow offload for ns1/ns2:" 1>&2
+	ip netns exec nsr1 nft list ruleset
+	ret=1
+fi
+
+# delete default route, i.e. ns2 won't be able to reach ns1 and
+# will depend on ns1 being masqueraded in nsr1.
+# expect ns1 has nsr1 address.
+ip -net ns2 route del default via 10.0.2.1
+ip -net ns2 route del default via dead:2::1
+ip -net ns2 route add 192.168.10.1 via 10.0.2.1
+
+# Second test:
+# Same, but with NAT enabled.
+ip netns exec nsr1 nft -f - <<EOF
+table ip nat {
+   chain postrouting {
+      type nat hook postrouting priority 0; policy accept;
+      meta oifname "veth1" masquerade
+   }
+}
+EOF
+
+test_tcp_forwarding ns1 ns2
+
+if [ $? -eq 0 ] ;then
+	echo "PASS: flow offloaded for ns1/ns2 with NAT"
+else
+	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
+	ip netns exec nsr1 nft list ruleset
+	ret=1
+fi
+
+# Third test:
+# Same as second test, but with PMTU discovery enabled.
+handle=$(ip netns exec nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
+
+ip netns exec nsr1 nft delete rule inet filter forward $handle
+if [ $? -ne 0 ] ;then
+	echo "FAIL: Could not delete large-packet accept rule"
+	exit 1
+fi
+
+ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+
+test_tcp_forwarding ns1 ns2
+if [ $? -eq 0 ] ;then
+	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
+else
+	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
+	ip netns exec nsr1 nft list ruleset
+fi
+
+exit $ret
-- 
2.11.0

