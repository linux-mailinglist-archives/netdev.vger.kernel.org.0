Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7745B094
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfF3QXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF3QXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:23:55 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F4D20673;
        Sun, 30 Jun 2019 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911834;
        bh=3EqdYagM7KIrz0vbl7nAUuxS/NXSXEE5ZmO5A4AHZX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwIyOrvghoJfghhFkLnuIQ+QllZnZGrH2ngnCTg+LSaNZbxpsnEUCO7lthIE3iBGn
         481oKeFzVi0fRMv9Yg92TldL3Bnat7YH8FU93yTG6s5Xo/8nqPX03sJTKaZxGfMEJb
         ZZXmxFiXSG2Rg9PkAKXVcaHLyO9J4jERHP8WF4Gc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v2 04/13] net/mlx5: mlx5_core_create_cq() enhancements
Date:   Sun, 30 Jun 2019 19:23:25 +0300
Message-Id: <20190630162334.22135-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enhance mlx5_core_create_cq() to get the command out buffer from the
callers to let them use the output.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c                     | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c        | 7 +++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 3 ++-
 include/linux/mlx5/cq.h                             | 2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 22230fd7d741..857a554e2c29 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -891,6 +891,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	int entries = attr->cqe;
 	int vector = attr->comp_vector;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	int uninitialized_var(index);
 	int uninitialized_var(inlen);
@@ -954,7 +955,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
 		MLX5_SET(cqc, cqc, oi, 1);
 
-	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen);
+	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
 	if (err)
 		goto err_cqb;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 703d88332bc6..1bd4336392a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -87,11 +87,10 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq)
 }
 
 int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-			u32 *in, int inlen)
+			u32 *in, int inlen, u32 *out, int outlen)
 {
 	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), c_eqn);
 	u32 dout[MLX5_ST_SZ_DW(destroy_cq_out)];
-	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)];
 	struct mlx5_eq_comp *eq;
 	int err;
@@ -100,9 +99,9 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	if (IS_ERR(eq))
 		return PTR_ERR(eq);
 
-	memset(out, 0, sizeof(out));
+	memset(out, 0, outlen);
 	MLX5_SET(create_cq_in, in, opcode, MLX5_CMD_OP_CREATE_CQ);
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1046bd057152..2a1a7dad5d04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1518,6 +1518,7 @@ static void mlx5e_free_cq(struct mlx5e_cq *cq)
 
 static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
 {
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	struct mlx5_core_dev *mdev = cq->mdev;
 	struct mlx5_core_cq *mcq = &cq->mcq;
 
@@ -1552,7 +1553,7 @@ static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
 					    MLX5_ADAPTER_PAGE_SHIFT);
 	MLX5_SET64(cqc, cqc, dbr_addr,      cq->wq_ctrl.db.dma);
 
-	err = mlx5_core_create_cq(mdev, mcq, in, inlen);
+	err = mlx5_core_create_cq(mdev, mcq, in, inlen, out, sizeof(out));
 
 	kvfree(in);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index ca2296a2f9ee..dc7b9d9f274d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -429,6 +429,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	struct mlx5_fpga_device *fdev = conn->fdev;
 	struct mlx5_core_dev *mdev = fdev->mdev;
 	u32 temp_cqc[MLX5_ST_SZ_DW(cqc)] = {0};
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	struct mlx5_wq_param wqp;
 	struct mlx5_cqe64 *cqe;
 	int inlen, err, eqn;
@@ -476,7 +477,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&conn->cq.wq_ctrl.buf, pas);
 
-	err = mlx5_core_create_cq(mdev, &conn->cq.mcq, in, inlen);
+	err = mlx5_core_create_cq(mdev, &conn->cq.mcq, in, inlen, out, sizeof(out));
 	kvfree(in);
 
 	if (err)
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 769326ea1d9b..e44157a2b7db 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -185,7 +185,7 @@ static inline void mlx5_cq_put(struct mlx5_core_cq *cq)
 }
 
 int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-			u32 *in, int inlen);
+			u32 *in, int inlen, u32 *out, int outlen);
 int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq);
 int mlx5_core_query_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 		       u32 *out, int outlen);
-- 
2.20.1

