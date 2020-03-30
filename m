Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A056E19841E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgC3TWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:09 -0400
Received: from correo.us.es ([193.147.175.20]:48570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgC3TWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09648B496E
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2A5FDA8E6
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1DE2123964; Mon, 30 Mar 2020 21:21:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85AD5100A53;
        Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5805442EF4E1;
        Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/28] netfilter: nf_tables: add nft_set_elem_expr_destroy() and use it
Date:   Mon, 30 Mar 2020 21:21:13 +0200
Message-Id: <20200330192136.230459-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds nft_set_elem_expr_destroy() to destroy stateful
expressions in set elements.

This patch also updates the commit path to call this function to invoke
expr->ops->destroy_clone when required.

This is implicitly fixing up a module reference counter leak and
a memory leak in expressions that allocated internal state, e.g.
nft_counter.

Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 29ad33e52dbb..c5332a313283 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4882,6 +4882,17 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
+static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+				      struct nft_expr *expr)
+{
+	if (expr->ops->destroy_clone) {
+		expr->ops->destroy_clone(ctx, expr);
+		module_put(expr->ops->type->owner);
+	} else {
+		nf_tables_expr_destroy(ctx, expr);
+	}
+}
+
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -4894,16 +4905,9 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
-	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
-		struct nft_expr *expr = nft_set_ext_expr(ext);
+	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+		nft_set_elem_expr_destroy(&ctx, nft_set_ext_expr(ext));
 
-		if (expr->ops->destroy_clone) {
-			expr->ops->destroy_clone(&ctx, expr);
-			module_put(expr->ops->type->owner);
-		} else {
-			nf_tables_expr_destroy(&ctx, expr);
-		}
-	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		(*nft_set_ext_obj(ext))->use--;
 	kfree(elem);
@@ -4919,7 +4923,8 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-		nf_tables_expr_destroy(ctx, nft_set_ext_expr(ext));
+		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
+
 	kfree(elem);
 }
 
@@ -5182,7 +5187,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_trans:
 	if (obj)
 		obj->use--;
-	kfree(elem.priv);
+
+	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&data, desc.type);
-- 
2.11.0

