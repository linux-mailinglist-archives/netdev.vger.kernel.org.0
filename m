Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F92114197A
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgARUOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:50 -0500
Received: from correo.us.es ([193.147.175.20]:48442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgARUOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12DB82EFEB1
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 004C2DA705
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EA0BCDA707; Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4FA2DA705;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BB48241E4800;
        Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/21] netfilter: bitwise: add helper for initializing boolean operations.
Date:   Sat, 18 Jan 2020 21:14:12 +0100
Message-Id: <20200118201417.334111-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Split the code specific to initializing bitwise boolean operations out
into a separate function.  A similar function will be added later for
shift operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 66 ++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 6948df7b0587..d0cc5f753e52 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -45,20 +45,53 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
 };
 
+static int nft_bitwise_init_bool(struct nft_bitwise *priv,
+				 const struct nlattr *const tb[])
+{
+	struct nft_data_desc d1, d2;
+	int err;
+
+	if (!tb[NFTA_BITWISE_MASK] ||
+	    !tb[NFTA_BITWISE_XOR])
+		return -EINVAL;
+
+	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
+			    tb[NFTA_BITWISE_MASK]);
+	if (err < 0)
+		return err;
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
+		err = -EINVAL;
+		goto err1;
+	}
+
+	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
+			    tb[NFTA_BITWISE_XOR]);
+	if (err < 0)
+		goto err1;
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
+		err = -EINVAL;
+		goto err2;
+	}
+
+	return 0;
+err2:
+	nft_data_release(&priv->xor, d2.type);
+err1:
+	nft_data_release(&priv->mask, d1.type);
+	return err;
+}
+
 static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
 {
 	struct nft_bitwise *priv = nft_expr_priv(expr);
-	struct nft_data_desc d1, d2;
 	u32 len;
 	int err;
 
 	if (!tb[NFTA_BITWISE_SREG] ||
 	    !tb[NFTA_BITWISE_DREG] ||
-	    !tb[NFTA_BITWISE_LEN]  ||
-	    !tb[NFTA_BITWISE_MASK] ||
-	    !tb[NFTA_BITWISE_XOR])
+	    !tb[NFTA_BITWISE_LEN])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX, &len);
@@ -90,29 +123,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 		priv->op = NFT_BITWISE_BOOL;
 	}
 
-	err = nft_data_init(NULL, &priv->mask, sizeof(priv->mask), &d1,
-			    tb[NFTA_BITWISE_MASK]);
-	if (err < 0)
-		return err;
-	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
-		err = -EINVAL;
-		goto err1;
-	}
-
-	err = nft_data_init(NULL, &priv->xor, sizeof(priv->xor), &d2,
-			    tb[NFTA_BITWISE_XOR]);
-	if (err < 0)
-		goto err1;
-	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
-		err = -EINVAL;
-		goto err2;
+	switch(priv->op) {
+	case NFT_BITWISE_BOOL:
+		err = nft_bitwise_init_bool(priv, tb);
+		break;
 	}
 
-	return 0;
-err2:
-	nft_data_release(&priv->xor, d2.type);
-err1:
-	nft_data_release(&priv->mask, d1.type);
 	return err;
 }
 
-- 
2.11.0

