Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1514254B157
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbiFNMhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355020AbiFNMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:46 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB2C4A93F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w27so11412819edl.7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QhiXx5WHgh2Z2GBsMXg5Rdubu7r0QyOU/3MLXPP73vs=;
        b=ilAnsBezFj4WAQzdWtrekC/ncJ4KlfY0O5hIn6Kt+z+lBeiUV8x1Z3wztM3awa8vvU
         4dFdVd1kDStRDULLofJDxxzi5iFvSYgJv8Gf0KsPeotnj6ZfGBDIDXNsU/meKgTnpH6N
         hAs+8X52nVybsh09sgSXfdAszreYIeQSDd3C9OUPrhsjLnyIKTZcOaJ69MIhVq7BLUNz
         fWTnGP4qcBHQYz3vuwizAylg5zZJU4lOe+UnpNdQ+BK0mezCs6/5lpE4gPudVQAw3HqG
         FR034e1QlOBX7gKCv0pXSSImu7NnnunhKchZLh0JfXbg0quoG0xniuZ2hqSJHF+XgLJO
         oMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QhiXx5WHgh2Z2GBsMXg5Rdubu7r0QyOU/3MLXPP73vs=;
        b=wx6yfszhpM6LUwatov9xYt+Qx9S/mKD3kyyZQmmIC2K7K1QCm4nk6VMxiziuPZjQTt
         O1CMy9Te0WvEqS4z+4EoZcG5GHqVc8ACT+x9wZG4Tcae0xU2bVTNAOPB6i/sVxDngRC7
         8j5r2anSa1SKtaxVi43Uf5DY5glituFlKoN0J5kTVMGHALuu6anj+AAWXzO0hx4Yszbm
         4VvqZeaAIuouX4w7Y5XF5jMPVAWRonov51uvmdCML+9Eun1chDjptFFNYndf0SOV5bX8
         LLdKLNVH3TVmI14gxpUwhwEcCDE9KwiLfHmULk7dubm9QLuMNKnU3BtfSYkezyDEzQLW
         ZAeA==
X-Gm-Message-State: AOAM530nd35wlfEfGDPPH5B7znQLGobDBOUUAwl2I57haEHUtksNmaiA
        MSNrgNnlkTAfhzGZJ4jqF7J/RM7D7njs1QfQyTw=
X-Google-Smtp-Source: ABdhPJyKRrUyylPVbjSN1OvQOS45U/zStp+nvH5hJ6kGgGAZ9R330FN1UxO9JYJHmWEfAstSHP01vw==
X-Received: by 2002:a05:6402:5208:b0:431:3a5e:758c with SMTP id s8-20020a056402520800b004313a5e758cmr5982324edd.250.1655210010836;
        Tue, 14 Jun 2022 05:33:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z15-20020aa7cf8f000000b004307c8e1c3fsm6918822edx.34.2022.06.14.05.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line card auxiliary device
Date:   Tue, 14 Jun 2022 14:33:17 +0200
Message-Id: <20220614123326.69745-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
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

In order to be eventually able to expose line card gearbox version and
possibility to flash FW, model the line card as a separate device on
auxiliary bus.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 ++
 .../mellanox/mlxsw/core_linecard_dev.c        | 152 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  |  10 ++
 6 files changed, 185 insertions(+), 3 deletions(-)
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
index 1a465fd5d8b3..c9a773d3158b 100644
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
index fc52832241b3..8864533281bd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3331,9 +3331,15 @@ static int __init mlxsw_core_module_init(void)
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
@@ -3344,6 +3350,8 @@ static int __init mlxsw_core_module_init(void)
 
 err_alloc_ordered_workqueue:
 	destroy_workqueue(mlxsw_wq);
+err_alloc_workqueue:
+	mlxsw_linecard_driver_unregister();
 	return err;
 }
 
@@ -3351,6 +3359,7 @@ static void __exit mlxsw_core_module_exit(void)
 {
 	destroy_workqueue(mlxsw_owq);
 	destroy_workqueue(mlxsw_wq);
+	mlxsw_linecard_driver_unregister();
 }
 
 module_init(mlxsw_core_module_init);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c2a891287047..cda20a4fcbdb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/net_namespace.h>
+#include <linux/auxiliary_bus.h>
 #include <net/devlink.h>
 
 #include "trap.h"
@@ -567,6 +568,8 @@ enum mlxsw_linecard_status_event_type {
 	MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION,
 };
 
+struct mlxsw_linecard_bdev;
+
 struct mlxsw_linecard {
 	u8 slot_index;
 	struct mlxsw_linecards *linecards;
@@ -581,6 +584,7 @@ struct mlxsw_linecard {
 	   active:1;
 	u16 hw_revision;
 	u16 ini_version;
+	struct mlxsw_linecard_bdev *bdev;
 };
 
 struct mlxsw_linecard_types_info;
@@ -620,4 +624,10 @@ void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
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
index 000000000000..af70d3f7a177
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -0,0 +1,152 @@
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
+	auxiliary_device_delete(&linecard_bdev->adev);
+	auxiliary_device_uninit(&linecard_bdev->adev);
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
index 5c9869dcf674..ae51944cde0c 100644
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
-- 
2.35.3

