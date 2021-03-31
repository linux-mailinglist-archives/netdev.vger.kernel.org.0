Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E4350806
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhCaURK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236471AbhCaUQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7879F610C7;
        Wed, 31 Mar 2021 20:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221799;
        bh=sxPS51F/VCSuUZi7BYUsBGP/+GEZxxMTpxKV8cxgavY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIIDxmt+2QtkEi2AAjqAZS3VvTccrpnpTYVOOUBHcljurCMFevm4/mVQ+XsulrQSc
         Siv8L9vruakfa0HrYBFy9UAU9fFYV3W0cisfkNvTTyHCtSpOhfD6mBXLcV8nSzHR+w
         o5D3SOSyJS1BMnlaGPsHj8KgSUPZLLz1FzySCAkHaaL7+zq9iqNYKDIqfyA3ZRvmnp
         l8xwCEr3NgHUZ9sJzy4kQr6o8zTS0VjFNoSQV13MjjzYURKrIKo7M5N65364/9Gt6K
         wTilZ6U7Q9Y7gpe1REX/EY6Wn+dGomPPSJea+Bo/CPqvZAIn2peAGekP4cjz6VPXgi
         7J1TzKDCtW+xA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/9] net/mlx5e: kTLS, Fix TX counters atomicity
Date:   Wed, 31 Mar 2021 13:14:20 -0700
Message-Id: <20210331201424.331095-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Some TLS TX counters increment per socket/connection, and are not
protected against parallel modifications from several cores.
Switch them to atomic counters by taking them out of the SQ stats into
the global atomic TLS stats.

In this patch, we touch a single counter 'tx_tls_ctx' that counts the
number of device-offloaded TX TLS connections added.
Now that this counter can be increased without the for having the SQ
context in hand, move it to the mlx5e_ktls_add_tx() callback where it
really belongs, out of the fast data-path.

This change is not needed for counters that increment only in NAPI
context or under the TX lock, as they are already protected.
Keep them as tls_* counters under 'struct mlx5e_sq_stats'.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  5 +-
 .../mellanox/mlx5/core/en_accel/tls.h         |  1 +
 .../mellanox/mlx5/core/en_accel/tls_stats.c   | 47 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  4 --
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 -
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index d16def68ecff..51bdf71073f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2019 Mellanox Technologies.
 
+#include "en_accel/tls.h"
 #include "en_accel/ktls_txrx.h"
 #include "en_accel/ktls_utils.h"
 
@@ -50,6 +51,7 @@ static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 struct mlx5e_ktls_offload_context_tx {
 	struct tls_offload_context_tx *tx_ctx;
 	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	struct mlx5e_tls_sw_stats *sw_stats;
 	u32 expected_seq;
 	u32 tisn;
 	u32 key_id;
@@ -99,6 +101,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_create_key;
 
+	priv_tx->sw_stats = &priv->tls->sw_stats;
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
@@ -111,6 +114,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		goto err_create_tis;
 
 	priv_tx->ctx_post_pending = true;
+	atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
 
 	return 0;
 
@@ -452,7 +456,6 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 
 	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-		stats->tls_ctx++;
 	}
 
 	seq = ntohl(tcp_hdr(skb)->seq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index bd270a85c804..5b408904df14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -41,6 +41,7 @@
 #include "en.h"
 
 struct mlx5e_tls_sw_stats {
+	atomic64_t tx_tls_ctx;
 	atomic64_t tx_tls_drop_metadata;
 	atomic64_t tx_tls_drop_resync_alloc;
 	atomic64_t tx_tls_drop_no_sync_data;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
index b949b9a7538b..a5aabc5c5236 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -45,49 +45,58 @@ static const struct counter_desc mlx5e_tls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_drop_bypass_required) },
 };
 
+static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
+};
+
 #define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
 	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
 
-#define NUM_TLS_SW_COUNTERS ARRAY_SIZE(mlx5e_tls_sw_stats_desc)
-
-static bool is_tls_atomic_stats(struct mlx5e_priv *priv)
+static const struct counter_desc *get_tls_atomic_stats(struct mlx5e_priv *priv)
 {
-	return priv->tls && !mlx5_accel_is_ktls_device(priv->mdev);
+	if (!priv->tls)
+		return NULL;
+	if (mlx5_accel_is_ktls_device(priv->mdev))
+		return mlx5e_ktls_sw_stats_desc;
+	return mlx5e_tls_sw_stats_desc;
 }
 
 int mlx5e_tls_get_count(struct mlx5e_priv *priv)
 {
-	if (!is_tls_atomic_stats(priv))
+	if (!priv->tls)
 		return 0;
-
-	return NUM_TLS_SW_COUNTERS;
+	if (mlx5_accel_is_ktls_device(priv->mdev))
+		return ARRAY_SIZE(mlx5e_ktls_sw_stats_desc);
+	return ARRAY_SIZE(mlx5e_tls_sw_stats_desc);
 }
 
 int mlx5e_tls_get_strings(struct mlx5e_priv *priv, uint8_t *data)
 {
-	unsigned int i, idx = 0;
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
 
-	if (!is_tls_atomic_stats(priv))
-		return 0;
+	stats_desc = get_tls_atomic_stats(priv);
+	n = mlx5e_tls_get_count(priv);
 
-	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)
+	for (i = 0; i < n; i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       mlx5e_tls_sw_stats_desc[i].format);
+		       stats_desc[i].format);
 
-	return NUM_TLS_SW_COUNTERS;
+	return n;
 }
 
 int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *data)
 {
-	int i, idx = 0;
+	const struct counter_desc *stats_desc;
+	unsigned int i, n, idx = 0;
 
-	if (!is_tls_atomic_stats(priv))
-		return 0;
+	stats_desc = get_tls_atomic_stats(priv);
+	n = mlx5e_tls_get_count(priv);
 
-	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)
+	for (i = 0; i < n; i++)
 		data[idx++] =
 		    MLX5E_READ_CTR_ATOMIC64(&priv->tls->sw_stats,
-					    mlx5e_tls_sw_stats_desc, i);
+					    stats_desc, i);
 
-	return NUM_TLS_SW_COUNTERS;
+	return n;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 92c5b81427b9..74adaa58189a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -116,7 +116,6 @@ static const struct counter_desc sw_stats_desc[] = {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_bytes) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_bytes) },
@@ -390,7 +389,6 @@ static void mlx5e_stats_grp_sw_update_stats_sq(struct mlx5e_sw_stats *s,
 #ifdef CONFIG_MLX5_EN_TLS
 	s->tx_tls_encrypted_packets += sq_stats->tls_encrypted_packets;
 	s->tx_tls_encrypted_bytes   += sq_stats->tls_encrypted_bytes;
-	s->tx_tls_ctx               += sq_stats->tls_ctx;
 	s->tx_tls_ooo               += sq_stats->tls_ooo;
 	s->tx_tls_dump_bytes        += sq_stats->tls_dump_bytes;
 	s->tx_tls_dump_packets      += sq_stats->tls_dump_packets;
@@ -1650,7 +1648,6 @@ static const struct counter_desc sq_stats_desc[] = {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
-	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
@@ -1776,7 +1773,6 @@ static const struct counter_desc qos_sq_stats_desc[] = {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
-	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 93c41312fb03..8eb056af79ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -191,7 +191,6 @@ struct mlx5e_sw_stats {
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tx_tls_encrypted_packets;
 	u64 tx_tls_encrypted_bytes;
-	u64 tx_tls_ctx;
 	u64 tx_tls_ooo;
 	u64 tx_tls_dump_packets;
 	u64 tx_tls_dump_bytes;
@@ -364,7 +363,6 @@ struct mlx5e_sq_stats {
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_encrypted_packets;
 	u64 tls_encrypted_bytes;
-	u64 tls_ctx;
 	u64 tls_ooo;
 	u64 tls_dump_packets;
 	u64 tls_dump_bytes;
-- 
2.30.2

