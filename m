Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD08F3453
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389751AbfKGQJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53687 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389701AbfKGQJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:37 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:32 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4R007213;
        Thu, 7 Nov 2019 18:09:29 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH net-next 17/19] net/mlx5: Add mdev driver to bind to mdev devices
Date:   Thu,  7 Nov 2019 10:08:32 -0600
Message-Id: <20191107160834.21087-17-parav@mellanox.com>
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

Add a mdev driver to probe the mdev devices.

During probing mdev device,
(a) create SF device with its resources
(b) load mlx5_core and interface protocol drivers on it.

Similar remove sequence is followed during mdev device removal.

mdev device proving/removal is done by following standard kernel bus
device model.
Example:
1. Bind mdev device to mlx5_core driver.
$ echo <mdev_id> > /sys/bus/mdev/drivers/mlx5_core/bind

2. Unbind mdev device from the mlx5_core driver
$ echo <mdev_id> /sys/bus/mdev/drivers/mlx5_core/unbind

Associated netdevice and rdma device life cycle is performed with
probe() and remove() routines as part of mdev bind/unbind sequence
similar to PCI device life cycle.

Currently mlx5 core driver validates if mdev bind request is for mlx5
device or not. However it is desired to have class id based matching
scheme between mdev creator driver and mdev bind driver.
Therefore, once [1] is merged to kernel,
a new MDEV_CLASS_ID_MLX5_NET will be introduced to match against.

[1] https://patchwork.kernel.org/patch/11230357/

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 11 +++-
 .../mellanox/mlx5/core/meddev/mdev_driver.c   | 50 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 12 +++++
 4 files changed, 73 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev_driver.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 34c2c39cc0c4..cab55495014b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -77,4 +77,4 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 #
 # Mdev basic
 #
-mlx5_core-$(CONFIG_MLX5_MDEV) += meddev/sf.o meddev/mdev.o
+mlx5_core-$(CONFIG_MLX5_MDEV) += meddev/sf.o meddev/mdev.o meddev/mdev_driver.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index eb4a68a180b0..45931f516a15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -40,6 +40,9 @@
 #include <linux/io-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#ifdef CONFIG_MLX5_MDEV
+#include <linux/mdev.h>
+#endif
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
@@ -1653,7 +1656,11 @@ static int __init init(void)
 	mlx5e_init();
 #endif
 
-	return 0;
+	err = mlx5_meddev_register_driver();
+	if (err) {
+		pci_unregister_driver(&mlx5_core_driver);
+		goto err_debug;
+	}
 
 err_debug:
 	mlx5_unregister_debugfs();
@@ -1662,6 +1669,8 @@ static int __init init(void)
 
 static void __exit cleanup(void)
 {
+	mlx5_meddev_unregister_driver();
+
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev_driver.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev_driver.c
new file mode 100644
index 000000000000..61390933ff8b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/mdev_driver.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018-19 Mellanox Technologies
+
+#include <linux/module.h>
+#include <net/devlink.h>
+#include <linux/mdev.h>
+
+#include "mlx5_core.h"
+#include "meddev/sf.h"
+
+static int mlx5_meddev_probe(struct device *dev)
+{
+	struct mdev_device *meddev = mdev_from_dev(dev);
+	struct mlx5_core_dev *parent_coredev;
+	struct device *parent_dev;
+	struct mlx5_sf *sf;
+
+	parent_dev = mdev_parent_dev(meddev);
+	parent_coredev = mlx5_get_core_dev(parent_dev);
+	if (!parent_coredev)
+		return -ENODEV;
+
+	sf = mdev_get_drvdata(meddev);
+
+	return mlx5_sf_load(sf, dev, parent_coredev);
+}
+
+static void mlx5_meddev_remove(struct device *dev)
+{
+	struct mdev_device *meddev = mdev_from_dev(dev);
+	struct mlx5_sf *sf = mdev_get_drvdata(meddev);
+
+	mlx5_sf_unload(sf);
+}
+
+static struct mdev_driver mlx5_meddev_driver = {
+	.name	= KBUILD_MODNAME,
+	.probe	= mlx5_meddev_probe,
+	.remove	= mlx5_meddev_remove,
+};
+
+int mlx5_meddev_register_driver(void)
+{
+	return mdev_register_driver(&mlx5_meddev_driver, THIS_MODULE);
+}
+
+void mlx5_meddev_unregister_driver(void)
+{
+	mdev_unregister_driver(&mlx5_meddev_driver);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 5af45d61ac6f..1306984a8798 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -260,6 +260,9 @@ void mlx5_meddev_cleanup(struct mlx5_eswitch *esw);
 int mlx5_meddev_register(struct mlx5_eswitch *esw);
 void mlx5_meddev_unregister(struct mlx5_eswitch *esw);
 bool mlx5_meddev_can_and_mark_cleanup(struct mlx5_eswitch *esw);
+
+int mlx5_meddev_register_driver(void);
+void mlx5_meddev_unregister_driver(void);
 #else
 static inline void mlx5_meddev_init(struct mlx5_core_dev *dev)
 {
@@ -282,6 +285,15 @@ static inline bool mlx5_meddev_can_and_mark_cleanup(struct mlx5_eswitch *esw)
 {
 	return true;
 }
+
+static inline int mlx5_meddev_register_driver(void)
+{
+	return 0;
+}
+
+static inline void mlx5_meddev_unregister_driver(void)
+{
+}
 #endif
 
 struct mlx5_core_dev *mlx5_get_core_dev(const struct device *dev);
-- 
2.19.2

