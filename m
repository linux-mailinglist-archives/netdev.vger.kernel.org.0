Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904A48C0B2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfHMShX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:23 -0400
Received: from correo.us.es ([193.147.175.20]:58788 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbfHMShX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 887FADA738
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 795BE519E5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6ED4FADE9; Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 673F1519E5;
        Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1A54F4265A2F;
        Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/17] netfilter: nf_tables: store data in offload context registers
Date:   Tue, 13 Aug 2019 20:36:50 +0200
Message-Id: <20190813183701.4002-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store immediate data into offload context register. This allows follow
up instructions to take it from the corresponding source register.

This patch is required to support for payload mangling, although other
instructions that take data from source register will benefit from this
too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  1 +
 net/netfilter/nft_immediate.c             | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 3196663a10e3..4977fbe7ed08 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -9,6 +9,7 @@ struct nft_offload_reg {
 	u32		len;
 	u32		base_offset;
 	u32		offset;
+	struct nft_data data;
 	struct nft_data	mask;
 };
 
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index ca2ae4b95a8d..c7f0ef73d939 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -125,17 +125,13 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static int nft_immediate_offload(struct nft_offload_ctx *ctx,
-				 struct nft_flow_rule *flow,
-				 const struct nft_expr *expr)
+static int nft_immediate_offload_verdict(struct nft_offload_ctx *ctx,
+					 struct nft_flow_rule *flow,
+					 const struct nft_immediate_expr *priv)
 {
-	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	struct flow_action_entry *entry;
 	const struct nft_data *data;
 
-	if (priv->dreg != NFT_REG_VERDICT)
-		return -EOPNOTSUPP;
-
 	entry = &flow->rule->action.entries[ctx->num_actions++];
 
 	data = &priv->data;
@@ -153,6 +149,20 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	return 0;
 }
 
+static int nft_immediate_offload(struct nft_offload_ctx *ctx,
+				 struct nft_flow_rule *flow,
+				 const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return nft_immediate_offload_verdict(ctx, flow, priv);
+
+	memcpy(&ctx->regs[priv->dreg].data, &priv->data, sizeof(priv->data));
+
+	return 0;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
-- 
2.11.0


