Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484213BEBEB
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhGGQVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55106 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhGGQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EE7F16243D;
        Wed,  7 Jul 2021 18:18:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 01/11] selftest: netfilter: add test case for unreplied tcp connections
Date:   Wed,  7 Jul 2021 18:18:34 +0200
Message-Id: <20210707161844.20827-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TCP connections in UNREPLIED state (only SYN seen) can be kept alive
indefinitely, as each SYN re-sets the timeout.

This means that even if a peer has closed its socket the entry
never times out.

This also prevents re-evaluation of configured NAT rules.
Add a test case that sets SYN timeout to 10 seconds, then check
that the nat redirection added later eventually takes effect.

This is based off a repro script from Antonio Ojea.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../netfilter/conntrack_tcp_unreplied.sh      | 167 ++++++++++++++++++
 2 files changed, 168 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index cd6430b39982..8748199ac109 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -5,7 +5,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
 	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh nft_meta.sh nf_nat_edemux.sh \
-	ipip-conntrack-mtu.sh
+	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh
 
 LDLIBS = -lmnl
 TEST_GEN_FILES =  nf-queue
diff --git a/tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh b/tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh
new file mode 100755
index 000000000000..e7d7bf13cff5
--- /dev/null
+++ b/tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh
@@ -0,0 +1,167 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Check that UNREPLIED tcp conntrack will eventually timeout.
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+waittime=20
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
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
+cleanup() {
+	ip netns pids $ns1 | xargs kill 2>/dev/null
+	ip netns pids $ns2 | xargs kill 2>/dev/null
+
+	ip netns del $ns1
+	ip netns del $ns2
+}
+
+ipv4() {
+    echo -n 192.168.$1.2
+}
+
+check_counter()
+{
+	ns=$1
+	name=$2
+	expect=$3
+	local lret=0
+
+	cnt=$(ip netns exec $ns2 nft list counter inet filter "$name" | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		echo "ERROR: counter $name in $ns2 has unexpected value (expected $expect)" 1>&2
+		ip netns exec $ns2 nft list counter inet filter "$name" 1>&2
+		lret=1
+	fi
+
+	return $lret
+}
+
+# Create test namespaces
+ip netns add $ns1 || exit 1
+
+trap cleanup EXIT
+
+ip netns add $ns2 || exit 1
+
+# Connect the namespace to the host using a veth pair
+ip -net $ns1 link add name veth1 type veth peer name veth2
+ip -net $ns1 link set netns $ns2 dev veth2
+
+ip -net $ns1 link set up dev lo
+ip -net $ns2 link set up dev lo
+ip -net $ns1 link set up dev veth1
+ip -net $ns2 link set up dev veth2
+
+ip -net $ns2 addr add 10.11.11.2/24 dev veth2
+ip -net $ns2 route add default via 10.11.11.1
+
+ip netns exec $ns2 sysctl -q net.ipv4.conf.veth2.forwarding=1
+
+# add a rule inside NS so we enable conntrack
+ip netns exec $ns1 iptables -A INPUT -m state --state established,related -j ACCEPT
+
+ip -net $ns1 addr add 10.11.11.1/24 dev veth1
+ip -net $ns1 route add 10.99.99.99 via 10.11.11.2
+
+# Check connectivity works
+ip netns exec $ns1 ping -q -c 2 10.11.11.2 >/dev/null || exit 1
+
+ip netns exec $ns2 nc -l -p 8080 < /dev/null &
+
+# however, conntrack entries are there
+
+ip netns exec $ns2 nft -f - <<EOF
+table inet filter {
+	counter connreq { }
+	counter redir { }
+	chain input {
+		type filter hook input priority 0; policy accept;
+		ct state new tcp flags syn ip daddr 10.99.99.99 tcp dport 80 counter name "connreq" accept
+		ct state new ct status dnat tcp dport 8080 counter name "redir" accept
+	}
+}
+EOF
+if [ $? -ne 0 ]; then
+	echo "ERROR: Could not load nft rules"
+	exit 1
+fi
+
+ip netns exec $ns2 sysctl -q net.netfilter.nf_conntrack_tcp_timeout_syn_sent=10
+
+echo "INFO: connect $ns1 -> $ns2 to the virtual ip"
+ip netns exec $ns1 bash -c 'while true ; do
+	nc -p 60000 10.99.99.99 80
+	sleep 1
+	done' &
+
+sleep 1
+
+ip netns exec $ns2 nft -f - <<EOF
+table inet nat {
+	chain prerouting {
+		type nat hook prerouting priority 0; policy accept;
+		ip daddr 10.99.99.99 tcp dport 80 redirect to :8080
+	}
+}
+EOF
+if [ $? -ne 0 ]; then
+	echo "ERROR: Could not load nat redirect"
+	exit 1
+fi
+
+count=$(ip netns exec $ns2 conntrack -L -p tcp --dport 80 2>/dev/null | wc -l)
+if [ $count -eq 0 ]; then
+	echo "ERROR: $ns2 did not pick up tcp connection from peer"
+	exit 1
+fi
+
+echo "INFO: NAT redirect added in ns $ns2, waiting for $waittime seconds for nat to take effect"
+for i in $(seq 1 $waittime); do
+	echo -n "."
+
+	sleep 1
+
+	count=$(ip netns exec $ns2 conntrack -L -p tcp --reply-port-src 8080 2>/dev/null | wc -l)
+	if [ $count -gt 0 ]; then
+		echo
+		echo "PASS: redirection took effect after $i seconds"
+		break
+	fi
+
+	m=$((i%20))
+	if [ $m -eq 0 ]; then
+		echo " waited for $i seconds"
+	fi
+done
+
+expect="packets 1 bytes 60"
+check_counter "$ns2" "redir" "$expect"
+if [ $? -ne 0 ]; then
+	ret=1
+fi
+
+if [ $ret -eq 0 ];then
+	echo "PASS: redirection counter has expected values"
+else
+	echo "ERROR: no tcp connection was redirected"
+fi
+
+exit $ret
-- 
2.20.1

