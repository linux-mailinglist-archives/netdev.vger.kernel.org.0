Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84E1ABC26
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503071AbgDPJGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:06:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16108 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502721AbgDPIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8eWY9013932;
        Thu, 16 Apr 2020 01:43:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=htcZ1UOImIzyq3lsTp1CZDOryypRUSuVGFxKLD0B5sI=;
 b=Yub+8XYNyROiRWUTW10/ptXyy9VrEFPzlZC7odjuZanVl4fqqvAC6fUiU4ovksgXfU6J
 Nz+L+H9wyqet3JBNbkL+cY9hhBnyxG1Nahosb5yAuf9Qv8sulFhbilUTlzXwTMQOCOtx
 vKZKwMW54dda6KS6d/+4rP7e4QlhUA5cUYTTPXm0MIBJCHV0an/tHbvPxtXQst1dnyPy
 pLYzlodSgwcdo7+kC89p1qWrhNYgEpImEYgTtoX17a/9u91K0OrdRWZ3JgvLb4VwSZpd
 flCz3/VHYs54fr06pD4sBxFBgGk6o+wkAcksaXqcAICr227hjB+5vWEHYDmGfnJvREeW yg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30dn8gp588-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8EABE3F7040;
        Thu, 16 Apr 2020 01:43:17 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hHcd018890;
        Thu, 16 Apr 2020 01:43:17 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hHS5018889;
        Thu, 16 Apr 2020 01:43:17 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 1/9] qedf: Keep track of num of pending flogi.
Date:   Thu, 16 Apr 2020 01:43:06 -0700
Message-ID: <20200416084314.18851-2-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200416084314.18851-1-skashyap@marvell.com>
References: <20200416084314.18851-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_03:2020-04-14,2020-04-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a port is brought down for an extended period of time, the
fipvlan counter gets exhausted and the driver will fall back to
default VLAN 1002 and call fcoe_ctlr_link_up to log in. However, the
switch will discard the FLOGI attempt because the VLAN is now
different.

Keep track of the number of FLOGI attempts and if a threshold of
QEDF_FLOGI_RETRY_CNT is exceeded, perform a context soft reset.

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

