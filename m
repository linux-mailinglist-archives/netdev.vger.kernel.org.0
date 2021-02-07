Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EE0312694
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 19:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhBGSOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 13:14:41 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhBGSOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 13:14:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117I5cIq016215;
        Sun, 7 Feb 2021 10:13:52 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq2dn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 10:13:51 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 10:13:49 -0800
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 10:13:46 -0800
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <sagi@grimberg.me>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <Erik.Smith@dell.com>,
        <Douglas.Farley@dell.com>, <smalin@marvell.com>,
        <aelior@marvell.com>, <mkalderon@marvell.com>,
        <pkushwaha@marvell.com>, <nassa@marvell.com>,
        <malin1024@gmail.com>, Arie Gershberg <agershberg@marvell.com>
Subject: [RFC PATCH v3 05/11] nvme-tcp-offload: Add controller level error recovery implementation
Date:   Sun, 7 Feb 2021 20:13:18 +0200
Message-ID: <20210207181324.11429-6-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210207181324.11429-1-smalin@marvell.com>
References: <20210207181324.11429-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_08:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arie Gershberg <agershberg@marvell.com>

In this patch, we implement controller level error handling and recovery.
Upon an error discovered by the ULP or reset controller initiated by the
nvme-core (using reset_ctrl workqueue), the ULP will initiate a controller
recovery which includes teardown and re-connect of all queues.

Signed-off-by: Arie Gershberg <agershberg@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/nvme/host/tcp-offload.c | 121 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/tcp-offload.h |  10 +++
 2 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
index da934c6fed9e..e3759c281927 100644
--- a/drivers/nvme/host/tcp-offload.c
+++ b/drivers/nvme/host/tcp-offload.c
@@ -73,6 +73,23 @@ void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
 }
 EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
 
+/**
+ * nvme_tcp_ofld_error_recovery() - NVMeTCP Offload Library error recovery.
+ * function.
+ * @nctrl:	NVMe controller instance to change to resetting.
+ *
+ * API function that change the controller state to resseting.
+ * Part of the overall controller reset sequence.
+ */
+void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl)
+{
+	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_RESETTING))
+		return;
+
+	queue_work(nvme_reset_wq, &to_tcp_ofld_ctrl(nctrl)->err_work);
+}
+EXPORT_SYMBOL_GPL(nvme_tcp_ofld_error_recovery);
+
 /**
  * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
  * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
@@ -291,6 +308,27 @@ nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
 	return rc;
 }
 
+static void nvme_tcp_ofld_reconnect_or_remove(struct nvme_ctrl *nctrl)
+{
+	/* If we are resetting/deleting then do nothing */
+	if (nctrl->state != NVME_CTRL_CONNECTING) {
+		WARN_ON_ONCE(nctrl->state == NVME_CTRL_NEW ||
+			     nctrl->state == NVME_CTRL_LIVE);
+		return;
+	}
+
+	if (nvmf_should_reconnect(nctrl)) {
+		dev_info(nctrl->device, "Reconnecting in %d seconds...\n",
+			 nctrl->opts->reconnect_delay);
+		queue_delayed_work(nvme_wq,
+				   &to_tcp_ofld_ctrl(nctrl)->connect_work,
+				   nctrl->opts->reconnect_delay * HZ);
+	} else {
+		dev_info(nctrl->device, "Removing controller...\n");
+		nvme_delete_ctrl(nctrl);
+	}
+}
+
 static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
 {
 	struct nvmf_ctrl_options *opts = nctrl->opts;
@@ -399,10 +437,62 @@ nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
 	/* Placeholder - teardown_io_queues */
 }
 
+static void nvme_tcp_ofld_reconnect_ctrl_work(struct work_struct *work)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl =
+				container_of(to_delayed_work(work),
+					     struct nvme_tcp_ofld_ctrl,
+					     connect_work);
+	struct nvme_ctrl *nctrl = &ctrl->nctrl;
+
+	++nctrl->nr_reconnects;
+
+	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
+		goto requeue;
+
+	dev_info(nctrl->device, "Successfully reconnected (%d attempt)\n",
+		 nctrl->nr_reconnects);
+
+	nctrl->nr_reconnects = 0;
+
+	return;
+
+requeue:
+	dev_info(nctrl->device, "Failed reconnect attempt %d\n",
+		 nctrl->nr_reconnects);
+	nvme_tcp_ofld_reconnect_or_remove(nctrl);
+}
+
+static void nvme_tcp_ofld_error_recovery_work(struct work_struct *work)
+{
+	struct nvme_tcp_ofld_ctrl *ctrl =
+		container_of(work, struct nvme_tcp_ofld_ctrl, err_work);
+	struct nvme_ctrl *nctrl = &ctrl->nctrl;
+
+	nvme_stop_keep_alive(nctrl);
+	nvme_tcp_ofld_teardown_io_queues(nctrl, false);
+	/* unquiesce to fail fast pending requests */
+	nvme_start_queues(nctrl);
+	nvme_tcp_ofld_teardown_admin_queue(nctrl, false);
+	blk_mq_unquiesce_queue(nctrl->admin_q);
+
+	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
+		/* state change failure is ok if we started nctrl delete */
+		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
+			     nctrl->state != NVME_CTRL_DELETING_NOIO);
+		return;
+	}
+
+	nvme_tcp_ofld_reconnect_or_remove(nctrl);
+}
+
 static void
 nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
 {
-	/* Placeholder - err_work and connect_work */
+	struct nvme_tcp_ofld_ctrl *ctrl = to_tcp_ofld_ctrl(nctrl);
+
+	cancel_work_sync(&ctrl->err_work);
+	cancel_delayed_work_sync(&ctrl->connect_work);
 	nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
 	blk_mq_quiesce_queue(nctrl->admin_q);
 	if (shutdown)
@@ -417,6 +507,31 @@ static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
 	nvme_tcp_ofld_teardown_ctrl(nctrl, true);
 }
 
+static void nvme_tcp_ofld_reset_ctrl_work(struct work_struct *work)
+{
+	struct nvme_ctrl *nctrl =
+		container_of(work, struct nvme_ctrl, reset_work);
+
+	nvme_stop_ctrl(nctrl);
+	nvme_tcp_ofld_teardown_ctrl(nctrl, false);
+
+	if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
+		/* state change failure is ok if we started ctrl delete */
+		WARN_ON_ONCE(nctrl->state != NVME_CTRL_DELETING &&
+			     nctrl->state != NVME_CTRL_DELETING_NOIO);
+		return;
+	}
+
+	if (nvme_tcp_ofld_setup_ctrl(nctrl, false))
+		goto out_fail;
+
+	return;
+
+out_fail:
+	++nctrl->nr_reconnects;
+	nvme_tcp_ofld_reconnect_or_remove(nctrl);
+}
+
 static int
 nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
 			   struct request *rq,
@@ -513,6 +628,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
 			     opts->nr_poll_queues + 1;
 	nctrl->sqsize = opts->queue_size - 1;
 	nctrl->kato = opts->kato;
+	INIT_DELAYED_WORK(&ctrl->connect_work,
+			  nvme_tcp_ofld_reconnect_ctrl_work);
+	INIT_WORK(&ctrl->err_work, nvme_tcp_ofld_error_recovery_work);
+	INIT_WORK(&nctrl->reset_work, nvme_tcp_ofld_reset_ctrl_work);
 	if (!(opts->mask & NVMF_OPT_TRSVCID)) {
 		opts->trsvcid =
 			kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERNEL);
diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
index a9bcd4f7d150..0fb212f9193a 100644
--- a/drivers/nvme/host/tcp-offload.h
+++ b/drivers/nvme/host/tcp-offload.h
@@ -84,6 +84,15 @@ struct nvme_tcp_ofld_ctrl {
 	struct blk_mq_tag_set admin_tag_set;
 	struct nvme_tcp_ofld_queue *queues;
 
+	struct work_struct err_work;
+	struct delayed_work connect_work;
+
+	/*
+	 * Each entry in the array indicates the number of queues of
+	 * corresponding type.
+	 */
+	u32 queue_type_mapping[HCTX_MAX_TYPES];
+
 	/* Connectivity params */
 	struct nvme_tcp_ofld_ctrl_con_params conn_params;
 
@@ -166,3 +175,4 @@ struct nvme_tcp_ofld_ops {
 /* Exported functions for lower vendor specific offload drivers */
 int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev);
 void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev);
+void nvme_tcp_ofld_error_recovery(struct nvme_ctrl *nctrl);
-- 
2.22.0

