Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3378F4AF2E6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiBINgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiBINgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0576C0612BE;
        Wed,  9 Feb 2022 05:36:28 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C12B601C9;
        Wed,  9 Feb 2022 14:36:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/14] netfilter: exthdr: add support for tcp option removal
Date:   Wed,  9 Feb 2022 14:36:10 +0100
Message-Id: <20220209133616.165104-9-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

This allows to replace a tcp option with nop padding to selectively disable
a particular tcp option.

Optstrip mode is chosen when userspace passes the exthdr expression with
neither a source nor a destination register attribute.

This is identical to xtables TCPOPTSTRIP extension.
The only difference is that TCPOPTSTRIP allows to pass in a bitmap
of options to remove rather than a single number.

Unlike TCPOPTSTRIP this expression can be used multiple times
in the same rule to get the same effect.

We could add a new nested attribute later on in case there is a
use case for single-expression-multi-remove.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 96 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dbe1f2e7dd9e..dfc06cdb8fa2 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -308,6 +308,63 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
+				      struct nft_regs *regs,
+				      const struct nft_pktinfo *pkt)
+{
+	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	unsigned int i, tcphdr_len, optl;
+	struct tcphdr *tcph;
+	u8 *opt;
+
+	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (!tcph)
+		goto err;
+
+	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
+		goto drop;
+
+	opt = (u8 *)nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (!opt)
+		goto err;
+	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
+		unsigned int j;
+
+		optl = optlen(opt, i);
+		if (priv->type != opt[i])
+			continue;
+
+		if (i + optl > tcphdr_len)
+			goto drop;
+
+		for (j = 0; j < optl; ++j) {
+			u16 n = TCPOPT_NOP;
+			u16 o = opt[i+j];
+
+			if ((i + j) % 2 == 0) {
+				o <<= 8;
+				n <<= 8;
+			}
+			inet_proto_csum_replace2(&tcph->check, pkt->skb, htons(o),
+						 htons(n), false);
+		}
+		memset(opt + i, TCPOPT_NOP, optl);
+		return;
+	}
+
+	/* option not found, continue. This allows to do multiple
+	 * option removals per rule.
+	 */
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
+	return;
+drop:
+	/* can't remove, no choice but to drop */
+	regs->verdict.code = NF_DROP;
+}
+
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -457,6 +514,28 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 				       priv->len);
 }
 
+static int nft_exthdr_tcp_strip_init(const struct nft_ctx *ctx,
+				     const struct nft_expr *expr,
+				     const struct nlattr * const tb[])
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	if (tb[NFTA_EXTHDR_SREG] ||
+	    tb[NFTA_EXTHDR_DREG] ||
+	    tb[NFTA_EXTHDR_FLAGS] ||
+	    tb[NFTA_EXTHDR_OFFSET] ||
+	    tb[NFTA_EXTHDR_LEN])
+		return -EINVAL;
+
+	if (!tb[NFTA_EXTHDR_TYPE])
+		return -EINVAL;
+
+	priv->type = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
+	priv->op = NFT_EXTHDR_OP_TCPOPT;
+
+	return 0;
+}
+
 static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
 				const struct nft_expr *expr,
 				const struct nlattr * const tb[])
@@ -517,6 +596,13 @@ static int nft_exthdr_dump_set(struct sk_buff *skb, const struct nft_expr *expr)
 	return nft_exthdr_dump_common(skb, priv);
 }
 
+static int nft_exthdr_dump_strip(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+
+	return nft_exthdr_dump_common(skb, priv);
+}
+
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
@@ -549,6 +635,14 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.dump		= nft_exthdr_dump_set,
 };
 
+static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_tcp_strip_eval,
+	.init		= nft_exthdr_tcp_strip_init,
+	.dump		= nft_exthdr_dump_strip,
+};
+
 static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
@@ -576,7 +670,7 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 			return &nft_exthdr_tcp_set_ops;
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_tcp_ops;
-		break;
+		return &nft_exthdr_tcp_strip_ops;
 	case NFT_EXTHDR_OP_IPV6:
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_ipv6_ops;
-- 
2.30.2

