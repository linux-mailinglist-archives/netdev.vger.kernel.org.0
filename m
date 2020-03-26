Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D907193944
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgCZHIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:08:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727721AbgCZHIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:08:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q710o1017925;
        Thu, 26 Mar 2020 00:08:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=bEbBpMHJ1dTu47WzB0edpN82n0kY4N1K0lJ9y/kPL5w=;
 b=PU8jkY99bEh5WVq4gUh03xFAglybSLwozwU4rqFbz/wzYQseGT4Ip8gqnKvlZZRkUVaG
 dGn4oh380ugwdPf1Rku2emtcgv5P1tNzsWuaSZSC2RAOsM/qzagPlwi9USO3Q8OnFjf2
 kMd9jCVgeYXE++NpAWQ/rVGpIAX31c5Ih+UvCZ/GgVxIP0uVicxS1IkoVRAK9Npqtvln
 LabRmONIXj3EoXcvIE1Mun9tBdDZkfIDUh84lcJR7oFoZzD2LG2NPN6uWFa5494pXaKM
 UYgTDTs14NA9u0v+GotbccLiFn3/XfrCs926BwYWt8a6Dz842zcnDH4DyHotCUiIAvtP CA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpctnby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:11 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:09 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:09 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0169C3F7040;
        Thu, 26 Mar 2020 00:08:09 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q7899V025532;
        Thu, 26 Mar 2020 00:08:09 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q7893u025531;
        Thu, 26 Mar 2020 00:08:09 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 1/8] qedf: Keep track of num of pending flogi.
Date:   Thu, 26 Mar 2020 00:07:59 -0700
Message-ID: <20200326070806.25493-2-skashyap@marvell.com>
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

- Problem: Port not coming up after bringing down the port
  for longer duration.
- Bring down the port from the switch
- wait for fipvlan to exhaust, driver will use
  default vlan (1002) and call fcoe_ctlr_link_up
- libfc/fcoe will start sending FLOGI
- bring back the port and switch discard FLOGI
  because vlan is different.
- keep track of pending flogi and if it increases
  certain number then do ctx reset and it will do
  fipvlan again.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  2 ++
 drivers/scsi/qedf/qedf_main.c | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index f3f399f..042ebf6 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -388,6 +388,7 @@ struct qedf_ctx {
 	mempool_t *io_mempool;
 	struct workqueue_struct *dpc_wq;
 	struct delayed_work grcdump_work;
+	struct delayed_work stag_work;
 
 	u32 slow_sge_ios;
 	u32 fast_sge_ios;
@@ -403,6 +404,7 @@ struct qedf_ctx {
 
 	u32 flogi_cnt;
 	u32 flogi_failed;
+	u32 flogi_pending;
 
 	/* Used for fc statistics */
 	struct mutex stats_mutex;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 604856e..ee468102 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -282,6 +282,7 @@ static void qedf_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 	else if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
 		/* Set the source MAC we will use for FCoE traffic */
 		qedf_set_data_src_addr(qedf, fp);
+		qedf->flogi_pending = 0;
 	}
 
 	/* Complete flogi_compl so we can proceed to sending ADISCs */
@@ -307,6 +308,11 @@ static struct fc_seq *qedf_elsct_send(struct fc_lport *lport, u32 did,
 	 */
 	if (resp == fc_lport_flogi_resp) {
 		qedf->flogi_cnt++;
+		if (qedf->flogi_pending >= QEDF_FLOGI_RETRY_CNT) {
+			schedule_delayed_work(&qedf->stag_work, 2);
+			return NULL;
+		}
+		qedf->flogi_pending++;
 		return fc_elsct_send(lport, did, fp, op, qedf_flogi_resp,
 		    arg, timeout);
 	}
@@ -850,6 +856,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 
 	qedf = lport_priv(lport);
 
+	qedf->flogi_pending = 0;
 	/* For host reset, essentially do a soft link up/down */
 	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
@@ -3205,6 +3212,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		init_completion(&qedf->fipvlan_compl);
 		mutex_init(&qedf->stats_mutex);
 		mutex_init(&qedf->flush_mutex);
+		qedf->flogi_pending = 0;
 
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_INFO,
 		   "QLogic FastLinQ FCoE Module qedf %s, "
@@ -3235,6 +3243,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
 	INIT_DELAYED_WORK(&qedf->grcdump_work, qedf_wq_grcdump);
+	INIT_DELAYED_WORK(&qedf->stag_work, qedf_stag_change_work);
 	qedf->fipvlan_retries = qedf_fipvlan_retries;
 	/* Set a default prio in case DCBX doesn't converge */
 	if (qedf_default_prio > -1) {
@@ -3770,6 +3779,20 @@ void qedf_get_protocol_tlv_data(void *dev, void *data)
 	fcoe->scsi_tsk_full = qedf->task_set_fulls;
 }
 
+/* Deferred work function to perform soft context reset on STAG change */
+void qedf_stag_change_work(struct work_struct *work)
+{
+	struct qedf_ctx *qedf =
+	    container_of(work, struct qedf_ctx, stag_work.work);
+
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
+	qedf_ctx_soft_reset(qedf->lport);
+}
+
 static void qedf_shutdown(struct pci_dev *pdev)
 {
 	__qedf_remove(pdev, QEDF_MODE_NORMAL);
-- 
1.8.3.1

