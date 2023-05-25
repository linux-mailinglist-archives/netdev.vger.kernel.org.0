Return-Path: <netdev+bounces-5210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF80710380
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00ED91C20D8F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E080C8BFB;
	Thu, 25 May 2023 03:49:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5406E8827
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1538CC433EF;
	Thu, 25 May 2023 03:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986556;
	bh=CL8M9FlyYiVenv+YK4uKJnsCPWUxKuZMEWkggODK6fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjUbglZtXo+DxbCjINe4WF2u9NWocdf9GjTDXX7vijeEFNGkqn4Bi2AdHGqJ2ndnV
	 XmXHBfCk+7LNPSrOxp9xZa+q9i3RxgaYO+bsz0vZrPc8a/ZiAHknmlsEwgIvdJEBPu
	 ceyb0YpK4MTZGQZLlQDT29Rjkq1cO6DtRVTxN1ddSHszNpzPVoaI82p79wVX5PvjN+
	 dt/pKuYOZ5zzQd3R8i8W526O7hyhrep5Cpi1wHhr2NhC49mjL3S+tDN5eMjVzT3t3u
	 XQuc9e5C4YrVl8MI7QhKzdaIClqYIgz6U1bPPW6TuxPGV+4JBJr8JJkwojQZQX+hn8
	 WmqfyAQYotqiQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Dmytro Linkin <dlinkin@nvidia.com>
Subject: [net 10/17] net/mlx5e: Don't attach netdev profile while handling internal error
Date: Wed, 24 May 2023 20:48:40 -0700
Message-Id: <20230525034847.99268-11-saeed@kernel.org>
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

From: Dmytro Linkin <dlinkin@nvidia.com>

As part of switchdev mode disablement, driver changes port netdevice
profile from uplink to nic. If this process is triggered by health
recovery flow (PCI reset, for ex.) profile attach would fail because all
fw commands aborted when internal error flag is set. As a result, nic
netdevice profile is not attached and driver fails to rollback to uplink
profile, which leave driver in broken state and cause crash later.

To handle broken state do netdevice profile initialization only instead
of full attachment and release mdev resources on driver suspend as
expected. Actual netdevice attachment is done during driver load.

Fixes: c4d7eb57687f ("net/mxl5e: Add change profile method")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 35 ++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0235adcbc609..a07bbe9a61be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5833,8 +5833,8 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 }
 
 static int
-mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mdev,
-			    const struct mlx5e_profile *new_profile, void *new_ppriv)
+mlx5e_netdev_init_profile(struct net_device *netdev, struct mlx5_core_dev *mdev,
+			  const struct mlx5e_profile *new_profile, void *new_ppriv)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
@@ -5850,6 +5850,25 @@ mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mde
 	err = new_profile->init(priv->mdev, priv->netdev);
 	if (err)
 		goto priv_cleanup;
+
+	return 0;
+
+priv_cleanup:
+	mlx5e_priv_cleanup(priv);
+	return err;
+}
+
+static int
+mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mdev,
+			    const struct mlx5e_profile *new_profile, void *new_ppriv)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err;
+
+	err = mlx5e_netdev_init_profile(netdev, mdev, new_profile, new_ppriv);
+	if (err)
+		return err;
+
 	err = mlx5e_attach_netdev(priv);
 	if (err)
 		goto profile_cleanup;
@@ -5857,7 +5876,6 @@ mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mde
 
 profile_cleanup:
 	new_profile->cleanup(priv);
-priv_cleanup:
 	mlx5e_priv_cleanup(priv);
 	return err;
 }
@@ -5876,6 +5894,12 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 	priv->profile->cleanup(priv);
 	mlx5e_priv_cleanup(priv);
 
+	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+		mlx5e_netdev_init_profile(netdev, mdev, new_profile, new_ppriv);
+		set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+		return -EIO;
+	}
+
 	err = mlx5e_netdev_attach_profile(netdev, mdev, new_profile, new_ppriv);
 	if (err) { /* roll back to original profile */
 		netdev_warn(netdev, "%s: new profile init failed, %d\n", __func__, err);
@@ -5937,8 +5961,11 @@ static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!netif_device_present(netdev))
+	if (!netif_device_present(netdev)) {
+		if (test_bit(MLX5E_STATE_DESTROYING, &priv->state))
+			mlx5e_destroy_mdev_resources(mdev);
 		return -ENODEV;
+	}
 
 	mlx5e_detach_netdev(priv);
 	mlx5e_destroy_mdev_resources(mdev);
-- 
2.40.1


