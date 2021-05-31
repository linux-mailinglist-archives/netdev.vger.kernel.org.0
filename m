Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5133969D6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhEaW4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:56:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47648 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232320AbhEaW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:56:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMpXID022471;
        Mon, 31 May 2021 15:54:14 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38vjqj36td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:12 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:09 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v7 08/27] nvme-tcp-offload: Add IO level implementation
Date:   Tue, 1 Jun 2021 01:52:03 +0300
Message-ID: <20210531225222.16992-9-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: DfdJjCrMfKWKg75bDX9Rf-iViQRkjRUp
X-Proofpoint-ORIG-GUID: DfdJjCrMfKWKg75bDX9Rf-iViQRkjRUp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dean Balandin <dbalandin@marvell.com>

In this patch, we present the IO level functionality.
The nvme-tcp-offload shall work on the IO-level, meaning the
nvme-tcp-offload ULP module shall pass the request to the nvme-tcp-offload
vendor driver and shall expect for the request completion.
No additional handling is needed in between, this design will reduce the
CPU utilization as we will describe below.

The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
with the following IO-path ops:
 - send_req - in order to pass the request to the handling of the offload
   driver that shall pass it to the vendor specific device
 - poll_queue

The vendor driver will manage the context from which the request will be
executed and the request aggregations.
Once the IO completed, the nvme-tcp-offload vendor driver shall call
command.done() that shall invoke the nvme-tcp-offload ULP layer for
completing the request.

This patch also add support for the nvme-tcp-offload timeout and
nvme-tcp-offload ASYNC flow.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/nvme/host/tcp-offload.c | 176 ++++++++++++++++++++++++++++++--
 drivers/nvme/host/tcp-offload.h |   2 +
 2 files changed, 171 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index 1700cdf42433..c76822e5ada7 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -125,7 +125,30 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
 			    union nvme_result *result,
 			    __le16 status)
 {
-	/* Placeholder - complete request with/without error */
+	struct request *rq = blk_mq_rq_from_pdu(req);
+
+	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), *result))
+		nvme_complete_rq(rq);
+}
+
+/**
+ * nvme_tcp_ofld_async_req_done() - NVMeTCP Offload request done callback
+ * function for async request. Pointed to by nvme_tcp_ofld_req->done.
+ * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
+ * @req:	NVMeTCP offload request to complete.
+ * @result:     The nvme_result.
+ * @status:     The completion status.
+ *
+ * API function that allows the vendor specific offload driver to report request
+ * completions to the common offload layer.
+ */
+void nvme_tcp_ofld_async_req_done(struct nvme_tcp_ofld_req *req,
+				  union nvme_result *result, __le16 status)
+{
+	struct nvme_tcp_ofld_queue *queue = req->queue;
+	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
+
+	nvme_complete_async_event(&ctrl->nctrl, status, result);
 }
 
 static struct nvme_tcp_ofld_dev *
@@ -698,6 +721,54 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
 	kfree(ctrl);
 }
 
+static void nvme_tcp_ofld_set_sg_null(struct nvme_command *c)
+{
+	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
+
+	sg->addr = 0;
+	sg->length = 0;
+	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
+}
+
+inline void nvme_tcp_ofld_set_sg_inline(struct nvme_tcp_ofld_queue *queue,
+					struct nvme_command *c, u32 data_len)
+{
+	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
+
+	sg->addr = cpu_to_le64(queue->ctrl->nctrl.icdoff);
+	sg->length = cpu_to_le32(data_len);
+	sg->type = (NVME_SGL_FMT_DATA_DESC << 4) | NVME_SGL_FMT_OFFSET;
+}
+
+static void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
+{
+	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
+
+	sg->addr = 0;
+	sg->length = cpu_to_le32(data_len);
+	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
+}
+
+static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(arg);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
+	struct nvme_tcp_ofld_dev *dev = queue->dev;
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
+
+	ctrl->async_req.nvme_cmd.common.opcode = nvme_admin_async_event;
+	ctrl->async_req.nvme_cmd.common.command_id = NVME_AQ_BLK_MQ_DEPTH;
+	ctrl->async_req.nvme_cmd.common.flags |= NVME_CMD_SGL_METABUF;
+
+	nvme_tcp_ofld_set_sg_null(&ctrl->async_req.nvme_cmd);
+
+	ctrl->async_req.async = true;
+	ctrl->async_req.queue = queue;
+	ctrl->async_req.done = nvme_tcp_ofld_async_req_done;
+
+	ops->send_req(&ctrl->async_req);
+}
+
 static void
 nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remove)
 {
@@ -836,9 +907,13 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
 			   unsigned int numa_node)
 {
 	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
+	int qid;
 
-	/* Placeholder - init request */
-
+	qid = (set == &ctrl->tag_set) ? hctx_idx + 1 : 0;
+	req->queue = &ctrl->queues[qid];
+	nvme_req(rq)->ctrl = &ctrl->nctrl;
+	nvme_req(rq)->cmd = &req->nvme_cmd;
 	req->done = nvme_tcp_ofld_req_done;
 
 	return 0;
@@ -854,9 +929,46 @@ static blk_status_t
 nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
 		       const struct blk_mq_queue_data *bd)
 {
-	/* Call nvme_setup_cmd(...) */
+	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(bd->rq);
+	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
+	struct nvme_tcp_ofld_ctrl *ctrl = queue->ctrl;
+	struct nvme_ns *ns = hctx->queue->queuedata;
+	struct nvme_tcp_ofld_dev *dev = queue->dev;
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
+	struct nvme_command *nvme_cmd;
+	struct request *rq = bd->rq;
+	bool queue_ready;
+	u32 data_len;
+	int rc;
+
+	queue_ready = test_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
+
+	req->async = false;
+
+	if (!nvme_check_ready(&ctrl->nctrl, rq, queue_ready))
+		return nvme_fail_nonready_command(&ctrl->nctrl, rq);
+
+	rc = nvme_setup_cmd(ns, rq);
+	if (unlikely(rc))
+		return rc;
 
-	/* Call ops->send_req(...) */
+	blk_mq_start_request(rq);
+
+	nvme_cmd = &req->nvme_cmd;
+	nvme_cmd->common.flags |= NVME_CMD_SGL_METABUF;
+
+	data_len = blk_rq_nr_phys_segments(rq) ? blk_rq_payload_bytes(rq) : 0;
+	if (!data_len)
+		nvme_tcp_ofld_set_sg_null(&req->nvme_cmd);
+	else if ((rq_data_dir(rq) == WRITE) &&
+		 data_len <= nvme_tcp_ofld_inline_data_size(queue))
+		nvme_tcp_ofld_set_sg_inline(queue, nvme_cmd, data_len);
+	else
+		nvme_tcp_ofld_map_data(nvme_cmd, data_len);
+
+	rc = ops->send_req(req);
+	if (unlikely(rc))
+		return rc;
 
 	return BLK_STS_OK;
 }
@@ -929,9 +1041,56 @@ static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
 
 static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
 {
-	/* Placeholder - Implement polling mechanism */
+	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
+	struct nvme_tcp_ofld_dev *dev = queue->dev;
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
 
-	return 0;
+	return ops->poll_queue(queue);
+}
+
+static void nvme_tcp_ofld_complete_timed_out(struct request *rq)
+{
+	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_ctrl *nctrl = &req->queue->ctrl->nctrl;
+
+	nvme_tcp_ofld_stop_queue(nctrl, nvme_tcp_ofld_qid(req->queue));
+	if (blk_mq_request_started(rq) && !blk_mq_request_completed(rq)) {
+		nvme_req(rq)->status = NVME_SC_HOST_ABORTED_CMD;
+		blk_mq_complete_request(rq);
+	}
+}
+
+static enum blk_eh_timer_return nvme_tcp_ofld_timeout(struct request *rq, bool reserved)
+{
+	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_ofld_ctrl *ctrl = req->queue->ctrl;
+
+	dev_warn(ctrl->nctrl.device,
+		 "queue %d: timeout request %#x type %d\n",
+		 nvme_tcp_ofld_qid(req->queue), rq->tag, req->nvme_cmd.common.opcode);
+
+	if (ctrl->nctrl.state != NVME_CTRL_LIVE) {
+		/*
+		 * If we are resetting, connecting or deleting we should
+		 * complete immediately because we may block controller
+		 * teardown or setup sequence
+		 * - ctrl disable/shutdown fabrics requests
+		 * - connect requests
+		 * - initialization admin requests
+		 * - I/O requests that entered after unquiescing and
+		 *   the controller stopped responding
+		 *
+		 * All other requests should be cancelled by the error
+		 * recovery work, so it's fine that we fail it here.
+		 */
+		nvme_tcp_ofld_complete_timed_out(rq);
+
+		return BLK_EH_DONE;
+	}
+
+	nvme_tcp_ofld_error_recovery(&ctrl->nctrl);
+
+	return BLK_EH_RESET_TIMER;
 }
 
 static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
@@ -940,6 +1099,7 @@ static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
 	.init_request	= nvme_tcp_ofld_init_request,
 	.exit_request	= nvme_tcp_ofld_exit_request,
 	.init_hctx	= nvme_tcp_ofld_init_hctx,
+	.timeout	= nvme_tcp_ofld_timeout,
 	.map_queues	= nvme_tcp_ofld_map_queues,
 	.poll		= nvme_tcp_ofld_poll,
 };
@@ -950,6 +1110,7 @@ static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
 	.init_request	= nvme_tcp_ofld_init_request,
 	.exit_request	= nvme_tcp_ofld_exit_request,
 	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
+	.timeout	= nvme_tcp_ofld_timeout,
 };
 
 static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
@@ -960,6 +1121,7 @@ static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
 	.free_ctrl		= nvme_tcp_ofld_free_ctrl,
+	.submit_async_event     = nvme_tcp_ofld_submit_async_event,
 	.delete_ctrl		= nvme_tcp_ofld_delete_ctrl,
 	.get_address		= nvmf_get_address,
 };
diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
index 875fcd3ec04a..2ac5b2428612 100644
--- a/drivers/nvme/host/tcp-offload.h
+++ b/drivers/nvme/host/tcp-offload.h
@@ -114,6 +114,8 @@ struct nvme_tcp_ofld_ctrl {
 	/* Connectivity params */
 	struct nvme_tcp_ofld_ctrl_con_params conn_params;
 
+	struct nvme_tcp_ofld_req async_req;
+
 	/* Vendor specific driver context */
 	void *private_data;
 };
-- 
2.22.0

