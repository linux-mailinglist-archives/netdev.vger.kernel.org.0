Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0564597084
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbiHQODP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239863AbiHQOCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:02:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705029A9B8;
        Wed, 17 Aug 2022 07:02:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJcO-0008TT-FS; Wed, 17 Aug 2022 16:02:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 17/17] testing: selftests: nft_flowtable.sh: rework test to detect offload failure
Date:   Wed, 17 Aug 2022 16:00:15 +0200
Message-Id: <20220817140015.25843-18-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test fails on current kernel releases because the flotwable path
now calls dst_check from packet path and will then remove the offload.

Test script has two purposes:
1. check that file (random content) can be sent to other netns (and vv)
2. check that the flow is offloaded (rather than handled by classic
   forwarding path).

Since dst_check is in place, 2) fails because the nftables ruleset in
router namespace 1 intentionally blocks traffic under the assumption
that packets are not passed via classic path at all.

Rework this: Instead of blocking traffic, create two named counters, one
for original and one for reverse direction.

The first three test cases are handled by classic forwarding path
(path mtu discovery is disabled and packets exceed MTU).

But all other tests enable PMTUD, so the originator and responder are
expected to lower packet size and flowtable is expected to do the packet
forwarding.

For those tests, check that the packet counters (which are only
incremented for packets that are passed up to classic forward path)
are significantly lower than the file size transferred.

I've tested that the counter-checks fail as expected when the 'flow add'
statement is removed from the ruleset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_flowtable.sh      | 141 +++++++++++-------
 1 file changed, 84 insertions(+), 57 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index c336e6c148d1..7060bae04ec8 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -24,8 +24,7 @@ nsr2="nsr2-$sfx"
 ksft_skip=4
 ret=0
 
-ns1in=""
-ns2in=""
+nsin=""
 ns1out=""
 ns2out=""
 
@@ -53,8 +52,7 @@ cleanup() {
 	ip netns del $nsr1
 	ip netns del $nsr2
 
-	rm -f "$ns1in" "$ns1out"
-	rm -f "$ns2in" "$ns2out"
+	rm -f "$nsin" "$ns1out" "$ns2out"
 
 	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
 }
@@ -165,36 +163,20 @@ table inet filter {
      devices = { veth0, veth1 }
    }
 
+   counter routed_orig { }
+   counter routed_repl { }
+
    chain forward {
       type filter hook forward priority 0; policy drop;
 
       # flow offloaded? Tag ct with mark 1, so we can detect when it fails.
-      meta oif "veth1" tcp dport 12345 flow offload @f1 counter
-
-      # use packet size to trigger 'should be offloaded by now'.
-      # otherwise, if 'flow offload' expression never offloads, the
-      # test will pass.
-      tcp dport 12345 meta length gt 200 ct mark set 1 counter
-
-      # this turns off flow offloading internally, so expect packets again
-      tcp flags fin,rst ct mark set 0 accept
-
-      # this allows large packets from responder, we need this as long
-      # as PMTUd is off.
-      # This rule is deleted for the last test, when we expect PMTUd
-      # to kick in and ensure all packets meet mtu requirements.
-      meta length gt $lmtu accept comment something-to-grep-for
+      meta oif "veth1" tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept
 
-      # next line blocks connection w.o. working offload.
-      # we only do this for reverse dir, because we expect packets to
-      # enter slow path due to MTU mismatch of veth0 and veth1.
-      tcp sport 12345 ct mark 1 counter log prefix "mark failure " drop
+      # count packets supposedly offloaded as per direction.
+      ct mark 1 counter name ct direction map { original : routed_orig, reply : routed_repl } accept
 
       ct state established,related accept
 
-      # for packets that we can't offload yet, i.e. SYN (any ct that is not confirmed)
-      meta length lt 200 oif "veth1" tcp dport 12345 counter accept
-
       meta nfproto ipv4 meta l4proto icmp accept
       meta nfproto ipv6 meta l4proto icmpv6 accept
    }
@@ -221,16 +203,16 @@ if [ $ret -eq 0 ];then
 	echo "PASS: netns routing/connectivity: $ns1 can reach $ns2"
 fi
 
-ns1in=$(mktemp)
+nsin=$(mktemp)
 ns1out=$(mktemp)
-ns2in=$(mktemp)
 ns2out=$(mktemp)
 
 make_file()
 {
 	name=$1
 
-	SIZE=$((RANDOM % (1024 * 8)))
+	SIZE=$((RANDOM % (1024 * 128)))
+	SIZE=$((SIZE + (1024 * 8)))
 	TSIZE=$((SIZE * 1024))
 
 	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
@@ -241,6 +223,38 @@ make_file()
 	dd if=/dev/urandom conf=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
 }
 
+check_counters()
+{
+	local what=$1
+	local ok=1
+
+	local orig=$(ip netns exec $nsr1 nft reset counter inet filter routed_orig | grep packets)
+	local repl=$(ip netns exec $nsr1 nft reset counter inet filter routed_repl | grep packets)
+
+	local orig_cnt=${orig#*bytes}
+	local repl_cnt=${repl#*bytes}
+
+	local fs=$(du -sb $nsin)
+	local max_orig=${fs%%/*}
+	local max_repl=$((max_orig/4))
+
+	if [ $orig_cnt -gt $max_orig ];then
+		echo "FAIL: $what: original counter $orig_cnt exceeds expected value $max_orig" 1>&2
+		ret=1
+		ok=0
+	fi
+
+	if [ $repl_cnt -gt $max_repl ];then
+		echo "FAIL: $what: reply counter $repl_cnt exceeds expected value $max_repl" 1>&2
+		ret=1
+		ok=0
+	fi
+
+	if [ $ok -eq 1 ]; then
+		echo "PASS: $what"
+	fi
+}
+
 check_transfer()
 {
 	in=$1
@@ -265,11 +279,11 @@ test_tcp_forwarding_ip()
 	local dstport=$4
 	local lret=0
 
-	ip netns exec $nsb nc -w 5 -l -p 12345 < "$ns2in" > "$ns2out" &
+	ip netns exec $nsb nc -w 5 -l -p 12345 < "$nsin" > "$ns2out" &
 	lpid=$!
 
 	sleep 1
-	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$ns1in" > "$ns1out" &
+	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$nsin" > "$ns1out" &
 	cpid=$!
 
 	sleep 3
@@ -284,11 +298,11 @@ test_tcp_forwarding_ip()
 
 	wait
 
-	if ! check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"; then
+	if ! check_transfer "$nsin" "$ns2out" "ns1 -> ns2"; then
 		lret=1
 	fi
 
-	if ! check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"; then
+	if ! check_transfer "$nsin" "$ns1out" "ns1 <- ns2"; then
 		lret=1
 	fi
 
@@ -305,23 +319,40 @@ test_tcp_forwarding()
 test_tcp_forwarding_nat()
 {
 	local lret
+	local pmtu
 
 	test_tcp_forwarding_ip "$1" "$2" 10.0.2.99 12345
 	lret=$?
 
+	pmtu=$3
+	what=$4
+
 	if [ $lret -eq 0 ] ; then
+		if [ $pmtu -eq 1 ] ;then
+			check_counters "flow offload for ns1/ns2 with masquerade and pmtu discovery $what"
+		else
+			echo "PASS: flow offload for ns1/ns2 with masquerade $what"
+		fi
+
 		test_tcp_forwarding_ip "$1" "$2" 10.6.6.6 1666
 		lret=$?
+		if [ $pmtu -eq 1 ] ;then
+			check_counters "flow offload for ns1/ns2 with dnat and pmtu discovery $what"
+		elif [ $lret -eq 0 ] ; then
+			echo "PASS: flow offload for ns1/ns2 with dnat $what"
+		fi
 	fi
 
 	return $lret
 }
 
-make_file "$ns1in"
-make_file "$ns2in"
+make_file "$nsin"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
+# Due to MTU mismatch in both directions, all packets (except small packets like pure
+# acks) have to be handled by normal forwarding path.  Therefore, packet counters
+# are not checked.
 if test_tcp_forwarding $ns1 $ns2; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
@@ -338,7 +369,8 @@ ip -net $ns2 route del default via dead:2::1
 ip -net $ns2 route add 192.168.10.1 via 10.0.2.1
 
 # Second test:
-# Same, but with NAT enabled.
+# Same, but with NAT enabled.  Same as in first test: we expect normal forward path
+# to handle most packets.
 ip netns exec $nsr1 nft -f - <<EOF
 table ip nat {
    chain prerouting {
@@ -353,29 +385,27 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat $ns1 $ns2; then
-	echo "PASS: flow offloaded for ns1/ns2 with NAT"
-else
+if ! test_tcp_forwarding_nat $ns1 $ns2 0 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
 	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
 # Third test:
-# Same as second test, but with PMTU discovery enabled.
-handle=$(ip netns exec $nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
-
-if ! ip netns exec $nsr1 nft delete rule inet filter forward $handle; then
-	echo "FAIL: Could not delete large-packet accept rule"
-	exit 1
-fi
-
+# Same as second test, but with PMTU discovery enabled. This
+# means that we expect the fastpath to handle packets as soon
+# as the endpoints adjust the packet size.
 ip netns exec $ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec $ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-if test_tcp_forwarding_nat $ns1 $ns2; then
-	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
-else
+# reset counters.
+# With pmtu in-place we'll also check that nft counters
+# are lower than file size and packets were forwarded via flowtable layer.
+# For earlier tests (large mtus), packets cannot be handled via flowtable
+# (except pure acks and other small packets).
+ip netns exec $nsr1 nft reset counters table inet filter >/dev/null
+
+if ! test_tcp_forwarding_nat $ns1 $ns2 1 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
 	ip netns exec $nsr1 nft list ruleset
 fi
@@ -408,14 +438,13 @@ table ip nat {
 }
 EOF
 
-if test_tcp_forwarding_nat $ns1 $ns2; then
-	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT"
-else
+if ! test_tcp_forwarding_nat $ns1 $ns2 1 "on bridge"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
 	ip netns exec $nsr1 nft list ruleset
 	ret=1
 fi
 
+
 # Another test:
 # Add bridge interface br0 to Router1, with NAT and VLAN.
 ip -net $nsr1 link set veth0 nomaster
@@ -433,9 +462,7 @@ ip -net $ns1 addr add 10.0.1.99/24 dev eth0.10
 ip -net $ns1 route add default via 10.0.1.1
 ip -net $ns1 addr add dead:1::99/64 dev eth0.10
 
-if test_tcp_forwarding_nat $ns1 $ns2; then
-	echo "PASS: flow offloaded for ns1/ns2 with bridge NAT and VLAN"
-else
+if ! test_tcp_forwarding_nat $ns1 $ns2 1 "bridge and VLAN"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
 	ip netns exec $nsr1 nft list ruleset
 	ret=1
@@ -502,7 +529,7 @@ ip -net $ns2 route add default via 10.0.2.1
 ip -net $ns2 route add default via dead:2::1
 
 if test_tcp_forwarding $ns1 $ns2; then
-	echo "PASS: ipsec tunnel mode for ns1/ns2"
+	check_counters "ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
 	ip netns exec $nsr1 nft list ruleset 1>&2
-- 
2.35.1

