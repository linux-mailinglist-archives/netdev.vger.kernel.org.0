Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05FE30B81F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhBBG4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232110AbhBBGzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD7764EE2;
        Tue,  2 Feb 2021 06:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248911;
        bh=VkLBuPrcIoTeuJQjUnHyW8UgIHHMy9IZrmqV/I8HQfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuV/YyBPR7gA+Zf2Lr35fEZfIujjbh4g2qlF4U3TGbXCGDDSQl7E5vsN2Wamba2Xf
         GDcr5bMSHCqGV/01flCWb+2g6rytd8KK47OYogorC9PPt8RkSz+J156Ti8ymWUFlH+
         Rq4f81s8TM9S6pWVANSDejoNgdzIAprk19Fh5QQkqyPT5kX2hRTqYFW8LTIPO7vTWk
         vBSMWBJQivac41gj2JS9FxzhIsQQ+MKkzH2UodYtfLkm/PjPKvyooBgv5/zmftzAaI
         3cEOhGP419yVSoFz91lv6VlD0GrW54H2UHbdKV15Bm7tkGWn7BPyUAd7f+6iqQxbaw
         3Hmo9O+1uVZ8A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 01/14] net/mlx5e: Separate between netdev objects and mlx5e profiles initialization
Date:   Mon,  1 Feb 2021 22:54:44 -0800
Message-Id: <20210202065457.613312-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

1) Initialize netdevice features and structures on netdevice allocation
   and outside of the mlx5e profile.

2) As now mlx5e netdevice private params will be setup on profile init only
   after netdevice features are already set, we add  a call to
   netde_update_features() to resolve any conflict.
   This is nice since we reuse the fix_features ndo code if a profile
   wants different default features, instead of duplicating features
   conflict resolution code on profile initialization.

3) With this we achieve total separation between mlx5e profiles and
   netdevices, and will allow replacing mlx5e profiles on the fly to reuse
   the same netdevice for multiple profiles.
   e.g. for uplink representor profile as shown in the following patch

4) Profile callbacks are not allowed to touch netdev->features directly
   anymore, since in downstream patch we will detach/attach netdev
   dynamically to profile, hence we move the code dealing with
   netdev->features from profile->init() to fix_features ndo, and we
   will call netdev_update_features() on
   mlx5e_attach_netdev(profile, netdev);

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  23 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 127 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  51 ++++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  23 ++--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |   5 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |   6 +-
 6 files changed, 121 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 39f389cc40fc..bf5de1e79134 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -895,8 +895,7 @@ extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic;
 
 struct mlx5e_profile {
 	int	(*init)(struct mlx5_core_dev *mdev,
-			struct net_device *netdev,
-			const struct mlx5e_profile *profile, void *ppriv);
+			struct net_device *netdev);
 	void	(*cleanup)(struct mlx5e_priv *priv);
 	int	(*init_rx)(struct mlx5e_priv *priv);
 	void	(*cleanup_rx)(struct mlx5e_priv *priv);
@@ -1155,24 +1154,22 @@ int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
 				 struct ethtool_pauseparam *pauseparam);
 
 /* mlx5e generic netdev management API */
+static inline unsigned int mlx5e_calc_max_nch(struct mlx5e_priv *priv)
+{
+	return priv->netdev->num_rx_queues / max_t(u8, priv->profile->rq_groups, 1);
+}
+
 int mlx5e_netdev_init(struct net_device *netdev,
 		      struct mlx5e_priv *priv,
-		      struct mlx5_core_dev *mdev,
-		      const struct mlx5e_profile *profile,
-		      void *ppriv);
+		      struct mlx5_core_dev *mdev);
 void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv);
-struct net_device*
-mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
-		    int nch, void *ppriv);
+struct net_device *
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int rxqs);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
-void mlx5e_build_nic_params(struct mlx5e_priv *priv,
-			    struct mlx5e_xsk *xsk,
-			    struct mlx5e_rss_params *rss_params,
-			    struct mlx5e_params *params,
-			    u16 mtu);
+void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu);
 void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
 			   struct mlx5e_params *params);
 void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index aad3887e3c1a..260ced27014d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4093,6 +4093,7 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		if (!params->vlan_strip_disable)
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
 	}
+
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		if (features & NETIF_F_LRO) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
@@ -4928,15 +4929,15 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 			tirc_default_config[tt].rx_hash_fields;
 }
 
-void mlx5e_build_nic_params(struct mlx5e_priv *priv,
-			    struct mlx5e_xsk *xsk,
-			    struct mlx5e_rss_params *rss_params,
-			    struct mlx5e_params *params,
-			    u16 mtu)
+void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu)
 {
+	struct mlx5e_rss_params *rss_params = &priv->rss_params;
+	struct mlx5e_params *params = &priv->channels.params;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 rx_cq_period_mode;
 
+	priv->max_nch = mlx5e_calc_max_nch(priv);
+
 	params->sw_mtu = mtu;
 	params->hard_mtu = MLX5E_ETH_HARD_MTU;
 	params->num_channels = min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
@@ -4994,6 +4995,11 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 
 	/* AF_XDP */
 	params->xsk = xsk;
+
+	/* Do not update netdev->features directly in here
+	 * on mlx5e_attach_netdev() we will call mlx5e_update_features()
+	 * To update netdev->features please modify mlx5e_fix_features()
+	 */
 }
 
 static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
@@ -5146,18 +5152,12 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_features |= NETIF_F_RXFCS;
 
 	netdev->features          = netdev->hw_features;
-	if (!priv->channels.params.lro_en)
-		netdev->features  &= ~NETIF_F_LRO;
 
+	/* Defaults */
 	if (fcs_enabled)
 		netdev->features  &= ~NETIF_F_RXALL;
-
-	if (!priv->channels.params.scatter_fcs_en)
-		netdev->features  &= ~NETIF_F_RXFCS;
-
-	/* prefere CQE compression over rxhash */
-	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
-		netdev->features &= ~NETIF_F_RXHASH;
+	netdev->features  &= ~NETIF_F_LRO;
+	netdev->features  &= ~NETIF_F_RXFCS;
 
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
@@ -5223,33 +5223,27 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 }
 
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
-			  struct net_device *netdev,
-			  const struct mlx5e_profile *profile,
-			  void *ppriv)
+			  struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rss_params *rss = &priv->rss_params;
 	int err;
 
-	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
-	if (err)
-		return err;
-
-	mlx5e_build_nic_params(priv, &priv->xsk, rss, &priv->channels.params,
-			       netdev->mtu);
+	mlx5e_build_nic_params(priv, &priv->xsk, netdev->mtu);
 
 	mlx5e_timestamp_init(priv);
 
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
+
 	err = mlx5e_tls_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
-	mlx5e_build_nic_netdev(netdev);
+
 	err = mlx5e_devlink_port_register(priv);
 	if (err)
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
+
 	mlx5e_health_create_reporters(priv);
 
 	return 0;
@@ -5261,7 +5255,6 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_devlink_port_unregister(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
-	mlx5e_netdev_cleanup(priv->netdev, priv);
 }
 
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
@@ -5464,21 +5457,14 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 };
 
 /* mlx5e generic netdev management API (move to en_common.c) */
-
-/* mlx5e_netdev_init/cleanup must be called from profile->init/cleanup callbacks */
 int mlx5e_netdev_init(struct net_device *netdev,
 		      struct mlx5e_priv *priv,
-		      struct mlx5_core_dev *mdev,
-		      const struct mlx5e_profile *profile,
-		      void *ppriv)
+		      struct mlx5_core_dev *mdev)
 {
 	/* priv init */
 	priv->mdev        = mdev;
 	priv->netdev      = netdev;
-	priv->profile     = profile;
-	priv->ppriv       = ppriv;
 	priv->msglevel    = MLX5E_MSG_LEVEL;
-	priv->max_nch     = netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
 	priv->max_opened_tc = 1;
 
 	if (!alloc_cpumask_var(&priv->scratchpad.cpumask, GFP_KERNEL))
@@ -5518,35 +5504,24 @@ void mlx5e_netdev_cleanup(struct net_device *netdev, struct mlx5e_priv *priv)
 	kvfree(priv->htb.qos_sq_stats);
 }
 
-struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
-				       const struct mlx5e_profile *profile,
-				       int nch,
-				       void *ppriv)
+struct net_device *
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int rxqs)
 {
 	struct net_device *netdev;
-	unsigned int ptp_txqs = 0;
-	int qos_sqs = 0;
 	int err;
 
-	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
-		ptp_txqs = profile->max_tc;
-
-	if (mlx5_qos_is_supported(mdev))
-		qos_sqs = mlx5e_qos_max_leaf_nodes(mdev);
-
-	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv),
-				    nch * profile->max_tc + ptp_txqs + qos_sqs,
-				    nch * profile->rq_groups);
+	netdev = alloc_etherdev_mqs(sizeof(struct mlx5e_priv), txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_err(mdev, "alloc_etherdev_mqs() failed\n");
 		return NULL;
 	}
 
-	err = profile->init(mdev, netdev, profile, ppriv);
+	err = mlx5e_netdev_init(netdev, netdev_priv(netdev), mdev);
 	if (err) {
-		mlx5_core_err(mdev, "failed to init mlx5e profile %d\n", err);
+		mlx5_core_err(mdev, "mlx5e_netdev_init failed, err=%d\n", err);
 		goto err_free_netdev;
 	}
+	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
 
@@ -5556,14 +5531,23 @@ struct net_device *mlx5e_create_netdev(struct mlx5_core_dev *mdev,
 	return NULL;
 }
 
+static void mlx5e_update_features(struct net_device *netdev)
+{
+	if (netdev->reg_state != NETREG_REGISTERED)
+		return; /* features will be updated on netdev registration */
+
+	rtnl_lock();
+	netdev_update_features(netdev);
+	rtnl_unlock();
+}
+
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
 	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
-	const struct mlx5e_profile *profile;
+	const struct mlx5e_profile *profile = priv->profile;
 	int max_nch;
 	int err;
 
-	profile = priv->profile;
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
 	/* max number of channels may have changed */
@@ -5603,6 +5587,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	if (profile->enable)
 		profile->enable(priv);
 
+	mlx5e_update_features(priv->netdev);
+
 	return 0;
 
 err_cleanup_tx:
@@ -5631,11 +5617,9 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv)
 {
-	const struct mlx5e_profile *profile = priv->profile;
 	struct net_device *netdev = priv->netdev;
 
-	if (profile->cleanup)
-		profile->cleanup(priv);
+	mlx5e_netdev_cleanup(netdev, priv);
 	free_netdev(netdev);
 }
 
@@ -5681,28 +5665,48 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		       const struct auxiliary_device_id *id)
 {
 	struct mlx5_adev *edev = container_of(adev, struct mlx5_adev, adev);
+	const struct mlx5e_profile *profile = &mlx5e_nic_profile;
 	struct mlx5_core_dev *mdev = edev->mdev;
 	struct net_device *netdev;
 	pm_message_t state = {};
-	void *priv;
+	unsigned int txqs, rxqs, ptp_txqs = 0;
+	struct mlx5e_priv *priv;
+	int qos_sqs = 0;
 	int err;
 	int nch;
 
+	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
+		ptp_txqs = profile->max_tc;
+
+	if (mlx5_qos_is_supported(mdev))
+		qos_sqs = mlx5e_qos_max_leaf_nodes(mdev);
+
 	nch = mlx5e_get_max_num_channels(mdev);
-	netdev = mlx5e_create_netdev(mdev, &mlx5e_nic_profile, nch, NULL);
+	txqs = nch * profile->max_tc + ptp_txqs + qos_sqs;
+	rxqs = nch * profile->rq_groups;
+	netdev = mlx5e_create_netdev(mdev, txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_err(mdev, "mlx5e_create_netdev failed\n");
 		return -ENOMEM;
 	}
 
-	dev_net_set(netdev, mlx5_core_net(mdev));
+	mlx5e_build_nic_netdev(netdev);
+
 	priv = netdev_priv(netdev);
 	dev_set_drvdata(&adev->dev, priv);
 
+	priv->profile = profile;
+	priv->ppriv = NULL;
+	err = profile->init(mdev, netdev);
+	if (err) {
+		mlx5_core_err(mdev, "mlx5e_nic_profile init failed, %d\n", err);
+		goto err_destroy_netdev;
+	}
+
 	err = mlx5e_resume(adev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_resume failed, %d\n", err);
-		goto err_destroy_netdev;
+		goto err_profile_cleanup;
 	}
 
 	err = register_netdev(netdev);
@@ -5718,6 +5722,8 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 
 err_resume:
 	mlx5e_suspend(adev, state);
+err_profile_cleanup:
+	profile->cleanup(priv);
 err_destroy_netdev:
 	mlx5e_destroy_netdev(priv);
 	return err;
@@ -5731,6 +5737,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
+	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 629ae6ccb4cd..d94d2ff9d312 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -684,7 +684,10 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 					 MLX5_CQ_PERIOD_MODE_START_FROM_CQE :
 					 MLX5_CQ_PERIOD_MODE_START_FROM_EQE;
 
+	priv->max_nch = mlx5e_calc_max_nch(priv);
 	params = &priv->channels.params;
+
+	params->num_channels = MLX5E_REP_PARAMS_DEF_NUM_CHANNELS;
 	params->hard_mtu    = MLX5E_ETH_HARD_MTU;
 	params->sw_mtu      = netdev->mtu;
 
@@ -710,12 +713,11 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	mlx5e_build_rss_params(&priv->rss_params, params->num_channels);
 }
 
-static void mlx5e_build_rep_netdev(struct net_device *netdev)
+static void mlx5e_build_rep_netdev(struct net_device *netdev,
+				   struct mlx5_core_dev *mdev,
+				   struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct mlx5_core_dev *mdev = priv->mdev;
 
 	SET_NETDEV_DEV(netdev, mdev->device);
 	if (rep->vport == MLX5_VPORT_UPLINK) {
@@ -755,22 +757,11 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 }
 
 static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
-			  struct net_device *netdev,
-			  const struct mlx5e_profile *profile,
-			  void *ppriv)
+			  struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	int err;
-
-	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
-	if (err)
-		return err;
-
-	priv->channels.params.num_channels = MLX5E_REP_PARAMS_DEF_NUM_CHANNELS;
 
 	mlx5e_build_rep_params(netdev);
-	mlx5e_build_rep_netdev(netdev);
-
 	mlx5e_timestamp_init(priv);
 
 	return 0;
@@ -778,7 +769,6 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
-	mlx5e_netdev_cleanup(priv->netdev, priv);
 }
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
@@ -1201,6 +1191,8 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	struct mlx5e_rep_priv *rpriv;
 	struct devlink_port *dl_port;
 	struct net_device *netdev;
+	struct mlx5e_priv *priv;
+	unsigned int txqs, rxqs;
 	int nch, err;
 
 	rpriv = kzalloc(sizeof(*rpriv), GFP_KERNEL);
@@ -1210,10 +1202,13 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	/* rpriv->rep to be looked up when profile->init() is called */
 	rpriv->rep = rep;
 
-	nch = mlx5e_get_max_num_channels(dev);
 	profile = (rep->vport == MLX5_VPORT_UPLINK) ?
 		  &mlx5e_uplink_rep_profile : &mlx5e_rep_profile;
-	netdev = mlx5e_create_netdev(dev, profile, nch, rpriv);
+
+	nch = mlx5e_get_max_num_channels(dev);
+	txqs = nch * profile->max_tc;
+	rxqs = nch * profile->rq_groups;
+	netdev = mlx5e_create_netdev(dev, txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_warn(dev,
 			       "Failed to create representor netdev for vport %d\n",
@@ -1222,7 +1217,8 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		return -EINVAL;
 	}
 
-	dev_net_set(netdev, mlx5_core_net(dev));
+	mlx5e_build_rep_netdev(netdev, dev, rep);
+
 	rpriv->netdev = netdev;
 	rep->rep_data[REP_ETH].priv = rpriv;
 	INIT_LIST_HEAD(&rpriv->vport_sqs_list);
@@ -1233,12 +1229,21 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 			goto err_destroy_netdev;
 	}
 
+	priv = netdev_priv(netdev);
+	priv->profile = profile;
+	priv->ppriv = rpriv;
+	err = profile->init(dev, netdev);
+	if (err) {
+		netdev_warn(netdev, "rep profile init failed, %d\n", err);
+		goto err_destroy_mdev_resources;
+	}
+
 	err = mlx5e_attach_netdev(netdev_priv(netdev));
 	if (err) {
 		netdev_warn(netdev,
 			    "Failed to attach representor netdev for vport %d\n",
 			    rep->vport);
-		goto err_destroy_mdev_resources;
+		goto err_cleanup_profile;
 	}
 
 	err = mlx5e_rep_neigh_init(rpriv);
@@ -1268,6 +1273,9 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 err_detach_netdev:
 	mlx5e_detach_netdev(netdev_priv(netdev));
 
+err_cleanup_profile:
+	priv->profile->cleanup(priv);
+
 err_destroy_mdev_resources:
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_destroy_mdev_resources(dev);
@@ -1294,6 +1302,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	unregister_netdev(netdev);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
+	priv->profile->cleanup(priv);
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_destroy_mdev_resources(priv->mdev);
 	mlx5e_destroy_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 97b5fcb1f406..5889029c2adf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -72,23 +72,14 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 }
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
-int mlx5i_init(struct mlx5_core_dev *mdev,
-	       struct net_device *netdev,
-	       const struct mlx5e_profile *profile,
-	       void *ppriv)
+int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 {
 	struct mlx5e_priv *priv  = mlx5i_epriv(netdev);
-	int err;
-
-	err = mlx5e_netdev_init(netdev, priv, mdev, profile, ppriv);
-	if (err)
-		return err;
 
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	netdev->mtu = netdev->max_mtu;
 
-	mlx5e_build_nic_params(priv, NULL, &priv->rss_params, &priv->channels.params,
-			       netdev->mtu);
+	mlx5e_build_nic_params(priv, NULL, netdev->mtu);
 	mlx5i_build_nic_params(mdev, &priv->channels.params);
 
 	mlx5e_timestamp_init(priv);
@@ -753,7 +744,14 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
 			goto destroy_ht;
 	}
 
-	prof->init(mdev, netdev, prof, ipriv);
+	err = mlx5e_netdev_init(netdev, epriv, mdev);
+	if (err)
+		goto destroy_mdev_resources;
+
+	epriv->profile = prof;
+	epriv->ppriv = ipriv;
+
+	prof->init(mdev, netdev);
 
 	err = mlx5e_attach_netdev(epriv);
 	if (err)
@@ -777,6 +775,7 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
 	prof->cleanup(epriv);
 	if (ipriv->sub_interface)
 		return err;
+destroy_mdev_resources:
 	mlx5e_destroy_mdev_resources(mdev);
 destroy_ht:
 	mlx5i_pkey_qpn_ht_cleanup(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index b79dc1e28c41..99d46fda9f82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -87,10 +87,7 @@ void mlx5i_dev_cleanup(struct net_device *dev);
 int mlx5i_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
 /* Parent profile functions */
-int mlx5i_init(struct mlx5_core_dev *mdev,
-	       struct net_device *netdev,
-	       const struct mlx5e_profile *profile,
-	       void *ppriv);
+int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev);
 void mlx5i_cleanup(struct mlx5e_priv *priv);
 
 int mlx5i_update_nic_rx(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 7163d9f6c4a6..3d0a18a0bed4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -276,14 +276,12 @@ static int mlx5i_pkey_change_mtu(struct net_device *netdev, int new_mtu)
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
 static int mlx5i_pkey_init(struct mlx5_core_dev *mdev,
-			   struct net_device *netdev,
-			   const struct mlx5e_profile *profile,
-			   void *ppriv)
+			   struct net_device *netdev)
 {
 	struct mlx5e_priv *priv  = mlx5i_epriv(netdev);
 	int err;
 
-	err = mlx5i_init(mdev, netdev, profile, ppriv);
+	err = mlx5i_init(mdev, netdev);
 	if (err)
 		return err;
 
-- 
2.29.2

