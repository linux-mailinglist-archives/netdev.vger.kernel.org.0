Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F0719D671
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 14:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbgDCMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 08:10:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403836AbgDCMKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 08:10:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033C0Fo2011752;
        Fri, 3 Apr 2020 05:10:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=a5oZZIn+G33vrAWId3T1hqCZVpNZ/YHbFv9IIwAh4MM=;
 b=H7aYlD5GvnAWDw/vOeeQIhJAaigQtZiNJMTguB1K98wSYYbja9Xz8rfOKLQ3mjYcshj9
 6lhp+LYGD38erMclwpSZ0kJYn0hDUp9S+/hM3do4c3ZAdyZVNQ1cdRWMXr9IC5GHTcV/
 l/WK616VfJ/gOcVCIJfr6/iIMHG8mJzXxIXVKBB0jTk0E0TpGI+uAVqVlsG4DYov8VyW
 z/cCDUmJD7D8uiALEcGb5CaXB8P0SsolVlRLaNB2B4jCoNa9l/5SNtlryMK+qO5doj3i
 5nOJB1GUG57SmjhmdR/RkufeACGulp6iP81VvA1NrT9APF/P5lrgDaVK4sSliUJrKFmN Eg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855xgsm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 05:10:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 05:10:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 05:10:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BE2493F7041;
        Fri,  3 Apr 2020 05:10:13 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 033CAD05002566;
        Fri, 3 Apr 2020 05:10:13 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 033CAD1I002565;
        Fri, 3 Apr 2020 05:10:13 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 5/7] qedf: Add schedule recovery handler.
Date:   Fri, 3 Apr 2020 05:09:55 -0700
Message-ID: <20200403120957.2431-6-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200403120957.2431-1-skashyap@marvell.com>
References: <20200403120957.2431-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_07:2020-04-02,2020-04-03 signatures=0
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
Changes in v2
 - qedf_schedule_recovery_handler marked as static
 - qedf_recovery_handler marked as static

 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index aaa2ac9..f8a98e5 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -387,6 +387,7 @@ struct qedf_ctx {
 #define QEDF_IO_WORK_MIN		64
 	mempool_t *io_mempool;
 	struct workqueue_struct *dpc_wq;
+	struct delayed_work recovery_work;
 	struct delayed_work grcdump_work;
 	struct delayed_work stag_work;
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ba66216..39a66e4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -28,6 +28,8 @@
 static int qedf_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 static void qedf_remove(struct pci_dev *pdev);
 static void qedf_shutdown(struct pci_dev *pdev);
+static void qedf_schedule_recovery_handler(void *dev);
+static void qedf_recovery_handler(struct work_struct *work);
 
 /*
  * Driver module parameters.
@@ -662,6 +664,7 @@ static u32 qedf_get_login_failures(void *cookie)
 	{
 		.link_update = qedf_link_update,
 		.bw_update = qedf_bw_update,
+		.schedule_recovery_handler = qedf_schedule_recovery_handler,
 		.dcbx_aen = qedf_dcbx_handler,
 		.get_generic_tlv_data = qedf_get_generic_tlv_data,
 		.get_protocol_tlv_data = qedf_get_protocol_tlv_data,
@@ -3510,6 +3513,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		    qedf->lport->host->host_no);
 		qedf->dpc_wq = create_workqueue(host_buf);
 	}
+	INIT_DELAYED_WORK(&qedf->recovery_work, qedf_recovery_handler);
 
 	/*
 	 * GRC dump and sysfs parameters are not reaped during the recovery
@@ -3825,6 +3829,45 @@ static void qedf_shutdown(struct pci_dev *pdev)
 	__qedf_remove(pdev, QEDF_MODE_NORMAL);
 }
 
+/*
+ * Recovery handler code
+ */
+static void qedf_schedule_recovery_handler(void *dev)
+{
+	struct qedf_ctx *qedf = dev;
+
+	QEDF_ERR(&qedf->dbg_ctx, "Recovery handler scheduled.\n");
+	schedule_delayed_work(&qedf->recovery_work, 0);
+}
+
+static void qedf_recovery_handler(struct work_struct *work)
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

