Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3330B829
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhBBG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A42A964EE6;
        Tue,  2 Feb 2021 06:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248917;
        bh=mDZk51/H79NHpCs5yF5GDpbZLDBwKrd9rUCUYfu27n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfPhJDzXamSVC3gMS2xavV7H/Gay2EpjXMjaiZ7dVReSkLPRak3sqhHGGkb7lmd0O
         /3lq7NoqfRQWgaTOdTuaEHQjW1VRFPdxPsXNeuYmsTTdzAJhtfFmbzm9JOCSPn9bDu
         YPJG5fAhqtedjciMCG8GKvFpIMVZCoGxvcdQ2MFa2RY7YdvZQ3OJzj2iY/Y8OaM0Ej
         lx8BoFMvxNJ/18txTaWqdNVtmKGbXXh8qTcww3ol26jqZ/ilObk0mEN0o8WIgcK3cU
         lpvkZqpOyItGX6r+eflAASalqPhT2tTLUIxGcaU0OEgVtQMk1rg5H2tqhb1MuxlDqn
         nhpdhqhsWbO1g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/14] net/mlx5e: Move representor neigh init into profile enable
Date:   Mon,  1 Feb 2021 22:54:50 -0800
Message-Id: <20210202065457.613312-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Also cleanup neigh in profile disable.
This is for logical separation.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/neigh.c         | 18 ++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 29 ++++++++++---------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
index 58e27038c947..616ee585a985 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -279,7 +279,7 @@ int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv)
 
 	err = rhashtable_init(&neigh_update->neigh_ht, &mlx5e_neigh_ht_params);
 	if (err)
-		return err;
+		goto out_err;
 
 	INIT_LIST_HEAD(&neigh_update->neigh_list);
 	mutex_init(&neigh_update->encap_lock);
@@ -287,14 +287,19 @@ int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv)
 			  mlx5e_rep_neigh_stats_work);
 	mlx5e_rep_neigh_update_init_interval(rpriv);
 
-	rpriv->neigh_update.netevent_nb.notifier_call = mlx5e_rep_netevent_event;
-	err = register_netevent_notifier(&rpriv->neigh_update.netevent_nb);
+	neigh_update->netevent_nb.notifier_call = mlx5e_rep_netevent_event;
+	err = register_netevent_notifier(&neigh_update->netevent_nb);
 	if (err)
-		goto out_err;
+		goto out_notifier;
 	return 0;
 
-out_err:
+out_notifier:
+	neigh_update->netevent_nb.notifier_call = NULL;
 	rhashtable_destroy(&neigh_update->neigh_ht);
+out_err:
+	netdev_warn(rpriv->netdev,
+		    "Failed to initialize neighbours handling for vport %d\n",
+		    rpriv->rep->vport);
 	return err;
 }
 
@@ -303,6 +308,9 @@ void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv)
 	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 
+	if (!rpriv->neigh_update.netevent_nb.notifier_call)
+		return;
+
 	unregister_netevent_notifier(&neigh_update->netevent_nb);
 
 	flush_workqueue(priv->wq); /* flush neigh update works */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 45669a1db426..84eeaa33033f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1051,7 +1051,17 @@ static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 
 static void mlx5e_rep_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
 	mlx5e_set_netdev_mtu_boundaries(priv);
+	mlx5e_rep_neigh_init(rpriv);
+}
+
+static void mlx5e_rep_disable(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	mlx5e_rep_neigh_cleanup(rpriv);
 }
 
 static int mlx5e_update_rep_rx(struct mlx5e_priv *priv)
@@ -1086,6 +1096,7 @@ static int uplink_rep_async_event(struct notifier_block *nb, unsigned long event
 
 static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u16 max_mtu;
@@ -1104,12 +1115,15 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5_notifier_register(mdev, &priv->events_nb);
 	mlx5e_dcbnl_initialize(priv);
 	mlx5e_dcbnl_init_app(priv);
+	mlx5e_rep_neigh_init(rpriv);
 }
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
+	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_dcbnl_delete_app(priv);
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	mlx5e_rep_tc_disable(priv);
@@ -1161,6 +1175,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.init_tx		= mlx5e_init_rep_tx,
 	.cleanup_tx		= mlx5e_cleanup_rep_tx,
 	.enable		        = mlx5e_rep_enable,
+	.disable	        = mlx5e_rep_disable,
 	.update_rx		= mlx5e_update_rep_rx,
 	.update_stats           = mlx5e_stats_update_ndo_stats,
 	.rx_handlers            = &mlx5e_rx_handlers_rep,
@@ -1252,20 +1267,12 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto err_cleanup_profile;
 	}
 
-	err = mlx5e_rep_neigh_init(rpriv);
-	if (err) {
-		netdev_warn(netdev,
-			    "Failed to initialized neighbours handling for vport %d\n",
-			    rep->vport);
-		goto err_detach_netdev;
-	}
-
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_warn(netdev,
 			    "Failed to register representor netdev for vport %d\n",
 			    rep->vport);
-		goto err_neigh_cleanup;
+		goto err_detach_netdev;
 	}
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch, rpriv->rep->vport);
@@ -1273,9 +1280,6 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		devlink_port_type_eth_set(dl_port, netdev);
 	return 0;
 
-err_neigh_cleanup:
-	mlx5e_rep_neigh_cleanup(rpriv);
-
 err_detach_netdev:
 	mlx5e_detach_netdev(netdev_priv(netdev));
 
@@ -1306,7 +1310,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	if (dl_port)
 		devlink_port_type_clear(dl_port);
 	unregister_netdev(netdev);
-	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
 	if (rep->vport == MLX5_VPORT_UPLINK)
-- 
2.29.2

