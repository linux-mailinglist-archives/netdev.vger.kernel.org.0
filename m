Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ABC1BE7B8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgD2Ts0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:48:26 -0400
Received: from correo.us.es ([193.147.175.20]:50160 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbgD2TsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 15:48:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C12BE1710
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80471BAAB5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 75D43BAAA3; Wed, 29 Apr 2020 21:42:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85421BAAB5;
        Wed, 29 Apr 2020 21:42:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:42:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6195842EF9E0;
        Wed, 29 Apr 2020 21:42:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/6] netfilter: nft_nat: add helper function to set up NAT address and protocol
Date:   Wed, 29 Apr 2020 21:42:42 +0200
Message-Id: <20200429194243.22228-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429194243.22228-1-pablo@netfilter.org>
References: <20200429194243.22228-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add nft_nat_setup_addr() and nft_nat_setup_proto() to set up
the NAT mangling.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 56 +++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 5c7ff213c030..7442aa8b1555 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -30,6 +30,36 @@ struct nft_nat {
 	u16			flags;
 };
 
+static void nft_nat_setup_addr(struct nf_nat_range2 *range,
+			       const struct nft_regs *regs,
+			       const struct nft_nat *priv)
+{
+	switch (priv->family) {
+	case AF_INET:
+		range->min_addr.ip = (__force __be32)
+				regs->data[priv->sreg_addr_min];
+		range->max_addr.ip = (__force __be32)
+				regs->data[priv->sreg_addr_max];
+		break;
+	case AF_INET6:
+		memcpy(range->min_addr.ip6, &regs->data[priv->sreg_addr_min],
+		       sizeof(range->min_addr.ip6));
+		memcpy(range->max_addr.ip6, &regs->data[priv->sreg_addr_max],
+		       sizeof(range->max_addr.ip6));
+		break;
+	}
+}
+
+static void nft_nat_setup_proto(struct nf_nat_range2 *range,
+				const struct nft_regs *regs,
+				const struct nft_nat *priv)
+{
+	range->min_proto.all = (__force __be16)
+		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
+	range->max_proto.all = (__force __be16)
+		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
+}
+
 static void nft_nat_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt)
@@ -40,29 +70,11 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
-	if (priv->sreg_addr_min) {
-		if (priv->family == AF_INET) {
-			range.min_addr.ip = (__force __be32)
-					regs->data[priv->sreg_addr_min];
-			range.max_addr.ip = (__force __be32)
-					regs->data[priv->sreg_addr_max];
-
-		} else {
-			memcpy(range.min_addr.ip6,
-			       &regs->data[priv->sreg_addr_min],
-			       sizeof(range.min_addr.ip6));
-			memcpy(range.max_addr.ip6,
-			       &regs->data[priv->sreg_addr_max],
-			       sizeof(range.max_addr.ip6));
-		}
-	}
+	if (priv->sreg_addr_min)
+		nft_nat_setup_addr(&range, regs, priv);
 
-	if (priv->sreg_proto_min) {
-		range.min_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_min]);
-		range.max_proto.all = (__force __be16)nft_reg_load16(
-			&regs->data[priv->sreg_proto_max]);
-	}
+	if (priv->sreg_proto_min)
+		nft_nat_setup_proto(&range, regs, priv);
 
 	range.flags = priv->flags;
 
-- 
2.20.1

