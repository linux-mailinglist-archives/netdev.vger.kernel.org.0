Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD48B47CBA3
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbhLVDQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242108AbhLVDQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B6CC061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 19:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2628CB81A62
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1F7C36AEA;
        Wed, 22 Dec 2021 03:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142976;
        bh=HbrkfShdag0tMavMpMIUcPa3RqvFwh7vmCz+mvdZoqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3+lu7mosFx+6aOHrmobv09rC2IeHDG9wRXUXYsWIgdVQc5PQxurAuODNF+Ks1DxW
         wAB/2XlMk2guoiBI6rOI1WsYXhDt4UU4uJul1Ilj6Lk66cKsVKuzC8+pwSlvCo+FD4
         RgS9r5QJJNAcBgpIwXVc9fYcVE/Y8rMTIyctLpBb6GWDkrFnTIkr9fj1PIhGvAKivQ
         23tQpw9oAc4y94HAN5szgENIiGxPKwIbtvwu02tqRUU0YtsLOMiCRMHqB3UDgm2Ueh
         J05N0EVx06nQpfvq/FtihnlOvycw+JE3na+WvhQD4RfDlsp1OXGID374k3SwNr8dbQ
         Bfhm0VJZhISuw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 09/14] net/mlx5e: Add profile indications for PTP and QOS HTB features
Date:   Tue, 21 Dec 2021 19:15:59 -0800
Message-Id: <20211222031604.14540-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Let the profile indicate support of the PTP and HTB (QOS) features.
This unifies the logic that calculates the number of netdev queues needed
for the features, and allows simplification of mlx5e_create_netdev(),
which no longer requires number of rx/tx queues as parameters.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 53 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  8 +--
 3 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a8fa7f1e5ce5..ff194c76f1c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -958,6 +958,8 @@ extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic;
 
 enum mlx5e_profile_feature {
 	MLX5E_PROFILE_FEATURE_PTP_RX,
+	MLX5E_PROFILE_FEATURE_PTP_TX,
+	MLX5E_PROFILE_FEATURE_QOS_HTB,
 };
 
 struct mlx5e_profile {
@@ -1195,8 +1197,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    struct mlx5_core_dev *mdev);
 void mlx5e_priv_cleanup(struct mlx5e_priv *priv);
 struct net_device *
-mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
-		    unsigned int txqs, unsigned int rxqs);
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6ca2240d7dff..a0d9a17aa4a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5093,7 +5093,9 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps	   = mlx5e_nic_stats_grps,
 	.stats_grps_num	   = mlx5e_nic_stats_grps_num,
-	.features          = BIT(MLX5E_PROFILE_FEATURE_PTP_RX),
+	.features          = BIT(MLX5E_PROFILE_FEATURE_PTP_RX) |
+		BIT(MLX5E_PROFILE_FEATURE_PTP_TX) |
+		BIT(MLX5E_PROFILE_FEATURE_QOS_HTB),
 };
 
 static unsigned int
@@ -5181,13 +5183,44 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	memset(priv, 0, sizeof(*priv));
 }
 
+static unsigned int mlx5e_get_max_num_txqs(struct mlx5_core_dev *mdev,
+					   const struct mlx5e_profile *profile)
+{
+	unsigned int nch, ptp_txqs, qos_txqs;
+
+	nch = mlx5e_get_max_num_channels(mdev);
+
+	ptp_txqs = MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn) &&
+		mlx5e_profile_feature_cap(profile, PTP_TX) ?
+		profile->max_tc : 0;
+
+	qos_txqs = mlx5_qos_is_supported(mdev) &&
+		mlx5e_profile_feature_cap(profile, QOS_HTB) ?
+		mlx5e_qos_max_leaf_nodes(mdev) : 0;
+
+	return nch * profile->max_tc + ptp_txqs + qos_txqs;
+}
+
+static unsigned int mlx5e_get_max_num_rxqs(struct mlx5_core_dev *mdev,
+					   const struct mlx5e_profile *profile)
+{
+	unsigned int nch;
+
+	nch = mlx5e_get_max_num_channels(mdev);
+
+	return nch * profile->rq_groups;
+}
+
 struct net_device *
-mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
-		    unsigned int txqs, unsigned int rxqs)
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile)
 {
 	struct net_device *netdev;
+	unsigned int txqs, rxqs;
 	int err;
 
+	txqs = mlx5e_get_max_num_txqs(mdev, profile);
+	rxqs = mlx5e_get_max_num_rxqs(mdev, profile);
+
 	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv), txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
@@ -5432,22 +5465,10 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	struct mlx5_core_dev *mdev = edev->mdev;
 	struct net_device *netdev;
 	pm_message_t state = {};
-	unsigned int txqs, rxqs, ptp_txqs = 0;
 	struct mlx5e_priv *priv;
-	int qos_sqs = 0;
 	int err;
-	int nch;
 
-	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
-		ptp_txqs = profile->max_tc;
-
-	if (mlx5_qos_is_supported(mdev))
-		qos_sqs = mlx5e_qos_max_leaf_nodes(mdev);
-
-	nch = mlx5e_get_max_num_channels(mdev);
-	txqs = nch * profile->max_tc + ptp_txqs + qos_sqs;
-	rxqs = nch * profile->rq_groups;
-	netdev = mlx5e_create_netdev(mdev, profile, txqs, rxqs);
+	netdev = mlx5e_create_netdev(mdev, profile);
 	if (!netdev) {
 		mlx5_core_err(mdev, "mlx5e_create_netdev failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 17d27d45a69d..0bd3721c9110 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1183,14 +1183,10 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	struct devlink_port *dl_port;
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
-	unsigned int txqs, rxqs;
-	int nch, err;
+	int err;
 
 	profile = &mlx5e_rep_profile;
-	nch = mlx5e_get_max_num_channels(dev);
-	txqs = nch * profile->max_tc;
-	rxqs = nch * profile->rq_groups;
-	netdev = mlx5e_create_netdev(dev, profile, txqs, rxqs);
+	netdev = mlx5e_create_netdev(dev, profile);
 	if (!netdev) {
 		mlx5_core_warn(dev,
 			       "Failed to create representor netdev for vport %d\n",
-- 
2.33.1

