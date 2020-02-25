Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88B16BD39
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 10:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgBYJZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 04:25:50 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33888 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbgBYJZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 04:25:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id i10so663607wmd.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 01:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FvcYTWOjERRwmHvUiPH05ZvRImLwQfvuQehAPXoTrzc=;
        b=2RTpyD5li6uacEavhXaQUO6odvLqCFIMhOOsCQda5uTPvfa3k3vEI4cQ9k6+q8GDLN
         W0heHrxaolccnuvq/mAvG7fIvG2FxyAXZJEBwcdk1C4TLY3UgG4JuPVLseXMLel/26vG
         al8K1q/DApkG9yD+aALCzJibqOYmIS6mA9WMR/Y0PCJamgE2a9DXcqwoyrSA1UIKyd7O
         VdufOPZGxViutEA5g7zvKThgwwnYFE8fJR4AF15A4fZTlNWRLQTHrKeGnpaRLc+i8VSt
         3rA+fiKwLdId3odulc4ndD5h+5zi+jUDzm6mSAj5ymGW3AQXuVS1KXTbpGwduKLonyvI
         xHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FvcYTWOjERRwmHvUiPH05ZvRImLwQfvuQehAPXoTrzc=;
        b=gGcy6tCs5GssUbN550RKP7DDW/WwoXfC4JebWEyCF+1I/npYtPdDoH1LvHMYKJI2cn
         yHvdJUFQ1q00T4+R4W8dx79cu11glwCbSVw95ljVxNmrlTD5uTZinBFPmIADditobJKM
         uVKstJ0R1DEMan3oGNCrrixfSvW2LIOwIdSXepdAhF9WXtEOKf+071mHFelL2Q8Au1fP
         ekQ0F0FmEIuLatlsE7XhSMshQ5X8RFJpJiETODlIWPr/XHG+kMh5n3paaxh0szEHhFon
         Lx8Hk8YQEslvaqXR4lRVRI9B9pJbO9zArKtrttITwuuOL+o8Mrfew+BVcHjnCj0piVMo
         8ewA==
X-Gm-Message-State: APjAAAXWC3GurliHVN97VCN9Do5OxPwpYVzOMEzZpVwjvdxv8zOZLXhi
        7Cs5lm0EAFmy9ttJVonIJTOjXxiakJ4=
X-Google-Smtp-Source: APXvYqx2YHkFA6VWuiMxLjAzdubJxYeOK01IPJH5oaMP4VmtsXXZsFjco3/Un2F06I3XBTsdTjTkeg==
X-Received: by 2002:a1c:b603:: with SMTP id g3mr4177833wmf.130.1582622747793;
        Tue, 25 Feb 2020 01:25:47 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a26sm3291070wmm.18.2020.02.25.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 01:25:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ayal@mellanox.com,
        saeedm@mellanox.com, ranro@mellanox.com, moshe@mellanox.com
Subject: [patch net] mlx5: register lag notifier for init network namespace only
Date:   Tue, 25 Feb 2020 10:25:46 +0100
Message-Id: <20200225092546.30710-1-jiri@resnulli.us>
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
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c       | 11 +++--------
 drivers/net/ethernet/mellanox/mlx5/core/lag.h       |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
 5 files changed, 6 insertions(+), 13 deletions(-)

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
index 7b48ccacebe2..3e4362dec4db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1870,7 +1870,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
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

