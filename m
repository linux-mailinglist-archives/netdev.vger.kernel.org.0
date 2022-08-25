Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC185A0DFA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240709AbiHYKea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241008AbiHYKeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:34:22 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB686A3D42
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:18 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u14so24012861wrq.9
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 03:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tACOXL4/qhEsoJ4REcCtn13WGBEbq7Q9mW7ATugpK38=;
        b=J9AgNmOEZ85/KcIp5SPHqJ8yebvhtHcRsoyweDHPnzQ1lrokIFDFyx56TSGD5ZC11A
         /aUHi5yadv5/NlQotDDQwYZ+40c/r6jH8eLG4SnEk6FOxaL0DEBb+e2LClm/ICrhAL2m
         3Q2465x4BK7ZsIPedH8yOeTeuSBTDkq5U9MOFRDsp7ruidrkOMAp9pciV+DZsghouulB
         eSgWU+rVLJw+zaLpvmQ1snvXOlPdVooYOqSpK82Hfq8hAjv0lAhnU8I8pZSBgylUxRMY
         thNh253tmBaKx0l/0F4XoMt8AZ/xBAqfMxgcsqk6ZjMlNzl8bkBxto/bRInpzPPj6K44
         Bgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tACOXL4/qhEsoJ4REcCtn13WGBEbq7Q9mW7ATugpK38=;
        b=jWzY5oTzGNV5Izxh5sQpVlgPYkEoVT5c91a2X9KYjI8ergrHA8SjOA1L23PeZDsD0r
         5mhTC13CQZEhh9+thdRQHQ5rxTgYgmlie82+W2QzHAd9aANDsbxfu/6LK9RYQExtNV0J
         CBdyQouOuqP10JzUgawUinIdbCgk6HzWegdcdAW/VqdO9JKgNNtylbG1EopKLDmAAxJQ
         zTzGyWev2HBY8bA79XN+vSUR9NMMCj2X6xgHCDJ30TzRFWB+nbDIOuceZMpBV16UAQ7G
         EXubfyHZP6HQo7EdbUnJ8d//VD5clv6c6QH+VwK8us5APE5aiTtiQ+J+6J3KXulj7eVz
         zt/Q==
X-Gm-Message-State: ACgBeo2d7agYVh3dA6+uyJRxK4KzdBdTM5eqbxJDb6n6yIDOnKT8CSE/
        xI35A7c6EuKSLN6v8iu1+2V9N9RdwLjGpLXu
X-Google-Smtp-Source: AA6agR6lhxZA6/9pgTPibo49EAX97mrkA85CNdhyLhUwrJvXLCmFHk9TQ2z/oMZL8zQ44k+qDKft9g==
X-Received: by 2002:a5d:45c4:0:b0:225:4320:1401 with SMTP id b4-20020a5d45c4000000b0022543201401mr1835431wrs.474.1661423657127;
        Thu, 25 Aug 2022 03:34:17 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b0021ea1bcc300sm20141239wrb.56.2022.08.25.03.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 03:34:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next 7/7] net: devlink: convert region create/destroy() to be forbidden on registered devlink/port
Date:   Thu, 25 Aug 2022 12:34:00 +0200
Message-Id: <20220825103400.1356995-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220825103400.1356995-1-jiri@resnulli.us>
References: <20220825103400.1356995-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

No need to create or destroy region when devlink or devlink ports are
registered. Limit the possibility to call the region create/destroy()
only for non-registered devlink or devlink port. Benefit from that and
avoid need to take devl_lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 20 +++---
 drivers/net/netdevsim/dev.c                 |  8 +--
 include/net/devlink.h                       |  5 --
 net/core/devlink.c                          | 74 +++++----------------
 4 files changed, 29 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 82a07a31cde7..ac5468b77488 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -226,10 +226,10 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 
 	/* Create cr-space region */
 	crdump->region_crspace =
-		devl_region_create(devlink,
-				   &region_cr_space_ops,
-				   MAX_NUM_OF_DUMPS_TO_STORE,
-				   pci_resource_len(pdev, 0));
+		devlink_region_create(devlink,
+				      &region_cr_space_ops,
+				      MAX_NUM_OF_DUMPS_TO_STORE,
+				      pci_resource_len(pdev, 0));
 	if (IS_ERR(crdump->region_crspace))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_cr_space_str,
@@ -237,10 +237,10 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 
 	/* Create fw-health region */
 	crdump->region_fw_health =
-		devl_region_create(devlink,
-				   &region_fw_health_ops,
-				   MAX_NUM_OF_DUMPS_TO_STORE,
-				   HEALTH_BUFFER_SIZE);
+		devlink_region_create(devlink,
+				      &region_fw_health_ops,
+				      MAX_NUM_OF_DUMPS_TO_STORE,
+				      HEALTH_BUFFER_SIZE);
 	if (IS_ERR(crdump->region_fw_health))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_fw_health_str,
@@ -253,6 +253,6 @@ void mlx4_crdump_end(struct mlx4_dev *dev)
 {
 	struct mlx4_fw_crdump *crdump = &dev->persist->crdump;
 
-	devl_region_destroy(crdump->region_fw_health);
-	devl_region_destroy(crdump->region_crspace);
+	devlink_region_destroy(crdump->region_fw_health);
+	devlink_region_destroy(crdump->region_crspace);
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cd3debc9921a..a5c69888dfa6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -557,15 +557,15 @@ static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
 				      struct devlink *devlink)
 {
 	nsim_dev->dummy_region =
-		devl_region_create(devlink, &dummy_region_ops,
-				   NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
-				   NSIM_DEV_DUMMY_REGION_SIZE);
+		devlink_region_create(devlink, &dummy_region_ops,
+				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
+				      NSIM_DEV_DUMMY_REGION_SIZE);
 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
 }
 
 static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 {
-	devl_region_destroy(nsim_dev->dummy_region);
+	devlink_region_destroy(nsim_dev->dummy_region);
 }
 
 static int
diff --git a/include/net/devlink.h b/include/net/devlink.h
index bc7c423891c2..e8e7eb386acc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1692,10 +1692,6 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value init_val);
 void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
-struct devlink_region *devl_region_create(struct devlink *devlink,
-					  const struct devlink_region_ops *ops,
-					  u32 region_max_snapshots,
-					  u64 region_size);
 struct devlink_region *
 devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
@@ -1704,7 +1700,6 @@ struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
 			   const struct devlink_port_region_ops *ops,
 			   u32 region_max_snapshots, u64 region_size);
-void devl_region_destroy(struct devlink_region *region);
 void devlink_region_destroy(struct devlink_region *region);
 void devlink_port_region_destroy(struct devlink_region *region);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a9b31a05d611..988476f44900 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5765,8 +5765,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	struct sk_buff *msg;
 
 	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
 	if (IS_ERR(msg))
@@ -11204,21 +11203,22 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 EXPORT_SYMBOL_GPL(devlink_param_value_changed);
 
 /**
- * devl_region_create - create a new address region
+ * devlink_region_create - create a new address region
  *
  * @devlink: devlink
  * @ops: region operations and name
  * @region_max_snapshots: Maximum supported number of snapshots for region
  * @region_size: size of region
  */
-struct devlink_region *devl_region_create(struct devlink *devlink,
-					  const struct devlink_region_ops *ops,
-					  u32 region_max_snapshots,
-					  u64 region_size)
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots,
+		      u64 region_size)
 {
 	struct devlink_region *region;
 
-	devl_assert_locked(devlink);
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
@@ -11237,35 +11237,9 @@ struct devlink_region *devl_region_create(struct devlink *devlink,
 	INIT_LIST_HEAD(&region->snapshot_list);
 	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &devlink->region_list);
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
 	return region;
 }
-EXPORT_SYMBOL_GPL(devl_region_create);
-
-/**
- *	devlink_region_create - create a new address region
- *
- *	@devlink: devlink
- *	@ops: region operations and name
- *	@region_max_snapshots: Maximum supported number of snapshots for region
- *	@region_size: size of region
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-struct devlink_region *
-devlink_region_create(struct devlink *devlink,
-		      const struct devlink_region_ops *ops,
-		      u32 region_max_snapshots, u64 region_size)
-{
-	struct devlink_region *region;
-
-	devl_lock(devlink);
-	region = devl_region_create(devlink, ops, region_max_snapshots,
-				    region_size);
-	devl_unlock(devlink);
-	return region;
-}
 EXPORT_SYMBOL_GPL(devlink_region_create);
 
 /**
@@ -11275,8 +11249,6 @@ EXPORT_SYMBOL_GPL(devlink_region_create);
  *	@ops: region operations and name
  *	@region_max_snapshots: Maximum supported number of snapshots for region
  *	@region_size: size of region
- *
- *	Context: Takes and release devlink->lock <mutex>.
  */
 struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
@@ -11288,6 +11260,7 @@ devlink_port_region_create(struct devlink_port *port,
 	int err = 0;
 
 	ASSERT_DEVLINK_PORT_INITIALIZED(port);
+	ASSERT_DEVLINK_PORT_NOT_REGISTERED(port);
 
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
@@ -11313,7 +11286,6 @@ devlink_port_region_create(struct devlink_port *port,
 	INIT_LIST_HEAD(&region->snapshot_list);
 	mutex_init(&region->snapshot_lock);
 	list_add_tail(&region->list, &port->region_list);
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
 	devl_unlock(devlink);
 	return region;
@@ -11325,16 +11297,18 @@ devlink_port_region_create(struct devlink_port *port,
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
 
 /**
- * devl_region_destroy - destroy address region
+ * devlink_region_destroy - destroy address region
  *
  * @region: devlink region to destroy
  */
-void devl_region_destroy(struct devlink_region *region)
+void devlink_region_destroy(struct devlink_region *region)
 {
-	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	devl_assert_locked(devlink);
+	if (region->port)
+		ASSERT_DEVLINK_PORT_NOT_REGISTERED(region->port);
+	else
+		ASSERT_DEVLINK_NOT_REGISTERED(region->devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -11343,26 +11317,8 @@ void devl_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 	mutex_destroy(&region->snapshot_lock);
 
-	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
 	kfree(region);
 }
-EXPORT_SYMBOL_GPL(devl_region_destroy);
-
-/**
- *	devlink_region_destroy - destroy address region
- *
- *	@region: devlink region to destroy
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_region_destroy(struct devlink_region *region)
-{
-	struct devlink *devlink = region->devlink;
-
-	devl_lock(devlink);
-	devl_region_destroy(region);
-	devl_unlock(devlink);
-}
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
 
 /**
-- 
2.37.1

