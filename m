Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B192739ABA9
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhFCUN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhFCUNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BC561404;
        Thu,  3 Jun 2021 20:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751123;
        bh=hSqW0xfuNUOynwkMyNo96jcuOWqlRoeYVKFxZn0dBic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8NlDqVzUiA0RyY6HqUZLSDgnjGySGWtOQ/+NuRNn+E7jmYBEN8Chzvc48BSBI4rH
         jxLLPK5J3vpsailnsp2CPApswOcbrfcVdfUhDnwjetqc6aolv+QLhLa5mXVcL8FQEg
         sdF0rNFOK02V79GETPu729ctgXudzj0j/txeKzSvrh9KOFCOnpPZY4pEO4SEDlyMyA
         efynM5BT1QbHNvmW1rCtrbIdk26xwtg2/P0CIGAHitqzaWfyWtDNqbJVJxXD8LJpAs
         /mogUxXTA6Vghd4f7RiP1wTMJHm0PD8J3FAsTMxHRmJBGE/8d0KrPUVR7LzS23DfTT
         QckrXKNwvxsLA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/10] net/mlx5e: Disable TLS device offload in kdump mode
Date:   Thu,  3 Jun 2021 13:11:54 -0700
Message-Id: <20210603201155.109184-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

Under kdump environment we want to use the smallest possible amount
of resources, that includes setting SQ size to minimum.
However, when running on a device that supports TLS device offload,
then the SQ stop room becomes larger than with non-capable device and
requires increasing the SQ size.

Since TLS device offload is not necessary in kdump mode, disable it to
reduce the memory requirements for capable devices.

With this change, the needed SQ stop room size drops by 33.

Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |  4 ++--
 .../mellanox/mlx5/core/en_accel/ktls.c        | 11 +++++----
 .../mellanox/mlx5/core/en_accel/ktls.h        | 24 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  5 +++-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  2 +-
 .../mellanox/mlx5/core/en_accel/tls.c         |  6 ++---
 .../mellanox/mlx5/core/en_accel/tls.h         | 10 +++++++-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  8 +++----
 .../mellanox/mlx5/core/en_accel/tls_stats.c   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 10 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 69cdc4e41a46..150c8e82c738 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -614,7 +614,7 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
 
 static u8 mlx5e_build_async_icosq_log_wq_sz(struct mlx5_core_dev *mdev)
 {
-	if (mlx5_accel_is_ktls_rx(mdev))
+	if (mlx5e_accel_is_ktls_rx(mdev))
 		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
 
 	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
@@ -643,7 +643,7 @@ static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 
 	mlx5e_build_sq_param_common(mdev, param);
 	param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
-	param->is_tls = mlx5_accel_is_ktls_rx(mdev);
+	param->is_tls = mlx5e_accel_is_ktls_rx(mdev);
 	if (param->is_tls)
 		param->stop_room += mlx5e_stop_room_for_wqe(1); /* for TLS RX resync NOP */
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 95293ee0d38d..d93aadbf10da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -59,12 +59,15 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (mlx5_accel_is_ktls_tx(mdev)) {
+	if (!mlx5e_accel_is_ktls_tx(mdev) && !mlx5e_accel_is_ktls_rx(mdev))
+		return;
+
+	if (mlx5e_accel_is_ktls_tx(mdev)) {
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->features    |= NETIF_F_HW_TLS_TX;
 	}
 
-	if (mlx5_accel_is_ktls_rx(mdev))
+	if (mlx5e_accel_is_ktls_rx(mdev))
 		netdev->hw_features |= NETIF_F_HW_TLS_RX;
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
@@ -89,7 +92,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 {
 	int err;
 
-	if (!mlx5_accel_is_ktls_rx(priv->mdev))
+	if (!mlx5e_accel_is_ktls_rx(priv->mdev))
 		return 0;
 
 	priv->tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
@@ -109,7 +112,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 {
-	if (!mlx5_accel_is_ktls_rx(priv->mdev))
+	if (!mlx5e_accel_is_ktls_rx(priv->mdev))
 		return;
 
 	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index aaa579bf9a39..5833deb2354c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -15,6 +15,25 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable);
 struct mlx5e_ktls_resync_resp *
 mlx5e_ktls_rx_resync_create_resp_list(void);
 void mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list);
+
+static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev)
+{
+	return !is_kdump_kernel() &&
+		mlx5_accel_is_ktls_tx(mdev);
+}
+
+static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev)
+{
+	return !is_kdump_kernel() &&
+		mlx5_accel_is_ktls_rx(mdev);
+}
+
+static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev)
+{
+	return !is_kdump_kernel() &&
+		mlx5_accel_is_ktls_device(mdev);
+}
+
 #else
 
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
@@ -44,6 +63,11 @@ mlx5e_ktls_rx_resync_create_resp_list(void)
 
 static inline void
 mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list) {}
+
+static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev) { return false; }
+static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev) { return false; }
+static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
+
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 51bdf71073f3..2c0a9344338a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -23,10 +23,13 @@ mlx5e_ktls_dumps_num_wqes(struct mlx5e_params *params, unsigned int nfrags,
 	return nfrags + DIV_ROUND_UP(sync_len, MLX5E_SW2HW_MTU(params, params->sw_mtu));
 }
 
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_params *params)
+u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	u16 num_dumps, stop_room = 0;
 
+	if (!mlx5e_accel_is_ktls_tx(mdev))
+		return 0;
+
 	num_dumps = mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
 
 	stop_room += mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 8f79335057dc..08c9d5134479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -14,7 +14,7 @@ struct mlx5e_accel_tx_tls_state {
 	u32 tls_tisn;
 };
 
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_params *params);
+u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb, int datalen,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index d6b21b899dbc..b8fc863aa68d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -192,13 +192,13 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	u32 caps;
 
-	if (mlx5_accel_is_ktls_device(priv->mdev)) {
+	if (mlx5e_accel_is_ktls_device(priv->mdev)) {
 		mlx5e_ktls_build_netdev(priv);
 		return;
 	}
 
 	/* FPGA */
-	if (!mlx5_accel_is_tls_device(priv->mdev))
+	if (!mlx5e_accel_is_tls_device(priv->mdev))
 		return;
 
 	caps = mlx5_accel_tls_device_caps(priv->mdev);
@@ -224,7 +224,7 @@ int mlx5e_tls_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tls *tls;
 
-	if (!mlx5_accel_is_tls_device(priv->mdev))
+	if (!mlx5e_accel_is_tls_device(priv->mdev))
 		return 0;
 
 	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 4c9274d390da..3fd6fd69bbd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -103,11 +103,18 @@ int mlx5e_tls_get_count(struct mlx5e_priv *priv);
 int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
 int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data);
 
+static inline bool mlx5e_accel_is_tls_device(struct mlx5_core_dev *mdev)
+{
+	return !is_kdump_kernel() &&
+		mlx5_accel_is_tls_device(mdev);
+}
+
 #else
 
 static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 {
-	if (mlx5_accel_is_ktls_device(priv->mdev))
+	if (!is_kdump_kernel() &&
+	    mlx5_accel_is_ktls_device(priv->mdev))
 		mlx5e_ktls_build_netdev(priv);
 }
 
@@ -117,6 +124,7 @@ static inline void mlx5e_tls_cleanup(struct mlx5e_priv *priv) { }
 static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
 static inline int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data) { return 0; }
 static inline int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
+static inline bool mlx5e_accel_is_tls_device(struct mlx5_core_dev *mdev) { return false; }
 
 #endif
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 82dc09aaa7fc..7a700f913582 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -273,7 +273,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
 		goto err_out;
 
-	if (mlx5_accel_is_ktls_tx(sq->mdev))
+	if (mlx5e_accel_is_ktls_tx(sq->mdev))
 		return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
 
 	/* FPGA */
@@ -378,11 +378,11 @@ void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq *rq, struct sk_buff *skb,
 
 u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
-	if (!mlx5_accel_is_tls_device(mdev))
+	if (!mlx5e_accel_is_tls_device(mdev))
 		return 0;
 
-	if (mlx5_accel_is_ktls_device(mdev))
-		return mlx5e_ktls_get_stop_room(params);
+	if (mlx5e_accel_is_ktls_device(mdev))
+		return mlx5e_ktls_get_stop_room(mdev, params);
 
 	/* FPGA */
 	/* Resync SKB. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
index 29463bdb7715..ffc84f9b41b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -58,7 +58,7 @@ static const struct counter_desc *get_tls_atomic_stats(struct mlx5e_priv *priv)
 {
 	if (!priv->tls)
 		return NULL;
-	if (mlx5_accel_is_ktls_device(priv->mdev))
+	if (mlx5e_accel_is_ktls_device(priv->mdev))
 		return mlx5e_ktls_sw_stats_desc;
 	return mlx5e_tls_sw_stats_desc;
 }
@@ -67,7 +67,7 @@ int mlx5e_tls_get_count(struct mlx5e_priv *priv)
 {
 	if (!priv->tls)
 		return 0;
-	if (mlx5_accel_is_ktls_device(priv->mdev))
+	if (mlx5e_accel_is_ktls_device(priv->mdev))
 		return ARRAY_SIZE(mlx5e_ktls_sw_stats_desc);
 	return ARRAY_SIZE(mlx5e_tls_sw_stats_desc);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b1981dc9cc7b..0d59639f8ac0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -857,7 +857,7 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 	if (err)
 		goto err_destroy_rq;
 
-	if (mlx5e_is_tls_on(rq->priv) && !mlx5_accel_is_ktls_device(mdev))
+	if (mlx5e_is_tls_on(rq->priv) && !mlx5e_accel_is_ktls_device(mdev))
 		__set_bit(MLX5E_RQ_STATE_FPGA_TLS, &rq->state); /* must be FPGA */
 
 	if (MLX5_CAP_ETH(mdev, cqe_checksum_full))
-- 
2.31.1

