Return-Path: <netdev+bounces-3553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69A8707D94
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936F42818B9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5267F11CB5;
	Thu, 18 May 2023 10:08:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482B7125AA
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:17 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7D51716;
	Thu, 18 May 2023 03:08:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYL-0005nn-NF; Thu, 18 May 2023 12:08:09 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH net-next 3/9] netfilter: nft_exthdr: add boolean DCCP option matching
Date: Thu, 18 May 2023 12:07:53 +0200
Message-Id: <20230518100759.84858-4-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jeremy Sowden <jeremy@azazel.net>

The xt_dccp iptables module supports the matching of DCCP packets based
on the presence or absence of DCCP options.  Extend nft_exthdr to add
this functionality to nftables.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=930
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nft_exthdr.c               | 106 +++++++++++++++++++++++
 2 files changed, 108 insertions(+)

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
index a54a7f772cec..671474e59817 100644
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
@@ -406,6 +407,82 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
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
+		unsigned int buflen = optlen - i;
+		u8 buf[2], *bufp;
+		u8 type, len;
+
+		if (buflen > sizeof(buf))
+			buflen = sizeof(buf);
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
@@ -557,6 +634,22 @@ static int nft_exthdr_ipv4_init(const struct nft_ctx *ctx,
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
@@ -686,6 +779,15 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
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
@@ -720,6 +822,10 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
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
2.40.1


