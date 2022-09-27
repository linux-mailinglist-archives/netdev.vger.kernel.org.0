Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35B35ECEAF
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiI0UhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbiI0Ugv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561798260A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDEBFB81C17
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2DBC433D7;
        Tue, 27 Sep 2022 20:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311008;
        bh=0TwNPpP23IGEpQbvPJ5xghJC/LI+IPnmyI0EeX6XZyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eba+UeA0bYTeO8Sba4+XxBsQnFww25C/x4HWCJV5q0M74yjsw0/EO3+goQTlOA5qC
         bE/CORNTfGH1O/PRH9Mkkx0MLDB5qPBphumYnqNL+/Ti0/FeNX2V/JriRJz7ruO7va
         KCgSG5PPnqm4Tf8ddI2fste51C9KfaxEAHV8Z/ylCD0W2Nu0exL7wFLK8sC/4WJhaO
         dGMGCuL+6dRqXlMsGruvSCFMetmGmRHnDStCz6gvNpGERSuLavkvxcWR7nZx0tWns8
         y4GFcrKnlYI0es4JsjOdZaEE2XEt8i2hNsnQFzpA1RLrRPrKzTgSWDFRFTibUTR1/K
         KixVrSrhw12TA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 10/16] net/mlx5e: kTLS, Check ICOSQ WQE size in advance
Date:   Tue, 27 Sep 2022 13:36:05 -0700
Message-Id: <20220927203611.244301-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
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

Instead of WARNing in runtime when TLS offload WQEs posted to ICOSQ are
over the hardware limit, check their size before enabling TLS RX
offload, and block the offload if the condition fails. It also allows to
drop a u16 field from struct mlx5e_icosq.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h   |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  |  8 +-------
 .../mellanox/mlx5/core/en_accel/ktls.c         | 18 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls.h         |  5 +----
 .../net/ethernet/mellanox/mlx5/core/en_main.c  |  1 -
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index fc595a8ef11f..4778298f4645 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -609,7 +609,6 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
-	u16                        max_sq_wqebbs;
 
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 8751e48e283d..f4f306bb8e6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -448,13 +448,7 @@ static inline u16 mlx5e_stop_room_for_mpwqe(struct mlx5_core_dev *mdev)
 
 static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size)
 {
-	u16 room = sq->reserved_room;
-
-	WARN_ONCE(wqe_size > sq->max_sq_wqebbs,
-		  "wqe_size %u is greater than max SQ WQEBBs %u",
-		  wqe_size, sq->max_sq_wqebbs);
-
-	room += MLX5E_STOP_ROOM(wqe_size);
+	u16 room = sq->reserved_room + MLX5E_STOP_ROOM(wqe_size);
 
 	return mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index c0b77963cc7c..da2184c94203 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -92,6 +92,24 @@ static const struct tlsdev_ops mlx5e_ktls_ops = {
 	.tls_dev_resync = mlx5e_ktls_resync,
 };
 
+bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
+{
+	u8 max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
+
+	if (is_kdump_kernel() || !MLX5_CAP_GEN(mdev, tls_rx))
+		return false;
+
+	/* Check the possibility to post the required ICOSQ WQEs. */
+	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS))
+		return false;
+	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS))
+		return false;
+	if (WARN_ON_ONCE(max_sq_wqebbs < MLX5E_KTLS_GET_PROGRESS_WQEBBS))
+		return false;
+
+	return true;
+}
+
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 299334b2f935..1c35045e41fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -61,10 +61,7 @@ static inline bool mlx5e_is_ktls_tx(struct mlx5_core_dev *mdev)
 	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_tx);
 }
 
-static inline bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
-{
-	return !is_kdump_kernel() && MLX5_CAP_GEN(mdev, tls_rx);
-}
+bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev);
 
 struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_ctx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a3013d5190d1..84cd86ff64d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1232,7 +1232,6 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
-	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
-- 
2.37.3

