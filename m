Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BC18C0C2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfHMShh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:37 -0400
Received: from correo.us.es ([193.147.175.20]:58782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbfHMShW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CE99B6325
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F564D190F
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 851E0A75E; Tue, 13 Aug 2019 20:37:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87CFCDA704;
        Tue, 13 Aug 2019 20:37:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 37B414265A2F;
        Tue, 13 Aug 2019 20:37:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/17] netfilter: nft_bitwise: add offload support
Date:   Tue, 13 Aug 2019 20:36:49 +0200
Message-Id: <20190813183701.4002-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract mask from bitwise operation and store it into the corresponding
context register so the cmp instruction can set the mask accordingly.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b310b637b550..1f04ed5c518c 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_bitwise {
 	enum nft_registers	sreg:8;
@@ -126,12 +127,30 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static struct nft_data zero;
+
+static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
+                               struct nft_flow_rule *flow,
+                               const struct nft_expr *expr)
+{
+	const struct nft_bitwise *priv = nft_expr_priv(expr);
+
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
+	    priv->sreg != priv->dreg))
+		return -EOPNOTSUPP;
+
+	memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
 	.eval		= nft_bitwise_eval,
 	.init		= nft_bitwise_init,
 	.dump		= nft_bitwise_dump,
+	.offload	= nft_bitwise_offload,
 };
 
 struct nft_expr_type nft_bitwise_type __read_mostly = {
-- 
2.11.0


