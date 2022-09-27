Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CFD5ECEAE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiI0UhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiI0Ugs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44594FC3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B621FB81BFF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCD8C433D6;
        Tue, 27 Sep 2022 20:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311004;
        bh=ekALF8nHoEZuM4ah3VqUOPNvy+rqgzjC/Tlq0aHOlkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVgUzIeoBoRud3GB5j0TNNROPw/U8TzLCL/CMOzKZ1u4ilRG/MrGZEo98iPFWVh9L
         ybr0kElGkO3194J3QCt0RzuZGZM0jiiatUVJzJiBNLA3OrCpbhoS/cps1EA8YIaXQ2
         HstLrotnteQC00kjYXO9TbH6e2MwDrLR05En9S8u2zJjiu5jCduH/Ld5ppeTWJnaIY
         +/AV+/4OEX7qukCHetm67CzbC5Qwoxi2G4iW8wB7vDl+k/1spqglYraF3oReNBeFgU
         21uroD7/7Y5wLPazyiClxt8rPVP8H8G6ThOzPHgc0fcua5GgvLxi21KsM53X7SU/5+
         VSK3Sj8mDv9eQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 06/16] net/mlx5e: Let mlx5e_get_sw_max_sq_mpw_wqebbs accept mdev
Date:   Tue, 27 Sep 2022 13:36:01 -0700
Message-Id: <20220927203611.244301-7-saeed@kernel.org>
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

To shorten and simplify code, let mlx5e_get_sw_max_sq_mpw_wqebbs accept
mdev and derive max SQ WQEBBs from it. Also rename the function to a
more generic name mlx5e_get_max_sq_aligned_wqebbs, because the following
patches will use it in non-MPWQE contexts.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 881e406d8757..fc595a8ef11f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -174,8 +174,7 @@ struct page_pool;
 	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
 
 #define MLX5E_MAX_KLM_PER_WQE(mdev) \
-	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * \
-		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)))
+	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * mlx5e_get_max_sq_aligned_wqebbs(mdev))
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
@@ -235,7 +234,7 @@ static inline u8 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
 			 MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
 }
 
-static inline u8 mlx5e_get_sw_max_sq_mpw_wqebbs(u8 max_sq_wqebbs)
+static inline u8 mlx5e_get_max_sq_aligned_wqebbs(struct mlx5_core_dev *mdev)
 {
 /* The return value will be multiplied by MLX5_SEND_WQEBB_NUM_DS.
  * Since max_sq_wqebbs may be up to MLX5_SEND_WQE_MAX_WQEBBS == 16,
@@ -244,8 +243,9 @@ static inline u8 mlx5e_get_sw_max_sq_mpw_wqebbs(u8 max_sq_wqebbs)
  * than MLX5_SEND_WQE_MAX_WQEBBS to let a full-session WQE be
  * cache-aligned.
  */
-	u8 wqebbs = min_t(u8, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
+	u8 wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
 
+	wqebbs = min_t(u8, wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
 #if L1_CACHE_BYTES >= 128
 	wqebbs = ALIGN_DOWN(wqebbs, 2);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 73ebb7ff4b26..5391b7ca1d21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1156,8 +1156,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 			&c->priv->channel_stats[c->ix]->xdpsq :
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
 	sq->stop_room = MLX5E_STOP_ROOM(mlx5e_get_max_sq_wqebbs(mdev));
-	sq->max_sq_mpw_wqebbs =
-		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev));
+	sq->max_sq_mpw_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1318,8 +1317,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->max_sq_mpw_wqebbs =
-		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev));
+	sq->max_sq_mpw_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
-- 
2.37.3

