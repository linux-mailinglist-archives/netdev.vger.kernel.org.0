Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC9F417DA2
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbhIXWNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49782 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbhIXWM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:59 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id DD90C63EB7;
        Sat, 25 Sep 2021 00:10:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 08/15] selftests: netfilter: add zone stress test with colliding tuples
Date:   Sat, 25 Sep 2021 00:11:06 +0200
Message-Id: <20210924221113.348767-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add 20k entries to the connection tracking table, once from the
data plane, once via ctnetlink.

In both cases, each entry lives in a different conntrack zone
and addresses/ports are identical.

Expectation is that insertions work and occurs in constant time:

PASS: added 10000 entries in 1215 ms (now 10000 total, loop 1)
PASS: added 10000 entries in 1214 ms (now 20000 total, loop 2)
PASS: inserted 20000 entries from packet path in 2434 ms total
PASS: added 10000 entries in 57631 ms (now 10000 total)
PASS: added 10000 entries in 58572 ms (now 20000 total)
PASS: inserted 20000 entries via ctnetlink in 116205 ms

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_zones_many.sh     | 156 ++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100755 tools/testing/selftests/netfilter/nft_zones_many.sh

diff --git a/tools/testing/selftests/netfilter/nft_zones_many.sh b/tools/testing/selftests/netfilter/nft_zones_many.sh
new file mode 100755
index 000000000000..ac646376eb01
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_zones_many.sh
@@ -0,0 +1,156 @@
+#!/bin/bash
+
+# Test insertion speed for packets with identical addresses/ports
+# that are all placed in distinct conntrack zones.
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns="ns-$sfx"
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+zones=20000
+have_ct_tool=0
+ret=0
+
+cleanup()
+{
+	ip netns del $ns
+}
+
+ip netns add $ns
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $gw"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+conntrack -V > /dev/null 2>&1
+if [ $? -eq 0 ];then
+	have_ct_tool=1
+fi
+
+ip -net "$ns" link set lo up
+
+test_zones() {
+	local max_zones=$1
+
+ip netns exec $ns sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
+ip netns exec $ns nft -f /dev/stdin<<EOF
+flush ruleset
+table inet raw {
+	map rndzone {
+		typeof numgen inc mod $max_zones : ct zone
+	}
+
+	chain output {
+		type filter hook output priority -64000; policy accept;
+		udp dport 12345  ct zone set numgen inc mod 65536 map @rndzone
+	}
+}
+EOF
+	(
+		echo "add element inet raw rndzone {"
+	for i in $(seq 1 $max_zones);do
+		echo -n "$i : $i"
+		if [ $i -lt $max_zones ]; then
+			echo ","
+		else
+			echo "}"
+		fi
+	done
+	) | ip netns exec $ns nft -f /dev/stdin
+
+	local i=0
+	local j=0
+	local outerstart=$(date +%s%3N)
+	local stop=$outerstart
+
+	while [ $i -lt $max_zones ]; do
+		local start=$(date +%s%3N)
+		i=$((i + 10000))
+		j=$((j + 1))
+		dd if=/dev/zero of=/dev/stdout bs=8k count=10000 2>/dev/null | ip netns exec "$ns" nc -w 1 -q 1 -u -p 12345 127.0.0.1 12345 > /dev/null
+		if [ $? -ne 0 ] ;then
+			ret=1
+			break
+		fi
+
+		stop=$(date +%s%3N)
+		local duration=$((stop-start))
+		echo "PASS: added 10000 entries in $duration ms (now $i total, loop $j)"
+	done
+
+	if [ $have_ct_tool -eq 1 ]; then
+		local count=$(ip netns exec "$ns" conntrack -C)
+		local duration=$((stop-outerstart))
+
+		if [ $count -eq $max_zones ]; then
+			echo "PASS: inserted $count entries from packet path in $duration ms total"
+		else
+			ip netns exec $ns conntrack -S 1>&2
+			echo "FAIL: inserted $count entries from packet path in $duration ms total, expected $max_zones entries"
+			ret=1
+		fi
+	fi
+
+	if [ $ret -ne 0 ];then
+		echo "FAIL: insert $max_zones entries from packet path" 1>&2
+	fi
+}
+
+test_conntrack_tool() {
+	local max_zones=$1
+
+	ip netns exec $ns conntrack -F >/dev/null 2>/dev/null
+
+	local outerstart=$(date +%s%3N)
+	local start=$(date +%s%3N)
+	local stop=$start
+	local i=0
+	while [ $i -lt $max_zones ]; do
+		i=$((i + 1))
+		ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i >/dev/null 2>&1
+		if [ $? -ne 0 ];then
+			ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i > /dev/null
+			echo "FAIL: conntrack -I returned an error"
+			ret=1
+			break
+		fi
+
+		if [ $((i%10000)) -eq 0 ];then
+			stop=$(date +%s%3N)
+
+			local duration=$((stop-start))
+			echo "PASS: added 10000 entries in $duration ms (now $i total)"
+			start=$stop
+		fi
+	done
+
+	local count=$(ip netns exec "$ns" conntrack -C)
+	local duration=$((stop-outerstart))
+
+	if [ $count -eq $max_zones ]; then
+		echo "PASS: inserted $count entries via ctnetlink in $duration ms"
+	else
+		ip netns exec $ns conntrack -S 1>&2
+		echo "FAIL: inserted $count entries via ctnetlink in $duration ms, expected $max_zones entries ($duration ms)"
+		ret=1
+	fi
+}
+
+test_zones $zones
+
+if [ $have_ct_tool -eq 1 ];then
+	test_conntrack_tool $zones
+else
+	echo "SKIP: Could not run ctnetlink insertion test without conntrack tool"
+	if [ $ret -eq 0 ];then
+		exit $ksft_skip
+	fi
+fi
+
+exit $ret
-- 
2.30.2

