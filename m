Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8148E5EEEE4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiI2HXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbiI2HW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9774118B31
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98A462061
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21076C433C1;
        Thu, 29 Sep 2022 07:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436172;
        bh=OksYJsOXLGXn47DiEiZjh0ikh7D4Grz1z6RvFm8KV3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpJpora1IJWMcFFUlI7yxCoNv31Jv67Gcw4ILesG0CZYhw5+rxGvhblBultZAL8oa
         VHePW4P754gbx9O3c04jNWxrlpyjkZps0V8DWWIfju1jLZlkC8aIogZp2vZqtdHE7s
         mWaekYNo3yZWpvnYYvsyqqzbvoAeJM1lwnPjRhTX/y6Uy1v5D0Jb+HF7MUw/iBPhSg
         V9a/r7GpT1P+KBMKJvSrYaaNzL6o04kPaEuF+kqWZBJudU9wDtR/WrHiG38ySmlIyl
         5B57m3IsOwVdAJY+3ciC36i9pYbbN5K+yg6vTvmlxCiOND9dnJp1Fh3zCW6IlQMab1
         yMGYt2GmQZNhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 14/16] net/mlx5e: Split out channel (de)activation in rx_res
Date:   Thu, 29 Sep 2022 00:21:54 -0700
Message-Id: <20220929072156.93299-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

To decrease the nesting level and reduce duplication of code, create
functions to redirect direct RQTs to the actual RQs or drop_rq, which
are used in the activation and deactivation flows of channels.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 106 +++++++++---------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index 24c32f73040a..3436ecfcbc2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -523,6 +523,53 @@ static u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int i
 	return mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt);
 }
 
+static void mlx5e_rx_res_channel_activate_direct(struct mlx5e_rx_res *res,
+						 struct mlx5e_channels *chs,
+						 unsigned int ix)
+{
+	u32 rqn;
+	int err;
+
+	mlx5e_channels_get_regular_rqn(chs, ix, &rqn);
+	err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, rqn);
+	if (err)
+		mlx5_core_warn(res->mdev, "Failed to redirect direct RQT %#x to RQ %#x (channel %u): err = %d\n",
+			       mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
+			       rqn, ix, err);
+
+	if (!(res->features & MLX5E_RX_RES_FEATURE_XSK))
+		return;
+
+	if (!mlx5e_channels_get_xsk_rqn(chs, ix, &rqn))
+		rqn = res->drop_rqn;
+	err = mlx5e_rqt_redirect_direct(&res->channels[ix].xsk_rqt, rqn);
+	if (err)
+		mlx5_core_warn(res->mdev, "Failed to redirect XSK RQT %#x to RQ %#x (channel %u): err = %d\n",
+			       mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
+			       rqn, ix, err);
+}
+
+static void mlx5e_rx_res_channel_deactivate_direct(struct mlx5e_rx_res *res,
+						   unsigned int ix)
+{
+	int err;
+
+	err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, res->drop_rqn);
+	if (err)
+		mlx5_core_warn(res->mdev, "Failed to redirect direct RQT %#x to drop RQ %#x (channel %u): err = %d\n",
+			       mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
+			       res->drop_rqn, ix, err);
+
+	if (!(res->features & MLX5E_RX_RES_FEATURE_XSK))
+		return;
+
+	err = mlx5e_rqt_redirect_direct(&res->channels[ix].xsk_rqt, res->drop_rqn);
+	if (err)
+		mlx5_core_warn(res->mdev, "Failed to redirect XSK RQT %#x to drop RQ %#x (channel %u): err = %d\n",
+			       mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
+			       res->drop_rqn, ix, err);
+}
+
 void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_channels *chs)
 {
 	unsigned int nch, ix;
@@ -536,43 +583,10 @@ void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_chann
 
 	mlx5e_rx_res_rss_enable(res);
 
-	for (ix = 0; ix < nch; ix++) {
-		u32 rqn;
-
-		mlx5e_channels_get_regular_rqn(chs, ix, &rqn);
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect direct RQT %#x to RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
-				       rqn, ix, err);
-
-		if (!(res->features & MLX5E_RX_RES_FEATURE_XSK))
-			continue;
-
-		if (!mlx5e_channels_get_xsk_rqn(chs, ix, &rqn))
-			rqn = res->drop_rqn;
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].xsk_rqt, rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect XSK RQT %#x to RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
-				       rqn, ix, err);
-	}
-	for (ix = nch; ix < res->max_nch; ix++) {
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, res->drop_rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect direct RQT %#x to drop RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
-				       res->drop_rqn, ix, err);
-
-		if (!(res->features & MLX5E_RX_RES_FEATURE_XSK))
-			continue;
-
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].xsk_rqt, res->drop_rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect XSK RQT %#x to drop RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
-				       res->drop_rqn, ix, err);
-	}
+	for (ix = 0; ix < nch; ix++)
+		mlx5e_rx_res_channel_activate_direct(res, chs, ix);
+	for (ix = nch; ix < res->max_nch; ix++)
+		mlx5e_rx_res_channel_deactivate_direct(res, ix);
 
 	if (res->features & MLX5E_RX_RES_FEATURE_PTP) {
 		u32 rqn;
@@ -595,22 +609,8 @@ void mlx5e_rx_res_channels_deactivate(struct mlx5e_rx_res *res)
 
 	mlx5e_rx_res_rss_disable(res);
 
-	for (ix = 0; ix < res->max_nch; ix++) {
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, res->drop_rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect direct RQT %#x to drop RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
-				       res->drop_rqn, ix, err);
-
-		if (!(res->features & MLX5E_RX_RES_FEATURE_XSK))
-			continue;
-
-		err = mlx5e_rqt_redirect_direct(&res->channels[ix].xsk_rqt, res->drop_rqn);
-		if (err)
-			mlx5_core_warn(res->mdev, "Failed to redirect XSK RQT %#x to drop RQ %#x (channel %u): err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
-				       res->drop_rqn, ix, err);
-	}
+	for (ix = 0; ix < res->max_nch; ix++)
+		mlx5e_rx_res_channel_deactivate_direct(res, ix);
 
 	if (res->features & MLX5E_RX_RES_FEATURE_PTP) {
 		err = mlx5e_rqt_redirect_direct(&res->ptp.rqt, res->drop_rqn);
-- 
2.37.3

