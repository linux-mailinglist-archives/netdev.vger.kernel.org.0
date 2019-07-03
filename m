Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AE5CD2D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfGBKDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfGBKDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:03:15 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 984C820665;
        Tue,  2 Jul 2019 10:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562061794;
        bh=wBCkRsnv9a1K8SJPoJTWZZwKmMKrVkDuueaN17ULxzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvCVaLoQQGQvUecyhCHFBy0RfJQU/Awt4JLwVFSZHYTc9Zp8ttDm/o9c62gHTHx3B
         U85gLFSylISqAUgeCx0Bq1VzvcMNLZmqHAL+QdwdUbIxqqj62Dg7R0aw6noZ37pHpO
         M8WttYUSGm68WKyPSeVIdoA9zzPwLSAGpn8NVUcg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v5 07/17] IB/mlx5: Support set qp counter
Date:   Tue,  2 Jul 2019 13:02:36 +0300
Message-Id: <20190702100246.17382-8-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Support bind a qp with counter. If counter is null then bind the qp to
the default counter. Different QP state has different operation:
- RESET: Set the counter field so that it will take effective
  during RST2INIT change;
- RTS: Issue an RTS2RTS change to update the QP counter;
- Other: Set the counter field and mark the counter_pending flag,
  when QP is moved to RTS state and this flag is set, then issue
  an RTS2RTS modification to update the counter.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++
 drivers/infiniband/hw/mlx5/qp.c      | 76 +++++++++++++++++++++++++++-
 include/linux/mlx5/qp.h              |  1 +
 3 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bdb83fc85f94..c0f4327bd1a5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -439,6 +439,10 @@ struct mlx5_ib_qp {
 	u32			flags_en;
 	/* storage for qp sub type when core qp type is IB_QPT_DRIVER */
 	enum ib_qp_type		qp_sub_type;
+	/* A flag to indicate if there's a new counter is configured
+	 * but not take effective
+	 */
+	u32                     counter_pending;
 };
 
 struct mlx5_ib_cq_buf {
@@ -1456,4 +1460,6 @@ void mlx5_ib_put_xlt_emergency_page(void);
 int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
 			bool dyn_bfreg);
+
+int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter);
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 4fbf60fed374..42375cdafd53 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -34,6 +34,7 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_cache.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/rdma_counter.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
 #include "ib_rep.h"
@@ -3380,6 +3381,35 @@ static unsigned int get_tx_affinity(struct mlx5_ib_dev *dev,
 	return tx_port_affinity;
 }
 
+static int __mlx5_ib_qp_set_counter(struct ib_qp *qp,
+				    struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_qp *mqp = to_mqp(qp);
+	struct mlx5_qp_context context = {};
+	struct mlx5_ib_port *mibport = NULL;
+	struct mlx5_ib_qp_base *base;
+	u32 set_id;
+
+	if (!MLX5_CAP_GEN(dev->mdev, rts2rts_qp_counters_set_id))
+		return 0;
+
+	if (counter) {
+		set_id = counter->id;
+	} else {
+		mibport = &dev->port[mqp->port - 1];
+		set_id = mibport->cnts.set_id;
+	}
+
+	base = &mqp->trans_qp.base;
+	context.qp_counter_set_usr_page &= cpu_to_be32(0xffffff);
+	context.qp_counter_set_usr_page |= cpu_to_be32(set_id << 24);
+	return mlx5_core_qp_modify(dev->mdev,
+				   MLX5_CMD_OP_RTS2RTS_QP,
+				   MLX5_QP_OPTPAR_COUNTER_SET_ID,
+				   &context, &base->mqp);
+}
+
 static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state,
@@ -3433,6 +3463,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	struct mlx5_ib_port *mibport = NULL;
 	enum mlx5_qp_state mlx5_cur, mlx5_new;
 	enum mlx5_qp_optpar optpar;
+	u32 set_id = 0;
 	int mlx5_st;
 	int err;
 	u16 op;
@@ -3595,8 +3626,12 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			port_num = 0;
 
 		mibport = &dev->port[port_num];
+		if (ibqp->counter)
+			set_id = ibqp->counter->id;
+		else
+			set_id = mibport->cnts.set_id;
 		context->qp_counter_set_usr_page |=
-			cpu_to_be32((u32)(mibport->cnts.set_id) << 24);
+			cpu_to_be32(set_id << 24);
 	}
 
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
@@ -3624,7 +3659,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 		raw_qp_param.operation = op;
 		if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
-			raw_qp_param.rq_q_ctr_id = mibport->cnts.set_id;
+			raw_qp_param.rq_q_ctr_id = set_id;
 			raw_qp_param.set_mask |= MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
 		}
 
@@ -3701,6 +3736,12 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		qp->db.db[MLX5_SND_DBR] = 0;
 	}
 
+	if ((new_state == IB_QPS_RTS) && qp->counter_pending) {
+		err = __mlx5_ib_qp_set_counter(ibqp, ibqp->counter);
+		if (!err)
+			qp->counter_pending = 0;
+	}
+
 out:
 	kfree(context);
 	return err;
@@ -6435,3 +6476,34 @@ void mlx5_ib_drain_rq(struct ib_qp *qp)
 
 	handle_drain_completion(cq, &rdrain, dev);
 }
+
+/**
+ * Bind a qp to a counter. If @counter is NULL then bind the qp to
+ * the default counter
+ */
+int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
+{
+	struct mlx5_ib_qp *mqp = to_mqp(qp);
+	int err = 0;
+
+	mutex_lock(&mqp->mutex);
+	if (mqp->state == IB_QPS_RESET) {
+		qp->counter = counter;
+		goto out;
+	}
+
+	if (mqp->state == IB_QPS_RTS) {
+		err = __mlx5_ib_qp_set_counter(qp, counter);
+		if (!err)
+			qp->counter = counter;
+
+		goto out;
+	}
+
+	mqp->counter_pending = 1;
+	qp->counter = counter;
+
+out:
+	mutex_unlock(&mqp->mutex);
+	return err;
+}
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 08e43cd9e742..a8270869f0b6 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -71,6 +71,7 @@ enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_CQN_RCV			= 1 << 19,
 	MLX5_QP_OPTPAR_DC_HS			= 1 << 20,
 	MLX5_QP_OPTPAR_DC_KEY			= 1 << 21,
+	MLX5_QP_OPTPAR_COUNTER_SET_ID		= 1 << 25,
 };
 
 enum mlx5_qp_state {
-- 
2.20.1

