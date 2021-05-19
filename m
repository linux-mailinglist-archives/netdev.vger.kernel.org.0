Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED5388C91
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhESLUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:20:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19538 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349787AbhESLT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:19:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBBDJH008736;
        Wed, 19 May 2021 04:16:14 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38mqcwhy87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:16:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:16:11 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:16:08 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>
Subject: [RFC PATCH v5 23/27] qedn: Add support of Task and SGL
Date:   Wed, 19 May 2021 14:13:36 +0300
Message-ID: <20210519111340.20613-24-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: umoxuDAMYKMm6LsOcNuDrT91qo564nuG
X-Proofpoint-ORIG-GUID: umoxuDAMYKMm6LsOcNuDrT91qo564nuG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prabhakar Kushwaha <pkushwaha@marvell.com>

This patch will add support of Task and SGL which is used
for slowpath and fast path IO. here Task is IO granule used
by firmware to perform tasks

The internal implementation:
- Create task/sgl resources used by all connection
- Provide APIs to allocate and free task.
- Add task support during connection establishment i.e. slowpath

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/qedn/qedn.h      |  66 +++++
 drivers/nvme/hw/qedn/qedn_conn.c |  44 +++-
 drivers/nvme/hw/qedn/qedn_main.c |  34 ++-
 drivers/nvme/hw/qedn/qedn_task.c | 411 +++++++++++++++++++++++++++++++
 4 files changed, 551 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 18411c3a9596..19637789e826 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -49,6 +49,21 @@
 
 #define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
 
+/* Protocol defines */
+#define QEDN_MAX_IO_SIZE QED_NVMETCP_MAX_IO_SIZE
+
+#define QEDN_SGE_BUFF_SIZE 4096
+#define QEDN_MAX_SGES_PER_TASK DIV_ROUND_UP(QEDN_MAX_IO_SIZE, QEDN_SGE_BUFF_SIZE)
+#define QEDN_FW_SGE_SIZE sizeof(struct nvmetcp_sge)
+#define QEDN_MAX_FW_SGL_SIZE ((QEDN_MAX_SGES_PER_TASK) * QEDN_FW_SGE_SIZE)
+#define QEDN_FW_SLOW_IO_MIN_SGE_LIMIT (9700 / 6)
+
+#define QEDN_MAX_HW_SECTORS (QEDN_MAX_IO_SIZE / 512)
+#define QEDN_MAX_SEGMENTS QEDN_MAX_SGES_PER_TASK
+
+#define QEDN_TASK_INSIST_TMO 1000 /* 1 sec */
+#define QEDN_INVALID_ITID 0xFFFF
+
 /*
  * TCP offload stack default configurations and defines.
  * Future enhancements will allow controlling the configurable
@@ -93,6 +108,15 @@ enum qedn_state {
 	QEDN_STATE_MODULE_REMOVE_ONGOING,
 };
 
+struct qedn_io_resources {
+	/* Lock for IO resources */
+	spinlock_t resources_lock;
+	struct list_head task_free_list;
+	u32 num_alloc_tasks;
+	u32 num_free_tasks;
+	u32 no_avail_resrc_cnt;
+};
+
 /* Per CPU core params */
 struct qedn_fp_queue {
 	struct qed_chain cq_chain;
@@ -102,6 +126,10 @@ struct qedn_fp_queue {
 	struct qed_sb_info *sb_info;
 	unsigned int cpu;
 	struct work_struct fw_cq_fp_wq_entry;
+
+	/* IO related resources for host */
+	struct qedn_io_resources host_resrc;
+
 	u16 sb_id;
 	char irqname[QEDN_IRQ_NAME_LEN];
 };
@@ -125,12 +153,35 @@ struct qedn_ctx {
 	/* Connections */
 	DECLARE_HASHTABLE(conn_ctx_hash, 16);
 
+	u32 num_tasks_per_pool;
+
 	/* Fast path queues */
 	u8 num_fw_cqs;
 	struct qedn_fp_queue *fp_q_arr;
 	struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
 	dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_virt */
 	struct workqueue_struct *fw_cq_fp_wq;
+
+	/* Fast Path Tasks */
+	struct qed_nvmetcp_tid	tasks;
+};
+
+struct qedn_task_ctx {
+	struct qedn_conn_ctx *qedn_conn;
+	struct qedn_ctx *qedn;
+	void *fw_task_ctx;
+	struct qedn_fp_queue *fp_q;
+	struct scatterlist *nvme_sg;
+	struct nvme_tcp_ofld_req *req; /* currently proccessed request */
+	struct list_head entry;
+	spinlock_t lock; /* To protect task resources */
+	bool valid;
+	unsigned long flags; /* Used by qedn_task_flags */
+	u32 task_size;
+	u16 itid;
+	u16 cccid;
+	int req_direction;
+	struct storage_sgl_task_params sgl_task_params;
 };
 
 struct qedn_endpoint {
@@ -224,6 +275,7 @@ struct qedn_conn_ctx {
 	struct nvme_tcp_ofld_ctrl *ctrl;
 	u32 conn_handle;
 	u32 fw_cid;
+	u8 default_cq;
 
 	atomic_t est_conn_indicator;
 	atomic_t destroy_conn_indicator;
@@ -241,6 +293,11 @@ struct qedn_conn_ctx {
 	dma_addr_t host_cccid_itid_phy_addr;
 	struct qedn_endpoint ep;
 	int abrt_flag;
+	/* Spinlock for accessing active_task_list */
+	spinlock_t task_list_lock;
+	struct list_head active_task_list;
+	atomic_t num_active_tasks;
+	atomic_t num_active_fw_tasks;
 
 	/* Connection resources - turned on to indicate what resource was
 	 * allocated, to that it can later be released.
@@ -260,6 +317,7 @@ struct qedn_conn_ctx {
 enum qedn_conn_resources_state {
 	QEDN_CONN_RESRC_FW_SQ,
 	QEDN_CONN_RESRC_ACQUIRE_CONN,
+	QEDN_CONN_RESRC_TASKS,
 	QEDN_CONN_RESRC_CCCID_ITID_MAP,
 	QEDN_CONN_RESRC_TCP_PORT,
 	QEDN_CONN_RESRC_DB_ADD,
@@ -281,5 +339,13 @@ inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 ccci
 void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
 void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
 void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe);
+int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx);
+inline int qedn_qid(struct nvme_tcp_ofld_queue *queue);
+struct qedn_task_ctx *
+	qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u16 cccid);
+void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task_params);
+void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
+void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
+			     struct qedn_io_resources *io_resrc);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index a66f77b823b0..4461c27ce49d 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -29,6 +29,11 @@ static const char * const qedn_conn_state_str[] = {
 	NULL
 };
 
+inline int qedn_qid(struct nvme_tcp_ofld_queue *queue)
+{
+	return queue - queue->ctrl->queues;
+}
+
 int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_state)
 {
 	spin_lock_bh(&conn_ctx->conn_state_lock);
@@ -156,6 +161,11 @@ static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
 		clear_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
 	}
 
+	if (test_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state)) {
+		clear_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state);
+			qedn_return_active_tasks(conn_ctx);
+	}
+
 	if (test_bit(QEDN_CONN_RESRC_CCCID_ITID_MAP, &conn_ctx->resrc_state)) {
 		dma_free_coherent(&qedn->pdev->dev,
 				  conn_ctx->sq_depth *
@@ -257,6 +267,7 @@ static int qedn_nvmetcp_offload_conn(struct qedn_conn_ctx *conn_ctx)
 	offld_prms.max_rt_time = QEDN_TCP_MAX_RT_TIME;
 	offld_prms.sq_pbl_addr =
 		(u64)qed_chain_get_pbl_phys(&qedn_ep->fw_sq_chain);
+	offld_prms.default_cq = conn_ctx->default_cq;
 
 	rc = qed_ops->offload_conn(qedn->cdev,
 				   conn_ctx->conn_handle,
@@ -394,6 +405,9 @@ void qedn_prep_db_data(struct qedn_conn_ctx *conn_ctx)
 static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 {
 	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_io_resources *io_resrc;
+	struct qedn_fp_queue *fp_q;
+	u8 default_cq_idx, qid;
 	size_t dma_size;
 	int rc;
 
@@ -405,6 +419,9 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 
 	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
 
+	atomic_set(&conn_ctx->num_active_tasks, 0);
+	atomic_set(&conn_ctx->num_active_fw_tasks, 0);
+
 	rc = qed_ops->acquire_conn(qedn->cdev,
 				   &conn_ctx->conn_handle,
 				   &conn_ctx->fw_cid,
@@ -418,7 +435,32 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 		 conn_ctx->conn_handle);
 	set_bit(QEDN_CONN_RESRC_ACQUIRE_CONN, &conn_ctx->resrc_state);
 
-	/* Placeholder - Allocate task resources and initialize fields */
+	qid = qedn_qid(conn_ctx->queue);
+	default_cq_idx = qid ? qid - 1 : 0; /* Offset adminq */
+
+	conn_ctx->default_cq = (default_cq_idx % qedn->num_fw_cqs);
+	fp_q = &qedn->fp_q_arr[conn_ctx->default_cq];
+	conn_ctx->fp_q = fp_q;
+	io_resrc = &fp_q->host_resrc;
+
+	/* The first connection on each fp_q will fill task
+	 * resources
+	 */
+	spin_lock(&io_resrc->resources_lock);
+	if (io_resrc->num_alloc_tasks == 0) {
+		rc = qedn_alloc_tasks(conn_ctx);
+		if (rc) {
+			pr_err("Failed allocating tasks: CID=0x%x\n",
+			       conn_ctx->fw_cid);
+			spin_unlock(&io_resrc->resources_lock);
+			goto rel_conn;
+		}
+	}
+	spin_unlock(&io_resrc->resources_lock);
+
+	spin_lock_init(&conn_ctx->task_list_lock);
+	INIT_LIST_HEAD(&conn_ctx->active_task_list);
+	set_bit(QEDN_CONN_RESRC_TASKS, &conn_ctx->resrc_state);
 
 	rc = qedn_fetch_tcp_port(conn_ctx);
 	if (rc)
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index 22f602349773..08a52106d077 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -29,6 +29,12 @@ __be16 qedn_get_in_port(struct sockaddr_storage *sa)
 		: ((struct sockaddr_in6 *)sa)->sin6_port;
 }
 
+static void qedn_init_io_resc(struct qedn_io_resources *io_resrc)
+{
+	spin_lock_init(&io_resrc->resources_lock);
+	INIT_LIST_HEAD(&io_resrc->task_free_list);
+}
+
 struct qedn_llh_filter *qedn_add_llh_filter(struct qedn_ctx *qedn, u16 tcp_port)
 {
 	struct qedn_llh_filter *llh_filter = NULL;
@@ -401,6 +407,8 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
 		 *	NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
 		 *	NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
 		 */
+	.max_hw_sectors = QEDN_MAX_HW_SECTORS,
+	.max_segments = QEDN_MAX_SEGMENTS,
 	.claim_dev = qedn_claim_dev,
 	.setup_ctrl = qedn_setup_ctrl,
 	.release_ctrl = qedn_release_ctrl,
@@ -608,8 +616,24 @@ static inline int qedn_core_probe(struct qedn_ctx *qedn)
 	return rc;
 }
 
+static void qedn_call_destroy_free_tasks(struct qedn_fp_queue *fp_q,
+					 struct qedn_io_resources *io_resrc)
+{
+	if (list_empty(&io_resrc->task_free_list))
+		return;
+
+	if (io_resrc->num_alloc_tasks != io_resrc->num_free_tasks)
+		pr_err("Task Pool:Not all returned allocated=0x%x, free=0x%x\n",
+		       io_resrc->num_alloc_tasks, io_resrc->num_free_tasks);
+
+	qedn_destroy_free_tasks(fp_q, io_resrc);
+	if (io_resrc->num_free_tasks)
+		pr_err("Expected num_free_tasks to be 0\n");
+}
+
 static void qedn_free_function_queues(struct qedn_ctx *qedn)
 {
+	struct qedn_io_resources *host_resrc;
 	struct qed_sb_info *sb_info = NULL;
 	struct qedn_fp_queue *fp_q;
 	int i;
@@ -621,6 +645,9 @@ static void qedn_free_function_queues(struct qedn_ctx *qedn)
 	/* Free the fast path queues*/
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
 		fp_q = &qedn->fp_q_arr[i];
+		host_resrc = &fp_q->host_resrc;
+
+		qedn_call_destroy_free_tasks(fp_q, host_resrc);
 
 		/* Free SB */
 		sb_info = fp_q->sb_info;
@@ -708,7 +735,8 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		goto mem_alloc_failure;
 	}
 
-	/* placeholder - create task pools */
+	qedn->num_tasks_per_pool =
+		qedn->pf_params.nvmetcp_pf_params.num_tasks / qedn->num_fw_cqs;
 
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
 		fp_q = &qedn->fp_q_arr[i];
@@ -750,7 +778,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		fp_q->qedn = qedn;
 		INIT_WORK(&fp_q->fw_cq_fp_wq_entry, qedn_fw_cq_fq_wq_handler);
 
-		/* Placeholder - Init IO-path resources */
+		qedn_init_io_resc(&fp_q->host_resrc);
 	}
 
 	return 0;
@@ -936,7 +964,7 @@ static int __qedn_probe(struct pci_dev *pdev)
 
 	/* NVMeTCP start HW PF */
 	rc = qed_ops->start(qedn->cdev,
-			    NULL /* Placeholder for FW IO-path resources */,
+			    &qedn->tasks,
 			    qedn,
 			    qedn_event_cb);
 	if (rc) {
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index 56f0af855f6e..4d3a3e2ec152 100644
--- a/drivers/nvme/hw/qedn/qedn_task.c
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -11,6 +11,263 @@
 /* Driver includes */
 #include "qedn.h"
 
+static bool qedn_sgl_has_small_mid_sge(struct nvmetcp_sge *sgl, u16 sge_count)
+{
+	u16 sge_num;
+
+	if (sge_count > 8) {
+		for (sge_num = 0; sge_num < sge_count; sge_num++) {
+			if (le32_to_cpu(sgl[sge_num].sge_len) <
+			    QEDN_FW_SLOW_IO_MIN_SGE_LIMIT)
+				return true; /* small middle SGE found */
+		}
+	}
+
+	return false; /* no small middle SGEs */
+}
+
+static int qedn_init_sgl(struct qedn_ctx *qedn, struct qedn_task_ctx *qedn_task)
+{
+	struct storage_sgl_task_params *sgl_task_params;
+	enum dma_data_direction dma_dir;
+	struct scatterlist *sg;
+	struct request *rq;
+	u16 num_sges;
+	int index;
+	int rc;
+
+	sgl_task_params = &qedn_task->sgl_task_params;
+	rq = blk_mq_rq_from_pdu(qedn_task->req);
+	if (qedn_task->task_size == 0) {
+		sgl_task_params->num_sges = 0;
+
+		return 0;
+	}
+
+	/* Convert BIO to scatterlist */
+	num_sges = blk_rq_map_sg(rq->q, rq, qedn_task->nvme_sg);
+	if (qedn_task->req_direction == WRITE)
+		dma_dir = DMA_TO_DEVICE;
+	else
+		dma_dir = DMA_FROM_DEVICE;
+
+	/* DMA map the scatterlist */
+	if (dma_map_sg(&qedn->pdev->dev, qedn_task->nvme_sg, num_sges, dma_dir) != num_sges) {
+		pr_err("Couldn't map sgl\n");
+		rc = -EPERM;
+
+		return rc;
+	}
+
+	sgl_task_params->total_buffer_size = qedn_task->task_size;
+	sgl_task_params->num_sges = num_sges;
+
+	for_each_sg(qedn_task->nvme_sg, sg, num_sges, index) {
+		DMA_REGPAIR_LE(sgl_task_params->sgl[index].sge_addr, sg_dma_address(sg));
+		sgl_task_params->sgl[index].sge_len = cpu_to_le32(sg_dma_len(sg));
+	}
+
+	/* Relevant for Host Write Only */
+	sgl_task_params->small_mid_sge = (qedn_task->req_direction == READ) ?
+		false :
+		qedn_sgl_has_small_mid_sge(sgl_task_params->sgl,
+					   sgl_task_params->num_sges);
+
+	return 0;
+}
+
+static void qedn_free_nvme_sg(struct qedn_task_ctx *qedn_task)
+{
+	kfree(qedn_task->nvme_sg);
+	qedn_task->nvme_sg = NULL;
+}
+
+static void qedn_free_fw_sgl(struct qedn_task_ctx *qedn_task)
+{
+	struct qedn_ctx *qedn = qedn_task->qedn;
+	dma_addr_t sgl_pa;
+
+	sgl_pa = HILO_DMA_REGPAIR(qedn_task->sgl_task_params.sgl_phys_addr);
+	dma_free_coherent(&qedn->pdev->dev,
+			  QEDN_MAX_FW_SGL_SIZE,
+			  qedn_task->sgl_task_params.sgl,
+			  sgl_pa);
+	qedn_task->sgl_task_params.sgl = NULL;
+}
+
+static void qedn_destroy_single_task(struct qedn_task_ctx *qedn_task)
+{
+	u16 itid;
+
+	itid = qedn_task->itid;
+	list_del(&qedn_task->entry);
+	qedn_free_nvme_sg(qedn_task);
+	qedn_free_fw_sgl(qedn_task);
+	kfree(qedn_task);
+	qedn_task = NULL;
+}
+
+void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
+			     struct qedn_io_resources *io_resrc)
+{
+	struct qedn_task_ctx *qedn_task, *task_tmp;
+
+	/* Destroy tasks from the free task list */
+	list_for_each_entry_safe(qedn_task, task_tmp,
+				 &io_resrc->task_free_list, entry) {
+		qedn_destroy_single_task(qedn_task);
+		io_resrc->num_free_tasks -= 1;
+	}
+}
+
+static int qedn_alloc_nvme_sg(struct qedn_task_ctx *qedn_task)
+{
+	int rc;
+
+	qedn_task->nvme_sg = kcalloc(QEDN_MAX_SGES_PER_TASK,
+				     sizeof(*qedn_task->nvme_sg), GFP_KERNEL);
+	if (!qedn_task->nvme_sg) {
+		rc = -ENOMEM;
+
+		return rc;
+	}
+
+	return 0;
+}
+
+static int qedn_alloc_fw_sgl(struct qedn_task_ctx *qedn_task)
+{
+	struct qedn_ctx *qedn = qedn_task->qedn_conn->qedn;
+	dma_addr_t fw_sgl_phys;
+
+	qedn_task->sgl_task_params.sgl =
+		dma_alloc_coherent(&qedn->pdev->dev, QEDN_MAX_FW_SGL_SIZE,
+				   &fw_sgl_phys, GFP_KERNEL);
+	if (!qedn_task->sgl_task_params.sgl) {
+		pr_err("Couldn't allocate FW sgl\n");
+
+		return -ENOMEM;
+	}
+
+	DMA_REGPAIR_LE(qedn_task->sgl_task_params.sgl_phys_addr, fw_sgl_phys);
+
+	return 0;
+}
+
+static inline void *qedn_get_fw_task(struct qed_nvmetcp_tid *info, u16 itid)
+{
+	return (void *)(info->blocks[itid / info->num_tids_per_block] +
+			(itid % info->num_tids_per_block) * info->size);
+}
+
+static struct qedn_task_ctx *qedn_alloc_task(struct qedn_conn_ctx *conn_ctx, u16 itid)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_task_ctx *qedn_task;
+	void *fw_task_ctx;
+	int rc = 0;
+
+	qedn_task = kzalloc(sizeof(*qedn_task), GFP_KERNEL);
+	if (!qedn_task)
+		return NULL;
+
+	spin_lock_init(&qedn_task->lock);
+	fw_task_ctx = qedn_get_fw_task(&qedn->tasks, itid);
+	if (!fw_task_ctx) {
+		pr_err("iTID: 0x%x; Failed getting fw_task_ctx memory\n", itid);
+		goto release_task;
+	}
+
+	/* No need to memset fw_task_ctx - its done in the HSI func */
+	qedn_task->qedn_conn = conn_ctx;
+	qedn_task->qedn = qedn;
+	qedn_task->fw_task_ctx = fw_task_ctx;
+	qedn_task->valid = 0;
+	qedn_task->flags = 0;
+	qedn_task->itid = itid;
+	rc = qedn_alloc_fw_sgl(qedn_task);
+	if (rc) {
+		pr_err("iTID: 0x%x; Failed allocating FW sgl\n", itid);
+		goto release_task;
+	}
+
+	rc = qedn_alloc_nvme_sg(qedn_task);
+	if (rc) {
+		pr_err("iTID: 0x%x; Failed allocating FW sgl\n", itid);
+		goto release_fw_sgl;
+	}
+
+	return qedn_task;
+
+release_fw_sgl:
+	qedn_free_fw_sgl(qedn_task);
+release_task:
+	kfree(qedn_task);
+
+	return NULL;
+}
+
+int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_task_ctx *qedn_task = NULL;
+	struct qedn_io_resources *io_resrc;
+	u16 itid, start_itid, offset;
+	struct qedn_fp_queue *fp_q;
+	int i, rc;
+
+	fp_q = conn_ctx->fp_q;
+
+	offset = fp_q->sb_id;
+	io_resrc = &fp_q->host_resrc;
+
+	start_itid = qedn->num_tasks_per_pool * offset;
+	for (i = 0; i < qedn->num_tasks_per_pool; ++i) {
+		itid = start_itid + i;
+		qedn_task = qedn_alloc_task(conn_ctx, itid);
+		if (!qedn_task) {
+			pr_err("Failed allocating task\n");
+			rc = -ENOMEM;
+			goto release_tasks;
+		}
+
+		qedn_task->fp_q = fp_q;
+		io_resrc->num_free_tasks += 1;
+		list_add_tail(&qedn_task->entry, &io_resrc->task_free_list);
+	}
+
+	io_resrc->num_alloc_tasks = io_resrc->num_free_tasks;
+
+	return 0;
+
+release_tasks:
+	qedn_destroy_free_tasks(fp_q, io_resrc);
+
+	return rc;
+}
+
+void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task_params)
+{
+	u16 sge_cnt = sgl_task_params->num_sges;
+
+	memset(&sgl_task_params->sgl[(sge_cnt - 1)], 0,
+	       sizeof(struct nvmetcp_sge));
+	sgl_task_params->total_buffer_size = 0;
+	sgl_task_params->small_mid_sge = false;
+	sgl_task_params->num_sges = 0;
+}
+
+inline void qedn_host_reset_cccid_itid_entry(struct qedn_conn_ctx *conn_ctx,
+					     u16 cccid)
+{
+	conn_ctx->host_cccid_itid[cccid].itid = cpu_to_le16(QEDN_INVALID_ITID);
+}
+
+inline void qedn_host_set_cccid_itid_entry(struct qedn_conn_ctx *conn_ctx, u16 cccid, u16 itid)
+{
+	conn_ctx->host_cccid_itid[cccid].itid = cpu_to_le16(itid);
+}
+
 inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 cccid)
 {
 	int rc = 0;
@@ -23,6 +280,160 @@ inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 ccci
 	return rc;
 }
 
+static void qedn_clear_sgl(struct qedn_ctx *qedn,
+			   struct qedn_task_ctx *qedn_task)
+{
+	struct storage_sgl_task_params *sgl_task_params;
+	enum dma_data_direction dma_dir;
+	u32 sge_cnt;
+
+	sgl_task_params = &qedn_task->sgl_task_params;
+	sge_cnt = sgl_task_params->num_sges;
+
+	/* Nothing to do if no SGEs were used */
+	if (!qedn_task->task_size || !sge_cnt)
+		return;
+
+	dma_dir = (qedn_task->req_direction == WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	dma_unmap_sg(&qedn->pdev->dev, qedn_task->nvme_sg, sge_cnt, dma_dir);
+	memset(&qedn_task->nvme_sg[(sge_cnt - 1)], 0, sizeof(struct scatterlist));
+	qedn_common_clear_fw_sgl(sgl_task_params);
+	qedn_task->task_size = 0;
+}
+
+static void qedn_clear_task(struct qedn_conn_ctx *conn_ctx,
+			    struct qedn_task_ctx *qedn_task)
+{
+	/* Task lock isn't needed since it is no longer in use */
+	qedn_clear_sgl(conn_ctx->qedn, qedn_task);
+	qedn_task->valid = 0;
+	qedn_task->flags = 0;
+
+	atomic_dec(&conn_ctx->num_active_tasks);
+}
+
+void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_fp_queue *fp_q = conn_ctx->fp_q;
+	struct qedn_task_ctx *qedn_task, *task_tmp;
+	struct qedn_io_resources *io_resrc;
+	int num_returned_tasks = 0;
+	int num_active_tasks;
+
+	io_resrc = &fp_q->host_resrc;
+
+	/* Return tasks that aren't "Used by FW" to the pool */
+	list_for_each_entry_safe(qedn_task, task_tmp,
+				 &conn_ctx->active_task_list, entry) {
+		qedn_clear_task(conn_ctx, qedn_task);
+		num_returned_tasks++;
+	}
+
+	if (num_returned_tasks) {
+		spin_lock(&io_resrc->resources_lock);
+		/* Return tasks to FP_Q pool in one shot */
+
+		list_splice_tail_init(&conn_ctx->active_task_list,
+				      &io_resrc->task_free_list);
+		io_resrc->num_free_tasks += num_returned_tasks;
+		spin_unlock(&io_resrc->resources_lock);
+	}
+
+	num_active_tasks = atomic_read(&conn_ctx->num_active_tasks);
+	if (num_active_tasks)
+		pr_err("num_active_tasks is %u after cleanup.\n", num_active_tasks);
+}
+
+void qedn_return_task_to_pool(struct qedn_conn_ctx *conn_ctx,
+			      struct qedn_task_ctx *qedn_task)
+{
+	struct qedn_fp_queue *fp_q = conn_ctx->fp_q;
+	struct qedn_io_resources *io_resrc;
+	unsigned long lock_flags;
+
+	io_resrc = &fp_q->host_resrc;
+
+	spin_lock_irqsave(&qedn_task->lock, lock_flags);
+	qedn_task->valid = 0;
+	qedn_task->flags = 0;
+	qedn_clear_sgl(conn_ctx->qedn, qedn_task);
+	spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
+
+	spin_lock(&conn_ctx->task_list_lock);
+	list_del(&qedn_task->entry);
+	qedn_host_reset_cccid_itid_entry(conn_ctx, qedn_task->cccid);
+	spin_unlock(&conn_ctx->task_list_lock);
+
+	atomic_dec(&conn_ctx->num_active_tasks);
+	atomic_dec(&conn_ctx->num_active_fw_tasks);
+
+	spin_lock(&io_resrc->resources_lock);
+	list_add_tail(&qedn_task->entry, &io_resrc->task_free_list);
+	io_resrc->num_free_tasks += 1;
+	spin_unlock(&io_resrc->resources_lock);
+}
+
+struct qedn_task_ctx *
+qedn_get_free_task_from_pool(struct qedn_conn_ctx *conn_ctx, u16 cccid)
+{
+	struct qedn_task_ctx *qedn_task = NULL;
+	struct qedn_io_resources *io_resrc;
+	struct qedn_fp_queue *fp_q;
+
+	fp_q = conn_ctx->fp_q;
+	io_resrc = &fp_q->host_resrc;
+
+	spin_lock(&io_resrc->resources_lock);
+	qedn_task = list_first_entry_or_null(&io_resrc->task_free_list,
+					     struct qedn_task_ctx, entry);
+	if (unlikely(!qedn_task)) {
+		spin_unlock(&io_resrc->resources_lock);
+
+		return NULL;
+	}
+	list_del(&qedn_task->entry);
+	io_resrc->num_free_tasks -= 1;
+	spin_unlock(&io_resrc->resources_lock);
+
+	spin_lock(&conn_ctx->task_list_lock);
+	list_add_tail(&qedn_task->entry, &conn_ctx->active_task_list);
+	qedn_host_set_cccid_itid_entry(conn_ctx, cccid, qedn_task->itid);
+	spin_unlock(&conn_ctx->task_list_lock);
+
+	atomic_inc(&conn_ctx->num_active_tasks);
+	qedn_task->cccid = cccid;
+	qedn_task->qedn_conn = conn_ctx;
+	qedn_task->valid = 1;
+
+	return qedn_task;
+}
+
+struct qedn_task_ctx *
+qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u16 cccid)
+{
+	struct qedn_task_ctx *qedn_task = NULL;
+	unsigned long timeout;
+
+	qedn_task = qedn_get_free_task_from_pool(conn_ctx, cccid);
+	if (unlikely(!qedn_task)) {
+		timeout = msecs_to_jiffies(QEDN_TASK_INSIST_TMO) + jiffies;
+		while (1) {
+			qedn_task = qedn_get_free_task_from_pool(conn_ctx, cccid);
+			if (likely(qedn_task))
+				break;
+
+			msleep(100);
+			if (time_after(jiffies, timeout)) {
+				pr_err("Failed on timeout of fetching task\n");
+
+				return NULL;
+			}
+		}
+	}
+
+	return qedn_task;
+}
+
 static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
 {
 	return true;
-- 
2.22.0

