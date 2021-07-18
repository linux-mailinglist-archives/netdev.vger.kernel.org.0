Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30663CC8EA
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbhGRL5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 07:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232685AbhGRL5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 07:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B152461040;
        Sun, 18 Jul 2021 11:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626609258;
        bh=J+Ypxx9ComWDmWZ+Oxy1Q4AusaFM9UVaVCI3jF221iM=;
        h=From:To:Cc:Subject:Date:From;
        b=jHqO0m/4ZbVdNR3yxUv/Nj2P4cvLxewaRnXfqyip4j4OC5v6iGqHKkHs4BHB5ibuL
         PZeMsYCapvgq6a7PDciQphyqr5G8skEHMjRysKr0nwaGhYm7QJsDyUl4vyZ1ZF4Unq
         rgMzuXjCGlrMHRaqoWaMw8W5oNGYthqDT15lsddYIHIEjQJafkFaTJEV4pyxspx1Dt
         gOtX4d8+tIO4kafRmGVZquwr2TT/V8nMKpJCIbJrPgJPyuN6tbco2mxtBel4IWcxkg
         2K3/Qj9TPWass1wZxIwqGm5aXk1MyW/12V3S3qvFeNNgkhw1aTcgMX8B/g4G/igqAE
         L1fgRKY3tWfqg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tal Gilboa <talgi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH mlx5-next] IB/mlx5: Rename is_apu_thread_cq function to is_apu_cq
Date:   Sun, 18 Jul 2021 14:54:13 +0300
Message-Id: <0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tal Gilboa <talgi@nvidia.com>

is_apu_thread_cq() used to detect CQs which are attached to APU
threads. This was extended to support other elements as well,
so the function was renamed to is_apu_cq().

c_eqn_or_apu_element was extended from 8 bits to 32 bits, which wan't
reflected when the APU support was first introduced.

Signed-off-by: Tal Gilboa <talgi@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
 drivers/infiniband/hw/mlx5/devx.c                          | 7 +++----
 drivers/net/ethernet/mellanox/mlx5/core/cq.c               | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                          | 2 +-
 include/linux/mlx5/mlx5_ifc.h                              | 5 ++---
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index aef87a7c01ff..464e6a1ecdb0 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -997,7 +997,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 				  MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD));
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(entries));
 	MLX5_SET(cqc, cqc, uar_page, index);
-	MLX5_SET(cqc, cqc, c_eqn, eqn);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
 	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
 		MLX5_SET(cqc, cqc, oi, 1);
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index edcac8b3f384..31f5f4c73d25 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1437,11 +1437,10 @@ static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
 	rcu_read_unlock();
 }
 
-static bool is_apu_thread_cq(struct mlx5_ib_dev *dev, const void *in)
+static bool is_apu_cq(struct mlx5_ib_dev *dev, const void *in)
 {
 	if (!MLX5_CAP_GEN(dev->mdev, apu) ||
-	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
-		      apu_thread_cq))
+	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), apu_cq))
 		return false;
 
 	return true;
@@ -1501,7 +1500,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		err = mlx5_core_create_dct(dev, &obj->core_dct, cmd_in,
 					   cmd_in_len, cmd_out, cmd_out_len);
 	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
-		   !is_apu_thread_cq(dev, cmd_in)) {
+		   !is_apu_cq(dev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
 		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index df3e4938ecdd..99ec278d0370 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -89,7 +89,8 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
 int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen, u32 *out, int outlen)
 {
-	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), c_eqn);
+	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
+			   c_eqn_or_apu_element);
 	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
 	struct mlx5_eq_comp *eq;
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c47603a952f3..308ccace48d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1626,7 +1626,7 @@ static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
 				  (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas));
 
 	MLX5_SET(cqc,   cqc, cq_period_mode, param->cq_period_mode);
-	MLX5_SET(cqc,   cqc, c_eqn,         eqn);
+	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.uar->index);
 	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
 					    MLX5_ADAPTER_PAGE_SHIFT);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 6f78716ff321..9bb4944820df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -454,7 +454,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(cq_size));
-	MLX5_SET(cqc, cqc, c_eqn, eqn);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET(cqc, cqc, uar_page, fdev->conn_res.uar->index);
 	MLX5_SET(cqc, cqc, log_page_size, conn->cq.wq_ctrl.buf.page_shift -
 			   MLX5_ADAPTER_PAGE_SHIFT);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index d1300b16d054..a4a3ee87a903 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -790,7 +790,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(ncqe));
-	MLX5_SET(cqc, cqc, c_eqn, eqn);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET(cqc, cqc, uar_page, uar->index);
 	MLX5_SET(cqc, cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
 		 MLX5_ADAPTER_PAGE_SHIFT);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 0121c7c49396..83fa3c26cbd2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -573,7 +573,7 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
 	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 	MLX5_SET(cqc, cqc, log_cq_size, ilog2(num_ent));
 	MLX5_SET(cqc, cqc, uar_page, ndev->mvdev.res.uar->index);
-	MLX5_SET(cqc, cqc, c_eqn, eqn);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET64(cqc, cqc, dbr_addr, vcq->db.dma);
 
 	err = mlx5_core_create_cq(mdev, &vcq->mcq, in, inlen, out, sizeof(out));
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c980eab89867..e93f16b87312 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3923,7 +3923,7 @@ struct mlx5_ifc_cqc_bits {
 	u8         status[0x4];
 	u8         reserved_at_4[0x2];
 	u8         dbr_umem_valid[0x1];
-	u8         apu_thread_cq[0x1];
+	u8         apu_cq[0x1];
 	u8         cqe_sz[0x3];
 	u8         cc[0x1];
 	u8         reserved_at_c[0x1];
@@ -3949,8 +3949,7 @@ struct mlx5_ifc_cqc_bits {
 	u8         cq_period[0xc];
 	u8         cq_max_count[0x10];
 
-	u8         reserved_at_a0[0x18];
-	u8         c_eqn[0x8];
+	u8         c_eqn_or_apu_element[0x20];
 
 	u8         reserved_at_c0[0x3];
 	u8         log_page_size[0x5];
-- 
2.31.1

