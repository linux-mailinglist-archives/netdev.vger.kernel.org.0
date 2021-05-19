Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7142D388C90
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349560AbhESLUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:20:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349747AbhESLT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:19:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBAXdn007731;
        Wed, 19 May 2021 04:16:22 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38mqcwhy8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:16:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:16:20 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:16:17 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>
Subject: [RFC PATCH v5 25/27] qedn: Add IO level fastpath functionality
Date:   Wed, 19 May 2021 14:13:38 +0300
Message-ID: <20210519111340.20613-26-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: jY7359etcct1bMPrvgpSDzs466fBbbC9
X-Proofpoint-ORIG-GUID: jY7359etcct1bMPrvgpSDzs466fBbbC9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will present the IO level functionality of qedn
nvme-tcp-offload host mode. The qedn_task_ctx structure is containing
various params and state of the current IO, and is mapped 1x1 to the
fw_task_ctx which is a HW and FW IO context.
A qedn_task is mapped directly to its parent connection.
For every new IO a qedn_task structure will be assigned and they will be
linked for the entire IO's life span.

The patch will include 2 flows:
  1. Send new command to the FW:
	 The flow is: nvme_tcp_ofld_queue_rq() which invokes qedn_send_req()
	 which invokes qedn_queue_request() which will:
         - Assign fw_task_ctx.
	 - Prepare the Read/Write SG buffer.
	 - Initialize the HW and FW context.
	 - Pass the IO to the FW.

  2. Process the IO completion:
     The flow is: qedn_irq_handler() which invokes qedn_fw_cq_fp_handler()
	 which invokes qedn_io_work_cq() which will:
	 - process the FW completion.
	 - Return the fw_task_ctx to the task pool.
	 - complete the nvme req.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/hw/qedn/qedn.h      |   7 +-
 drivers/nvme/hw/qedn/qedn_conn.c |   1 +
 drivers/nvme/hw/qedn/qedn_main.c |   8 +
 drivers/nvme/hw/qedn/qedn_task.c | 252 ++++++++++++++++++++++++++++++-
 4 files changed, 260 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 083833839868..a7be866de6f6 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -186,6 +186,10 @@ struct qedn_ctx {
 	struct qed_nvmetcp_tid	tasks;
 };
 
+enum qedn_task_flags {
+	QEDN_TASK_USED_BY_FW,
+};
+
 struct qedn_task_ctx {
 	struct qedn_conn_ctx *qedn_conn;
 	struct qedn_ctx *qedn;
@@ -371,7 +375,7 @@ int qedn_set_con_state(struct qedn_conn_ctx *conn_ctx, enum qedn_conn_state new_
 void qedn_terminate_connection(struct qedn_conn_ctx *conn_ctx);
 __be16 qedn_get_in_port(struct sockaddr_storage *sa);
 inline int qedn_validate_cccid_in_range(struct qedn_conn_ctx *conn_ctx, u16 cccid);
-void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
+int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req);
 void qedn_nvme_req_fp_wq_handler(struct work_struct *work);
 void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe);
 int qedn_alloc_tasks(struct qedn_conn_ctx *conn_ctx);
@@ -382,6 +386,7 @@ void qedn_common_clear_fw_sgl(struct storage_sgl_task_params *sgl_task_params);
 void qedn_return_active_tasks(struct qedn_conn_ctx *conn_ctx);
 void qedn_destroy_free_tasks(struct qedn_fp_queue *fp_q,
 			     struct qedn_io_resources *io_resrc);
+void qedn_swap_bytes(u32 *p, int size);
 void qedn_prep_icresp(struct qedn_conn_ctx *conn_ctx, struct nvmetcp_fw_cqe *cqe);
 void qedn_ring_doorbell(struct qedn_conn_ctx *conn_ctx);
 
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index df4f2a9b96bb..ed60ac0306d5 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -507,6 +507,7 @@ static int qedn_send_icreq(struct qedn_conn_ctx *conn_ctx)
 	qed_ops->init_icreq_exchange(&task_params, &icreq, sgl_task_params,  NULL);
 
 	qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_IC_COMP);
+	set_bit(QEDN_TASK_USED_BY_FW, &qedn_task->flags);
 	atomic_inc(&conn_ctx->num_active_fw_tasks);
 
 	/* spin_lock - doorbell is accessed  both Rx flow and response flow */
diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
index e2c65c610997..c2721a771822 100644
--- a/drivers/nvme/hw/qedn/qedn_main.c
+++ b/drivers/nvme/hw/qedn/qedn_main.c
@@ -1020,6 +1020,14 @@ static int qedn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return __qedn_probe(pdev);
 }
 
+void qedn_swap_bytes(u32 *p, int size)
+{
+	int i;
+
+	for (i = 0; i < size; ++i, ++p)
+		*p = __swab32(*p);
+}
+
 static struct pci_driver qedn_pci_driver = {
 	.name     = QEDN_MODULE_NAME,
 	.id_table = qedn_pci_tbl,
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index fa2a9a62f12c..44e5ea2a693a 100644
--- a/drivers/nvme/hw/qedn/qedn_task.c
+++ b/drivers/nvme/hw/qedn/qedn_task.c
@@ -11,6 +11,8 @@
 /* Driver includes */
 #include "qedn.h"
 
+extern const struct qed_nvmetcp_ops *qed_ops;
+
 static bool qedn_sgl_has_small_mid_sge(struct nvmetcp_sge *sgl, u16 sge_count)
 {
 	u16 sge_num;
@@ -434,16 +436,173 @@ qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u16 cccid)
 	return qedn_task;
 }
 
-static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
+int qedn_send_read_cmd(struct qedn_task_ctx *qedn_task, struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvme_command *nvme_cmd = &qedn_task->req->nvme_cmd;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct nvmetcp_task_params task_params;
+	struct nvme_tcp_cmd_pdu cmd_hdr;
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+	u32 max_burst_length;
+	int rc;
+
+	rc = qedn_init_sgl(qedn, qedn_task);
+	if (rc)
+		return rc;
+
+	task_params.opq.lo = cpu_to_le32(((u64)(qedn_task)) & 0xffffffff);
+	task_params.opq.hi = cpu_to_le32(((u64)(qedn_task)) >> 32);
+
+	/* Initialize task params */
+	task_params.context = qedn_task->fw_task_ctx;
+	task_params.sqe = &local_sqe;
+	task_params.tx_io_size = 0;
+	task_params.rx_io_size = qedn_task->task_size;
+	task_params.conn_icid = (u16)conn_ctx->conn_handle;
+	task_params.itid = qedn_task->itid;
+	task_params.cq_rss_number = conn_ctx->default_cq;
+	task_params.send_write_incapsule = 0;
+
+	/* Initialize conn params */
+	max_burst_length = QEDN_MAX_IO_SIZE;
+
+	cmd_hdr.hdr.type = nvme_tcp_cmd;
+	cmd_hdr.hdr.flags = 0;
+	cmd_hdr.hdr.hlen = sizeof(cmd_hdr);
+	cmd_hdr.hdr.pdo = 0x0;
+	/* Swapping requirement will be removed in future FW versions */
+	cmd_hdr.hdr.plen = cpu_to_le32(__swab32(cmd_hdr.hdr.hlen));
+
+	qed_ops->init_read_io(&task_params, max_burst_length, &cmd_hdr,
+			      nvme_cmd, &qedn_task->sgl_task_params);
+
+	set_bit(QEDN_TASK_USED_BY_FW, &qedn_task->flags);
+	atomic_inc(&conn_ctx->num_active_fw_tasks);
+
+	spin_lock(&conn_ctx->ep.doorbell_lock);
+	chain_sqe = qed_chain_produce(&conn_ctx->ep.fw_sq_chain);
+	memcpy(chain_sqe, &local_sqe, sizeof(local_sqe));
+	qedn_ring_doorbell(conn_ctx);
+	spin_unlock(&conn_ctx->ep.doorbell_lock);
+
+	return 0;
+}
+
+int qedn_send_write_cmd(struct qedn_task_ctx *qedn_task, struct qedn_conn_ctx *conn_ctx)
 {
-	return true;
+	struct nvme_command *nvme_cmd = &qedn_task->req->nvme_cmd;
+	struct nvmetcp_task_params task_params;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct nvme_tcp_cmd_pdu cmd_hdr;
+	u32 pdu_len = sizeof(cmd_hdr);
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+	u8 send_write_incapsule;
+	u32 max_burst_length;
+	int rc;
+
+	if (qedn_task->task_size <= nvme_tcp_ofld_inline_data_size(conn_ctx->queue) &&
+	    qedn_task->task_size) {
+		send_write_incapsule = 1;
+		pdu_len += qedn_task->task_size;
+
+		/* Add digest length once supported */
+		cmd_hdr.hdr.pdo = sizeof(cmd_hdr);
+	} else {
+		send_write_incapsule = 0;
+
+		cmd_hdr.hdr.pdo = 0x0;
+	}
+
+	rc = qedn_init_sgl(qedn, qedn_task);
+	if (rc)
+		return rc;
+
+	task_params.host_cccid = cpu_to_le16(qedn_task->cccid);
+	task_params.opq.lo = cpu_to_le32(((u64)(qedn_task)) & 0xffffffff);
+	task_params.opq.hi = cpu_to_le32(((u64)(qedn_task)) >> 32);
+
+	/* Initialize task params */
+	task_params.context = qedn_task->fw_task_ctx;
+	task_params.sqe = &local_sqe;
+	task_params.tx_io_size = qedn_task->task_size;
+	task_params.rx_io_size = 0;
+	task_params.conn_icid = (u16)conn_ctx->conn_handle;
+	task_params.itid = qedn_task->itid;
+	task_params.cq_rss_number = conn_ctx->default_cq;
+	task_params.send_write_incapsule = send_write_incapsule;
+
+	/* Initialize conn params */
+	max_burst_length = QEDN_MAX_IO_SIZE;
+
+	cmd_hdr.hdr.type = nvme_tcp_cmd;
+	cmd_hdr.hdr.flags = 0;
+	cmd_hdr.hdr.hlen = sizeof(cmd_hdr);
+	/* Swapping requirement will be removed in future FW versions */
+	cmd_hdr.hdr.plen = cpu_to_le32(__swab32(pdu_len));
+
+	qed_ops->init_write_io(&task_params, max_burst_length, &cmd_hdr,
+			       nvme_cmd, &qedn_task->sgl_task_params);
+
+	set_bit(QEDN_TASK_USED_BY_FW, &qedn_task->flags);
+	atomic_inc(&conn_ctx->num_active_fw_tasks);
+
+	spin_lock(&conn_ctx->ep.doorbell_lock);
+	chain_sqe = qed_chain_produce(&conn_ctx->ep.fw_sq_chain);
+	memcpy(chain_sqe, &local_sqe, sizeof(local_sqe));
+	qedn_ring_doorbell(conn_ctx);
+	spin_unlock(&conn_ctx->ep.doorbell_lock);
+
+	return 0;
 }
 
-void qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req)
+int qedn_queue_request(struct qedn_conn_ctx *qedn_conn, struct nvme_tcp_ofld_req *req)
 {
-	bool empty, res = false;
+	struct qedn_task_ctx *qedn_task;
+	struct request *rq;
+	int rc = 0;
+	u16 cccid;
+
+	rq = blk_mq_rq_from_pdu(req);
+
+	/* Placeholder - async */
+
+	cccid = rq->tag;
+	qedn_task = qedn_get_task_from_pool_insist(qedn_conn, cccid);
+	if (unlikely(!qedn_task)) {
+		pr_err("Not able to allocate task context resource\n");
+
+		return BLK_STS_NOTSUPP;
+	}
+
+	req->private_data = qedn_task;
+	qedn_task->req = req;
+
+	/* Placeholder - handle (req->async) */
+
+	/* Check if there are physical segments in request to determine the task size.
+	 * The logic of nvme_tcp_set_sg_null() will be implemented as part of
+	 * qedn_set_sg_host_data().
+	 */
+	qedn_task->task_size = blk_rq_nr_phys_segments(rq) ? blk_rq_payload_bytes(rq) : 0;
+	qedn_task->req_direction = rq_data_dir(rq);
+	if (qedn_task->req_direction == WRITE)
+		rc = qedn_send_write_cmd(qedn_task, qedn_conn);
+	else
+		rc = qedn_send_read_cmd(qedn_task, qedn_conn);
+
+	if (unlikely(rc)) {
+		pr_err("Read/Write command failure\n");
+
+		return BLK_STS_TRANSPORT;
+	}
 
-	res = qedn_process_req(qedn_conn);
+	spin_lock(&qedn_conn->ep.doorbell_lock);
+	qedn_ring_doorbell(qedn_conn);
+	spin_unlock(&qedn_conn->ep.doorbell_lock);
+
+	return BLK_STS_OK;
 }
 
 struct qedn_task_ctx *qedn_cqe_get_active_task(struct nvmetcp_fw_cqe *cqe)
@@ -454,8 +613,73 @@ struct qedn_task_ctx *qedn_cqe_get_active_task(struct nvmetcp_fw_cqe *cqe)
 					+ le32_to_cpu(p->lo)));
 }
 
+static struct nvme_tcp_ofld_req *qedn_decouple_req_task(struct qedn_task_ctx *qedn_task)
+{
+	struct nvme_tcp_ofld_req *ulp_req = qedn_task->req;
+
+	qedn_task->req = NULL;
+	if (ulp_req)
+		ulp_req->private_data = NULL;
+
+	return ulp_req;
+}
+
+static inline int qedn_comp_valid_task(struct qedn_task_ctx *qedn_task,
+				       union nvme_result *result, __le16 status)
+{
+	struct qedn_conn_ctx *conn_ctx = qedn_task->qedn_conn;
+	struct nvme_tcp_ofld_req *req;
+
+	req = qedn_decouple_req_task(qedn_task);
+	qedn_return_task_to_pool(conn_ctx, qedn_task);
+	if (!req) {
+		pr_err("req not found\n");
+
+		return -EINVAL;
+	}
+
+	/* Call request done to complete the request */
+	if (req->done)
+		req->done(req, result, status);
+	else
+		pr_err("request done not Set !!!\n");
+
+	return 0;
+}
+
+int qedn_process_nvme_cqe(struct qedn_task_ctx *qedn_task, struct nvme_completion *cqe)
+{
+	int rc = 0;
+
+	/* CQE arrives swapped
+	 * Swapping requirement will be removed in future FW versions
+	 */
+	qedn_swap_bytes((u32 *)cqe, (sizeof(*cqe) / sizeof(u32)));
+
+	/* Placeholder - async */
+
+	rc = qedn_comp_valid_task(qedn_task, &cqe->result, cqe->status);
+
+	return rc;
+}
+
+int qedn_complete_c2h(struct qedn_task_ctx *qedn_task)
+{
+	int rc = 0;
+
+	__le16 status = cpu_to_le16(NVME_SC_SUCCESS << 1);
+	union nvme_result result = {};
+
+	rc = qedn_comp_valid_task(qedn_task, &result, status);
+
+	return rc;
+}
+
 void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 {
+	int rc = 0;
+
+	struct nvme_completion *nvme_cqe = NULL;
 	struct qedn_task_ctx *qedn_task = NULL;
 	struct qedn_conn_ctx *conn_ctx = NULL;
 	u16 itid;
@@ -482,13 +706,27 @@ void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 		case NVMETCP_TASK_TYPE_HOST_WRITE:
 		case NVMETCP_TASK_TYPE_HOST_READ:
 
-			/* Placeholder - IO flow */
+			/* Verify data digest once supported */
 
+			nvme_cqe = (struct nvme_completion *)&cqe->cqe_data.nvme_cqe;
+			rc = qedn_process_nvme_cqe(qedn_task, nvme_cqe);
+			if (rc) {
+				pr_err("Read/Write completion error\n");
+
+				return;
+			}
 			break;
 
 		case NVMETCP_TASK_TYPE_HOST_READ_NO_CQE:
 
-			/* Placeholder - IO flow */
+			/* Verify data digest once supported */
+
+			rc = qedn_complete_c2h(qedn_task);
+			if (rc) {
+				pr_err("Controller To Host Data Transfer error error\n");
+
+				return;
+			}
 
 			break;
 
-- 
2.22.0

