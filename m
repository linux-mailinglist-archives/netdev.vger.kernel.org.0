Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F802D8A8B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408175AbgLLXGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:06:15 -0500
Received: from correo.us.es ([193.147.175.20]:46812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408170AbgLLXGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74DB9303D24
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66B8EDA73D
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C310DA722; Sun, 13 Dec 2020 00:05:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1DF3DA73D;
        Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B0C8D4265A5A;
        Sun, 13 Dec 2020 00:05:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/10] netfilter: nftables: netlink support for several set element expressions
Date:   Sun, 13 Dec 2020 00:05:13 +0100
Message-Id: <20201212230513.3465-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds three new netlink attributes to encapsulate a list of
expressions per set elements:

- NFTA_SET_EXPRESSIONS: this attribute provides the set definition in
  terms of expressions. New set elements get attached the list of
  expressions that is specified by this new netlink attribute.
- NFTA_SET_ELEM_EXPRESSIONS: this attribute allows users to restore (or
  initialize) the stateful information of set elements when adding an
  element to the set.
- NFTA_DYNSET_EXPRESSIONS: this attribute specifies the list of
  expressions that the set element gets when it is inserted from the
  packet path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 ++
 net/netfilter/nf_tables_api.c            | 93 +++++++++++++++++++++++-
 net/netfilter/nft_dynset.c               | 56 +++++++++++++-
 3 files changed, 149 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 98272cb5f617..28b6ee53305f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -361,6 +361,7 @@ enum nft_set_field_attributes {
  * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_SET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -381,6 +382,7 @@ enum nft_set_attributes {
 	NFTA_SET_OBJ_TYPE,
 	NFTA_SET_HANDLE,
 	NFTA_SET_EXPR,
+	NFTA_SET_EXPRESSIONS,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -406,6 +408,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
  * @NFTA_SET_ELEM_KEY_END: closing key value (NLA_NESTED: nft_data)
+ * @NFTA_SET_ELEM_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -419,6 +422,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_PAD,
 	NFTA_SET_ELEM_OBJREF,
 	NFTA_SET_ELEM_KEY_END,
+	NFTA_SET_ELEM_EXPRESSIONS,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
@@ -715,6 +719,7 @@ enum nft_dynset_flags {
  * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
  * @NFTA_DYNSET_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_DYNSET_FLAGS: flags (NLA_U32)
+ * @NFTA_DYNSET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
  */
 enum nft_dynset_attributes {
 	NFTA_DYNSET_UNSPEC,
@@ -727,6 +732,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_EXPR,
 	NFTA_DYNSET_PAD,
 	NFTA_DYNSET_FLAGS,
+	NFTA_DYNSET_EXPRESSIONS,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3d5014dd246..243e3c2c7629 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3566,6 +3566,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
+	[NFTA_SET_EXPRESSIONS]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
@@ -3773,6 +3774,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	u32 portid = ctx->portid;
 	struct nlattr *nest;
 	u32 seq = ctx->seq;
+	int i;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
@@ -3847,6 +3849,17 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
+	} else if (set->num_exprs > 1) {
+		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPRESSIONS);
+		if (nest == NULL)
+			goto nla_put_failure;
+
+		for (i = 0; i < set->num_exprs; i++) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+					  set->exprs[i]) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
 	}
 
 	nlmsg_end(skb, nlh);
@@ -4215,7 +4228,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
-	if (nla[NFTA_SET_EXPR])
+	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])
 		desc.expr = true;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
@@ -4281,6 +4294,29 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		}
 		set->exprs[0] = expr;
 		set->num_exprs++;
+	} else if (nla[NFTA_SET_EXPRESSIONS]) {
+		struct nft_expr *expr;
+		struct nlattr *tmp;
+		int left;
+
+		i = 0;
+		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
+			if (i == NFT_SET_EXPR_MAX) {
+				err = -E2BIG;
+				goto err_set_init;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_set_init;
+			}
+			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
+			if (IS_ERR(expr)) {
+				err = PTR_ERR(expr);
+				goto err_set_init;
+			}
+			set->exprs[i++] = expr;
+			set->num_exprs++;
+		}
 	}
 
 	udata = NULL;
@@ -4540,6 +4576,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
 					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_EXPRESSIONS]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -4580,6 +4617,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 	struct nft_set_elem_expr *elem_expr;
 	u32 size, num_exprs = 0;
 	struct nft_expr *expr;
+	struct nlattr *nest;
 
 	elem_expr = nft_set_ext_expr(ext);
 	nft_setelem_expr_foreach(expr, elem_expr, size)
@@ -4591,9 +4629,22 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 			return -1;
 
 		return 0;
-	}
+	} else if (num_exprs > 1) {
+		nest = nla_nest_start_noflag(skb, NFTA_SET_ELEM_EXPRESSIONS);
+		if (nest == NULL)
+			goto nla_put_failure;
 
+		nft_setelem_expr_foreach(expr, elem_expr, size) {
+			expr = nft_setelem_expr_at(elem_expr, size);
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
+	}
 	return 0;
+
+nla_put_failure:
+	return -1;
 }
 
 static int nf_tables_fill_setelem(struct sk_buff *skb,
@@ -5268,7 +5319,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	      nla[NFTA_SET_ELEM_TIMEOUT] ||
 	      nla[NFTA_SET_ELEM_EXPIRATION] ||
 	      nla[NFTA_SET_ELEM_USERDATA] ||
-	      nla[NFTA_SET_ELEM_EXPR]))
+	      nla[NFTA_SET_ELEM_EXPR] ||
+	      nla[NFTA_SET_ELEM_EXPRESSIONS]))
 		return -EINVAL;
 
 	timeout = 0;
@@ -5310,6 +5362,41 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
+	} else if (nla[NFTA_SET_ELEM_EXPRESSIONS]) {
+		struct nft_expr *expr;
+		struct nlattr *tmp;
+		int left;
+
+		if (set->num_exprs == 0)
+			return -EOPNOTSUPP;
+
+		i = 0;
+		nla_for_each_nested(tmp, nla[NFTA_SET_ELEM_EXPRESSIONS], left) {
+			if (i == set->num_exprs) {
+				err = -E2BIG;
+				goto err_set_elem_expr;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_set_elem_expr;
+			}
+			expr = nft_set_elem_expr_alloc(ctx, set, tmp);
+			if (IS_ERR(expr)) {
+				err = PTR_ERR(expr);
+				goto err_set_elem_expr;
+			}
+			expr_array[i] = expr;
+
+			if (expr->ops != set->exprs[i]->ops) {
+				err = -EOPNOTSUPP;
+				goto err_set_elem_expr;
+			}
+			i++;
+		}
+		if (set->num_exprs != i) {
+			err = -EOPNOTSUPP;
+			goto err_set_elem_expr;
+		}
 	} else if (set->num_exprs > 0) {
 		err = nft_set_elem_expr_clone(ctx, set, expr_array);
 		if (err < 0)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index d9e609b2e5d4..13c426d5dcf9 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -153,6 +153,7 @@ static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_TIMEOUT]	= { .type = NLA_U64 },
 	[NFTA_DYNSET_EXPR]	= { .type = NLA_NESTED },
 	[NFTA_DYNSET_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_DYNSET_EXPRESSIONS] = { .type = NLA_NESTED },
 };
 
 static int nft_dynset_init(const struct nft_ctx *ctx,
@@ -232,12 +233,13 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	} else if (set->flags & NFT_SET_MAP)
 		return -EINVAL;
 
+	if ((tb[NFTA_DYNSET_EXPR] || tb[NFTA_DYNSET_EXPRESSIONS]) &&
+	    !(set->flags & NFT_SET_EVAL))
+		return -EINVAL;
+
 	if (tb[NFTA_DYNSET_EXPR]) {
 		struct nft_expr *dynset_expr;
 
-		if (!(set->flags & NFT_SET_EVAL))
-			return -EINVAL;
-
 		dynset_expr = nft_dynset_expr_alloc(ctx, set,
 						    tb[NFTA_DYNSET_EXPR], 0);
 		if (IS_ERR(dynset_expr))
@@ -252,6 +254,40 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
+	} else if (tb[NFTA_DYNSET_EXPRESSIONS]) {
+		struct nft_expr *dynset_expr;
+		struct nlattr *tmp;
+		int left;
+
+		i = 0;
+		nla_for_each_nested(tmp, tb[NFTA_DYNSET_EXPRESSIONS], left) {
+			if (i == NFT_SET_EXPR_MAX) {
+				err = -E2BIG;
+				goto err_expr_free;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_expr_free;
+			}
+			dynset_expr = nft_dynset_expr_alloc(ctx, set, tmp, i);
+			if (IS_ERR(dynset_expr)) {
+				err = PTR_ERR(dynset_expr);
+				goto err_expr_free;
+			}
+			priv->expr_array[i] = dynset_expr;
+			priv->num_exprs++;
+
+			if (set->num_exprs &&
+			    dynset_expr->ops != set->exprs[i]->ops) {
+				err = -EOPNOTSUPP;
+				goto err_expr_free;
+			}
+			i++;
+		}
+		if (set->num_exprs && set->num_exprs != i) {
+			err = -EOPNOTSUPP;
+			goto err_expr_free;
+		}
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
@@ -318,6 +354,7 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	u32 flags = priv->invert ? NFT_DYNSET_F_INV : 0;
+	int i;
 
 	if (nft_dump_register(skb, NFTA_DYNSET_SREG_KEY, priv->sreg_key))
 		goto nla_put_failure;
@@ -335,6 +372,19 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (priv->num_exprs == 1) {
 		if (nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr_array[0]))
 			goto nla_put_failure;
+	} else if (priv->num_exprs > 1) {
+		struct nlattr *nest;
+
+		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
+		if (!nest)
+			goto nla_put_failure;
+
+		for (i = 0; i < priv->num_exprs; i++) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+					  priv->expr_array[i]))
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
 	}
 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
 		goto nla_put_failure;
-- 
2.20.1

