Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809A5393A0A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhE1AGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:06:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236616AbhE1AFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:05:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14S015Yi008069;
        Thu, 27 May 2021 17:01:56 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38sxpmd05g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 17:01:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 17:01:54 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 27 May 2021 17:01:51 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>
Subject: [RFC PATCH v6 23/27] qedn: Add support of Task and SGL
Date:   Fri, 28 May 2021 02:58:58 +0300
Message-ID: <20210527235902.2185-24-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210527235902.2185-1-smalin@marvell.com>
References: <20210527235902.2185-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R41dx9fOTp__RLgICK3qbefhdrsRmLJw
X-Proofpoint-GUID: R41dx9fOTp__RLgICK3qbefhdrsRmLJw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_13:2021-05-27,2021-05-27 signatures=0
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
 drivers/nvme/hw/qedn/qedn.h      |  65 +++++++
 drivers/nvme/hw/qedn/qedn_conn.c |  44 ++++-
 drivers/nvme/hw/qedn/qedn_main.c |  34 +++-
 drivers/nvme/hw/qedn/qedn_task.c | 320 +++++++++++++++++++++++++++++++
 4 files changed, 459 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index d56184f58840..cfb5e1b0fbaa 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -40,6 +40,20 @@
 
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
+#define QEDN_INVALID_ITID 0xFFFF
+
 /*
  * TCP offload stack default configurations and defines.
  * Future enhancements will allow controlling the configurable
@@ -84,6 +98,15 @@ enum qedn_state {
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
@@ -93,6 +116,10 @@ struct qedn_fp_queue {
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
@@ -116,12 +143,35 @@ struct qedn_ctx {
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
@@ -220,6 +270,7 @@ struct qedn_conn_ctx {
 	struct nvme_tcp_ofld_ctrl *ctrl;
 	u32 conn_handle;
 	u32 fw_cid;
+	u8 default_cq;
 
 	atomic_t est_conn_indicator;
 	atomic_t destroy_conn_indicator;
@@ -237,6 +288,11 @@ struct qedn_conn_ctx {
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
@@ -256,6 +312,7 @@ struct qedn_conn_ctx {
 enum qedn_conn_resources_state {
 	QEDN_CONN_RESRC_FW_SQ,
 	QEDN_CONN_RESRC_ACQUIRE_CONN,
+	QEDN_CONN_RESRC_TASKS,
 	QEDN_CONN_RESRC_CCCID_ITID_MAP,
 	QEDN_CONN_RESRC_TCP_PORT,
 	QEDN_CONN_RESRC_DB_ADD,
@@ -278,5 +335,13 @@ inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 ccci
 int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
 void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
 void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe);
+int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx);
+inline int qedn_qid(struct nvme_tcp_ofld_queue *queue);
+void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task_params);
+void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
+struct qedn_task_ctx *
+qedn_get_free_task_from_pool(struct qedn_conn_ctx *conn_ctx, u16 cccid);
+void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
+			     struct qedn_io_resources *io_resrc);
 
 #endif /* _QEDN_H_ */
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index 049db20b69e8..7e38edccbb56 100644
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
@@ -159,6 +164,11 @@ static void qedn_release_conn_ctx(struct qedn_conn_ctx *conn_ctx)
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
@@ -261,6 +271,7 @@ static int qedn_nvmetcp_offload_conn(struct qedn_conn_ctx *conn_ctx)
 	offld_prms.max_rt_time = QEDN_TCP_MAX_RT_TIME;
 	offld_prms.sq_pbl_addr =
 		(u64)qed_chain_get_pbl_phys(&qedn_ep->fw_sq_chain);
+	offld_prms.default_cq = conn_ctx->default_cq;
 
 	rc = qed_ops->offload_conn(qedn->cdev,
 				   conn_ctx->conn_handle,
@@ -398,6 +409,9 @@ void qedn_prep_db_data(struct qedn_conn_ctx *conn_ctx)
 static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 {
 	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct qedn_io_resources *io_resrc;
+	struct qedn_fp_queue *fp_q;
+	u8 default_cq_idx, qid;
 	size_t dma_size;
 	int rc;
 
@@ -409,6 +423,9 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 
 	set_bit(QEDN_CONN_RESRC_FW_SQ, &conn_ctx->resrc_state);
 
+	atomic_set(&conn_ctx->num_active_tasks, 0);
+	atomic_set(&conn_ctx->num_active_fw_tasks, 0);
+
 	rc = qed_ops->acquire_conn(qedn->cdev,
 				   &conn_ctx->conn_handle,
 				   &conn_ctx->fw_cid,
@@ -422,7 +439,32 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
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
index db8c27dd8876..444db6d58a0a 100644
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
@@ -437,6 +443,8 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
 		 *	NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
 		 *	NVMF_OPT_NR_POLL_QUEUES | NVMF_OPT_TOS
 		 */
+	.max_hw_sectors = QEDN_MAX_HW_SECTORS,
+	.max_segments = QEDN_MAX_SEGMENTS,
 	.claim_dev = qedn_claim_dev,
 	.setup_ctrl = qedn_setup_ctrl,
 	.release_ctrl = qedn_release_ctrl,
@@ -642,8 +650,24 @@ static inline int qedn_core_probe(struct qedn_ctx *qedn)
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
@@ -655,6 +679,9 @@ static void qedn_free_function_queues(struct qedn_ctx *qedn)
 	/* Free the fast path queues*/
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
 		fp_q = &qedn->fp_q_arr[i];
+		host_resrc = &fp_q->host_resrc;
+
+		qedn_call_destroy_free_tasks(fp_q, host_resrc);
 
 		/* Free SB */
 		sb_info = fp_q->sb_info;
@@ -742,7 +769,8 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		goto mem_alloc_failure;
 	}
 
-	/* placeholder - create task pools */
+	qedn->num_tasks_per_pool =
+		qedn->pf_params.nvmetcp_pf_params.num_tasks / qedn->num_fw_cqs;
 
 	for (i = 0; i < qedn->num_fw_cqs; i++) {
 		fp_q = &qedn->fp_q_arr[i];
@@ -784,7 +812,7 @@ static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
 		fp_q->qedn = qedn;
 		INIT_WORK(&fp_q->fw_cq_fp_wq_entry, qedn_fw_cq_fq_wq_handler);
 
-		/* Placeholder - Init IO-path resources */
+		qedn_init_io_resc(&fp_q->host_resrc);
 	}
 
 	return 0;
@@ -966,7 +994,7 @@ static int __qedn_probe(struct pci_dev *pdev)
 
 	/* NVMeTCP start HW PF */
 	rc = qed_ops->start(qedn->cdev,
-			    NULL /* Placeholder for FW IO-path resources */,
+			    &qedn->tasks,
 			    qedn,
 			    qedn_event_cb);
 	if (rc) {
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index ea6745b94817..35cb5e8e4e61 100644
--- a/drivers/nvme/hw/qedn/qedn_task.c
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -11,6 +11,198 @@
 /* Driver includes */
 #include "qedn.h"
 
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
@@ -23,6 +215,134 @@ inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 ccci
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
 int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req)
 {
 	/* Process the request */
-- 
2.22.0

