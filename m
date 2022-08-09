Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5AF58E27D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiHIWGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiHIWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4CEB13F3B;
        Tue,  9 Aug 2022 15:05:41 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/8] netfilter: nf_tables: validate variable length element extension
Date:   Wed, 10 Aug 2022 00:05:25 +0200
Message-Id: <20220809220532.130240-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
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

Update template to validate variable length extensions. This patch adds
a new .ext_len[id] field to the template to store the expected extension
length. This is used to sanity check the initialization of the variable
length extension.

Use PTR_ERR() in nft_set_elem_init() to report errors since, after this
update, there are two reason why this might fail, either because of
ENOMEM or insufficient room in the extension field (EINVAL).

Kernels up until 7e6bc1f6cabc ("netfilter: nf_tables: stricter
validation of element data") allowed to copy more data to the extension
than was allocated. This ext_len field allows to validate if the
destination has the correct size as additional check.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 +-
 net/netfilter/nf_tables_api.c     | 84 +++++++++++++++++++++++++------
 net/netfilter/nft_dynset.c        |  2 +-
 3 files changed, 73 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8bfb9c74afbf..7ece4fd0cf66 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -651,6 +651,7 @@ extern const struct nft_set_ext_type nft_set_ext_types[];
 struct nft_set_ext_tmpl {
 	u16	len;
 	u8	offset[NFT_SET_EXT_NUM];
+	u8	ext_len[NFT_SET_EXT_NUM];
 };
 
 /**
@@ -680,7 +681,8 @@ static inline int nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
 		return -EINVAL;
 
 	tmpl->offset[id] = tmpl->len;
-	tmpl->len	+= nft_set_ext_types[id].len + len;
+	tmpl->ext_len[id] = nft_set_ext_types[id].len + len;
+	tmpl->len	+= tmpl->ext_len[id];
 
 	return 0;
 }
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9f976b11d896..3b09e13b9b5c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5467,6 +5467,27 @@ struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
+static int nft_set_ext_check(const struct nft_set_ext_tmpl *tmpl, u8 id, u32 len)
+{
+	len += nft_set_ext_types[id].len;
+	if (len > tmpl->ext_len[id] ||
+	    len > U8_MAX)
+		return -1;
+
+	return 0;
+}
+
+static int nft_set_ext_memcpy(const struct nft_set_ext_tmpl *tmpl, u8 id,
+			      void *to, const void *from, u32 len)
+{
+	if (nft_set_ext_check(tmpl, id, len) < 0)
+		return -1;
+
+	memcpy(to, from, len);
+
+	return 0;
+}
+
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end,
@@ -5477,17 +5498,26 @@ void *nft_set_elem_init(const struct nft_set *set,
 
 	elem = kzalloc(set->ops->elemsize + tmpl->len, gfp);
 	if (elem == NULL)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ext = nft_set_elem_ext(set, elem);
 	nft_set_ext_init(ext, tmpl);
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY))
-		memcpy(nft_set_ext_key(ext), key, set->klen);
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
-		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
-		memcpy(nft_set_ext_data(ext), data, set->dlen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY) &&
+	    nft_set_ext_memcpy(tmpl, NFT_SET_EXT_KEY,
+			       nft_set_ext_key(ext), key, set->klen) < 0)
+		goto err_ext_check;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END) &&
+	    nft_set_ext_memcpy(tmpl, NFT_SET_EXT_KEY_END,
+			       nft_set_ext_key_end(ext), key_end, set->klen) < 0)
+		goto err_ext_check;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
+	    nft_set_ext_memcpy(tmpl, NFT_SET_EXT_DATA,
+			       nft_set_ext_data(ext), data, set->dlen) < 0)
+		goto err_ext_check;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		*nft_set_ext_expiration(ext) = get_jiffies_64() + expiration;
 		if (expiration == 0)
@@ -5497,6 +5527,11 @@ void *nft_set_elem_init(const struct nft_set *set,
 		*nft_set_ext_timeout(ext) = timeout;
 
 	return elem;
+
+err_ext_check:
+	kfree(elem);
+
+	return ERR_PTR(-EINVAL);
 }
 
 static void __nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
@@ -5584,14 +5619,25 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 }
 
 static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
+				   const struct nft_set_ext_tmpl *tmpl,
 				   const struct nft_set_ext *ext,
 				   struct nft_expr *expr_array[],
 				   u32 num_exprs)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
+	u32 len = sizeof(struct nft_set_elem_expr);
 	struct nft_expr *expr;
 	int i, err;
 
+	if (num_exprs == 0)
+		return 0;
+
+	for (i = 0; i < num_exprs; i++)
+		len += expr_array[i]->ops->size;
+
+	if (nft_set_ext_check(tmpl, NFT_SET_EXT_EXPRESSIONS, len) < 0)
+		return -EINVAL;
+
 	for (i = 0; i < num_exprs; i++) {
 		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
 		err = nft_expr_clone(expr, expr_array[i]);
@@ -6054,17 +6100,23 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		}
 	}
 
-	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
 				      elem.key_end.val.data, elem.data.val.data,
 				      timeout, expiration, GFP_KERNEL_ACCOUNT);
-	if (elem.priv == NULL)
+	if (IS_ERR(elem.priv)) {
+		err = PTR_ERR(elem.priv);
 		goto err_parse_data;
+	}
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
+
 	if (ulen > 0) {
+		if (nft_set_ext_check(&tmpl, NFT_SET_EXT_USERDATA, ulen) < 0) {
+			err = -EINVAL;
+			goto err_elem_userdata;
+		}
 		udata = nft_set_ext_userdata(ext);
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
@@ -6073,14 +6125,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	err = nft_set_elem_expr_setup(ctx, ext, expr_array, num_exprs);
+	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
 	if (err < 0)
-		goto err_elem_expr;
+		goto err_elem_free;
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_elem_free;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
@@ -6126,10 +6178,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
-err_elem_expr:
+err_elem_free:
 	if (obj)
 		obj->use--;
-
+err_elem_userdata:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
@@ -6311,8 +6363,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
 				      elem.key_end.val.data, NULL, 0, 0,
 				      GFP_KERNEL_ACCOUNT);
-	if (elem.priv == NULL)
+	if (IS_ERR(elem.priv)) {
+		err = PTR_ERR(elem.priv);
 		goto fail_elem_key_end;
+	}
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 22f70b543fa2..6983e6ddeef9 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -60,7 +60,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 				 &regs->data[priv->sreg_key], NULL,
 				 &regs->data[priv->sreg_data],
 				 timeout, 0, GFP_ATOMIC);
-	if (elem == NULL)
+	if (IS_ERR(elem))
 		goto err1;
 
 	ext = nft_set_elem_ext(set, elem);
-- 
2.30.2

