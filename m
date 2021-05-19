Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E69388C79
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346254AbhESLQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:16:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62626 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346275AbhESLQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 07:16:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBBDJA008736;
        Wed, 19 May 2021 04:14:57 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38mqcwhy3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:14:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 19 May
 2021 04:14:54 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 May 2021 04:14:51 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        "Dean Balandin" <dbalandin@marvell.com>
Subject: [RFC PATCH v5 06/27] nvme-tcp-offload: Add queue level implementation
Date:   Wed, 19 May 2021 14:13:19 +0300
Message-ID: <20210519111340.20613-7-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210519111340.20613-1-smalin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: tNc4t9dGiWBgVQoIjnjor81US_IXcKoo
X-Proofpoint-ORIG-GUID: tNc4t9dGiWBgVQoIjnjor81US_IXcKoo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
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
---
 drivers/nvme/host/tcp-offload.c | 424 ++++++++++++++++++++++++++++++--
 drivers/nvme/host/tcp-offload.h |   1 +
 2 files changed, 399 insertions(+), 26 deletions(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index 9eb4b03e0f3d..8ed7668d987a 100644
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
@@ -191,12 +196,94 @@ nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
 	return set;
 }
 
+static void __nvme_tcp_ofld_stop_queue(struct nvme_tcp_ofld_queue *queue)
+{
+	queue->dev->ops->drain_queue(queue);
+	queue->dev->ops->destroy_queue(queue);
+}
+
+static void nvme_tcp_ofld_stop_queue(struct nvme_ctrl *nctrl, int qid)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
+
+	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_LIVE, &queue->flags))
+		return;
+
+	__nvme_tcp_ofld_stop_queue(queue);
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
+static void nvme_tcp_ofld_free_queue(struct nvme_ctrl *nctrl, int qid)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_queue *queue = &ctrl->queues[qid];
+
+	if (!test_and_clear_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags))
+		return;
+
+	queue = &ctrl->queues[qid];
+	queue->ctrl = NULL;
+	queue->dev = NULL;
+	queue->report_err = NULL;
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
+	rc = ctrl->dev->ops->create_queue(queue, 0, NVME_AQ_DEPTH);
+	if (rc)
+		return rc;
+
+	set_bit(NVME_TCP_OFLD_Q_ALLOCATED, &queue->flags);
 	if (new) {
 		nctrl->admin_tagset =
 				nvme_tcp_ofld_alloc_tagset(nctrl, true);
@@ -221,7 +308,9 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 		}
 	}
 
-	/* Placeholder - nvme_tcp_ofld_start_queue */
+	rc = nvme_tcp_ofld_start_queue(nctrl, 0);
+	if (rc)
+		goto out_cleanup_queue;
 
 	rc = nvme_enable_ctrl(nctrl);
 	if (rc)
@@ -238,11 +327,12 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
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
@@ -250,7 +340,136 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
 	if (new)
 		blk_mq_free_tag_set(nctrl->admin_tagset);
 out_free_queue:
-	/* Placeholder - free admin queue */
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
+static void
+nvme_tcp_ofld_terminate_io_queues(struct nvme_ctrl *nctrl, int start_from)
+{
+	int i;
+
+	/* Loop condition will stop before index 0 which is the admin queue */
+	for (i = start_from; i >= 1; i--)
+		nvme_tcp_ofld_stop_queue(nctrl, i);
+}
+
+static int nvme_tcp_ofld_create_io_queues(struct nvme_ctrl *nctrl)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	int i, rc;
+
+	for (i = 1; i < nctrl->queue_count; i++) {
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
+	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
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
+			goto terminate_queues;
+	}
+
+	return 0;
+
+terminate_queues:
+	nvme_tcp_ofld_terminate_io_queues(nctrl, --i);
 
 	return rc;
 }
@@ -258,9 +477,10 @@ static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
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
@@ -278,7 +498,9 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
 		}
 	}
 
-	/* Placeholder - start_io_queues */
+	rc = nvme_tcp_ofld_start_io_queues(nctrl);
+	if (rc)
+		goto out_cleanup_connect_q;
 
 	if (!new) {
 		nvme_start_queues(nctrl);
@@ -300,16 +522,16 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
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
+	nvme_tcp_ofld_terminate_io_queues(nctrl, nctrl->queue_count);
 
 	return rc;
 }
@@ -336,6 +558,26 @@ static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
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
+static void nvme_tcp_ofld_destroy_io_queues(struct nvme_ctrl *nctrl, bool remove)
+{
+	nvme_tcp_ofld_stop_io_queues(nctrl);
+	if (remove) {
+		blk_cleanup_queue(nctrl->connect_q);
+		blk_mq_free_tag_set(nctrl->tagset);
+	}
+}
+
 static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
 {
 	struct nvmf_ctrl_options *opts = nctrl->opts;
@@ -392,9 +634,19 @@ static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
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
 
 	return rc;
 }
@@ -415,6 +667,18 @@ nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
 	return 0;
 }
 
+static void nvme_tcp_ofld_free_ctrl_queues(struct nvme_ctrl *nctrl)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	int i;
+
+	for (i = 0; i < nctrl->queue_count; ++i)
+		nvme_tcp_ofld_free_queue(nctrl, i);
+
+	kfree(ctrl->queues);
+	ctrl->queues = NULL;
+}
+
 static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
@@ -424,6 +688,7 @@ static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
 		goto free_ctrl;
 
 	down_write(&nvme_tcp_ofld_ctrl_rwsem);
+	nvme_tcp_ofld_free_ctrl_queues(nctrl);
 	ctrl->dev->ops->release_ctrl(ctrl);
 	list_del(&ctrl->list);
 	up_write(&nvme_tcp_ofld_ctrl_rwsem);
@@ -441,15 +706,37 @@ static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
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
@@ -577,6 +864,17 @@ nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
 	return 0;
 }
 
+inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue)
+{
+	return queue->cmnd_capsule_len - sizeof(struct nvme_command);
+}
+EXPORT_SYMBOL_GPL(nvme_tcp_ofld_inline_data_size);
+
+static void nvme_tcp_ofld_commit_rqs(struct blk_mq_hw_ctx *hctx)
+{
+	/* Call ops->commit_rqs */
+}
+
 static blk_status_t
 nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
 		       const struct blk_mq_queue_data *bd)
@@ -588,22 +886,96 @@ nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
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
+	.commit_rqs     = nvme_tcp_ofld_commit_rqs,
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
index 2a931d05905d..2233d855aa10 100644
--- a/drivers/nvme/host/tcp-offload.h
+++ b/drivers/nvme/host/tcp-offload.h
@@ -211,3 +211,4 @@ struct nvme_tcp_ofld_ops {
 int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
 void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
 void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
+inline size_t nvme_tcp_ofld_inline_data_size(struct nvme_tcp_ofld_queue *queue);
-- 
2.22.0

