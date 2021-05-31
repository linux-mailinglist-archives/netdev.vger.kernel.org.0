Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183A33969EA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhEaW7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:59:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232138AbhEaW7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:59:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMnt1N021113;
        Mon, 31 May 2021 15:55:19 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38vjqj36v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:55:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:55:17 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:55:14 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 22/27] qedn: Add IO level qedn_send_req and fw_cq workqueue
Date:   Tue, 1 Jun 2021 01:52:17 +0300
Message-ID: <20210531225222.16992-23-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZqpFuq_cgdunpiGikt0D8xLul3CS4L3y
X-Proofpoint-ORIG-GUID: ZqpFuq_cgdunpiGikt0D8xLul3CS4L3y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the IO level skeleton flows:

- qedn_send_req(): process new requests, similar to nvme_tcp_queue_rq().

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
 drivers/nvme/hw/qedn/Makefile    |  2 +-
 drivers/nvme/hw/qedn/qedn.h      | 13 +++++
 drivers/nvme/hw/qedn/qedn_conn.c |  2 +
 drivers/nvme/hw/qedn/qedn_main.c | 82 +++++++++++++++++++++++++++++---
 drivers/nvme/hw/qedn/qedn_task.c | 78 ++++++++++++++++++++++++++++++
 5 files changed, 169 insertions(+), 8 deletions(-)
 create mode 100644 drivers/nvme/hw/qedn/qedn_task.c

diff --git a/drivers/nvme/hw/qedn/Makefile b/drivers/nvme/hw/qedn/Makefile
index ece84772d317..888d466fa5ed 100644
--- a/drivers/nvme/hw/qedn/Makefile
+++ b/drivers/nvme/hw/qedn/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_NVME_QEDN) += qedn.o
-qedn-y := qedn_main.o qedn_conn.o
+qedn-y := qedn_main.o qedn_conn.o qedn_task.o
\ No newline at end of file
diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 5994b30e9b6e..4bc28e9ca08a 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -38,6 +38,8 @@
 #define QEDN_NON_ABORTIVE_TERMINATION 0
 #define QEDN_ABORTIVE_TERMINATION 1
 
+#define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
+
 /*
  * TCP offload stack default configurations and defines.
  * Future enhancements will allow controlling the configurable
@@ -90,6 +92,7 @@ struct qedn_fp_queue {
 	struct qedn_ctx	*qedn;
 	struct qed_sb_info *sb_info;
 	unsigned int cpu;
+	struct work_struct fw_cq_fp_wq_entry;
 	u16 sb_id;
 	char irqname[QEDN_IRQ_NAME_LEN];
 };
@@ -118,6 +121,7 @@ struct qedn_ctx {
 	struct qedn_fp_queue *fp_q_arr;
 	struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
 	dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_virt */
+	struct workqueue_struct *fw_cq_fp_wq;
 };
 
 struct qedn_endpoint {
@@ -204,6 +208,12 @@ struct qedn_ctrl {
 
 /* Connection level struct */
 struct qedn_conn_ctx {
+	/* IO path */
+	struct qedn_fp_queue *fp_q;
+	/* mutex for queueing request */
+	struct mutex send_mutex;
+	int qid;
+
 	struct qedn_ctx *qedn;
 	struct nvme_tcp_ofld_queue *queue;
 	struct nvme_tcp_ofld_ctrl *ctrl;
@@ -263,5 +273,8 @@ int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_
 void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx);
 void qedn_cleanp_fw(struct qedn_conn_ctx *conn_ctx);
 __be16 qedn_get_in_port(struct sockaddr_storage *sa);
+int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
+void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
+void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index c780c97b6d8a..97d7ffbe1a83 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -183,6 +183,7 @@ static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
 		pr_err("Conn resources state isn't 0 as expected 0x%lx\n",
 		       conn_ctx->resrc_state);
 
+	mutex_destroy(&conn_ctx->send_mutex);
 	atomic_inc(&conn_ctx->destroy_conn_indicator);
 	qedn_set_con_state(conn_ctx, CONN_STATE_DESTROY_COMPLETE);
 	wake_up_interruptible(&conn_ctx->conn_waitq);
@@ -417,6 +418,7 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 	}
 
 	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
+
 	rc = qed_ops->acquire_conn(qedn->cdev,
 				   &conn_ctx->conn_handle,
 				   &conn_ctx->fw_cid,
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index da37a801859f..0158823993a4 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -299,6 +299,7 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
 	conn_ctx->queue = queue;
 	conn_ctx->ctrl = ctrl;
 	conn_ctx->sq_depth = queue_size;
+	mutex_init(&conn_ctx->send_mutex);
 
 	init_waitqueue_head(&conn_ctx->conn_waitq);
 	atomic_set(&conn_ctx->est_conn_indicator, 0);
@@ -306,6 +307,8 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
 
 	spin_lock_init(&conn_ctx->conn_state_lock);
 
+	conn_ctx->qid = qid;
+
 	qedn_initialize_endpoint(&conn_ctx->ep, qedn->local_mac_addr, ctrl);
 
 	atomic_inc(&qctrl->host_num_active_conns);
@@ -397,9 +400,18 @@ static int qedn_poll_queue(struct nvme_tcp_ofld_queue *queue)
 
 static int qedn_send_req(struct nvme_tcp_ofld_req *req)
 {
-	/* Placeholder - qedn_send_req */
+	struct qedn_conn_ctx *qedn_conn;
+	int rc = 0;
 
-	return 0;
+	qedn_conn = (struct qedn_conn_ctx *)req->queue->private_data;
+	if (unlikely(!qedn_conn))
+		return -ENXIO;
+
+	mutex_lock(&qedn_conn->send_mutex);
+	rc = qedn_queue_request(qedn_conn, req);
+	mutex_unlock(&qedn_conn->send_mutex);
+
+	return rc;
 }
 
 static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
@@ -439,9 +451,57 @@ struct qedn_conn_ctx *qedn_get_conn_hash(struct qedn_ctx *qedn, u16 icid)
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
+	qed_sb_ack(fp_q->sb_info, IGU_INT_DISABLE, 0);
+	queue_work_on(fp_q->cpu, qedn->fw_cq_fp_wq, &fp_q->fw_cq_fp_wq_entry);
 
 	return IRQ_HANDLED;
 }
@@ -575,6 +635,8 @@ static void qedn_free_function_queues(struct qedn_ctx *qedn)
 	int i;
 
 	/* Free workqueues */
+	destroy_workqueue(qedn->fw_cq_fp_wq);
+	qedn->fw_cq_fp_wq = NULL;
 
 	/* Free the fast path queues*/
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
@@ -642,7 +704,14 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
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
 
 	qedn->fp_q_arr = kcalloc(qedn->num_fw_cqs,
 				 sizeof(struct qedn_fp_queue), GFP_KERNEL);
@@ -670,7 +739,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		chain_params.mode = QED_CHAIN_MODE_PBL,
 		chain_params.cnt_type = QED_CHAIN_CNT_TYPE_U16,
 		chain_params.num_elems = QEDN_FW_CQ_SIZE;
-		chain_params.elem_size = 64; /*Placeholder - sizeof(struct nvmetcp_fw_cqe)*/
+		chain_params.elem_size = sizeof(struct nvmetcp_fw_cqe);
 
 		rc = qed_ops->common->chain_alloc(qedn->cdev,
 						  &fp_q->cq_chain,
@@ -699,8 +768,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
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
index 000000000000..f1927da03250
--- /dev/null
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -0,0 +1,78 @@
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
+int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req)
+{
+	/* Process the request */
+
+	return 0;
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

