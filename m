Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D8189313
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCRAk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:56 -0400
Received: from correo.us.es ([193.147.175.20]:45646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgCRAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 269DD27F8BC
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1759CDA3A1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CF22DA39F; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D0A6DA38D;
        Wed, 18 Mar 2020 01:39:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 27DDC426CCB9;
        Wed, 18 Mar 2020 01:39:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 23/29] netfilter: nf_tables: add elements with stateful expressions
Date:   Wed, 18 Mar 2020 01:39:50 +0100
Message-Id: <20200318003956.73573-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update nft_add_set_elem() to handle the NFTA_SET_ELEM_EXPR netlink
attribute. This patch allows users to to add elements with stateful
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bc7a33f0cd06..f92fb6003745 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4891,6 +4891,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
+	struct nft_expr *expr = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	struct nft_data data;
@@ -4958,10 +4959,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
+	if (nla[NFTA_SET_ELEM_EXPR] != NULL) {
+		expr = nft_set_elem_expr_alloc(ctx, set,
+					       nla[NFTA_SET_ELEM_EXPR]);
+		if (IS_ERR(expr))
+			return PTR_ERR(expr);
+	}
+
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
 				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		return err;
+		goto err_set_elem_expr;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 
@@ -4980,6 +4988,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
+	if (expr)
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPR,
+				       expr->ops->size);
+
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
 			err = -EINVAL;
@@ -5064,6 +5076,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
+	if (expr) {
+		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
+		kfree(expr);
+	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
@@ -5119,6 +5135,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
+err_set_elem_expr:
+	if (expr != NULL)
+		nft_expr_destroy(ctx, expr);
 
 	return err;
 }
-- 
2.11.0

