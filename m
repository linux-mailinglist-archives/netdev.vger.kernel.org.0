Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E36EB558
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjDUXCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbjDUXCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CEA1E6E;
        Fri, 21 Apr 2023 16:02:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 01/20] netfilter: nft_exthdr: add boolean DCCP option matching
Date:   Sat, 22 Apr 2023 01:01:52 +0200
Message-Id: <20230421230211.214635-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The xt_dccp iptables module supports the matching of DCCP packets based
on the presence or absence of DCCP options.  Extend nft_exthdr to add
this functionality to nftables.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c4d4d8e42dc8..e059dc2644df 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -859,12 +859,14 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
+ * @NFT_EXTHDR_OP_DCCP: match against dccp otions
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
 	NFT_EXTHDR_OP_SCTP,
+	NFT_EXTHDR_OP_DCCP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a54a7f772cec..09b99a48e5c3 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -10,6 +10,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/dccp.h>
 #include <linux/sctp.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
@@ -406,6 +407,81 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	unsigned int thoff, dataoff, optoff, optlen, i;
+	u32 *dest = &regs->data[priv->dreg];
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
+
+	if (pkt->tprot != IPPROTO_DCCP || pkt->fragoff)
+		goto err;
+
+	thoff = nft_thoff(pkt);
+
+	dh = skb_header_pointer(pkt->skb, thoff, sizeof(_dh), &_dh);
+	if (!dh)
+		goto err;
+
+	dataoff = dh->dccph_doff * sizeof(u32);
+	optoff = __dccp_hdr_len(dh);
+	if (dataoff <= optoff)
+		goto err;
+
+	optlen = dataoff - optoff;
+
+	for (i = 0; i < optlen; ) {
+		/* Options 0 (DCCPO_PADDING) - 31 (DCCPO_MAX_RESERVED) are 1B in
+		 * the length; the remaining options are at least 2B long.  In
+		 * all cases, the first byte contains the option type.  In
+		 * multi-byte options, the second byte contains the option
+		 * length, which must be at least two: 1 for the type plus 1 for
+		 * the length plus 0-253 for any following option data.  We
+		 * aren't interested in the option data, only the type and the
+		 * length, so we don't need to read more than two bytes at a
+		 * time.
+		 */
+		unsigned int buflen;
+		u8 buf[2], *bufp;
+		u8 type, len;
+
+		buflen = optlen - i < sizeof(buf) ? optlen - i : sizeof(buf);
+
+		bufp = skb_header_pointer(pkt->skb, thoff + optoff + i, buflen,
+					  &buf);
+		if (!bufp)
+			goto err;
+
+		type = bufp[0];
+
+		if (type == priv->type) {
+			*dest = 1;
+			return;
+		}
+
+		if (type <= DCCPO_MAX_RESERVED) {
+			i++;
+			continue;
+		}
+
+		if (buflen < 2)
+			goto err;
+
+		len = bufp[1];
+
+		if (len < 2)
+			goto err;
+
+		i += len;
+	}
+
+err:
+	*dest = 0;
+}
+
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_DREG]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
@@ -557,6 +633,22 @@ static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_exthdr_dccp_init(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const struct nlattr * const tb[])
+{
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	int err = nft_exthdr_init(ctx, expr, tb);
+
+	if (err < 0)
+		return err;
+
+	if (!(priv->flags & NFT_EXTHDR_F_PRESENT))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 static int nft_exthdr_dump_common(struct sk_buff *skb, const struct nft_exthdr *priv)
 {
 	if (nla_put_u8(skb, NFTA_EXTHDR_TYPE, priv->type))
@@ -686,6 +778,15 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.reduce		= nft_exthdr_reduce,
 };
 
+static const struct nft_expr_ops nft_exthdr_dccp_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_dccp_eval,
+	.init		= nft_exthdr_dccp_init,
+	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
+};
+
 static const struct nft_expr_ops *
 nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
@@ -720,6 +821,10 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		if (tb[NFTA_EXTHDR_DREG])
 			return &nft_exthdr_sctp_ops;
 		break;
+	case NFT_EXTHDR_OP_DCCP:
+		if (tb[NFTA_EXTHDR_DREG])
+			return &nft_exthdr_dccp_ops;
+		break;
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.30.2

