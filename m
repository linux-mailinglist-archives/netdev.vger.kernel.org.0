Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2332D579369
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbiGSGtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbiGSGs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:48:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A57F275E4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:54 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b11so25329926eju.10
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUQ0fezjNL0dW7+wCvEjphoydjS4KsAsm/sFhOwIea4=;
        b=qGFNIFn7vt8IC86drdMKnVX5p4ac2j2u6QpXwL63kcmyTxd8r/uJHsoM2CNIu74Phm
         ayijP/797Q+nICwv6VvkBMr4gQcq+DWf1v2xRD16XE9YstPXi1PTNTEAfK3phcKfaiMr
         DAmT/Cq66hNgajycgGiGg7F6f/3Ez0H0Z5m/8oipYVCzZrvSRXckRp9MCaGy8ePEfHJC
         W9nFm4pSeVtL/Jt/LbVLTrHkZCDi1Xe3sQvrr0ABMwwzwwv6lBey7LkNnSi9Zbf3ZVpa
         +xgpLlPihrVXVt55U0Ww00ggDXjTHYRawtiGUiGHuVN9fBLKZLe2Lqt7Kp3MWPT+SzUz
         2I0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUQ0fezjNL0dW7+wCvEjphoydjS4KsAsm/sFhOwIea4=;
        b=JdwwTrNKok4lEnVuKAjuqM7erCSFgvlGNsaIZvAK3Wf9C6t/6KofF4t10L3Ioz4I52
         bXD6zTR6jcY5m5f4OEXE2OHo6SwvjghPUltd0oxcQ391ec27GCxl2/jPD/4sjtHfBMnQ
         RVlVzDqz/XqXLHH4w+W+iR+JL07Sb+If4MESwBngfBjHdjTie7gPtgaby95iCPjmieqZ
         XM+DY033LUGWH/VKsHiYZb9tu5URtViqBINVs/mu/SdLYRlpxiI/SsK6mdrET2v7GbE9
         15hYAHVUq9a0Y6nmK7DMxkDcImnI9s52HIN5SLgZFmxTRi2WXXAwFHe3CNe4Gue9a5OR
         Q9GA==
X-Gm-Message-State: AJIora9Ly8RZZSmIREQqnNTCMaVTO2pow2hmiVPeZt/XqUUdmjK7pEpA
        YdRKwg7ZPvZrlInYfEczqxEuC9tSjyiuThvGpjA=
X-Google-Smtp-Source: AGRyM1tHCiPLecxDZWhxfSTgyY8hXpOf8ShwqzC0d/Upz/cdsK/yrFANxlWU75LrlEZIZA5eCENkzw==
X-Received: by 2002:a17:906:4fd5:b0:72e:ce13:2438 with SMTP id i21-20020a1709064fd500b0072ece132438mr27097894ejw.175.1658213333019;
        Mon, 18 Jul 2022 23:48:53 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ky13-20020a170907778d00b0072ae174cdd4sm6269283ejc.111.2022.07.18.23.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 03/12] mlxsw: core_linecards: Introduce per line card auxiliary device
Date:   Tue, 19 Jul 2022 08:48:38 +0200
Message-Id: <20220719064847.3688226-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to be eventually able to expose line card gearbox version and
possibility to flash FW, model the line card as a separate device on
auxiliary bus.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- added auxdev removal to mlxsw_linecard_fini()
- adjusted mlxsw_linecard_bdev_del() to cope with bdev == NULL
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 ++
 .../mellanox/mlxsw/core_linecard_dev.c        | 155 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  |  11 ++
 6 files changed, 189 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index 4683312861ac..a510bf2cff2f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -7,6 +7,7 @@ config MLXSW_CORE
 	tristate "Mellanox Technologies Switch ASICs support"
 	select NET_DEVLINK
 	select MLXFW
+	select AUXILIARY_BUS
 	help
 	  This driver supports Mellanox Technologies Switch ASICs family.
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index c2d6d64ffe4b..3ca9fce759ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_MLXSW_CORE)	+= mlxsw_core.o
 mlxsw_core-objs			:= core.o core_acl_flex_keys.o \
 				   core_acl_flex_actions.o core_env.o \
-				   core_linecards.o
+				   core_linecards.o core_linecard_dev.o
 mlxsw_core-$(CONFIG_MLXSW_CORE_HWMON) += core_hwmon.o
 mlxsw_core-$(CONFIG_MLXSW_CORE_THERMAL) += core_thermal.o
 obj-$(CONFIG_MLXSW_PCI)		+= mlxsw_pci.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 61eb96b93889..831b0d3472c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3334,9 +3334,15 @@ static int __init mlxsw_core_module_init(void)
 {
 	int err;
 
+	err = mlxsw_linecard_driver_register();
+	if (err)
+		return err;
+
 	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, 0, 0);
-	if (!mlxsw_wq)
-		return -ENOMEM;
+	if (!mlxsw_wq) {
+		err = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
 					    mlxsw_core_driver_name);
 	if (!mlxsw_owq) {
@@ -3347,6 +3353,8 @@ static int __init mlxsw_core_module_init(void)
 
 err_alloc_ordered_workqueue:
 	destroy_workqueue(mlxsw_wq);
+err_alloc_workqueue:
+	mlxsw_linecard_driver_unregister();
 	return err;
 }
 
@@ -3354,6 +3362,7 @@ static void __exit mlxsw_core_module_exit(void)
 {
 	destroy_workqueue(mlxsw_owq);
 	destroy_workqueue(mlxsw_wq);
+	mlxsw_linecard_driver_unregister();
 }
 
 module_init(mlxsw_core_module_init);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index a3491ef2aa7e..b22db13fa547 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/net_namespace.h>
+#include <linux/auxiliary_bus.h>
 #include <net/devlink.h>
 
 #include "trap.h"
@@ -561,6 +562,8 @@ enum mlxsw_linecard_status_event_type {
 	MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION,
 };
 
+struct mlxsw_linecard_bdev;
+
 struct mlxsw_linecard {
 	u8 slot_index;
 	struct mlxsw_linecards *linecards;
@@ -575,6 +578,7 @@ struct mlxsw_linecard {
 	   active:1;
 	u16 hw_revision;
 	u16 ini_version;
+	struct mlxsw_linecard_bdev *bdev;
 };
 
 struct mlxsw_linecard_types_info;
@@ -614,4 +618,10 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
 					  struct mlxsw_linecards_event_ops *ops,
 					  void *priv);
 
+int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard);
+void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard);
+
+int mlxsw_linecard_driver_register(void);
+void mlxsw_linecard_driver_unregister(void);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
new file mode 100644
index 000000000000..bb6068b62df0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2022 NVIDIA Corporation and Mellanox Technologies. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/idr.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <net/devlink.h>
+#include "core.h"
+
+#define MLXSW_LINECARD_DEV_ID_NAME "lc"
+
+struct mlxsw_linecard_dev {
+	struct mlxsw_linecard *linecard;
+};
+
+struct mlxsw_linecard_bdev {
+	struct auxiliary_device adev;
+	struct mlxsw_linecard *linecard;
+	struct mlxsw_linecard_dev *linecard_dev;
+};
+
+static DEFINE_IDA(mlxsw_linecard_bdev_ida);
+
+static int mlxsw_linecard_bdev_id_alloc(void)
+{
+	return ida_alloc(&mlxsw_linecard_bdev_ida, GFP_KERNEL);
+}
+
+static void mlxsw_linecard_bdev_id_free(int id)
+{
+	ida_free(&mlxsw_linecard_bdev_ida, id);
+}
+
+static void mlxsw_linecard_bdev_release(struct device *device)
+{
+	struct auxiliary_device *adev =
+			container_of(device, struct auxiliary_device, dev);
+	struct mlxsw_linecard_bdev *linecard_bdev =
+			container_of(adev, struct mlxsw_linecard_bdev, adev);
+
+	mlxsw_linecard_bdev_id_free(adev->id);
+	kfree(linecard_bdev);
+}
+
+int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_linecard_bdev *linecard_bdev;
+	int err;
+	int id;
+
+	id = mlxsw_linecard_bdev_id_alloc();
+	if (id < 0)
+		return id;
+
+	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
+	if (!linecard_bdev) {
+		mlxsw_linecard_bdev_id_free(id);
+		return -ENOMEM;
+	}
+	linecard_bdev->adev.id = id;
+	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
+	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
+	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
+	linecard_bdev->linecard = linecard;
+
+	err = auxiliary_device_init(&linecard_bdev->adev);
+	if (err) {
+		mlxsw_linecard_bdev_id_free(id);
+		kfree(linecard_bdev);
+		return err;
+	}
+
+	err = auxiliary_device_add(&linecard_bdev->adev);
+	if (err) {
+		auxiliary_device_uninit(&linecard_bdev->adev);
+		return err;
+	}
+
+	linecard->bdev = linecard_bdev;
+	return 0;
+}
+
+void mlxsw_linecard_bdev_del(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_linecard_bdev *linecard_bdev = linecard->bdev;
+
+	if (!linecard_bdev)
+		return;
+	auxiliary_device_delete(&linecard_bdev->adev);
+	auxiliary_device_uninit(&linecard_bdev->adev);
+	linecard->bdev = NULL;
+}
+
+static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
+};
+
+static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
+				     const struct auxiliary_device_id *id)
+{
+	struct mlxsw_linecard_bdev *linecard_bdev =
+			container_of(adev, struct mlxsw_linecard_bdev, adev);
+	struct mlxsw_linecard_dev *linecard_dev;
+	struct devlink *devlink;
+
+	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
+				sizeof(*linecard_dev), &adev->dev);
+	if (!devlink)
+		return -ENOMEM;
+	linecard_dev = devlink_priv(devlink);
+	linecard_dev->linecard = linecard_bdev->linecard;
+	linecard_bdev->linecard_dev = linecard_dev;
+
+	devlink_register(devlink);
+	return 0;
+}
+
+static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
+{
+	struct mlxsw_linecard_bdev *linecard_bdev =
+			container_of(adev, struct mlxsw_linecard_bdev, adev);
+	struct devlink *devlink = priv_to_devlink(linecard_bdev->linecard_dev);
+
+	devlink_unregister(devlink);
+	devlink_free(devlink);
+}
+
+static const struct auxiliary_device_id mlxsw_linecard_bdev_id_table[] = {
+	{ .name = KBUILD_MODNAME "." MLXSW_LINECARD_DEV_ID_NAME },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlxsw_linecard_bdev_id_table);
+
+static struct auxiliary_driver mlxsw_linecard_driver = {
+	.name = MLXSW_LINECARD_DEV_ID_NAME,
+	.probe = mlxsw_linecard_bdev_probe,
+	.remove = mlxsw_linecard_bdev_remove,
+	.id_table = mlxsw_linecard_bdev_id_table,
+};
+
+int mlxsw_linecard_driver_register(void)
+{
+	return auxiliary_driver_register(&mlxsw_linecard_driver);
+}
+
+void mlxsw_linecard_driver_unregister(void)
+{
+	auxiliary_driver_unregister(&mlxsw_linecard_driver);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 5c9869dcf674..43696d8badca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -232,6 +232,7 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 {
 	struct mlxsw_linecards *linecards = linecard->linecards;
 	const char *type;
+	int err;
 
 	type = mlxsw_linecard_types_lookup(linecards, card_type);
 	mlxsw_linecard_status_event_done(linecard,
@@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 	linecard->provisioned = true;
 	linecard->hw_revision = hw_revision;
 	linecard->ini_version = ini_version;
+
+	err = mlxsw_linecard_bdev_add(linecard);
+	if (err) {
+		linecard->provisioned = false;
+		mlxsw_linecard_provision_fail(linecard);
+		return err;
+	}
+
 	devlink_linecard_provision_set(linecard->devlink_linecard, type);
 	return 0;
 }
@@ -260,6 +269,7 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
 {
 	mlxsw_linecard_status_event_done(linecard,
 					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
+	mlxsw_linecard_bdev_del(linecard);
 	linecard->provisioned = false;
 	devlink_linecard_provision_clear(linecard->devlink_linecard);
 }
@@ -885,6 +895,7 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	mlxsw_core_flush_owq();
 	if (linecard->active)
 		mlxsw_linecard_active_clear(linecard);
+	mlxsw_linecard_bdev_del(linecard);
 	devlink_linecard_destroy(linecard->devlink_linecard);
 	mutex_destroy(&linecard->lock);
 }
-- 
2.35.3

