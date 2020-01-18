Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F13141966
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgARUOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:38 -0500
Received: from correo.us.es ([193.147.175.20]:48442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbgARUOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB9F12EFEB0
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8923DA713
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE606DA711; Sat, 18 Jan 2020 21:14:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B29ADDA701;
        Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8D04041E4800;
        Sat, 18 Jan 2020 21:14:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 21/21] netfilter: bitwise: add support for shifts.
Date:   Sat, 18 Jan 2020 21:14:17 +0100
Message-Id: <20200118201417.334111-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Hitherto nft_bitwise has only supported boolean operations: NOT, AND, OR
and XOR.  Extend it to do shifts as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  9 +++-
 net/netfilter/nft_bitwise.c              | 77 ++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8bef0620bc4f..261864736b26 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -489,9 +489,13 @@ enum nft_immediate_attributes {
  *
  * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
  *                    XOR boolean operations
+ * @NFT_BITWISE_LSHIFT: left-shift operation
+ * @NFT_BITWISE_RSHIFT: right-shift operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_BOOL,
+	NFT_BITWISE_LSHIFT,
+	NFT_BITWISE_RSHIFT,
 };
 
 /**
@@ -506,11 +510,12 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
  *
- * The bitwise expression performs the following operation:
+ * The bitwise expression supports boolean and shift operations.  It implements
+ * the boolean operations by performing the following operation:
  *
  * dreg = (sreg & mask) ^ xor
  *
- * which allow to express all bitwise operations:
+ * with these mask and xor values:
  *
  * 		mask	xor
  * NOT:		1	1
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 744008a527fb..0ed2281f03be 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -34,6 +34,32 @@ static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
 		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 }
 
+static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	u32 shift = priv->data.data[0];
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
+		dst[i - 1] = (src[i - 1] << shift) | carry;
+		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
+	}
+}
+
+static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
+				    const struct nft_bitwise *priv)
+{
+	u32 shift = priv->data.data[0];
+	unsigned int i;
+	u32 carry = 0;
+
+	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+		dst[i] = carry | (src[i] >> shift);
+		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
+	}
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
@@ -45,6 +71,12 @@ void nft_bitwise_eval(const struct nft_expr *expr,
 	case NFT_BITWISE_BOOL:
 		nft_bitwise_eval_bool(dst, src, priv);
 		break;
+	case NFT_BITWISE_LSHIFT:
+		nft_bitwise_eval_lshift(dst, src, priv);
+		break;
+	case NFT_BITWISE_RSHIFT:
+		nft_bitwise_eval_rshift(dst, src, priv);
+		break;
 	}
 }
 
@@ -97,6 +129,32 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	return err;
 }
 
+static int nft_bitwise_init_shift(struct nft_bitwise *priv,
+				  const struct nlattr *const tb[])
+{
+	struct nft_data_desc d;
+	int err;
+
+	if (tb[NFTA_BITWISE_MASK] ||
+	    tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	if (!tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
+	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &d,
+			    tb[NFTA_BITWISE_DATA]);
+	if (err < 0)
+		return err;
+	if (d.type != NFT_DATA_VALUE || d.len != sizeof(u32) ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+		nft_data_release(&priv->data, d.type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -131,6 +189,8 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
 		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_LSHIFT:
+		case NFT_BITWISE_RSHIFT:
 			break;
 		default:
 			return -EOPNOTSUPP;
@@ -143,6 +203,10 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	case NFT_BITWISE_BOOL:
 		err = nft_bitwise_init_bool(priv, tb);
 		break;
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		err = nft_bitwise_init_shift(priv, tb);
+		break;
 	}
 
 	return err;
@@ -162,6 +226,15 @@ static int nft_bitwise_dump_bool(struct sk_buff *skb,
 	return 0;
 }
 
+static int nft_bitwise_dump_shift(struct sk_buff *skb,
+				  const struct nft_bitwise *priv)
+{
+	if (nft_data_dump(skb, NFTA_BITWISE_DATA, &priv->data,
+			  NFT_DATA_VALUE, sizeof(u32)) < 0)
+		return -1;
+	return 0;
+}
+
 static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
@@ -180,6 +253,10 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	case NFT_BITWISE_BOOL:
 		err = nft_bitwise_dump_bool(skb, priv);
 		break;
+	case NFT_BITWISE_LSHIFT:
+	case NFT_BITWISE_RSHIFT:
+		err = nft_bitwise_dump_shift(skb, priv);
+		break;
 	}
 
 	return err;
-- 
2.11.0

