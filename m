Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086C42A9B6
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfEZMYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40678 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727883AbfEZMYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCL9dD001198;
        Sun, 26 May 2019 05:24:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LyPqu8EHKJ51sX8YQ1q+jd1z8LLEAjPdntn9bqYx9hI=;
 b=H4HNCSydALyFJRIJh1beekbz5TS2ClWNF36c1KHuWft8TJjrTPFY9Ozm4UEKq9Lg0INw
 nq7Vv4V5KhEBnwElT25nEJRszYLd0O8lVsMh5U3EVy2grch17KfRy/3HjN9mCbIW4pxO
 vWt+w/hA4C7pPqp1uXtO0GwT7oZ5RV372CBJ3dHDCy7mT32lDnMLT3b7n7pXvFgDcPuM
 2Vh/OIEUaiYO8g2ko9yCcGEhH/U6S5E2Z3I8f93jAX4EaozjWe26nzVwYVbsC+vCRp/l
 rwQUKXX8imw6ZEhecePtz1oaXw1LFM7+41UPUb4kXYKpPTWl7FBLnyAMuNHRCN8v+s+1 Hw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:17 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:16 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:16 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id AFF893F7040;
        Sun, 26 May 2019 05:24:13 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Chad Dupuis <cdupuis@marvell.com>,
        "Saurav Kashyap" <skashyap@marvell.com>
Subject: [PATCH v2 net-next 11/11] qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use
Date:   Sun, 26 May 2019 15:22:30 +0300
Message-ID: <20190526122230.30039-12-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chad Dupuis <cdupuis@marvell.com>

MSI-X vector index is determined using qed device information and
affinity to use.

Signed-off-by: Chad Dupuis <cdupuis@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9f9431a4cc0e..dc4cad1d5dcc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2086,16 +2086,21 @@ static void qedf_simd_int_handler(void *cookie)
 static void qedf_sync_free_irqs(struct qedf_ctx *qedf)
 {
 	int i;
+	u16 vector_idx = 0;
+	u32 vector;
 
 	if (qedf->int_info.msix_cnt) {
 		for (i = 0; i < qedf->int_info.used_cnt; i++) {
-			synchronize_irq(qedf->int_info.msix[i].vector);
-			irq_set_affinity_hint(qedf->int_info.msix[i].vector,
-			    NULL);
-			irq_set_affinity_notifier(qedf->int_info.msix[i].vector,
-			    NULL);
-			free_irq(qedf->int_info.msix[i].vector,
-			    &qedf->fp_array[i]);
+			vector_idx = i * qedf->dev_info.common.num_hwfns +
+				qed_ops->common->get_affin_hwfn_idx(qedf->cdev);
+			QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+				  "Freeing IRQ #%d vector_idx=%d.\n",
+				  i, vector_idx);
+			vector = qedf->int_info.msix[vector_idx].vector;
+			synchronize_irq(vector);
+			irq_set_affinity_hint(vector, NULL);
+			irq_set_affinity_notifier(vector, NULL);
+			free_irq(vector, &qedf->fp_array[i]);
 		}
 	} else
 		qed_ops->common->simd_handler_clean(qedf->cdev,
@@ -2108,11 +2113,19 @@ static void qedf_sync_free_irqs(struct qedf_ctx *qedf)
 static int qedf_request_msix_irq(struct qedf_ctx *qedf)
 {
 	int i, rc, cpu;
+	u16 vector_idx = 0;
+	u32 vector;
 
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < qedf->num_queues; i++) {
-		rc = request_irq(qedf->int_info.msix[i].vector,
-		    qedf_msix_handler, 0, "qedf", &qedf->fp_array[i]);
+		vector_idx = i * qedf->dev_info.common.num_hwfns +
+			qed_ops->common->get_affin_hwfn_idx(qedf->cdev);
+		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+			  "Requesting IRQ #%d vector_idx=%d.\n",
+			  i, vector_idx);
+		vector = qedf->int_info.msix[vector_idx].vector;
+		rc = request_irq(vector, qedf_msix_handler, 0, "qedf",
+				 &qedf->fp_array[i]);
 
 		if (rc) {
 			QEDF_WARN(&(qedf->dbg_ctx), "request_irq failed.\n");
@@ -2121,8 +2134,7 @@ static int qedf_request_msix_irq(struct qedf_ctx *qedf)
 		}
 
 		qedf->int_info.used_cnt++;
-		rc = irq_set_affinity_hint(qedf->int_info.msix[i].vector,
-		    get_cpu_mask(cpu));
+		rc = irq_set_affinity_hint(vector, get_cpu_mask(cpu));
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 
@@ -3068,6 +3080,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		goto err1;
 	}
 
+	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
+		  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+		  qedf->dev_info.common.num_hwfns,
+		  qed_ops->common->get_affin_hwfn_idx(qedf->cdev));
+
 	/* queue allocation code should come here
 	 * order should be
 	 * 	slowpath_start
-- 
2.14.5

