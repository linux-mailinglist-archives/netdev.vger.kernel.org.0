Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4AC4FB9A5
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345536AbiDKKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbiDKKaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81261433B8;
        Mon, 11 Apr 2022 03:27:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50E3B6303C;
        Mon, 11 Apr 2022 12:23:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/11] selftests: netfilter: add fib expression forward test case
Date:   Mon, 11 Apr 2022 12:27:44 +0200
Message-Id: <20220411102744.282101-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its now possible to use fib expression in the forward chain (where both
the input and output interfaces are known).

Add a simple test case for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_fib.sh | 50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 695a1958723f..fd76b69635a4 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -66,6 +66,20 @@ table inet filter {
 EOF
 }
 
+load_pbr_ruleset() {
+	local netns=$1
+
+ip netns exec ${netns} nft -f /dev/stdin <<EOF
+table inet filter {
+	chain forward {
+		type filter hook forward priority raw;
+		fib saddr . iif oif gt 0 accept
+		log drop
+	}
+}
+EOF
+}
+
 load_ruleset_count() {
 	local netns=$1
 
@@ -219,4 +233,40 @@ sleep 2
 ip netns exec ${ns1} ping -c 3 -q 1c3::c01d > /dev/null
 check_fib_counter 3 ${nsrouter} 1c3::c01d || exit 1
 
+# delete all rules
+ip netns exec ${ns1} nft flush ruleset
+ip netns exec ${ns2} nft flush ruleset
+ip netns exec ${nsrouter} nft flush ruleset
+
+ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0
+
+ip -net ${ns1} addr del 10.0.2.99/24 dev eth0
+ip -net ${ns1} addr del dead:2::99/64 dev eth0
+
+ip -net ${nsrouter} addr del dead:2::1/64 dev veth0
+
+# ... pbr ruleset for the router, check iif+oif.
+load_pbr_ruleset ${nsrouter}
+if [ $? -ne 0 ] ; then
+	echo "SKIP: Could not load fib forward ruleset"
+	exit $ksft_skip
+fi
+
+ip -net ${nsrouter} rule add from all table 128
+ip -net ${nsrouter} rule add from all iif veth0 table 129
+ip -net ${nsrouter} route add table 128 to 10.0.1.0/24 dev veth0
+ip -net ${nsrouter} route add table 129 to 10.0.2.0/24 dev veth1
+
+# drop main ipv4 table
+ip -net ${nsrouter} -4 rule delete table main
+
+test_ping 10.0.2.99 dead:2::99
+if [ $? -ne 0 ] ; then
+	ip -net ${nsrouter} nft list ruleset
+	echo "FAIL: fib mismatch in pbr setup"
+	exit 1
+fi
+
+echo "PASS: fib expression forward check with policy based routing"
 exit 0
-- 
2.30.2

