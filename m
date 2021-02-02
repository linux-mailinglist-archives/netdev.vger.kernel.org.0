Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B879430B819
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhBBGz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232085AbhBBGzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:55:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6513F64EE7;
        Tue,  2 Feb 2021 06:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248913;
        bh=64zPNsBlfb8Q82UxAFOfMhBRA7UZC8nZRPzrZ6vOjMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqwZdwz9akev+JbiAk5k8uzXMtRq0aePlK86+2b+CXa3GbQ3PlaVz92UKwctzlMAD
         DhC7K/LB1oBKlsYOoYwv9DHjvnTzGzpdIq95/Weu8TnlB78hf5HdxsK+sqSWIm+Rh3
         adnwxTDiKZSBxRYrrti/SNeCniP/eAwUIu4I56Ao59h5d5/bDWm2yMVWP7SJm6mjWv
         c0ENm+D0idYrEJ3jmRNgKR9Xn1rS2RdTH8XQ2WHIbpQczh9+ur8SjGq+Z4KaFRV5dF
         Hoik4+iUHofXLlUjDSn7RqbFFl5Hxh1Q1TsUoMhr47DygBMWQuyIhV3sPUfAqdjCoD
         U7FcABE0y6PrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: Refactor mlx5e_netdev_init/cleanup to mlx5e_priv_init/cleanup
Date:   Mon,  1 Feb 2021 22:54:46 -0800
Message-Id: <20210202065457.613312-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We actually initialize priv and not netdev. The only call to
set netdev carrier will be moved in the following commit.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++----------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 ++--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index fa461cfd6410..8cc80c31341f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1160,10 +1160,10 @@ mlx5e_calc_max_nch(struct mlx5e_priv *priv, const struct mlx5e_profile *profile)
 	return priv->netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
 }
 
-int mlx5e_netdev_init(struct net_device *netdev,
-		      struct mlx5e_priv *priv,
-		      struct mlx5_core_dev *mdev);
-void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv);
+int mlx5e_priv_init(struct mlx5e_priv *priv,
+		    struct net_device *netdev,
+		    struct mlx5_core_dev *mdev);
+void mlx5e_priv_cleanup(struct mlx5e_priv *priv);
 struct net_device *
 mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int rxqs);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 91f23871ded5..177e076f6cce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5457,9 +5457,9 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 };
 
 /* mlx5e generic netdev management API (move to en_common.c) */
-int mlx5e_netdev_init(struct net_device *netdev,
-		      struct mlx5e_priv *priv,
-		      struct mlx5_core_dev *mdev)
+int mlx5e_priv_init(struct mlx5e_priv *priv,
+		    struct net_device *netdev,
+		    struct mlx5_core_dev *mdev)
 {
 	memset(priv, 0, sizeof(*priv));
 
@@ -5494,7 +5494,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	return -ENOMEM;
 }
 
-void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv)
+void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 {
 	int i;
 
@@ -5518,9 +5518,9 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int
 		return NULL;
 	}
 
-	err = mlx5e_netdev_init(netdev, netdev_priv(netdev), mdev);
+	err = mlx5e_priv_init(netdev_priv(netdev), netdev, mdev);
 	if (err) {
-		mlx5_core_err(mdev, "mlx5e_netdev_init failed, err=%d\n", err);
+		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		goto err_free_netdev;
 	}
 	dev_net_set(netdev, mlx5_core_net(mdev));
@@ -5625,9 +5625,9 @@ mlx5e_netdev_attach_profile(struct mlx5e_priv *priv,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	err = mlx5e_netdev_init(netdev, priv, mdev);
+	err = mlx5e_priv_init(priv, netdev, mdev);
 	if (err) {
-		mlx5_core_err(mdev, "mlx5e_netdev_init failed, err=%d\n", err);
+		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		return err;
 	}
 	priv->profile = new_profile;
@@ -5660,7 +5660,7 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 	/* cleanup old profile */
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
-	mlx5e_netdev_cleanup(priv->netdev, priv);
+	mlx5e_priv_cleanup(priv);
 
 	err = mlx5e_netdev_attach_profile(priv, new_profile, new_ppriv);
 	if (err) { /* roll back to original profile */
@@ -5685,7 +5685,7 @@ void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
 
-	mlx5e_netdev_cleanup(netdev, priv);
+	mlx5e_priv_cleanup(priv);
 	free_netdev(netdev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 5889029c2adf..8641bd9bbb53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -103,7 +103,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 /* Called directly before IPoIB netdevice is destroyed to cleanup SW structs */
 void mlx5i_cleanup(struct mlx5e_priv *priv)
 {
-	mlx5e_netdev_cleanup(priv->netdev, priv);
+	mlx5e_priv_cleanup(priv);
 }
 
 static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
@@ -744,7 +744,7 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
 			goto destroy_ht;
 	}
 
-	err = mlx5e_netdev_init(netdev, epriv, mdev);
+	err = mlx5e_priv_init(epriv, netdev, mdev);
 	if (err)
 		goto destroy_mdev_resources;
 
-- 
2.29.2

