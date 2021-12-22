Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C1347CB9F
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbhLVDQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58330 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbhLVDQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B89B81054
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF71C36AEC;
        Wed, 22 Dec 2021 03:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142975;
        bh=sCY6ldRU/uflcyMhByoG1isvH+7GFaenRUENFpDXMqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMU5aUQUkqD7RPccwjv/bi66YTW345Oyv309ZnQqa3Zj1Rkt9d6Fo83OnoFAByfKR
         q1X3pU+y94EplvaMHcM3Fgii1S2VEHYsv6wdH2Cb/VUljdGpSPL9xm/UhJLwKIoo7h
         1XFNFFepPZUPwP5+R3n1KBTpBnmHP9th3OsDmTgDzHvyf27uD8/vT9vEx6NqnOZAwE
         ZkX+pyMPxKHV67RgjkqzC12ksoMnfoZV0GQWTwdPh3teOQUquNcd5iF3PbMONgHUPO
         gkwCnsY8OCPneHyAOsnVaCqDaiW6hYR3OECEoF6wrvfQBSctjqNuA05fTYZ7Uy5Z+q
         UECkXsDlMFYyA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 08/14] net/mlx5e: Use bitmap field for profile features
Date:   Tue, 21 Dec 2021 19:15:58 -0800
Message-Id: <20211222031604.14540-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Use a features bitmap field in mlx5e_profile to declare profile support
state of the different features.  Let it replace the existing
rx_ptp_support boolean. It will be extended to cover more features in a
downstream patch.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h             | 9 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c         | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c         | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    | 1 -
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c   | 1 -
 7 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e77c4159713f..a8fa7f1e5ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -956,6 +956,10 @@ struct mlx5e_rx_handlers {
 
 extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic;
 
+enum mlx5e_profile_feature {
+	MLX5E_PROFILE_FEATURE_PTP_RX,
+};
+
 struct mlx5e_profile {
 	int	(*init)(struct mlx5_core_dev *mdev,
 			struct net_device *netdev);
@@ -974,9 +978,12 @@ struct mlx5e_profile {
 	const struct mlx5e_rx_handlers *rx_handlers;
 	int	max_tc;
 	u8	rq_groups;
-	bool	rx_ptp_support;
+	u32     features;
 };
 
+#define mlx5e_profile_feature_cap(profile, feature)	\
+	((profile)->features & (MLX5E_PROFILE_FEATURE_## feature))
+
 void mlx5e_build_ptys2ethtool_map(void);
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 18d542b1c5cb..82baafd3c00c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -768,7 +768,7 @@ int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ptp_fs *ptp_fs;
 
-	if (!priv->profile->rx_ptp_support)
+	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
 		return 0;
 
 	ptp_fs = kzalloc(sizeof(*ptp_fs), GFP_KERNEL);
@@ -783,7 +783,7 @@ void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
 
-	if (!priv->profile->rx_ptp_support)
+	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
 		return;
 
 	mlx5e_ptp_rx_unset_fs(priv);
@@ -794,7 +794,7 @@ int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set)
 {
 	struct mlx5e_ptp *c = priv->channels.ptp;
 
-	if (!priv->profile->rx_ptp_support)
+	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
 		return 0;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c8757c5a812b..536fcb2c5e90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1934,7 +1934,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (curr_val == new_val)
 		return 0;
 
-	if (new_val && !priv->profile->rx_ptp_support && rx_filter) {
+	if (new_val && !mlx5e_profile_feature_cap(priv->profile, PTP_RX) && rx_filter) {
 		netdev_err(priv->netdev,
 			   "Profile doesn't support enabling of CQE compression while hardware time-stamping is enabled.\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 496977e7406e..6ca2240d7dff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4038,7 +4038,7 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 		goto err_unlock;
 	}
 
-	if (!priv->profile->rx_ptp_support)
+	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
 		err = mlx5e_hwstamp_config_no_ptp_rx(priv,
 						     config.rx_filter != HWTSTAMP_FILTER_NONE);
 	else
@@ -5093,7 +5093,7 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps	   = mlx5e_nic_stats_grps,
 	.stats_grps_num	   = mlx5e_nic_stats_grps_num,
-	.rx_ptp_support    = true,
+	.features          = BIT(MLX5E_PROFILE_FEATURE_PTP_RX),
 };
 
 static unsigned int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6e0f88ea3701..17d27d45a69d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1113,7 +1113,6 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_rep_stats_grps,
 	.stats_grps_num		= mlx5e_rep_stats_grps_num,
-	.rx_ptp_support		= false,
 };
 
 static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
@@ -1134,7 +1133,6 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps		= mlx5e_ul_rep_stats_grps,
 	.stats_grps_num		= mlx5e_ul_rep_stats_grps_num,
-	.rx_ptp_support		= false,
 };
 
 /* e-Switch vport representors */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 051b20ec7bdb..1b082576a63a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -449,7 +449,6 @@ static const struct mlx5e_profile mlx5i_nic_profile = {
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps        = mlx5i_stats_grps,
 	.stats_grps_num    = mlx5i_stats_grps_num,
-	.rx_ptp_support    = false,
 };
 
 /* mlx5i netdev NDos */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 5308f23702bc..0b86e78dbc0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -350,7 +350,6 @@ static const struct mlx5e_profile mlx5i_pkey_nic_profile = {
 	.rx_handlers       = &mlx5i_rx_handlers,
 	.max_tc		   = MLX5I_MAX_NUM_TC,
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
-	.rx_ptp_support	   = false,
 };
 
 const struct mlx5e_profile *mlx5i_pkey_get_profile(void)
-- 
2.33.1

