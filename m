Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3684730B81A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhBBGz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhBBGzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:55:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FA7D64EE8;
        Tue,  2 Feb 2021 06:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248913;
        bh=6h96t0KmVA/ZHg0SCIB7LAec9IKH97aWu3/bgP48UsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXSvA9gkea0AQTuk2mp7nBz2UN+ZUnb+bRydeoq5JM8juF9M/7qWFMO7Wp9DGUR/z
         cdwa5nqvw7epkxY20oiyBj2eU1D5dJ9WJsoLxmY2fv94KpyNLTpz0Dww+G/9mpOwO5
         didPuc/sHz9NBJdIzX5in8m1eog+PaqdKz0SHBFcKv6TOhFVsbupgLMZq/bmtegF7y
         l6CBN873akmOgC7NlF7moAg3pgcPtMtv2AdESWO0z9NvdTBYBZmc5KnqmHBnTJNKys
         yhVMSJSf5PTv3EoK1EznnxdUx0v3s7uk0zYnqUHVw+EF5j47HI7IMocMvCVyB56Bz+
         njtJfoJkkUumA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5e: Move netif_carrier_off() out of mlx5e_priv_init()
Date:   Mon,  1 Feb 2021 22:54:47 -0800
Message-Id: <20210202065457.613312-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

It's not part of priv initialization.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 177e076f6cce..e468d8329c2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5483,9 +5483,6 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	if (!priv->wq)
 		goto err_free_cpumask;
 
-	/* netdev init */
-	netif_carrier_off(netdev);
-
 	return 0;
 
 err_free_cpumask:
@@ -5523,6 +5520,8 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int
 		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		goto err_free_netdev;
 	}
+
+	netif_carrier_off(netdev);
 	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
@@ -5630,6 +5629,7 @@ mlx5e_netdev_attach_profile(struct mlx5e_priv *priv,
 		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		return err;
 	}
+	netif_carrier_off(netdev);
 	priv->profile = new_profile;
 	priv->ppriv = new_ppriv;
 	err = new_profile->init(priv->mdev, priv->netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 8641bd9bbb53..1eeca45cfcdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -76,6 +76,7 @@ int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 {
 	struct mlx5e_priv *priv  = mlx5i_epriv(netdev);
 
+	netif_carrier_off(netdev);
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	netdev->mtu = netdev->max_mtu;
 
-- 
2.29.2

