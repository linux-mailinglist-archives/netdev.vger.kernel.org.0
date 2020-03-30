Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F4197175
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgC3AiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:38:13 -0400
Received: from correo.us.es ([193.147.175.20]:57136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgC3AhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5DF63EF42A
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C00B100A50
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 41942100A47; Mon, 30 Mar 2020 02:37:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CC4F100A48;
        Mon, 30 Mar 2020 02:37:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1804A42EF42A;
        Mon, 30 Mar 2020 02:37:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/26] netfilter: nf_tables: allow to specify stateful expression in set definition
Date:   Mon, 30 Mar 2020 02:36:45 +0200
Message-Id: <20200330003708.54017-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows users to specify the stateful expression for the
elements in this set via NFTA_SET_EXPR. This new feature allows you to
turn on counters for all of the elements in this set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 60 +++++++++++++++++++++++++-------
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af2ed70d7eed..642bc3ef81aa 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -416,6 +416,7 @@ struct nft_set_type {
  *	@policy: set parameterization (see enum nft_set_policies)
  *	@udlen: user data length
  *	@udata: user data
+ *	@expr: stateful expression
  * 	@ops: set ops
  * 	@flags: set flags
  *	@genmask: generation mask
@@ -444,6 +445,7 @@ struct nft_set {
 	u16				policy;
 	u16				udlen;
 	unsigned char			*udata;
+	struct nft_expr			*expr;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	u16				flags:14,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c3d2d04d6a1..4e3a5971d4ee 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -342,6 +342,7 @@ enum nft_set_field_attributes {
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
+ * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -361,6 +362,7 @@ enum nft_set_attributes {
 	NFTA_SET_PAD,
 	NFTA_SET_OBJ_TYPE,
 	NFTA_SET_HANDLE,
+	NFTA_SET_EXPR,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index df046cd97fa7..f1910cd795fd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3394,6 +3394,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 					    .len  = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
+	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
@@ -3597,8 +3598,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 {
 	struct nfgenmsg *nfmsg;
 	struct nlmsghdr *nlh;
-	struct nlattr *desc;
 	u32 portid = ctx->portid;
+	struct nlattr *nest;
 	u32 seq = ctx->seq;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
@@ -3654,9 +3655,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
 		goto nla_put_failure;
 
-	desc = nla_nest_start_noflag(skb, NFTA_SET_DESC);
-
-	if (desc == NULL)
+	nest = nla_nest_start_noflag(skb, NFTA_SET_DESC);
+	if (!nest)
 		goto nla_put_failure;
 	if (set->size &&
 	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
@@ -3666,7 +3666,15 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	    nf_tables_fill_set_concat(skb, set))
 		goto nla_put_failure;
 
-	nla_nest_end(skb, desc);
+	nla_nest_end(skb, nest);
+
+	if (set->expr) {
+		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
+		if (nf_tables_fill_expr_info(skb, set->expr) < 0)
+			goto nla_put_failure;
+
+		nla_nest_end(skb, nest);
+	}
 
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -3913,6 +3921,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	u8 genmask = nft_genmask_next(net);
 	int family = nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
+	struct nft_expr *expr = NULL;
 	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
@@ -4069,13 +4078,21 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	name = nla_strdup(nla[NFTA_SET_NAME], GFP_KERNEL);
 	if (!name) {
 		err = -ENOMEM;
-		goto err2;
+		goto err_set_name;
 	}
 
 	err = nf_tables_set_alloc_name(&ctx, set, name);
 	kfree(name);
 	if (err < 0)
-		goto err2;
+		goto err_set_alloc_name;
+
+	if (nla[NFTA_SET_EXPR]) {
+		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
+		if (IS_ERR(expr)) {
+			err = PTR_ERR(expr);
+			goto err_set_alloc_name;
+		}
+	}
 
 	udata = NULL;
 	if (udlen) {
@@ -4092,6 +4109,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->dtype = dtype;
 	set->objtype = objtype;
 	set->dlen  = desc.dlen;
+	set->expr = expr;
 	set->flags = flags;
 	set->size  = desc.size;
 	set->policy = policy;
@@ -4107,21 +4125,24 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
-		goto err3;
+		goto err_set_init;
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
 	if (err < 0)
-		goto err4;
+		goto err_set_trans;
 
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
 
-err4:
+err_set_trans:
 	ops->destroy(set);
-err3:
+err_set_init:
+	if (expr)
+		nft_expr_destroy(&ctx, expr);
+err_set_alloc_name:
 	kfree(set->name);
-err2:
+err_set_name:
 	kvfree(set);
 	return err;
 }
@@ -4131,6 +4152,9 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 	if (WARN_ON(set->use > 0))
 		return;
 
+	if (set->expr)
+		nft_expr_destroy(ctx, set->expr);
+
 	set->ops->destroy(set);
 	kfree(set->name);
 	kvfree(set);
@@ -4982,6 +5006,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					       nla[NFTA_SET_ELEM_EXPR]);
 		if (IS_ERR(expr))
 			return PTR_ERR(expr);
+
+		err = -EOPNOTSUPP;
+		if (set->expr && set->expr->ops != expr->ops)
+			goto err_set_elem_expr;
+	} else if (set->expr) {
+		expr = kzalloc(set->expr->ops->size, GFP_KERNEL);
+		if (!expr)
+			return -ENOMEM;
+
+		err = nft_expr_clone(expr, set->expr);
+		if (err < 0)
+			goto err_set_elem_expr;
 	}
 
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-- 
2.11.0

