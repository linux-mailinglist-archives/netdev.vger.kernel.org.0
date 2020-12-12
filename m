Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF9B2D8A89
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408171AbgLLXGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:06:15 -0500
Received: from correo.us.es ([193.147.175.20]:46808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408169AbgLLXGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF029303D1A
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0324DA704
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5AE4DA730; Sun, 13 Dec 2020 00:05:14 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D99BDA704;
        Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E2D024265A5A;
        Sun, 13 Dec 2020 00:05:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/10] netfilter: nftables: generalize set extension to support for several expressions
Date:   Sun, 13 Dec 2020 00:05:12 +0100
Message-Id: <20201212230513.3465-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces NFT_SET_EXPR by NFT_SET_EXT_EXPRESSIONS. This new
extension allows to attach several expressions to one set element (not
only one single expression as NFT_SET_EXPR provides). This patch
prepares for support for several expressions per set element in the
netlink userspace API.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  36 ++++++++---
 net/netfilter/nf_tables_api.c     |  85 ++++++++++++++++++------
 net/netfilter/nft_dynset.c        | 103 ++++++++++++++++++++++++------
 net/netfilter/nft_set_hash.c      |  27 ++++++--
 4 files changed, 196 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0f4ae16a0c42..bba56f2ce60c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -421,6 +421,20 @@ struct nft_set_type {
 };
 #define to_set_type(o) container_of(o, struct nft_set_type, ops)
 
+struct nft_set_elem_expr {
+	u8				size;
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(struct nft_expr))));
+};
+
+#define nft_setelem_expr_at(__elem_expr, __offset)			\
+	((struct nft_expr *)&__elem_expr->data[__offset])
+
+#define nft_setelem_expr_foreach(__expr, __elem_expr, __size)		\
+	for (__expr = nft_setelem_expr_at(__elem_expr, 0), __size = 0;	\
+	     __size < (__elem_expr)->size;				\
+	     __size += (__expr)->ops->size, __expr = ((void *)(__expr)) + (__expr)->ops->size)
+
 #define NFT_SET_EXPR_MAX	2
 
 /**
@@ -547,7 +561,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	@NFT_SET_EXT_TIMEOUT: element timeout
  *	@NFT_SET_EXT_EXPIRATION: element expiration time
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
- *	@NFT_SET_EXT_EXPR: expression assiociated with the element
+ *	@NFT_SET_EXT_EXPRESSIONS: expressions assiciated with the element
  *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
  *	@NFT_SET_EXT_NUM: number of extension types
  */
@@ -559,7 +573,7 @@ enum nft_set_extensions {
 	NFT_SET_EXT_TIMEOUT,
 	NFT_SET_EXT_EXPIRATION,
 	NFT_SET_EXT_USERDATA,
-	NFT_SET_EXT_EXPR,
+	NFT_SET_EXT_EXPRESSIONS,
 	NFT_SET_EXT_OBJREF,
 	NFT_SET_EXT_NUM
 };
@@ -677,9 +691,9 @@ static inline struct nft_userdata *nft_set_ext_userdata(const struct nft_set_ext
 	return nft_set_ext(ext, NFT_SET_EXT_USERDATA);
 }
 
-static inline struct nft_expr *nft_set_ext_expr(const struct nft_set_ext *ext)
+static inline struct nft_set_elem_expr *nft_set_ext_expr(const struct nft_set_ext *ext)
 {
-	return nft_set_ext(ext, NFT_SET_EXT_EXPR);
+	return nft_set_ext(ext, NFT_SET_EXT_EXPRESSIONS);
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
@@ -909,11 +923,17 @@ static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
 					    struct nft_regs *regs,
 					    const struct nft_pktinfo *pkt)
 {
+	struct nft_set_elem_expr *elem_expr;
 	struct nft_expr *expr;
-
-	if (__nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
-		expr = nft_set_ext_expr(ext);
-		expr->ops->eval(expr, regs, pkt);
+	u32 size;
+
+	if (__nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS)) {
+		elem_expr = nft_set_ext_expr(ext);
+		nft_setelem_expr_foreach(expr, elem_expr, size) {
+			expr->ops->eval(expr, regs, pkt);
+			if (regs->verdict.code == NFT_BREAK)
+				return;
+		}
 	}
 }
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ade10cd23acc..a3d5014dd246 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4496,8 +4496,8 @@ const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_DATA]		= {
 		.align	= __alignof__(u32),
 	},
-	[NFT_SET_EXT_EXPR]		= {
-		.align	= __alignof__(struct nft_expr),
+	[NFT_SET_EXT_EXPRESSIONS]	= {
+		.align	= __alignof__(struct nft_set_elem_expr),
 	},
 	[NFT_SET_EXT_OBJREF]		= {
 		.len	= sizeof(struct nft_object *),
@@ -4573,6 +4573,29 @@ static int nft_ctx_init_from_elemattr(struct nft_ctx *ctx, struct net *net,
 	return 0;
 }
 
+static int nft_set_elem_expr_dump(struct sk_buff *skb,
+				  const struct nft_set *set,
+				  const struct nft_set_ext *ext)
+{
+	struct nft_set_elem_expr *elem_expr;
+	u32 size, num_exprs = 0;
+	struct nft_expr *expr;
+
+	elem_expr = nft_set_ext_expr(ext);
+	nft_setelem_expr_foreach(expr, elem_expr, size)
+		num_exprs++;
+
+	if (num_exprs == 1) {
+		expr = nft_setelem_expr_at(elem_expr, 0);
+		if (nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, expr) < 0)
+			return -1;
+
+		return 0;
+	}
+
+	return 0;
+}
+
 static int nf_tables_fill_setelem(struct sk_buff *skb,
 				  const struct nft_set *set,
 				  const struct nft_set_elem *elem)
@@ -4600,8 +4623,8 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 			  set->dlen) < 0)
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR) &&
-	    nft_expr_dump(skb, NFTA_SET_ELEM_EXPR, nft_set_ext_expr(ext)) < 0)
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
+	    nft_set_elem_expr_dump(skb, set, ext))
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
@@ -5096,8 +5119,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
-static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
-				      struct nft_expr *expr)
+static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+					struct nft_expr *expr)
 {
 	if (expr->ops->destroy_clone) {
 		expr->ops->destroy_clone(ctx, expr);
@@ -5107,6 +5130,16 @@ static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 	}
 }
 
+static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+				      struct nft_set_elem_expr *elem_expr)
+{
+	struct nft_expr *expr;
+	u32 size;
+
+	nft_setelem_expr_foreach(expr, elem_expr, size)
+		__nft_set_elem_expr_destroy(ctx, expr);
+}
+
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -5119,7 +5152,7 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
-	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
 		nft_set_elem_expr_destroy(&ctx, nft_set_ext_expr(ext));
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
@@ -5136,7 +5169,7 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS))
 		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
 
 	kfree(elem);
@@ -5171,6 +5204,18 @@ static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
 	return -ENOMEM;
 }
 
+static void nft_set_elem_expr_setup(const struct nft_set_ext *ext, int i,
+				    struct nft_expr *expr_array[])
+{
+	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
+	struct nft_expr *expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+
+	memcpy(expr, expr_array[i], expr_array[i]->ops->size);
+	elem_expr->size += expr_array[i]->ops->size;
+	kfree(expr_array[i]);
+	expr_array[i] = NULL;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5186,11 +5231,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
-	u32 flags = 0;
+	u32 flags = 0, size = 0;
 	u64 timeout;
 	u64 expiration;
-	u8 ulen;
 	int err, i;
+	u8 ulen;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
 					  nft_set_elem_policy, NULL);
@@ -5293,9 +5338,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
-	if (set->num_exprs == 1)
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPR,
-				       expr_array[0]->ops->size);
+	if (set->num_exprs) {
+		for (i = 0; i < set->num_exprs; i++)
+			size += expr_array[i]->ops->size;
+
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
+				       sizeof(struct nft_set_elem_expr) +
+				       size);
+	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
@@ -5377,13 +5427,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	if (set->num_exprs == 1) {
-		struct nft_expr *expr = expr_array[0];
-
-		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
-		kfree(expr);
-		expr_array[0] = NULL;
-	}
+	for (i = 0; i < set->num_exprs; i++)
+		nft_set_elem_expr_setup(ext, i, expr_array);
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 4353e47c30fc..d9e609b2e5d4 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -19,11 +19,30 @@ struct nft_dynset {
 	enum nft_registers		sreg_key:8;
 	enum nft_registers		sreg_data:8;
 	bool				invert;
+	u8				num_exprs;
 	u64				timeout;
-	struct nft_expr			*expr;
+	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
 	struct nft_set_binding		binding;
 };
 
+static int nft_dynset_expr_setup(const struct nft_dynset *priv,
+				 const struct nft_set_ext *ext)
+{
+	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
+	struct nft_expr *expr;
+	int i;
+
+	for (i = 0; i < priv->num_exprs; i++) {
+		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+		if (nft_expr_clone(expr, priv->expr_array[i]) < 0)
+			return -1;
+
+		elem_expr->size += priv->expr_array[i]->ops->size;
+	}
+
+	return 0;
+}
+
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
@@ -44,8 +63,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 		goto err1;
 
 	ext = nft_set_elem_ext(set, elem);
-	if (priv->expr != NULL &&
-	    nft_expr_clone(nft_set_ext_expr(ext), priv->expr) < 0)
+	if (priv->num_exprs && nft_dynset_expr_setup(priv, ext) < 0)
 		goto err2;
 
 	return elem;
@@ -90,6 +108,41 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_dynset_ext_add_expr(struct nft_dynset *priv)
+{
+	u8 size = 0;
+	int i;
+
+	for (i = 0; i < priv->num_exprs; i++)
+		size += priv->expr_array[i]->ops->size;
+
+	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPRESSIONS,
+			       sizeof(struct nft_set_elem_expr) + size);
+}
+
+static struct nft_expr *
+nft_dynset_expr_alloc(const struct nft_ctx *ctx, const struct nft_set *set,
+		      const struct nlattr *attr, int pos)
+{
+	struct nft_expr *expr;
+	int err;
+
+	expr = nft_set_elem_expr_alloc(ctx, set, attr);
+	if (IS_ERR(expr))
+		return expr;
+
+	if (set->exprs[pos] && set->exprs[pos]->ops != expr->ops) {
+		err = -EOPNOTSUPP;
+		goto err_dynset_expr;
+	}
+
+	return expr;
+
+err_dynset_expr:
+	nft_expr_destroy(ctx, expr);
+	return ERR_PTR(err);
+}
+
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_SET_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_SET_MAXNAMELEN - 1 },
@@ -110,7 +163,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set *set;
 	u64 timeout;
-	int err;
+	int err, i;
 
 	lockdep_assert_held(&ctx->net->nft.commit_mutex);
 
@@ -179,17 +232,23 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	} else if (set->flags & NFT_SET_MAP)
 		return -EINVAL;
 
-	if (tb[NFTA_DYNSET_EXPR] != NULL) {
+	if (tb[NFTA_DYNSET_EXPR]) {
+		struct nft_expr *dynset_expr;
+
 		if (!(set->flags & NFT_SET_EVAL))
 			return -EINVAL;
 
-		priv->expr = nft_set_elem_expr_alloc(ctx, set,
-						     tb[NFTA_DYNSET_EXPR]);
-		if (IS_ERR(priv->expr))
-			return PTR_ERR(priv->expr);
+		dynset_expr = nft_dynset_expr_alloc(ctx, set,
+						    tb[NFTA_DYNSET_EXPR], 0);
+		if (IS_ERR(dynset_expr))
+			return PTR_ERR(dynset_expr);
 
-		if (set->num_exprs == 1 &&
-		    set->exprs[0]->ops != priv->expr->ops) {
+		priv->num_exprs++;
+		priv->expr_array[0] = dynset_expr;
+
+		if (set->num_exprs > 1 ||
+		    (set->num_exprs == 1 &&
+		     dynset_expr->ops != set->exprs[0]->ops)) {
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
@@ -199,9 +258,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
 	if (set->flags & NFT_SET_MAP)
 		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_DATA, set->dlen);
-	if (priv->expr != NULL)
-		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPR,
-				       priv->expr->ops->size);
+
+	if (priv->num_exprs)
+		nft_dynset_ext_add_expr(priv);
+
 	if (set->flags & NFT_SET_TIMEOUT) {
 		if (timeout || set->timeout)
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
@@ -220,8 +280,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return 0;
 
 err_expr_free:
-	if (priv->expr != NULL)
-		nft_expr_destroy(ctx, priv->expr);
+	for (i = 0; i < priv->num_exprs; i++)
+		nft_expr_destroy(ctx, priv->expr_array[i]);
 	return err;
 }
 
@@ -246,9 +306,10 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
+	int i;
 
-	if (priv->expr != NULL)
-		nft_expr_destroy(ctx, priv->expr);
+	for (i = 0; i < priv->num_exprs; i++)
+		nft_expr_destroy(ctx, priv->expr_array[i]);
 
 	nf_tables_destroy_set(ctx, priv->set);
 }
@@ -271,8 +332,10 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
-	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
-		goto nla_put_failure;
+	if (priv->num_exprs == 1) {
+		if (nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr_array[0]))
+			goto nla_put_failure;
+	}
 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 	return 0;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 4d3f147e8d8d..bf618b7ec1ae 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -293,6 +293,22 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	rhashtable_walk_exit(&hti);
 }
 
+static bool nft_rhash_expr_needs_gc_run(const struct nft_set *set,
+					struct nft_set_ext *ext)
+{
+	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
+	struct nft_expr *expr;
+	u32 size;
+
+	nft_setelem_expr_foreach(expr, elem_expr, size) {
+		if (expr->ops->gc &&
+		    expr->ops->gc(read_pnet(&set->net), expr))
+			return true;
+	}
+
+	return false;
+}
+
 static void nft_rhash_gc(struct work_struct *work)
 {
 	struct nft_set *set;
@@ -314,16 +330,13 @@ static void nft_rhash_gc(struct work_struct *work)
 			continue;
 		}
 
-		if (nft_set_ext_exists(&he->ext, NFT_SET_EXT_EXPR)) {
-			struct nft_expr *expr = nft_set_ext_expr(&he->ext);
+		if (nft_set_ext_exists(&he->ext, NFT_SET_EXT_EXPRESSIONS) &&
+		    nft_rhash_expr_needs_gc_run(set, &he->ext))
+			goto needs_gc_run;
 
-			if (expr->ops->gc &&
-			    expr->ops->gc(read_pnet(&set->net), expr))
-				goto gc;
-		}
 		if (!nft_set_elem_expired(&he->ext))
 			continue;
-gc:
+needs_gc_run:
 		if (nft_set_elem_mark_busy(&he->ext))
 			continue;
 
-- 
2.20.1

