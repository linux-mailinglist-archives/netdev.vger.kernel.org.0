Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914E44F146F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbiDDMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238824AbiDDMKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C752512AB7;
        Mon,  4 Apr 2022 05:08:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADE7DB8160C;
        Mon,  4 Apr 2022 12:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F00C340F2;
        Mon,  4 Apr 2022 12:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649074117;
        bh=ehCgOD+U6gmvEZhuUHXahJ3XyRPs9YuAKCQeqFsnd5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDRe6UKU5+HGvTmCFm8HFBw7Cq8QE+jVhqg2auCWLMRtMQm3hBCCYX9liL2ved7oF
         h9KTv+loLFmpV5hjRBBp6kLgpKaMJ6izAmKRpWG+58gz/X/h3ElacZIqRigWnOCqR3
         7XnyTb41V9tu36Rg/27E3+CyJS0hk2jT5qbAfWFC5uOUSr70Met/CsvUJImHQAkK4p
         qzIL74inPiOYt47e/chwDs6yIIBoqV7iQvQoYBkw7d073QEhFwZe/0s1SqgZhAr11F
         Sq3Mo1DSJGCDrEm1BVTHihy8bAu0V9lK9NM0Tk7EyOF8Os9qimo0+fLfoY3XUgsKJi
         j0TRIZF2GEWRQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 4/5] net/mlx5: Remove tls vs. ktls separation as it is the same
Date:   Mon,  4 Apr 2022 15:08:18 +0300
Message-Id: <67e596599edcffb0de43f26551208dfd34ac777e.1649073691.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
References: <cover.1649073691.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

After removal FPGA TLS, we can remove tls->ktls indirection too,
as it is the same thing.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 11 +--
 .../mellanox/mlx5/core/en_accel/ktls.c        | 22 ++++-
 .../mellanox/mlx5/core/en_accel/ktls.h        | 32 +++++++
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  2 +-
 .../en_accel/{tls_stats.c => ktls_stats.c}    | 38 ++++-----
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 18 +++-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 28 +++++-
 .../mellanox/mlx5/core/en_accel/tls.c         | 70 ---------------
 .../mellanox/mlx5/core/en_accel/tls.h         | 85 -------------------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 70 ---------------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    | 85 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
 16 files changed, 130 insertions(+), 356 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (76%)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b7e3bcb5e6c7..44ff1623707a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -97,7 +97,7 @@ mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o
 
-mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
+mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
 				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 08fd1370a8b0..458a75607ca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -207,7 +207,7 @@ u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 	bool is_mpwqe = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
 	u16 stop_room;
 
-	stop_room  = mlx5e_tls_get_stop_room(mdev, params);
+	stop_room  = mlx5e_ktls_get_stop_room(mdev, params);
 	stop_room += mlx5e_stop_room_for_max_wqe(mdev);
 	if (is_mpwqe)
 		/* A MPWQE can take up to the maximum-sized WQE + all the normal
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 62cde3e87c2e..04c0a5e1c89a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -37,8 +37,8 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include "en_accel/ipsec_rxtx.h"
-#include "en_accel/tls.h"
-#include "en_accel/tls_rxtx.h"
+#include "en_accel/ktls.h"
+#include "en_accel/ktls_txrx.h"
 #include "en.h"
 #include "en/txrx.h"
 
@@ -124,8 +124,9 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 
 #ifdef CONFIG_MLX5_EN_TLS
 	/* May send SKBs and WQEs. */
-	if (mlx5e_tls_skb_offloaded(skb))
-		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
+	if (mlx5e_ktls_skb_offloaded(skb))
+		if (unlikely(!mlx5e_ktls_handle_tx_skb(dev, sq, skb,
+						       &state->tls)))
 			return false;
 #endif
 
@@ -174,7 +175,7 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 					 struct mlx5_wqe_inline_seg *inlseg)
 {
 #ifdef CONFIG_MLX5_EN_TLS
-	mlx5e_tls_handle_tx_wqe(&wqe->ctrl, &state->tls);
+	mlx5e_ktls_handle_tx_wqe(&wqe->ctrl, &state->tls);
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 160aa44bcece..7f95b833f2ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -3,7 +3,6 @@
 
 #include "en.h"
 #include "lib/mlx5.h"
-#include "en_accel/tls.h"
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -159,3 +158,24 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 
 	destroy_workqueue(priv->tls->rx_wq);
 }
+
+int mlx5e_ktls_init(struct mlx5e_priv *priv)
+{
+	struct mlx5e_tls *tls;
+
+	if (!mlx5e_accel_is_ktls_device(priv->mdev))
+		return 0;
+
+	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
+	if (!tls)
+		return -ENOMEM;
+
+	priv->tls = tls;
+	return 0;
+}
+
+void mlx5e_ktls_cleanup(struct mlx5e_priv *priv)
+{
+	kfree(priv->tls);
+	priv->tls = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index 82259d25a516..50e720966358 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -5,6 +5,7 @@
 #define __MLX5E_KTLS_H__
 
 #include <linux/tls.h>
+#include <net/tls.h>
 #include "en.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
@@ -61,6 +62,25 @@ static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev)
 		mlx5_accel_is_ktls_device(mdev);
 }
 
+struct mlx5e_tls_sw_stats {
+	atomic64_t tx_tls_ctx;
+	atomic64_t tx_tls_del;
+	atomic64_t rx_tls_ctx;
+	atomic64_t rx_tls_del;
+};
+
+struct mlx5e_tls {
+	struct mlx5e_tls_sw_stats sw_stats;
+	struct workqueue_struct *rx_wq;
+};
+
+int mlx5e_ktls_init(struct mlx5e_priv *priv);
+void mlx5e_ktls_cleanup(struct mlx5e_priv *priv);
+
+int mlx5e_ktls_get_count(struct mlx5e_priv *priv);
+int mlx5e_ktls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
+int mlx5e_ktls_get_stats(struct mlx5e_priv *priv, u64 *data);
+
 #else
 static inline int
 mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
@@ -107,6 +127,18 @@ static inline bool mlx5e_accel_is_ktls_tx(struct mlx5_core_dev *mdev) { return f
 static inline bool mlx5e_accel_is_ktls_rx(struct mlx5_core_dev *mdev) { return false; }
 static inline bool mlx5e_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
 
+static inline int mlx5e_ktls_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_ktls_cleanup(struct mlx5e_priv *priv) { }
+static inline int mlx5e_ktls_get_count(struct mlx5e_priv *priv) { return 0; }
+static inline int mlx5e_ktls_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+{
+	return 0;
+}
+
+static inline int mlx5e_ktls_get_stats(struct mlx5e_priv *priv, u64 *data)
+{
+	return 0;
+}
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 96064a2033f7..0bb0633b7542 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -3,7 +3,7 @@
 
 #include <net/inet6_hashtables.h>
 #include "en_accel/en_accel.h"
-#include "en_accel/tls.h"
+#include "en_accel/ktls.h"
 #include "en_accel/ktls_txrx.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
similarity index 76%
rename from drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
rename to drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
index c25e8742bbbf..2ab46c4247ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
@@ -36,7 +36,7 @@
 
 #include "en.h"
 #include "fpga/sdk.h"
-#include "en_accel/tls.h"
+#include "en_accel/ktls.h"
 
 static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
@@ -48,15 +48,7 @@ static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 #define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
 	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
 
-static const struct counter_desc *get_tls_atomic_stats(struct mlx5e_priv *priv)
-{
-	if (!priv->tls)
-		return NULL;
-
-	return mlx5e_ktls_sw_stats_desc;
-}
-
-int mlx5e_tls_get_count(struct mlx5e_priv *priv)
+int mlx5e_ktls_get_count(struct mlx5e_priv *priv)
 {
 	if (!priv->tls)
 		return 0;
@@ -64,33 +56,35 @@ int mlx5e_tls_get_count(struct mlx5e_priv *priv)
 	return ARRAY_SIZE(mlx5e_ktls_sw_stats_desc);
 }
 
-int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data)
+int mlx5e_ktls_get_strings(struct mlx5e_priv *priv, uint8_t *data)
 {
-	const struct counter_desc *stats_desc;
 	unsigned int i, n, idx = 0;
 
-	stats_desc = get_tls_atomic_stats(priv);
-	n = mlx5e_tls_get_count(priv);
+	if (!priv->tls)
+		return 0;
+
+	n = mlx5e_ktls_get_count(priv);
 
 	for (i = 0; i < n; i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       stats_desc[i].format);
+		       mlx5e_ktls_sw_stats_desc[i].format);
 
 	return n;
 }
 
-int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data)
+int mlx5e_ktls_get_stats(struct mlx5e_priv *priv, u64 *data)
 {
-	const struct counter_desc *stats_desc;
 	unsigned int i, n, idx = 0;
 
-	stats_desc = get_tls_atomic_stats(priv);
-	n = mlx5e_tls_get_count(priv);
+	if (!priv->tls)
+		return 0;
+
+	n = mlx5e_ktls_get_count(priv);
 
 	for (i = 0; i < n; i++)
-		data[idx++] =
-		    MLX5E_READ_CTR_ATOMIC64(&priv->tls->sw_stats,
-					    stats_desc, i);
+		data[idx++] = MLX5E_READ_CTR_ATOMIC64(&priv->tls->sw_stats,
+						      mlx5e_ktls_sw_stats_desc,
+						      i);
 
 	return n;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index aaf11c66bf4c..cadf322f9d9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
-#include "en_accel/tls.h"
+#include "en_accel/ktls.h"
 #include "en_accel/ktls_txrx.h"
 #include "en_accel/ktls_utils.h"
 
@@ -448,14 +448,26 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	return MLX5E_KTLS_SYNC_FAIL;
 }
 
-bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, int datalen,
+bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			      struct sk_buff *skb,
 			      struct mlx5e_accel_tx_tls_state *state)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
+	struct tls_context *tls_ctx;
+	int datalen;
 	u32 seq;
 
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	if (!datalen)
+		return true;
+
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
+	tls_ctx = tls_get_ctx(skb->sk);
+	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+		goto err_out;
+
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
 	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 08c9d5134479..2dd78dd4ad65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -16,8 +16,8 @@ struct mlx5e_accel_tx_tls_state {
 
 u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
-bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *sq,
-			      struct sk_buff *skb, int datalen,
+bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
+			      struct sk_buff *skb,
 			      struct mlx5e_accel_tx_tls_state *state);
 void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			      struct mlx5_cqe64 *cqe, u32 *cqe_bcnt);
@@ -48,6 +48,18 @@ mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
 {
 	return budget && test_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &c->async_icosq.state);
 }
+
+static inline bool mlx5e_ktls_skb_offloaded(struct sk_buff *skb)
+{
+	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
+}
+
+static inline void
+mlx5e_ktls_handle_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg,
+			 struct mlx5e_accel_tx_tls_state *state)
+{
+	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
+}
 #else
 static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
@@ -69,6 +81,18 @@ mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
 	return false;
 }
 
+static inline u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev,
+					   struct mlx5e_params *params)
+{
+	return 0;
+}
+
+static inline void mlx5e_ktls_handle_rx_skb(struct mlx5e_rq *rq,
+					    struct sk_buff *skb,
+					    struct mlx5_cqe64 *cqe,
+					    u32 *cqe_bcnt)
+{
+}
 #endif /* CONFIG_MLX5_EN_TLS */
 
 #endif /* __MLX5E_TLS_TXRX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
deleted file mode 100644
index 0609828bb973..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/netdevice.h>
-#include <net/ipv6.h>
-#include "en_accel/tls.h"
-
-void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
-{
-	if (!mlx5e_accel_is_ktls_device(priv->mdev))
-		return;
-
-	mlx5e_ktls_build_netdev(priv);
-}
-
-int mlx5e_tls_init(struct mlx5e_priv *priv)
-{
-	struct mlx5e_tls *tls;
-
-	if (!mlx5e_accel_is_tls_device(priv->mdev))
-		return 0;
-
-	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
-	if (!tls)
-		return -ENOMEM;
-
-	priv->tls = tls;
-	return 0;
-}
-
-void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
-{
-	struct mlx5e_tls *tls = priv->tls;
-
-	if (!tls)
-		return;
-
-	kfree(tls);
-	priv->tls = NULL;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
deleted file mode 100644
index a9776fd04b20..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-#ifndef __MLX5E_TLS_H__
-#define __MLX5E_TLS_H__
-
-#include "en_accel/ktls.h"
-
-#ifdef CONFIG_MLX5_EN_TLS
-#include <net/tls.h>
-#include "en.h"
-
-struct mlx5e_tls_sw_stats {
-	atomic64_t tx_tls_ctx;
-	atomic64_t tx_tls_del;
-	atomic64_t rx_tls_ctx;
-	atomic64_t rx_tls_del;
-};
-
-struct mlx5e_tls {
-	struct mlx5e_tls_sw_stats sw_stats;
-	struct workqueue_struct *rx_wq;
-};
-
-void mlx5e_tls_build_netdev(struct mlx5e_priv *priv);
-int mlx5e_tls_init(struct mlx5e_priv *priv);
-void mlx5e_tls_cleanup(struct mlx5e_priv *priv);
-
-int mlx5e_tls_get_count(struct mlx5e_priv *priv);
-int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data);
-int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data);
-
-static inline bool mlx5e_accel_is_tls_device(struct mlx5_core_dev *mdev)
-{
-	return !is_kdump_kernel() && mlx5_accel_is_ktls_device(mdev);
-}
-
-#else
-
-static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
-{
-	if (!is_kdump_kernel() &&
-	    mlx5_accel_is_ktls_device(priv->mdev))
-		mlx5e_ktls_build_netdev(priv);
-}
-
-static inline int mlx5e_tls_init(struct mlx5e_priv *priv) { return 0; }
-static inline void mlx5e_tls_cleanup(struct mlx5e_priv *priv) { }
-static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0; }
-static inline int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data) { return 0; }
-static inline int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data) { return 0; }
-static inline bool mlx5e_accel_is_tls_device(struct mlx5_core_dev *mdev) { return false; }
-
-#endif
-
-#endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
deleted file mode 100644
index 39412fafa860..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include "en_accel/tls.h"
-#include "en_accel/tls_rxtx.h"
-#include "accel/accel.h"
-
-#include <net/inet6_hashtables.h>
-#include <linux/ipv6.h>
-
-bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state)
-{
-	struct tls_context *tls_ctx;
-	int datalen;
-
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
-	if (!datalen)
-		return true;
-
-	mlx5e_tx_mpwqe_ensure_complete(sq);
-
-	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
-		goto err_out;
-
-	return mlx5e_ktls_handle_tx_skb(tls_ctx, sq, skb, datalen, state);
-
-err_out:
-	dev_kfree_skb_any(skb);
-	return false;
-}
-
-u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
-{
-	if (!mlx5e_accel_is_tls_device(mdev))
-		return 0;
-
-	return mlx5e_ktls_get_stop_room(mdev, params);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
deleted file mode 100644
index 168acceb0d28..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2018 Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#ifndef __MLX5E_TLS_RXTX_H__
-#define __MLX5E_TLS_RXTX_H__
-
-#include "accel/accel.h"
-#include "en_accel/ktls_txrx.h"
-
-#ifdef CONFIG_MLX5_EN_TLS
-
-#include <linux/skbuff.h>
-#include "en.h"
-#include "en/txrx.h"
-
-u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
-
-bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
-			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state);
-
-static inline bool mlx5e_tls_skb_offloaded(struct sk_buff *skb)
-{
-	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
-}
-
-static inline void
-mlx5e_tls_handle_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg,
-			struct mlx5e_accel_tx_tls_state *state)
-{
-	cseg->tis_tir_num = cpu_to_be32(state->tls_tisn << 8);
-}
-
-static inline void
-mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt)
-{
-	if (unlikely(get_cqe_tls_offload(cqe))) /* cqe bit indicates a TLS device */
-		mlx5e_ktls_handle_rx_skb(rq, skb, cqe, cqe_bcnt);
-}
-
-#else
-
-static inline bool
-mlx5e_accel_is_tls(struct mlx5_cqe64 *cqe, struct sk_buff *skb) { return false; }
-static inline void
-mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
-			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt) {}
-static inline u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
-{
-	return 0;
-}
-
-#endif /* CONFIG_MLX5_EN_TLS */
-
-#endif /* __MLX5E_TLS_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7ef1ee7e7572..89a85030b0eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -47,7 +47,7 @@
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
 #include "en_accel/en_accel.h"
-#include "en_accel/tls.h"
+#include "en_accel/ktls.h"
 #include "accel/ipsec.h"
 #include "lib/vxlan.h"
 #include "lib/clock.h"
@@ -4930,7 +4930,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
-	mlx5e_tls_build_netdev(priv);
+	mlx5e_ktls_build_netdev(priv);
 }
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
@@ -4992,7 +4992,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
 
-	err = mlx5e_tls_init(priv);
+	err = mlx5e_ktls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
@@ -5003,7 +5003,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
-	mlx5e_tls_cleanup(priv);
+	mlx5e_ktls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 56bb58704bf9..84cebf4c5ada 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -51,7 +51,7 @@
 #include "accel/ipsec.h"
 #include "fpga/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
-#include "en_accel/tls_rxtx.h"
+#include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
@@ -1416,7 +1416,8 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	skb->mac_len = ETH_HLEN;
 
-	mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
+	if (unlikely(get_cqe_tls_offload(cqe)))
+		mlx5e_ktls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
 
 	if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
 		mlx5e_ipsec_offload_handle_rx_skb(netdev, skb, cqe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index bdc870f9c2f3..5123a220d7a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -32,7 +32,7 @@
 
 #include "lib/mlx5.h"
 #include "en.h"
-#include "en_accel/tls.h"
+#include "en_accel/ktls.h"
 #include "en_accel/en_accel.h"
 #include "en/ptp.h"
 #include "en/port.h"
@@ -1900,17 +1900,17 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(pme) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(tls)
 {
-	return mlx5e_tls_get_count(priv);
+	return mlx5e_ktls_get_count(priv);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(tls)
 {
-	return idx + mlx5e_tls_get_strings(priv, data + idx * ETH_GSTRING_LEN);
+	return idx + mlx5e_ktls_get_strings(priv, data + idx * ETH_GSTRING_LEN);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(tls)
 {
-	return idx + mlx5e_tls_get_stats(priv, data + idx);
+	return idx + mlx5e_ktls_get_stats(priv, data + idx);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(tls) { return; }
-- 
2.35.1

