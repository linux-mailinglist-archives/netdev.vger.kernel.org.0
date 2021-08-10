Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC603E51B2
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhHJEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhHJEAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F49860F8F;
        Tue, 10 Aug 2021 03:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567985;
        bh=zkzs5xzHH72i4OD3qa+kFTySbS0Phg2T6G1WVVNBRjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gro9lir3nwdRZbwEcJVbhz8kpXaDI9br7LQeiXlY5lL48HcgTmU64pGHyWofYapN6
         dXcAKn4OldaWJWJR4JHv+h2Sl1FwRVvYSRPclkAMUYGTbrRXhOr/nUmoYwHMz3zw+7
         l9Q1UfyuAkKL1roG75e7lvAzOQ7CICWg/DPoN4bGIPwwsMzSfivi/4BSHOmYZbwOkx
         5IjU8fHvjJWRzoa/ZYQjOZGvXAqpaFb/x5pmxRr3Mwtp3AcaeB1/uMmIa+UkBKoWWC
         u7IuQmUoxRE05jodQtpqVNCGA66P3o1nz5+4WQMltCVhNRt2bsCN07Zn/7hd3jPayr
         Y8UtvY7fiiWrA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/12] net/mlx5: Synchronize correct IRQ when destroying CQ
Date:   Mon,  9 Aug 2021 20:59:22 -0700
Message-Id: <20210810035923.345745-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

The CQ destroy is performed based on the IRQ number that is stored in
cq->irqn. That number wasn't set explicitly during CQ creation and as
expected some of the API users of mlx5_core_create_cq() forgot to update
it.

This caused to wrong synchronization call of the wrong IRQ with a number
0 instead of the real one.

As a fix, set the IRQ number directly in the mlx5_core_create_cq() and
update all users accordingly.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Fixes: ef1659ade359 ("IB/mlx5: Add DEVX support for CQ events")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c               |  4 +---
 drivers/infiniband/hw/mlx5/devx.c             |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++----------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 20 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  4 +---
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 ++
 .../mellanox/mlx5/core/steering/dr_send.c     |  4 +---
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  3 +--
 include/linux/mlx5/driver.h                   |  3 +--
 10 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 7abeb576b3c5..b8e5e371bb19 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -945,7 +945,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	u32 *cqb = NULL;
 	void *cqc;
 	int cqe_size;
-	unsigned int irqn;
 	int eqn;
 	int err;
 
@@ -984,7 +983,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		INIT_WORK(&cq->notify_work, notify_soft_wc_handler);
 	}
 
-	err = mlx5_vector2eqn(dev->mdev, vector, &eqn, &irqn);
+	err = mlx5_vector2eqn(dev->mdev, vector, &eqn);
 	if (err)
 		goto err_cqb;
 
@@ -1007,7 +1006,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		goto err_cqb;
 
 	mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
-	cq->mcq.irqn = irqn;
 	if (udata)
 		cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
 	else
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index eb9b0a2707f8..c869b2a91a28 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -975,7 +975,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	struct mlx5_ib_dev *dev;
 	int user_vector;
 	int dev_eqn;
-	unsigned int irqn;
 	int err;
 
 	if (uverbs_copy_from(&user_vector, attrs,
@@ -987,7 +986,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 		return PTR_ERR(c);
 	dev = to_mdev(c->ibucontext.device);
 
-	err = mlx5_vector2eqn(dev->mdev, user_vector, &dev_eqn, &irqn);
+	err = mlx5_vector2eqn(dev->mdev, user_vector, &dev_eqn);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index df3e4938ecdd..360e093874d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -134,6 +134,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			      cq->cqn);
 
 	cq->uar = dev->priv.uar;
+	cq->irqn = eq->core.irqn;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index fd250f7bcd88..24f919ef9b8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1535,15 +1535,9 @@ static int mlx5e_alloc_cq_common(struct mlx5e_priv *priv,
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5_core_cq *mcq = &cq->mcq;
-	int eqn_not_used;
-	unsigned int irqn;
 	int err;
 	u32 i;
 
-	err = mlx5_vector2eqn(mdev, param->eq_ix, &eqn_not_used, &irqn);
-	if (err)
-		return err;
-
 	err = mlx5_cqwq_create(mdev, &param->wq, param->cqc, &cq->wq,
 			       &cq->wq_ctrl);
 	if (err)
@@ -1557,7 +1551,6 @@ static int mlx5e_alloc_cq_common(struct mlx5e_priv *priv,
 	mcq->vector     = param->eq_ix;
 	mcq->comp       = mlx5e_completion_event;
 	mcq->event      = mlx5e_cq_error_event;
-	mcq->irqn       = irqn;
 
 	for (i = 0; i < mlx5_cqwq_get_size(&cq->wq); i++) {
 		struct mlx5_cqe64 *cqe = mlx5_cqwq_get_wqe(&cq->wq, i);
@@ -1605,11 +1598,10 @@ static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
 	void *in;
 	void *cqc;
 	int inlen;
-	unsigned int irqn_not_used;
 	int eqn;
 	int err;
 
-	err = mlx5_vector2eqn(mdev, param->eq_ix, &eqn, &irqn_not_used);
+	err = mlx5_vector2eqn(mdev, param->eq_ix, &eqn);
 	if (err)
 		return err;
 
@@ -1983,9 +1975,8 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	struct mlx5e_channel *c;
 	unsigned int irq;
 	int err;
-	int eqn;
 
-	err = mlx5_vector2eqn(priv->mdev, ix, &eqn, &irq);
+	err = mlx5_vector2irqn(priv->mdev, ix, &irq);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 6e074cc457de..605c8ecc3610 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -855,8 +855,8 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	return err;
 }
 
-int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
-		    unsigned int *irqn)
+static int vector2eqnirqn(struct mlx5_core_dev *dev, int vector, int *eqn,
+			  unsigned int *irqn)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 	struct mlx5_eq_comp *eq, *n;
@@ -865,8 +865,10 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		if (i++ == vector) {
-			*eqn = eq->core.eqn;
-			*irqn = eq->core.irqn;
+			if (irqn)
+				*irqn = eq->core.irqn;
+			if (eqn)
+				*eqn = eq->core.eqn;
 			err = 0;
 			break;
 		}
@@ -874,8 +876,18 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 
 	return err;
 }
+
+int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn)
+{
+	return vector2eqnirqn(dev, vector, eqn, NULL);
+}
 EXPORT_SYMBOL(mlx5_vector2eqn);
 
+int mlx5_vector2irqn(struct mlx5_core_dev *dev, int vector, unsigned int *irqn)
+{
+	return vector2eqnirqn(dev, vector, NULL, irqn);
+}
+
 unsigned int mlx5_comp_vectors_count(struct mlx5_core_dev *dev)
 {
 	return dev->priv.eq_table->num_comp_eqs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index bd66ab2af5b5..d5da4ab65766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -417,7 +417,6 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	struct mlx5_wq_param wqp;
 	struct mlx5_cqe64 *cqe;
 	int inlen, err, eqn;
-	unsigned int irqn;
 	void *cqc, *in;
 	__be64 *pas;
 	u32 i;
@@ -446,7 +445,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 		goto err_cqwq;
 	}
 
-	err = mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
+	err = mlx5_vector2eqn(mdev, smp_processor_id(), &eqn);
 	if (err) {
 		kvfree(in);
 		goto err_cqwq;
@@ -476,7 +475,6 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	*conn->cq.mcq.arm_db    = 0;
 	conn->cq.mcq.vector     = 0;
 	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
-	conn->cq.mcq.irqn       = irqn;
 	conn->cq.mcq.uar        = fdev->conn_res.uar;
 	tasklet_setup(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 624cedebb510..d3d628b862f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -104,4 +104,6 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
 #endif
 
+int mlx5_vector2irqn(struct mlx5_core_dev *dev, int vector, unsigned int *irqn);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 12cf323a5943..9df0e73d1c35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -749,7 +749,6 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	struct mlx5_cqe64 *cqe;
 	struct mlx5dr_cq *cq;
 	int inlen, err, eqn;
-	unsigned int irqn;
 	void *cqc, *in;
 	__be64 *pas;
 	int vector;
@@ -782,7 +781,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 		goto err_cqwq;
 
 	vector = raw_smp_processor_id() % mlx5_comp_vectors_count(mdev);
-	err = mlx5_vector2eqn(mdev, vector, &eqn, &irqn);
+	err = mlx5_vector2eqn(mdev, vector, &eqn);
 	if (err) {
 		kvfree(in);
 		goto err_cqwq;
@@ -818,7 +817,6 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	*cq->mcq.arm_db = cpu_to_be32(2 << 28);
 
 	cq->mcq.vector = 0;
-	cq->mcq.irqn = irqn;
 	cq->mcq.uar = uar;
 
 	return cq;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 2a31467f7ac5..379a19144a25 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -526,7 +526,6 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
 	void __iomem *uar_page = ndev->mvdev.res.uar->map;
 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	struct mlx5_vdpa_cq *vcq = &mvq->cq;
-	unsigned int irqn;
 	__be64 *pas;
 	int inlen;
 	void *cqc;
@@ -566,7 +565,7 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
 	/* Use vector 0 by default. Consider adding code to choose least used
 	 * vector.
 	 */
-	err = mlx5_vector2eqn(mdev, 0, &eqn, &irqn);
+	err = mlx5_vector2eqn(mdev, 0, &eqn);
 	if (err)
 		goto err_vec;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1efe37466969..25a8be58d289 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1044,8 +1044,7 @@ void mlx5_unregister_debugfs(void);
 void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas);
 void mlx5_fill_page_frag_array_perm(struct mlx5_frag_buf *buf, __be64 *pas, u8 perm);
 void mlx5_fill_page_frag_array(struct mlx5_frag_buf *frag_buf, __be64 *pas);
-int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
-		    unsigned int *irqn);
+int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn);
 int mlx5_core_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 int mlx5_core_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 
-- 
2.31.1

