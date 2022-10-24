Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B5F60B6D9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiJXTMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiJXTLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:11:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8BC1781FD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0069B81626
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BD2C433D6;
        Mon, 24 Oct 2022 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630818;
        bh=kdFLX4zkPArAT6rZgWYL08h5O/rycFS3UjzsipuSQFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5yNkmBlJ5hxsqphxA6bppSrU58Gfyq4oxPofwBFhhU6EjvO6FnTaXZYn4Io99dfg
         NHi8B59tos6I1YQMcG7s8O3UDFR0Su9N86ylQN1qqFNhVOSXMPzpp2QIXqxFtibv7D
         hWAQjFr6v5AKHB3PGEbFZTF0hfKSW9pSjScYsQ+M8eUhH96PylUJlNsmMSs4inCgBi
         nCRUUeMjcGKnvDzKpxWWvaIttAqrkxrj5acMzwkT6Ex5DMBAnbFX7Bx5bdpH+O3UJ8
         24YTF9572KNk1Yclc358N6QDFFZ6Eu/Pv3TeJQJD9paMUl1Ur5c3T9Hu2oRRAUwhq1
         KKI6n/GrGLGyA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 1/6] net/mlx5e: Support devlink reload of IPsec core
Date:   Mon, 24 Oct 2022 19:59:54 +0300
Message-Id: <2ef26b5cfbc2870e65391320bbf70491cda6321f.1666630548.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666630548.git.leonro@nvidia.com>
References: <cover.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Change IPsec initialization flow to allow future creation of hardware
resources that should be released and allocated during devlink reload
operation. As part of that change, update function signature to be
void as no callers are actually interested in it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c         | 17 ++++++++---------
 .../mellanox/mlx5/core/en_accel/ipsec.h         |  5 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  7 ++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    |  9 +++------
 4 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2a8fd7020622..325b56ff3e8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -348,29 +348,27 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	kfree(sa_entry);
 }
 
-int mlx5e_ipsec_init(struct mlx5e_priv *priv)
+void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ipsec *ipsec;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (!mlx5_ipsec_device_caps(priv->mdev)) {
 		netdev_dbg(priv->netdev, "Not an IPSec offload device\n");
-		return 0;
+		return;
 	}
 
 	ipsec = kzalloc(sizeof(*ipsec), GFP_KERNEL);
 	if (!ipsec)
-		return -ENOMEM;
+		return;
 
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
 	ipsec->mdev = priv->mdev;
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
-	if (!ipsec->wq) {
-		ret = -ENOMEM;
+	if (!ipsec->wq)
 		goto err_wq;
-	}
 
 	ret = mlx5e_accel_ipsec_fs_init(ipsec);
 	if (ret)
@@ -378,13 +376,14 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
 	priv->ipsec = ipsec;
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
-	return 0;
+	return;
 
 err_fs_init:
 	destroy_workqueue(ipsec->wq);
 err_wq:
 	kfree(ipsec);
-	return (ret != -EOPNOTSUPP) ? ret : 0;
+	mlx5_core_err(priv->mdev, "IPSec initialization failed, %d\n", ret);
+	return;
 }
 
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 16bcceec16c4..4c47347d0ee2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -146,7 +146,7 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_modify_state_work modify_work;
 };
 
-int mlx5e_ipsec_init(struct mlx5e_priv *priv);
+void mlx5e_ipsec_init(struct mlx5e_priv *priv);
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv);
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
 
@@ -174,9 +174,8 @@ mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return sa_entry->ipsec->mdev;
 }
 #else
-static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
+static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
-	return 0;
 }
 
 static inline void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 364f04309149..6a97d0d96bf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5225,10 +5225,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	}
 	priv->fs = fs;
 
-	err = mlx5e_ipsec_init(priv);
-	if (err)
-		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
-
 	err = mlx5e_ktls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
@@ -5241,7 +5237,6 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
-	mlx5e_ipsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
 }
 
@@ -5370,6 +5365,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	int err;
 
 	mlx5e_fs_init_l2_addr(priv->fs, netdev);
+	mlx5e_ipsec_init(priv);
 
 	err = mlx5e_macsec_init(priv);
 	if (err)
@@ -5433,6 +5429,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
 	mlx5e_macsec_cleanup(priv);
+	mlx5e_ipsec_cleanup(priv);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 794cd8dfe9c9..324e5759b049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -761,7 +761,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 			     struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	int err;
 
 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
 				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
@@ -770,10 +769,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 		return -ENOMEM;
 	}
 
-	err = mlx5e_ipsec_init(priv);
-	if (err)
-		mlx5_core_err(mdev, "Uplink rep IPsec initialization failed, %d\n", err);
-
 	mlx5e_vxlan_set_netdev_info(priv);
 	mlx5e_build_rep_params(netdev);
 	mlx5e_timestamp_init(priv);
@@ -783,7 +778,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
 	mlx5e_fs_cleanup(priv->fs);
-	mlx5e_ipsec_cleanup(priv);
 }
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
@@ -1074,6 +1068,8 @@ static void mlx5e_rep_enable(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
+	mlx5e_ipsec_init(priv);
+
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	mlx5e_rep_neigh_init(rpriv);
 }
@@ -1083,6 +1079,7 @@ static void mlx5e_rep_disable(struct mlx5e_priv *priv)
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
 	mlx5e_rep_neigh_cleanup(rpriv);
+	mlx5e_ipsec_cleanup(priv);
 }
 
 static int mlx5e_update_rep_rx(struct mlx5e_priv *priv)
-- 
2.37.3

