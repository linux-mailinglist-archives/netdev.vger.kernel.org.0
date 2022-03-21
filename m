Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425E34E266F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347432AbiCUMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347399AbiCUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF78185673;
        Mon, 21 Mar 2022 05:31:04 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B65F963041;
        Mon, 21 Mar 2022 13:28:22 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 14/19] netfilter: nft_tunnel: track register operations
Date:   Mon, 21 Mar 2022 13:30:47 +0100
Message-Id: <20220321123052.70553-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321123052.70553-1-pablo@netfilter.org>
References: <20220321123052.70553-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if the destination register already contains the data that this
tunnel expression performs. This allows to skip this redundant operation.
If the destination contains a different selector, update the register
tracking information. This patch does not perform bitwise tracking.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3b27926d5382..d0f9b1d51b0e 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -17,6 +17,7 @@ struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
 	u8			dreg;
 	enum nft_tunnel_mode	mode:8;
+	u8			len;
 };
 
 static void nft_tunnel_get_eval(const struct nft_expr *expr,
@@ -101,6 +102,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 		priv->mode = NFT_TUNNEL_MODE_NONE;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_TUNNEL_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -122,6 +124,31 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static bool nft_tunnel_get_reduce(struct nft_regs_track *track,
+				  const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+	const struct nft_tunnel *tunnel;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	tunnel = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != tunnel->key ||
+	    priv->dreg != tunnel->dreg ||
+	    priv->mode != tunnel->mode) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static struct nft_expr_type nft_tunnel_type;
 static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.type		= &nft_tunnel_type,
@@ -129,6 +156,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.reduce		= nft_tunnel_get_reduce,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
-- 
2.30.2

