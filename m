Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EFA46473D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346973AbhLAGkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbhLAGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7860B81DE0
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A10AC53FD5;
        Wed,  1 Dec 2021 06:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340642;
        bh=lgOE76ZyKC8m301YCkstHaFLj1nvwyYFD7Ai8NFRPoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsOMQ6fnmCStVaZv25arzrKmG/vQJEZFu/Fz+7MUYSkmWHhx7eDSqJY3Idwcn09nG
         PhTfjjshvs8Y4PGrGvHAckzpTYPFo3kOBhq88OIyglceflHKSXMzepr5YA99s0tyZo
         xZTwpnuDjvI9irSwEdya5w4nWKu3DC4jQ+1whqIS0YR/L1fArHKJDn0aG3FETh18hA
         fzY9FXlBIUrECTi77zkNG2vrSHQkwjGKyvGnL2dfhMLBkLyOWH+aBLQaWWq7oeOws1
         2h6jZ5h8mvgjCUpWu1z2jCweomY2UwXE3enmZwiJUkU4zv4IxbE+ogMjtAVFMaLIN0
         4jKo9nteKDB7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/13] net/mlx5e: Sync TIR params updates against concurrent create/modify
Date:   Tue, 30 Nov 2021 22:36:59 -0800
Message-Id: <20211201063709.229103-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Transport Interface Receive (TIR) objects perform the packet processing and
reassembly and is also responsible for demultiplexing the packets into the
different RQs.

There are certain TIR context attributes that propagate to the pointed RQs
and applied to them (like packet_merge offloads (LRO/SHAMPO) and
tunneled_offload_en).  When TIRs do not agree on attributes values, a "last
one wins" policy is applied.  Hence, if not synced properly, a race between
TIR params update and a concurrent TIR create/modify operation might yield
to a mismatch between the shadow parameters in SW and the actual applied
state of the RQs in HW.

tunneled_offload_en is a fixed attribute per profile, while packet merge
offload state might be toggled and get out-of-sync. When this happens,
packet_merge offload might be working although not requested, or the
opposite.

All updates to packet_merge state and all create/modify operations of
regular redirection/steering TIRs are done under the same priv->state_lock,
so they do not run in parallel, and no race is possible.

However, there are other kind of TIRs (acceleration offloads TIRs, like TLS
TIRs) which are created on demand for each new connection without holding
the coarse priv->state_lock, hence might race.

Fix this by synchronizing all packet_merge state reads and writes against
all TIR create/modify operations. Include the modify operations of the
regular redirection steering TIRs under the new lock, for better code
layering and division of responsibilities.

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 41 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |  6 +--
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 24 +----------
 3 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index 142953847996..0015a81eb9a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -13,6 +13,9 @@ struct mlx5e_rx_res {
 	unsigned int max_nch;
 	u32 drop_rqn;
 
+	struct mlx5e_packet_merge_param pkt_merge_param;
+	struct rw_semaphore pkt_merge_param_sem;
+
 	struct mlx5e_rss *rss[MLX5E_MAX_NUM_RSS];
 	bool rss_active;
 	u32 rss_rqns[MLX5E_INDIR_RQT_SIZE];
@@ -392,6 +395,7 @@ static int mlx5e_rx_res_ptp_init(struct mlx5e_rx_res *res)
 	if (err)
 		goto out;
 
+	/* Separated from the channels RQs, does not share pkt_merge state with them */
 	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
 				    mlx5e_rqt_get_rqtn(&res->ptp.rqt),
 				    inner_ft_support);
@@ -447,6 +451,9 @@ int mlx5e_rx_res_init(struct mlx5e_rx_res *res, struct mlx5_core_dev *mdev,
 	res->max_nch = max_nch;
 	res->drop_rqn = drop_rqn;
 
+	res->pkt_merge_param = *init_pkt_merge_param;
+	init_rwsem(&res->pkt_merge_param_sem);
+
 	err = mlx5e_rx_res_rss_init_def(res, init_pkt_merge_param, init_nch);
 	if (err)
 		goto err_out;
@@ -513,7 +520,7 @@ u32 mlx5e_rx_res_get_tirn_ptp(struct mlx5e_rx_res *res)
 	return mlx5e_tir_get_tirn(&res->ptp.tir);
 }
 
-u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix)
+static u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix)
 {
 	return mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt);
 }
@@ -656,6 +663,9 @@ int mlx5e_rx_res_packet_merge_set_param(struct mlx5e_rx_res *res,
 	if (!builder)
 		return -ENOMEM;
 
+	down_write(&res->pkt_merge_param_sem);
+	res->pkt_merge_param = *pkt_merge_param;
+
 	mlx5e_tir_builder_build_packet_merge(builder, pkt_merge_param);
 
 	final_err = 0;
@@ -681,6 +691,7 @@ int mlx5e_rx_res_packet_merge_set_param(struct mlx5e_rx_res *res,
 		}
 	}
 
+	up_write(&res->pkt_merge_param_sem);
 	mlx5e_tir_builder_free(builder);
 	return final_err;
 }
@@ -689,3 +700,31 @@ struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *
 {
 	return mlx5e_rss_get_hash(res->rss[0]);
 }
+
+int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
+				struct mlx5e_tir *tir)
+{
+	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	struct mlx5e_tir_builder *builder;
+	u32 rqtn;
+	int err;
+
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
+	rqtn = mlx5e_rx_res_get_rqtn_direct(res, rxq);
+
+	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn, rqtn,
+				    inner_ft_support);
+	mlx5e_tir_builder_build_direct(builder);
+	mlx5e_tir_builder_build_tls(builder);
+	down_read(&res->pkt_merge_param_sem);
+	mlx5e_tir_builder_build_packet_merge(builder, &res->pkt_merge_param);
+	err = mlx5e_tir_init(tir, builder, res->mdev, false);
+	up_read(&res->pkt_merge_param_sem);
+
+	mlx5e_tir_builder_free(builder);
+
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index d09f7d174a51..b39b20a720e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -37,9 +37,6 @@ u32 mlx5e_rx_res_get_tirn_rss(struct mlx5e_rx_res *res, enum mlx5_traffic_types
 u32 mlx5e_rx_res_get_tirn_rss_inner(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt);
 u32 mlx5e_rx_res_get_tirn_ptp(struct mlx5e_rx_res *res);
 
-/* RQTN getters for modules that create their own TIRs */
-u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix);
-
 /* Activate/deactivate API */
 void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_channels *chs);
 void mlx5e_rx_res_channels_deactivate(struct mlx5e_rx_res *res);
@@ -69,4 +66,7 @@ struct mlx5e_rss *mlx5e_rx_res_rss_get(struct mlx5e_rx_res *res, u32 rss_idx);
 /* Workaround for hairpin */
 struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *res);
 
+/* Accel TIRs */
+int mlx5e_rx_res_tls_tir_create(struct mlx5e_rx_res *res, unsigned int rxq,
+				struct mlx5e_tir *tir);
 #endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index a2a9f68579dd..15711814d2d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -100,25 +100,6 @@ mlx5e_ktls_rx_resync_create_resp_list(void)
 	return resp_list;
 }
 
-static int mlx5e_ktls_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 rqtn)
-{
-	struct mlx5e_tir_builder *builder;
-	int err;
-
-	builder = mlx5e_tir_builder_alloc(false);
-	if (!builder)
-		return -ENOMEM;
-
-	mlx5e_tir_builder_build_rqt(builder, mdev->mlx5e_res.hw_objs.td.tdn, rqtn, false);
-	mlx5e_tir_builder_build_direct(builder);
-	mlx5e_tir_builder_build_tls(builder);
-	err = mlx5e_tir_init(tir, builder, mdev, false);
-
-	mlx5e_tir_builder_free(builder);
-
-	return err;
-}
-
 static void accel_rule_handle_work(struct work_struct *work)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
@@ -609,7 +590,6 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int rxq, err;
-	u32 rqtn;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
@@ -635,9 +615,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rqtn = mlx5e_rx_res_get_rqtn_direct(priv->rx_res, rxq);
-
-	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tir, rqtn);
+	err = mlx5e_rx_res_tls_tir_create(priv->rx_res, rxq, &priv_rx->tir);
 	if (err)
 		goto err_create_tir;
 
-- 
2.31.1

