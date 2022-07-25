Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9357FB56
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiGYI3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiGYI3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F613F64
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p5so1936272edi.12
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pw89+DzN45GYcCwc2t7iJMS+ZSgGvgiqBdhowHNCcw=;
        b=MJGhuxDLONqgi1G4m0BR8I30Yde5dJ97Y3bood7OMPlZ962Idik+zr28mJYTvQ9P9j
         6uiWV77MXJUTiYPBzgC1S/xdVtGtr7Q2opktdhtudFk925I3dd9/qYuMmeKmPkMX5u6R
         RfB5b4dglYJdJ5YX5gbdGQEPx3rw1t7HlswdvQKC1zmTdIkWNRvlsC1zOjA4DC79mmwv
         3b+SQgj6EbaVxXf01B8FiVAL2so8q/Vo2vj0kpZWGE2psd5LNuLY4fdhvVue35bvOY47
         +6+4/knSUO1TVvA8DZrxacbbSndHqr6AAuzeeWStFui7XduxqFq65CoIze4cOxWtrqkA
         ylag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pw89+DzN45GYcCwc2t7iJMS+ZSgGvgiqBdhowHNCcw=;
        b=uqUTki/XGxaGiDa9M4rYYYhVwh2HmoCVsq5BCaEJbnj1WMEUFTx24ecKLYmf2ouwJ6
         V1B68KiTkgCfFl/y9tbILkWJdbaSz2OZ3URX5dypkNBTtEEGkhTGSQ51YfOo0xYAXRck
         51xJUiBsTQBD08PKV8hBMXG6Lh0mn9uelbhT7WqQy/Bwnj4UWHPjNisQ7MI/70zdTOTm
         60idtXl9gAyzS6hqfbIZvJ0wBSCFvLaUohfKMD+TqDMItAcj65mxBjRYRN2XdRibTL+g
         GT2j/rmOcASeZaX87DmYR5aCbGIf27RG1xKHKyhguUmwlBm7w7JRy161qenHQsW+GJsp
         6ISA==
X-Gm-Message-State: AJIora/0uJ0+3mVUxQ9XzY0nzvELOSDVA4Ebu8wDmh+rwhfHR58pVF4C
        JNbgk12aeOM+u5QDp9MRn2Lr2NqwOIoY5uJb1fI=
X-Google-Smtp-Source: AGRyM1vxD+RDKYjKB+trBj4tZgjjyN3OXuhoGcha/GVwJQF08yy218QBieQvHzfcdzyAHCoFPpjl4A==
X-Received: by 2002:a05:6402:38f:b0:43b:c651:5041 with SMTP id o15-20020a056402038f00b0043bc6515041mr11745189edv.327.1658737773297;
        Mon, 25 Jul 2022 01:29:33 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bx4-20020a170906a1c400b0072a430d2abdsm5040100ejb.91.2022.07.25.01.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 04/12] mlxsw: core_linecards: Introduce per line card auxiliary device
Date:   Mon, 25 Jul 2022 10:29:17 +0200
Message-Id: <20220725082925.366455-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
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

Add the auxiliary device for provisioned line card in order to be able
to expose provisioned line card info over devlink dev info. When the
line card becomes active, there may be other additional info added to
the output.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v3->v4:
- added Ido's RVB tag
v2->v3:
- extended patch description
- added comment to mlxsw_linecard_bdev_del()
- squashed in mlxsw: "core_linecard_dev: Set nested devlink relationship
  for a line card" patch
v1->v2:
- added auxdev removal to mlxsw_linecard_fini()
- adjusted mlxsw_linecard_bdev_del() to cope with bdev == NULL
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 ++
 .../mellanox/mlxsw/core_linecard_dev.c        | 160 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  |  11 ++
 6 files changed, 194 insertions(+), 3 deletions(-)
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
index 1b61bc8f59a2..1c8b72faf9e2 100644
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
index 000000000000..b1fa9f681003
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -0,0 +1,160 @@
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
+		/* Unprovisioned line cards do not have an auxiliary device. */
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
+	struct mlxsw_linecard *linecard = linecard_bdev->linecard;
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
+	devlink_linecard_nested_dl_set(linecard->devlink_linecard, devlink);
+	return 0;
+}
+
+static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
+{
+	struct mlxsw_linecard_bdev *linecard_bdev =
+			container_of(adev, struct mlxsw_linecard_bdev, adev);
+	struct devlink *devlink = priv_to_devlink(linecard_bdev->linecard_dev);
+	struct mlxsw_linecard *linecard = linecard_bdev->linecard;
+
+	devlink_linecard_nested_dl_set(linecard->devlink_linecard, NULL);
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

