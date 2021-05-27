Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343033935D9
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbhE0TDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:03:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38840 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbhE0TC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:02:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4686464504;
        Thu, 27 May 2021 21:00:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/5] netfilter: nf_tables: fix table flag updates
Date:   Thu, 27 May 2021 21:01:14 +0200
Message-Id: <20210527190115.98503-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527190115.98503-1-pablo@netfilter.org>
References: <20210527190115.98503-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dormant flag need to be updated from the preparation phase,
otherwise, two consecutive requests to dorm a table in the same batch
might try to remove the same hooks twice, resulting in the following
warning:

 hook not found, pf 3 num 0
 WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
 Modules linked in:
 CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Workqueue: netns cleanup_net
 RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480

This patch is a partial revert of 0ce7cf4127f1 ("netfilter: nftables:
update table flags from the commit phase") to restore the previous
behaviour.

However, there is still another problem: A batch containing a series of
dorm-wakeup-dorm table and vice-versa also trigger the warning above
since hook unregistration happens from the preparation phase, while hook
registration occurs from the commit phase.

To fix this problem, this patch adds two internal flags to annotate the
original dormant flag status which are __NFT_TABLE_F_WAS_DORMANT and
__NFT_TABLE_F_WAS_AWAKEN, to restore it from the abort path.

The __NFT_TABLE_F_UPDATE bitmask allows to handle the dormant flag update
with one single transaction.

Reported-by: syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com
Fixes: 0ce7cf4127f1 ("netfilter: nftables: update table flags from the commit phase")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 ----
 net/netfilter/nf_tables_api.c     | 59 +++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 27eeb613bb4e..0a5655e300b5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1506,16 +1506,10 @@ struct nft_trans_chain {
 
 struct nft_trans_table {
 	bool				update;
-	u8				state;
-	u32				flags;
 };
 
 #define nft_trans_table_update(trans)	\
 	(((struct nft_trans_table *)trans->data)->update)
-#define nft_trans_table_state(trans)	\
-	(((struct nft_trans_table *)trans->data)->state)
-#define nft_trans_table_flags(trans)	\
-	(((struct nft_trans_table *)trans->data)->flags)
 
 struct nft_trans_elem {
 	struct nft_set			*set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c34a3c0a0d9c..72bc759179ef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -736,7 +736,8 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
-	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
+	    nla_put_be32(skb, NFTA_TABLE_FLAGS,
+			 htonl(table->flags & NFT_TABLE_F_MASK)) ||
 	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
 	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
 			 NFTA_TABLE_PAD))
@@ -947,20 +948,22 @@ static int nf_tables_table_enable(struct net *net, struct nft_table *table)
 
 static void nf_tables_table_disable(struct net *net, struct nft_table *table)
 {
+	table->flags &= ~NFT_TABLE_F_DORMANT;
 	nft_table_disable(net, table, 0);
+	table->flags |= NFT_TABLE_F_DORMANT;
 }
 
-enum {
-	NFT_TABLE_STATE_UNCHANGED	= 0,
-	NFT_TABLE_STATE_DORMANT,
-	NFT_TABLE_STATE_WAKEUP
-};
+#define __NFT_TABLE_F_INTERNAL		(NFT_TABLE_F_MASK + 1)
+#define __NFT_TABLE_F_WAS_DORMANT	(__NFT_TABLE_F_INTERNAL << 0)
+#define __NFT_TABLE_F_WAS_AWAKEN	(__NFT_TABLE_F_INTERNAL << 1)
+#define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
+					 __NFT_TABLE_F_WAS_AWAKEN)
 
 static int nf_tables_updtable(struct nft_ctx *ctx)
 {
 	struct nft_trans *trans;
 	u32 flags;
-	int ret = 0;
+	int ret;
 
 	if (!ctx->nla[NFTA_TABLE_FLAGS])
 		return 0;
@@ -985,21 +988,27 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 
 	if ((flags & NFT_TABLE_F_DORMANT) &&
 	    !(ctx->table->flags & NFT_TABLE_F_DORMANT)) {
-		nft_trans_table_state(trans) = NFT_TABLE_STATE_DORMANT;
+		ctx->table->flags |= NFT_TABLE_F_DORMANT;
+		if (!(ctx->table->flags & __NFT_TABLE_F_UPDATE))
+			ctx->table->flags |= __NFT_TABLE_F_WAS_AWAKEN;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
-		ret = nf_tables_table_enable(ctx->net, ctx->table);
-		if (ret >= 0)
-			nft_trans_table_state(trans) = NFT_TABLE_STATE_WAKEUP;
+		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+		if (!(ctx->table->flags & __NFT_TABLE_F_UPDATE)) {
+			ret = nf_tables_table_enable(ctx->net, ctx->table);
+			if (ret < 0)
+				goto err_register_hooks;
+
+			ctx->table->flags |= __NFT_TABLE_F_WAS_DORMANT;
+		}
 	}
-	if (ret < 0)
-		goto err;
 
-	nft_trans_table_flags(trans) = flags;
 	nft_trans_table_update(trans) = true;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
+
 	return 0;
-err:
+
+err_register_hooks:
 	nft_trans_destroy(trans);
 	return ret;
 }
@@ -8556,10 +8565,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_DORMANT)
+				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
+					nft_trans_destroy(trans);
+					break;
+				}
+				if (trans->ctx.table->flags & NFT_TABLE_F_DORMANT)
 					nf_tables_table_disable(net, trans->ctx.table);
 
-				trans->ctx.table->flags = nft_trans_table_flags(trans);
+				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
 			} else {
 				nft_clear(net, trans->ctx.table);
 			}
@@ -8777,9 +8790,17 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
-				if (nft_trans_table_state(trans) == NFT_TABLE_STATE_WAKEUP)
+				if (!(trans->ctx.table->flags & __NFT_TABLE_F_UPDATE)) {
+					nft_trans_destroy(trans);
+					break;
+				}
+				if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_DORMANT) {
 					nf_tables_table_disable(net, trans->ctx.table);
-
+					trans->ctx.table->flags |= NFT_TABLE_F_DORMANT;
+				} else if (trans->ctx.table->flags & __NFT_TABLE_F_WAS_AWAKEN) {
+					trans->ctx.table->flags &= ~NFT_TABLE_F_DORMANT;
+				}
+				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
 				nft_trans_destroy(trans);
 			} else {
 				list_del_rcu(&trans->ctx.table->list);
-- 
2.30.2

