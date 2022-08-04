Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9298589FD8
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiHDR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiHDR04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:26:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD12B635E
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:26:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oJecY-0007DX-9m; Thu, 04 Aug 2022 19:26:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/3] selftests: netfilter: add test case for nf trace infrastructure
Date:   Thu,  4 Aug 2022 19:26:28 +0200
Message-Id: <20220804172629.29748-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220804172629.29748-1-fw@strlen.de>
References: <20220804172629.29748-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable/disable tracing infrastructure while packets are in-flight.
This triggers KASAN splat after
e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen").

While at it, reduce script run time as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_trans_stress.sh   | 81 +++++++++++++++++--
 1 file changed, 76 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_trans_stress.sh b/tools/testing/selftests/netfilter/nft_trans_stress.sh
index f1affd12c4b1..a7f62ad4f661 100755
--- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
+++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
@@ -9,8 +9,27 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-testns=testns1
+testns=testns-$(mktemp -u "XXXXXXXX")
+
 tables="foo bar baz quux"
+global_ret=0
+eret=0
+lret=0
+
+check_result()
+{
+	local r=$1
+	local OK="PASS"
+
+	if [ $r -ne 0 ] ;then
+		OK="FAIL"
+		global_ret=$r
+	fi
+
+	echo "$OK: nft $2 test returned $r"
+
+	eret=0
+}
 
 nft --version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -59,16 +78,66 @@ done)
 
 sleep 1
 
+ip netns exec "$testns" nft -f "$tmp"
 for i in $(seq 1 10) ; do ip netns exec "$testns" nft -f "$tmp" & done
 
 for table in $tables;do
-	randsleep=$((RANDOM%10))
+	randsleep=$((RANDOM%2))
 	sleep $randsleep
-	ip netns exec "$testns" nft delete table inet $table 2>/dev/null
+	ip netns exec "$testns" nft delete table inet $table
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
 done
 
-randsleep=$((RANDOM%10))
-sleep $randsleep
+check_result $eret "add/delete"
+
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp") | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+done
+
+check_result $eret "reload"
+
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp"
+	 echo "insert rule inet foo INPUT meta nftrace set 1"
+	 echo "insert rule inet foo OUTPUT meta nftrace set 1"
+	 ) | ip netns exec "$testns" nft -f /dev/stdin
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+
+	(echo "flush ruleset"; cat "$tmp"
+	 ) | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=$lret
+	fi
+done
+
+check_result $eret "add/delete with nftrace enabled"
+
+echo "insert rule inet foo INPUT meta nftrace set 1" >> $tmp
+echo "insert rule inet foo OUTPUT meta nftrace set 1" >> $tmp
+
+for i in $(seq 1 10) ; do
+	(echo "flush ruleset"; cat "$tmp") | ip netns exec "$testns" nft -f /dev/stdin
+
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		eret=1
+	fi
+done
+
+check_result $lret "add/delete with nftrace enabled"
 
 pkill -9 ping
 
@@ -76,3 +145,5 @@ wait
 
 rm -f "$tmp"
 ip netns del "$testns"
+
+exit $global_ret
-- 
2.35.1

