Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48EFE6B11FA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCHTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCHTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:30:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6041B2DD;
        Wed,  8 Mar 2023 11:30:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzUn-0003p8-EX; Wed, 08 Mar 2023 20:30:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH net-next 1/9] netfilter: bridge: introduce broute meta statement
Date:   Wed,  8 Mar 2023 20:30:25 +0100
Message-Id: <20230308193033.13965-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193033.13965-1-fw@strlen.de>
References: <20230308193033.13965-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

nftables equivalent for ebtables -t broute.

Implement broute meta statement to set br_netfilter_broute flag
in skb to force a packet to be routed instead of being bridged.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/bridge/netfilter/nft_meta_bridge.c   | 71 +++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ff677f3a6cad..9c6f02c26054 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -931,6 +931,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -969,6 +970,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
 };
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index c3ecd77e25cb..bd4d1b4d745f 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -8,6 +8,9 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nft_meta.h>
 #include <linux/if_bridge.h>
+#include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
+
+#include "../br_private.h"
 
 static const struct net_device *
 nft_meta_get_bridge(const struct net_device *dev)
@@ -102,6 +105,50 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.reduce		= nft_meta_get_reduce,
 };
 
+static void nft_meta_bridge_set_eval(const struct nft_expr *expr,
+				     struct nft_regs *regs,
+				     const struct nft_pktinfo *pkt)
+{
+	const struct nft_meta *meta = nft_expr_priv(expr);
+	u32 *sreg = &regs->data[meta->sreg];
+	struct sk_buff *skb = pkt->skb;
+	u8 value8;
+
+	switch (meta->key) {
+	case NFT_META_BRI_BROUTE:
+		value8 = nft_reg_load8(sreg);
+		BR_INPUT_SKB_CB(skb)->br_netfilter_broute = !!value8;
+		break;
+	default:
+		nft_meta_set_eval(expr, regs, pkt);
+	}
+}
+
+static int nft_meta_bridge_set_init(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int len;
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
+	switch (priv->key) {
+	case NFT_META_BRI_BROUTE:
+		len = sizeof(u8);
+		break;
+	default:
+		return nft_meta_set_init(ctx, expr, tb);
+	}
+
+	priv->len = len;
+	err = nft_parse_register_load(tb[NFTA_META_SREG], &priv->sreg, len);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
 static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 				       const struct nft_expr *expr)
 {
@@ -120,15 +167,33 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 	return false;
 }
 
+static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr,
+					const struct nft_data **data)
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->key) {
+	case NFT_META_BRI_BROUTE:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	default:
+		return nft_meta_set_validate(ctx, expr, data);
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
-	.eval		= nft_meta_set_eval,
-	.init		= nft_meta_set_init,
+	.eval		= nft_meta_bridge_set_eval,
+	.init		= nft_meta_bridge_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
 	.reduce		= nft_meta_bridge_set_reduce,
-	.validate	= nft_meta_set_validate,
+	.validate	= nft_meta_bridge_set_validate,
 };
 
 static const struct nft_expr_ops *
-- 
2.39.2

