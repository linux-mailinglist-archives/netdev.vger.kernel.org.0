Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687A74A9BCA
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359625AbiBDPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:14 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50340 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359608AbiBDPTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:10 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 21B5560191;
        Fri,  4 Feb 2022 16:19:04 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next] netfilter: nft_cmp: optimize comparison for up to 16-bytes
Date:   Fri,  4 Feb 2022 16:18:58 +0100
Message-Id: <20220204151903.320786-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow up to 16-byte comparisons with the cmp fast version. Use two
64-bit words and calculate the mask representing the bits to be
compared. Make sure the comparison is 64-bit aligned and avoid
out-of-bound memory access.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  4 +--
 net/netfilter/nf_tables_core.c         |  6 +++-
 net/netfilter/nft_cmp.c                | 48 +++++++++++++++++---------
 3 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index b6fb1fdff9b2..52395e216ecc 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -35,8 +35,8 @@ struct nft_bitwise_fast_expr {
 };
 
 struct nft_cmp_fast_expr {
-	u32			data;
-	u32			mask;
+	struct nft_data		data;
+	struct nft_data		mask;
 	u8			sreg;
 	u8			len;
 	bool			inv;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 36e73f9828c5..000c598cbc13 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -61,8 +61,12 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 			      struct nft_regs *regs)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
 
-	if (((regs->data[priv->sreg] & priv->mask) == priv->data) ^ priv->inv)
+	if (((reg_data[0] & mask[0]) == data[0] &&
+	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
 		return;
 	regs->verdict.code = NFT_BREAK;
 }
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 47b6d05f1ae6..ea9dcb380cac 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -76,6 +76,7 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct nft_data_desc desc;
 	int err;
 
+	memset(&priv->data, 0, sizeof(priv->data));
 	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
 			    tb[NFTA_CMP_DATA]);
 	if (err < 0)
@@ -196,16 +197,32 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.offload	= nft_cmp_offload,
 };
 
+static void nft_cmp16_fast_mask(struct nft_data *data, unsigned int bitlen)
+{
+	int len = bitlen / BITS_PER_BYTE;
+	int i, words = len / sizeof(u32);
+
+	for (i = 0; i < words; i++) {
+		data->data[i] = 0xffffffff;
+		bitlen -= sizeof(u32) * BITS_PER_BYTE;
+	}
+
+	if (len % sizeof(u32))
+		data->data[i++] = cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
+
+	for (; i < 4; i++)
+		data->data[i] = 0;
+}
+
 static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 			     const struct nft_expr *expr,
 			     const struct nlattr * const tb[])
 {
 	struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	struct nft_data_desc desc;
-	struct nft_data data;
 	int err;
 
-	err = nft_data_init(NULL, &data, sizeof(data), &desc,
+	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
 			    tb[NFTA_CMP_DATA]);
 	if (err < 0)
 		return err;
@@ -214,12 +231,10 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	desc.len *= BITS_PER_BYTE;
-
-	priv->mask = nft_cmp_fast_mask(desc.len);
-	priv->data = data.data[0] & priv->mask;
 	priv->len  = desc.len;
 	priv->inv  = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
+	nft_cmp16_fast_mask(&priv->mask, desc.len * BITS_PER_BYTE);
+
 	return 0;
 }
 
@@ -229,13 +244,9 @@ static int nft_cmp_fast_offload(struct nft_offload_ctx *ctx,
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	struct nft_cmp_expr cmp = {
-		.data	= {
-			.data	= {
-				[0] = priv->data,
-			},
-		},
+		.data	= priv->data,
 		.sreg	= priv->sreg,
-		.len	= priv->len / BITS_PER_BYTE,
+		.len	= priv->len,
 		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
 	};
 
@@ -246,16 +257,14 @@ static int nft_cmp_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
 	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
-	struct nft_data data;
 
 	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
 		goto nla_put_failure;
 
-	data.data[0] = priv->data;
-	if (nft_data_dump(skb, NFTA_CMP_DATA, &data,
-			  NFT_DATA_VALUE, priv->len / BITS_PER_BYTE) < 0)
+	if (nft_data_dump(skb, NFTA_CMP_DATA, &priv->data,
+			  NFT_DATA_VALUE, priv->len) < 0)
 		goto nla_put_failure;
 	return 0;
 
@@ -278,6 +287,7 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	struct nft_data_desc desc;
 	struct nft_data data;
 	enum nft_cmp_ops op;
+	u8 sreg;
 	int err;
 
 	if (tb[NFTA_CMP_SREG] == NULL ||
@@ -306,7 +316,11 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	if (desc.type != NFT_DATA_VALUE)
 		goto err1;
 
-	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
+	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
+
+	if (sreg >= NFT_REG_1 && sreg <= NFT_REG32_12 &&
+	    (sreg <= NFT_REG_4 || sreg % 2 == 0) &&
+	    (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
 		return &nft_cmp_fast_ops;
 
 	return &nft_cmp_ops;
-- 
2.30.2

