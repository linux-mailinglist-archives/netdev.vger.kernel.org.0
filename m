Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B065E48F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjAEESr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjAEES2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEE43D9DF;
        Wed,  4 Jan 2023 20:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8214617FF;
        Thu,  5 Jan 2023 04:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141C7C433EF;
        Thu,  5 Jan 2023 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892295;
        bh=vhMKy6kTQDuQTcK34SYuhAbWBxrMVFfNSquTO3zjnDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr4iWlPLCKzASvSyj+qG0Fy/KqHsy7FcHERHG3greAB3sr+wUJTGtkApUyuVtxgeO
         9knRLaxGxEL9Gq9ZO/HDCXyi7TCSpPu80PgV3MchVobNxoplIy29ZXlHZuBMVarhMn
         /L+Kv0Uy3rRwgZGI9TWA4KChzKIjPN+sNhek3BjUkFx8gJY8EVJEHw6xZTCT5t1V/P
         LI37fkYcQ8xDxsHufgjpKuGo7mMN0IXOf0bNkXbJFT+pDZcHS0kpwI28zf29Yg7NJM
         oy7XAVcul2pIRB4Oztn/Ko6uky5V+MesPb9gfmrccNnjDO4O8HPQRxoQryQZE1a+MC
         Mv3Z+Hqvdsrgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH mlx5-next 2/8] net/mlx5e: Propagate an internal event in case uplink netdev changes
Date:   Wed,  4 Jan 2023 20:17:50 -0800
Message-Id: <20230105041756.677120-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

Whenever uplink netdev is set/cleared, propagate newly introduced event
to inform notifier blocks netdev was added/removed.

Move the set() helper to core.c from header, introduce clear() and
netdev_added_event_replay() helpers. The last one is going to be called
from rdma driver, so export it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  5 -----
 .../net/ethernet/mellanox/mlx5/core/main.c    | 20 +++++++++++++++++++
 include/linux/mlx5/device.h                   |  1 +
 include/linux/mlx5/driver.h                   |  5 +++++
 5 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a07f13dc4495..5b3b07e195d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5961,7 +5961,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	}
 
 	mlx5e_dcbnl_init_app(priv);
-	mlx5_uplink_netdev_set(mdev, netdev);
+	mlx5_core_uplink_netdev_set(mdev, netdev);
 	mlx5e_params_print_info(mdev, &priv->channels.params);
 	return 0;
 
@@ -5981,6 +5981,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	pm_message_t state = {};
 
+	mlx5_core_uplink_netdev_set(priv->mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 032adb21ad4b..bfd3a1121ed8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -96,11 +96,6 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
-static inline void mlx5_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev)
-{
-	mdev->mlx5e_res.uplink_netdev = netdev;
-}
-
 static inline struct net_device *mlx5_uplink_netdev_get(struct mlx5_core_dev *mdev)
 {
 	return mdev->mlx5e_res.uplink_netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7f5db13e3550..f64fd762ea83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -336,6 +336,24 @@ static u16 to_fw_pkey_sz(struct mlx5_core_dev *dev, u32 size)
 	}
 }
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *netdev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	dev->mlx5e_res.uplink_netdev = netdev;
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  dev->mlx5e_res.uplink_netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+EXPORT_SYMBOL(mlx5_core_uplink_netdev_event_replay);
+
 static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 				   enum mlx5_cap_type cap_type,
 				   enum mlx5_cap_mode cap_mode)
@@ -1606,6 +1624,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
@@ -1694,6 +1713,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 5fe5d198b57a..3f8ebb679c04 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -362,6 +362,7 @@ enum mlx5_event {
 
 enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_TYPE_TRAP = 0,
+	MLX5_DRIVER_EVENT_UPLINK_NETDEV,
 };
 
 enum {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..cc48aa308269 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -49,6 +49,7 @@
 #include <linux/notifier.h>
 #include <linux/refcount.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/mutex.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -674,6 +675,7 @@ struct mlx5e_resources {
 	} hw_objs;
 	struct devlink_port dl_port;
 	struct net_device *uplink_netdev;
+	struct mutex uplink_netdev_lock;
 };
 
 enum mlx5_sw_icm_type {
@@ -1011,6 +1013,9 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev);
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *mdev);
+
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
-- 
2.38.1

