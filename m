Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56471A6816
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgDMOYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730689AbgDMOYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:24:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA04D20774;
        Mon, 13 Apr 2020 14:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787836;
        bh=d+ETAaiTTZuX0WT+mbElHZs0+S12sIt6Ep+PJFHaVaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EVzXnZys/YzqtMqjGN3YalyHKjKnf1K3BvY7hN22/lwiFbR0txLyZS1OxnludY6K
         O4pcwrhSOP3Ikpp/CKf7OS303IBr0U59BcGXVvzLPvmMU+xBeQRq4GBl8X6vR+bKJ6
         LW7x2LuCRYlBFzMZYw1EdF6laGZuicfdLOgzovpU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 13/13] net/mlx5: Move QP logic to mlx5_ib
Date:   Mon, 13 Apr 2020 17:23:08 +0300
Message-Id: <20200413142308.936946-14-leon@kernel.org>
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

The mlx5_core doesn't need any functionality coded in qp.c, so move
that file to drivers/infiniband/ be under mlx5_ib responsibility.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/Makefile           |   1 +
 drivers/infiniband/hw/mlx5/cq.c               |   3 +-
 drivers/infiniband/hw/mlx5/devx.c             |  10 +-
 drivers/infiniband/hw/mlx5/main.c             |  10 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   2 +
 drivers/infiniband/hw/mlx5/odp.c              |   3 +-
 drivers/infiniband/hw/mlx5/qp.c               |  47 ++--
 drivers/infiniband/hw/mlx5/qp.h               |  46 +++
 .../core/qp.c => infiniband/hw/mlx5/qpc.c}    | 264 ++++++------------
 drivers/infiniband/hw/mlx5/srq_cmd.c          |   1 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |   6 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   4 -
 include/linux/mlx5/cmd.h                      |  51 ----
 include/linux/mlx5/driver.h                   |   2 -
 include/linux/mlx5/qp.h                       |  45 ---
 16 files changed, 180 insertions(+), 317 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/qp.h
 rename drivers/{net/ethernet/mellanox/mlx5/core/qp.c => infiniband/hw/mlx5/qpc.c} (59%)
 delete mode 100644 include/linux/mlx5/cmd.h

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index 375b341be8a1..228be05fbaf8 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -13,6 +13,7 @@ mlx5_ib-y := ah.o \
 	     mem.o \
 	     mr.o \
 	     qp.o \
+	     qpc.o \
 	     restrack.o \
 	     srq.o \
 	     srq_cmd.o
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 146ba2966744..32c05730dfe9 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -36,6 +36,7 @@
 #include <rdma/ib_cache.h>
 #include "mlx5_ib.h"
 #include "srq.h"
+#include "qp.h"
 
 static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
 {
@@ -484,7 +485,7 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 		 * because CQs will be locked while QPs are removed
 		 * from the table.
 		 */
-		mqp = __mlx5_qp_lookup(dev->mdev, qpn);
+		mqp = radix_tree_lookup(&dev->qp_table.tree, qpn);
 		*cur_qp = to_mibqp(mqp);
 	}
 
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 46e1ab771f10..35b98c2d64d5 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -14,6 +14,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
+#include "qp.h"
 #include <linux/xarray.h>
 
 #define UVERBS_MODULE_NAME mlx5_ib
@@ -1356,7 +1357,7 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	}
 
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		ret = mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
+		ret = mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
 		ret = mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
@@ -1450,9 +1451,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
 		obj->flags |= DEVX_OBJ_FLAGS_DCT;
-		err = mlx5_core_create_dct(dev->mdev, &obj->core_dct,
-					   cmd_in, cmd_in_len,
-					   cmd_out, cmd_out_len);
+		err = mlx5_core_create_dct(dev, &obj->core_dct, cmd_in,
+					   cmd_in_len, cmd_out, cmd_out_len);
 	} else if (opcode == MLX5_CMD_OP_CREATE_CQ) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
@@ -1499,7 +1499,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
+		mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
 		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ea1fe4f9e0c3..689b9dddda26 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -60,6 +60,7 @@
 #include "ib_rep.h"
 #include "cmd.h"
 #include "srq.h"
+#include "qp.h"
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/accel.h>
 #include <rdma/uverbs_std_types.h>
@@ -4604,8 +4605,7 @@ static void delay_drop_handler(struct work_struct *work)
 	atomic_inc(&delay_drop->events_cnt);
 
 	mutex_lock(&delay_drop->lock);
-	err = mlx5_core_set_delay_drop(delay_drop->dev->mdev,
-				       delay_drop->timeout);
+	err = mlx5_core_set_delay_drop(delay_drop->dev, delay_drop->timeout);
 	if (err) {
 		mlx5_ib_warn(delay_drop->dev, "Failed to set delay drop, timeout=%u\n",
 			     delay_drop->timeout);
@@ -7166,6 +7166,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
 		     mlx5_ib_stage_roce_init,
 		     mlx5_ib_stage_roce_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_QP,
+		     mlx5_init_qp_table,
+		     mlx5_cleanup_qp_table),
 	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
 		     mlx5_init_srq_table,
 		     mlx5_cleanup_srq_table),
@@ -7223,6 +7226,9 @@ const struct mlx5_ib_profile raw_eth_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
 		     mlx5_ib_stage_raw_eth_roce_init,
 		     mlx5_ib_stage_raw_eth_roce_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_QP,
+		     mlx5_init_qp_table,
+		     mlx5_cleanup_qp_table),
 	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
 		     mlx5_init_srq_table,
 		     mlx5_cleanup_srq_table),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 897a7ff06880..550b044c670e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -870,6 +870,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_CAPS,
 	MLX5_IB_STAGE_NON_DEFAULT_CB,
 	MLX5_IB_STAGE_ROCE,
+	MLX5_IB_STAGE_QP,
 	MLX5_IB_STAGE_SRQ,
 	MLX5_IB_STAGE_DEVICE_RESOURCES,
 	MLX5_IB_STAGE_DEVICE_NOTIFIER,
@@ -1065,6 +1066,7 @@ struct mlx5_ib_dev {
 	struct mlx5_dm		dm;
 	u16			devx_whitelist_uid;
 	struct mlx5_srq_table   srq_table;
+	struct mlx5_qp_table    qp_table;
 	struct mlx5_async_ctx   async_ctx;
 	struct mlx5_devx_event_table devx_event_table;
 	struct mlx5_var_table var_table;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 3de7606d4a1a..16af1105cfcf 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -36,6 +36,7 @@
 
 #include "mlx5_ib.h"
 #include "cmd.h"
+#include "qp.h"
 
 #include <linux/mlx5/eq.h>
 
@@ -1219,7 +1220,7 @@ static inline struct mlx5_core_rsc_common *odp_get_rsc(struct mlx5_ib_dev *dev,
 	case MLX5_WQE_PF_TYPE_REQ_SEND_OR_WRITE:
 	case MLX5_WQE_PF_TYPE_RESP:
 	case MLX5_WQE_PF_TYPE_REQ_READ_OR_ATOMIC:
-		common = mlx5_core_res_hold(dev->mdev, wq_num, MLX5_RES_QP);
+		common = mlx5_core_res_hold(dev, wq_num, MLX5_RES_QP);
 		break;
 	default:
 		break;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e7083ab3bcd2..12082e19cf08 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -39,6 +39,7 @@
 #include "mlx5_ib.h"
 #include "ib_rep.h"
 #include "cmd.h"
+#include "qp.h"
 
 /* not supported currently */
 static int wq_signature;
@@ -1336,7 +1337,7 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	pas = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, sq->ubuffer.umem, page_shift, pas, 0);
 
-	err = mlx5_core_create_sq_tracked(dev->mdev, in, inlen, &sq->base.mqp);
+	err = mlx5_core_create_sq_tracked(dev, in, inlen, &sq->base.mqp);
 
 	kvfree(in);
 
@@ -1356,7 +1357,7 @@ static void destroy_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 				     struct mlx5_ib_sq *sq)
 {
 	destroy_flow_rule_vport_sq(sq);
-	mlx5_core_destroy_sq_tracked(dev->mdev, &sq->base.mqp);
+	mlx5_core_destroy_sq_tracked(dev, &sq->base.mqp);
 	ib_umem_release(sq->ubuffer.umem);
 }
 
@@ -1426,7 +1427,7 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	qp_pas = (__be64 *)MLX5_ADDR_OF(create_qp_in, qpin, pas);
 	memcpy(pas, qp_pas, rq_pas_size);
 
-	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rq->base.mqp);
+	err = mlx5_core_create_rq_tracked(dev, in, inlen, &rq->base.mqp);
 
 	kvfree(in);
 
@@ -1436,7 +1437,7 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 static void destroy_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 				     struct mlx5_ib_rq *rq)
 {
-	mlx5_core_destroy_rq_tracked(dev->mdev, &rq->base.mqp);
+	mlx5_core_destroy_rq_tracked(dev, &rq->base.mqp);
 }
 
 static bool tunnel_offload_supported(struct mlx5_core_dev *dev)
@@ -2347,7 +2348,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		err = create_raw_packet_qp(dev, qp, in, inlen, pd, udata,
 					   &resp);
 	} else {
-		err = mlx5_core_create_qp(dev->mdev, &base->mqp, in, inlen);
+		err = mlx5_core_create_qp(dev, &base->mqp, in, inlen);
 	}
 
 	if (err) {
@@ -2513,8 +2514,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->state != IB_QPS_RESET) {
 		if (qp->ibqp.qp_type != IB_QPT_RAW_PACKET &&
 		    !(qp->flags & MLX5_IB_QP_UNDERLAY)) {
-			err = mlx5_core_qp_modify(dev->mdev,
-						  MLX5_CMD_OP_2RST_QP, 0,
+			err = mlx5_core_qp_modify(dev, MLX5_CMD_OP_2RST_QP, 0,
 						  NULL, &base->mqp);
 		} else {
 			struct mlx5_modify_raw_qp_param raw_qp_param = {
@@ -2555,7 +2555,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	    qp->flags & MLX5_IB_QP_UNDERLAY) {
 		destroy_raw_packet_qp(dev, qp);
 	} else {
-		err = mlx5_core_destroy_qp(dev->mdev, &base->mqp);
+		err = mlx5_core_destroy_qp(dev, &base->mqp);
 		if (err)
 			mlx5_ib_warn(dev, "failed to destroy QP 0x%x\n",
 				     base->mqp.qpn);
@@ -2818,7 +2818,7 @@ static int mlx5_ib_destroy_dct(struct mlx5_ib_qp *mqp)
 	if (mqp->state == IB_QPS_RTR) {
 		int err;
 
-		err = mlx5_core_destroy_dct(dev->mdev, &mqp->dct.mdct);
+		err = mlx5_core_destroy_dct(dev, &mqp->dct.mdct);
 		if (err) {
 			mlx5_ib_warn(dev, "failed to destroy DCT %d\n", err);
 			return err;
@@ -3522,10 +3522,9 @@ static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
 	base = &mqp->trans_qp.base;
 	context.qp_counter_set_usr_page &= cpu_to_be32(0xffffff);
 	context.qp_counter_set_usr_page |= cpu_to_be32(set_id << 24);
-	return mlx5_core_qp_modify(dev->mdev,
-				   MLX5_CMD_OP_RTS2RTS_QP,
-				   MLX5_QP_OPTPAR_COUNTER_SET_ID,
-				   &context, &base->mqp);
+	return mlx5_core_qp_modify(dev, MLX5_CMD_OP_RTS2RTS_QP,
+				   MLX5_QP_OPTPAR_COUNTER_SET_ID, &context,
+				   &base->mqp);
 }
 
 static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
@@ -3805,8 +3804,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 		err = modify_raw_packet_qp(dev, qp, &raw_qp_param, tx_affinity);
 	} else {
-		err = mlx5_core_qp_modify(dev->mdev, op, optpar, context,
-					  &base->mqp);
+		err = mlx5_core_qp_modify(dev, op, optpar, context, &base->mqp);
 	}
 
 	if (err)
@@ -3980,7 +3978,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		MLX5_SET(dctc, dctc, my_addr_index, attr->ah_attr.grh.sgid_index);
 		MLX5_SET(dctc, dctc, hop_limit, attr->ah_attr.grh.hop_limit);
 
-		err = mlx5_core_create_dct(dev->mdev, &qp->dct.mdct, qp->dct.in,
+		err = mlx5_core_create_dct(dev, &qp->dct.mdct, qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,
 					   sizeof(out));
 		if (err)
@@ -3988,7 +3986,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		resp.dctn = qp->dct.mdct.mqp.qpn;
 		err = ib_copy_to_udata(udata, &resp, resp.response_length);
 		if (err) {
-			mlx5_core_destroy_dct(dev->mdev, &qp->dct.mdct);
+			mlx5_core_destroy_dct(dev, &qp->dct.mdct);
 			return err;
 		}
 	} else {
@@ -5750,8 +5748,7 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!outb)
 		return -ENOMEM;
 
-	err = mlx5_core_qp_query(dev->mdev, &qp->trans_qp.base.mqp, outb,
-				 outlen);
+	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen);
 	if (err)
 		goto out;
 
@@ -5829,7 +5826,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_dct_query(dev->mdev, dct, out, outlen);
+	err = mlx5_core_dct_query(dev, dct, out, outlen);
 	if (err)
 		goto out;
 
@@ -6015,7 +6012,7 @@ static int set_delay_drop(struct mlx5_ib_dev *dev)
 	if (dev->delay_drop.activate)
 		goto out;
 
-	err = mlx5_core_set_delay_drop(dev->mdev, dev->delay_drop.timeout);
+	err = mlx5_core_set_delay_drop(dev, dev->delay_drop.timeout);
 	if (err)
 		goto out;
 
@@ -6121,13 +6118,13 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	}
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
-	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rwq->core_qp);
+	err = mlx5_core_create_rq_tracked(dev, in, inlen, &rwq->core_qp);
 	if (!err && init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP) {
 		err = set_delay_drop(dev);
 		if (err) {
 			mlx5_ib_warn(dev, "Failed to enable delay drop err=%d\n",
 				     err);
-			mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
+			mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
 		} else {
 			rwq->create_flags |= MLX5_IB_WQ_FLAGS_DELAY_DROP;
 		}
@@ -6309,7 +6306,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 	return &rwq->ibwq;
 
 err_copy:
-	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
+	mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
 err_user_rq:
 	destroy_user_rq(dev, pd, rwq, udata);
 err:
@@ -6322,7 +6319,7 @@ void mlx5_ib_destroy_wq(struct ib_wq *wq, struct ib_udata *udata)
 	struct mlx5_ib_dev *dev = to_mdev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 
-	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
+	mlx5_core_destroy_rq_tracked(dev, &rwq->core_qp);
 	destroy_user_rq(dev, wq->pd, rwq, udata);
 	kfree(rwq);
 }
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
new file mode 100644
index 000000000000..ad9d76e3e18a
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2013-2020, Mellanox Technologies inc. All rights reserved.
+ */
+
+#ifndef _MLX5_IB_QP_H
+#define _MLX5_IB_QP_H
+
+#include "mlx5_ib.h"
+
+int mlx5_init_qp_table(struct mlx5_ib_dev *dev);
+void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev);
+
+int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *qp,
+			 u32 *in, int inlen, u32 *out, int outlen);
+int mlx5_core_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
+			u32 *in, int inlen);
+int mlx5_core_qp_modify(struct mlx5_ib_dev *dev, u16 opcode, u32 opt_param_mask,
+			void *qpc, struct mlx5_core_qp *qp);
+int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp);
+int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct);
+int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
+		       u32 *out, int outlen);
+int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
+			u32 *out, int outlen);
+
+int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev, u32 timeout_usec);
+
+void mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
+				  struct mlx5_core_qp *rq);
+int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+				struct mlx5_core_qp *sq);
+void mlx5_core_destroy_sq_tracked(struct mlx5_ib_dev *dev,
+				  struct mlx5_core_qp *sq);
+
+int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
+				struct mlx5_core_qp *rq);
+
+struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_ib_dev *dev,
+						int res_num,
+						enum mlx5_res_type res_type);
+void mlx5_core_res_put(struct mlx5_core_rsc_common *res);
+
+int mlx5_core_xrcd_alloc(struct mlx5_ib_dev *dev, u32 *xrcdn);
+int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn);
+#endif /* _MLX5_IB_QP_H */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/infiniband/hw/mlx5/qpc.c
similarity index 59%
rename from drivers/net/ethernet/mellanox/mlx5/core/qp.c
rename to drivers/infiniband/hw/mlx5/qpc.c
index d9df3a5dd532..ea62735042f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -1,45 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /*
- * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
+ * Copyright (c) 2013-2020, Mellanox Technologies inc. All rights reserved.
  */
 
 #include <linux/gfp.h>
-#include <linux/export.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/driver.h>
-#include <linux/mlx5/transobj.h>
+#include "mlx5_ib.h"
+#include "qp.h"
 
-#include "mlx5_core.h"
-#include "lib/eq.h"
-
-static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
+static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
 			       struct mlx5_core_dct *dct);
 
 static struct mlx5_core_rsc_common *
@@ -123,11 +93,9 @@ static int rsc_event_notifier(struct notifier_block *nb,
 {
 	struct mlx5_core_rsc_common *common;
 	struct mlx5_qp_table *table;
-	struct mlx5_core_dev *dev;
 	struct mlx5_core_dct *dct;
 	u8 event_type = (u8)type;
 	struct mlx5_core_qp *qp;
-	struct mlx5_priv *priv;
 	struct mlx5_eqe *eqe;
 	u32 rsn;
 
@@ -154,22 +122,12 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	}
 
 	table = container_of(nb, struct mlx5_qp_table, nb);
-	priv  = container_of(table, struct mlx5_priv, qp_table);
-	dev   = container_of(priv, struct mlx5_core_dev, priv);
-
-	mlx5_core_dbg(dev, "event (%d) arrived on resource 0x%x\n", eqe->type, rsn);
-
 	common = mlx5_get_rsc(table, rsn);
-	if (!common) {
-		mlx5_core_dbg(dev, "Async event for unknown resource 0x%x\n", rsn);
+	if (!common)
 		return NOTIFY_OK;
-	}
 
-	if (!is_event_type_allowed((rsn >> MLX5_USER_INDEX_LEN), event_type)) {
-		mlx5_core_warn(dev, "event 0x%.2x is not allowed on resource 0x%.8x\n",
-			       event_type, rsn);
+	if (!is_event_type_allowed((rsn >> MLX5_USER_INDEX_LEN), event_type))
 		goto out;
-	}
 
 	switch (common->res) {
 	case MLX5_RES_QP:
@@ -184,7 +142,7 @@ static int rsc_event_notifier(struct notifier_block *nb,
 			complete(&dct->drained);
 		break;
 	default:
-		mlx5_core_warn(dev, "invalid resource type for 0x%x\n", rsn);
+		break;
 	}
 out:
 	mlx5_core_put_rsc(common);
@@ -192,11 +150,10 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static int create_resource_common(struct mlx5_core_dev *dev,
-				  struct mlx5_core_qp *qp,
-				  int rsc_type)
+static int create_resource_common(struct mlx5_ib_dev *dev,
+				  struct mlx5_core_qp *qp, int rsc_type)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	struct mlx5_qp_table *table = &dev->qp_table;
 	int err;
 
 	qp->common.res = rsc_type;
@@ -215,10 +172,10 @@ static int create_resource_common(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-static void destroy_resource_common(struct mlx5_core_dev *dev,
+static void destroy_resource_common(struct mlx5_ib_dev *dev,
 				    struct mlx5_core_qp *qp)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	struct mlx5_qp_table *table = &dev->qp_table;
 	unsigned long flags;
 
 	spin_lock_irqsave(&table->lock, flags);
@@ -229,24 +186,19 @@ static void destroy_resource_common(struct mlx5_core_dev *dev,
 	wait_for_completion(&qp->common.free);
 }
 
-static int _mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+static int _mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 				  struct mlx5_core_dct *dct, bool need_cleanup)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)] = {};
 	struct mlx5_core_qp *qp = &dct->mqp;
 	int err;
 
 	err = mlx5_core_drain_dct(dev, dct);
 	if (err) {
-		if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+		if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 			goto destroy;
-		} else {
-			mlx5_core_warn(
-				dev, "failed drain DCT 0x%x with error 0x%x\n",
-				qp->qpn, err);
-			return err;
-		}
+
+		return err;
 	}
 	wait_for_completion(&dct->drained);
 destroy:
@@ -255,15 +207,12 @@ static int _mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
 	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
 	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
 	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
-	err = mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
-			    (void *)&out, sizeof(out));
+	err = mlx5_cmd_exec_in(dev->mdev, destroy_dct, in);
 	return err;
 }
 
-int mlx5_core_create_dct(struct mlx5_core_dev *dev,
-			 struct mlx5_core_dct *dct,
-			 u32 *in, int inlen,
-			 u32 *out, int outlen)
+int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
+			 u32 *in, int inlen, u32 *out, int outlen)
 {
 	struct mlx5_core_qp *qp = &dct->mqp;
 	int err;
@@ -271,11 +220,9 @@ int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 	init_completion(&dct->drained);
 	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
 
-	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
-	if (err) {
-		mlx5_core_warn(dev, "create DCT failed, ret %d\n", err);
+	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, outlen);
+	if (err)
 		return err;
-	}
 
 	qp->qpn = MLX5_GET(create_dct_out, out, dctn);
 	qp->uid = MLX5_GET(create_dct_in, in, uid);
@@ -288,108 +235,83 @@ int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 	_mlx5_core_destroy_dct(dev, dct, false);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx5_core_create_dct);
 
-int mlx5_core_create_qp(struct mlx5_core_dev *dev,
-			struct mlx5_core_qp *qp,
+int mlx5_core_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 			u32 *in, int inlen)
 {
-	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {0};
-	u32 dout[MLX5_ST_SZ_DW(destroy_qp_out)];
-	u32 din[MLX5_ST_SZ_DW(destroy_qp_in)];
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	u32 din[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
 	int err;
 
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
 
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
 	if (err)
 		return err;
 
 	qp->uid = MLX5_GET(create_qp_in, in, uid);
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
-	mlx5_core_dbg(dev, "qpn = 0x%x\n", qp->qpn);
 
 	err = create_resource_common(dev, qp, MLX5_RES_QP);
 	if (err)
 		goto err_cmd;
 
-	err = mlx5_debug_qp_add(dev, qp);
-	if (err)
-		mlx5_core_dbg(dev, "failed adding QP 0x%x to debug file system\n",
-			      qp->qpn);
-
-	atomic_inc(&dev->num_qps);
+	mlx5_debug_qp_add(dev->mdev, qp);
 
 	return 0;
 
 err_cmd:
-	memset(din, 0, sizeof(din));
-	memset(dout, 0, sizeof(dout));
 	MLX5_SET(destroy_qp_in, din, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, din, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, din, uid, qp->uid);
-	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
+	mlx5_cmd_exec_in(dev->mdev, destroy_qp, din);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx5_core_create_qp);
 
-static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
+static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
 			       struct mlx5_core_dct *dct)
 {
-	u32 out[MLX5_ST_SZ_DW(drain_dct_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(drain_dct_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(drain_dct_in)] = {};
 	struct mlx5_core_qp *qp = &dct->mqp;
 
 	MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
 	MLX5_SET(drain_dct_in, in, dctn, qp->qpn);
 	MLX5_SET(drain_dct_in, in, uid, qp->uid);
-	return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
-			     (void *)&out, sizeof(out));
+	return mlx5_cmd_exec_in(dev->mdev, drain_dct, in);
 }
 
-int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 			  struct mlx5_core_dct *dct)
 {
 	return _mlx5_core_destroy_dct(dev, dct, true);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_destroy_dct);
 
-int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
-			 struct mlx5_core_qp *qp)
+int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_qp_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)]   = {0};
-	int err;
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
 
-	mlx5_debug_qp_remove(dev, qp);
+	mlx5_debug_qp_remove(dev->mdev, qp);
 
 	destroy_resource_common(dev, qp);
 
 	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
 	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
 	MLX5_SET(destroy_qp_in, in, uid, qp->uid);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (err)
-		return err;
-
-	atomic_dec(&dev->num_qps);
+	mlx5_cmd_exec_in(dev->mdev, destroy_qp, in);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mlx5_core_destroy_qp);
 
-int mlx5_core_set_delay_drop(struct mlx5_core_dev *dev,
+int mlx5_core_set_delay_drop(struct mlx5_ib_dev *dev,
 			     u32 timeout_usec)
 {
-	u32 out[MLX5_ST_SZ_DW(set_delay_drop_params_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(set_delay_drop_params_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(set_delay_drop_params_in)] = {};
 
 	MLX5_SET(set_delay_drop_params_in, in, opcode,
 		 MLX5_CMD_OP_SET_DELAY_DROP_PARAMS);
 	MLX5_SET(set_delay_drop_params_in, in, delay_drop_timeout,
 		 timeout_usec / 100);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev->mdev, set_delay_drop_params, in);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_set_delay_drop);
 
 struct mbox_info {
 	u32 *in;
@@ -495,120 +417,112 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 				  opt_param_mask, qpc, uid);
 		break;
 	default:
-		mlx5_core_err(dev, "Unknown transition for modify QP: OP(0x%x) QPN(0x%x)\n",
-			      opcode, qpn);
 		return -EINVAL;
 	}
 	return 0;
 }
 
-int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 opcode,
-			u32 opt_param_mask, void *qpc,
-			struct mlx5_core_qp *qp)
+int mlx5_core_qp_modify(struct mlx5_ib_dev *dev, u16 opcode, u32 opt_param_mask,
+			void *qpc, struct mlx5_core_qp *qp)
 {
 	struct mbox_info mbox;
 	int err;
 
-	err = modify_qp_mbox_alloc(dev, opcode, qp->qpn,
+	err = modify_qp_mbox_alloc(dev->mdev, opcode, qp->qpn,
 				   opt_param_mask, qpc, &mbox, qp->uid);
 	if (err)
 		return err;
 
-	err = mlx5_cmd_exec(dev, mbox.in, mbox.inlen, mbox.out, mbox.outlen);
+	err = mlx5_cmd_exec(dev->mdev, mbox.in, mbox.inlen, mbox.out,
+			    mbox.outlen);
 	mbox_free(&mbox);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx5_core_qp_modify);
 
-void mlx5_init_qp_table(struct mlx5_core_dev *dev)
+int mlx5_init_qp_table(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	struct mlx5_qp_table *table = &dev->qp_table;
 
-	memset(table, 0, sizeof(*table));
 	spin_lock_init(&table->lock);
 	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
-	mlx5_qp_debugfs_init(dev);
+	mlx5_qp_debugfs_init(dev->mdev);
 
 	table->nb.notifier_call = rsc_event_notifier;
-	mlx5_notifier_register(dev, &table->nb);
+	mlx5_notifier_register(dev->mdev, &table->nb);
+
+	return 0;
 }
 
-void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev)
+void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	struct mlx5_qp_table *table = &dev->qp_table;
 
-	mlx5_notifier_unregister(dev, &table->nb);
-	mlx5_qp_debugfs_cleanup(dev);
+	mlx5_notifier_unregister(dev->mdev, &table->nb);
+	mlx5_qp_debugfs_cleanup(dev->mdev);
 }
 
-int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
+int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 		       u32 *out, int outlen)
 {
-	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
 
 	MLX5_SET(query_qp_in, in, opcode, MLX5_CMD_OP_QUERY_QP);
 	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, outlen);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_qp_query);
 
-int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
+int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 			u32 *out, int outlen)
 {
-	u32 in[MLX5_ST_SZ_DW(query_dct_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_dct_in)] = {};
 	struct mlx5_core_qp *qp = &dct->mqp;
 
 	MLX5_SET(query_dct_in, in, opcode, MLX5_CMD_OP_QUERY_DCT);
 	MLX5_SET(query_dct_in, in, dctn, qp->qpn);
 
-	return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
-			     (void *)out, outlen);
+	return mlx5_cmd_exec(dev->mdev, (void *)&in, sizeof(in), (void *)out,
+			     outlen);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_dct_query);
 
-int mlx5_core_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn)
+int mlx5_core_xrcd_alloc(struct mlx5_ib_dev *dev, u32 *xrcdn)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(alloc_xrcd_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_xrcd_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_xrcd_in, in, opcode, MLX5_CMD_OP_ALLOC_XRCD);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev->mdev, alloc_xrcd, in, out);
 	if (!err)
 		*xrcdn = MLX5_GET(alloc_xrcd_out, out, xrcd);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx5_core_xrcd_alloc);
 
-int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
+int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_xrcd_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(dealloc_xrcd_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_xrcd_in)] = {};
 
 	MLX5_SET(dealloc_xrcd_in, in, opcode, MLX5_CMD_OP_DEALLOC_XRCD);
 	MLX5_SET(dealloc_xrcd_in, in, xrcd, xrcdn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev->mdev, dealloc_xrcd, in);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
 
-static void destroy_rq_tracked(struct mlx5_core_dev *dev, u32 rqn, u16 uid)
+static void destroy_rq_tracked(struct mlx5_ib_dev *dev, u32 rqn, u16 uid)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)]   = {};
-	u32 out[MLX5_ST_SZ_DW(destroy_rq_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)] = {};
 
 	MLX5_SET(destroy_rq_in, in, opcode, MLX5_CMD_OP_DESTROY_RQ);
 	MLX5_SET(destroy_rq_in, in, rqn, rqn);
 	MLX5_SET(destroy_rq_in, in, uid, uid);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev->mdev, destroy_rq, in);
 }
 
-int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
+int mlx5_core_create_rq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *rq)
 {
 	int err;
 	u32 rqn;
 
-	err = mlx5_core_create_rq(dev, in, inlen, &rqn);
+	err = mlx5_core_create_rq(dev->mdev, in, inlen, &rqn);
 	if (err)
 		return err;
 
@@ -625,39 +539,37 @@ int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 
 	return err;
 }
-EXPORT_SYMBOL(mlx5_core_create_rq_tracked);
 
-void mlx5_core_destroy_rq_tracked(struct mlx5_core_dev *dev,
+void mlx5_core_destroy_rq_tracked(struct mlx5_ib_dev *dev,
 				  struct mlx5_core_qp *rq)
 {
 	destroy_resource_common(dev, rq);
 	destroy_rq_tracked(dev, rq->qpn, rq->uid);
 }
-EXPORT_SYMBOL(mlx5_core_destroy_rq_tracked);
 
-static void destroy_sq_tracked(struct mlx5_core_dev *dev, u32 sqn, u16 uid)
+static void destroy_sq_tracked(struct mlx5_ib_dev *dev, u32 sqn, u16 uid)
 {
-	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)]   = {};
-	u32 out[MLX5_ST_SZ_DW(destroy_sq_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)] = {};
 
 	MLX5_SET(destroy_sq_in, in, opcode, MLX5_CMD_OP_DESTROY_SQ);
 	MLX5_SET(destroy_sq_in, in, sqn, sqn);
 	MLX5_SET(destroy_sq_in, in, uid, uid);
-	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(dev->mdev, destroy_sq, in);
 }
 
-int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
+int mlx5_core_create_sq_tracked(struct mlx5_ib_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *sq)
 {
+	u32 out[MLX5_ST_SZ_DW(create_sq_out)] = {};
 	int err;
-	u32 sqn;
 
-	err = mlx5_core_create_sq(dev, in, inlen, &sqn);
+	MLX5_SET(create_sq_in, in, opcode, MLX5_CMD_OP_CREATE_SQ);
+	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, sizeof(out));
 	if (err)
 		return err;
 
+	sq->qpn = MLX5_GET(create_sq_out, out, sqn);
 	sq->uid = MLX5_GET(create_sq_in, in, uid);
-	sq->qpn = sqn;
 	err = create_resource_common(dev, sq, MLX5_RES_SQ);
 	if (err)
 		goto err_destroy_sq;
@@ -669,29 +581,25 @@ int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 
 	return err;
 }
-EXPORT_SYMBOL(mlx5_core_create_sq_tracked);
 
-void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
+void mlx5_core_destroy_sq_tracked(struct mlx5_ib_dev *dev,
 				  struct mlx5_core_qp *sq)
 {
 	destroy_resource_common(dev, sq);
 	destroy_sq_tracked(dev, sq->qpn, sq->uid);
 }
-EXPORT_SYMBOL(mlx5_core_destroy_sq_tracked);
 
-struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
+struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_ib_dev *dev,
 						int res_num,
 						enum mlx5_res_type res_type)
 {
 	u32 rsn = res_num | (res_type << MLX5_USER_INDEX_LEN);
-	struct mlx5_qp_table *table = &dev->priv.qp_table;
+	struct mlx5_qp_table *table = &dev->qp_table;
 
 	return mlx5_get_rsc(table, rsn);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_res_hold);
 
 void mlx5_core_res_put(struct mlx5_core_rsc_common *res)
 {
 	mlx5_core_put_rsc(res);
 }
-EXPORT_SYMBOL_GPL(mlx5_core_res_put);
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 88c0388f9fc6..c851570791af 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -7,6 +7,7 @@
 #include <linux/mlx5/driver.h>
 #include "mlx5_ib.h"
 #include "srq.h"
+#include "qp.h"
 
 static int get_pas_size(struct mlx5_srq_attr *in)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 6d32915000fc..d3c7dbd7f1d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 # mlx5 core basic
 #
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
-		health.o mcg.o cq.o alloc.o qp.o port.o mr.o pd.o \
+		health.o mcg.o cq.o alloc.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index d40c3d5bd496..65fef5a86644 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -101,15 +101,15 @@ void mlx5_unregister_debugfs(void)
 
 void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev)
 {
-	atomic_set(&dev->num_qps, 0);
-
 	dev->priv.qp_debugfs = debugfs_create_dir("QPs",  dev->priv.dbg_root);
 }
+EXPORT_SYMBOL(mlx5_qp_debugfs_init);
 
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
 	debugfs_remove_recursive(dev->priv.qp_debugfs);
 }
+EXPORT_SYMBOL(mlx5_qp_debugfs_cleanup);
 
 void mlx5_eq_debugfs_init(struct mlx5_core_dev *dev)
 {
@@ -450,6 +450,7 @@ int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_debug_qp_add);
 
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 {
@@ -459,6 +460,7 @@ void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 	if (qp->dbg)
 		rem_res_tree(qp->dbg);
 }
+EXPORT_SYMBOL(mlx5_debug_qp_remove);
 
 int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bbe1a2110204..a1900aab129a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -850,8 +850,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	mlx5_cq_debugfs_init(dev);
 
-	mlx5_init_qp_table(dev);
-
 	mlx5_init_reserved_gids(dev);
 
 	mlx5_init_clock(dev);
@@ -910,7 +908,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 err_tables_cleanup:
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
-	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_events_cleanup(dev);
 err_eq_cleanup:
@@ -938,7 +935,6 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_vxlan_destroy(dev->vxlan);
 	mlx5_cleanup_clock(dev);
 	mlx5_cleanup_reserved_gids(dev);
-	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_events_cleanup(dev);
 	mlx5_eq_table_cleanup(dev);
diff --git a/include/linux/mlx5/cmd.h b/include/linux/mlx5/cmd.h
deleted file mode 100644
index 68cd08f02c2f..000000000000
--- a/include/linux/mlx5/cmd.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright (c) 2013-2015, Mellanox Technologies. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef MLX5_CMD_H
-#define MLX5_CMD_H
-
-#include <linux/types.h>
-
-struct manage_pages_layout {
-	u64	ptr;
-	u32	reserved;
-	u16	num_entries;
-	u16	func_id;
-};
-
-
-struct mlx5_cmd_alloc_uar_imm_out {
-	u32	rsvd[3];
-	u32	uarn;
-};
-
-#endif /* MLX5_CMD_H */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e44e889577a..df175bb9b8ad 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -541,7 +541,6 @@ struct mlx5_priv {
 	struct mlx5_core_health health;
 
 	/* start: qp staff */
-	struct mlx5_qp_table	qp_table;
 	struct dentry	       *qp_debugfs;
 	struct dentry	       *eq_debugfs;
 	struct dentry	       *cq_debugfs;
@@ -687,7 +686,6 @@ struct mlx5_core_dev {
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
 	struct mlx5_profile	*profile;
-	atomic_t		num_qps;
 	u32			issi;
 	struct mlx5e_resources  mlx5e_res;
 	struct mlx5_dm          *dm;
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 2413394298dc..c99abdf2f911 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -555,53 +555,8 @@ struct mlx5_qp_context {
 	u8			rsvd1[24];
 };
 
-static inline struct mlx5_core_qp *__mlx5_qp_lookup(struct mlx5_core_dev *dev, u32 qpn)
-{
-	return radix_tree_lookup(&dev->priv.qp_table.tree, qpn);
-}
-
-int mlx5_core_create_dct(struct mlx5_core_dev *dev,
-			 struct mlx5_core_dct *qp,
-			 u32 *in, int inlen,
-			 u32 *out, int outlen);
-int mlx5_core_create_qp(struct mlx5_core_dev *dev,
-			struct mlx5_core_qp *qp,
-			u32 *in,
-			int inlen);
-int mlx5_core_qp_modify(struct mlx5_core_dev *dev, u16 opcode,
-			u32 opt_param_mask, void *qpc,
-			struct mlx5_core_qp *qp);
-int mlx5_core_destroy_qp(struct mlx5_core_dev *dev,
-			 struct mlx5_core_qp *qp);
-int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
-			  struct mlx5_core_dct *dct);
-int mlx5_core_qp_query(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
-		       u32 *out, int outlen);
-int mlx5_core_dct_query(struct mlx5_core_dev *dev, struct mlx5_core_dct *dct,
-			u32 *out, int outlen);
-
-int mlx5_core_set_delay_drop(struct mlx5_core_dev *dev,
-			     u32 timeout_usec);
-
-int mlx5_core_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn);
-int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn);
-void mlx5_init_qp_table(struct mlx5_core_dev *dev);
-void mlx5_cleanup_qp_table(struct mlx5_core_dev *dev);
 int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp);
-int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
-				struct mlx5_core_qp *rq);
-void mlx5_core_destroy_rq_tracked(struct mlx5_core_dev *dev,
-				  struct mlx5_core_qp *rq);
-int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
-				struct mlx5_core_qp *sq);
-void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
-				  struct mlx5_core_qp *sq);
-
-struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
-						int res_num,
-						enum mlx5_res_type res_type);
-void mlx5_core_res_put(struct mlx5_core_rsc_common *res);
 
 static inline const char *mlx5_qp_type_str(int type)
 {
-- 
2.25.2

