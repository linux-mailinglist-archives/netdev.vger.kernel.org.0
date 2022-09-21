Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2745BFF3A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiIUNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUNvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF08180F79
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B5336300B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA7C433D7;
        Wed, 21 Sep 2022 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768284;
        bh=i34wNiAqiKx9CJHvry7XJe1uKpLFAl7hMFJ8yWF7Of0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGbrEnZKMbP27yI/pOs/j3GGlFeThR/b2QZUMPwYdvmtAXw+cikspZ3Da+LKXjtCd
         bXt82ypsFCIeGNq39NMU/IBLcG7pQwWUerh6OROZPq0n6AWMWmZMRcx0qxXa4ZDnSb
         VQFJIdjC1MUazsier/anqkUtoVLR/9/QfzjRm8wYMM1eXRhBqMVW60kTbWqYExUeOk
         mjwR0I1YUC3/EzinpxRbWUvEgJUMdn7E8et3/wx+OWIGxTcq58N3ErX3vKhTcPGRsF
         tblyc/00StDljld1pSeueN1GB+yipcL8pW2JZVJIobOYM4hlt/oZ/ipqiP2femKf/c
         cJeUEugoFdd5Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 1/7] net: phy: mscc: macsec: make the prepare phase a noop
Date:   Wed, 21 Sep 2022 15:51:12 +0200
Message-Id: <20220921135118.968595-2-atenart@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921135118.968595-1-atenart@kernel.org>
References: <20220921135118.968595-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for removing the MACsec h/w offloading preparation phase,
make it a no-op in the MSCC phy driver.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 104 +++++++++++++++--------------
 1 file changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index b7b2521c73fb..58210be879ff 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -706,14 +706,6 @@ static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
 	struct phy_device *phydev = ctx->phydev;
 	struct vsc8531_private *priv = phydev->priv;
 
-	if (!flow) {
-		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
-		if (IS_ERR(flow))
-			return PTR_ERR(flow);
-
-		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-	}
-
 	flow->assoc_num = ctx->sa.assoc_num;
 	flow->rx_sa = ctx->sa.rx_sa;
 
@@ -730,24 +722,13 @@ static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
 static int __vsc8584_macsec_add_txsa(struct macsec_context *ctx,
 				     struct macsec_flow *flow, bool update)
 {
-	struct phy_device *phydev = ctx->phydev;
-	struct vsc8531_private *priv = phydev->priv;
-
-	if (!flow) {
-		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
-		if (IS_ERR(flow))
-			return PTR_ERR(flow);
-
-		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-	}
-
 	flow->assoc_num = ctx->sa.assoc_num;
 	flow->tx_sa = ctx->sa.tx_sa;
 
 	/* Always match untagged packets on egress */
 	flow->match.untagged = 1;
 
-	return vsc8584_macsec_add_flow(phydev, flow, update);
+	return vsc8584_macsec_add_flow(ctx->phydev, flow, update);
 }
 
 static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
@@ -785,12 +766,11 @@ static int vsc8584_macsec_add_secy(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_secy *secy = ctx->secy;
 
-	if (ctx->prepare) {
-		if (priv->secy)
-			return -EEXIST;
-
+	if (ctx->prepare)
 		return 0;
-	}
+
+	if (priv->secy)
+		return -EEXIST;
 
 	priv->secy = secy;
 
@@ -862,33 +842,46 @@ static int vsc8584_macsec_del_rxsc(struct macsec_context *ctx)
 
 static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
 {
-	struct macsec_flow *flow = NULL;
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+	struct macsec_flow *flow;
+	int ret;
 
 	if (ctx->prepare)
-		return __vsc8584_macsec_add_rxsa(ctx, flow, false);
+		return 0;
 
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+
+	ret = __vsc8584_macsec_add_rxsa(ctx, flow, false);
+	if (ret)
+		return ret;
+
+	vsc8584_macsec_flow_enable(phydev, flow);
 	return 0;
 }
 
 static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
+	int ret;
+
+	if (ctx->prepare)
+		return 0;
 
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	if (ctx->prepare) {
-		/* Make sure the flow is disabled before updating it */
-		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+	/* Make sure the flow is disabled before updating it */
+	vsc8584_macsec_flow_disable(ctx->phydev, flow);
 
-		return __vsc8584_macsec_add_rxsa(ctx, flow, true);
-	}
+	ret = __vsc8584_macsec_add_rxsa(ctx, flow, true);
+	if (ret)
+		return ret;
 
 	vsc8584_macsec_flow_enable(ctx->phydev, flow);
 	return 0;
@@ -898,12 +891,12 @@ static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	if (ctx->prepare)
+		return 0;
 
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
-	if (ctx->prepare)
-		return 0;
 
 	vsc8584_macsec_del_flow(ctx->phydev, flow);
 	return 0;
@@ -911,33 +904,46 @@ static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
 
 static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
 {
-	struct macsec_flow *flow = NULL;
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+	struct macsec_flow *flow;
+	int ret;
 
 	if (ctx->prepare)
-		return __vsc8584_macsec_add_txsa(ctx, flow, false);
+		return 0;
 
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+
+	ret = __vsc8584_macsec_add_txsa(ctx, flow, false);
+	if (ret)
+		return ret;
+
+	vsc8584_macsec_flow_enable(phydev, flow);
 	return 0;
 }
 
 static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
+	int ret;
+
+	if (ctx->prepare)
+		return 0;
 
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	if (ctx->prepare) {
-		/* Make sure the flow is disabled before updating it */
-		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+	/* Make sure the flow is disabled before updating it */
+	vsc8584_macsec_flow_disable(ctx->phydev, flow);
 
-		return __vsc8584_macsec_add_txsa(ctx, flow, true);
-	}
+	ret = __vsc8584_macsec_add_txsa(ctx, flow, true);
+	if (ret)
+		return ret;
 
 	vsc8584_macsec_flow_enable(ctx->phydev, flow);
 	return 0;
@@ -947,12 +953,12 @@ static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	if (ctx->prepare)
+		return 0;
 
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
-	if (ctx->prepare)
-		return 0;
 
 	vsc8584_macsec_del_flow(ctx->phydev, flow);
 	return 0;
-- 
2.37.3

