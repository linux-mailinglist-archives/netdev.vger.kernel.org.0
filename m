Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ACB63CE9F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiK3FNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbiK3FMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A790769DB
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C512B81A2F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F4BC433C1;
        Wed, 30 Nov 2022 05:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785135;
        bh=fg0gybSrR1hyQ6reUGg0AeyObze2103wrGGPrf+dyjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssGchc1VikQ5PhiIZ6UK5Jv2ZKSXHompEisOtVSnxoLSzLDDK9D9UJQ/501gb+KDr
         q5K1rMby//pXuDP687uBUfuXQTCoXsD9buMO39qNV+4RXLVDRGMvNiV8t+OoYcy4+W
         s7t0flZqqxHpcz9ffJi3+Tllz2ELEKsbIQD9gn3K7tVMQA2Jl7VdwXABvMHE40llWU
         3PTA2TYQLzWCXUhdakhtsfZby5pBQuNFhlaNapRFbS6bUp3/7+V7pnU/ntFvwkPeNd
         sy7OXRclNOM3ArXUnPB5OQAsuiXr//njp2QDmrs+WMcG5azPaA/3+EBVN6/Yjo/RIv
         2gRc7i93R+1Ng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Support devlink reload of IPsec core
Date:   Tue, 29 Nov 2022 21:11:52 -0800
Message-Id: <20221130051152.479480-16-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c         | 17 ++++++++---------
 .../mellanox/mlx5/core/en_accel/ipsec.h         |  5 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  7 ++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 10 ++++------
 4 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index a715601865d3..1b03ab03fc5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -345,29 +345,27 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
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
@@ -375,13 +373,14 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 
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
index 199387c6bf16..8d36e2de53a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5238,10 +5238,6 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	}
 	priv->fs = fs;
 
-	err = mlx5e_ipsec_init(priv);
-	if (err)
-		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
-
 	err = mlx5e_ktls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
@@ -5254,7 +5250,6 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_ktls_cleanup(priv);
-	mlx5e_ipsec_cleanup(priv);
 	mlx5e_fs_cleanup(priv->fs);
 }
 
@@ -5383,6 +5378,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	int err;
 
 	mlx5e_fs_init_l2_addr(priv->fs, netdev);
+	mlx5e_ipsec_init(priv);
 
 	err = mlx5e_macsec_init(priv);
 	if (err)
@@ -5446,6 +5442,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
 	mlx5e_macsec_cleanup(priv);
+	mlx5e_ipsec_cleanup(priv);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 1b53e8852c86..623886462c10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -751,7 +751,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 			     struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	int err;
 
 	priv->fs = mlx5e_fs_init(priv->profile, mdev,
 				 !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
@@ -760,10 +759,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 		return -ENOMEM;
 	}
 
-	err = mlx5e_ipsec_init(priv);
-	if (err)
-		mlx5_core_err(mdev, "Uplink rep IPsec initialization failed, %d\n", err);
-
 	mlx5e_vxlan_set_netdev_info(priv);
 	mlx5e_build_rep_params(netdev);
 	mlx5e_timestamp_init(priv);
@@ -773,7 +768,6 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
 	mlx5e_fs_cleanup(priv->fs);
-	mlx5e_ipsec_cleanup(priv);
 }
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
@@ -1112,6 +1106,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u16 max_mtu;
 
+	mlx5e_ipsec_init(priv);
+
 	netdev->min_mtu = ETH_MIN_MTU;
 	mlx5_query_port_max_mtu(priv->mdev, &max_mtu, 1);
 	netdev->max_mtu = MLX5E_HW2SW_MTU(&priv->channels.params, max_mtu);
@@ -1158,6 +1154,8 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	mlx5e_rep_tc_disable(priv);
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
+
+	mlx5e_ipsec_cleanup(priv);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
-- 
2.38.1

