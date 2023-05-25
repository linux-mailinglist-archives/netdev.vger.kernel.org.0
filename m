Return-Path: <netdev+bounces-5211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2B9710381
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 253F6280351
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FE5A937;
	Thu, 25 May 2023 03:49:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEECE8825
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A24BC4339B;
	Thu, 25 May 2023 03:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986557;
	bh=mfVsIAiBbb6JCeszFd/p43A4jnpLc7felSMbWt5Xq+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCMc/CDBwtE5mG9qGqTx9sOZ5znCeI7gejNIEVeS15FTDPGEz0EYKE8AqZx3lZ1m4
	 +8eXx4ITbz4tOXLvQtnW207S+tqEIHRfsdaQJcIrWppcGSZ/q1cKvjQPkL6t0Ip0Va
	 Iy8rJgp4/7yLVxGYDW+mHzZ1oOq3HmKdPat4c85otIgSeAQGR7uginCCjPJQg3CJVE
	 WrDyLvD2acJmr+CNa1JpBTcyFIBfB9YDKKnejMeG7DJpcIqOpeQ7stD2ykSpmP0U85
	 lv72jXaBkz6Xa+y7AsMrDHVtHtN1BauFA3bnqERCr9Ma5srym9zEY/OxQj0ymsB8Jt
	 SBvieFyVHrkzA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>
Subject: [net 11/17] net/mlx5e: Move Ethernet driver debugfs to profile init callback
Date: Wed, 24 May 2023 20:48:41 -0700
Message-Id: <20230525034847.99268-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianbo Liu <jianbol@nvidia.com>

As priv->dfs_root is cleared, and therefore missed, when change
eswitch mode, move the creation of the root debugfs to the init
callback of mlx5e_nic_profile and mlx5e_uplink_rep_profile, and
the destruction to the cleanup callback for symmeter.

Fixes: 288eca60cc31 ("net/mlx5e: Add Ethernet driver debugfs")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |  6 ++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a07bbe9a61be..a7c526ee5024 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5261,12 +5261,16 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 
 	mlx5e_timestamp_init(priv);
 
+	priv->dfs_root = debugfs_create_dir("nic",
+					    mlx5_debugfs_get_dev_root(mdev));
+
 	fs = mlx5e_fs_init(priv->profile, mdev,
 			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
 			   priv->dfs_root);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
+		debugfs_remove_recursive(priv->dfs_root);
 		return err;
 	}
 	priv->fs = fs;
@@ -5287,6 +5291,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
+	debugfs_remove_recursive(priv->dfs_root);
 	priv->fs = NULL;
 }
 
@@ -6011,9 +6016,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	priv->profile = profile;
 	priv->ppriv = NULL;
 
-	priv->dfs_root = debugfs_create_dir("nic",
-					    mlx5_debugfs_get_dev_root(priv->mdev));
-
 	err = profile->init(mdev, netdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_nic_profile init failed, %d\n", err);
@@ -6042,7 +6044,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 err_profile_cleanup:
 	profile->cleanup(priv);
 err_destroy_netdev:
-	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
 err_devlink_port_unregister:
 	mlx5e_devlink_port_unregister(mlx5e_dev);
@@ -6062,7 +6063,6 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
 	priv->profile->cleanup(priv);
-	debugfs_remove_recursive(priv->dfs_root);
 	mlx5e_destroy_netdev(priv);
 	mlx5e_devlink_port_unregister(mlx5e_dev);
 	mlx5e_destroy_devlink(mlx5e_dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1fc386eccaf8..3e7041bd5705 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/debugfs.h>
 #include <linux/mlx5/fs.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
@@ -812,11 +813,15 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
+	priv->dfs_root = debugfs_create_dir("nic",
+					    mlx5_debugfs_get_dev_root(mdev));
+
 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
 				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
 				 priv->dfs_root);
 	if (!priv->fs) {
 		netdev_err(priv->netdev, "FS allocation failed\n");
+		debugfs_remove_recursive(priv->dfs_root);
 		return -ENOMEM;
 	}
 
@@ -829,6 +834,7 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
 	mlx5e_fs_cleanup(priv->fs);
+	debugfs_remove_recursive(priv->dfs_root);
 	priv->fs = NULL;
 }
 
-- 
2.40.1


