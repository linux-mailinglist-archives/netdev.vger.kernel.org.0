Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC309362814
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhDPSzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236188AbhDPSzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7A1613CB;
        Fri, 16 Apr 2021 18:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599282;
        bh=viFF/s+Zq56omfwPzKGELo6xcLiqsyRpkJHNGDiF6bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKIe69Jwr+6kNj1Kk91DPP0vAhA9jcDw8anM/nZm8U5Ovfxlray7HHNvUfW51rC9N
         sMocHOCZHM3k16/4faMbjDzB4zgvATk1hl9INXReX7iMUPmZynWb8cAeaz6d/lGzHE
         8yMjmBCdGrLOx3trG7L2opLwlljCF1DmCBcoMX0wSoLtUGHG5Pdo00zGJ8fGGaAn3E
         htR+RMcbhlxM5GCDIp6C+m9KqjrRPA1/mPZqj/yIzgG38C8riraA/zCyyRPC/NdUF+
         fgjdUC9FkLKg95Sb7B8Ur8pVUa6rW5PSmKNQJ4KzaxHhJgr6KwAcRDPPWEOOMVONxr
         KYNg0xIQvCiXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/14] net/mlx5e: kTLS, Add resiliency to RX resync failures
Date:   Fri, 16 Apr 2021 11:54:21 -0700
Message-Id: <20210416185430.62584-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

When the TLS logic finds a tcp seq match for a kTLS RX resync
request, it calls the driver callback function mlx5e_ktls_resync()
to handle it and communicate it to the device.

Errors might occur during mlx5e_ktls_resync(), however, they are not
reported to the stack. Moreover, there is no error handling in the
stack for these errors.

In this patch, the driver obtains responsibility on errors handling,
adding queue and retry mechanisms to these resyncs.

We maintain a linked list of resync matches, and try posting them
to the async ICOSQ in the NAPI context.

Only possible failure that demands driver handling is ICOSQ being full.
By relying on the NAPI mechanism, we make sure that the entries in list
will be handled when ICOSQ completions arrive and make some room
available.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |   3 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ktls.h        |  11 ++
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 124 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  20 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   3 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   5 +
 10 files changed, 166 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index cb4e7aaa4f8a..28a68eef8ae6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -327,6 +327,7 @@ enum {
 	MLX5E_SQ_STATE_AM,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
+	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
 };
 
 struct mlx5e_tx_mpwqe {
@@ -499,6 +500,8 @@ struct mlx5e_xdpsq {
 	struct mlx5e_channel      *channel;
 } ____cacheline_aligned_in_smp;
 
+struct mlx5e_ktls_resync_resp;
+
 struct mlx5e_icosq {
 	/* data path */
 	u16                        cc;
@@ -518,6 +521,7 @@ struct mlx5e_icosq {
 	u32                        sqn;
 	u16                        reserved_room;
 	unsigned long              state;
+	struct mlx5e_ktls_resync_resp *ktls_resync;
 
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 7b2b52e75222..f6ba568e00be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -621,6 +621,9 @@ static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 
 	mlx5e_build_sq_param_common(mdev, param);
 	param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
+	param->is_tls = mlx5_accel_is_ktls_rx(mdev);
+	if (param->is_tls)
+		param->stop_room += mlx5e_stop_room_for_wqe(1); /* for TLS RX resync NOP */
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
 	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
 	mlx5e_build_ico_cq_param(mdev, log_wq_size, &param->cqp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 602e41a2bddd..fcc51ec6084e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -30,6 +30,7 @@ struct mlx5e_sq_param {
 	u32                        sqc[MLX5_ST_SZ_DW(sqc)];
 	struct mlx5_wq_param       wq;
 	bool                       is_mpw;
+	bool                       is_tls;
 	u16                        stop_room;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index baa58b62e8df..aaa579bf9a39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -12,6 +12,9 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
 int mlx5e_ktls_init_rx(struct mlx5e_priv *priv);
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv);
 int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable);
+struct mlx5e_ktls_resync_resp *
+mlx5e_ktls_rx_resync_create_resp_list(void);
+void mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list);
 #else
 
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
@@ -33,6 +36,14 @@ static inline int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enab
 	return -EOPNOTSUPP;
 }
 
+static inline struct mlx5e_ktls_resync_resp *
+mlx5e_ktls_rx_resync_create_resp_list(void)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void
+mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list) {}
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 76fd4b230003..4e58fade7a60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -56,6 +56,7 @@ struct mlx5e_ktls_offload_context_rx {
 
 	/* resync */
 	struct mlx5e_ktls_rx_resync_ctx resync;
+	struct list_head list;
 };
 
 static bool mlx5e_ktls_priv_rx_put(struct mlx5e_ktls_offload_context_rx *priv_rx)
@@ -72,6 +73,32 @@ static void mlx5e_ktls_priv_rx_get(struct mlx5e_ktls_offload_context_rx *priv_rx
 	refcount_inc(&priv_rx->resync.refcnt);
 }
 
+struct mlx5e_ktls_resync_resp {
+	/* protects list changes */
+	spinlock_t lock;
+	struct list_head list;
+};
+
+void mlx5e_ktls_rx_resync_destroy_resp_list(struct mlx5e_ktls_resync_resp *resp_list)
+{
+	kvfree(resp_list);
+}
+
+struct mlx5e_ktls_resync_resp *
+mlx5e_ktls_rx_resync_create_resp_list(void)
+{
+	struct mlx5e_ktls_resync_resp *resp_list;
+
+	resp_list = kvzalloc(sizeof(*resp_list), GFP_KERNEL);
+	if (!resp_list)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&resp_list->list);
+	spin_lock_init(&resp_list->lock);
+
+	return resp_list;
+}
+
 static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, u32 *tirn, u32 rqtn)
 {
 	int err, inlen;
@@ -358,33 +385,32 @@ static void resync_init(struct mlx5e_ktls_rx_resync_ctx *resync,
 /* Function can be called with the refcount being either elevated or not.
  * It does not affect the refcount.
  */
-static int resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx,
-				   struct mlx5e_channel *c)
+static void resync_handle_seq_match(struct mlx5e_ktls_offload_context_rx *priv_rx,
+				    struct mlx5e_channel *c)
 {
 	struct tls12_crypto_info_aes_gcm_128 *info = &priv_rx->crypto_info;
-	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_ktls_resync_resp *ktls_resync;
 	struct mlx5e_icosq *sq;
-	int err;
+	bool trigger_poll;
 
 	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
-	err = 0;
 
 	sq = &c->async_icosq;
-	spin_lock_bh(&c->async_icosq_lock);
+	ktls_resync = sq->ktls_resync;
 
-	cseg = post_static_params(sq, priv_rx);
-	if (IS_ERR(cseg)) {
-		priv_rx->rq_stats->tls_resync_res_skip++;
-		err = PTR_ERR(cseg);
-		goto unlock;
-	}
-	/* Do not increment priv_rx refcnt, CQE handling is empty */
-	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
-	priv_rx->rq_stats->tls_resync_res_ok++;
-unlock:
-	spin_unlock_bh(&c->async_icosq_lock);
+	spin_lock_bh(&ktls_resync->lock);
+	list_add_tail(&priv_rx->list, &ktls_resync->list);
+	trigger_poll = !test_and_set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	spin_unlock_bh(&ktls_resync->lock);
 
-	return err;
+	if (!trigger_poll)
+		return;
+
+	if (!napi_if_scheduled_mark_missed(&c->napi)) {
+		spin_lock_bh(&c->async_icosq_lock);
+		mlx5e_trigger_irq(sq);
+		spin_unlock_bh(&c->async_icosq_lock);
+	}
 }
 
 /* Function can be called with the refcount being either elevated or not.
@@ -675,3 +701,65 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	 */
 	mlx5e_ktls_priv_rx_put(priv_rx);
 }
+
+bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
+{
+	struct mlx5e_ktls_offload_context_rx *priv_rx, *tmp;
+	struct mlx5e_ktls_resync_resp *ktls_resync;
+	struct mlx5_wqe_ctrl_seg *db_cseg;
+	struct mlx5e_icosq *sq;
+	LIST_HEAD(local_list);
+	int i, j;
+
+	sq = &c->async_icosq;
+
+	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
+		return false;
+
+	ktls_resync = sq->ktls_resync;
+	db_cseg = NULL;
+	i = 0;
+
+	spin_lock(&ktls_resync->lock);
+	list_for_each_entry_safe(priv_rx, tmp, &ktls_resync->list, list) {
+		list_move(&priv_rx->list, &local_list);
+		if (++i == budget)
+			break;
+	}
+	if (list_empty(&ktls_resync->list))
+		clear_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+	spin_unlock(&ktls_resync->lock);
+
+	spin_lock(&c->async_icosq_lock);
+	for (j = 0; j < i; j++) {
+		struct mlx5_wqe_ctrl_seg *cseg;
+
+		priv_rx = list_first_entry(&local_list,
+					   struct mlx5e_ktls_offload_context_rx,
+					   list);
+		cseg = post_static_params(sq, priv_rx);
+		if (IS_ERR(cseg))
+			break;
+		list_del(&priv_rx->list);
+		db_cseg = cseg;
+	}
+	if (db_cseg)
+		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, db_cseg);
+	spin_unlock(&c->async_icosq_lock);
+
+	priv_rx->rq_stats->tls_resync_res_ok += j;
+
+	if (!list_empty(&local_list)) {
+		/* This happens only if ICOSQ is full.
+		 * There is no need to mark busy or explicitly ask for a NAPI cycle,
+		 * it will be triggered by the outstanding ICOSQ completions.
+		 */
+		spin_lock(&ktls_resync->lock);
+		list_splice(&local_list, &ktls_resync->list);
+		set_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &sq->state);
+		spin_unlock(&ktls_resync->lock);
+		priv_rx->rq_stats->tls_resync_res_retry++;
+	}
+
+	return i == budget;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index ee04e916fa21..8f79335057dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -40,6 +40,14 @@ mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	}
 	return false;
 }
+
+bool mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget);
+
+static inline bool
+mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
+{
+	return budget && test_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &c->async_icosq.state);
+}
 #else
 static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
@@ -49,6 +57,18 @@ mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	return false;
 }
 
+static inline bool
+mlx5e_ktls_rx_handle_resync_list(struct mlx5e_channel *c, int budget)
+{
+	return false;
+}
+
+static inline bool
+mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
+{
+	return false;
+}
+
 #endif /* CONFIG_MLX5_EN_TLS */
 
 #endif /* __MLX5E_TLS_TXRX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 64d6c0fd92bf..df4959e46f27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1409,8 +1409,17 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	if (err)
 		goto err_free_icosq;
 
+	if (param->is_tls) {
+		sq->ktls_resync = mlx5e_ktls_rx_resync_create_resp_list();
+		if (IS_ERR(sq->ktls_resync)) {
+			err = PTR_ERR(sq->ktls_resync);
+			goto err_destroy_icosq;
+		}
+	}
 	return 0;
 
+err_destroy_icosq:
+	mlx5e_destroy_sq(c->mdev, sq->sqn);
 err_free_icosq:
 	mlx5e_free_icosq(sq);
 
@@ -1432,6 +1441,8 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 {
 	struct mlx5e_channel *c = sq->channel;
 
+	if (sq->ktls_resync)
+		mlx5e_ktls_rx_resync_destroy_resp_list(sq->ktls_resync);
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_icosq_descs(sq);
 	mlx5e_free_icosq(sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 353513bd0d5e..5146aa200de9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -184,6 +184,7 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_end) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_req_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_ok) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_retry) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
 #endif
@@ -344,6 +345,7 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_tls_resync_req_end      += rq_stats->tls_resync_req_end;
 	s->rx_tls_resync_req_skip     += rq_stats->tls_resync_req_skip;
 	s->rx_tls_resync_res_ok       += rq_stats->tls_resync_res_ok;
+	s->rx_tls_resync_res_retry    += rq_stats->tls_resync_res_retry;
 	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
 	s->rx_tls_err                 += rq_stats->tls_err;
 #endif
@@ -1654,6 +1656,7 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_end) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_req_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_ok) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_retry) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 3f0789e51eed..9614de49b7ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -209,6 +209,7 @@ struct mlx5e_sw_stats {
 	u64 rx_tls_resync_req_end;
 	u64 rx_tls_resync_req_skip;
 	u64 rx_tls_resync_res_ok;
+	u64 rx_tls_resync_res_retry;
 	u64 rx_tls_resync_res_skip;
 	u64 rx_tls_err;
 #endif
@@ -339,6 +340,7 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_req_end;
 	u64 tls_resync_req_skip;
 	u64 tls_resync_res_ok;
+	u64 tls_resync_res_retry;
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index d54da3797c30..833be29170a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -36,6 +36,7 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
+#include "en_accel/ktls_txrx.h"
 
 static inline bool mlx5e_channel_no_affinity_change(struct mlx5e_channel *c)
 {
@@ -171,6 +172,10 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		 */
 		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
 
+	/* Keep after async ICOSQ CQ poll */
+	if (unlikely(mlx5e_ktls_rx_pending_resync_list(c, budget)))
+		busy |= mlx5e_ktls_rx_handle_resync_list(c, budget);
+
 	busy |= INDIRECT_CALL_2(rq->post_wqes,
 				mlx5e_post_rx_mpwqes,
 				mlx5e_post_rx_wqes,
-- 
2.30.2

