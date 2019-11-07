Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B9FF344C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfKGQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:35 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53661 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389685AbfKGQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:33 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:26 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4P007213;
        Thu, 7 Nov 2019 18:09:24 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH net-next 15/19] net/mlx5: Add load/unload routines for SF driver binding
Date:   Thu,  7 Nov 2019 10:08:30 -0600
Message-Id: <20191107160834.21087-15-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SF load/unload helper routines which will be used during
binding/unbinding a SF to mlx5_core driver as mediated device.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 11 ++-
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 67 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   |  5 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  8 +++
 4 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index da96dc526aa7..eb4a68a180b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -80,7 +80,6 @@ unsigned int mlx5_core_debug_mask;
 module_param_named(debug_mask, mlx5_core_debug_mask, uint, 0644);
 MODULE_PARM_DESC(debug_mask, "debug mask: 1 = dump cmd data, 2 = dump cmd exec time, 3 = both. Default=0");
 
-#define MLX5_DEFAULT_PROF	2
 static unsigned int prof_sel = MLX5_DEFAULT_PROF;
 module_param_named(prof_sel, prof_sel, uint, 0444);
 MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
@@ -1197,8 +1196,8 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
 
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot,
-			 const struct mlx5_core_dev *irq_dev)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot,
+		  const struct mlx5_core_dev *irq_dev)
 {
 	int err = 0;
 
@@ -1256,7 +1255,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot,
 	return err;
 }
 
-static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
 	if (cleanup) {
 		mlx5_unregister_device(dev);
@@ -1288,7 +1287,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	return 0;
 }
 
-static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	int err;
@@ -1334,7 +1333,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	return err;
 }
 
-static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index d496046daed8..cfbbb2d32aca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -8,6 +8,7 @@
 #include "sf.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
+#include "devlink.h"
 
 static int
 mlx5_cmd_query_sf_partitions(struct mlx5_core_dev *mdev, u32 *out, int outlen)
@@ -205,3 +206,69 @@ u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
 {
 	return mlx5_core_is_sf_supported(dev) ? sf_table->max_sfs : 0;
 }
+
+int mlx5_sf_load(struct mlx5_sf *sf, struct device *device,
+		 const struct mlx5_core_dev *parent_dev)
+{
+	struct mlx5_core_dev *dev;
+	struct devlink *devlink;
+	int err;
+
+	devlink = mlx5_devlink_alloc();
+	if (!devlink)
+		return -ENOMEM;
+
+	dev = devlink_priv(devlink);
+	dev->device = device;
+	dev->pdev = parent_dev->pdev;
+	dev->bar_addr = sf->base_addr;
+	dev->iseg_base = sf->base_addr;
+	dev->coredev_type = MLX5_COREDEV_SF;
+
+	dev->iseg = ioremap(dev->iseg_base, sizeof(*dev->iseg));
+	if (!dev->iseg) {
+		mlx5_core_warn(dev, "remap error for sf=%d\n", sf->idx);
+		err = -ENOMEM;
+		goto remap_err;
+	}
+
+	err = mlx5_mdev_init(dev, MLX5_DEFAULT_PROF);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_mdev_init on sf=%d err=%d\n",
+			       sf->idx, err);
+		goto mdev_err;
+	}
+
+	err = mlx5_load_one(dev, true, parent_dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_load_one sf=%d err=%d\n",
+			       sf->idx, err);
+		goto load_one_err;
+	}
+	err = devlink_register(devlink, device);
+	if (err)
+		goto devlink_err;
+	sf->dev = dev;
+	return 0;
+
+devlink_err:
+	mlx5_unload_one(sf->dev, true);
+load_one_err:
+	mlx5_mdev_uninit(dev);
+mdev_err:
+	iounmap(dev->iseg);
+remap_err:
+	mlx5_devlink_free(devlink);
+	return err;
+}
+
+void mlx5_sf_unload(struct mlx5_sf *sf)
+{
+	struct devlink *devlink = priv_to_devlink(sf->dev);
+
+	devlink_unregister(devlink);
+	mlx5_unload_one(sf->dev, true);
+	mlx5_mdev_uninit(sf->dev);
+	iounmap(sf->dev->iseg);
+	mlx5_devlink_free(devlink);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
index 8ac032fdbb0b..8948c0ed8ee7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -9,6 +9,7 @@
 #include <linux/idr.h>
 
 struct mlx5_sf {
+	struct mlx5_core_dev *dev;
 	phys_addr_t base_addr;
 	u16 idx;	/* Index allocated by the SF table bitmap */
 };
@@ -50,6 +51,10 @@ u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
 u16 mlx5_get_free_sfs(struct mlx5_core_dev *dev,
 		      struct mlx5_sf_table *sf_table);
 
+int mlx5_sf_load(struct mlx5_sf *sf, struct device *device,
+		 const struct mlx5_core_dev *parent_dev);
+void mlx5_sf_unload(struct mlx5_sf *sf);
+
 #else
 static inline u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
 				    const struct mlx5_sf_table *sf_table)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 12e8c2409ee4..5af45d61ac6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -116,6 +116,8 @@ enum mlx5_semaphore_space_address {
 	MLX5_SEMAPHORE_SW_RESET         = 0x20,
 };
 
+#define MLX5_DEFAULT_PROF	2
+
 int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
 int mlx5_query_board_id(struct mlx5_core_dev *dev);
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
@@ -246,6 +248,12 @@ enum {
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
 
+int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
+void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot,
+		  const struct mlx5_core_dev *irq_dev);
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
+
 #ifdef CONFIG_MLX5_MDEV
 void mlx5_meddev_init(struct mlx5_eswitch *esw);
 void mlx5_meddev_cleanup(struct mlx5_eswitch *esw);
-- 
2.19.2

