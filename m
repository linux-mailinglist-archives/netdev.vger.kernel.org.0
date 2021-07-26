Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618553D650D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbhGZQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241918AbhGZQQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9467960F9F;
        Mon, 26 Jul 2021 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318560;
        bh=mB63Llru9Z0KEguyfIYyrqUYPQeYPIERidqMBH3p6do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9/nwZNB1IHe4ymz65kPXYWLdPZk1+JGwJ57V0kDz8U+D+J0/MY03w5dvMmQocGu9
         Fmyr+HW3XsHqfReh1qZ43gXT00/eZ7uzcFYlAttcBG8/0A//uPQyzCjhs9Zmm0LDmk
         xIUbvgRzMv0MZ4magiOtTYY3rvTmqkOaHnEjCo5klUJh/s9nBFxT5OTr9MYTnnsmnm
         L22BwXQgkfGSoKTtfkadI1hBeTc+twQaYdgKLdYrYztTusU1+k9TmGtpgrTY3Cwsnz
         OT6hKZq/LmVl2/tZMnBtzNh15EUaKh9W6I3PmBYUuywyma7nzWo1kzrS5iHNR2l/oq
         8EjwdlrbXvhLA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5e: Use the new TIR API for kTLS
Date:   Mon, 26 Jul 2021 09:55:44 -0700
Message-Id: <20210726165544.389143-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

One of the previous commits introduced a dedicated object for a TIR.
kTLS code creates a TIR per connection using the low-level mlx5_core
API. This commit converts it to the new mlx5e_tir API.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tir.c  | 12 +++++
 .../net/ethernet/mellanox/mlx5/core/en/tir.h  |  1 +
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 51 ++++++++-----------
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index 3ec94da45d36..de936dc4bc48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -140,6 +140,18 @@ void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder)
 	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
 }
 
+void mlx5e_tir_builder_build_tls(struct mlx5e_tir_builder *builder)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+
+	WARN_ON(builder->modify);
+
+	MLX5_SET(tirc, tirc, tls_en, 1);
+	MLX5_SET(tirc, tirc, self_lb_block,
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST |
+		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST);
+}
+
 int mlx5e_tir_init(struct mlx5e_tir *tir, struct mlx5e_tir_builder *builder,
 		   struct mlx5_core_dev *mdev, bool reg)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
index 25b8a2edf6cc..e45149a78ed9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
@@ -34,6 +34,7 @@ void mlx5e_tir_builder_build_rss(struct mlx5e_tir_builder *builder,
 				 const struct mlx5e_rss_params_traffic_type *rss_tt,
 				 bool inner);
 void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder);
+void mlx5e_tir_builder_build_tls(struct mlx5e_tir_builder *builder);
 
 struct mlx5_core_dev;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 44bc6efd62fd..bfdbc3060755 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -49,7 +49,7 @@ struct mlx5e_ktls_offload_context_rx {
 	struct mlx5e_rq_stats *rq_stats;
 	struct mlx5e_tls_sw_stats *sw_stats;
 	struct completion add_ctx;
-	u32 tirn;
+	struct mlx5e_tir tir;
 	u32 key_id;
 	u32 rxq;
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
@@ -99,31 +99,22 @@ mlx5e_ktls_rx_resync_create_resp_list(void)
 	return resp_list;
 }
 
-static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
+static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 rqtn)
 {
-	int err, inlen;
-	void *tirc;
-	u32 *in;
+	struct mlx5e_tir_builder *builder;
+	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
 		return -ENOMEM;
 
-	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-
-	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
-	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
-	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
-	MLX5_SET(tirc, tirc, indirect_table, rqtn);
-	MLX5_SET(tirc, tirc, tls_en, 1);
-	MLX5_SET(tirc, tirc, self_lb_block,
-		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST |
-		 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST);
+	mlx5e_tir_builder_build_rqt(builder, mdev->mlx5e_res.hw_objs.td.tdn, rqtn, false);
+	mlx5e_tir_builder_build_direct(builder);
+	mlx5e_tir_builder_build_tls(builder);
+	err = mlx5e_tir_init(tir, builder, mdev, false);
 
-	err = mlx5_core_create_tir(mdev, in, tirn);
+	mlx5e_tir_builder_free(builder);
 
-	kvfree(in);
 	return err;
 }
 
@@ -139,7 +130,8 @@ static void accel_rule_handle_work(struct work_struct *work)
 		goto out;
 
 	rule = mlx5e_accel_fs_add_sk(accel_rule->priv, priv_rx->sk,
-				     priv_rx->tirn, MLX5_FS_DEFAULT_FLOW_TAG);
+				     mlx5e_tir_get_tirn(&priv_rx->tir),
+				     MLX5_FS_DEFAULT_FLOW_TAG);
 	if (!IS_ERR_OR_NULL(rule))
 		accel_rule->rule = rule;
 out:
@@ -173,8 +165,8 @@ post_static_params(struct mlx5e_icosq *sq,
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
-				       priv_rx->tirn, priv_rx->key_id,
-				       priv_rx->resync.seq, false,
+				       mlx5e_tir_get_tirn(&priv_rx->tir),
+				       priv_rx->key_id, priv_rx->resync.seq, false,
 				       TLS_OFFLOAD_CTX_DIR_RX);
 	wi = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type = MLX5E_ICOSQ_WQE_UMR_TLS,
@@ -202,8 +194,9 @@ post_progress_params(struct mlx5e_icosq *sq,
 
 	pi = mlx5e_icosq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_PROGRESS_PARAMS_WQE(sq, pi);
-	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn, priv_rx->tirn, false,
-					 next_record_tcp_sn,
+	mlx5e_ktls_build_progress_params(wqe, sq->pc, sq->sqn,
+					 mlx5e_tir_get_tirn(&priv_rx->tir),
+					 false, next_record_tcp_sn,
 					 TLS_OFFLOAD_CTX_DIR_RX);
 	wi = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_TLS,
@@ -325,7 +318,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	psv = &wqe->psv;
 	psv->num_psv      = 1 << 4;
 	psv->l_key        = sq->channel->mkey_be;
-	psv->psv_index[0] = cpu_to_be32(priv_rx->tirn);
+	psv->psv_index[0] = cpu_to_be32(mlx5e_tir_get_tirn(&priv_rx->tir));
 	psv->va           = cpu_to_be64(buf->dma_addr);
 
 	wi = (struct mlx5e_icosq_wqe_info) {
@@ -637,7 +630,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 
 	rqtn = mlx5e_rqt_get_rqtn(&priv->rx_res->channels[rxq].direct_rqt);
 
-	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
+	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tir, rqtn);
 	if (err)
 		goto err_create_tir;
 
@@ -658,7 +651,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	return 0;
 
 err_post_wqes:
-	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
+	mlx5e_tir_destroy(&priv_rx->tir);
 err_create_tir:
 	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
 err_create_key:
@@ -693,7 +686,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
-	mlx5_core_destroy_tir(mdev, priv_rx->tirn);
+	mlx5e_tir_destroy(&priv_rx->tir);
 	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
 	/* priv_rx should normally be freed here, but if there is an outstanding
 	 * GET_PSV, deallocation will be delayed until the CQE for GET_PSV is
-- 
2.31.1

