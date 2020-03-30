Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BFC19748E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgC3Gay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:30:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728991AbgC3Gax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:30:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6PEHp016756;
        Sun, 29 Mar 2020 23:30:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=a5oZZIn+G33vrAWId3T1hqCZVpNZ/YHbFv9IIwAh4MM=;
 b=qiOcPHvkMD33ujTsYxC+Jo7vDoZmyRXjT/ROrg6lVlpUwlnjWRCNbmzGe9sqsNXb6cgC
 1u2GEfwf+j55d0PvY/8rMT2pCT/UvI/icxlOlFJfre3WnoDe0egDOtxDO++jiPD9eIZF
 Wv/69Eo+CXEYTuLfs4jqR90+nUD/DCij9TrVVkOxxx2xJPznG8nZqRWKBJbdDxGJOQJ4
 jQO5Hg01bNdfttXbNLy2TDM1Ine9ldfXrVmFTIUeIlxPyNZvuTX/66MZH7X/Lz1Qn+ji
 Z9mudM/jqGq+xwzSiEXT2CTBeqh5ZkJC2CC8ZItNHnVzMblUCjHo2cK1rBzbQ0j3HjBe tg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnwdan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:52 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:50 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:50 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E30F63F703F;
        Sun, 29 Mar 2020 23:30:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6Uo6H027364;
        Sun, 29 Mar 2020 23:30:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UoNE027363;
        Sun, 29 Mar 2020 23:30:50 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 5/8] qedf: Add schedule recovery handler.
Date:   Sun, 29 Mar 2020 23:30:31 -0700
Message-ID: <20200330063034.27309-6-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
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

