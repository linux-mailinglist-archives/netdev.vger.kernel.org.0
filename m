Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A9B14197B
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgARUOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:51 -0500
Received: from correo.us.es ([193.147.175.20]:48426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgARUOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89CE82EFEAE
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78E64DA70E
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E4ABDA702; Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60285DA712;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3A1CA41E4800;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/21] netfilter: bitwise: add NFTA_BITWISE_OP netlink attribute.
Date:   Sat, 18 Jan 2020 21:14:11 +0100
Message-Id: <20200118201417.334111-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Add a new bitwise netlink attribute, NFTA_BITWISE_OP, which is set to a
value of a new enum, nft_bitwise_ops.  It describes the type of
operation an expression contains.  Currently, it only has one value:
NFT_BITWISE_BOOL.  More values will be added later to implement shifts.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nft_bitwise.c              | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index dd4611767933..0cddf357281f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -485,6 +485,16 @@ enum nft_immediate_attributes {
 #define NFTA_IMMEDIATE_MAX	(__NFTA_IMMEDIATE_MAX - 1)
 
 /**
+ * enum nft_bitwise_ops - nf_tables bitwise operations
+ *
+ * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
+ *                    XOR boolean operations
+ */
+enum nft_bitwise_ops {
+	NFT_BITWISE_BOOL,
+};
+
+/**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
  *
  * @NFTA_BITWISE_SREG: source register (NLA_U32: nft_registers)
@@ -492,6 +502,7 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  *
  * The bitwise expression performs the following operation:
  *
@@ -512,6 +523,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_OP,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index c15e9beb5243..6948df7b0587 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -18,6 +18,7 @@
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
 	enum nft_registers	dreg:8;
+	enum nft_bitwise_ops	op:8;
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
@@ -41,6 +42,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_LEN]	= { .type = NLA_U32 },
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
+	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 };
 
 static int nft_bitwise_init(const struct nft_ctx *ctx,
@@ -76,6 +78,18 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_BITWISE_OP]) {
+		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
+		switch (priv->op) {
+		case NFT_BITWISE_BOOL:
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	} else {
+		priv->op = NFT_BITWISE_BOOL;
+	}
+
 	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
@@ -112,6 +126,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(priv->len)))
 		return -1;
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(priv->op)))
+		return -1;
 
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
-- 
2.11.0

