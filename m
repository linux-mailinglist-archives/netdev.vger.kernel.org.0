Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0665F2D8A87
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439891AbgLLXGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:06:44 -0500
Received: from correo.us.es ([193.147.175.20]:46798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408166AbgLLXGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3DDE303D21
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D612ADA791
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CBA55DA78E; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B69CDA72F;
        Sun, 13 Dec 2020 00:05:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 725F94265A5A;
        Sun, 13 Dec 2020 00:05:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/10] netfilter: nftables: move nft_expr before nft_set
Date:   Sun, 13 Dec 2020 00:05:11 +0100
Message-Id: <20201212230513.3465-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the nft_expr structure definition before nft_set. Expressions are
used by rules and sets, remove unnecessary forward declarations. This
comes as preparation to support for multiple expressions per set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 54 +++++++++++++++----------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index aad7e1381200..0f4ae16a0c42 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -305,8 +305,33 @@ struct nft_set_estimate {
 	enum nft_set_class	space;
 };
 
+#define NFT_EXPR_MAXATTR		16
+#define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
+					 ALIGN(size, __alignof__(struct nft_expr)))
+
+/**
+ *	struct nft_expr - nf_tables expression
+ *
+ *	@ops: expression ops
+ *	@data: expression private data
+ */
+struct nft_expr {
+	const struct nft_expr_ops	*ops;
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
+};
+
+static inline void *nft_expr_priv(const struct nft_expr *expr)
+{
+	return (void *)expr->data;
+}
+
+int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
+void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
+int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
+		  const struct nft_expr *expr);
+
 struct nft_set_ext;
-struct nft_expr;
 
 /**
  *	struct nft_set_ops - nf_tables set operations
@@ -797,7 +822,6 @@ struct nft_offload_ctx;
  *	@validate: validate expression, called during loop detection
  *	@data: extra data to attach to this expression operation
  */
-struct nft_expr;
 struct nft_expr_ops {
 	void				(*eval)(const struct nft_expr *expr,
 						struct nft_regs *regs,
@@ -833,32 +857,6 @@ struct nft_expr_ops {
 	void				*data;
 };
 
-#define NFT_EXPR_MAXATTR		16
-#define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
-					 ALIGN(size, __alignof__(struct nft_expr)))
-
-/**
- *	struct nft_expr - nf_tables expression
- *
- *	@ops: expression ops
- *	@data: expression private data
- */
-struct nft_expr {
-	const struct nft_expr_ops	*ops;
-	unsigned char			data[]
-		__attribute__((aligned(__alignof__(u64))));
-};
-
-static inline void *nft_expr_priv(const struct nft_expr *expr)
-{
-	return (void *)expr->data;
-}
-
-int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
-void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
-int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
-		  const struct nft_expr *expr);
-
 /**
  *	struct nft_rule - nf_tables rule
  *
-- 
2.20.1

