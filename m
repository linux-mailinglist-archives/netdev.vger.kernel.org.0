Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEC51C062B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgD3TWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:22:12 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44415 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727080AbgD3TWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:22:00 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Apr 2020 22:21:54 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03UJLqAX004128;
        Thu, 30 Apr 2020 22:21:53 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V8 rdma-next 15/16] RDMA/mlx5: Refactor affinity related code
Date:   Thu, 30 Apr 2020 22:21:45 +0300
Message-Id: <20200430192146.12863-16-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200430192146.12863-1-maorg@mellanox.com>
References: <20200430192146.12863-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move affinity related code in modify qp to function.
It's a preparation for next patch the extend the affinity
calculation to consider the xmit slave.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 90 +++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2673678f1899..518abbda33c0 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3409,33 +3409,61 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return 0;
 }
 
-static unsigned int get_tx_affinity(struct mlx5_ib_dev *dev,
-				    struct mlx5_ib_pd *pd,
-				    struct mlx5_ib_qp_base *qp_base,
-				    u8 port_num, struct ib_udata *udata)
+static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
+				       struct ib_udata *udata)
 {
 	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
 		udata, struct mlx5_ib_ucontext, ibucontext);
-	unsigned int tx_port_affinity;
+	u8 port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	atomic_t *tx_port_affinity;
 
-	if (ucontext) {
-		tx_port_affinity = (unsigned int)atomic_add_return(
-					   1, &ucontext->tx_port_affinity) %
-					   MLX5_MAX_PORTS +
-				   1;
+	if (ucontext)
+		tx_port_affinity = &ucontext->tx_port_affinity;
+	else
+		tx_port_affinity = &dev->port[port_num].roce.tx_port_affinity;
+
+	return (unsigned int)atomic_add_return(1, tx_port_affinity) %
+		MLX5_MAX_PORTS + 1;
+}
+
+static bool qp_supports_affinity(struct ib_qp *qp)
+{
+	struct mlx5_ib_qp *mqp = to_mqp(qp);
+
+	if ((qp->qp_type == IB_QPT_RC) ||
+	    (qp->qp_type == IB_QPT_UD &&
+	     !(mqp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)) ||
+	    (qp->qp_type == IB_QPT_UC) ||
+	    (qp->qp_type == IB_QPT_RAW_PACKET) ||
+	    (qp->qp_type == IB_QPT_XRC_INI) ||
+	    (qp->qp_type == IB_QPT_XRC_TGT))
+		return true;
+	return false;
+}
+
+static unsigned int get_tx_affinity(struct ib_qp *qp, u8 init,
+				    struct ib_udata *udata)
+{
+	struct mlx5_ib_ucontext *ucontext = rdma_udata_to_drv_context(
+		udata, struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_qp *mqp = to_mqp(qp);
+	struct mlx5_ib_qp_base *qp_base;
+	unsigned int tx_affinity;
+
+	if (!(dev->lag_active && init && qp_supports_affinity(qp)))
+		return 0;
+
+	tx_affinity = get_tx_affinity_rr(dev, udata);
+
+	qp_base = &mqp->trans_qp.base;
+	if (ucontext)
 		mlx5_ib_dbg(dev, "Set tx affinity 0x%x to qpn 0x%x ucontext %p\n",
-				tx_port_affinity, qp_base->mqp.qpn, ucontext);
-	} else {
-		tx_port_affinity =
-			(unsigned int)atomic_add_return(
-				1, &dev->port[port_num].roce.tx_port_affinity) %
-				MLX5_MAX_PORTS +
-			1;
+			    tx_affinity, qp_base->mqp.qpn, ucontext);
+	else
 		mlx5_ib_dbg(dev, "Set tx affinity 0x%x to qpn 0x%x\n",
-				tx_port_affinity, qp_base->mqp.qpn);
-	}
-
-	return tx_port_affinity;
+			    tx_affinity, qp_base->mqp.qpn);
+	return tx_affinity;
 }
 
 static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
@@ -3546,22 +3574,10 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	if ((cur_state == IB_QPS_RESET) && (new_state == IB_QPS_INIT)) {
-		if ((ibqp->qp_type == IB_QPT_RC) ||
-		    (ibqp->qp_type == IB_QPT_UD &&
-		     !(qp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)) ||
-		    (ibqp->qp_type == IB_QPT_UC) ||
-		    (ibqp->qp_type == IB_QPT_RAW_PACKET) ||
-		    (ibqp->qp_type == IB_QPT_XRC_INI) ||
-		    (ibqp->qp_type == IB_QPT_XRC_TGT)) {
-			if (dev->lag_active) {
-				u8 p = mlx5_core_native_port_num(dev->mdev) - 1;
-				tx_affinity = get_tx_affinity(dev, pd, base, p,
-							      udata);
-				context->flags |= cpu_to_be32(tx_affinity << 24);
-			}
-		}
-	}
+	tx_affinity = get_tx_affinity(ibqp,
+				      cur_state == IB_QPS_RESET &&
+				      new_state == IB_QPS_INIT, udata);
+	context->flags |= cpu_to_be32(tx_affinity << 24);
 
 	if (is_sqp(ibqp->qp_type)) {
 		context->mtu_msgmax = (IB_MTU_256 << 5) | 8;
-- 
2.17.2

