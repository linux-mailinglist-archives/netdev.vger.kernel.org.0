Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9EE149526
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgAYLRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:17:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37334 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAYLRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:17:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so5174741wru.4
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NVJVXWMmW6+azJuif5XHBsc9/5TTZmty+7ikIMETbWo=;
        b=aUVmBPRj8IuAJdVv+RT/8HW9IzKPtYNzHFOapbjJyg1fnSFhuz5gki1Cej72ItM79Y
         pD9ky8cvX+IsW8VFygdam9ndXeFAIqBcf3T3k53jDnn4hSh6uR3cQZcv5ksl9pRif4Z1
         yw7XtslcoRFCC+itwhIOnFoXZTqVkY/550UIM0FhP1oCBcnND2Hsi3/tMCNMPDKUjL4o
         AdATmh3XrI1Z7k15hB8WJUHWnVRofIjOq0QM+7d9SW6gqOWJbqo/aTCmZUqirfLFf54T
         hNIS3Nt0fQMRsUNBg4rfrdloH7cGBAUvubfIK4uuimBCl2NfO6ai+nn9H22NmiLDxUue
         OP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NVJVXWMmW6+azJuif5XHBsc9/5TTZmty+7ikIMETbWo=;
        b=gAb1IJQh2cFBmu2acHakr7V0oeJ/Kl3kMTAsTMSR3cQTx3IXoiF/GxUhSih+BfzgnA
         ZFOYUqubI9vqbcL36/kOVgqtArYOqr7qsAQIBEuOFGaL3zRXcZcCP028tRETCl4uNc56
         g49HuudSGqQ0UYpv0Sqg/VdMwTLtVdpkC/3ISe87p49rvcYdWq9Grp9p6Q5pRUKCbfq6
         RbJ8X/U7c6ixh6J4dSNhciA8JkyfmHcffsJmdpTZIhpYKO6OvECysus9ufEzRv2cHRXp
         gbrfQs2YSGCvow6pAOFgd71TY6Zt6bniny2sW7tS0sQ08D4ft2/uYY9GQQKaAqhU+fAn
         eIag==
X-Gm-Message-State: APjAAAWmzpDfOSoMxKhAoceHRN/ot2zJrp1pbrqUqJW0R9y1CdxC86p4
        xZFw7sxpnYrPpoipnDpK9rbZxDTrwB0=
X-Google-Smtp-Source: APXvYqwPwWrQz/CvqFmao8hk7+Fn7HxVrXqedKeOQ/GpSNxjE3kufMWaTaOWaPCYfpJtfVcf959caA==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr10741978wrv.198.1579951036183;
        Sat, 25 Jan 2020 03:17:16 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m21sm10394427wmi.27.2020.01.25.03.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:17:15 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: [patch net-next v2 4/4] mlx5: Use dev_net netdevice notifier registrations
Date:   Sat, 25 Jan 2020 12:17:09 +0100
Message-Id: <20200125111709.14566-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200125111709.14566-1-jiri@resnulli.us>
References: <20200125111709.14566-1-jiri@resnulli.us>
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
v1->v2:
- Rebased on top of recent changes
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h     |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     |  9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c       |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag.h       |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
 8 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index d48292ccda29..0416f7712109 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -21,6 +21,7 @@ struct mlx5e_tc_table {
 	DECLARE_HASHTABLE(hairpin_tbl, 8);
 
 	struct notifier_block     netdevice_nb;
+	struct netdev_net_notifier	netdevice_nn;
 };
 
 struct mlx5e_flow_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f3600ae4b0a1..454d3459bd8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5144,6 +5144,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
+	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -5164,7 +5165,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 		mlx5e_monitor_counter_cleanup(priv);
 
 	mlx5e_disable_async_events(priv);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove(mdev, netdev);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 09061b4c43af..7b48ccacebe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1731,7 +1731,9 @@ static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 	/* init indirect block notifications */
 	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
 	uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
-	err = register_netdevice_notifier(&uplink_priv->netdevice_nb);
+	err = register_netdevice_notifier_dev_net(rpriv->netdev,
+						  &uplink_priv->netdevice_nb,
+						  &uplink_priv->netdevice_nn);
 	if (err) {
 		mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
 		goto tc_esw_cleanup;
@@ -1770,8 +1772,12 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+
 	/* clean indirect TC block notifications */
-	unregister_netdevice_notifier(&rpriv->uplink_priv.netdevice_nb);
+	unregister_netdevice_notifier_dev_net(rpriv->netdev,
+					      &uplink_priv->netdevice_nb,
+					      &uplink_priv->netdevice_nn);
 	mlx5e_rep_indr_clean_block_privs(rpriv);
 
 	/* delete shared tc flow table */
@@ -1855,6 +1861,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 {
+	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
@@ -1863,7 +1870,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 #endif
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
-	mlx5_lag_remove(mdev);
+	mlx5_lag_remove(mdev, netdev);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
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
index 4f184c770a45..92a63467ab82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4246,7 +4246,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
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
@@ -4268,7 +4271,9 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
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

