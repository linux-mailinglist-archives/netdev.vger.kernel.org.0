Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41029198449
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgC3TXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:23:00 -0400
Received: from correo.us.es ([193.147.175.20]:48510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbgC3TWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E39E3FFB9E
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B429F123968
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35CA4100A69; Mon, 30 Mar 2020 21:21:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68E34100788;
        Mon, 30 Mar 2020 21:21:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 40A0B42EF4E0;
        Mon, 30 Mar 2020 21:21:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/28] netfilter: nf_tables: move nft_expr_clone() to nf_tables_api.c
Date:   Mon, 30 Mar 2020 21:21:09 +0200
Message-Id: <20200330192136.230459-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the nft_expr_clone() helper function to the core.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 18 ++++++++++++++++++
 net/netfilter/nft_dynset.c        | 17 -----------------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5d80e09f8148..af2ed70d7eed 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -846,6 +846,7 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f92fb6003745..4f6245e7988e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2557,6 +2557,24 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	return ERR_PTR(err);
 }
 
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+{
+	int err;
+
+	if (src->ops->clone) {
+		dst->ops = src->ops;
+		err = src->ops->clone(dst, src);
+		if (err < 0)
+			return err;
+	} else {
+		memcpy(dst, src, src->ops->size);
+	}
+
+	__module_get(src->ops->type->owner);
+
+	return 0;
+}
+
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr)
 {
 	nf_tables_expr_destroy(ctx, expr);
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 46ab28ec4b53..d1b64c8de585 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -24,23 +24,6 @@ struct nft_dynset {
 	struct nft_set_binding		binding;
 };
 
-static int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
-{
-	int err;
-
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
-
-	__module_get(src->ops->type->owner);
-	return 0;
-}
-
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
-- 
2.11.0

