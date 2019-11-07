Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A74AF3448
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389673AbfKGQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53637 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389598AbfKGQJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:28 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:24 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4O007213;
        Thu, 7 Nov 2019 18:09:21 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 14/19] net/mlx5: Share irqs between SFs and parent PCI device
Date:   Thu,  7 Nov 2019 10:08:29 -0600
Message-Id: <20191107160834.21087-14-parav@mellanox.com>
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

From: Yuval Avnery <yuvalav@mellanox.com>

Sub function devices share IRQ vectors with their parent PCI
device's mlx5_core_dev.

When a SF device loads, instead of creating an IRQ table, refer to
the IRQ table of the parent mlx5_core_dev.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c      |  6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h  |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    | 14 ++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 12 ++++++++++++
 include/linux/mlx5/driver.h                       |  8 +++++++-
 5 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 580c71cb9dfa..6213b3c9df80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -41,6 +41,7 @@
 #include <linux/cpu_rmap.h>
 #endif
 #include "mlx5_core.h"
+#include "meddev/sf.h"
 #include "lib/eq.h"
 #include "fpga/core.h"
 #include "eswitch.h"
@@ -412,7 +413,8 @@ void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 			      eq->eqn, cq->cqn);
 }
 
-int mlx5_eq_table_init(struct mlx5_core_dev *dev)
+int mlx5_eq_table_init(struct mlx5_core_dev *dev,
+		       const struct mlx5_core_dev *irq_dev)
 {
 	struct mlx5_eq_table *eq_table;
 	int i;
@@ -429,7 +431,7 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 	for (i = 0; i < MLX5_EVENT_TYPE_MAX; i++)
 		ATOMIC_INIT_NOTIFIER_HEAD(&eq_table->nh[i]);
 
-	eq_table->irq_table = dev->priv.irq_table;
+	eq_table->irq_table = irq_dev->priv.irq_table;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4be4d2d36218..b28b76c77b28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -69,7 +69,8 @@ static inline void eq_update_ci(struct mlx5_eq *eq, int arm)
 	mb();
 }
 
-int mlx5_eq_table_init(struct mlx5_core_dev *dev);
+int mlx5_eq_table_init(struct mlx5_core_dev *dev,
+		       const struct mlx5_core_dev *irq_dev);
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_eq_table_create(struct mlx5_core_dev *dev);
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 092e2c90caf1..da96dc526aa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -828,7 +828,8 @@ static void mlx5_pci_close(struct mlx5_core_dev *dev)
 	mlx5_pci_disable_device(dev);
 }
 
-static int mlx5_init_once(struct mlx5_core_dev *dev)
+static int mlx5_init_once(struct mlx5_core_dev *dev,
+			  const struct mlx5_core_dev *irq_dev)
 {
 	int err;
 
@@ -849,7 +850,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_devcom;
 	}
 
-	err = mlx5_eq_table_init(dev);
+	err = mlx5_eq_table_init(dev, irq_dev);
 	if (err) {
 		mlx5_core_err(dev, "failed to initialize eq\n");
 		goto err_irq_cleanup;
@@ -1196,7 +1197,8 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
 
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot,
+			 const struct mlx5_core_dev *irq_dev)
 {
 	int err = 0;
 
@@ -1214,7 +1216,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		goto out;
 
 	if (boot) {
-		err = mlx5_init_once(dev);
+		err = mlx5_init_once(dev, irq_dev);
 		if (err) {
 			mlx5_core_err(dev, "sw objs init failed\n");
 			goto function_teardown;
@@ -1370,7 +1372,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto pci_init_err;
 	}
 
-	err = mlx5_load_one(dev, true);
+	err = mlx5_load_one(dev, true, dev);
 	if (err) {
 		mlx5_core_err(dev, "mlx5_load_one failed with error code %d\n",
 			      err);
@@ -1501,7 +1503,7 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "%s was called\n", __func__);
 
-	err = mlx5_load_one(dev, false);
+	err = mlx5_load_one(dev, false, dev);
 	if (err)
 		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
 			      __func__, err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 373981a659c7..571246cea8c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -30,6 +30,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *irq_table;
 
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	irq_table = kvzalloc(sizeof(*irq_table), GFP_KERNEL);
 	if (!irq_table)
 		return -ENOMEM;
@@ -40,6 +43,9 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
 {
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	kvfree(dev->priv.irq_table);
 }
 
@@ -268,6 +274,9 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	int nvec;
 	int err;
 
+	if (mlx5_core_is_sf(dev))
+		return 0;
+
 	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
 	       MLX5_IRQ_VEC_COMP_BASE;
 	nvec = min_t(int, nvec, num_eqs);
@@ -319,6 +328,9 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 	struct mlx5_irq_table *table = dev->priv.irq_table;
 	int i;
 
+	if (mlx5_core_is_sf(dev))
+		return;
+
 	/* free_irq requires that affinity and rmap will be cleared
 	 * before calling it. This is why there is asymmetry with set_rmap
 	 * which should be called after alloc_irq but before request_irq.
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7b4801e96feb..88fc74eb3c66 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -186,7 +186,8 @@ enum port_state_policy {
 
 enum mlx5_coredev_type {
 	MLX5_COREDEV_PF,
-	MLX5_COREDEV_VF
+	MLX5_COREDEV_VF,
+	MLX5_COREDEV_SF
 };
 
 struct mlx5_field_desc {
@@ -1126,6 +1127,11 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 	return dev->coredev_type == MLX5_COREDEV_VF;
 }
 
+static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
+{
+	return dev->coredev_type == MLX5_COREDEV_SF;
+}
+
 static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
-- 
2.19.2

