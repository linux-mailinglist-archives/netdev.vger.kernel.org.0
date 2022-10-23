Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6EB60951E
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJWRXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJWRXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:23:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12D75380
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 10:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A797660BC2
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 17:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85904C433C1;
        Sun, 23 Oct 2022 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545788;
        bh=eX6K9xnIqhQ4Oz1yeOVn7ELD2CoAOFURGdmLXn2enYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQQQBwxmdCd5PPTJ397A6wb8Sd2pkKOjSXSZ644F2ClFdg0BY+4HPP1A1BXLgkOS0
         rjqikASrmig9C/YlVC+dDjKJF/iT/rUgqBd0jN6sO1PRWCpa5cOjek/yPxgUqdZria
         gH8fsJQNyhmNJp06xlZeAnx3BwDvXBpDVeWfTZRSKzVHlbIwfOy3AJp5EPn21ahxGf
         59MgtfhCnx99awkVSbl2gZN4BFUYSbXa45t/lrt5k08J2enNJgpdQOAeW8Xpa5fFeK
         ogWf0Rl/GxnI1nSEeoYzq3wzU053FRe7toTG8Cy2aNB6+xEnSdiFOcEAEDFOUXzizP
         z1WBiPPgzwKKQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 1/6] net/mlx5e: Support devlink reload of IPsec core
Date:   Sun, 23 Oct 2022 20:22:53 +0300
Message-Id: <862c2bab5b9a17c6a552d2e243909b9daf5d73d6.1666545480.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666545480.git.leonro@nvidia.com>
References: <cover.1666545480.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  8 +++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 13 +++++++------
 4 files changed, 20 insertions(+), 23 deletions(-)

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
index 364f04309149..8867fee0db1c 100644
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
@@ -5885,6 +5882,7 @@ static int mlx5e_suspend(struct auxiliary_device *adev, pm_message_t state)
 		return -ENODEV;
 
 	mlx5e_detach_netdev(priv);
+
 	mlx5e_destroy_mdev_resources(mdev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 794cd8dfe9c9..061240e4eaf5 100644
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
@@ -1122,6 +1119,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u16 max_mtu;
 
+	mlx5e_ipsec_init(priv);
+
 	netdev->min_mtu = ETH_MIN_MTU;
 	mlx5_query_port_max_mtu(priv->mdev, &max_mtu, 1);
 	netdev->max_mtu = MLX5E_HW2SW_MTU(&priv->channels.params, max_mtu);
@@ -1168,6 +1167,8 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	mlx5e_rep_tc_disable(priv);
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
+
+	mlx5e_ipsec_cleanup(priv);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
-- 
2.37.3

