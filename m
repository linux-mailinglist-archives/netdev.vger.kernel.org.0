Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F263969DD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhEaW6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:58:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232221AbhEaW6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:58:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMpTwh002182;
        Mon, 31 May 2021 15:54:10 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:08 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:04 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>, Dean Balandin <dbalandin@marvell.com>
Subject: [RFC PATCH v7 07/27] nvme-tcp-offload: Add queue level implementation
Date:   Tue, 1 Jun 2021 01:52:02 +0300
Message-ID: <20210531225222.16992-8-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: F21uhms-gNfLOUR-nqh1jG5qGBXaQDIB
X-Proofpoint-ORIG-GUID: F21uhms-gNfLOUR-nqh1jG5qGBXaQDIB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dean Balandin <dbalandin@marvell.com>

In this patch we implement queue level functionality.
The implementation is similar to the nvme-tcp module, the main
difference being that we call the vendor specific create_queue op which
creates the TCP connection, and NVMeTPC connection including
icreq+icresp negotiation.
Once create_queue returns successfully, we can move on to the fabrics
connect.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dean Balandin <dbalandin@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/nvme/host/tcp-offload.c | 417 +++++++++++++++++++++++++++++---
 drivers/nvme/host/tcp-offload.h |   4 +
 2 files changed, 393 insertions(+), 28 deletions(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index 97c1fd33adb9..1700cdf42433 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -22,6 +22,11 @@ static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctr
 	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
 }
 
+static inline int nvme_tcp_ofld_qid(struct nvme_tcp_ofld_queue *queue)
+{
+	return queue - queue->ctrl->queues;
+}
+
 /**
  * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
  * function.
@@ -182,19 +187,124 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
 	return set;
 }
 
+static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	queue->dev->ops->drain_queue(queue);
+}
+
+static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
+
+	mutex_lock(&queue->queue_lock);
+	if (test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
+		__nvme_tcp_ofld_stop_queue(queue);
+	mutex_unlock(&queue->queue_lock);
+}
+
+static void nvme_tcp_ofld_stop_io_queues(struct nvme_ctrl *ctrl)
+{
+	int i;
+
+	for (i = 1; i < ctrl->queue_count; i++)
+		nvme_tcp_ofld_stop_queue(ctrl, i);
+}
+
+static void __nvme_tcp_ofld_free_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	queue->dev->ops->destroy_queue(queue);
+}
+
+static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
+
+	if (test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags)) {
+		__nvme_tcp_ofld_free_queue(queue);
+		mutex_destroy(&queue->queue_lock);
+	}
+}
+
+static void
+nvme_tcp_ofld_free_io_queues(struct nvme_ctrl *nctrl)
+{
+	int i;
+
+	for (i = 1; i < nctrl->queue_count; i++)
+		nvme_tcp_ofld_free_queue(nctrl, i);
+}
+
+static void nvme_tcp_ofld_destroy_io_queues(struct nvme_ctrl *nctrl, bool remove)
+{
+	nvme_tcp_ofld_stop_io_queues(nctrl);
+	if (remove) {
+		blk_cleanup_queue(nctrl->connect_q);
+		blk_mq_free_tag_set(nctrl->tagset);
+	}
+	nvme_tcp_ofld_free_io_queues(nctrl);
+}
+
+static void nvme_tcp_ofld_destroy_admin_queue(struct nvme_ctrl *nctrl, bool remove)
+{
+	nvme_tcp_ofld_stop_queue(nctrl, 0);
+	if (remove) {
+		blk_cleanup_queue(nctrl->admin_q);
+		blk_cleanup_queue(nctrl->fabrics_q);
+		blk_mq_free_tag_set(nctrl->admin_tagset);
+	}
+	nvme_tcp_ofld_free_queue(nctrl, 0);
+}
+
+static int nvme_tcp_ofld_start_queue(struct nvme_ctrl *nctrl, int qid)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
+	int rc;
+
+	queue = &ctrl->queues[qid];
+	if (qid) {
+		queue->cmnd_capsule_len = nctrl->ioccsz * 16;
+		rc = nvmf_connect_io_queue(nctrl, qid, false);
+	} else {
+		queue->cmnd_capsule_len = sizeof(struct nvme_command) + NVME_TCP_ADMIN_CCSZ;
+		rc = nvmf_connect_admin_queue(nctrl);
+	}
+
+	if (!rc) {
+		set_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags);
+	} else {
+		if (test_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
+			__nvme_tcp_ofld_stop_queue(queue);
+		dev_err(nctrl->device,
+			"failed to connect queue: %d ret=%d\n", qid, rc);
+	}
+
+	return rc;
+}
+
 static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 					       bool new)
 {
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[0];
 	int rc;
 
-	/* Placeholder - alloc_admin_queue */
+	mutex_init(&queue->queue_lock);
+
+	rc = ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
+	if (rc)
+		return rc;
+
+	set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
 	if (new) {
 		nctrl->admin_tagset =
 				nvme_tcp_ofld_alloc_tagset(nctrl, true);
 		if (IS_ERR(nctrl->admin_tagset)) {
 			rc = PTR_ERR(nctrl->admin_tagset);
 			nctrl->admin_tagset = NULL;
-			goto out_destroy_queue;
+			goto out_free_queue;
 		}
 
 		nctrl->fabrics_q = blk_mq_init_queue(nctrl->admin_tagset);
@@ -212,7 +322,9 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 		}
 	}
 
-	/* Placeholder - nvme_tcp_ofld_start_queue */
+	rc = nvme_tcp_ofld_start_queue(nctrl, 0);
+	if (rc)
+		goto out_cleanup_queue;
 
 	rc = nvme_enable_ctrl(nctrl);
 	if (rc)
@@ -229,19 +341,143 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 out_quiesce_queue:
 	blk_mq_quiesce_queue(nctrl->admin_q);
 	blk_sync_queue(nctrl->admin_q);
-
 out_stop_queue:
-	/* Placeholder - stop offload queue */
+	nvme_tcp_ofld_stop_queue(nctrl, 0);
 	nvme_cancel_admin_tagset(nctrl);
-
+out_cleanup_queue:
+	if (new)
+		blk_cleanup_queue(nctrl->admin_q);
 out_cleanup_fabrics_q:
 	if (new)
 		blk_cleanup_queue(nctrl->fabrics_q);
 out_free_tagset:
 	if (new)
 		blk_mq_free_tag_set(nctrl->admin_tagset);
-out_destroy_queue:
-	/* Placeholder - free admin queue */
+out_free_queue:
+	nvme_tcp_ofld_free_queue(nctrl, 0);
+
+	return rc;
+}
+
+static unsigned int nvme_tcp_ofld_nr_io_queues(struct nvme_ctrl *nctrl)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
+	u32 hw_vectors = dev->num_hw_vectors;
+	u32 nr_write_queues, nr_poll_queues;
+	u32 nr_io_queues, nr_total_queues;
+
+	nr_io_queues = min3(nctrl->opts->nr_io_queues, num_online_cpus(),
+			    hw_vectors);
+	nr_write_queues = min3(nctrl->opts->nr_write_queues, num_online_cpus(),
+			       hw_vectors);
+	nr_poll_queues = min3(nctrl->opts->nr_poll_queues, num_online_cpus(),
+			      hw_vectors);
+
+	nr_total_queues = nr_io_queues + nr_write_queues + nr_poll_queues;
+
+	return nr_total_queues;
+}
+
+static void
+nvme_tcp_ofld_set_io_queues(struct nvme_ctrl *nctrl, unsigned int nr_io_queues)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvmf_ctrl_options *opts = nctrl->opts;
+
+	if (opts->nr_write_queues && opts->nr_io_queues < nr_io_queues) {
+		/*
+		 * separate read/write queues
+		 * hand out dedicated default queues only after we have
+		 * sufficient read queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_READ] = opts->nr_io_queues;
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_READ];
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_write_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/*
+		 * shared read/write queues
+		 * either no write queues were requested, or we don't have
+		 * sufficient queue count to have dedicated default queues.
+		 */
+		ctrl->io_queues[HCTX_TYPE_DEFAULT] =
+			min(opts->nr_io_queues, nr_io_queues);
+		nr_io_queues -= ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	}
+
+	if (opts->nr_poll_queues && nr_io_queues) {
+		/* map dedicated poll queues only if we have queues left */
+		ctrl->io_queues[HCTX_TYPE_POLL] =
+			min(opts->nr_poll_queues, nr_io_queues);
+	}
+}
+
+static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	int i, rc;
+
+	for (i = 1; i < nctrl->queue_count; i++) {
+		mutex_init(&ctrl->queues[i].queue_lock);
+
+		rc = ctrl->dev->ops->create_queue(&ctrl->queues[i],
+						  i, nctrl->sqsize + 1);
+		if (rc)
+			goto out_free_queues;
+
+		set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &ctrl->queues[i].flags);
+	}
+
+	return 0;
+
+out_free_queues:
+	for (i--; i >= 1; i--)
+		nvme_tcp_ofld_free_queue(nctrl, i);
+
+	return rc;
+}
+
+static int nvme_tcp_ofld_alloc_io_queues(struct nvme_ctrl *nctrl)
+{
+	unsigned int nr_io_queues;
+	int rc;
+
+	nr_io_queues = nvme_tcp_ofld_nr_io_queues(nctrl);
+	rc = nvme_set_queue_count(nctrl, &nr_io_queues);
+	if (rc)
+		return rc;
+
+	nctrl->queue_count = nr_io_queues + 1;
+	if (nctrl->queue_count < 2) {
+		dev_err(nctrl->device,
+			"unable to set any I/O queues\n");
+
+		return -ENOMEM;
+	}
+
+	dev_info(nctrl->device, "creating %d I/O queues.\n", nr_io_queues);
+	nvme_tcp_ofld_set_io_queues(nctrl, nr_io_queues);
+
+	return nvme_tcp_ofld_create_io_queues(nctrl);
+}
+
+static int nvme_tcp_ofld_start_io_queues(struct nvme_ctrl *nctrl)
+{
+	int i, rc = 0;
+
+	for (i = 1; i < nctrl->queue_count; i++) {
+		rc = nvme_tcp_ofld_start_queue(nctrl, i);
+		if (rc)
+			goto out_stop_queues;
+	}
+
+	return 0;
+
+out_stop_queues:
+	for (i--; i >= 1; i--)
+		nvme_tcp_ofld_stop_queue(nctrl, i);
 
 	return rc;
 }
@@ -249,9 +485,10 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 static int
 nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
 {
-	int rc;
+	int rc = nvme_tcp_ofld_alloc_io_queues(nctrl);
 
-	/* Placeholder - alloc_io_queues */
+	if (rc)
+		return rc;
 
 	if (new) {
 		nctrl->tagset = nvme_tcp_ofld_alloc_tagset(nctrl, false);
@@ -269,7 +506,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
 		}
 	}
 
-	/* Placeholder - start_io_queues */
+	rc = nvme_tcp_ofld_start_io_queues(nctrl);
+	if (rc)
+		goto out_cleanup_connect_q;
 
 	if (!new) {
 		nvme_start_queues(nctrl);
@@ -291,16 +530,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
 out_wait_freeze_timed_out:
 	nvme_stop_queues(nctrl);
 	nvme_sync_io_queues(nctrl);
-
-	/* Placeholder - Stop IO queues */
-
+	nvme_tcp_ofld_stop_io_queues(nctrl);
+out_cleanup_connect_q:
+	nvme_cancel_tagset(nctrl);
 	if (new)
 		blk_cleanup_queue(nctrl->connect_q);
 out_free_tag_set:
 	if (new)
 		blk_mq_free_tag_set(nctrl->tagset);
 out_free_io_queues:
-	/* Placeholder - free_io_queues */
+	nvme_tcp_ofld_free_io_queues(nctrl);
 
 	return rc;
 }
@@ -327,6 +566,17 @@ static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
 	}
 }
 
+static int
+nvme_tcp_ofld_init_admin_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			      unsigned int hctx_idx)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = data;
+
+	hctx->driver_data = &ctrl->queues[0];
+
+	return 0;
+}
+
 static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
 {
 	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
@@ -388,9 +638,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
 	return 0;
 
 destroy_io:
-	/* Placeholder - stop and destroy io queues*/
+	if (nctrl->queue_count > 1) {
+		nvme_stop_queues(nctrl);
+		nvme_sync_io_queues(nctrl);
+		nvme_tcp_ofld_stop_io_queues(nctrl);
+		nvme_cancel_tagset(nctrl);
+		nvme_tcp_ofld_destroy_io_queues(nctrl, new);
+	}
 destroy_admin:
-	/* Placeholder - stop and destroy admin queue*/
+	blk_mq_quiesce_queue(nctrl->admin_q);
+	blk_sync_queue(nctrl->admin_q);
+	nvme_tcp_ofld_stop_queue(nctrl, 0);
+	nvme_cancel_admin_tagset(nctrl);
+	nvme_tcp_ofld_destroy_admin_queue(nctrl, new);
 out_release_ctrl:
 	ctrl->dev->ops->release_ctrl(ctrl);
 
@@ -439,15 +699,37 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
 }
 
 static void
-nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove)
+nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *nctrl, bool remove)
 {
-	/* Placeholder - teardown_admin_queue */
+	blk_mq_quiesce_queue(nctrl->admin_q);
+	blk_sync_queue(nctrl->admin_q);
+
+	nvme_tcp_ofld_stop_queue(nctrl, 0);
+	nvme_cancel_admin_tagset(nctrl);
+
+	if (remove)
+		blk_mq_unquiesce_queue(nctrl->admin_q);
+
+	nvme_tcp_ofld_destroy_admin_queue(nctrl, remove);
 }
 
 static void
 nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
 {
-	/* Placeholder - teardown_io_queues */
+	if (nctrl->queue_count <= 1)
+		return;
+
+	blk_mq_quiesce_queue(nctrl->admin_q);
+	nvme_start_freeze(nctrl);
+	nvme_stop_queues(nctrl);
+	nvme_sync_io_queues(nctrl);
+	nvme_tcp_ofld_stop_io_queues(nctrl);
+	nvme_cancel_tagset(nctrl);
+
+	if (remove)
+		nvme_start_queues(nctrl);
+
+	nvme_tcp_ofld_destroy_io_queues(nctrl, remove);
 }
 
 static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
@@ -562,6 +844,12 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
 	return 0;
 }
 
+inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue)
+{
+	return queue->cmnd_capsule_len - sizeof(struct nvme_command);
+}
+EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
+
 static blk_status_t
 nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
 		       const struct blk_mq_queue_data *bd)
@@ -573,22 +861,95 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
+static void
+nvme_tcp_ofld_exit_request(struct blk_mq_tag_set *set,
+			   struct request *rq, unsigned int hctx_idx)
+{
+	/*
+	 * Nothing is allocated in nvme_tcp_ofld_init_request,
+	 * hence empty.
+	 */
+}
+
+static int
+nvme_tcp_ofld_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			unsigned int hctx_idx)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = data;
+
+	hctx->driver_data = &ctrl->queues[hctx_idx + 1];
+
+	return 0;
+}
+
+static int nvme_tcp_ofld_map_queues(struct blk_mq_tag_set *set)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
+	struct nvmf_ctrl_options *opts = ctrl->nctrl.opts;
+
+	if (opts->nr_write_queues && ctrl->io_queues[HCTX_TYPE_READ]) {
+		/* separate read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_READ];
+		set->map[HCTX_TYPE_READ].queue_offset =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+	} else {
+		/* shared read/write queues */
+		set->map[HCTX_TYPE_DEFAULT].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_DEFAULT].queue_offset = 0;
+		set->map[HCTX_TYPE_READ].nr_queues =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT];
+		set->map[HCTX_TYPE_READ].queue_offset = 0;
+	}
+	blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
+	blk_mq_map_queues(&set->map[HCTX_TYPE_READ]);
+
+	if (opts->nr_poll_queues && ctrl->io_queues[HCTX_TYPE_POLL]) {
+		/* map dedicated poll queues only if we have queues left */
+		set->map[HCTX_TYPE_POLL].nr_queues =
+				ctrl->io_queues[HCTX_TYPE_POLL];
+		set->map[HCTX_TYPE_POLL].queue_offset =
+			ctrl->io_queues[HCTX_TYPE_DEFAULT] +
+			ctrl->io_queues[HCTX_TYPE_READ];
+		blk_mq_map_queues(&set->map[HCTX_TYPE_POLL]);
+	}
+
+	dev_info(ctrl->nctrl.device,
+		 "mapped %d/%d/%d default/read/poll queues.\n",
+		 ctrl->io_queues[HCTX_TYPE_DEFAULT],
+		 ctrl->io_queues[HCTX_TYPE_READ],
+		 ctrl->io_queues[HCTX_TYPE_POLL]);
+
+	return 0;
+}
+
+static int nvme_tcp_ofld_poll(struct blk_mq_hw_ctx *hctx)
+{
+	/* Placeholder - Implement polling mechanism */
+
+	return 0;
+}
+
 static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
 	.queue_rq	= nvme_tcp_ofld_queue_rq,
+	.complete	= nvme_complete_rq,
 	.init_request	= nvme_tcp_ofld_init_request,
-	/*
-	 * All additional ops will be also implemented and registered similar to
-	 * tcp.c
-	 */
+	.exit_request	= nvme_tcp_ofld_exit_request,
+	.init_hctx	= nvme_tcp_ofld_init_hctx,
+	.map_queues	= nvme_tcp_ofld_map_queues,
+	.poll		= nvme_tcp_ofld_poll,
 };
 
 static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
 	.queue_rq	= nvme_tcp_ofld_queue_rq,
+	.complete	= nvme_complete_rq,
 	.init_request	= nvme_tcp_ofld_init_request,
-	/*
-	 * All additional ops will be also implemented and registered similar to
-	 * tcp.c
-	 */
+	.exit_request	= nvme_tcp_ofld_exit_request,
+	.init_hctx	= nvme_tcp_ofld_init_admin_hctx,
 };
 
 static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
index 4281d1dacc94..875fcd3ec04a 100644
--- a/drivers/nvme/host/tcp-offload.h
+++ b/drivers/nvme/host/tcp-offload.h
@@ -65,6 +65,9 @@ struct nvme_tcp_ofld_queue {
 	unsigned long flags;
 	size_t cmnd_capsule_len;
 
+	/* mutex used during stop_queue */
+	struct mutex queue_lock;
+
 	u8 hdr_digest;
 	u8 data_digest;
 	u8 tos;
@@ -198,3 +201,4 @@ struct nvme_tcp_ofld_ops {
 int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
 void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
 void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
+inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue);
-- 
2.22.0

