Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB19747CBA1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242139AbhLVDQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45020 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbhLVDQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBAD617B3
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F31C36AED;
        Wed, 22 Dec 2021 03:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142977;
        bh=pKaZIrnJiNTw31LLDc0BmU72P5hyq91RT7RE49NOgKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/cw21M7maqaz1yVKfnvbcYt4PhJw+E7+BfRHHCnRzQIM8IBeBfxq8NHthKOli45l
         k/XYuh8Ps+AUyqmkUwsvXiA9C9uCMSSnnJM0Qc408yCEXTz4bH7BcmIkoIeNVVHUyR
         U4wcOI+/XnxDNa34Xocp+Cmm3NRDRxtyteyWwnHnHg65SW5zwnLm4XuPo5gaFvuRqb
         JAM7jfnvHKwP4kLw6mT/7WMNJO84Rp78FE5/NdqAVTdybpHTCd1WhgI5IhTb90y3DW
         OViiykiDgGJdXV0vEpAY2yfuidzUbyq84M22OvzP/TWuvmwYsoLggkm3PY2ywxqb7M
         NVTbmTXBDeE3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 11/14] net/mlx5e: Allow profile-specific limitation on max num of channels
Date:   Tue, 21 Dec 2021 19:16:01 -0800
Message-Id: <20211222031604.14540-12-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Let SF/VF representor's netdev use profile-specific limitation on
max_nch to reduce its memory and HW resources consumption.

This is particularly important for environments with limited memory
and high number of SFs.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c  | 18 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c   |  7 +++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 14497b4adc6a..c2812513434a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -972,6 +972,7 @@ struct mlx5e_profile {
 	int	(*update_rx)(struct mlx5e_priv *priv);
 	void	(*update_stats)(struct mlx5e_priv *priv);
 	void	(*update_carrier)(struct mlx5e_priv *priv);
+	int	(*max_nch_limit)(struct mlx5_core_dev *mdev);
 	unsigned int (*stats_grps_num)(struct mlx5e_priv *priv);
 	mlx5e_stats_grp_t *stats_grps;
 	const struct mlx5e_rx_handlers *rx_handlers;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 75984ed262dc..e4a79ba031e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5098,6 +5098,18 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 		BIT(MLX5E_PROFILE_FEATURE_QOS_HTB),
 };
 
+static int mlx5e_profile_max_num_channels(struct mlx5_core_dev *mdev,
+					  const struct mlx5e_profile *profile)
+{
+	int nch;
+
+	nch = mlx5e_get_max_num_channels(mdev);
+
+	if (profile->max_nch_limit)
+		nch = min_t(int, nch, profile->max_nch_limit(mdev));
+	return nch;
+}
+
 static unsigned int
 mlx5e_calc_max_nch(struct mlx5_core_dev *mdev, struct net_device *netdev,
 		   const struct mlx5e_profile *profile)
@@ -5106,7 +5118,7 @@ mlx5e_calc_max_nch(struct mlx5_core_dev *mdev, struct net_device *netdev,
 	unsigned int max_nch, tmp;
 
 	/* core resources */
-	max_nch = mlx5e_get_max_num_channels(mdev);
+	max_nch = mlx5e_profile_max_num_channels(mdev, profile);
 
 	/* netdev rx queues */
 	tmp = netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
@@ -5235,7 +5247,7 @@ static unsigned int mlx5e_get_max_num_txqs(struct mlx5_core_dev *mdev,
 {
 	unsigned int nch, ptp_txqs, qos_txqs;
 
-	nch = mlx5e_get_max_num_channels(mdev);
+	nch = mlx5e_profile_max_num_channels(mdev, profile);
 
 	ptp_txqs = MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn) &&
 		mlx5e_profile_feature_cap(profile, PTP_TX) ?
@@ -5253,7 +5265,7 @@ static unsigned int mlx5e_get_max_num_rxqs(struct mlx5_core_dev *mdev,
 {
 	unsigned int nch;
 
-	nch = mlx5e_get_max_num_channels(mdev);
+	nch = mlx5e_profile_max_num_channels(mdev, profile);
 
 	return nch * profile->rq_groups;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0bd3721c9110..8c0f4cfbe471 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -591,6 +591,12 @@ bool mlx5e_eswitch_vf_rep(const struct net_device *netdev)
 	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
 }
 
+static int mlx5e_rep_max_nch_limit(struct mlx5_core_dev *mdev)
+{
+	return (1 << MLX5_CAP_GEN(mdev, log_max_tir)) /
+		mlx5_eswitch_get_total_vports(mdev);
+}
+
 static void mlx5e_build_rep_params(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -1113,6 +1119,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_rep_stats_grps,
 	.stats_grps_num		= mlx5e_rep_stats_grps_num,
+	.max_nch_limit		= mlx5e_rep_max_nch_limit,
 };
 
 static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
-- 
2.33.1

