Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5763053F196
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiFFVVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiFFVVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:21:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E3FCC3D2C;
        Mon,  6 Jun 2022 14:21:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/7] netfilter: nf_tables: delete flowtable hooks via transaction list
Date:   Mon,  6 Jun 2022 23:20:51 +0200
Message-Id: <20220606212055.98300-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220606212055.98300-1-pablo@netfilter.org>
References: <20220606212055.98300-1-pablo@netfilter.org>
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

Remove inactive bool field in nft_hook object that was introduced in
abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable").
Move stale flowtable hooks to transaction list instead.

Deleting twice the same device does not result in ENOENT.

Fixes: abadb2f865d7 ("netfilter: nf_tables: delete devices from flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 -
 net/netfilter/nf_tables_api.c     | 31 ++++++-------------------------
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9..279ae0fff7ad 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1090,7 +1090,6 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	bool			inactive;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 129d3ebd6ce5..30588349f96c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1914,7 +1914,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_dev;
 	}
 	hook->ops.dev = dev;
-	hook->inactive = false;
 
 	return hook;
 
@@ -7618,6 +7617,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	LIST_HEAD(flowtable_del_list);
 	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
@@ -7633,7 +7633,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		hook->inactive = true;
+		list_move(&hook->list, &flowtable_del_list);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -7646,6 +7646,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	list_splice(&flowtable_del_list, &nft_trans_flowtable_hooks(trans));
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -7653,13 +7654,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
-		if (!hook)
-			break;
-
-		hook->inactive = false;
-	}
+	list_splice(&flowtable_del_list, &flowtable->hook_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -8563,17 +8558,6 @@ void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
-static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
-				    struct list_head *hook_list)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		if (hook->inactive)
-			list_move(&hook->list, hook_list);
-	}
-}
-
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -8918,8 +8902,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nft_flowtable_hooks_del(nft_trans_flowtable(trans),
-							&nft_trans_flowtable_hooks(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
@@ -9000,7 +8982,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
-	struct nft_hook *hook;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
@@ -9131,8 +9112,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
-					hook->inactive = false;
+				list_splice(&nft_trans_flowtable_hooks(trans),
+					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				trans->ctx.table->use++;
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
-- 
2.30.2

