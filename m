Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1D336CF2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhCKHKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhCKHJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56EF265021;
        Thu, 11 Mar 2021 07:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446584;
        bh=WLbXKSFYXxzgozV6BiybDqKwXMylYsfg/3YTtC6i9Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSkkZz6617fQQmjS97q8H/ohM8gj7n3p74OqQnSX//5sLOie0PeCYBTCcLakZhFoQ
         dnUlfSI1e443GIdwxg/Rzo2haLYPYSO3K+z4+SGCeWCiodCmcHiG/Q2MVfe0sUcM8Z
         MNWmq1GXTFWuZJcgk6UZEJRW5ko6SjncehcM1oQ4IkIWDnIHupd5S2ybWsI+JrozkL
         n5kbPucn0fu6MBxJpKge1ozc+9c3eq24+S1xzGsirZGayhdcvOwoCuWg5RFyLrN6uq
         C/bTFxmMb53xlBl3aI8IwXevh7FNUwDo/MqGsl8SJZfDgWCmoVIsZ0ZoEaWwpzfURJ
         y1/jsslCcFuYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 9/9] net/mlx5: Use order-0 allocations for EQs
Date:   Wed, 10 Mar 2021 23:09:15 -0800
Message-Id: <20210311070915.321814-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Currently we are allocating high-order page for EQs. In case of
fragmented system, VF hot remove/add in VMs for example, there isn't
enough contiguous memory for EQs allocation, which results in crashing
of the VM.
Therefore, use order-0 fragments for the EQ allocations instead.

Performance tests:
ConnectX-5 100Gbps, CPU: Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz
Performance tests show no sensible degradation.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 27 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  | 15 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/wq.c  |  5 ----
 include/linux/mlx5/driver.h                   |  5 ++++
 5 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 84e501e057b4..6f4e6c34b2a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -128,7 +128,7 @@ int mlx5e_health_eq_diag_fmsg(struct mlx5_eq_comp *eq, struct devlink_fmsg *fmsg
 	if (err)
 		return err;
 
-	err = devlink_fmsg_u32_pair_put(fmsg, "size", eq->core.nent);
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", eq_get_size(&eq->core));
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 174dfbc996c6..4e8381030d77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -271,7 +271,7 @@ static void init_eq_buf(struct mlx5_eq *eq)
 	struct mlx5_eqe *eqe;
 	int i;
 
-	for (i = 0; i < eq->nent; i++) {
+	for (i = 0; i < eq_get_size(eq); i++) {
 		eqe = get_eqe(eq, i);
 		eqe->owner = MLX5_EQE_OWNER_INIT_VAL;
 	}
@@ -281,8 +281,10 @@ static int
 create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	      struct mlx5_eq_param *param)
 {
+	u8 log_eq_size = order_base_2(param->nent + MLX5_NUM_SPARE_EQE);
 	struct mlx5_cq_table *cq_table = &eq->cq_table;
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
+	u8 log_eq_stride = ilog2(MLX5_EQE_SIZE);
 	struct mlx5_priv *priv = &dev->priv;
 	u8 vecidx = param->irq_index;
 	__be64 *pas;
@@ -297,16 +299,18 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	spin_lock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
 
-	eq->nent = roundup_pow_of_two(param->nent + MLX5_NUM_SPARE_EQE);
 	eq->cons_index = 0;
-	err = mlx5_buf_alloc(dev, eq->nent * MLX5_EQE_SIZE, &eq->buf);
+
+	err = mlx5_frag_buf_alloc_node(dev, wq_get_byte_sz(log_eq_size, log_eq_stride),
+				       &eq->frag_buf, dev->priv.numa_node);
 	if (err)
 		return err;
 
+	mlx5_init_fbc(eq->frag_buf.frags, log_eq_stride, log_eq_size, &eq->fbc);
 	init_eq_buf(eq);
 
 	inlen = MLX5_ST_SZ_BYTES(create_eq_in) +
-		MLX5_FLD_SZ_BYTES(create_eq_in, pas[0]) * eq->buf.npages;
+		MLX5_FLD_SZ_BYTES(create_eq_in, pas[0]) * eq->frag_buf.npages;
 
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
@@ -315,7 +319,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	}
 
 	pas = (__be64 *)MLX5_ADDR_OF(create_eq_in, in, pas);
-	mlx5_fill_page_array(&eq->buf, pas);
+	mlx5_fill_page_frag_array(&eq->frag_buf, pas);
 
 	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
 	if (!param->mask[0] && MLX5_CAP_GEN(dev, log_max_uctx))
@@ -326,11 +330,11 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 				 param->mask[i]);
 
 	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
-	MLX5_SET(eqc, eqc, log_eq_size, ilog2(eq->nent));
+	MLX5_SET(eqc, eqc, log_eq_size, eq->fbc.log_sz);
 	MLX5_SET(eqc, eqc, uar_page, priv->uar->index);
 	MLX5_SET(eqc, eqc, intr, vecidx);
 	MLX5_SET(eqc, eqc, log_page_size,
-		 eq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
+		 eq->frag_buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
 
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 	if (err)
@@ -356,7 +360,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	kvfree(in);
 
 err_buf:
-	mlx5_buf_free(dev, &eq->buf);
+	mlx5_frag_buf_free(dev, &eq->frag_buf);
 	return err;
 }
 
@@ -413,7 +417,7 @@ static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 			       eq->eqn);
 	synchronize_irq(eq->irqn);
 
-	mlx5_buf_free(dev, &eq->buf);
+	mlx5_frag_buf_free(dev, &eq->frag_buf);
 
 	return err;
 }
@@ -764,10 +768,11 @@ EXPORT_SYMBOL(mlx5_eq_destroy_generic);
 struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc)
 {
 	u32 ci = eq->cons_index + cc;
+	u32 nent = eq_get_size(eq);
 	struct mlx5_eqe *eqe;
 
-	eqe = get_eqe(eq, ci & (eq->nent - 1));
-	eqe = ((eqe->owner & 1) ^ !!(ci & eq->nent)) ? NULL : eqe;
+	eqe = get_eqe(eq, ci & (nent - 1));
+	eqe = ((eqe->owner & 1) ^ !!(ci & nent)) ? NULL : eqe;
 	/* Make sure we read EQ entry contents after we've
 	 * checked the ownership bit.
 	 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 81f2cc4ca1da..f607a3858ef5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -22,15 +22,15 @@ struct mlx5_cq_table {
 };
 
 struct mlx5_eq {
+	struct mlx5_frag_buf_ctrl fbc;
+	struct mlx5_frag_buf    frag_buf;
 	struct mlx5_core_dev    *dev;
 	struct mlx5_cq_table    cq_table;
 	__be32 __iomem	        *doorbell;
 	u32                     cons_index;
-	struct mlx5_frag_buf    buf;
 	unsigned int            vecidx;
 	unsigned int            irqn;
 	u8                      eqn;
-	int                     nent;
 	struct mlx5_rsc_debug   *dbg;
 };
 
@@ -47,16 +47,21 @@ struct mlx5_eq_comp {
 	struct list_head        list;
 };
 
+static inline u32 eq_get_size(struct mlx5_eq *eq)
+{
+	return eq->fbc.sz_m1 + 1;
+}
+
 static inline struct mlx5_eqe *get_eqe(struct mlx5_eq *eq, u32 entry)
 {
-	return mlx5_buf_offset(&eq->buf, entry * MLX5_EQE_SIZE);
+	return mlx5_frag_buf_get_wqe(&eq->fbc, entry);
 }
 
 static inline struct mlx5_eqe *next_eqe_sw(struct mlx5_eq *eq)
 {
-	struct mlx5_eqe *eqe = get_eqe(eq, eq->cons_index & (eq->nent - 1));
+	struct mlx5_eqe *eqe = get_eqe(eq, eq->cons_index & eq->fbc.sz_m1);
 
-	return ((eqe->owner & 1) ^ !!(eq->cons_index & eq->nent)) ? NULL : eqe;
+	return (eqe->owner ^ (eq->cons_index >> eq->fbc.log_sz)) & 1 ? NULL : eqe;
 }
 
 static inline void eq_update_ci(struct mlx5_eq *eq, int arm)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
index 01f075fac276..3091dd014650 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -34,11 +34,6 @@
 #include "wq.h"
 #include "mlx5_core.h"
 
-static u32 wq_get_byte_sz(u8 log_sz, u8 log_stride)
-{
-	return ((u32)1 << log_sz) << log_stride;
-}
-
 int mlx5_wq_cyc_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *param,
 		       void *wqc, struct mlx5_wq_cyc *wq,
 		       struct mlx5_wq_ctrl *wq_ctrl)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8fe51b4a781e..5c0422930b01 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -873,6 +873,11 @@ static inline u32 mlx5_base_mkey(const u32 key)
 	return key & 0xffffff00u;
 }
 
+static inline u32 wq_get_byte_sz(u8 log_sz, u8 log_stride)
+{
+	return ((u32)1 << log_sz) << log_stride;
+}
+
 static inline void mlx5_init_fbc_offset(struct mlx5_buf_list *frags,
 					u8 log_stride, u8 log_sz,
 					u16 strides_offset,
-- 
2.29.2

