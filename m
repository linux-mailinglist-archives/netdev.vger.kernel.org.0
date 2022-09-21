Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7027D5BFF3F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiIUNwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiIUNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:51:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423881B16
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60BEA63052
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD75C433C1;
        Wed, 21 Sep 2022 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663768296;
        bh=xNMQMlzdKZL+bChdEsAsUO4rwUML3Vy6aPsHoHxQ35A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARwGUaaS+c+iGP4PHiNMMKQ7M4YM/I7kytRTGh1hFYCEKjXyNB1tYl9S+XRd7rfc8
         viQOkhL2ROppRWdfqdgUZSj3cbTaN4x5Ku/mt0RORFRWRl245ot/izr8vP4CCE23MB
         4OVeGh5f42e4LxiPAuGZz4+VvElznzrMWR52QA0JQwoq4898OFNex4F7z+XRQWcpHX
         Yt+hVvLpANNXW9bLLyazNnzdN/wArpYm8/rvK0WaQopyl9pQxVAJ7Ys9n1ya5hEfLa
         l/1L7q5ZNfaUuQ3M/7BJnMa6ARCHn/hlOw4CAG8tQRKkadpTn0qUfrhsSE3s0S1pF/
         fWmoGKs0F18iQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Antoine Tenart <atenart@kernel.org>, sundeep.lkml@gmail.com,
        saeedm@nvidia.com, liorna@nvidia.com, dbogdanov@marvell.com,
        mstarovoitov@marvell.com, irusskikh@marvell.com,
        sd@queasysnail.net, netdev@vger.kernel.org
Subject: [PATCH net-next 5/7] net: atlantic: macsec: remove checks on the prepare phase
Date:   Wed, 21 Sep 2022 15:51:16 +0200
Message-Id: <20220921135118.968595-6-atenart@kernel.org>
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
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 57 -------------------
 1 file changed, 57 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 9dbd348ac714..3d0e16791e1c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -292,9 +292,6 @@ static int aq_mdo_dev_open(struct macsec_context *ctx)
 	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (netif_carrier_ok(nic->ndev))
 		ret = aq_apply_secy_cfg(nic, ctx->secy);
 
@@ -306,9 +303,6 @@ static int aq_mdo_dev_stop(struct macsec_context *ctx)
 	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	int i;
 
-	if (ctx->prepare)
-		return 0;
-
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (nic->macsec_cfg->txsc_idx_busy & BIT(i))
 			aq_clear_secy(nic, nic->macsec_cfg->aq_txsc[i].sw_secy,
@@ -452,9 +446,6 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
 	u32 txsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (secy->xpn)
 		return -EOPNOTSUPP;
 
@@ -488,9 +479,6 @@ static int aq_mdo_upd_secy(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
 	if (txsc_idx < 0)
 		return -ENOENT;
@@ -543,9 +531,6 @@ static int aq_mdo_del_secy(struct macsec_context *ctx)
 	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (!nic->macsec_cfg)
 		return 0;
 
@@ -597,9 +582,6 @@ static int aq_mdo_add_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
@@ -627,9 +609,6 @@ static int aq_mdo_upd_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
@@ -677,9 +656,6 @@ static int aq_mdo_del_txsa(struct macsec_context *ctx)
 	int txsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
@@ -773,9 +749,6 @@ static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 	u32 rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	if (hweight32(cfg->rxsc_idx_busy) >= rxsc_idx_max)
 		return -ENOSPC;
 
@@ -805,9 +778,6 @@ static int aq_mdo_upd_rxsc(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
@@ -872,9 +842,6 @@ static int aq_mdo_del_rxsc(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
@@ -944,9 +911,6 @@ static int aq_mdo_add_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
@@ -974,9 +938,6 @@ static int aq_mdo_upd_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
@@ -1025,9 +986,6 @@ static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 	int rxsc_idx;
 	int ret = 0;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
@@ -1044,9 +1002,6 @@ static int aq_mdo_get_dev_stats(struct macsec_context *ctx)
 	struct aq_macsec_common_stats *stats = &nic->macsec_cfg->stats;
 	struct aq_hw_s *hw = nic->aq_hw;
 
-	if (ctx->prepare)
-		return 0;
-
 	aq_get_macsec_common_stats(hw, stats);
 
 	ctx->stats.dev_stats->OutPktsUntagged = stats->out.untagged_pkts;
@@ -1069,9 +1024,6 @@ static int aq_mdo_get_tx_sc_stats(struct macsec_context *ctx)
 	struct aq_macsec_txsc *aq_txsc;
 	int txsc_idx;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -ENOENT;
@@ -1102,9 +1054,6 @@ static int aq_mdo_get_tx_sa_stats(struct macsec_context *ctx)
 	u32 next_pn;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
 	if (txsc_idx < 0)
 		return -EINVAL;
@@ -1143,9 +1092,6 @@ static int aq_mdo_get_rx_sc_stats(struct macsec_context *ctx)
 	int ret = 0;
 	int i;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -ENOENT;
@@ -1192,9 +1138,6 @@ static int aq_mdo_get_rx_sa_stats(struct macsec_context *ctx)
 	u32 next_pn;
 	int ret;
 
-	if (ctx->prepare)
-		return 0;
-
 	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
 	if (rxsc_idx < 0)
 		return -EINVAL;
-- 
2.37.3

