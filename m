Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E0B149FC0
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgA0IWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:22:08 -0500
Received: from correo.us.es ([193.147.175.20]:36428 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgA0IWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:22:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F41AB1931
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85C33DA723
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:22:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A993DA71F; Mon, 27 Jan 2020 09:22:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEE36DA707;
        Mon, 27 Jan 2020 09:22:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jan 2020 09:22:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9D2BA42EFB83;
        Mon, 27 Jan 2020 09:22:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/6] netfilter: nf_tables: add nft_setelem_parse_key()
Date:   Mon, 27 Jan 2020 09:20:49 +0100
Message-Id: <20200127082054.318263-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200127082054.318263-1-pablo@netfilter.org>
References: <20200127082054.318263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper function to parse the set element key netlink attribute.

v4: No changes
v3: New patch

[sbrivio: refactor error paths and labels; use NFT_DATA_VALUE_MAXLEN
  instead of sizeof(*key) in helper, value can be longer than that;
  rebase]
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 91 +++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7e63b481cc86..58e3b285a3d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4524,11 +4524,28 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 	return 0;
 }
 
+static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
+				 struct nft_data *key, struct nlattr *attr)
+{
+	struct nft_data_desc desc;
+	int err;
+
+	err = nft_data_init(ctx, key, NFT_DATA_VALUE_MAXLEN, &desc, attr);
+	if (err < 0)
+		return err;
+
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
+		nft_data_release(key, desc.type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
 	uint32_t flags = 0;
@@ -4547,17 +4564,11 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
 		return err;
 
-	err = -EINVAL;
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
-		nft_data_release(&elem.key.val, desc.type);
-		return err;
-	}
-
 	priv = set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
 		return PTR_ERR(priv);
@@ -4756,13 +4767,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	u8 genmask = nft_genmask_next(ctx->net);
-	struct nft_data_desc d1, d2;
 	struct nft_set_ext_tmpl tmpl;
 	struct nft_set_ext *ext, *ext2;
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
 	struct nft_userdata *udata;
+	struct nft_data_desc desc;
 	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
@@ -4828,15 +4839,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
-	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
 		goto err1;
-	err = -EINVAL;
-	if (d1.type != NFT_DATA_VALUE || d1.len != set->klen)
-		goto err2;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, d1.len);
+	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 	if (timeout > 0) {
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
 		if (timeout != set->timeout)
@@ -4859,13 +4867,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
-		err = nft_data_init(ctx, &data, sizeof(data), &d2,
+		err = nft_data_init(ctx, &data, sizeof(data), &desc,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
 			goto err2;
 
 		err = -EINVAL;
-		if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
+		if (set->dtype != NFT_DATA_VERDICT && desc.len != set->dlen)
 			goto err3;
 
 		dreg = nft_type_to_reg(set->dtype);
@@ -4882,18 +4890,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 			err = nft_validate_register_store(&bind_ctx, dreg,
 							  &data,
-							  d2.type, d2.len);
+							  desc.type, desc.len);
 			if (err < 0)
 				goto err3;
 
-			if (d2.type == NFT_DATA_VERDICT &&
+			if (desc.type == NFT_DATA_VERDICT &&
 			    (data.verdict.code == NFT_GOTO ||
 			     data.verdict.code == NFT_JUMP))
 				nft_validate_state_update(ctx->net,
 							  NFT_VALIDATE_NEED);
 		}
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
 	}
 
 	/* The full maximum length of userdata can exceed the maximum
@@ -4976,9 +4984,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-		nft_data_release(&data, d2.type);
+		nft_data_release(&data, desc.type);
 err2:
-	nft_data_release(&elem.key.val, d1.type);
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err1:
 	return err;
 }
@@ -5074,7 +5082,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
-	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	struct nft_trans *trans;
@@ -5085,11 +5092,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
 					  nft_set_elem_policy, NULL);
 	if (err < 0)
-		goto err1;
+		return err;
 
-	err = -EINVAL;
 	if (nla[NFTA_SET_ELEM_KEY] == NULL)
-		goto err1;
+		return -EINVAL;
 
 	nft_set_ext_prepare(&tmpl);
 
@@ -5099,37 +5105,31 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags != 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
-	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
-
-	err = -EINVAL;
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
-		goto err2;
+		return err;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, desc.len);
+	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
 				      0, GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto err2;
+		goto fail_elem;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
-	if (trans == NULL) {
-		err = -ENOMEM;
-		goto err3;
-	}
+	if (trans == NULL)
+		goto fail_trans;
 
 	priv = set->ops->deactivate(ctx->net, set, &elem);
 	if (priv == NULL) {
 		err = -ENOENT;
-		goto err4;
+		goto fail_ops;
 	}
 	kfree(elem.priv);
 	elem.priv = priv;
@@ -5140,13 +5140,12 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err4:
+fail_ops:
 	kfree(trans);
-err3:
+fail_trans:
 	kfree(elem.priv);
-err2:
-	nft_data_release(&elem.key.val, desc.type);
-err1:
+fail_elem:
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 	return err;
 }
 
-- 
2.11.0

