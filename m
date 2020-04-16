Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B501ABC44
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503490AbgDPJKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:10:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502519AbgDPIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8e7mW020358;
        Thu, 16 Apr 2020 01:43:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MEgF6h97D59/JP6Sru30e3+Sb6rlVFxWUEs1gmDxoH0=;
 b=bD+UBbhLSLHCy332P8iM2B71NxlCl7iNxg3qWWWoR/l43SfdXsUNfRdXeYPHcAsuEaOl
 jNXpqyrJa4rh5TdeqkfaYVY7v9EcUgj7ysk+wiQKLXmzwjDiAymlkv1IVG5MKsMiyLLi
 UuAZGJyPnEbIvfXUE7giNOlDbwxnT3Jw30/GWst9treHpZKueBrZgAIOcMauo2Zxmjeu
 U5abos/mY13B1/N7hkyap6mGhkHYQb6Svs6wFKaGDoTiWb955nuw6byTNSajf0GZWKxs
 4Q12LbHyWvVLyA0WDstJjYVArG5L9ZZSgap5UyGY7ItF1c+HG2QQXFsdKPEjzsJaEaE+ ew== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 283533F703F;
        Thu, 16 Apr 2020 01:43:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hRBm018902;
        Thu, 16 Apr 2020 01:43:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hQJr018901;
        Thu, 16 Apr 2020 01:43:26 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 4/9] qedf: Honor status qualifier in FCP_RSP per spec.
Date:   Thu, 16 Apr 2020 01:43:09 -0700
Message-ID: <20200416084314.18851-5-skashyap@marvell.com>
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

From: Javed Hasan <jhasan@marvell.com>

Handle scope and qualifier on SAM_STAT_TASK_SET_FULL
or SAM_STAT_BUSY

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 64c1769..f0f455e 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1138,6 +1138,8 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	int refcount;
 	u16 scope, qualifier = 0;
 	u8 fw_residual_flag = 0;
+	unsigned long flags = 0;
+	u16 chk_scope = 0;
 
 	if (!io_req)
 		return;
@@ -1271,16 +1273,8 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
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
@@ -1291,6 +1285,35 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
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

