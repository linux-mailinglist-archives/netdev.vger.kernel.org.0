Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBA3A7583
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFOEDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhFOEDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68B6E6141B;
        Tue, 15 Jun 2021 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729690;
        bh=8nkBbtYj5bWEaMgdCurg50WRbD0s8YnYVtlBUvZwdCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCGUZqlsmaVPwJpd9hpSghEObGgjiLPzU5s+q2J52XBHFI2FPeDe7STFCjAdmfFJB
         Vw8fbMzzlVkMalzRpmliuCUOTFhmL1lXYyq3dhRFufGI4jLllUXvc5Saim8nbWJYfA
         yYTV1q61euAAzOE4Pt8ayMaf83qHEBlbycbLVhWuSM6CNQ5VTa3DQFRZExHKExFzzv
         Aj9ZQBaAhMI+llAcA+2aEZuL5G68d4NrcVSS5iFxL95cmdTXvQiW3SoYr2htbW8gnw
         +7tOiTT1EI38+Wga5084pRkQASsfKzzOvnvRob9ODZ7fj+3jvnWmU+QauuC1ntSch+
         wC+iV/64CgFcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Introduce API for request and release IRQs
Date:   Mon, 14 Jun 2021 21:01:13 -0700
Message-Id: <20210615040123.287101-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Introduce new API that will allow IRQs users to hold a pointer to
mlx5_irq.
In the end of this series, IRQs will be allocated on demand. Hence,
this will allow us to properly manage and use IRQs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 22 +++++++------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 19 ------------
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    | 30 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 31 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  1 +
 7 files changed, 68 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 77c0ca655975..7e7bbed3763d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -45,6 +45,7 @@
 #include "eswitch.h"
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
+#include "mlx5_irq.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -309,13 +310,19 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	mlx5_init_fbc(eq->frag_buf.frags, log_eq_stride, log_eq_size, &eq->fbc);
 	init_eq_buf(eq);
 
+	eq->irq = mlx5_irq_request(dev, vecidx);
+	if (IS_ERR(eq->irq)) {
+		err = PTR_ERR(eq->irq);
+		goto err_buf;
+	}
+
 	inlen = MLX5_ST_SZ_BYTES(create_eq_in) +
 		MLX5_FLD_SZ_BYTES(create_eq_in, pas[0]) * eq->frag_buf.npages;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
-		goto err_buf;
+		goto err_irq;
 	}
 
 	pas = (__be64 *)MLX5_ADDR_OF(create_eq_in, in, pas);
@@ -359,6 +366,8 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 err_in:
 	kvfree(in);
 
+err_irq:
+	mlx5_irq_release(eq->irq);
 err_buf:
 	mlx5_frag_buf_free(dev, &eq->frag_buf);
 	return err;
@@ -377,10 +386,9 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 int mlx5_eq_enable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		   struct notifier_block *nb)
 {
-	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	int err;
 
-	err = mlx5_irq_attach_nb(eq_table->irq_table, eq->vecidx, nb);
+	err = mlx5_irq_attach_nb(eq->irq, nb);
 	if (!err)
 		eq_update_ci(eq, 1);
 
@@ -399,9 +407,7 @@ EXPORT_SYMBOL(mlx5_eq_enable);
 void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		     struct notifier_block *nb)
 {
-	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-
-	mlx5_irq_detach_nb(eq_table->irq_table, eq->vecidx, nb);
+	mlx5_irq_detach_nb(eq->irq, nb);
 }
 EXPORT_SYMBOL(mlx5_eq_disable);
 
@@ -415,10 +421,9 @@ static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 	if (err)
 		mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
 			       eq->eqn);
-	synchronize_irq(eq->irqn);
+	mlx5_irq_release(eq->irq);
 
 	mlx5_frag_buf_free(dev, &eq->frag_buf);
-
 	return err;
 }
 
@@ -863,7 +868,6 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	}
 
 	return 0;
-
 clean:
 	destroy_comp_eqs(dev);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index f607a3858ef5..f618cf95e030 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -32,6 +32,7 @@ struct mlx5_eq {
 	unsigned int            irqn;
 	u8                      eqn;
 	struct mlx5_rsc_debug   *dbg;
+	struct mlx5_irq         *irq;
 };
 
 struct mlx5_eq_async {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 310518fabf77..390b1d3a6fde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -76,6 +76,7 @@
 #include "sf/vhca_event.h"
 #include "sf/dev/dev.h"
 #include "sf/sf.h"
+#include "mlx5_irq.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
 MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index dd95aa6eb2f8..343807ac2036 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -169,25 +169,6 @@ void mlx5_lag_remove_netdev(struct mlx5_core_dev *dev, struct net_device *netdev
 void mlx5_lag_add_mdev(struct mlx5_core_dev *dev);
 void mlx5_lag_remove_mdev(struct mlx5_core_dev *dev);
 
-int mlx5_irq_table_init(struct mlx5_core_dev *dev);
-void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
-int mlx5_irq_table_create(struct mlx5_core_dev *dev);
-void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
-int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
-		       struct notifier_block *nb);
-int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
-		       struct notifier_block *nb);
-
-int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
-			    int msix_vec_count);
-int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
-
-struct cpumask *
-mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
-struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
-int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
-struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
-
 int mlx5_events_init(struct mlx5_core_dev *dev);
 void mlx5_events_cleanup(struct mlx5_core_dev *dev);
 void mlx5_events_start(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
new file mode 100644
index 000000000000..dd138b38bf36
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_IRQ_H__
+#define __MLX5_IRQ_H__
+
+#include <linux/mlx5/driver.h>
+
+struct mlx5_irq;
+
+int mlx5_irq_table_init(struct mlx5_core_dev *dev);
+void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
+int mlx5_irq_table_create(struct mlx5_core_dev *dev);
+void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
+struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
+int mlx5_irq_get_num_comp(struct mlx5_irq_table *table);
+struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
+
+int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
+			    int msix_vec_count);
+int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
+
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx);
+void mlx5_irq_release(struct mlx5_irq *irq);
+int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
+int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb);
+struct cpumask *
+mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
+
+#endif /* __MLX5_IRQ_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 0e65ac3301c5..ecace7ca4a01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
+#include "mlx5_irq.h"
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
@@ -160,13 +161,10 @@ static void irq_put(struct mlx5_irq *irq)
 	kref_put(&irq->kref, irq_release);
 }
 
-int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
-		       struct notifier_block *nb)
+int mlx5_irq_attach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 {
-	struct mlx5_irq *irq;
 	int err;
 
-	irq = &irq_table->irq[vecidx];
 	err = kref_get_unless_zero(&irq->kref);
 	if (WARN_ON_ONCE(!err))
 		/* Something very bad happens here, we are enabling EQ
@@ -179,16 +177,31 @@ int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 	return err;
 }
 
-int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
-		       struct notifier_block *nb)
+int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 {
-	struct mlx5_irq *irq;
-
-	irq = &irq_table->irq[vecidx];
 	irq_put(irq);
 	return atomic_notifier_chain_unregister(&irq->nh, nb);
 }
 
+void mlx5_irq_release(struct mlx5_irq *irq)
+{
+	synchronize_irq(irq->irqn);
+	irq_put(irq);
+}
+
+struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, int vecidx)
+{
+	struct mlx5_irq_table *table = mlx5_irq_table_get(dev);
+	struct mlx5_irq *irq = &table->irq[vecidx];
+	int err;
+
+	err = kref_get_unless_zero(&irq->kref);
+	if (!err)
+		return ERR_PTR(-ENOENT);
+
+	return irq;
+}
+
 static irqreturn_t mlx5_irq_int_handler(int irq, void *nh)
 {
 	atomic_notifier_call_chain(nh, 0, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 2338989d4403..e8185b69ac6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -34,6 +34,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
+#include "mlx5_irq.h"
 #include "eswitch.h"
 
 static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf)
-- 
2.31.1

