Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B306A127B24
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfLTMfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:35:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36554 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfLTMfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:35:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so9287548wru.3
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fuG3AHsHL8ATGWggygUb8JD+FGOq0HX0nU/dwthZ2jQ=;
        b=d1VJ0zbHKyhLuyQPc2NvxYEugxaIfInYghVP3SmSM7hz/t1JBa5/WWj839GGO+LG/+
         bnneJzWy1cJ2zZjCl1b/lfpXwT0ACKo8/vAc3NqdF+omconawl/T9ZcgwuYfX76k2Pze
         nz2uwTAsGuTTgVHtJBq+AANEvAE/8xWLoEMKG72xSSbhxI1sy+QnHg6yoPQHyPDHTkHf
         7FfVTKFgie3zimOicxP+nfUsRST1ntVa9Gc2rbQOux4kNAbGl4l+kgZyDVjJo6tW1Jtd
         XM7jlBFv3QnN7m90WEFgIuGxkXWlNRcUJCG30aUsPJxpvBvQ+XIapituBWuVKjool1gS
         JksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fuG3AHsHL8ATGWggygUb8JD+FGOq0HX0nU/dwthZ2jQ=;
        b=lUzgN5mCOvKrtq7QYi+4cJbGvD5xuMIFkCx6ft3l1ELHLy8I6la+HnYC8UWlkxASbs
         0+HEaC++WR/ClPNXfX3yo0MA0hG29b+U6Au3SJ1AqkTeQOznG4XEy67+yELlHxmrRSod
         f3jI0H9WKhWr1CQTaiDXYQnw/1OcBox3GojHoXU1MVc3toVyKS/jrhrHA5jkv+tMz6FB
         UV4DbakxeTlMjOMnR6XpH0s02C0+dXG62OEuRDaKiGtKoW5TqSxF0napKQawPsTWVfj1
         WN0K4QH6ZmwkLXLAncpYhCb1x04fVWk7TImJmJ+IsvBxOyE3z4172b+ojfqW3vBF3QXx
         U3Xw==
X-Gm-Message-State: APjAAAXIL3FOUpq2tgV/YGfVv6Oz5NUlGm/0OUGdoLr906jwXDRBawGe
        UQqhK9foJWAfGXegP5ElUkFXEvfFGi0=
X-Google-Smtp-Source: APXvYqwx6+yhUhfPYL1oro/7vM/JOzVjrW+FQr9JezS1EaNZQgvwRdM4WkKdeVdWpIz9eC1qFfXJBA==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr15239802wrm.131.1576845347950;
        Fri, 20 Dec 2019 04:35:47 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id b67sm10135133wmc.38.2019.12.20.04.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:35:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next 4/4] mlx5: Use dev_net netdevice notifier registrations
Date:   Fri, 20 Dec 2019 13:35:42 +0100
Message-Id: <20191220123542.26315-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220123542.26315-1-jiri@resnulli.us>
References: <20191220123542.26315-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Register the dev_net notifier and allow the per-net notifier to follow
the device into different namespace.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 14 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |  1 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +-
 8 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 68d593074f6c..a3b098a46ad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -21,6 +21,7 @@ struct mlx5e_tc_table {
 	DECLARE_HASHTABLE(hairpin_tbl, 8);
 
 	struct notifier_block     netdevice_nb;
+	struct netdev_net_notifier	netdevice_nn;
 };
 
 struct mlx5e_flow_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 68f1c8cb302b..d9a900e567f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5166,6 +5166,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
+	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -5186,7 +5187,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 		mlx5e_monitor_counter_cleanup(priv);
 
 	mlx5e_disable_async_events(priv);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove(mdev, netdev);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb24bb67..5a275690dc6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1688,7 +1688,9 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 		/* init indirect block notifications */
 		INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
 		uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
-		err = register_netdevice_notifier(&uplink_priv->netdevice_nb);
+		err = register_netdevice_notifier_dev_net(rpriv->netdev,
+							  &uplink_priv->netdevice_nb,
+							  &uplink_priv->netdevice_nn);
 		if (err) {
 			mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
 			goto tc_esw_cleanup;
@@ -1707,12 +1709,17 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_rep_uplink_priv *uplink_priv;
 
 	mlx5e_destroy_tises(priv);
 
 	if (rpriv->rep->vport == MLX5_VPORT_UPLINK) {
+		uplink_priv = &rpriv->uplink_priv;
+
 		/* clean indirect TC block notifications */
-		unregister_netdevice_notifier(&rpriv->uplink_priv.netdevice_nb);
+		unregister_netdevice_notifier_dev_net(rpriv->netdev,
+						      &uplink_priv->netdevice_nb,
+						      &uplink_priv->netdevice_nn);
 		mlx5e_rep_indr_clean_block_privs(rpriv);
 
 		/* delete shared tc flow table */
@@ -1787,6 +1794,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 {
+	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
@@ -1795,7 +1803,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 #endif
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove(mdev, netdev);
 }
 
 static const struct mlx5e_profile mlx5e_rep_profile = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 31f83c8adcc9..3f756d51435f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -73,6 +73,7 @@ struct mlx5_rep_uplink_priv {
 	 */
 	struct list_head	    tc_indr_block_priv_list;
 	struct notifier_block	    netdevice_nb;
+	struct netdev_net_notifier  netdevice_nn;
 
 	struct mlx5_tun_entropy tun_entropy;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9b32a9c0f497..59cc898b7a21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4142,7 +4142,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 		return err;
 
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
-	if (register_netdevice_notifier(&tc->netdevice_nb)) {
+	err = register_netdevice_notifier_dev_net(priv->netdev,
+						  &tc->netdevice_nb,
+						  &tc->netdevice_nn);
+	if (err) {
 		tc->netdevice_nb.notifier_call = NULL;
 		mlx5_core_warn(priv->mdev, "Failed to register netdev notifier\n");
 	}
@@ -4164,7 +4167,9 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 
 	if (tc->netdevice_nb.notifier_call)
-		unregister_netdevice_notifier(&tc->netdevice_nb);
+		unregister_netdevice_notifier_dev_net(priv->netdev,
+						      &tc->netdevice_nb,
+						      &tc->netdevice_nn);
 
 	mutex_destroy(&tc->mod_hdr.lock);
 	mutex_destroy(&tc->hairpin_tbl_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index fc0d9583475d..b91eabc09fbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -586,7 +586,8 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 
 	if (!ldev->nb.notifier_call) {
 		ldev->nb.notifier_call = mlx5_lag_netdev_event;
-		if (register_netdevice_notifier(&ldev->nb)) {
+		if (register_netdevice_notifier_dev_net(netdev, &ldev->nb,
+							&ldev->nn)) {
 			ldev->nb.notifier_call = NULL;
 			mlx5_core_err(dev, "Failed to register LAG netdev notifier\n");
 		}
@@ -599,7 +600,7 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 }
 
 /* Must be called with intf_mutex held */
-void mlx5_lag_remove(struct mlx5_core_dev *dev)
+void mlx5_lag_remove(struct mlx5_core_dev *dev, struct net_device *netdev)
 {
 	struct mlx5_lag *ldev;
 	int i;
@@ -619,7 +620,8 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
 
 	if (i == MLX5_MAX_PORTS) {
 		if (ldev->nb.notifier_call)
-			unregister_netdevice_notifier(&ldev->nb);
+			unregister_netdevice_notifier_dev_net(netdev, &ldev->nb,
+							      &ldev->nn);
 		mlx5_lag_mp_cleanup(ldev);
 		cancel_delayed_work_sync(&ldev->bond_work);
 		mlx5_lag_dev_free(ldev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index f1068aac6406..316ab09e2664 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -44,6 +44,7 @@ struct mlx5_lag {
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
 	struct notifier_block     nb;
+	struct netdev_net_notifier	nn;
 	struct lag_mp             lag_mp;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index da67b28d6e23..fcce9e0fc82c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -157,7 +157,7 @@ int mlx5_query_qcam_reg(struct mlx5_core_dev *mdev, u32 *qcam,
 			u8 feature_group, u8 access_reg_group);
 
 void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev);
-void mlx5_lag_remove(struct mlx5_core_dev *dev);
+void mlx5_lag_remove(struct mlx5_core_dev *dev, struct net_device *netdev);
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
-- 
2.21.0

