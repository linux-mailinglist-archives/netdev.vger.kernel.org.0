Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0448614196E
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgARUOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:44 -0500
Received: from correo.us.es ([193.147.175.20]:48480 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgARUOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 856142EFEB9
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76B73DA711
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C4AFDA70F; Sat, 18 Jan 2020 21:14:33 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BC5CDA701;
        Sat, 18 Jan 2020 21:14:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4624941E4800;
        Sat, 18 Jan 2020 21:14:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/21] netfilter: bitwise: add helper for evaluating boolean operations.
Date:   Sat, 18 Jan 2020 21:14:13 +0100
Message-Id: <20200118201417.334111-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Split the code specific to evaluating bitwise boolean operations out
into a separate function.  Similar functions will be added later for
shift operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d0cc5f753e52..88a91c63f213 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -24,16 +24,27 @@ struct nft_bitwise {
 	struct nft_data		xor;
 };
 
+static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
+				  const struct nft_bitwise *priv)
+{
+	unsigned int i;
+
+	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
+		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+}
+
 void nft_bitwise_eval(const struct nft_expr *expr,
 		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const u32 *src = &regs->data[priv->sreg];
 	u32 *dst = &regs->data[priv->dreg];
-	unsigned int i;
 
-	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++)
-		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
+	switch (priv->op) {
+	case NFT_BITWISE_BOOL:
+		nft_bitwise_eval_bool(dst, src, priv);
+		break;
+	}
 }
 
 static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
-- 
2.11.0

