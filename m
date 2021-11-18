Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1374565A0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhKRW3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:33 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58270 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhKRW3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:32 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 932BB6499E;
        Thu, 18 Nov 2021 23:24:23 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 02/11] selftests: netfilter: extend nfqueue tests to cover vrf device
Date:   Thu, 18 Nov 2021 23:26:09 +0100
Message-Id: <20211118222618.433273-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

VRF device calls the output/postrouting hooks so packet should be seeon
with oifname tvrf and once with eth0.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/netfilter/nft_queue.sh  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
index 3d202b90b33d..7d27f1f3bc01 100755
--- a/tools/testing/selftests/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -16,6 +16,10 @@ timeout=4
 
 cleanup()
 {
+	ip netns pids ${ns1} | xargs kill 2>/dev/null
+	ip netns pids ${ns2} | xargs kill 2>/dev/null
+	ip netns pids ${nsrouter} | xargs kill 2>/dev/null
+
 	ip netns del ${ns1}
 	ip netns del ${ns2}
 	ip netns del ${nsrouter}
@@ -332,6 +336,55 @@ EOF
 	echo "PASS: tcp via loopback and re-queueing"
 }
 
+test_icmp_vrf() {
+	ip -net $ns1 link add tvrf type vrf table 9876
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not add vrf device"
+		return
+	fi
+
+	ip -net $ns1 li set eth0 master tvrf
+	ip -net $ns1 li set tvrf up
+
+	ip -net $ns1 route add 10.0.2.0/24 via 10.0.1.1 dev eth0 table 9876
+ip netns exec ${ns1} nft -f /dev/stdin <<EOF
+flush ruleset
+table inet filter {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		meta oifname "tvrf" icmp type echo-request counter queue num 1
+		meta oifname "eth0" icmp type echo-request counter queue num 1
+	}
+	chain post {
+		type filter hook postrouting priority 0; policy accept;
+		meta oifname "tvrf" icmp type echo-request counter queue num 1
+		meta oifname "eth0" icmp type echo-request counter queue num 1
+	}
+}
+EOF
+	ip netns exec ${ns1} ./nf-queue -q 1 -t $timeout &
+	local nfqpid=$!
+
+	sleep 1
+	ip netns exec ${ns1} ip vrf exec tvrf ping -c 1 10.0.2.99 > /dev/null
+
+	for n in output post; do
+		for d in tvrf eth0; do
+			ip netns exec ${ns1} nft list chain inet filter $n | grep -q "oifname \"$d\" icmp type echo-request counter packets 1"
+			if [ $? -ne 0 ] ; then
+				echo "FAIL: chain $n: icmp packet counter mismatch for device $d" 1>&2
+				ip netns exec ${ns1} nft list ruleset
+				ret=1
+				return
+			fi
+		done
+	done
+
+	wait $nfqpid
+	[ $? -eq 0 ] && echo "PASS: icmp+nfqueue via vrf"
+	wait 2>/dev/null
+}
+
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -372,5 +425,6 @@ test_queue 20
 test_tcp_forward
 test_tcp_localhost
 test_tcp_localhost_requeue
+test_icmp_vrf
 
 exit $ret
-- 
2.30.2

