Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546BB5BFF3B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiIUNvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiIUNvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F0783F18
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2FF6304E
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EDCC433C1;
        Wed, 21 Sep 2022 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768287;
        bh=2sitIxVtAv+R1eooDZ0qfpINIMIxbMDsZvcxqGPSOrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE55Yf5McCfk0FmqhgMI63zLtVfYWHYaF14sgkYEofyriEmI2e5Ekz6RG2XZHXNYk
         nmGWDdFCNBw0VvItqd/0Kgijgr8N76F6IfbqPpiwZ6IsaLyxdzpSNIWUeB85nFH33R
         Y48Bg/yS2YPyMNHlIBeyePbJRFSER/PdmyxrepZcKjXAee9SED/RGVyGPas/KCjyXe
         Pm5nwKOfWvA7pHMXMlF4DieD0fRGw3axYQXqJ52oKLCQQnEqfOu8ftbTPvLL9lz0ZF
         XMeCKcILWaGTgSaC5GgmR8NxzaFSGwmFjiv60m4kxHf7izLEX8GiKSn+eUp9I5yWxX
         ZlEnr3gOGG42A==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 2/7] net: atlantic: macsec: make the prepare phase a noop
Date:   Wed, 21 Sep 2022 15:51:13 +0200
Message-Id: <20220921135118.968595-3-atenart@kernel.org>
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
make it a no-op in the Atlantic driver.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 90 +++++++++----------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 02058fe79f52..9dbd348ac714 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -452,6 +452,9 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 	u32 txsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	if (secy->xpn)
 		return -EOPNOTSUPP;
 
@@ -466,9 +469,6 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 	if (txsc_idx == AQ_MACSEC_MAX_SC)
 		return -ENOSPC;
 
-	if (ctx->prepare)
-		return 0;
-
 	cfg->sc_sa = sc_sa;
 	cfg->aq_txsc[txsc_idx].hw_sc_idx = aq_to_hw_sc_idx(txsc_idx, sc_sa);
 	cfg->aq_txsc[txsc_idx].sw_secy = secy;
@@ -488,13 +488,13 @@ static int aq_mdo_upd_secy(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
 	if (txsc_idx < 0)
 		return -ENOENT;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
 		ret = aq_set_txsc(nic, txsc_idx);
 
@@ -597,13 +597,13 @@ static int aq_mdo_add_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_txsc = &cfg->aq_txsc[txsc_idx];
 	set_bit(ctx->sa.assoc_num, &aq_txsc->tx_sa_idx_busy);
 
@@ -627,13 +627,13 @@ static int aq_mdo_upd_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_txsc = &cfg->aq_txsc[txsc_idx];
 	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
 		ret = aq_update_txsa(nic, aq_txsc->hw_sc_idx, secy,
@@ -677,13 +677,13 @@ static int aq_mdo_del_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	ret = aq_clear_txsa(nic, &cfg->aq_txsc[txsc_idx], ctx->sa.assoc_num,
 			    AQ_CLEAR_ALL);
 
@@ -773,6 +773,9 @@ static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 	u32 rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	if (hweight32(cfg->rxsc_idx_busy) >= rxsc_idx_max)
 		return -ENOSPC;
 
@@ -780,9 +783,6 @@ static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 	if (rxsc_idx >= rxsc_idx_max)
 		return -ENOSPC;
 
-	if (ctx->prepare)
-		return 0;
-
 	cfg->aq_rxsc[rxsc_idx].hw_sc_idx = aq_to_hw_sc_idx(rxsc_idx,
 							   cfg->sc_sa);
 	cfg->aq_rxsc[rxsc_idx].sw_secy = ctx->secy;
@@ -805,13 +805,13 @@ static int aq_mdo_upd_rxsc(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (netif_carrier_ok(nic->ndev) && netif_running(ctx->secy->netdev))
 		ret = aq_set_rxsc(nic, rxsc_idx);
 
@@ -872,13 +872,13 @@ static int aq_mdo_del_rxsc(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (netif_carrier_ok(nic->ndev))
 		clear_type = AQ_CLEAR_ALL;
 
@@ -944,13 +944,13 @@ static int aq_mdo_add_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_rxsc = &nic->macsec_cfg->aq_rxsc[rxsc_idx];
 	set_bit(ctx->sa.assoc_num, &aq_rxsc->rx_sa_idx_busy);
 
@@ -974,13 +974,13 @@ static int aq_mdo_upd_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
 		ret = aq_update_rxsa(nic, cfg->aq_rxsc[rxsc_idx].hw_sc_idx,
 				     secy, ctx->sa.rx_sa, NULL,
@@ -1025,13 +1025,13 @@ static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	ret = aq_clear_rxsa(nic, &cfg->aq_rxsc[rxsc_idx], ctx->sa.assoc_num,
 			    AQ_CLEAR_ALL);
 
@@ -1069,13 +1069,13 @@ static int aq_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 	struct aq_macsec_txsc *aq_txsc;
 	int txsc_idx;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -ENOENT;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_txsc = &nic->macsec_cfg->aq_txsc[txsc_idx];
 	stats = &aq_txsc->stats;
 	aq_get_txsc_stats(hw, aq_txsc->hw_sc_idx, stats);
@@ -1102,13 +1102,13 @@ static int aq_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 	u32 next_pn;
 	int ret;
 
+	if (ctx->prepare)
+		return 0;
+
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_txsc = &cfg->aq_txsc[txsc_idx];
 	sa_idx = aq_txsc->hw_sc_idx | ctx->sa.assoc_num;
 	stats = &aq_txsc->tx_sa_stats[ctx->sa.assoc_num];
@@ -1143,13 +1143,13 @@ static int aq_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 	int ret = 0;
 	int i;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_rxsc = &cfg->aq_rxsc[rxsc_idx];
 	for (i = 0; i < MACSEC_NUM_AN; i++) {
 		if (!test_bit(i, &aq_rxsc->rx_sa_idx_busy))
@@ -1192,13 +1192,13 @@ static int aq_mdo_get_rx_sa_stats(struct macsec_context *ctx)
 	u32 next_pn;
 	int ret;
 
+	if (ctx->prepare)
+		return 0;
+
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_rxsc = &cfg->aq_rxsc[rxsc_idx];
 	stats = &aq_rxsc->rx_sa_stats[ctx->sa.assoc_num];
 	sa_idx = aq_rxsc->hw_sc_idx | ctx->sa.assoc_num;
-- 
2.37.3

