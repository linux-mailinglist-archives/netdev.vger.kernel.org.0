Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1779019D66A
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403883AbgDCMKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 08:10:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18252 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728149AbgDCMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 08:10:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033C1WnJ020012;
        Fri, 3 Apr 2020 05:10:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nHVnZAkGjwhXrL8d4bc64Ctkm8kDGblmwH/Pb8ZFUk4=;
 b=lI07sJUsPKe7PfX6bVlwPBkRBvsl2SEuBjXH713pMKPiSmRZB0pZyjjlbax+cvatK7bv
 vjQvB+xN9WxigsFfWnebW/7WfxpWXzlFKGXZVmXzsCItlXZSz3AZzwgLq5HpBDbFnAs1
 /k1za+ieVLwl8lfcNkPlECnivROMealLzsvVxZz5cXZrBcG8QGmIVMf7dUU2u1UROZWA
 EQyDc2za4y+Cduttx6X2OfZo10es80EFj09sQc+iiItgOW7iJrbdFHD6cJ+B/u4zKFLg
 ag+tS5Qbjj1EyVedWlIhFuWSvyOdcCrjSkaFi68OjS/942Flf7l6u0qDkbSpoiLAUPp3 8Q== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h66sx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Apr 2020 05:10:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 05:10:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 05:10:04 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2F9413F7040;
        Fri,  3 Apr 2020 05:10:04 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 033CA4Zx002554;
        Fri, 3 Apr 2020 05:10:04 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 033CA4WK002473;
        Fri, 3 Apr 2020 05:10:04 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 2/7] qedf: Fix for the deviations from the SAM-4 spec.
Date:   Fri, 3 Apr 2020 05:09:52 -0700
Message-ID: <20200403120957.2431-3-skashyap@marvell.com>
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

From: Javed Hasan <jhasan@marvell.com>

- Upper limit for retry delay(QEDF_RETRY_DELAY_MAX)
  increased from 20 sec to 1 min.
- Log an event/message indicating throttling of I/O
  for the target and include scope and retry delay
  time returned by the target and the driver enforced delay.
- Synchronizing the update of the fcport->retry_delay_timestamp
  between qedf_queuecommand() and qedf_scsi_completion().

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf.h    |  2 +-
 drivers/scsi/qedf/qedf_io.c | 47 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 042ebf6..aaa2ac9 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -470,7 +470,7 @@ static inline void qedf_stop_all_io(struct qedf_ctx *qedf)
 extern uint qedf_io_tracing;
 extern uint qedf_stop_io_on_error;
 extern uint qedf_link_down_tmo;
-#define QEDF_RETRY_DELAY_MAX		20 /* 2 seconds */
+#define QEDF_RETRY_DELAY_MAX		600 /* 60 seconds */
 extern bool qedf_retry_delay;
 extern uint qedf_debug;
 
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index e749a2d..f0f455e 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1021,14 +1021,18 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 	atomic_inc(&fcport->ios_to_queue);
 
 	if (fcport->retry_delay_timestamp) {
+		/* Take fcport->rport_lock for resetting the delay_timestamp */
+		spin_lock_irqsave(&fcport->rport_lock, flags);
 		if (time_after(jiffies, fcport->retry_delay_timestamp)) {
 			fcport->retry_delay_timestamp = 0;
 		} else {
+			spin_unlock_irqrestore(&fcport->rport_lock, flags);
 			/* If retry_delay timer is active, flow off the ML */
 			rc = SCSI_MLQUEUE_TARGET_BUSY;
 			atomic_dec(&fcport->ios_to_queue);
 			goto exit_qcmd;
 		}
+		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 	}
 
 	io_req = qedf_alloc_cmd(fcport, QEDF_SCSI_CMD);
@@ -1134,6 +1138,8 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	int refcount;
 	u16 scope, qualifier = 0;
 	u8 fw_residual_flag = 0;
+	unsigned long flags = 0;
+	u16 chk_scope = 0;
 
 	if (!io_req)
 		return;
@@ -1267,16 +1273,8 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 				/* Lower 14 bits */
 				qualifier = fcp_rsp->retry_delay_timer & 0x3FFF;
 
-				if (qedf_retry_delay &&
-				    scope > 0 && qualifier > 0 &&
-				    qualifier <= 0x3FEF) {
-					/* Check we don't go over the max */
-					if (qualifier > QEDF_RETRY_DELAY_MAX)
-						qualifier =
-						    QEDF_RETRY_DELAY_MAX;
-					fcport->retry_delay_timestamp =
-					    jiffies + (qualifier * HZ / 10);
-				}
+				if (qedf_retry_delay)
+					chk_scope = 1;
 				/* Record stats */
 				if (io_req->cdb_status ==
 				    SAM_STAT_TASK_SET_FULL)
@@ -1287,6 +1285,35 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
+
+		if (chk_scope == 1)
+			if ((scope == 1 || scope == 2) &&
+			    (qualifier > 0 && qualifier <= 0x3FEF)) {
+				/* Check we don't go over the max */
+				if (qualifier > QEDF_RETRY_DELAY_MAX) {
+					qualifier = QEDF_RETRY_DELAY_MAX;
+					QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+						  "qualifier = %d\n",
+						  (fcp_rsp->retry_delay_timer &
+						  0x3FFF));
+				}
+				QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+					  "Scope = %d and qualifier = %d",
+					  scope, qualifier);
+				/*  Take fcport->rport_lock to
+				 *  update the retry_delay_timestamp
+				 */
+				spin_lock_irqsave(&fcport->rport_lock, flags);
+				fcport->retry_delay_timestamp =
+					jiffies + (qualifier * HZ / 10);
+				spin_unlock_irqrestore(&fcport->rport_lock,
+						       flags);
+
+			} else {
+				QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
+					  "combination of scope = %d and qualifier = %d is not handled in qedf.\n",
+					  scope, qualifier);
+			}
 		break;
 	default:
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "fcp_status=%d.\n",
-- 
1.8.3.1

