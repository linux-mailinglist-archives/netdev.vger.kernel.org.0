Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7249EF06
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343985AbiA0Xwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:44 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43006 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343822AbiA0Xwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:43 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5215960868;
        Fri, 28 Jan 2022 00:49:38 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/8] selftests: netfilter: check stateless nat udp checksum fixup
Date:   Fri, 28 Jan 2022 00:52:31 +0100
Message-Id: <20220127235235.656931-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add a test that sends large udp packet (which is fragmented)
via a stateless nft nat rule, i.e. 'ip saddr set 10.2.3.4'
and check that the datagram is received by peer.

On kernels without
commit 4e1860a38637 ("netfilter: nft_payload: do not update layer 4 checksum when mangling fragments")',
this will fail with:

cmp: EOF on /tmp/tmp.V1q0iXJyQF which is empty
-rw------- 1 root root 4096 Jan 24 22:03 /tmp/tmp.Aaqnq4rBKS
-rw------- 1 root root    0 Jan 24 22:03 /tmp/tmp.V1q0iXJyQF
ERROR: in and output file mismatch when checking udp with stateless nat
FAIL: nftables v1.0.0 (Fearless Fosdick #2)

On patched kernels, this will show:
PASS: IP statless for ns2-PFp89amx

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 152 +++++++++++++++++++
 1 file changed, 152 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 349a319a9e51..79fe627b9e81 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -899,6 +899,144 @@ EOF
 	ip netns exec "$ns0" nft delete table $family nat
 }
 
+test_stateless_nat_ip()
+{
+	local lret=0
+
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 before loading stateless rules"
+		return 1
+	fi
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table ip stateless {
+	map xlate_in {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth1" . 10.0.2.99 . 10.0.1.99 : 10.0.2.2,
+		}
+	}
+	map xlate_out {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth0" . 10.0.1.99 . 10.0.2.2 : 10.0.2.99
+		}
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr set meta iifname . ip saddr . ip daddr map @xlate_in
+		ip daddr set meta iifname . ip saddr . ip daddr map @xlate_out
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add ip statless rules"
+		return $ksft_skip
+	fi
+
+	reset_counters
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 with stateless rules"
+		lret=1
+	fi
+
+	# ns1 should have seen packets from .2.2, due to stateless rewrite.
+	expect="packets 1 bytes 84"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 1"
+		lret=1
+	fi
+
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns2" ns1$dir "$expect" "test_stateless 2"
+			lret=1
+		fi
+	done
+
+	# ns1 should not have seen packets from ns2, due to masquerade
+	expect="packets 0 bytes 0"
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns1" ns0$dir "$expect" "test_stateless 3"
+			lret=1
+		fi
+
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns0" ns1$dir "$expect" "test_stateless 4"
+			lret=1
+		fi
+	done
+
+	reset_counters
+
+	socat -h > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run stateless nat frag test without socat tool"
+		if [ $lret -eq 0 ]; then
+			return $ksft_skip
+		fi
+
+		ip netns exec "$ns0" nft delete table ip stateless
+		return $lret
+	fi
+
+	local tmpfile=$(mktemp)
+	dd if=/dev/urandom of=$tmpfile bs=4096 count=1 2>/dev/null
+
+	local outfile=$(mktemp)
+	ip netns exec "$ns1" timeout 3 socat -u UDP4-RECV:4233 OPEN:$outfile < /dev/null &
+	sc_r=$!
+
+	sleep 1
+	# re-do with large ping -> ip fragmentation
+	ip netns exec "$ns2" timeout 3 socat - UDP4-SENDTO:"10.0.1.99:4233" < "$tmpfile" > /dev/null
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: failed to test udp $ns1 to $ns2 with stateless ip nat" 1>&2
+		lret=1
+	fi
+
+	wait
+
+	cmp "$tmpfile" "$outfile"
+	if [ $? -ne 0 ]; then
+		ls -l "$tmpfile" "$outfile"
+		echo "ERROR: in and output file mismatch when checking udp with stateless nat" 1>&2
+		lret=1
+	fi
+
+	rm -f "$tmpfile" "$outfile"
+
+	# ns1 should have seen packets from 2.2, due to stateless rewrite.
+	expect="packets 3 bytes 4164"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 5"
+		lret=1
+	fi
+
+	ip netns exec "$ns0" nft delete table ip stateless
+	if [ $? -ne 0 ]; then
+		echo "ERROR: Could not delete table ip stateless" 1>&2
+		lret=1
+	fi
+
+	test $lret -eq 0 && echo "PASS: IP statless for $ns2"
+
+	return $lret
+}
+
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in 0 1 2; do
 ip netns exec ns$i-$sfx nft -f /dev/stdin <<EOF
@@ -965,6 +1103,19 @@ table inet filter {
 EOF
 done
 
+# special case for stateless nat check, counter needs to
+# be done before (input) ip defragmentation
+ip netns exec ns1-$sfx nft -f /dev/stdin <<EOF
+table inet filter {
+	counter ns0insl {}
+
+	chain pre {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr 10.0.2.2 counter name "ns0insl"
+	}
+}
+EOF
+
 sleep 3
 # test basic connectivity
 for i in 1 2; do
@@ -1019,6 +1170,7 @@ $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
 test_port_shadowing
+test_stateless_nat_ip
 
 if [ $ret -ne 0 ];then
 	echo -n "FAIL: "
-- 
2.30.2

