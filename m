Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B1719394F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgCZHI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:08:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727639AbgCZHIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:08:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q70Pe4019422;
        Thu, 26 Mar 2020 00:08:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=wVla8zrZkVOBS+1JOisI/L2w2eFV3Ww+XRtXLjxLwcU=;
 b=puwTr+YcE/XK1RvhYTHRAQEsxU29hGkYYwhq7mN6KwGVnw7+lKqzkO649H9cBkHPhqDX
 3Z+U2vmR7QleiXAWaDAmoYG2MiFpVmVumjKt0qMHSnRrNCa6y3/VCXSfSwXqM94p69n1
 0KZoT5C7WI0fss5MV1b+n5biznuYqbWadLVtpcQy8Fktspe/eJkuhV2YdKFgJdj6W9yu
 bmsZSybjf5vcy5XhXK0cZNdBpC5cpXklHuHSzc6YYJzJ07LJZJuzRMjI1MdH9/DmUJH4
 BIvq+6zQ9C69977N8fg8qnTwx9Yf6Ef7SZNeY9fQvfs1pieN5sb8V36Ha01O2QkAKSeN sw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nv95c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:22 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:22 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A3E983F7043;
        Thu, 26 Mar 2020 00:08:22 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q78MLv025548;
        Thu, 26 Mar 2020 00:08:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q78Mmk025547;
        Thu, 26 Mar 2020 00:08:22 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 5/8] qedf: Add schedule recovery handler.
Date:   Thu, 26 Mar 2020 00:08:03 -0700
Message-ID: <20200326070806.25493-6-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200326070806.25493-1-skashyap@marvell.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

- Add recovery handler, this will be triggered
  by QED.

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  3 +++
 drivers/scsi/qedf/qedf_main.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index aaa2ac9..a5134c7 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -387,6 +387,7 @@ struct qedf_ctx {
 #define QEDF_IO_WORK_MIN		64
 	mempool_t *io_mempool;
 	struct workqueue_struct *dpc_wq;
+	struct delayed_work recovery_work;
 	struct delayed_work grcdump_work;
 	struct delayed_work stag_work;
 
@@ -527,6 +528,8 @@ extern void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 extern void qedf_process_unsol_compl(struct qedf_ctx *qedf, uint16_t que_idx,
 	struct fcoe_cqe *cqe);
 extern void qedf_restart_rport(struct qedf_rport *fcport);
+void qedf_schedule_recovery_handler(void *dev);
+void qedf_recovery_handler(struct work_struct *work);
 extern int qedf_send_rec(struct qedf_ioreq *orig_io_req);
 extern int qedf_post_io_req(struct qedf_rport *fcport,
 	struct qedf_ioreq *io_req);
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ba66216..b3fa21a 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -662,6 +662,7 @@ static u32 qedf_get_login_failures(void *cookie)
 	{
 		.link_update = qedf_link_update,
 		.bw_update = qedf_bw_update,
+		.schedule_recovery_handler = qedf_schedule_recovery_handler,
 		.dcbx_aen = qedf_dcbx_handler,
 		.get_generic_tlv_data = qedf_get_generic_tlv_data,
 		.get_protocol_tlv_data = qedf_get_protocol_tlv_data,
@@ -3510,6 +3511,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		    qedf->lport->host->host_no);
 		qedf->dpc_wq = create_workqueue(host_buf);
 	}
+	INIT_DELAYED_WORK(&qedf->recovery_work, qedf_recovery_handler);
 
 	/*
 	 * GRC dump and sysfs parameters are not reaped during the recovery
@@ -3825,6 +3827,45 @@ static void qedf_shutdown(struct pci_dev *pdev)
 	__qedf_remove(pdev, QEDF_MODE_NORMAL);
 }
 
+/*
+ * Recovery handler code
+ */
+void qedf_schedule_recovery_handler(void *dev)
+{
+	struct qedf_ctx *qedf = dev;
+
+	QEDF_ERR(&qedf->dbg_ctx, "Recovery handler scheduled.\n");
+	schedule_delayed_work(&qedf->recovery_work, 0);
+}
+
+void qedf_recovery_handler(struct work_struct *work)
+{
+	struct qedf_ctx *qedf =
+	    container_of(work, struct qedf_ctx, recovery_work.work);
+
+	if (test_and_set_bit(QEDF_IN_RECOVERY, &qedf->flags))
+		return;
+
+	/*
+	 * Call common_ops->recovery_prolog to allow the MFW to quiesce
+	 * any PCI transactions.
+	 */
+	qed_ops->common->recovery_prolog(qedf->cdev);
+
+	QEDF_ERR(&qedf->dbg_ctx, "Recovery work start.\n");
+	__qedf_remove(qedf->pdev, QEDF_MODE_RECOVERY);
+	/*
+	 * Reset link and dcbx to down state since we will not get a link down
+	 * event from the MFW but calling __qedf_remove will essentially be a
+	 * link down event.
+	 */
+	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
+	atomic_set(&qedf->dcbx, QEDF_DCBX_PENDING);
+	__qedf_probe(qedf->pdev, QEDF_MODE_RECOVERY);
+	clear_bit(QEDF_IN_RECOVERY, &qedf->flags);
+	QEDF_ERR(&qedf->dbg_ctx, "Recovery work complete.\n");
+}
+
 /* Generic TLV data callback */
 void qedf_get_generic_tlv_data(void *dev, struct qed_generic_tlvs *data)
 {
-- 
1.8.3.1

