Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8F36F05B
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhD2TSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:18:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242214AbhD2TOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:14:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ5Arl027348;
        Thu, 29 Apr 2021 12:11:28 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 387rpnamw5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:11:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:11:26 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:11:23 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 26/27] qedn: Add Connection and IO level recovery flows
Date:   Thu, 29 Apr 2021 22:09:25 +0300
Message-ID: <20210429190926.5086-27-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: I36LMHgOdciCgAWS0lHUGmCccygAGpb7
X-Proofpoint-ORIG-GUID: I36LMHgOdciCgAWS0lHUGmCccygAGpb7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the connection level functionalities:
 - conn clear-sq: will release the FW restrictions in order to flush all
   the pending IOs.
 - drain: in case clear-sq is stuck, will release all the device FW
   restrictions in order to flush all the pending IOs.
 - task cleanup - will flush the IO level resources.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/hw/qedn/qedn.h      |   8 ++
 drivers/nvme/hw/qedn/qedn_conn.c | 133 ++++++++++++++++++++++++++++++-
 drivers/nvme/hw/qedn/qedn_main.c |   1 +
 drivers/nvme/hw/qedn/qedn_task.c |  27 ++++++-
 4 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 065e4324e30c..fed4252392e0 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -51,6 +51,8 @@
 #define QEDN_FW_CQ_FP_WQ_WORKQUEUE "qedn_fw_cq_fp_wq"
 #define QEDN_NVME_REQ_FP_WQ_WORKQUEUE "qedn_nvme_req_fp_wq"
 
+#define QEDN_DRAIN_MAX_ATTEMPTS 3
+
 /* Protocol defines */
 #define QEDN_MAX_IO_SIZE QED_NVMETCP_MAX_IO_SIZE
 #define QEDN_MAX_PDU_SIZE 0x80000 /* 512KB */
@@ -104,6 +106,8 @@
 /* Timeouts and delay constants */
 #define QEDN_WAIT_CON_ESTABLSH_TMO 10000 /* 10 seconds */
 #define QEDN_RLS_CONS_TMO 5000 /* 5 sec */
+#define QEDN_TASK_CLEANUP_TMO 3000 /* 3 sec */
+#define QEDN_DRAIN_TMO 1000 /* 1 sec */
 
 enum qedn_state {
 	QEDN_STATE_CORE_PROBED = 0,
@@ -191,7 +195,9 @@ struct qedn_ctx {
 };
 
 enum qedn_task_flags {
+	QEDN_TASK_IS_ICREQ,
 	QEDN_TASK_USED_BY_FW,
+	QEDN_TASK_WAIT_FOR_CLEANUP,
 };
 
 struct qedn_task_ctx {
@@ -348,6 +354,8 @@ struct qedn_conn_ctx {
 	struct list_head active_task_list;
 	atomic_t num_active_tasks;
 	atomic_t num_active_fw_tasks;
+	atomic_t task_cleanups_cnt;
+	wait_queue_head_t cleanup_waitq;
 
 	/* Connection resources - turned on to indicate what resource was
 	 * allocated, to that it can later be released.
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index fa8d414eb888..8af119202b91 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -585,6 +585,11 @@ static int qedn_handle_icresp(struct qedn_conn_ctx *conn_ctx)
 	return rc;
 }
 
+void qedn_error_recovery(struct nvme_ctrl *nctrl)
+{
+	nvme_tcp_ofld_error_recovery(nctrl);
+}
+
 /* Slowpath EQ Callback */
 int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
 {
@@ -644,6 +649,7 @@ int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
 		}
 
 		break;
+
 	case NVMETCP_EVENT_TYPE_ASYN_TERMINATE_DONE:
 		if (conn_ctx->state != CONN_STATE_WAIT_FOR_DESTROY_DONE)
 			pr_err("CID=0x%x - ASYN_TERMINATE_DONE: Unexpected connection state %u\n",
@@ -652,6 +658,19 @@ int qedn_event_cb(void *context, u8 fw_event_code, void *event_ring_data)
 			queue_work(qctrl->sp_wq, &conn_ctx->sp_wq_entry);
 
 		break;
+
+	case NVMETCP_EVENT_TYPE_ASYN_CLOSE_RCVD:
+	case NVMETCP_EVENT_TYPE_ASYN_ABORT_RCVD:
+	case NVMETCP_EVENT_TYPE_ASYN_MAX_RT_TIME:
+	case NVMETCP_EVENT_TYPE_ASYN_MAX_RT_CNT:
+	case NVMETCP_EVENT_TYPE_ASYN_SYN_RCVD:
+	case NVMETCP_EVENT_TYPE_ASYN_MAX_KA_PROBES_CNT:
+	case NVMETCP_EVENT_TYPE_NVMETCP_CONN_ERROR:
+	case NVMETCP_EVENT_TYPE_TCP_CONN_ERROR:
+		qedn_error_recovery(&conn_ctx->ctrl->nctrl);
+
+		break;
+
 	default:
 		pr_err("CID=0x%x - Recv Unknown Event %u\n", conn_ctx->fw_cid, fw_event_code);
 		break;
@@ -765,8 +784,110 @@ static int qedn_prep_and_offload_queue(struct qedn_conn_ctx *conn_ctx)
 	return -EINVAL;
 }
 
+static void qedn_cleanup_fw_task(struct qedn_ctx *qedn, struct qedn_task_ctx *qedn_task)
+{
+	struct qedn_conn_ctx *conn_ctx = qedn_task->qedn_conn;
+	struct nvmetcp_task_params task_params;
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+	unsigned long lock_flags;
+
+	/* Take lock to prevent race with fastpath, we don't want to
+	 * invoke cleanup flows on tasks that already returned.
+	 */
+	spin_lock_irqsave(&qedn_task->lock, lock_flags);
+	if (!qedn_task->valid) {
+		spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
+
+		return;
+	}
+	/* Skip tasks not used by FW */
+	if (!test_bit(QEDN_TASK_USED_BY_FW, &qedn_task->flags)) {
+		spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
+
+		return;
+	}
+	/* Skip tasks that were already invoked for cleanup */
+	if (unlikely(test_bit(QEDN_TASK_WAIT_FOR_CLEANUP, &qedn_task->flags))) {
+		spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
+
+		return;
+	}
+	set_bit(QEDN_TASK_WAIT_FOR_CLEANUP, &qedn_task->flags);
+	spin_unlock_irqrestore(&qedn_task->lock, lock_flags);
+
+	atomic_inc(&conn_ctx->task_cleanups_cnt);
+
+	task_params.sqe = &local_sqe;
+	task_params.itid = qedn_task->itid;
+	qed_ops->init_task_cleanup(&task_params);
+
+	/* spin_lock - doorbell is accessed  both Rx flow and response flow */
+	spin_lock(&conn_ctx->ep.doorbell_lock);
+	chain_sqe = qed_chain_produce(&conn_ctx->ep.fw_sq_chain);
+	memcpy(chain_sqe, &local_sqe, sizeof(local_sqe));
+	qedn_ring_doorbell(conn_ctx);
+	spin_unlock(&conn_ctx->ep.doorbell_lock);
+}
+
+inline int qedn_drain(struct qedn_conn_ctx *conn_ctx)
+{
+	int drain_iter = QEDN_DRAIN_MAX_ATTEMPTS;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int wrc;
+
+	while (drain_iter) {
+		qed_ops->common->drain(qedn->cdev);
+		msleep(100);
+
+		wrc = wait_event_interruptible_timeout(conn_ctx->cleanup_waitq,
+						       !atomic_read(&conn_ctx->task_cleanups_cnt),
+						       msecs_to_jiffies(QEDN_DRAIN_TMO));
+		if (!wrc) {
+			drain_iter--;
+			continue;
+		}
+
+		return 0;
+	}
+
+	pr_err("CID 0x%x: cleanup after drain failed - need hard reset.\n", conn_ctx->fw_cid);
+
+	return -EINVAL;
+}
+
+void qedn_cleanup_all_fw_tasks(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_task_ctx *qedn_task, *task_tmp;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int wrc;
+
+	list_for_each_entry_safe_reverse(qedn_task, task_tmp, &conn_ctx->active_task_list, entry) {
+		qedn_cleanup_fw_task(qedn, qedn_task);
+	}
+
+	wrc = wait_event_interruptible_timeout(conn_ctx->cleanup_waitq,
+					       atomic_read(&conn_ctx->task_cleanups_cnt) == 0,
+					       msecs_to_jiffies(QEDN_TASK_CLEANUP_TMO));
+	if (!wrc) {
+		if (qedn_drain(conn_ctx))
+			return;
+	}
+}
+
+static void qedn_clear_fw_sq(struct qedn_conn_ctx *conn_ctx)
+{
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	int rc;
+
+	rc = qed_ops->clear_sq(qedn->cdev, conn_ctx->conn_handle);
+	if (rc)
+		pr_warn("clear_sq failed - rc %u\n", rc);
+}
+
 void qedn_destroy_connection(struct qedn_conn_ctx *conn_ctx)
 {
+	struct nvme_tcp_ofld_req *req, *req_tmp;
 	struct qedn_ctx *qedn = conn_ctx->qedn;
 	int rc;
 
@@ -775,7 +896,17 @@ void qedn_destroy_connection(struct qedn_conn_ctx *conn_ctx)
 	if (qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_DESTROY_DONE))
 		return;
 
-	/* Placeholder - task cleanup */
+	spin_lock(&conn_ctx->nvme_req_lock);
+	list_for_each_entry_safe(req, req_tmp, &conn_ctx->host_pend_req_list, queue_entry) {
+		list_del(&req->queue_entry);
+	}
+	spin_unlock(&conn_ctx->nvme_req_lock);
+
+	if (atomic_read(&conn_ctx->num_active_fw_tasks)) {
+		conn_ctx->abrt_flag = QEDN_ABORTIVE_TERMINATION;
+		qedn_clear_fw_sq(conn_ctx);
+		qedn_cleanup_all_fw_tasks(conn_ctx);
+	}
 
 	rc = qed_ops->destroy_conn(qedn->cdev, conn_ctx->conn_handle,
 				   conn_ctx->abrt_flag);
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index a6756d7250b7..63a4e88d826d 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -323,6 +323,7 @@ static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid, size_t
 	qedn_set_pdu_params(conn_ctx);
 
 	init_waitqueue_head(&conn_ctx->conn_waitq);
+	init_waitqueue_head(&conn_ctx->cleanup_waitq);
 	atomic_set(&conn_ctx->est_conn_indicator, 0);
 	atomic_set(&conn_ctx->destroy_conn_indicator, 0);
 
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index 13d9fb6ed5b6..4ae6c0f66258 100644
--- a/drivers/nvme/hw/qedn/qedn_task.c
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -327,6 +327,17 @@ void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx)
 	/* Return tasks that aren't "Used by FW" to the pool */
 	list_for_each_entry_safe(qedn_task, task_tmp,
 				 &conn_ctx->active_task_list, entry) {
+		/* If we got this far, cleanup was already done
+		 * in which case we want to return the task to the pool and
+		 * release it. So we make sure the cleanup indication is down
+		 */
+		clear_bit(QEDN_TASK_WAIT_FOR_CLEANUP, &qedn_task->flags);
+
+		/* Special handling in case of ICREQ task */
+		if (unlikely(conn_ctx->state ==	CONN_STATE_WAIT_FOR_IC_COMP &&
+			     test_bit(QEDN_TASK_IS_ICREQ, &(qedn_task)->flags)))
+			qedn_common_clear_fw_sgl(&qedn_task->sgl_task_params);
+
 		qedn_clear_task(conn_ctx, qedn_task);
 		num_returned_tasks++;
 	}
@@ -770,7 +781,8 @@ void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 		return;
 
 	if (likely(cqe->cqe_type == NVMETCP_FW_CQE_TYPE_NORMAL)) {
-		/* Placeholder - verify the connection was established */
+		if (unlikely(test_bit(QEDN_TASK_WAIT_FOR_CLEANUP, &qedn_task->flags)))
+			return;
 
 		switch (cqe->task_type) {
 		case NVMETCP_TASK_TYPE_HOST_WRITE:
@@ -811,6 +823,17 @@ void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 			pr_info("Could not identify task type\n");
 		}
 	} else {
-		/* Placeholder - Recovery flows */
+		if (cqe->cqe_type == NVMETCP_FW_CQE_TYPE_CLEANUP) {
+			clear_bit(QEDN_TASK_WAIT_FOR_CLEANUP, &qedn_task->flags);
+			qedn_return_task_to_pool(conn_ctx, qedn_task);
+			atomic_dec(&conn_ctx->task_cleanups_cnt);
+			wake_up_interruptible(&conn_ctx->cleanup_waitq);
+
+			return;
+		}
+
+		 /* The else is NVMETCP_FW_CQE_TYPE_DUMMY - in which don't return the task.
+		  * The task will return during NVMETCP_FW_CQE_TYPE_CLEANUP.
+		  */
 	}
 }
-- 
2.22.0

