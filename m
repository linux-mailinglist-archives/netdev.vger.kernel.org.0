Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3763508B3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhCaURK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236473AbhCaUQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04734610A6;
        Wed, 31 Mar 2021 20:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221800;
        bh=/opiJTvOqi2AGLe7eiN8WAjMA13fqoaX5BaadaLvVMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1GyTYOlpihA2onFnUaqRU8igkakwWQhcQObqYCcjlsC9zDuDpMe4+BSLb0lOM+hK
         lKjLAy9YSyu/wL2cxzSg0ZAosOnnSwg24mY9Da5O69uNX+FNia2nXHFnSXM38LUIqU
         SSBNh8YTlfMfyZzG0i9eC7PRphwybxfEj8j4vsnw70kl2QXgKROG4fLggkRO5nOOpe
         gPwfOW3nkJoOx5h+ipx2D31uzT9bL8OWCQMZvAqsytv0Xm2gwWFsnBEq09B3gYH5Xg
         B8KcBjVBfN4llN6bZXc6kUEmvjrTceQsaclkh47faRlN15rt7m221gE9Cb5ECcj0tz
         O6Dhv+dVS8TCg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/9] net/mlx5e: kTLS, Fix RX counters atomicity
Date:   Wed, 31 Mar 2021 13:14:21 -0700
Message-Id: <20210331201424.331095-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Some TLS RX counters increment per socket/connection, and are not
protected against parallel modifications from several cores.
Switch them to atomic counters by taking them out of the RQ stats into
the global atomic TLS stats.

In this patch, we touch 'rx_tls_ctx/del' that count the number of
device-offloaded RX TLS connections added/deleted.
These counters are updated in the add/del callbacks, out of the fast
data-path.

This change is not needed for counters that increment only in NAPI
context, as they are protected by the NAPI mechanism.
Keep them as tls_* counters under 'struct mlx5e_rq_stats'.

Fixes: 76c1e1ac2aae ("net/mlx5e: kTLS, Add kTLS RX stats")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 22 ++++++++++---------
 .../mellanox/mlx5/core/en_accel/tls.h         |  2 ++
 .../mellanox/mlx5/core/en_accel/tls_stats.c   |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  6 -----
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  4 ----
 5 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index d06532d0baa4..57c5ebd597a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -46,7 +46,8 @@ struct mlx5e_ktls_offload_context_rx {
 	struct tls12_crypto_info_aes_gcm_128 crypto_info;
 	struct accel_rule rule;
 	struct sock *sk;
-	struct mlx5e_rq_stats *stats;
+	struct mlx5e_rq_stats *rq_stats;
+	struct mlx5e_tls_sw_stats *sw_stats;
 	struct completion add_ctx;
 	u32 tirn;
 	u32 key_id;
@@ -218,7 +219,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
 	return err;
 
 err_out:
-	priv_rx->stats->tls_resync_req_skip++;
+	priv_rx->rq_stats->tls_resync_req_skip++;
 	err = PTR_ERR(cseg);
 	complete(&priv_rx->add_ctx);
 	goto unlock;
@@ -322,7 +323,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 err_free:
 	kfree(buf);
 err_out:
-	priv_rx->stats->tls_resync_req_skip++;
+	priv_rx->rq_stats->tls_resync_req_skip++;
 	return err;
 }
 
@@ -378,13 +379,13 @@ static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx
 
 	cseg = post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg)) {
-		priv_rx->stats->tls_resync_res_skip++;
+		priv_rx->rq_stats->tls_resync_res_skip++;
 		err = PTR_ERR(cseg);
 		goto unlock;
 	}
 	/* Do not increment priv_rx refcnt, CQE handling is empty */
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
-	priv_rx->stats->tls_resync_res_ok++;
+	priv_rx->rq_stats->tls_resync_res_ok++;
 unlock:
 	spin_unlock_bh(&c->async_icosq_lock);
 
@@ -420,13 +421,13 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	auth_state = MLX5_GET(tls_progress_params, ctx, auth_state);
 	if (tracker_state != MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING ||
 	    auth_state != MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD) {
-		priv_rx->stats->tls_resync_req_skip++;
+		priv_rx->rq_stats->tls_resync_req_skip++;
 		goto out;
 	}
 
 	hw_seq = MLX5_GET(tls_progress_params, ctx, hw_resync_tcp_sn);
 	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
-	priv_rx->stats->tls_resync_req_end++;
+	priv_rx->rq_stats->tls_resync_req_end++;
 out:
 	mlx5e_ktls_priv_rx_put(priv_rx);
 	dma_unmap_single(dev, buf->dma_addr, PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
@@ -609,7 +610,8 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
 
-	priv_rx->stats = &priv->channel_stats[rxq].rq;
+	priv_rx->rq_stats = &priv->channel_stats[rxq].rq;
+	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
 	rqtn = priv->direct_tir[rxq].rqt.rqtn;
@@ -630,7 +632,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (err)
 		goto err_post_wqes;
 
-	priv_rx->stats->tls_ctx++;
+	atomic64_inc(&priv_rx->sw_stats->rx_tls_ctx);
 
 	return 0;
 
@@ -666,7 +668,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	if (cancel_work_sync(&resync->work))
 		mlx5e_ktls_priv_rx_put(priv_rx);
 
-	priv_rx->stats->tls_del++;
+	atomic64_inc(&priv_rx->sw_stats->rx_tls_del);
 	if (priv_rx->rule.rule)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 5b408904df14..4c9274d390da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -46,6 +46,8 @@ struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_drop_resync_alloc;
 	atomic64_t tx_tls_drop_no_sync_data;
 	atomic64_t tx_tls_drop_bypass_required;
+	atomic64_t rx_tls_ctx;
+	atomic64_t rx_tls_del;
 	atomic64_t rx_tls_drop_resync_request;
 	atomic64_t rx_tls_resync_request;
 	atomic64_t rx_tls_resync_reply;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
index a5aabc5c5236..29463bdb7715 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -47,6 +47,8 @@ static const struct counter_desc mlx5e_tls_sw_stats_desc[] = {
 
 static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_ctx) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_del) },
 };
 
 #define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 74adaa58189a..88a01c59ce61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -179,8 +179,6 @@ static const struct counter_desc sw_stats_desc[] = {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_ctx) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_del) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_pkt) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_start) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_end) },
@@ -341,8 +339,6 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 #ifdef CONFIG_MLX5_EN_TLS
 	s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
 	s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
-	s->rx_tls_ctx                 += rq_stats->tls_ctx;
-	s->rx_tls_del                 += rq_stats->tls_del;
 	s->rx_tls_resync_req_pkt      += rq_stats->tls_resync_req_pkt;
 	s->rx_tls_resync_req_start    += rq_stats->tls_resync_req_start;
 	s->rx_tls_resync_req_end      += rq_stats->tls_resync_req_end;
@@ -1620,8 +1616,6 @@ static const struct counter_desc rq_stats_desc[] = {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_bytes) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_ctx) },
-	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_del) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_pkt) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_start) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_end) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 8eb056af79ba..adf9b7b8b712 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -201,8 +201,6 @@ struct mlx5e_sw_stats {
 
 	u64 rx_tls_decrypted_packets;
 	u64 rx_tls_decrypted_bytes;
-	u64 rx_tls_ctx;
-	u64 rx_tls_del;
 	u64 rx_tls_resync_req_pkt;
 	u64 rx_tls_resync_req_start;
 	u64 rx_tls_resync_req_end;
@@ -333,8 +331,6 @@ struct mlx5e_rq_stats {
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_decrypted_packets;
 	u64 tls_decrypted_bytes;
-	u64 tls_ctx;
-	u64 tls_del;
 	u64 tls_resync_req_pkt;
 	u64 tls_resync_req_start;
 	u64 tls_resync_req_end;
-- 
2.30.2

