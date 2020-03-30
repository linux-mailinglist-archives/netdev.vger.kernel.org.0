Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D0197490
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgC3Ga7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:30:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728991AbgC3Ga6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:30:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6UPMZ015736;
        Sun, 29 Mar 2020 23:30:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pTZ5Hl51Ej6SUhKKJ3OLZ3SyT4RBg306Yfvbv6Nps+A=;
 b=UqcxOvi6Bn8VzKThRLR3Tx88bpEx1YrSTCuvCPp40ls0IDUhG0rNdyHNmUd18JhchcOd
 08wGFT97Vow9Pj5oTNUJ+hbJ3GpjhO2pxLl6aBHPvzlii0p85zV+7iaidRSnhqjjHVbz
 BegXTnGtEJ8FGJ90zUoh7hF1ahLa3dVA2qFp5G8ELk/ZL+Y3Z6OZorbdhQ8/9T4CYx3I
 ZLMF0eaYieB/AO/ETH6J7JSUDjlA27gBF0mH57eUzd3irfp3ioekFFa0PLVYUdntsDuL
 DTkonVXWAKs1rM7r061JL7JCSbSym8Q0JeWUNEU43jywHdj1DTqLsLzyWe0yBGCDlmix 0Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30263kd1m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:55 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:54 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1BA713F7044;
        Sun, 29 Mar 2020 23:30:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6UrPo027368;
        Sun, 29 Mar 2020 23:30:53 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UrT5027367;
        Sun, 29 Mar 2020 23:30:53 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 6/8] qedf: Fix crash when MFW calls for protocol stats while function is still probing.
Date:   Sun, 29 Mar 2020 23:30:32 -0700
Message-ID: <20200330063034.27309-7-skashyap@marvell.com>
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

The MFW may make an call to qed and then to qedf for protocol statistics
while the function is still probing.  If this happens it's possible that
some members of the struct qedf_ctx may not be fully initialized which can
result in a NULL pointer dereference or general protection fault.

To prevent this, add a new flag call QEDF_PROBING and set it when the
__qedf_probe() function is active. Then in the qedf_get_protocol_tlv_data()
function we can check if the function is still probing and return
immediantely before any uninitialized structures can be touched.

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index f8a98e5..e163be8 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -355,6 +355,7 @@ struct qedf_ctx {
 #define QEDF_GRCDUMP_CAPTURE		4
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
+#define QEDF_PROBING			8
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 39a66e4..52673b4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3198,7 +3198,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 {
 	int rc = -EINVAL;
 	struct fc_lport *lport;
-	struct qedf_ctx *qedf;
+	struct qedf_ctx *qedf = NULL;
 	struct Scsi_Host *host;
 	bool is_vf = false;
 	struct qed_ll2_params params;
@@ -3228,6 +3228,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 		/* Initialize qedf_ctx */
 		qedf = lport_priv(lport);
+		set_bit(QEDF_PROBING, &qedf->flags);
 		qedf->lport = lport;
 		qedf->ctlr.lp = lport;
 		qedf->pdev = pdev;
@@ -3252,9 +3253,12 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	} else {
 		/* Init pointers during recovery */
 		qedf = pci_get_drvdata(pdev);
+		set_bit(QEDF_PROBING, &qedf->flags);
 		lport = qedf->lport;
 	}
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe started.\n");
+
 	host = lport->host;
 
 	/* Allocate mempool for qedf_io_work structs */
@@ -3561,6 +3565,10 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	else
 		fc_fabric_login(lport);
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
+
+	clear_bit(QEDF_PROBING, &qedf->flags);
+
 	/* All good */
 	return 0;
 
@@ -3586,6 +3594,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 err1:
 	scsi_host_put(lport->host);
 err0:
+	if (qedf) {
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
+
+		clear_bit(QEDF_PROBING, &qedf->flags);
+	}
 	return rc;
 }
 
@@ -3735,11 +3748,25 @@ void qedf_get_protocol_tlv_data(void *dev, void *data)
 {
 	struct qedf_ctx *qedf = dev;
 	struct qed_mfw_tlv_fcoe *fcoe = data;
-	struct fc_lport *lport = qedf->lport;
-	struct Scsi_Host *host = lport->host;
-	struct fc_host_attrs *fc_host = shost_to_fc_host(host);
+	struct fc_lport *lport;
+	struct Scsi_Host *host;
+	struct fc_host_attrs *fc_host;
 	struct fc_host_statistics *hst;
 
+	if (!qedf) {
+		QEDF_ERR(NULL, "qedf is null.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_PROBING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Function is still probing.\n");
+		return;
+	}
+
+	lport = qedf->lport;
+	host = lport->host;
+	fc_host = shost_to_fc_host(host);
+
 	/* Force a refresh of the fc_host stats including offload stats */
 	hst = qedf_fc_get_host_stats(host);
 
-- 
1.8.3.1

