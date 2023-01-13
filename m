Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B9C669E69
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjAMQnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjAMQme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:42:34 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F272182B87;
        Fri, 13 Jan 2023 08:41:11 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] selftests: netfilter: fix transaction test script timeout handling
Date:   Fri, 13 Jan 2023 17:41:04 +0100
Message-Id: <20230113164106.311491-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230113164106.311491-1-pablo@netfilter.org>
References: <20230113164106.311491-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The kselftest framework uses a default timeout of 45 seconds for
all test scripts.

Increase the timeout to two minutes for the netfilter tests, this
should hopefully be enough,

Make sure that, should the script be canceled, the net namespace and
the spawned ping instances are removed.

Fixes: 25d8bcedbf43 ("selftests: add script to stress-test nft packet path vs. control plane")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_trans_stress.sh      | 16 +++++++++-------
 tools/testing/selftests/netfilter/settings       |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings

diff --git a/tools/testing/selftests/netfilter/nft_trans_stress.sh b/tools/testing/selftests/netfilter/nft_trans_stress.sh
index a7f62ad4f661..2ffba45a78bf 100755
--- a/tools/testing/selftests/netfilter/nft_trans_stress.sh
+++ b/tools/testing/selftests/netfilter/nft_trans_stress.sh
@@ -10,12 +10,20 @@
 ksft_skip=4
 
 testns=testns-$(mktemp -u "XXXXXXXX")
+tmp=""
 
 tables="foo bar baz quux"
 global_ret=0
 eret=0
 lret=0
 
+cleanup() {
+	ip netns pids "$testns" | xargs kill 2>/dev/null
+	ip netns del "$testns"
+
+	rm -f "$tmp"
+}
+
 check_result()
 {
 	local r=$1
@@ -43,6 +51,7 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
+trap cleanup EXIT
 tmp=$(mktemp)
 
 for table in $tables; do
@@ -139,11 +148,4 @@ done
 
 check_result $lret "add/delete with nftrace enabled"
 
-pkill -9 ping
-
-wait
-
-rm -f "$tmp"
-ip netns del "$testns"
-
 exit $global_ret
diff --git a/tools/testing/selftests/netfilter/settings b/tools/testing/selftests/netfilter/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/netfilter/settings
@@ -0,0 +1 @@
+timeout=120
-- 
2.30.2

