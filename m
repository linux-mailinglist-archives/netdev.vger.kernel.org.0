Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575FE282D6F
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgJDTuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:32 -0400
Received: from correo.us.es ([193.147.175.20]:34996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgJDTuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0D88EF441
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8FA1DA730
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F44FDA792; Sun,  4 Oct 2020 21:50:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 462D2DA730;
        Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1BE3442EF9E0;
        Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 10/11] netfilter: nf_tables: Enable fast nft_cmp for inverted matches
Date:   Sun,  4 Oct 2020 21:49:39 +0200
Message-Id: <20201004194940.7368-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Add a boolean indicating NFT_CMP_NEQ. To include it into the match
decision, it is sufficient to XOR it with the data comparison's result.

While being at it, store the mask that is calculated during expression
init and free the eval routine from having to recalculate it each time.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  2 ++
 net/netfilter/nf_tables_core.c         |  3 +--
 net/netfilter/nft_cmp.c                | 13 +++++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 78516de14d31..df2d91c814cb 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -25,8 +25,10 @@ void nf_tables_core_module_exit(void);
 
 struct nft_cmp_fast_expr {
 	u32			data;
+	u32			mask;
 	enum nft_registers	sreg:8;
 	u8			len;
+	bool			inv;
 };
 
 struct nft_immediate_expr {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 587897a2498b..e92feacaf551 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -51,9 +51,8 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	u32 mask = nft_cmp_fast_mask(priv->len);
 
-	if ((regs->data[priv->sreg] & mask) == priv->data)
+	if (((regs->data[priv->sreg] & priv->mask) == priv->data) ^ priv->inv)
 		return;
 	regs->verdict.code = NFT_BREAK;
 }
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 16f4d84599ac..bc079d68a536 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -167,7 +167,6 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	struct nft_data_desc desc;
 	struct nft_data data;
-	u32 mask;
 	int err;
 
 	err = nft_data_init(NULL, &data, sizeof(data), &desc,
@@ -181,10 +180,11 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 		return err;
 
 	desc.len *= BITS_PER_BYTE;
-	mask = nft_cmp_fast_mask(desc.len);
 
-	priv->data = data.data[0] & mask;
+	priv->mask = nft_cmp_fast_mask(desc.len);
+	priv->data = data.data[0] & priv->mask;
 	priv->len  = desc.len;
+	priv->inv  = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
 	return 0;
 }
 
@@ -201,7 +201,7 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 		},
 		.sreg	= priv->sreg,
 		.len	= priv->len / BITS_PER_BYTE,
-		.op	= NFT_CMP_EQ,
+		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
 	};
 
 	return __nft_cmp_offload(ctx, flow, &cmp);
@@ -210,11 +210,12 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 static int nft_cmp_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
 	struct nft_data data;
 
 	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(NFT_CMP_EQ)))
+	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
 		goto nla_put_failure;
 
 	data.data[0] = priv->data;
@@ -272,7 +273,7 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 		goto err1;
 	}
 
-	if (desc.len <= sizeof(u32) && op == NFT_CMP_EQ)
+	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
 		return &nft_cmp_fast_ops;
 
 	return &nft_cmp_ops;
-- 
2.20.1

