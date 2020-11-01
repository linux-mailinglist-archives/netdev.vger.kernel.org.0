Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678B72A2157
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 21:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKAUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 15:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgKAUQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 15:16:09 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90DF422253;
        Sun,  1 Nov 2020 20:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604261767;
        bh=8EABCCZjLf1CkwolTvuadQrO3kU7oPMgz6kBzbzlbBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ssMzIrfOAt5yJyOLTUEo9jzyGk8kzuxlu0VDJEzxJqwL6NywCWdW9ZSXU18yo1qu
         uqPeNrPPp1UmtdsbcOPd3yAD/tK3tnAMfaTGsBSl4TkxwDCnOggzvtO6YI18zTSt8s
         tOtf0zluv/zDUV1X20ZZzskM6y3epyVJE1Ft86Qc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next v1 06/11] vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus
Date:   Sun,  1 Nov 2020 22:15:37 +0200
Message-Id: <20201101201542.2027568-7-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101201542.2027568-1-leon@kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Change module registration logic to use auxiliary bus instead of custom
made mlx5 register interface.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 28 ++++++-
 drivers/vdpa/mlx5/Makefile                    |  2 +-
 drivers/vdpa/mlx5/net/main.c                  | 76 -------------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c             | 51 +++++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.h             | 24 ------
 5 files changed, 72 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/vdpa/mlx5/net/main.c
 delete mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 8ddf469b2d05..76eb09f4adba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -31,6 +31,7 @@
  */

 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/mlx5_ifc_vdpa.h>
 #include "mlx5_core.h"

 static LIST_HEAD(intf_list);
@@ -51,10 +52,35 @@ enum {
 	MLX5_INTERFACE_ATTACHED,
 };

+static bool is_vnet_supported(struct mlx5_core_dev *dev)
+{
+	if (!IS_ENABLED(CONFIG_MLX5_VDPA_NET))
+		return false;
+
+	if (mlx5_core_is_pf(dev))
+		return false;
+
+	if (!(MLX5_CAP_GEN_64(dev, general_obj_types) &
+	      MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q))
+		return false;
+
+	if (!(MLX5_CAP_DEV_VDPA_EMULATION(dev, event_mode) &
+	      MLX5_VIRTIO_Q_EVENT_MODE_QP_MODE))
+		return false;
+
+	if (!MLX5_CAP_DEV_VDPA_EMULATION(dev, eth_frame_offload_type))
+		return false;
+
+	return true;
+}
+
 static const struct mlx5_adev_device {
 	const char *suffix;
 	bool (*is_supported)(struct mlx5_core_dev *dev);
-} mlx5_adev_devices[1] = {};
+} mlx5_adev_devices[] = {
+	[MLX5_INTERFACE_PROTOCOL_VDPA] = { .suffix = "vnet",
+					   .is_supported = &is_vnet_supported },
+};

 int mlx5_adev_idx_alloc(void)
 {
diff --git a/drivers/vdpa/mlx5/Makefile b/drivers/vdpa/mlx5/Makefile
index 89a5bededc9f..f717978c83bf 100644
--- a/drivers/vdpa/mlx5/Makefile
+++ b/drivers/vdpa/mlx5/Makefile
@@ -1,4 +1,4 @@
 subdir-ccflags-y += -I$(srctree)/drivers/vdpa/mlx5/core

 obj-$(CONFIG_MLX5_VDPA_NET) += mlx5_vdpa.o
-mlx5_vdpa-$(CONFIG_MLX5_VDPA_NET) += net/main.o net/mlx5_vnet.o core/resources.o core/mr.o
+mlx5_vdpa-$(CONFIG_MLX5_VDPA_NET) += net/mlx5_vnet.o core/resources.o core/mr.o
diff --git a/drivers/vdpa/mlx5/net/main.c b/drivers/vdpa/mlx5/net/main.c
deleted file mode 100644
index 4dd3f00f2306..000000000000
--- a/drivers/vdpa/mlx5/net/main.c
+++ /dev/null
@@ -1,76 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2020 Mellanox Technologies Ltd. */
-
-#include <linux/module.h>
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/device.h>
-#include <linux/mlx5/mlx5_ifc_vdpa.h>
-#include "mlx5_vnet.h"
-
-MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
-MODULE_DESCRIPTION("Mellanox VDPA driver");
-MODULE_LICENSE("Dual BSD/GPL");
-
-static bool required_caps_supported(struct mlx5_core_dev *mdev)
-{
-	u8 event_mode;
-	u64 got;
-
-	got = MLX5_CAP_GEN_64(mdev, general_obj_types);
-
-	if (!(got & MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q))
-		return false;
-
-	event_mode = MLX5_CAP_DEV_VDPA_EMULATION(mdev, event_mode);
-	if (!(event_mode & MLX5_VIRTIO_Q_EVENT_MODE_QP_MODE))
-		return false;
-
-	if (!MLX5_CAP_DEV_VDPA_EMULATION(mdev, eth_frame_offload_type))
-		return false;
-
-	return true;
-}
-
-static void *mlx5_vdpa_add(struct mlx5_core_dev *mdev)
-{
-	struct mlx5_vdpa_dev *vdev;
-
-	if (mlx5_core_is_pf(mdev))
-		return NULL;
-
-	if (!required_caps_supported(mdev)) {
-		dev_info(mdev->device, "virtio net emulation not supported\n");
-		return NULL;
-	}
-	vdev = mlx5_vdpa_add_dev(mdev);
-	if (IS_ERR(vdev))
-		return NULL;
-
-	return vdev;
-}
-
-static void mlx5_vdpa_remove(struct mlx5_core_dev *mdev, void *context)
-{
-	struct mlx5_vdpa_dev *vdev = context;
-
-	mlx5_vdpa_remove_dev(vdev);
-}
-
-static struct mlx5_interface mlx5_vdpa_interface = {
-	.add = mlx5_vdpa_add,
-	.remove = mlx5_vdpa_remove,
-	.protocol = MLX5_INTERFACE_PROTOCOL_VDPA,
-};
-
-static int __init mlx5_vdpa_init(void)
-{
-	return mlx5_register_interface(&mlx5_vdpa_interface);
-}
-
-static void __exit mlx5_vdpa_exit(void)
-{
-	mlx5_unregister_interface(&mlx5_vdpa_interface);
-}
-
-module_init(mlx5_vdpa_init);
-module_exit(mlx5_vdpa_exit);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6c218b47b9f1..5316e51e72d4 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1,18 +1,27 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies Ltd. */

+#include <linux/module.h>
 #include <linux/vdpa.h>
+#include <linux/vringh.h>
+#include <uapi/linux/virtio_net.h>
 #include <uapi/linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/device.h>
+#include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
-#include <linux/mlx5/device.h>
 #include <linux/mlx5/mlx5_ifc_vdpa.h>
-#include "mlx5_vnet.h"
 #include "mlx5_vdpa.h"

+MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
+MODULE_DESCRIPTION("Mellanox VDPA driver");
+MODULE_LICENSE("Dual BSD/GPL");
+
+#define to_mlx5_vdpa_ndev(__mvdev) container_of(__mvdev, struct mlx5_vdpa_net, mvdev)
 #define to_mvdev(__vdev) container_of((__vdev), struct mlx5_vdpa_dev, vdev)

 #define VALID_FEATURES_MASK                                                                        \
@@ -159,6 +168,11 @@ static bool mlx5_vdpa_debug;
 			mlx5_vdpa_info(mvdev, "%s\n", #_status);                                   \
 	} while (0)

+static inline u32 mlx5_vdpa_max_qps(int max_vqs)
+{
+	return max_vqs / 2;
+}
+
 static void print_status(struct mlx5_vdpa_dev *mvdev, u8 status, bool set)
 {
 	if (status & ~VALID_STATUS_MASK)
@@ -1928,8 +1942,11 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
 	}
 }

-void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
+static int mlx5v_probe(struct auxiliary_device *adev,
+		       const struct auxiliary_device_id *id)
 {
+	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = madev->mdev;
 	struct virtio_net_config *config;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
@@ -1943,7 +1960,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
 				 2 * mlx5_vdpa_max_qps(max_vqs));
 	if (IS_ERR(ndev))
-		return ndev;
+		return PTR_ERR(ndev);

 	ndev->mvdev.max_vqs = max_vqs;
 	mvdev = &ndev->mvdev;
@@ -1972,7 +1989,8 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_reg;

-	return ndev;
+	dev_set_drvdata(&adev->dev, ndev);
+	return 0;

 err_reg:
 	free_resources(ndev);
@@ -1981,10 +1999,29 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 err_mtu:
 	mutex_destroy(&ndev->reslock);
 	put_device(&mvdev->vdev.dev);
-	return ERR_PTR(err);
+	return err;
 }

-void mlx5_vdpa_remove_dev(struct mlx5_vdpa_dev *mvdev)
+static int mlx5v_remove(struct auxiliary_device *adev)
 {
+	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
+
 	vdpa_unregister_device(&mvdev->vdev);
+	return 0;
 }
+
+static const struct auxiliary_device_id mlx5v_id_table[] = {
+	{ .name = MLX5_ADEV_NAME ".vnet", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, mlx5v_id_table);
+
+static struct auxiliary_driver mlx5v_driver = {
+	.name = "vnet",
+	.probe = mlx5v_probe,
+	.remove = mlx5v_remove,
+	.id_table = mlx5v_id_table,
+};
+
+module_auxiliary_driver(mlx5v_driver);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.h b/drivers/vdpa/mlx5/net/mlx5_vnet.h
deleted file mode 100644
index f2d6d68b020e..000000000000
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2020 Mellanox Technologies Ltd. */
-
-#ifndef __MLX5_VNET_H_
-#define __MLX5_VNET_H_
-
-#include <linux/vdpa.h>
-#include <linux/virtio_net.h>
-#include <linux/vringh.h>
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/cq.h>
-#include <linux/mlx5/qp.h>
-#include "mlx5_vdpa.h"
-
-static inline u32 mlx5_vdpa_max_qps(int max_vqs)
-{
-	return max_vqs / 2;
-}
-
-#define to_mlx5_vdpa_ndev(__mvdev) container_of(__mvdev, struct mlx5_vdpa_net, mvdev)
-void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev);
-void mlx5_vdpa_remove_dev(struct mlx5_vdpa_dev *mvdev);
-
-#endif /* __MLX5_VNET_H_ */
--
2.28.0

