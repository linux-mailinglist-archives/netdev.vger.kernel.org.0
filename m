Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5894456A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392958AbfFMQn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730440AbfFMG1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:27:17 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274D32133D;
        Thu, 13 Jun 2019 06:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407235;
        bh=f9yo1R0O8+J7AxFy1DLwnWgI9SYPXFyZUI36nP1xDXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQ3BuPjft3FX3FiyUFdmGA1WEOtxPy8vIZA9XVO6eJ6DDIlGhpIr7QEMNEddKUVAl
         dWzHQQszqGu1wxXszA8h7jDg/rZ8OHuWznfXnLeFPuInFrVie2WY8TBHejh66frYxT
         SkMaRiNxg1yKh7eUvojcCcy+v2vSpI3p/lpiFRBs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 06/12] net/mlx5: Report EQE data upon CQ completion
Date:   Thu, 13 Jun 2019 09:26:34 +0300
Message-Id: <20190613062640.28958-7-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Report EQE data upon CQ completion to let upper layers use this data.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c                     | 2 +-
 drivers/infiniband/hw/mlx5/main.c                   | 2 +-
 drivers/infiniband/hw/mlx5/qp.c                     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c        | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 3 ++-
 include/linux/mlx5/cq.h                             | 4 ++--
 9 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 9f39e7b9dd1b..fa6d49d583fe 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -37,7 +37,7 @@
 #include "mlx5_ib.h"
 #include "srq.h"
 
-static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq)
+static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
 {
 	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 33709fd93ab2..8850e3f9c855 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4463,7 +4463,7 @@ static void mlx5_ib_handle_internal_error(struct mlx5_ib_dev *ibdev)
 	 * lock/unlock above locks Now need to arm all involved CQs.
 	 */
 	list_for_each_entry(mcq, &cq_armed_list, reset_notify) {
-		mcq->comp(mcq);
+		mcq->comp(mcq, NULL);
 	}
 	spin_unlock_irqrestore(&ibdev->reset_flow_resource_lock, flags);
 }
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 63d8f61e50e0..f240e022682b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -6409,7 +6409,7 @@ static void handle_drain_completion(struct ib_cq *cq,
 		/* Run the CQ handler - this makes sure that the drain WR will
 		 * be processed if wasn't processed yet.
 		 */
-		mcq->mcq.comp(&mcq->mcq);
+		mcq->mcq.comp(&mcq->mcq, NULL);
 	}
 
 	wait_for_completion(&sdrain->done);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 1bd4336392a2..818edc63e428 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -58,7 +58,7 @@ void mlx5_cq_tasklet_cb(unsigned long data)
 	list_for_each_entry_safe(mcq, temp, &ctx->process_list,
 				 tasklet_ctx.list) {
 		list_del_init(&mcq->tasklet_ctx.list);
-		mcq->tasklet_ctx.comp(mcq);
+		mcq->tasklet_ctx.comp(mcq, NULL);
 		mlx5_cq_put(mcq);
 		if (time_after(jiffies, end))
 			break;
@@ -68,7 +68,8 @@ void mlx5_cq_tasklet_cb(unsigned long data)
 		tasklet_schedule(&ctx->task);
 }
 
-static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq)
+static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
+				   struct mlx5_eqe *eqe)
 {
 	unsigned long flags;
 	struct mlx5_eq_tasklet *tasklet_ctx = cq->tasklet_ctx.priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3a183d690e23..16753f263079 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -780,7 +780,7 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
 
 void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
-void mlx5e_completion_event(struct mlx5_core_cq *mcq);
+void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
 void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
 int mlx5e_napi_poll(struct napi_struct *napi, int budget);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index f9862bf75491..c665ae0f22bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -136,7 +136,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-void mlx5e_completion_event(struct mlx5_core_cq *mcq)
+void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
 {
 	struct mlx5e_cq *cq = container_of(mcq, struct mlx5e_cq, mcq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c2a679657c34..396e66c379a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -144,7 +144,7 @@ static irqreturn_t mlx5_eq_comp_int(int irq, void *eq_ptr)
 		cq = mlx5_eq_cq_get(eq, cqn);
 		if (likely(cq)) {
 			++cq->arm_sn;
-			cq->comp(cq);
+			cq->comp(cq, eqe);
 			mlx5_cq_put(cq);
 		} else {
 			mlx5_core_warn(eq->dev, "Completion event for bogus CQ 0x%x\n", cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index dc7b9d9f274d..028891823f32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -414,7 +414,8 @@ static void mlx5_fpga_conn_cq_tasklet(unsigned long data)
 	mlx5_fpga_conn_cqes(conn, MLX5_FPGA_CQ_BUDGET);
 }
 
-static void mlx5_fpga_conn_cq_complete(struct mlx5_core_cq *mcq)
+static void mlx5_fpga_conn_cq_complete(struct mlx5_core_cq *mcq,
+				       struct mlx5_eqe *eqe)
 {
 	struct mlx5_fpga_conn *conn;
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index e44157a2b7db..40748fc1b11b 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -47,7 +47,7 @@ struct mlx5_core_cq {
 	struct completion	free;
 	unsigned		vector;
 	unsigned int		irqn;
-	void (*comp)		(struct mlx5_core_cq *);
+	void (*comp)(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe);
 	void (*event)		(struct mlx5_core_cq *, enum mlx5_event);
 	u32			cons_index;
 	unsigned		arm_sn;
@@ -55,7 +55,7 @@ struct mlx5_core_cq {
 	int			pid;
 	struct {
 		struct list_head list;
-		void (*comp)(struct mlx5_core_cq *);
+		void (*comp)(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe);
 		void		*priv;
 	} tasklet_ctx;
 	int			reset_notify_added;
-- 
2.20.1

