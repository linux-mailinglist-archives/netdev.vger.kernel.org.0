Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2E836F05A
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhD2TSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:18:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242145AbhD2TOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:14:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ5LQu027396;
        Thu, 29 Apr 2021 12:11:12 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 387rpnamv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:11:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:11:10 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:11:06 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 22/27] qedn: Add IO level nvme_req and fw_cq workqueues
Date:   Thu, 29 Apr 2021 22:09:21 +0300
Message-ID: <20210429190926.5086-23-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: JG0YL0qbbHaWSi2cC_2mEB0juIfYoEEm
X-Proofpoint-ORIG-GUID: JG0YL0qbbHaWSi2cC_2mEB0juIfYoEEm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the IO level workqueues:

- qedn_nvme_req_fp_wq(): process new requests, similar to
			 nvme_tcp_io_work(). The flow starts from
			 send_req() and will aggregate all the requests
			 on this CPU core.

- qedn_fw_cq_fp_wq():   process new FW completions, the flow starts from
			the IRQ handler and for a single interrupt it will
			process all the pending NVMeoF Completions under
			polling mode.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/qedn/Makefile    |   2 +-
 drivers/nvme/hw/qedn/qedn.h      |  29 +++++++
 drivers/nvme/hw/qedn/qedn_conn.c |   3 +
 drivers/nvme/hw/qedn/qedn_main.c | 114 +++++++++++++++++++++++--
 drivers/nvme/hw/qedn/qedn_task.c | 138 +++++++++++++++++++++++++++++++
 5 files changed, 278 insertions(+), 8 deletions(-)
 create mode 100644 drivers/nvme/hw/qedn/qedn_task.c

diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makefile
index d8b343afcd16..c7d838a61ae6 100644
--- a/drivers/nvme/hw/qedn/Makefile
+++ b/drivers/nvme/hw/qedn/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_NVME_QEDN) += qedn.o
-qedn-y := qedn_main.o qedn_conn.o
+qedn-y := qedn_main.o qedn_conn.o qedn_task.o
\ No newline at end of file
diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index c15cac37ec1e..bd9a250cb2f5 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -47,6 +47,9 @@
 #define QEDN_NON_ABORTIVE_TERMINATION 0
 #define QEDN_ABORTIVE_TERMINATION 1
 
+#define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
+#define QEDN_NVME_REQ_FP_WQ_WORKQUEUE "qedn_nvme_req_fp_wq"
+
 /*
  * TCP offload stack default configurations and defines.
  * Future enhancements will allow controlling the configurable
@@ -100,6 +103,7 @@ struct qedn_fp_queue {
 	struct qedn_ctx	*qedn;
 	struct qed_sb_info *sb_info;
 	unsigned int cpu;
+	struct work_struct fw_cq_fp_wq_entry;
 	u16 sb_id;
 	char irqname[QEDN_IRQ_NAME_LEN];
 };
@@ -131,6 +135,8 @@ struct qedn_ctx {
 	struct qedn_fp_queue *fp_q_arr;
 	struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
 	dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_virt */
+	struct workqueue_struct *nvme_req_fp_wq;
+	struct workqueue_struct *fw_cq_fp_wq;
 };
 
 struct qedn_endpoint {
@@ -213,6 +219,25 @@ struct qedn_ctrl {
 
 /* Connection level struct */
 struct qedn_conn_ctx {
+	/* IO path */
+	struct workqueue_struct	*nvme_req_fp_wq; /* ptr to qedn->nvme_req_fp_wq */
+	struct nvme_tcp_ofld_req *req; /* currently proccessed request */
+
+	struct list_head host_pend_req_list;
+	/* Spinlock to access pending request list */
+	spinlock_t nvme_req_lock;
+	unsigned int cpu;
+
+	/* Entry for registering to nvme_req_fp_wq */
+	struct work_struct nvme_req_fp_wq_entry;
+	/*
+	 * Spinlock for accessing qedn_process_req as it can be called
+	 * from multiple place like queue_rq, async, self requeued
+	 */
+	struct mutex nvme_req_mutex;
+	struct qedn_fp_queue *fp_q;
+	int qid;
+
 	struct qedn_ctx *qedn;
 	struct nvme_tcp_ofld_queue *queue;
 	struct nvme_tcp_ofld_ctrl *ctrl;
@@ -280,5 +305,9 @@ int qedn_wait_for_conn_est(struct qedn_conn_ctx *conn_ctx);
 int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state);
 void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx, int abrt_flag);
 __be16 qedn_get_in_port(struct sockaddr_storage *sa);
+inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 cccid);
+void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
+void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
+void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index 9bfc0a5f0cdb..90d8aa36d219 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -385,6 +385,9 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 	}
 
 	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
+	INIT_LIST_HEAD(&conn_ctx->host_pend_req_list);
+	spin_lock_init(&conn_ctx->nvme_req_lock);
+
 	rc = qed_ops->acquire_conn(qedn->cdev,
 				   &conn_ctx->conn_handle,
 				   &conn_ctx->fw_cid,
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 8b5714e7e2bb..38f23dbb03a5 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -267,6 +267,18 @@ static int qedn_release_ctrl(struct nvme_tcp_ofld_ctrl *ctrl)
 	return 0;
 }
 
+static void qedn_set_ctrl_io_cpus(struct qedn_conn_ctx *conn_ctx, int qid)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_fp_queue *fp_q = NULL;
+	int index;
+
+	index = qid ? (qid - 1) % qedn->num_fw_cqs : 0;
+	fp_q = &qedn->fp_q_arr[index];
+
+	conn_ctx->cpu = fp_q->cpu;
+}
+
 static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t q_size)
 {
 	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
@@ -288,6 +300,7 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t
 	conn_ctx->queue = queue;
 	conn_ctx->ctrl = ctrl;
 	conn_ctx->sq_depth = q_size;
+	qedn_set_ctrl_io_cpus(conn_ctx, qid);
 
 	init_waitqueue_head(&conn_ctx->conn_waitq);
 	atomic_set(&conn_ctx->est_conn_indicator, 0);
@@ -295,6 +308,10 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t
 
 	spin_lock_init(&conn_ctx->conn_state_lock);
 
+	INIT_WORK(&conn_ctx->nvme_req_fp_wq_entry, qedn_nvme_req_fp_wq_handler);
+	conn_ctx->nvme_req_fp_wq = qedn->nvme_req_fp_wq;
+	conn_ctx->qid = qid;
+
 	qedn_initialize_endpoint(&conn_ctx->ep, qedn->local_mac_addr,
 				 &ctrl->conn_params);
 
@@ -356,6 +373,7 @@ static void qedn_destroy_queue(struct nvme_tcp_ofld_queue *queue)
 	if (!conn_ctx)
 		return;
 
+	cancel_work_sync(&conn_ctx->nvme_req_fp_wq_entry);
 	qedn_terminate_connection(conn_ctx, QEDN_ABORTIVE_TERMINATION);
 
 	qedn_queue_wait_for_terminate_complete(conn_ctx);
@@ -385,12 +403,24 @@ static int qedn_init_req(struct nvme_tcp_ofld_req *req)
 
 static void qedn_commit_rqs(struct nvme_tcp_ofld_queue *queue)
 {
-	/* Placeholder - queue work */
+	struct qedn_conn_ctx *conn_ctx;
+
+	conn_ctx = (struct qedn_conn_ctx *)queue->private_data;
+
+	if (!list_empty(&conn_ctx->host_pend_req_list))
+		queue_work_on(conn_ctx->cpu, conn_ctx->nvme_req_fp_wq,
+			      &conn_ctx->nvme_req_fp_wq_entry);
 }
 
 static int qedn_send_req(struct nvme_tcp_ofld_req *req)
 {
-	/* Placeholder - qedn_send_req */
+	struct qedn_conn_ctx *qedn_conn = (struct qedn_conn_ctx *)req->queue->private_data;
+
+	/* Under the assumption that the cccid/tag will be in the range of 0 to sq_depth-1. */
+	if (!req->async && qedn_validate_cccid_in_range(qedn_conn, req->rq->tag))
+		return BLK_STS_NOTSUPP;
+
+	qedn_queue_request(qedn_conn, req);
 
 	return 0;
 }
@@ -434,9 +464,59 @@ struct qedn_conn_ctx *qedn_get_conn_hash(struct qedn_ctx *qedn, u16 icid)
 }
 
 /* Fastpath IRQ handler */
+void qedn_fw_cq_fp_handler(struct qedn_fp_queue *fp_q)
+{
+	u16 sb_id, cq_prod_idx, cq_cons_idx;
+	struct qedn_ctx *qedn = fp_q->qedn;
+	struct nvmetcp_fw_cqe *cqe = NULL;
+
+	sb_id = fp_q->sb_id;
+	qed_sb_update_sb_idx(fp_q->sb_info);
+
+	/* rmb - to prevent missing new cqes */
+	rmb();
+
+	/* Read the latest cq_prod from the SB */
+	cq_prod_idx = *fp_q->cq_prod;
+	cq_cons_idx = qed_chain_get_cons_idx(&fp_q->cq_chain);
+
+	while (cq_cons_idx != cq_prod_idx) {
+		cqe = qed_chain_consume(&fp_q->cq_chain);
+		if (likely(cqe))
+			qedn_io_work_cq(qedn, cqe);
+		else
+			pr_err("Failed consuming cqe\n");
+
+		cq_cons_idx = qed_chain_get_cons_idx(&fp_q->cq_chain);
+
+		/* Check if new completions were posted */
+		if (unlikely(cq_prod_idx == cq_cons_idx)) {
+			/* rmb - to prevent missing new cqes */
+			rmb();
+
+			/* Update the latest cq_prod from the SB */
+			cq_prod_idx = *fp_q->cq_prod;
+		}
+	}
+}
+
+static void qedn_fw_cq_fq_wq_handler(struct work_struct *work)
+{
+	struct qedn_fp_queue *fp_q = container_of(work, struct qedn_fp_queue, fw_cq_fp_wq_entry);
+
+	qedn_fw_cq_fp_handler(fp_q);
+	qed_sb_ack(fp_q->sb_info, IGU_INT_ENABLE, 1);
+}
+
 static irqreturn_t qedn_irq_handler(int irq, void *dev_id)
 {
-	/* Placeholder */
+	struct qedn_fp_queue *fp_q = dev_id;
+	struct qedn_ctx *qedn = fp_q->qedn;
+
+	fp_q->cpu = smp_processor_id();
+
+	qed_sb_ack(fp_q->sb_info, IGU_INT_DISABLE, 0);
+	queue_work_on(fp_q->cpu, qedn->fw_cq_fp_wq, &fp_q->fw_cq_fp_wq_entry);
 
 	return IRQ_HANDLED;
 }
@@ -584,6 +664,11 @@ static void qedn_free_function_queues(struct qedn_ctx *qedn)
 	int i;
 
 	/* Free workqueues */
+	destroy_workqueue(qedn->fw_cq_fp_wq);
+	qedn->fw_cq_fp_wq = NULL;
+
+	destroy_workqueue(qedn->nvme_req_fp_wq);
+	qedn->nvme_req_fp_wq = NULL;
 
 	/* Free the fast path queues*/
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
@@ -651,7 +736,23 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 	u64 cq_phy_addr;
 	int i;
 
-	/* Place holder - IO-path workqueues */
+	qedn->fw_cq_fp_wq = alloc_workqueue(QEDN_FW_CQ_FP_WQ_WORKQUEUE,
+					    WQ_HIGHPRI | WQ_MEM_RECLAIM, 0);
+	if (!qedn->fw_cq_fp_wq) {
+		rc = -ENODEV;
+		pr_err("Unable to create fastpath FW CQ workqueue!\n");
+
+		return rc;
+	}
+
+	qedn->nvme_req_fp_wq = alloc_workqueue(QEDN_NVME_REQ_FP_WQ_WORKQUEUE,
+					       WQ_HIGHPRI | WQ_MEM_RECLAIM, 1);
+	if (!qedn->nvme_req_fp_wq) {
+		rc = -ENODEV;
+		pr_err("Unable to create fastpath qedn nvme workqueue!\n");
+
+		return rc;
+	}
 
 	qedn->fp_q_arr = kcalloc(qedn->num_fw_cqs,
 				 sizeof(struct qedn_fp_queue), GFP_KERNEL);
@@ -679,7 +780,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		chain_params.mode = QED_CHAIN_MODE_PBL,
 		chain_params.cnt_type = QED_CHAIN_CNT_TYPE_U16,
 		chain_params.num_elems = QEDN_FW_CQ_SIZE;
-		chain_params.elem_size = 64; /*Placeholder - sizeof(struct nvmetcp_fw_cqe)*/
+		chain_params.elem_size = sizeof(struct nvmetcp_fw_cqe);
 
 		rc = qed_ops->common->chain_alloc(qedn->cdev,
 						  &fp_q->cq_chain,
@@ -708,8 +809,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		sb = fp_q->sb_info->sb_virt;
 		fp_q->cq_prod = (u16 *)&sb->pi_array[QEDN_PROTO_CQ_PROD_IDX];
 		fp_q->qedn = qedn;
-
-		/* Placeholder - Init IO-path workqueue */
+		INIT_WORK(&fp_q->fw_cq_fp_wq_entry, qedn_fw_cq_fq_wq_handler);
 
 		/* Placeholder - Init IO-path resources */
 	}
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
new file mode 100644
index 000000000000..d3474188efdc
--- /dev/null
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2021 Marvell. All rights reserved.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+ /* Kernel includes */
+#include <linux/kernel.h>
+
+/* Driver includes */
+#include "qedn.h"
+
+inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 cccid)
+{
+	int rc = 0;
+
+	if (unlikely(cccid >= conn_ctx->sq_depth)) {
+		pr_err("cccid 0x%x out of range ( > sq depth)\n", cccid);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
+{
+	return true;
+}
+
+/* The WQ handler can be call from 3 flows:
+ *	1. queue_rq.
+ *	2. async.
+ *	3. self requeued
+ * Try to send requests from the pending list. If a request proccess has failed,
+ * re-register to the workqueue.
+ * If there are no additional pending requests - exit the handler.
+ */
+void qedn_nvme_req_fp_wq_handler(struct work_struct *work)
+{
+	struct qedn_conn_ctx *qedn_conn;
+	bool more = false;
+
+	qedn_conn = container_of(work, struct qedn_conn_ctx, nvme_req_fp_wq_entry);
+	do {
+		if (mutex_trylock(&qedn_conn->nvme_req_mutex)) {
+			more = qedn_process_req(qedn_conn);
+			qedn_conn->req = NULL;
+			mutex_unlock(&qedn_conn->nvme_req_mutex);
+		}
+	} while (more);
+
+	if (!list_empty(&qedn_conn->host_pend_req_list))
+		queue_work_on(qedn_conn->cpu, qedn_conn->nvme_req_fp_wq,
+			      &qedn_conn->nvme_req_fp_wq_entry);
+}
+
+void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req)
+{
+	bool empty, res = false;
+
+	spin_lock(&qedn_conn->nvme_req_lock);
+	empty = list_empty(&qedn_conn->host_pend_req_list) && !qedn_conn->req;
+	list_add_tail(&req->queue_entry, &qedn_conn->host_pend_req_list);
+	spin_unlock(&qedn_conn->nvme_req_lock);
+
+	/* attempt workqueue bypass */
+	if (qedn_conn->cpu == smp_processor_id() && empty &&
+	    mutex_trylock(&qedn_conn->nvme_req_mutex)) {
+		res = qedn_process_req(qedn_conn);
+		qedn_conn->req = NULL;
+		mutex_unlock(&qedn_conn->nvme_req_mutex);
+		if (res || list_empty(&qedn_conn->host_pend_req_list))
+			return;
+	} else if (req->last) {
+		queue_work_on(qedn_conn->cpu, qedn_conn->nvme_req_fp_wq,
+			      &qedn_conn->nvme_req_fp_wq_entry);
+	}
+}
+
+struct qedn_task_ctx *qedn_cqe_get_active_task(struct nvmetcp_fw_cqe *cqe)
+{
+	struct regpair *p = &cqe->task_opaque;
+
+	return (struct qedn_task_ctx *)((((u64)(le32_to_cpu(p->hi)) << 32)
+					+ le32_to_cpu(p->lo)));
+}
+
+void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
+{
+	struct qedn_task_ctx *qedn_task = NULL;
+	struct qedn_conn_ctx *conn_ctx = NULL;
+	u16 itid;
+	u32 cid;
+
+	conn_ctx = qedn_get_conn_hash(qedn, le16_to_cpu(cqe->conn_id));
+	if (unlikely(!conn_ctx)) {
+		pr_err("CID 0x%x: Failed to fetch conn_ctx from hash\n",
+		       le16_to_cpu(cqe->conn_id));
+
+		return;
+	}
+
+	cid = conn_ctx->fw_cid;
+	itid = le16_to_cpu(cqe->itid);
+	qedn_task = qedn_cqe_get_active_task(cqe);
+	if (unlikely(!qedn_task))
+		return;
+
+	if (likely(cqe->cqe_type == NVMETCP_FW_CQE_TYPE_NORMAL)) {
+		/* Placeholder - verify the connection was established */
+
+		switch (cqe->task_type) {
+		case NVMETCP_TASK_TYPE_HOST_WRITE:
+		case NVMETCP_TASK_TYPE_HOST_READ:
+
+			/* Placeholder - IO flow */
+
+			break;
+
+		case NVMETCP_TASK_TYPE_HOST_READ_NO_CQE:
+
+			/* Placeholder - IO flow */
+
+			break;
+
+		case NVMETCP_TASK_TYPE_INIT_CONN_REQUEST:
+
+			/* Placeholder - ICReq flow */
+
+			break;
+		default:
+			pr_info("Could not identify task type\n");
+		}
+	} else {
+		/* Placeholder - Recovery flows */
+	}
+}
-- 
2.22.0

