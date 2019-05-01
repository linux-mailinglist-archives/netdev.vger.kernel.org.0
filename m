Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23236106BC
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfEAJ67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726478AbfEAJ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419tYj3026237;
        Wed, 1 May 2019 02:58:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=LyPqu8EHKJ51sX8YQ1q+jd1z8LLEAjPdntn9bqYx9hI=;
 b=IHsd0EoyRaJl5eGCWFQ2io5q2rHVxZn4iiDgoebzsWoMGNJYrVeV/iRk4BMz2nuc4uD1
 O92kPZ7+EqsR4lqv14gQ/4QLZX3Hv1xSsagvqtqRxejqflFbO0vhqIXwSw/ovDKqRgEX
 ayVNv1wOt3QN17kY6Nfeaec5e1Cu9HjLWqBQdxW9rUFY9uKa1l3eANERMp5RZ0+z8i3T
 vT1doav57R6e8rHtR8WeZFuGA2gvvcva1U43uLYL9cG8sE2TlHWLSuYGo3wfDusf8H9c
 lk4LP9UBrCWbTB0ipt6oD6c+do1nma88+FuTG+AXOG06up6TPiyy3VqA1GkrJr66beW9 1A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2s6xj61wqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:54 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:53 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:53 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 56D853F7041;
        Wed,  1 May 2019 02:58:51 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Chad Dupuis <cdupuis@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH net-next 10/10] qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use
Date:   Wed, 1 May 2019 12:57:22 +0300
Message-ID: <20190501095722.6902-11-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501095722.6902-1-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
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

