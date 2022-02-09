Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99934AF2EF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbiBINgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiBINg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16F7DC05CB88;
        Wed,  9 Feb 2022 05:36:30 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6EE46601D1;
        Wed,  9 Feb 2022 14:36:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/14] netfilter: nft_cmp: optimize comparison for 16-bytes
Date:   Wed,  9 Feb 2022 14:36:14 +0100
Message-Id: <20220209133616.165104-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
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

Allow up to 16-byte comparisons with a new cmp fast version. Use two
64-bit words and calculate the mask representing the bits to be
compared. Make sure the comparison is 64-bit aligned and avoid
out-of-bound memory access on registers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |   9 +++
 net/netfilter/nf_tables_core.c         |  16 ++++
 net/netfilter/nft_cmp.c                | 102 ++++++++++++++++++++++++-
 3 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index b6fb1fdff9b2..0ea7c55cea4d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -42,6 +42,14 @@ struct nft_cmp_fast_expr {
 	bool			inv;
 };
 
+struct nft_cmp16_fast_expr {
+	struct nft_data		data;
+	struct nft_data		mask;
+	u8			sreg;
+	u8			len;
+	bool			inv;
+};
+
 struct nft_immediate_expr {
 	struct nft_data		data;
 	u8			dreg;
@@ -59,6 +67,7 @@ static inline u32 nft_cmp_fast_mask(unsigned int len)
 }
 
 extern const struct nft_expr_ops nft_cmp_fast_ops;
+extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
 struct nft_payload {
 	enum nft_payload_bases	base:8;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 36e73f9828c5..c6c05b2412c4 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,20 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_cmp16_fast_eval(const struct nft_expr *expr,
+				struct nft_regs *regs)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	const u64 *reg_data = (const u64 *)&regs->data[priv->sreg];
+	const u64 *mask = (const u64 *)&priv->mask;
+	const u64 *data = (const u64 *)&priv->data;
+
+	if (((reg_data[0] & mask[0]) == data[0] &&
+	    ((reg_data[1] & mask[1]) == data[1])) ^ priv->inv)
+		return;
+	regs->verdict.code = NFT_BREAK;
+}
+
 static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
@@ -225,6 +239,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_dp_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
+			else if (expr->ops == &nft_cmp16_fast_ops)
+				nft_cmp16_fast_eval(expr, &regs);
 			else if (expr->ops == &nft_bitwise_fast_ops)
 				nft_bitwise_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 47b6d05f1ae6..917072af09df 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -272,12 +272,103 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
 	.offload	= nft_cmp_fast_offload,
 };
 
+static u32 nft_cmp_mask(u32 bitlen)
+{
+	return (__force u32)cpu_to_le32(~0U >> (sizeof(u32) * BITS_PER_BYTE - bitlen));
+}
+
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
+		data->data[i++] = nft_cmp_mask(bitlen);
+
+	for (; i < 4; i++)
+		data->data[i] = 0;
+}
+
+static int nft_cmp16_fast_init(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nlattr * const tb[])
+{
+	struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_data_desc desc;
+	int err;
+
+	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
+			    tb[NFTA_CMP_DATA]);
+	if (err < 0)
+		return err;
+
+	err = nft_parse_register_load(tb[NFTA_CMP_SREG], &priv->sreg, desc.len);
+	if (err < 0)
+		return err;
+
+	nft_cmp16_fast_mask(&priv->mask, desc.len * BITS_PER_BYTE);
+	priv->inv = ntohl(nla_get_be32(tb[NFTA_CMP_OP])) != NFT_CMP_EQ;
+	priv->len = desc.len;
+
+	return 0;
+}
+
+static int nft_cmp16_fast_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	struct nft_cmp_expr cmp = {
+		.data	= priv->data,
+		.sreg	= priv->sreg,
+		.len	= priv->len,
+		.op	= priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ,
+	};
+
+	return __nft_cmp_offload(ctx, flow, &cmp);
+}
+
+static int nft_cmp16_fast_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_cmp16_fast_expr *priv = nft_expr_priv(expr);
+	enum nft_cmp_ops op = priv->inv ? NFT_CMP_NEQ : NFT_CMP_EQ;
+
+	if (nft_dump_register(skb, NFTA_CMP_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_CMP_OP, htonl(op)))
+		goto nla_put_failure;
+
+	if (nft_data_dump(skb, NFTA_CMP_DATA, &priv->data,
+			  NFT_DATA_VALUE, priv->len) < 0)
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+
+const struct nft_expr_ops nft_cmp16_fast_ops = {
+	.type		= &nft_cmp_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp16_fast_expr)),
+	.eval		= NULL,	/* inlined */
+	.init		= nft_cmp16_fast_init,
+	.dump		= nft_cmp16_fast_dump,
+	.offload	= nft_cmp16_fast_offload,
+};
+
 static const struct nft_expr_ops *
 nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 {
 	struct nft_data_desc desc;
 	struct nft_data data;
 	enum nft_cmp_ops op;
+	u8 sreg;
 	int err;
 
 	if (tb[NFTA_CMP_SREG] == NULL ||
@@ -306,9 +397,16 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	if (desc.type != NFT_DATA_VALUE)
 		goto err1;
 
-	if (desc.len <= sizeof(u32) && (op == NFT_CMP_EQ || op == NFT_CMP_NEQ))
-		return &nft_cmp_fast_ops;
+	sreg = ntohl(nla_get_be32(tb[NFTA_CMP_SREG]));
 
+	if (op == NFT_CMP_EQ || op == NFT_CMP_NEQ) {
+		if (desc.len <= sizeof(u32))
+			return &nft_cmp_fast_ops;
+		else if (desc.len <= sizeof(data) &&
+			 ((sreg >= NFT_REG_1 && sreg <= NFT_REG_4) ||
+			  (sreg >= NFT_REG32_00 && sreg <= NFT_REG32_12 && sreg % 2 == 0)))
+			return &nft_cmp16_fast_ops;
+	}
 	return &nft_cmp_ops;
 err1:
 	nft_data_release(&data, desc.type);
-- 
2.30.2

