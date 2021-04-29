Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F9136F041
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 21:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhD2TRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:17:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239531AbhD2TLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:11:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13TJ6GPe019581;
        Thu, 29 Apr 2021 12:10:25 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 387erumw22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 29 Apr 2021 12:10:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 29 Apr
 2021 12:10:23 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 12:10:19 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>, <hch@lst.de>, <axboe@fb.com>,
        <kbusch@kernel.org>
CC:     =?UTF-8?q?David=20S=20=2E=20Miller=20davem=20=40=20davemloft=20=2E=20net=20=C2=A0--cc=3DJakub=20Kicinski?= 
        <kuba@kernel.org>, <smalin@marvell.com>, <aelior@marvell.com>,
        <mkalderon@marvell.com>, <okulkarni@marvell.com>,
        <pkushwaha@marvell.com>, <malin1024@gmail.com>,
        Arie Gershberg <agershberg@marvell.com>
Subject: [RFC PATCH v4 11/27] nvme-tcp-offload: Add controller level implementation
Date:   Thu, 29 Apr 2021 22:09:10 +0300
Message-ID: <20210429190926.5086-12-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: TEn28OSo2x9SL9eIWbHYRgNE5sKsB75J
X-Proofpoint-ORIG-GUID: TEn28OSo2x9SL9eIWbHYRgNE5sKsB75J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-29_10:2021-04-28,2021-04-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arie Gershberg <agershberg@marvell.com>

In this patch we implement controller level functionality including:
- create_ctrl.
- delete_ctrl.
- free_ctrl.

The implementation is similar to other nvme fabrics modules, the main
difference being that the nvme-tcp-offload ULP calls the vendor specific
claim_dev() op with the given TCP/IP parameters to determine which device
will be used for this controller.
Once found, the vendor specific device and controller will be paired and
kept in a controller list managed by the ULP.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Arie Gershberg <agershberg@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/tcp-offload.c | 467 +++++++++++++++++++++++++++++++-
 1 file changed, 459 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index aa7cc239abf2..59e1955e02ec 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -12,6 +12,10 @@
 
 static LIST_HEAD(nvme_tcp_ofld_devices);
 static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
+static LIST_HEAD(nvme_tcp_ofld_ctrl_list);
+static DECLARE_RWSEM(nvme_tcp_ofld_ctrl_rwsem);
+static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops;
+static struct blk_mq_ops nvme_tcp_ofld_mq_ops;
 
 static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
 {
@@ -128,28 +132,430 @@ nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
 	return dev;
 }
 
+static struct blk_mq_tag_set *
+nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct blk_mq_tag_set *set;
+	int rc;
+
+	if (admin) {
+		set = &ctrl->admin_tag_set;
+		memset(set, 0, sizeof(*set));
+		set->ops = &nvme_tcp_ofld_admin_mq_ops;
+		set->queue_depth = NVME_AQ_MQ_TAG_DEPTH;
+		set->reserved_tags = NVMF_RESERVED_TAGS;
+		set->numa_node = nctrl->numa_node;
+		set->flags = BLK_MQ_F_BLOCKING;
+		set->cmd_size = sizeof(struct nvme_tcp_ofld_req);
+		set->driver_data = ctrl;
+		set->nr_hw_queues = 1;
+		set->timeout = NVME_ADMIN_TIMEOUT;
+	} else {
+		set = &ctrl->tag_set;
+		memset(set, 0, sizeof(*set));
+		set->ops = &nvme_tcp_ofld_mq_ops;
+		set->queue_depth = nctrl->sqsize + 1;
+		set->reserved_tags = NVMF_RESERVED_TAGS;
+		set->numa_node = nctrl->numa_node;
+		set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING;
+		set->cmd_size = sizeof(struct nvme_tcp_ofld_req);
+		set->driver_data = ctrl;
+		set->nr_hw_queues = nctrl->queue_count - 1;
+		set->timeout = NVME_IO_TIMEOUT;
+		set->nr_maps = nctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2;
+	}
+
+	rc = blk_mq_alloc_tag_set(set);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return set;
+}
+
+static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl,
+					       bool new)
+{
+	int rc;
+
+	/* Placeholder - alloc_admin_queue */
+	if (new) {
+		nctrl->admin_tagset =
+				nvme_tcp_ofld_alloc_tagset(nctrl, true);
+		if (IS_ERR(nctrl->admin_tagset)) {
+			rc = PTR_ERR(nctrl->admin_tagset);
+			nctrl->admin_tagset = NULL;
+			goto out_free_queue;
+		}
+
+		nctrl->fabrics_q = blk_mq_init_queue(nctrl->admin_tagset);
+		if (IS_ERR(nctrl->fabrics_q)) {
+			rc = PTR_ERR(nctrl->fabrics_q);
+			nctrl->fabrics_q = NULL;
+			goto out_free_tagset;
+		}
+
+		nctrl->admin_q = blk_mq_init_queue(nctrl->admin_tagset);
+		if (IS_ERR(nctrl->admin_q)) {
+			rc = PTR_ERR(nctrl->admin_q);
+			nctrl->admin_q = NULL;
+			goto out_cleanup_fabrics_q;
+		}
+	}
+
+	/* Placeholder - nvme_tcp_ofld_start_queue */
+
+	rc = nvme_enable_ctrl(nctrl);
+	if (rc)
+		goto out_stop_queue;
+
+	blk_mq_unquiesce_queue(nctrl->admin_q);
+
+	rc = nvme_init_identify(nctrl);
+	if (rc)
+		goto out_quiesce_queue;
+
+	return 0;
+
+out_quiesce_queue:
+	blk_mq_quiesce_queue(nctrl->admin_q);
+	blk_sync_queue(nctrl->admin_q);
+
+out_stop_queue:
+	/* Placeholder - stop offload queue */
+	nvme_cancel_admin_tagset(nctrl);
+
+out_cleanup_fabrics_q:
+	if (new)
+		blk_cleanup_queue(nctrl->fabrics_q);
+out_free_tagset:
+	if (new)
+		blk_mq_free_tag_set(nctrl->admin_tagset);
+out_free_queue:
+	/* Placeholder - free admin queue */
+
+	return rc;
+}
+
+static int
+nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
+{
+	int rc;
+
+	/* Placeholder - alloc_io_queues */
+
+	if (new) {
+		nctrl->tagset = nvme_tcp_ofld_alloc_tagset(nctrl, false);
+		if (IS_ERR(nctrl->tagset)) {
+			rc = PTR_ERR(nctrl->tagset);
+			nctrl->tagset = NULL;
+			goto out_free_io_queues;
+		}
+
+		nctrl->connect_q = blk_mq_init_queue(nctrl->tagset);
+		if (IS_ERR(nctrl->connect_q)) {
+			rc = PTR_ERR(nctrl->connect_q);
+			nctrl->connect_q = NULL;
+			goto out_free_tag_set;
+		}
+	}
+
+	/* Placeholder - start_io_queues */
+
+	if (!new) {
+		nvme_start_queues(nctrl);
+		if (!nvme_wait_freeze_timeout(nctrl, NVME_IO_TIMEOUT)) {
+			/*
+			 * If we timed out waiting for freeze we are likely to
+			 * be stuck.  Fail the controller initialization just
+			 * to be safe.
+			 */
+			rc = -ENODEV;
+			goto out_wait_freeze_timed_out;
+		}
+		blk_mq_update_nr_hw_queues(nctrl->tagset, nctrl->queue_count - 1);
+		nvme_unfreeze(nctrl);
+	}
+
+	return 0;
+
+out_wait_freeze_timed_out:
+	nvme_stop_queues(nctrl);
+	nvme_sync_io_queues(nctrl);
+
+	/* Placeholder - Stop IO queues */
+
+	if (new)
+		blk_cleanup_queue(nctrl->connect_q);
+out_free_tag_set:
+	if (new)
+		blk_mq_free_tag_set(nctrl->tagset);
+out_free_io_queues:
+	/* Placeholder - free_io_queues */
+
+	return rc;
+}
+
 static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
 {
-	/* Placeholder - validates inputs and creates admin and IO queues */
+	struct nvmf_ctrl_options *opts = nctrl->opts;
+	int rc;
+
+	rc = nvme_tcp_ofld_configure_admin_queue(nctrl, new);
+	if (rc)
+		return rc;
+
+	if (nctrl->icdoff) {
+		dev_err(nctrl->device, "icdoff is not supported!\n");
+		rc = -EINVAL;
+		goto destroy_admin;
+	}
+
+	if (opts->queue_size > nctrl->sqsize + 1)
+		dev_warn(nctrl->device,
+			 "queue_size %zu > ctrl sqsize %u, clamping down\n",
+			 opts->queue_size, nctrl->sqsize + 1);
+
+	if (nctrl->sqsize + 1 > nctrl->maxcmd) {
+		dev_warn(nctrl->device,
+			 "sqsize %u > ctrl maxcmd %u, clamping down\n",
+			 nctrl->sqsize + 1, nctrl->maxcmd);
+		nctrl->sqsize = nctrl->maxcmd - 1;
+	}
+
+	if (nctrl->queue_count > 1) {
+		rc = nvme_tcp_ofld_configure_io_queues(nctrl, new);
+		if (rc)
+			goto destroy_admin;
+	}
+
+	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_LIVE)) {
+		/*
+		 * state change failure is ok if we started ctrl delete,
+		 * unless we're during creation of a new controller to
+		 * avoid races with teardown flow.
+		 */
+		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
+			     nctrl->state != NVME_CTRL_DELETING_NOIO);
+		WARN_ON_ONCE(new);
+		rc = -EINVAL;
+		goto destroy_io;
+	}
+
+	nvme_start_ctrl(nctrl);
+
+	return 0;
+
+destroy_io:
+	/* Placeholder - stop and destroy io queues*/
+destroy_admin:
+	/* Placeholder - stop and destroy admin queue*/
+
+	return rc;
+}
+
+static int
+nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
+			     struct nvme_tcp_ofld_ops *ofld_ops)
+{
+	unsigned int nvme_tcp_ofld_opt_mask = NVMF_ALLOWED_OPTS |
+			ofld_ops->allowed_opts | ofld_ops->required_opts;
+	if (opts->mask & ~nvme_tcp_ofld_opt_mask) {
+		pr_warn("One or more of the nvmf options isn't supported by %s.\n",
+			ofld_ops->name);
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+	struct nvme_tcp_ofld_dev *dev = ctrl->dev;
+
+	if (list_empty(&ctrl->list))
+		goto free_ctrl;
+
+	down_write(&nvme_tcp_ofld_ctrl_rwsem);
+	ctrl->dev->ops->release_ctrl(ctrl);
+	list_del(&ctrl->list);
+	up_write(&nvme_tcp_ofld_ctrl_rwsem);
+
+	nvmf_free_options(nctrl->opts);
+free_ctrl:
+	module_put(dev->ops->module);
+	kfree(ctrl->queues);
+	kfree(ctrl);
+}
+
+static void nvme_tcp_ofld_submit_async_event(struct nvme_ctrl *arg)
+{
+	/* Placeholder - submit_async_event */
+}
+
+static void
+nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove)
+{
+	/* Placeholder - teardown_admin_queue */
+}
+
+static void
+nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
+{
+	/* Placeholder - teardown_io_queues */
+}
+
+static void
+nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
+{
+	/* Placeholder - err_work and connect_work */
+	nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
+	blk_mq_quiesce_queue(nctrl->admin_q);
+	if (shutdown)
+		nvme_shutdown_ctrl(nctrl);
+	else
+		nvme_disable_ctrl(nctrl);
+	nvme_tcp_ofld_teardown_admin_queue(nctrl, shutdown);
+}
+
+static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
+{
+	nvme_tcp_ofld_teardown_ctrl(nctrl, true);
+}
+
+static int
+nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
+			   struct request *rq,
+			   unsigned int hctx_idx,
+			   unsigned int numa_node)
+{
+	struct nvme_tcp_ofld_req *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_ofld_ctrl *ctrl = set->driver_data;
+
+	/* Placeholder - init request */
+
+	req->done = nvme_tcp_ofld_req_done;
+	ctrl->dev->ops->init_req(req);
 
 	return 0;
 }
 
+static blk_status_t
+nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
+		       const struct blk_mq_queue_data *bd)
+{
+	/* Call nvme_setup_cmd(...) */
+
+	/* Call ops->send_req(...) */
+
+	return BLK_STS_OK;
+}
+
+static struct blk_mq_ops nvme_tcp_ofld_mq_ops = {
+	.queue_rq	= nvme_tcp_ofld_queue_rq,
+	.init_request	= nvme_tcp_ofld_init_request,
+	/*
+	 * All additional ops will be also implemented and registered similar to
+	 * tcp.c
+	 */
+};
+
+static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops = {
+	.queue_rq	= nvme_tcp_ofld_queue_rq,
+	.init_request	= nvme_tcp_ofld_init_request,
+	/*
+	 * All additional ops will be also implemented and registered similar to
+	 * tcp.c
+	 */
+};
+
+static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops = {
+	.name			= "tcp_offload",
+	.module			= THIS_MODULE,
+	.flags			= NVME_F_FABRICS,
+	.reg_read32		= nvmf_reg_read32,
+	.reg_read64		= nvmf_reg_read64,
+	.reg_write32		= nvmf_reg_write32,
+	.free_ctrl		= nvme_tcp_ofld_free_ctrl,
+	.submit_async_event	= nvme_tcp_ofld_submit_async_event,
+	.delete_ctrl		= nvme_tcp_ofld_delete_ctrl,
+	.get_address		= nvmf_get_address,
+};
+
+static bool
+nvme_tcp_ofld_existing_controller(struct nvmf_ctrl_options *opts)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl;
+	bool found = false;
+
+	down_read(&nvme_tcp_ofld_ctrl_rwsem);
+	list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list) {
+		found = nvmf_ip_options_match(&ctrl->nctrl, opts);
+		if (found)
+			break;
+	}
+	up_read(&nvme_tcp_ofld_ctrl_rwsem);
+
+	return found;
+}
+
 static struct nvme_ctrl *
 nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
 {
+	struct nvme_tcp_ofld_queue *queue;
 	struct nvme_tcp_ofld_ctrl *ctrl;
 	struct nvme_tcp_ofld_dev *dev;
 	struct nvme_ctrl *nctrl;
-	int rc = 0;
+	int i, rc = 0;
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
 		return ERR_PTR(-ENOMEM);
 
+	INIT_LIST_HEAD(&ctrl->list);
 	nctrl = &ctrl->nctrl;
+	nctrl->opts = opts;
+	nctrl->queue_count = opts->nr_io_queues + opts->nr_write_queues +
+			     opts->nr_poll_queues + 1;
+	nctrl->sqsize = opts->queue_size - 1;
+	nctrl->kato = opts->kato;
+	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
+		opts->trsvcid =
+			kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERNEL);
+		if (!opts->trsvcid) {
+			rc = -ENOMEM;
+			goto out_free_ctrl;
+		}
+		opts->mask |= NVMF_OPT_TRSVCID;
+	}
 
-	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
+	rc = inet_pton_with_scope(&init_net, AF_UNSPEC, opts->traddr,
+				  opts->trsvcid,
+				  &ctrl->conn_params.remote_ip_addr);
+	if (rc) {
+		pr_err("malformed address passed: %s:%s\n",
+		       opts->traddr, opts->trsvcid);
+		goto out_free_ctrl;
+	}
+
+	if (opts->mask & NVMF_OPT_HOST_TRADDR) {
+		rc = inet_pton_with_scope(&init_net, AF_UNSPEC,
+					  opts->host_traddr, NULL,
+					  &ctrl->conn_params.local_ip_addr);
+		if (rc) {
+			pr_err("malformed src address passed: %s\n",
+			       opts->host_traddr);
+			goto out_free_ctrl;
+		}
+	}
+
+	if (!opts->duplicate_connect &&
+	    nvme_tcp_ofld_existing_controller(opts)) {
+		rc = -EALREADY;
+		goto out_free_ctrl;
+	}
 
 	/* Find device that can reach the dest addr */
 	dev = nvme_tcp_ofld_lookup_dev(ctrl);
@@ -160,6 +566,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
 		goto out_free_ctrl;
 	}
 
+	rc = nvme_tcp_ofld_check_dev_opts(opts, dev->ops);
+	if (rc)
+		goto out_module_put;
+
 	ctrl->dev = dev;
 
 	if (ctrl->dev->ops->max_hw_sectors)
@@ -167,22 +577,55 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
 	if (ctrl->dev->ops->max_segments)
 		nctrl->max_segments = ctrl->dev->ops->max_segments;
 
-	/* Init queues */
+	ctrl->queues = kcalloc(nctrl->queue_count,
+			       sizeof(struct nvme_tcp_ofld_queue),
+			       GFP_KERNEL);
+	if (!ctrl->queues) {
+		rc = -ENOMEM;
+		goto out_module_put;
+	}
 
-	/* Call nvme_init_ctrl */
+	for (i = 0; i < nctrl->queue_count; ++i) {
+		queue = &ctrl->queues[i];
+		queue->ctrl = ctrl;
+		queue->dev = dev;
+		queue->report_err = nvme_tcp_ofld_report_queue_err;
+	}
+
+	rc = nvme_init_ctrl(nctrl, ndev, &nvme_tcp_ofld_ctrl_ops, 0);
+	if (rc)
+		goto out_free_queues;
+
+	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
+		WARN_ON_ONCE(1);
+		rc = -EINTR;
+		goto out_uninit_ctrl;
+	}
 
 	rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
 	if (rc)
-		goto out_module_put;
+		goto out_uninit_ctrl;
 
 	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
 	if (rc)
-		goto out_uninit_ctrl;
+		goto out_release_ctrl;
+
+	dev_info(nctrl->device, "new ctrl: NQN \"%s\", addr %pISp\n",
+		 opts->subsysnqn, &ctrl->conn_params.remote_ip_addr);
+
+	down_write(&nvme_tcp_ofld_ctrl_rwsem);
+	list_add_tail(&ctrl->list, &nvme_tcp_ofld_ctrl_list);
+	up_write(&nvme_tcp_ofld_ctrl_rwsem);
 
 	return nctrl;
 
-out_uninit_ctrl:
+out_release_ctrl:
 	ctrl->dev->ops->release_ctrl(ctrl);
+out_uninit_ctrl:
+	nvme_uninit_ctrl(nctrl);
+	nvme_put_ctrl(nctrl);
+out_free_queues:
+	kfree(ctrl->queues);
 out_module_put:
 	module_put(dev->ops->module);
 out_free_ctrl:
@@ -212,7 +655,15 @@ static int __init nvme_tcp_ofld_init_module(void)
 
 static void __exit nvme_tcp_ofld_cleanup_module(void)
 {
+	struct nvme_tcp_ofld_ctrl *ctrl;
+
 	nvmf_unregister_transport(&nvme_tcp_ofld_transport);
+
+	down_write(&nvme_tcp_ofld_ctrl_rwsem);
+	list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list)
+		nvme_delete_ctrl(&ctrl->nctrl);
+	up_write(&nvme_tcp_ofld_ctrl_rwsem);
+	flush_workqueue(nvme_delete_wq);
 }
 
 module_init(nvme_tcp_ofld_init_module);
-- 
2.22.0

