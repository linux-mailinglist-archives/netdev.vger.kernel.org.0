Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3105134E021
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhC3E2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhC3E1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 222C561985;
        Tue, 30 Mar 2021 04:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078466;
        bh=KIIH9zLXPXd8UGDaMg0jIawxS2398ADeq6PMSELfBls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV09nw1s8K3iCMmhhjvRhj+C3zSX/r1H+cKBf8DOSRWXP9QWaGtSDLn1xmtaJPbEY
         199LK9IsNJ7H4YwCGKprrVLMqqTCz1weCmXUZK+FJO6TL8N9lDmquEl5f+PVwSxNrn
         6bBdlT9TsWFj97o6WvTiKoN2dyPnwAUw3CCnRMn0qsy8Tf0RtrhotggKhnddT9J0mR
         uLIpIia3fS1FnxLKfWUKWgIk1gFcgEJExoSbSta2N+X/e4vNlzLqaZckfELPkmWjH6
         O4vwlKzaNYy/yMYjUYJwSJdOL1Q6YtCscIirCdUzXQ2Y3OKwcN63nyMeID6/Ffugat
         R/ArTaARk/L5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/12] net:mlx5e: Add PTP-TIR and PTP-RQT
Date:   Mon, 29 Mar 2021 21:27:33 -0700
Message-Id: <20210330042741.198601-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add PTP-TIR and initiate its RQT to allow PTP-RQ to integrate into the
safe-reopen flow on configuration change. Add rx_ptp_support flag on a
profile and turn it on for ETH driver. With this flag set, create a
redirect-RQT for PTP-RQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  9 +++++
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 40 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  1 +
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  1 +
 7 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8f6ccd54057a..f31b5ccc27d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -837,6 +837,7 @@ struct mlx5e_priv {
 	struct mlx5e_tir           inner_indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           direct_tir[MLX5E_MAX_NUM_CHANNELS];
 	struct mlx5e_tir           xsk_tir[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_tir           ptp_tir;
 	struct mlx5e_rss_params    rss_params;
 	u32                        tx_rates[MLX5E_MAX_NUM_SQS];
 
@@ -916,6 +917,7 @@ struct mlx5e_profile {
 	const struct mlx5e_rx_handlers *rx_handlers;
 	int	max_tc;
 	u8	rq_groups;
+	bool	rx_ptp_support;
 };
 
 void mlx5e_build_ptys2ethtool_map(void);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 4595d2388d83..c1c41c8656dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -663,3 +663,12 @@ void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
 
 	napi_disable(&c->napi);
 }
+
+int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn)
+{
+	if (!c || !test_bit(MLX5E_PTP_STATE_RX, c->state))
+		return -EINVAL;
+
+	*rqn = c->rq.rqn;
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index cc6a48a43233..460b167887bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -48,6 +48,7 @@ int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
+int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
 
 enum {
 	MLX5E_SKB_CB_CQE_HWTSTAMP  = BIT(0),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7ecde284c57c..7cf12342afe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2329,7 +2329,8 @@ static u32 mlx5e_get_direct_rqn(struct mlx5e_priv *priv, int ix,
 }
 
 static void mlx5e_redirect_rqts(struct mlx5e_priv *priv,
-				struct mlx5e_redirect_rqt_param rrp)
+				struct mlx5e_redirect_rqt_param rrp,
+				struct mlx5e_redirect_rqt_param *ptp_rrp)
 {
 	u32 rqtn;
 	int ix;
@@ -2355,11 +2356,17 @@ static void mlx5e_redirect_rqts(struct mlx5e_priv *priv,
 		rqtn = priv->direct_tir[ix].rqt.rqtn;
 		mlx5e_redirect_rqt(priv, rqtn, 1, direct_rrp);
 	}
+	if (ptp_rrp) {
+		rqtn = priv->ptp_tir.rqt.rqtn;
+		mlx5e_redirect_rqt(priv, rqtn, 1, *ptp_rrp);
+	}
 }
 
 static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 					    struct mlx5e_channels *chs)
 {
+	bool rx_ptp_support = priv->profile->rx_ptp_support;
+	struct mlx5e_redirect_rqt_param *ptp_rrp_p = NULL;
 	struct mlx5e_redirect_rqt_param rrp = {
 		.is_rss        = true,
 		{
@@ -2369,12 +2376,22 @@ static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 			}
 		},
 	};
+	struct mlx5e_redirect_rqt_param ptp_rrp;
+
+	if (rx_ptp_support) {
+		u32 ptp_rqn;
 
-	mlx5e_redirect_rqts(priv, rrp);
+		ptp_rrp.is_rss = false;
+		ptp_rrp.rqn = mlx5e_ptp_get_rqn(priv->channels.ptp, &ptp_rqn) ?
+			      priv->drop_rq.rqn : ptp_rqn;
+		ptp_rrp_p = &ptp_rrp;
+	}
+	mlx5e_redirect_rqts(priv, rrp, ptp_rrp_p);
 }
 
 static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 {
+	bool rx_ptp_support = priv->profile->rx_ptp_support;
 	struct mlx5e_redirect_rqt_param drop_rrp = {
 		.is_rss = false,
 		{
@@ -2382,7 +2399,7 @@ static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 		},
 	};
 
-	mlx5e_redirect_rqts(priv, drop_rrp);
+	mlx5e_redirect_rqts(priv, drop_rrp, rx_ptp_support ? &drop_rrp : NULL);
 }
 
 static const struct mlx5e_tirc_config tirc_default_config[MLX5E_NUM_INDIR_TIRS] = {
@@ -4944,10 +4961,18 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (unlikely(err))
 		goto err_destroy_xsk_rqts;
 
+	err = mlx5e_create_direct_rqts(priv, &priv->ptp_tir, 1);
+	if (err)
+		goto err_destroy_xsk_tirs;
+
+	err = mlx5e_create_direct_tirs(priv, &priv->ptp_tir, 1);
+	if (err)
+		goto err_destroy_ptp_rqt;
+
 	err = mlx5e_create_flow_steering(priv);
 	if (err) {
 		mlx5_core_warn(mdev, "create flow steering failed, %d\n", err);
-		goto err_destroy_xsk_tirs;
+		goto err_destroy_ptp_direct_tir;
 	}
 
 	err = mlx5e_tc_nic_init(priv);
@@ -4968,6 +4993,10 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_tc_nic_cleanup(priv);
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
+err_destroy_ptp_direct_tir:
+	mlx5e_destroy_direct_tirs(priv, &priv->ptp_tir, 1);
+err_destroy_ptp_rqt:
+	mlx5e_destroy_direct_rqts(priv, &priv->ptp_tir, 1);
 err_destroy_xsk_tirs:
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
 err_destroy_xsk_rqts:
@@ -4994,6 +5023,8 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
+	mlx5e_destroy_direct_tirs(priv, &priv->ptp_tir, 1);
+	mlx5e_destroy_direct_rqts(priv, &priv->ptp_tir, 1);
 	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
 	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir, max_nch);
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
@@ -5106,6 +5137,7 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps	   = mlx5e_nic_stats_grps,
 	.stats_grps_num	   = mlx5e_nic_stats_grps_num,
+	.rx_ptp_support    = true,
 };
 
 /* mlx5e generic netdev management API (move to en_common.c) */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b597fc3b192b..9ef8e4a671a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1062,6 +1062,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_rep_stats_grps,
 	.stats_grps_num		= mlx5e_rep_stats_grps_num,
+	.rx_ptp_support		= false,
 };
 
 static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
@@ -1082,6 +1083,7 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps		= mlx5e_ul_rep_stats_grps,
 	.stats_grps_num		= mlx5e_ul_rep_stats_grps_num,
+	.rx_ptp_support		= false,
 };
 
 /* e-Switch vport representors */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 63ca73105149..b65b0cefc5b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -473,6 +473,7 @@ static const struct mlx5e_profile mlx5i_nic_profile = {
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps        = mlx5i_stats_grps,
 	.stats_grps_num    = mlx5i_stats_grps_num,
+	.rx_ptp_support    = false,
 };
 
 /* mlx5i netdev NDos */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 3d0a18a0bed4..18ee21b06a00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -350,6 +350,7 @@ static const struct mlx5e_profile mlx5i_pkey_nic_profile = {
 	.rx_handlers       = &mlx5i_rx_handlers,
 	.max_tc		   = MLX5I_MAX_NUM_TC,
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
+	.rx_ptp_support	   = false,
 };
 
 const struct mlx5e_profile *mlx5i_pkey_get_profile(void)
-- 
2.30.2

