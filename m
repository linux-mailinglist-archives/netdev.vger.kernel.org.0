Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B4160E215
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiJZNXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiJZNW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 156225D88E;
        Wed, 26 Oct 2022 06:22:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 07/10] netfilter: nft_inner: add percpu inner context
Date:   Wed, 26 Oct 2022 15:22:24 +0200
Message-Id: <20221026132227.3287-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026132227.3287-1-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NFT_PKTINFO_INNER_FULL flag to annotate that inner offsets are
available. Store nft_inner_tun_ctx object in percpu area to cache
existing inner offsets for this skbuff.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  1 +
 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/nft_inner.c              | 26 ++++++++++++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2dbfe7524a7e..38e2b396e38a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -24,6 +24,7 @@ struct module;
 enum {
 	NFT_PKTINFO_L4PROTO	= (1 << 0),
 	NFT_PKTINFO_INNER	= (1 << 1),
+	NFT_PKTINFO_INNER_FULL	= (1 << 2),
 };
 
 struct nft_pktinfo {
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index be2b2b5d0a52..3e825381ac5c 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -149,6 +149,7 @@ enum {
 };
 
 struct nft_inner_tun_ctx {
+	u16	type;
 	u16	inner_tunoff;
 	u16	inner_lloff;
 	u16	inner_nhoff;
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 1e4079b5b431..29f2eefe0357 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -21,6 +21,8 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
+static DEFINE_PER_CPU(struct nft_inner_tun_ctx, nft_pcpu_tun_ctx);
+
 /* Same layout as nft_expr but it embeds the private expression data area. */
 struct __nft_expr {
 	const struct nft_expr_ops	*ops;
@@ -180,7 +182,7 @@ static int nft_inner_parse_tunhdr(const struct nft_inner *priv,
 }
 
 static int nft_inner_parse(const struct nft_inner *priv,
-			   const struct nft_pktinfo *pkt,
+			   struct nft_pktinfo *pkt,
 			   struct nft_inner_tun_ctx *tun_ctx)
 {
 	struct nft_inner_tun_ctx ctx = {};
@@ -199,25 +201,41 @@ static int nft_inner_parse(const struct nft_inner *priv,
 	}
 
 	*tun_ctx = ctx;
+	tun_ctx->type = priv->type;
+	pkt->flags |= NFT_PKTINFO_INNER_FULL;
 
 	return 0;
 }
 
+static bool nft_inner_parse_needed(const struct nft_inner *priv,
+				   const struct nft_pktinfo *pkt,
+				   const struct nft_inner_tun_ctx *tun_ctx)
+{
+	if (!(pkt->flags & NFT_PKTINFO_INNER_FULL))
+		return true;
+
+	if (priv->type != tun_ctx->type)
+		return true;
+
+	return false;
+}
+
 static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			   const struct nft_pktinfo *pkt)
 {
+	struct nft_inner_tun_ctx *tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx);
 	const struct nft_inner *priv = nft_expr_priv(expr);
-	struct nft_inner_tun_ctx tun_ctx = {};
 
 	if (nft_payload_inner_offset(pkt) < 0)
 		goto err;
 
-	if (nft_inner_parse(priv, pkt, &tun_ctx) < 0)
+	if (nft_inner_parse_needed(priv, pkt, tun_ctx) &&
+	    nft_inner_parse(priv, (struct nft_pktinfo *)pkt, tun_ctx) < 0)
 		goto err;
 
 	switch (priv->expr_type) {
 	case NFT_INNER_EXPR_PAYLOAD:
-		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
+		nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, tun_ctx);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.30.2

