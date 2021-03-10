Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B033477B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhCJTE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhCJTD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E848C64F9F;
        Wed, 10 Mar 2021 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403039;
        bh=20srfg38HVwL0+40YLCNsoAfIjEGBeM7X/JZggOwUYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Od/g+xQNht6M+960IGeyWRek9KgOhocBnDc3PU9gYVncOa1SKmryTWyq4N2H6qoAW
         9PiFs3XxOY6/OPogRXJbmtlhsHkKpRT/J1BRjlgvXcsr8aJTfdEqjQVN26N7oPPqi+
         u5ejEYGqbrHSzW5bCEGeYdne0zt7ITPJ+LfRK2vdfMCN/SB33NyAOShm84KF4NGltB
         qz6xOHaHBiStFpQuqd/vf9E6jG7DP9clxcIX1N9GfCB4Hwq8tWHyPOoV32PQfYqTHJ
         t6XeUwZlXwXOmM6zTlLAT2n2Jb7WmtbgV5uUGj3OFSwx/JUP4U7CSUL8u6CmcNDtpU
         xncNB71VXmbBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/18] net/mlx5e: Fix error flow in change profile
Date:   Wed, 10 Mar 2021 11:03:35 -0800
Message-Id: <20210310190342.238957-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move priv memset from init to cleanup to avoid double priv cleanup
that can happen on profile change if also roolback fails.
Add missing cleanup flow in mlx5e_netdev_attach_profile().

Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 41 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  3 +-
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6b761fb8d269..33b418796e43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5488,8 +5488,6 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    struct net_device *netdev,
 		    struct mlx5_core_dev *mdev)
 {
-	memset(priv, 0, sizeof(*priv));
-
 	/* priv init */
 	priv->mdev        = mdev;
 	priv->netdev      = netdev;
@@ -5522,12 +5520,18 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 {
 	int i;
 
+	/* bail if change profile failed and also rollback failed */
+	if (!priv->mdev)
+		return;
+
 	destroy_workqueue(priv->wq);
 	free_cpumask_var(priv->scratchpad.cpumask);
 
 	for (i = 0; i < priv->htb.max_qos_sqs; i++)
 		kfree(priv->htb.qos_sq_stats[i]);
 	kvfree(priv->htb.qos_sq_stats);
+
+	memset(priv, 0, sizeof(*priv));
 }
 
 struct net_device *
@@ -5644,11 +5648,10 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 }
 
 static int
-mlx5e_netdev_attach_profile(struct mlx5e_priv *priv,
+mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mdev,
 			    const struct mlx5e_profile *new_profile, void *new_ppriv)
 {
-	struct net_device *netdev = priv->netdev;
-	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
 	err = mlx5e_priv_init(priv, netdev, mdev);
@@ -5661,10 +5664,16 @@ mlx5e_netdev_attach_profile(struct mlx5e_priv *priv,
 	priv->ppriv = new_ppriv;
 	err = new_profile->init(priv->mdev, priv->netdev);
 	if (err)
-		return err;
+		goto priv_cleanup;
 	err = mlx5e_attach_netdev(priv);
 	if (err)
-		new_profile->cleanup(priv);
+		goto profile_cleanup;
+	return err;
+
+profile_cleanup:
+	new_profile->cleanup(priv);
+priv_cleanup:
+	mlx5e_priv_cleanup(priv);
 	return err;
 }
 
@@ -5673,13 +5682,14 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 {
 	unsigned int new_max_nch = mlx5e_calc_max_nch(priv, new_profile);
 	const struct mlx5e_profile *orig_profile = priv->profile;
+	struct net_device *netdev = priv->netdev;
+	struct mlx5_core_dev *mdev = priv->mdev;
 	void *orig_ppriv = priv->ppriv;
 	int err, rollback_err;
 
 	/* sanity */
 	if (new_max_nch != priv->max_nch) {
-		netdev_warn(priv->netdev,
-			    "%s: Replacing profile with different max channels\n",
+		netdev_warn(netdev, "%s: Replacing profile with different max channels\n",
 			    __func__);
 		return -EINVAL;
 	}
@@ -5689,22 +5699,19 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 	priv->profile->cleanup(priv);
 	mlx5e_priv_cleanup(priv);
 
-	err = mlx5e_netdev_attach_profile(priv, new_profile, new_ppriv);
+	err = mlx5e_netdev_attach_profile(netdev, mdev, new_profile, new_ppriv);
 	if (err) { /* roll back to original profile */
-		netdev_warn(priv->netdev, "%s: new profile init failed, %d\n",
-			    __func__, err);
+		netdev_warn(netdev, "%s: new profile init failed, %d\n", __func__, err);
 		goto rollback;
 	}
 
 	return 0;
 
 rollback:
-	rollback_err = mlx5e_netdev_attach_profile(priv, orig_profile, orig_ppriv);
-	if (rollback_err) {
-		netdev_err(priv->netdev,
-			   "%s: failed to rollback to orig profile, %d\n",
+	rollback_err = mlx5e_netdev_attach_profile(netdev, mdev, orig_profile, orig_ppriv);
+	if (rollback_err)
+		netdev_err(netdev, "%s: failed to rollback to orig profile, %d\n",
 			   __func__, rollback_err);
-	}
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1eeca45cfcdf..756fa0401ab7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -694,6 +694,7 @@ static int mlx5i_check_required_hca_cap(struct mlx5_core_dev *mdev)
 static void mlx5_rdma_netdev_free(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
+	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5i_priv *ipriv = priv->ppriv;
 	const struct mlx5e_profile *profile = priv->profile;
 
@@ -702,7 +703,7 @@ static void mlx5_rdma_netdev_free(struct net_device *netdev)
 
 	if (!ipriv->sub_interface) {
 		mlx5i_pkey_qpn_ht_cleanup(netdev);
-		mlx5e_destroy_mdev_resources(priv->mdev);
+		mlx5e_destroy_mdev_resources(mdev);
 	}
 }
 
-- 
2.29.2

