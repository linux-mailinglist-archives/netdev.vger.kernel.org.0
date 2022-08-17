Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21A59709D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbiHQOBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239863AbiHQOA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:00:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F979858F;
        Wed, 17 Aug 2022 07:00:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJbK-0008O2-Cp; Wed, 17 Aug 2022 16:00:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 01/17] netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
Date:   Wed, 17 Aug 2022 15:59:59 +0200
Message-Id: <20220817140015.25843-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

The generation ID is bumped from the commit path while holding the
mutex, however, netlink dump operations rely on RCU.

This patch also adds missing cb->base_eq initialization in
nf_tables_dump_set().

Fixes: 38e029f14a97 ("netfilter: nf_tables: set NLM_F_DUMP_INTR if netlink dumping is stale")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3cc88998b879..8b084cd669ab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -889,7 +889,7 @@ static int nf_tables_dump_tables(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -1705,7 +1705,7 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -3149,7 +3149,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -4133,7 +4133,7 @@ static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (ctx->family != NFPROTO_UNSPEC &&
@@ -5061,6 +5061,8 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
+	cb->seq = READ_ONCE(nft_net->base_seq);
+
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (dump_ctx->ctx.family != NFPROTO_UNSPEC &&
 		    dump_ctx->ctx.family != table->family)
@@ -6941,7 +6943,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -7873,7 +7875,7 @@ static int nf_tables_dump_flowtable(struct sk_buff *skb,
 
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
-	cb->seq = nft_net->base_seq;
+	cb->seq = READ_ONCE(nft_net->base_seq);
 
 	list_for_each_entry_rcu(table, &nft_net->tables, list) {
 		if (family != NFPROTO_UNSPEC && family != table->family)
@@ -8806,6 +8808,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	struct nft_trans_elem *te;
 	struct nft_chain *chain;
 	struct nft_table *table;
+	unsigned int base_seq;
 	LIST_HEAD(adl);
 	int err;
 
@@ -8855,9 +8858,12 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	 * Bump generation counter, invalidate any dump in progress.
 	 * Cannot fail after this point.
 	 */
-	while (++nft_net->base_seq == 0)
+	base_seq = READ_ONCE(nft_net->base_seq);
+	while (++base_seq == 0)
 		;
 
+	WRITE_ONCE(nft_net->base_seq, base_seq);
+
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
 
-- 
2.35.1

