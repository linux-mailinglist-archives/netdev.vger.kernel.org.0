Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9A6EB556
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbjDUXC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjDUXCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DD111BCC;
        Fri, 21 Apr 2023 16:02:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 06/20] netfilter: nf_tables: make validation state per table
Date:   Sat, 22 Apr 2023 01:01:57 +0200
Message-Id: <20230421230211.214635-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
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

We only need to validate tables that saw changes in the current
transaction.

The existing code revalidates all tables, but this isn't needed as
cross-table jumps are not allowed (chains have table scope).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 38 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f476fd030626..ec347d9cff9e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1209,6 +1209,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
  *	@genmask: generation mask
  *	@afinfo: address family info
  *	@name: name of the table
+ *	@validate_state: internal, set when transaction adds jumps
  */
 struct nft_table {
 	struct list_head		list;
@@ -1227,6 +1228,7 @@ struct nft_table {
 	char				*name;
 	u16				udlen;
 	u8				*udata;
+	u8				validate_state;
 };
 
 static inline bool nft_table_has_owner(const struct nft_table *table)
@@ -1698,7 +1700,6 @@ struct nftables_pernet {
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	unsigned int		base_seq;
-	u8			validate_state;
 };
 
 extern unsigned int nf_tables_net_id;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 21eb273d2740..44ebc5f9598e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -102,11 +102,9 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
 	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
 };
 
-static void nft_validate_state_update(struct net *net, u8 new_validate_state)
+static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
-
-	switch (nft_net->validate_state) {
+	switch (table->validate_state) {
 	case NFT_VALIDATE_SKIP:
 		WARN_ON_ONCE(new_validate_state == NFT_VALIDATE_DO);
 		break;
@@ -117,7 +115,7 @@ static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 			return;
 	}
 
-	nft_net->validate_state = new_validate_state;
+	table->validate_state = new_validate_state;
 }
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
@@ -1224,6 +1222,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	if (table == NULL)
 		goto err_kzalloc;
 
+	table->validate_state = NFT_VALIDATE_SKIP;
 	table->name = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (table->name == NULL)
 		goto err_strdup;
@@ -3660,7 +3659,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 
 		if (expr_info[i].ops->validate)
-			nft_validate_state_update(net, NFT_VALIDATE_NEED);
+			nft_validate_state_update(table, NFT_VALIDATE_NEED);
 
 		expr_info[i].ops = NULL;
 		expr = nft_expr_next(expr);
@@ -3710,7 +3709,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (flow)
 		nft_trans_flow_rule(trans) = flow;
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -6312,7 +6311,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (desc.type == NFT_DATA_VERDICT &&
 			    (elem.data.val.verdict.code == NFT_GOTO ||
 			     elem.data.val.verdict.code == NFT_JUMP))
-				nft_validate_state_update(ctx->net,
+				nft_validate_state_update(ctx->table,
 							  NFT_VALIDATE_NEED);
 		}
 
@@ -6437,7 +6436,6 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -6476,7 +6474,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 		}
 	}
 
-	if (nft_net->validate_state == NFT_VALIDATE_DO)
+	if (table->validate_state == NFT_VALIDATE_DO)
 		return nft_table_validate(net, table);
 
 	return 0;
@@ -8628,19 +8626,20 @@ static int nf_tables_validate(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
-	switch (nft_net->validate_state) {
-	case NFT_VALIDATE_SKIP:
-		break;
-	case NFT_VALIDATE_NEED:
-		nft_validate_state_update(net, NFT_VALIDATE_DO);
-		fallthrough;
-	case NFT_VALIDATE_DO:
-		list_for_each_entry(table, &nft_net->tables, list) {
+	list_for_each_entry(table, &nft_net->tables, list) {
+		switch (table->validate_state) {
+		case NFT_VALIDATE_SKIP:
+			continue;
+		case NFT_VALIDATE_NEED:
+			nft_validate_state_update(table, NFT_VALIDATE_DO);
+			fallthrough;
+		case NFT_VALIDATE_DO:
 			if (nft_table_validate(net, table) < 0)
 				return -EAGAIN;
+
+			nft_validate_state_update(table, NFT_VALIDATE_SKIP);
 		}
 
-		nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 		break;
 	}
 
@@ -10355,7 +10354,6 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
-	nft_net->validate_state = NFT_VALIDATE_SKIP;
 
 	return 0;
 }
-- 
2.30.2

