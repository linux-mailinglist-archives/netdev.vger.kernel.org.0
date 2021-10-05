Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E7421B9D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJEBRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhJEBQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DAEC615A4;
        Tue,  5 Oct 2021 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396489;
        bh=90mJnXjCArWb+OrDlHGP662GsiATsbTn6mpEXF6Y2tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvZqGyUkjIQYJB4obg56/VTle5uLClWrwfvnXD8xRquzRuZ4zsJbzOQSZ5h4FxA0c
         H+LnW0Fskf4LE0eTs493j2syysx6Z3D2Sygi/Mj+nrx/vEwzd0GLXQtyuBBmxwpGwu
         lntgemhxmWoQ06e/SiobPqpQswQB+if/uivL634gXhTTT2gSSDx6bHfCUosRZvh6fi
         N14SHlsug2b8GR9LuVqZc21tQYjooQliZQ3I9cw3prgpIoK5lcH87yscfu9bGpePdq
         +/YRy5kYjpmvChVTc4AKa+B93BQPFxAREKs7/Qv2VU5TS1UtLYjxWDIWad/6bIISOs
         HtTmH+L5Ih7jw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Shift control IRQ to the last index
Date:   Mon,  4 Oct 2021 18:13:01 -0700
Message-Id: <20211005011302.41793-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Control IRQ is the first IRQ vector. This complicates handling of
completion irqs as we need to offset them by one.
in the next patch, there are scenarios where completion and control EQs
will share the same irq. for example: functions with single IRQ. To ease
such scenarios, we shift control IRQ to the end of the irq array.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c                   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 10 +++++-----
 include/linux/mlx5/driver.h                        |  2 ++
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d0d98e584ebc..81147d774dd2 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1559,6 +1559,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 
 	eq->irq_nb.notifier_call = mlx5_ib_eq_pf_int;
 	param = (struct mlx5_eq_param) {
+		.irq_index = MLX5_IRQ_EQ_CTRL,
 		.nent = MLX5_IB_NUM_PF_EQE,
 	};
 	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_FAULT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 605c8ecc3610..792e0d6aa861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -632,6 +632,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
 
 	param = (struct mlx5_eq_param) {
+		.irq_index = MLX5_IRQ_EQ_CTRL,
 		.nent = MLX5_NUM_CMD_EQE,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD,
 	};
@@ -644,6 +645,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	mlx5_cmd_allowed_opcode(dev, CMD_ALLOWED_OPCODE_ALL);
 
 	param = (struct mlx5_eq_param) {
+		.irq_index = MLX5_IRQ_EQ_CTRL,
 		.nent = MLX5_NUM_ASYNC_EQE,
 	};
 
@@ -653,6 +655,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 		goto err2;
 
 	param = (struct mlx5_eq_param) {
+		.irq_index = MLX5_IRQ_EQ_CTRL,
 		.nent = /* TODO: sriov max_vf + */ 1,
 		.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST,
 	};
@@ -806,8 +809,8 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	ncomp_eqs = table->num_comp_eqs;
 	nent = MLX5_COMP_EQ_SIZE;
 	for (i = 0; i < ncomp_eqs; i++) {
-		int vecidx = i + MLX5_IRQ_VEC_COMP_BASE;
 		struct mlx5_eq_param param = {};
+		int vecidx = i;
 
 		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
 		if (!eq) {
@@ -953,9 +956,7 @@ static int set_rmap(struct mlx5_core_dev *mdev)
 		goto err_out;
 	}
 
-	vecidx = MLX5_IRQ_VEC_COMP_BASE;
-	for (; vecidx < eq_table->num_comp_eqs + MLX5_IRQ_VEC_COMP_BASE;
-	     vecidx++) {
+	for (vecidx = 0; vecidx < eq_table->num_comp_eqs; vecidx++) {
 		err = irq_cpu_rmap_add(eq_table->rmap,
 				       pci_irq_vector(mdev->pdev, vecidx));
 		if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index abd024173c42..8116815663a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -8,8 +8,6 @@
 
 #define MLX5_COMP_EQS_PER_SF 8
 
-#define MLX5_IRQ_EQ_CTRL (0)
-
 struct mlx5_irq;
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 763c83a02380..a66144b54fc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -194,15 +194,14 @@ static void irq_sf_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 	snprintf(name, MLX5_MAX_IRQ_NAME, "%s%d", pool->name, vecidx);
 }
 
-static void irq_set_name(char *name, int vecidx)
+static void irq_set_name(struct mlx5_irq_pool *pool, char *name, int vecidx)
 {
-	if (vecidx == 0) {
+	if (vecidx == pool->xa_num_irqs.max) {
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_async%d", vecidx);
 		return;
 	}
 
-	snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d",
-		 vecidx - MLX5_IRQ_VEC_COMP_BASE);
+	snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", vecidx);
 }
 
 static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
@@ -217,7 +216,7 @@ static struct mlx5_irq *irq_request(struct mlx5_irq_pool *pool, int i)
 		return ERR_PTR(-ENOMEM);
 	irq->irqn = pci_irq_vector(dev->pdev, i);
 	if (!pool->name[0])
-		irq_set_name(name, i);
+		irq_set_name(pool, name, i);
 	else
 		irq_sf_set_name(pool, name, i);
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
@@ -440,6 +439,7 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 	}
 pf_irq:
 	pool = irq_table->pf_pool;
+	vecidx = (vecidx == MLX5_IRQ_EQ_CTRL) ? pool->xa_num_irqs.max : vecidx;
 	irq = irq_pool_request_vector(pool, vecidx, affinity);
 out:
 	if (IS_ERR(irq))
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index e23417424373..0ca719c00824 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -59,6 +59,8 @@
 
 #define MLX5_ADEV_NAME "mlx5_core"
 
+#define MLX5_IRQ_EQ_CTRL (U8_MAX)
+
 enum {
 	MLX5_BOARD_ID_LEN = 64,
 };
-- 
2.31.1

