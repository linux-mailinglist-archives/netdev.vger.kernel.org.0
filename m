Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33897388C84
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349046AbhESLSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:18:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348926AbhESLSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:18:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBAXVQ007727;
        Wed, 19 May 2021 04:15:01 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38mqcwhy46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:15:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:14:59 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:14:55 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Dean Balandin" <dbalandin@marvell.com>
Subject: [RFC PATCH v5 07/27] nvme-tcp-offload: Add IO level implementation
Date:   Wed, 19 May 2021 14:13:20 +0300
Message-ID: <20210519111340.20613-8-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: SDvauFUdxSRdR3O7H1z_LK7294E1l_HF
X-Proofpoint-ORIG-GUID: SDvauFUdxSRdR3O7H1z_LK7294E1l_HF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
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
 - init_req
 - send_req - in order to pass the request to the handling of the offload
   driver that shall pass it to the vendor specific device
 - poll_queue

The vendor driver will manage the context from which the request will be
executed and the request aggregations.
Once the IO completed, the nvme-tcp-offload vendor driver shall call
command.done() that shall invoke the nvme-tcp-offload ULP layer for
completing the request.

This patch also contains initial definition of nvme_tcp_ofld_queue_rq().

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/tcp-offload.c | 96 ++++++++++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index 8ed7668d987a..276b8475ac85 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -127,7 +127,10 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
 			    union nvme_result *result,
 			    __le16 status)
 {
-	/* Placeholder - complete request with/without error */
+	struct request *rq = blk_mq_rq_from_pdu(req);
+
+	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), *result))
+		nvme_complete_rq(rq);
 }
 
 struct nvme_tcp_ofld_dev *
@@ -700,6 +703,34 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
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
+void nvme_tcp_ofld_map_data(struct nvme_command *c, u32 data_len)
+{
+	struct nvme_sgl_desc *sg = &c->common.dptr.sgl;
+
+	sg->addr = 0;
+	sg->length = cpu_to_le32(data_len);
+	sg->type = (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A;
+}
+
 static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
 {
 	/* Placeholder - submit_async_event */
@@ -855,9 +886,12 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
 {
 	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
 	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
+	int qid;
 
-	/* Placeholder - init request */
-
+	qid = (set == &ctrl->tag_set) ? hctx_idx + 1 : 0;
+	req->queue = &ctrl->queues[qid];
+	nvme_req(rq)->ctrl = &ctrl->nctrl;
+	nvme_req(rq)->cmd = &req->nvme_cmd;
 	req->done = nvme_tcp_ofld_req_done;
 	ctrl->dev->ops->init_req(req);
 
@@ -872,16 +906,60 @@ EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
 
 static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
 {
-	/* Call ops->commit_rqs */
+	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
+	struct nvme_tcp_ofld_dev *dev = queue->dev;
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
+
+	ops->commit_rqs(queue);
 }
 
 static blk_status_t
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
+	struct request *rq;
+	bool queue_ready;
+	u32 data_len;
+	int rc;
+
+	queue_ready = test_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
+
+	req->rq = bd->rq;
+	req->async = false;
+	rq = req->rq;
+
+	if (!nvme_check_ready(&ctrl->nctrl, req->rq, queue_ready))
+		return nvme_fail_nonready_command(&ctrl->nctrl, req->rq);
+
+	rc = nvme_setup_cmd(ns, req->rq);
+	if (unlikely(rc))
+		return rc;
 
-	/* Call ops->send_req(...) */
+	blk_mq_start_request(req->rq);
+	req->last = bd->last;
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
@@ -954,9 +1032,11 @@ static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
 
 static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
 {
-	/* Placeholder - Implement polling mechanism */
+	struct nvme_tcp_ofld_queue *queue = hctx->driver_data;
+	struct nvme_tcp_ofld_dev *dev = queue->dev;
+	struct nvme_tcp_ofld_ops *ops = dev->ops;
 
-	return 0;
+	return ops->poll_queue(queue);
 }
 
 static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
-- 
2.22.0

