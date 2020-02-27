Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8021C17115C
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgB0HWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:22:15 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44419 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgB0HWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:22:14 -0500
Received: by mail-wr1-f67.google.com with SMTP id m16so1930719wrx.11
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2oXugiNtzBrDuQzU4TGK7faHy6BjnwZR06zkJnuGuQ=;
        b=WEp+Vet7jOZrCohLveaDLwDVM30zu6WCT71OujLPKIL+htiZstD07iOBGb+8bnf4pY
         LG0lksjHd00vNqDLBeInfvYjFWiEuPXNv5e1hEbkeg/rv5kXUWe8kfPtf+n7zvrvcF+s
         YqsiD3ai+HTeeDMEPlvcXIeQ2myZt+EMx1UB2sUwEYI3cLKON3QggGUdWg2WGxb821K8
         7bcDog01UjC/HYpUNKVnZBMAn41qj+M+H57OX1xz9QSCvJtWPlIuvWwPAcMdFc18psuQ
         IC6Jy38jcWZAZk9caMly7RNT5ySG4b5o08GbXfOuh+iz3FJ66vEVkineo1a6iKeXYbEm
         2jdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c2oXugiNtzBrDuQzU4TGK7faHy6BjnwZR06zkJnuGuQ=;
        b=pg5dlqJaFEFGbyQre1K0S2eTwM/AgoQsvqFMEOv9pjB1T7cHOVwQi5fq60OXUUb6mv
         SMuRGZbKo9S2Adf1QnuegG1ZW+znrw2dvX2n/R/X8OusFv2aWD9RgmWKhuC7usixqZK7
         gN1pFSpv7QpLBOPAQ682EnwI1m8s3DySnxvDn0R/h5o4q8smPm+pykah0aNNTHLtvTwc
         aMfjXZFl4HDAMQfJ7AnZIhBZpQDwTpHDnkMozOWIVAuyNP0MbNZgl3V1oeQxQDkDwGKA
         RoOvWNdMUj3GLCW/Ibd6kkr63IhrWk61Uzd/5tG3HpTTdtnprYjOjyhyuXWCnSLAQBr2
         KKHA==
X-Gm-Message-State: APjAAAUVRFx22u5jGIgBYat68fhM6Vbq2VnmH9sWZlDxM1rovoGeYYC6
        CswwfyHUmXyFFoGaP8AqlcJ72+qLwpw=
X-Google-Smtp-Source: APXvYqwl5noVsZVld/S8/DKaCrZYxSUu2uCHo+8u5cDBA4SnPOb8oavbuGqZ/TDOeH46fKfbleONGg==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr3203796wrq.208.1582788131571;
        Wed, 26 Feb 2020 23:22:11 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id p26sm6185538wmc.24.2020.02.26.23.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:22:10 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ayal@mellanox.com,
        saeedm@mellanox.com, ranro@mellanox.com, moshe@mellanox.com
Subject: [patch net v2] mlx5: register lag notifier for init network namespace only
Date:   Thu, 27 Feb 2020 08:22:10 +0100
Message-Id: <20200227072210.1270-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The current code causes problems when the unregistering netdevice could
be different then the registering one.

Since the check in mlx5_lag_netdev_event() does not allow any other
network namespace anyway, fix this by registerting the lag notifier
per init network namespace only.

Fixes: d48834f9d4b4 ("mlx5: Use dev_net netdevice notifier registrations")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Aya Levin <ayal@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
v1->v2:
- removed unused variable
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c       | 11 +++--------
 drivers/net/ethernet/mellanox/mlx5/core/lag.h       |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 966983674663..21de4764d4c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5147,7 +5147,6 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 {
-	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
 #ifdef CONFIG_MLX5_CORE_EN_DCB
@@ -5168,7 +5167,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 		mlx5e_monitor_counter_cleanup(priv);
 
 	mlx5e_disable_async_events(priv);
-	mlx5_lag_remove(mdev, netdev);
+	mlx5_lag_remove(mdev);
 }
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7b48ccacebe2..6ed307d7f191 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1861,7 +1861,6 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 {
-	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
@@ -1870,7 +1869,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 #endif
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
-	mlx5_lag_remove(mdev, netdev);
+	mlx5_lag_remove(mdev);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index b91eabc09fbc..8e19f6ab8393 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -464,9 +464,6 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 	struct mlx5_lag *ldev;
 	int changed = 0;
 
-	if (!net_eq(dev_net(ndev), &init_net))
-		return NOTIFY_DONE;
-
 	if ((event != NETDEV_CHANGEUPPER) && (event != NETDEV_CHANGELOWERSTATE))
 		return NOTIFY_DONE;
 
@@ -586,8 +583,7 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 
 	if (!ldev->nb.notifier_call) {
 		ldev->nb.notifier_call = mlx5_lag_netdev_event;
-		if (register_netdevice_notifier_dev_net(netdev, &ldev->nb,
-							&ldev->nn)) {
+		if (register_netdevice_notifier_net(&init_net, &ldev->nb)) {
 			ldev->nb.notifier_call = NULL;
 			mlx5_core_err(dev, "Failed to register LAG netdev notifier\n");
 		}
@@ -600,7 +596,7 @@ void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev)
 }
 
 /* Must be called with intf_mutex held */
-void mlx5_lag_remove(struct mlx5_core_dev *dev, struct net_device *netdev)
+void mlx5_lag_remove(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
 	int i;
@@ -620,8 +616,7 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev, struct net_device *netdev)
 
 	if (i == MLX5_MAX_PORTS) {
 		if (ldev->nb.notifier_call)
-			unregister_netdevice_notifier_dev_net(netdev, &ldev->nb,
-							      &ldev->nn);
+			unregister_netdevice_notifier_net(&init_net, &ldev->nb);
 		mlx5_lag_mp_cleanup(ldev);
 		cancel_delayed_work_sync(&ldev->bond_work);
 		mlx5_lag_dev_free(ldev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
index 316ab09e2664..f1068aac6406 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -44,7 +44,6 @@ struct mlx5_lag {
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
 	struct notifier_block     nb;
-	struct netdev_net_notifier	nn;
 	struct lag_mp             lag_mp;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index fcce9e0fc82c..da67b28d6e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -157,7 +157,7 @@ int mlx5_query_qcam_reg(struct mlx5_core_dev *mdev, u32 *qcam,
 			u8 feature_group, u8 access_reg_group);
 
 void mlx5_lag_add(struct mlx5_core_dev *dev, struct net_device *netdev);
-void mlx5_lag_remove(struct mlx5_core_dev *dev, struct net_device *netdev);
+void mlx5_lag_remove(struct mlx5_core_dev *dev);
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
-- 
2.21.1

