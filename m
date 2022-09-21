Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50085BFF3E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiIUNwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiIUNvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C777086706
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C7A163067
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769F0C433D6;
        Wed, 21 Sep 2022 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768293;
        bh=zCWK3c++tbcg7hHF2XecW35g+kHwMuCQhUQna+wQP6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlYJOtJvWBUyFk6ratQWTaLNQGgeH9LPahwe/aWS7sR/xRQ9TESvV+7pQZ08D54UC
         0MjrGN53olC1pZm48Srs+f3zyAYGI7felyxnsILXqQxV0tA34PCExHh1VX6cjGUSWk
         kiJEkp95ddqWWyPg5veXpNYn90GGAOL6bgFsoNwPCKQK4gnup+A9hCrFpllUbsFmFf
         yECl7Io0i2Zly0o7ghMau+MvEm7iH60yr4K/PIvQG5gxNGhR8o7ccsYvSqw0wgQTHJ
         WpV5kj7OpvbRdsmJ/U/6EAUYcUSf6NM0u9Zncdsa9XZ3JJENwdq3lNV32CLaMalBCq
         32EqyprFkmc1Q==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] net: phy: mscc: macsec: remove checks on the prepare phase
Date:   Wed, 21 Sep 2022 15:51:15 +0200
Message-Id: <20220921135118.968595-5-atenart@kernel.org>
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

Remove checks on the prepare phase as it is now unused by the MACsec
core implementation.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 41 ------------------------------
 1 file changed, 41 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 58210be879ff..ee5b17edca39 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -736,10 +736,6 @@ static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_flow *flow, *tmp;
 
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
 	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
 		vsc8584_macsec_flow_enable(ctx->phydev, flow);
 
@@ -751,10 +747,6 @@ static int vsc8584_macsec_dev_stop(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_flow *flow, *tmp;
 
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
 	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
 		vsc8584_macsec_flow_disable(ctx->phydev, flow);
 
@@ -766,9 +758,6 @@ static int vsc8584_macsec_add_secy(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_secy *secy = ctx->secy;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (priv->secy)
 		return -EEXIST;
 
@@ -787,10 +776,6 @@ static int vsc8584_macsec_del_secy(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_flow *flow, *tmp;
 
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
 	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
 		vsc8584_macsec_del_flow(ctx->phydev, flow);
 
@@ -803,10 +788,6 @@ static int vsc8584_macsec_del_secy(struct macsec_context *ctx)
 
 static int vsc8584_macsec_upd_secy(struct macsec_context *ctx)
 {
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
 	vsc8584_macsec_del_secy(ctx);
 	return vsc8584_macsec_add_secy(ctx);
 }
@@ -827,10 +808,6 @@ static int vsc8584_macsec_del_rxsc(struct macsec_context *ctx)
 	struct vsc8531_private *priv = ctx->phydev->priv;
 	struct macsec_flow *flow, *tmp;
 
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
 	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
 		if (flow->bank == MACSEC_INGR && flow->rx_sa &&
 		    flow->rx_sa->sc->sci == ctx->rx_sc->sci)
@@ -847,9 +824,6 @@ static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
 	struct macsec_flow *flow;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -869,9 +843,6 @@ static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
 	struct macsec_flow *flow;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -891,9 +862,6 @@ static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -909,9 +877,6 @@ static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
 	struct macsec_flow *flow;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -931,9 +896,6 @@ static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
 	struct macsec_flow *flow;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -953,9 +915,6 @@ static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
-	if (ctx->prepare)
-		return 0;
-
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
-- 
2.37.3

