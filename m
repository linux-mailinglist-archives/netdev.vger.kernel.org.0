Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539EB36F046
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhD2TR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:17:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233345AbhD2TMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:12:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ6WFP019663;
        Thu, 29 Apr 2021 12:11:24 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 387erumw6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:11:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:11:22 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:11:19 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>
Subject: [RFC PATCH v4 25/27] qedn: Add IO level fastpath functionality
Date:   Thu, 29 Apr 2021 22:09:24 +0300
Message-ID: <20210429190926.5086-26-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: BLI0-McXHoHgKZUMn-iJCLNsJTzxY2Ir
X-Proofpoint-ORIG-GUID: BLI0-McXHoHgKZUMn-iJCLNsJTzxY2Ir
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
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
	 -  Initialize the HW and FW context.
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
---
 drivers/nvme/hw/qedn/qedn.h      |   4 +
 drivers/nvme/hw/qedn/qedn_conn.c |   1 +
 drivers/nvme/hw/qedn/qedn_task.c | 269 ++++++++++++++++++++++++++++++-
 3 files changed, 272 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
index 773a57994148..065e4324e30c 100644
--- a/drivers/nvme/hw/qedn/qedn.h
+++ b/drivers/nvme/hw/qedn/qedn.h
@@ -190,6 +190,10 @@ struct qedn_ctx {
 	struct qed_nvmetcp_tid	tasks;
 };
 
+enum qedn_task_flags {
+	QEDN_TASK_USED_BY_FW,
+};
+
 struct qedn_task_ctx {
 	struct qedn_conn_ctx *qedn_conn;
 	struct qedn_ctx *qedn;
diff --git a/drivers/nvme/hw/qedn/qedn_conn.c b/drivers/nvme/hw/qedn/qedn_conn.c
index 5679354aa0e0..fa8d414eb888 100644
--- a/drivers/nvme/hw/qedn/qedn_conn.c
+++ b/drivers/nvme/hw/qedn/qedn_conn.c
@@ -503,6 +503,7 @@ static int qedn_send_icreq(struct qedn_conn_ctx *conn_ctx)
 	qed_ops->init_icreq_exchange(&task_params, icreq_ptr, sgl_task_params,  NULL);
 
 	qedn_set_con_state(conn_ctx, CONN_STATE_WAIT_FOR_IC_COMP);
+	set_bit(QEDN_TASK_USED_BY_FW, &qedn_task->flags);
 	atomic_inc(&conn_ctx->num_active_fw_tasks);
 
 	/* spin_lock - doorbell is accessed  both Rx flow and response flow */
diff --git a/drivers/nvme/hw/qedn/qedn_task.c b/drivers/nvme/hw/qedn/qedn_task.c
index 9cb84883e95e..13d9fb6ed5b6 100644
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
@@ -434,8 +436,194 @@ qedn_get_task_from_pool_insist(struct qedn_conn_ctx *conn_ctx, u16 cccid)
 	return qedn_task;
 }
 
+int qedn_send_read_cmd(struct qedn_task_ctx *qedn_task, struct qedn_conn_ctx *conn_ctx)
+{
+	struct nvme_command *nvme_cmd = &qedn_task->req->nvme_cmd;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct nvmetcp_cmd_capsule_hdr cmd_hdr;
+	struct nvmetcp_task_params task_params;
+	struct nvmetcp_conn_params conn_params;
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+	int rc;
+	int i;
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
+	conn_params.max_burst_length = QEDN_MAX_IO_SIZE;
+
+	cmd_hdr.chdr.pdu_type = nvme_tcp_cmd;
+	cmd_hdr.chdr.flags = 0;
+	cmd_hdr.chdr.hlen = sizeof(cmd_hdr);
+	cmd_hdr.chdr.pdo = 0x0;
+	cmd_hdr.chdr.plen_swapped = cpu_to_le32(__swab32(cmd_hdr.chdr.hlen));
+
+	for (i = 0; i < 16; i++)
+		cmd_hdr.pshdr.raw_swapped[i] = cpu_to_le32(__swab32(((u32 *)nvme_cmd)[i]));
+
+	qed_ops->init_read_io(&task_params, &conn_params, &cmd_hdr, &qedn_task->sgl_task_params);
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
+{
+	struct nvme_command *nvme_cmd = &qedn_task->req->nvme_cmd;
+	struct nvmetcp_task_params task_params;
+	struct qedn_ctx *qedn = conn_ctx->qedn;
+	struct nvmetcp_cmd_capsule_hdr cmd_hdr;
+	struct nvmetcp_conn_params conn_params;
+	u32 pdu_len = sizeof(cmd_hdr);
+	struct nvmetcp_wqe *chain_sqe;
+	struct nvmetcp_wqe local_sqe;
+	u8 send_write_incapsule;
+	int rc;
+	int i;
+
+	if (qedn_task->task_size <= nvme_tcp_ofld_inline_data_size(conn_ctx->queue) &&
+	    qedn_task->task_size) {
+		send_write_incapsule = 1;
+		pdu_len += qedn_task->task_size;
+
+		/* Add digest length once supported */
+		cmd_hdr.chdr.pdo = sizeof(cmd_hdr);
+	} else {
+		send_write_incapsule = 0;
+
+		cmd_hdr.chdr.pdo = 0x0;
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
+
+	cmd_hdr.chdr.pdu_type = nvme_tcp_cmd;
+	cmd_hdr.chdr.flags = 0;
+	cmd_hdr.chdr.hlen = sizeof(cmd_hdr);
+	cmd_hdr.chdr.plen_swapped = cpu_to_le32(__swab32(pdu_len));
+	for (i = 0; i < 16; i++)
+		cmd_hdr.pshdr.raw_swapped[i] = cpu_to_le32(__swab32(((u32 *)nvme_cmd)[i]));
+
+	qed_ops->init_write_io(&task_params, &conn_params, &cmd_hdr, &qedn_task->sgl_task_params);
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
+static void qedn_fetch_request(struct qedn_conn_ctx *qedn_conn)
+{
+	spin_lock(&qedn_conn->nvme_req_lock);
+	qedn_conn->req = list_first_entry_or_null(&qedn_conn->host_pend_req_list,
+						  struct nvme_tcp_ofld_req, queue_entry);
+	if (qedn_conn->req)
+		list_del(&qedn_conn->req->queue_entry);
+	spin_unlock(&qedn_conn->nvme_req_lock);
+}
+
 static bool qedn_process_req(struct qedn_conn_ctx *qedn_conn)
 {
+	struct qedn_task_ctx *qedn_task;
+	struct nvme_tcp_ofld_req *req;
+	struct request *rq;
+	int rc = 0;
+	u16 cccid;
+
+	qedn_fetch_request(qedn_conn);
+	if (!qedn_conn->req)
+		return false;
+
+	req = qedn_conn->req;
+	rq = blk_mq_rq_from_pdu(req);
+
+	/* Placeholder - async */
+
+	cccid = rq->tag;
+	qedn_task = qedn_get_task_from_pool_insist(qedn_conn, cccid);
+	if (unlikely(!qedn_task)) {
+		pr_err("Not able to allocate task context\n");
+		goto doorbell;
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
+		goto doorbell;
+	}
+
+	/* Don't ring doorbell if this is not the last request */
+	if (!req->last)
+		return true;
+
+doorbell:
+	/* Always ring doorbell if reached here, in case there were coalesced
+	 * requests which were delayed
+	 */
+	qedn_ring_doorbell(qedn_conn);
+
 	return true;
 }
 
@@ -497,8 +685,71 @@ struct qedn_task_ctx *qedn_cqe_get_active_task(struct nvmetcp_fw_cqe *cqe)
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
+	/* Call request done to compelete the request */
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
+	/* cqe arrives swapped */
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
@@ -525,13 +776,27 @@ void qedn_io_work_cq(struct qedn_ctx *qedn, struct nvmetcp_fw_cqe *cqe)
 		case NVMETCP_TASK_TYPE_HOST_WRITE:
 		case NVMETCP_TASK_TYPE_HOST_READ:
 
-			/* Placeholder - IO flow */
+			/* Verify data digest once supported */
+
+			nvme_cqe = (struct nvme_completion *)&cqe->nvme_cqe;
+			rc = qedn_process_nvme_cqe(qedn_task, nvme_cqe);
+			if (rc) {
+				pr_err("Read/Write completion error\n");
 
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

