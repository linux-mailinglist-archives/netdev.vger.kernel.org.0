Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593111A67FE
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgDMOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgDMOXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:24 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 171132075E;
        Mon, 13 Apr 2020 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787803;
        bh=3iK2ZHpN3qGB9DycGIZRHB0oW4VSXZHM+bWeGsDG6d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KH/78UGeKneEMblADYzf/wXwPn+u3+gJLxCvCFJJF8iAUdCYRsSbFTWbeiZYZoB9X
         Tkr/6NJPqU9t2sfM5Qg+RCvJFlqJ+OvE4xRWEBQpvSH6dn4cxgh3DntsGqk3/8N7te
         LEIAeUGRZWISUUJ9NpMylRWouI91f8jkLgGqal7o=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/13] net/mlx5: Remove empty QP and CQ events handlers
Date:   Mon, 13 Apr 2020 17:22:58 +0300
Message-Id: <20200413142308.936946-4-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The QP and CQ events functions do nothing except printing some debug
messages. There is nothing to do with this knowledge and such events,
so remove them.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 19 -------------------
 .../mellanox/mlx5/core/steering/dr_send.c     | 14 --------------
 2 files changed, 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 7c3e7232852e..1d49894399af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -362,23 +362,6 @@ static void mlx5_fpga_conn_arm_cq(struct mlx5_fpga_conn *conn)
 		    conn->fdev->conn_res.uar->map, conn->cq.wq.cc);
 }
 
-static void mlx5_fpga_conn_cq_event(struct mlx5_core_cq *mcq,
-				    enum mlx5_event event)
-{
-	struct mlx5_fpga_conn *conn;
-
-	conn = container_of(mcq, struct mlx5_fpga_conn, cq.mcq);
-	mlx5_fpga_warn(conn->fdev, "CQ event %u on CQ #%u\n", event, mcq->cqn);
-}
-
-static void mlx5_fpga_conn_event(struct mlx5_core_qp *mqp, int event)
-{
-	struct mlx5_fpga_conn *conn;
-
-	conn = container_of(mqp, struct mlx5_fpga_conn, qp.mqp);
-	mlx5_fpga_warn(conn->fdev, "QP event %u on QP #%u\n", event, mqp->qpn);
-}
-
 static inline void mlx5_fpga_conn_cqes(struct mlx5_fpga_conn *conn,
 				       unsigned int budget)
 {
@@ -493,7 +476,6 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	*conn->cq.mcq.arm_db    = 0;
 	conn->cq.mcq.vector     = 0;
 	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
-	conn->cq.mcq.event      = mlx5_fpga_conn_cq_event;
 	conn->cq.mcq.irqn       = irqn;
 	conn->cq.mcq.uar        = fdev->conn_res.uar;
 	tasklet_init(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet,
@@ -607,7 +589,6 @@ static int mlx5_fpga_conn_create_qp(struct mlx5_fpga_conn *conn,
 		goto err_sq_bufs;
 
 	conn->qp.mqp.qpn = MLX5_GET(create_qp_out, out, qpn);
-	conn->qp.mqp.event = mlx5_fpga_conn_event;
 	mlx5_fpga_dbg(fdev, "Created QP #0x%x\n", conn->qp.mqp.qpn);
 
 	goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 88bc94a8b8f1..690e4181db4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -100,11 +100,6 @@ static int dr_poll_cq(struct mlx5dr_cq *dr_cq, int ne)
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
-static void dr_qp_event(struct mlx5_core_qp *mqp, int event)
-{
-	pr_info("DR QP event %u on QP #%u\n", event, mqp->qpn);
-}
-
 static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 					 struct dr_qp_init_attr *attr)
 {
@@ -187,7 +182,6 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	kfree(in);
 	if (err)
 		goto err_in;
-	dr_qp->mqp.event = dr_qp_event;
 	dr_qp->uar = attr->uar;
 
 	return dr_qp;
@@ -695,12 +689,6 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 	return 0;
 }
 
-static void dr_cq_event(struct mlx5_core_cq *mcq,
-			enum mlx5_event event)
-{
-	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
-}
-
 static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 				      struct mlx5_uars_page *uar,
 				      size_t ncqe)
@@ -761,8 +749,6 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 
-	cq->mcq.event = dr_cq_event;
-
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	kvfree(in);
 
-- 
2.25.2

