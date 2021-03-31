Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390C9350809
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbhCaURO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236477AbhCaUQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A5A610A6;
        Wed, 31 Mar 2021 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221801;
        bh=jyw10WDM0dO2UcnqgtCaEdpFE74TnelwKCkAYm+lkDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmnQN4NwtB8By1oWAa07vFmWpE8UVvDFVNf/rQfiz672QkEYE3YElVRNlvr01TE1j
         4PcPO83j+DoFq1AvJhgSMqYne42yj7WniaW+Y2H+1lKrTMB15KMNWcXNN+0D1bVW9q
         aZRVkTWCG4Ekf872VWqvqGn5QptxDD1dgfxmjadZwMphUgPicxpxhVrHhoYDi910bf
         D0LkvpRrCqHR2XrkfE+yiRERCzMwr+4SUamKX7Lssu0ryRqUvKvRovprqhIxi8XCxs
         50x1L9f3kFmqFocaAk2NBZzbV0sqTAoMVjAgC/n6xq9WeyzSXknZN5yFxHKy8Lq1w1
         1FXBxiUH0m+MQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 9/9] net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ
Date:   Wed, 31 Mar 2021 13:14:24 -0700
Message-Id: <20210331201424.331095-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

XSK wakeup flow triggers an IRQ by posting a NOP WQE and hitting
the doorbell on the async ICOSQ.
It maintains its state so that it doesn't issue another NOP WQE
if it has an outstanding one already.

For this flow to work properly, the NOP post must not fail.
Make sure to reserve room for the NOP WQE in all WQE posts to the
async ICOSQ.

Fixes: 8d94b590f1e4 ("net/mlx5e: Turn XSK ICOSQ into a general asynchronous one")
Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 ++++++
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 18 +++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 ++++++++++++++++++-
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 304b296fe8b9..bc6f77ea0a31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -516,6 +516,7 @@ struct mlx5e_icosq {
 	struct mlx5_wq_cyc         wq;
 	void __iomem              *uar_map;
 	u32                        sqn;
+	u16                        reserved_room;
 	unsigned long              state;
 
 	/* control path */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 2371b83dad9c..055c3bc23733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -441,4 +441,10 @@ static inline u16 mlx5e_stop_room_for_wqe(u16 wqe_size)
 	return wqe_size * 2 - 1;
 }
 
+static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size)
+{
+	u16 room = sq->reserved_room + mlx5e_stop_room_for_wqe(wqe_size);
+
+	return mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room);
+}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 57c5ebd597a7..19d22a63313f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -138,11 +138,10 @@ post_static_params(struct mlx5e_icosq *sq,
 {
 	struct mlx5e_set_tls_static_params_wqe *wqe;
 	struct mlx5e_icosq_wqe_info wi;
-	u16 pi, num_wqebbs, room;
+	u16 pi, num_wqebbs;
 
 	num_wqebbs = MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS;
-	room = mlx5e_stop_room_for_wqe(num_wqebbs);
-	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+	if (unlikely(!mlx5e_icosq_can_post_wqe(sq, num_wqebbs)))
 		return ERR_PTR(-ENOSPC);
 
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
@@ -169,11 +168,10 @@ post_progress_params(struct mlx5e_icosq *sq,
 {
 	struct mlx5e_set_tls_progress_params_wqe *wqe;
 	struct mlx5e_icosq_wqe_info wi;
-	u16 pi, num_wqebbs, room;
+	u16 pi, num_wqebbs;
 
 	num_wqebbs = MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS;
-	room = mlx5e_stop_room_for_wqe(num_wqebbs);
-	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+	if (unlikely(!mlx5e_icosq_can_post_wqe(sq, num_wqebbs)))
 		return ERR_PTR(-ENOSPC);
 
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
@@ -278,17 +276,15 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 
 	buf->priv_rx = priv_rx;
 
-	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS != 1);
-
 	spin_lock_bh(&sq->channel->async_icosq_lock);
 
-	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
+	if (unlikely(!mlx5e_icosq_can_post_wqe(sq, MLX5E_KTLS_GET_PROGRESS_WQEBBS))) {
 		spin_unlock_bh(&sq->channel->async_icosq_lock);
 		err = -ENOSPC;
 		goto err_dma_unmap;
 	}
 
-	pi = mlx5e_icosq_get_next_pi(sq, 1);
+	pi = mlx5e_icosq_get_next_pi(sq, MLX5E_KTLS_GET_PROGRESS_WQEBBS);
 	wqe = MLX5E_TLS_FETCH_GET_PROGRESS_PARAMS_WQE(sq, pi);
 
 #define GET_PSV_DS_CNT (DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS))
@@ -308,7 +304,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 
 	wi = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type = MLX5E_ICOSQ_WQE_GET_PSV_TLS,
-		.num_wqebbs = 1,
+		.num_wqebbs = MLX5E_KTLS_GET_PROGRESS_WQEBBS,
 		.tls_get_params.buf = buf,
 	};
 	icosq_fill_wi(sq, pi, &wi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 158f947a8503..5db63b9f3b70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1091,6 +1091,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
+	sq->reserved_room = param->stop_room;
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -2350,6 +2351,24 @@ void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
 	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
 }
 
+static void mlx5e_build_async_icosq_param(struct mlx5e_priv *priv,
+					  struct mlx5e_params *params,
+					  u8 log_wq_size,
+					  struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+
+	/* async_icosq is used by XSK only if xdp_prog is active */
+	if (params->xdp_prog)
+		param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
+	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
+	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
+	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
+}
+
 void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param)
@@ -2398,7 +2417,7 @@ static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
+	mlx5e_build_async_icosq_param(priv, params, async_icosq_log_wq_sz, &cparam->async_icosq);
 }
 
 int mlx5e_open_channels(struct mlx5e_priv *priv,
-- 
2.30.2

