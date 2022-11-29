Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5731963C2CA
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiK2OjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiK2OjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:39:11 -0500
X-Greylist: delayed 1927 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 06:39:09 PST
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86183E0B8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:39:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p01GF-00043a-VK; Tue, 29 Nov 2022 15:07:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] inet: ping: use hlist_nulls rcu iterator during lookup
Date:   Tue, 29 Nov 2022 15:06:44 +0100
Message-Id: <20221129140644.28525-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
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

ping_lookup() does not acquire the table spinlock, so iteration should
use hlist_nulls_for_each_entry_rcu().

Spotted during code review.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .clang-format      | 1 +
 include/net/ping.h | 3 ---
 net/ipv4/ping.c    | 7 ++++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/.clang-format b/.clang-format
index 1247d54f9e49..8d01225bfcb7 100644
--- a/.clang-format
+++ b/.clang-format
@@ -535,6 +535,7 @@ ForEachMacros:
   - 'perf_hpp_list__for_each_sort_list_safe'
   - 'perf_pmu__for_each_hybrid_pmu'
   - 'ping_portaddr_for_each_entry'
+  - 'ping_portaddr_for_each_entry_rcu'
   - 'plist_for_each'
   - 'plist_for_each_continue'
   - 'plist_for_each_entry'
diff --git a/include/net/ping.h b/include/net/ping.h
index e4ff3911cbf5..9233ad3de0ad 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -16,9 +16,6 @@
 #define PING_HTABLE_SIZE 	64
 #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-
 /*
  * gid_t is either uint or ushort.  We want to pass it to
  * proc_dointvec_minmax(), so it must not be larger than MAX_INT
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index bde333b24837..04b4ec07bb06 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -49,6 +49,11 @@
 #include <net/transp_v6.h>
 #endif
 
+#define ping_portaddr_for_each_entry(__sk, node, list) \
+	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
+#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
+	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
+
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
@@ -192,7 +197,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry(sk, hnode, hslot) {
+	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
-- 
2.37.4

