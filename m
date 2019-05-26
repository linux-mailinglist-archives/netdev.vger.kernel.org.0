Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7552A9B3
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfEZMYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40666 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727878AbfEZMYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCLfmF001354;
        Sun, 26 May 2019 05:24:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pylv6Q36P3r0O02Sqp69GavYjwWOkjrv81IEC/g5TAE=;
 b=BkEZwWCbjfSZI1b0bFq7PzhyNmOMFO/HiSfABNMUDsnzG/hBcHzBAL4/gTW+RpBSblLX
 fkofxKV2Ab2pAg4HkIDhmQzeQvuKaVyXR3/nKBowt7+CwVRHlayZFAXpGXR4j43UTVMJ
 1MFfH56ctxnwOMM6jiSC00mNoMlNUe5oz7NvPdxX+7jlNCLidbqgTJStFW26WsRY+Ub7
 qzUHky17p9yVi3qrbwcd4l7/EOsWJEubS1nNPTecrXul/MMZoiNlBFOuz4NkC/JTF7/D
 IoNP1yvihcsMZ6Ww7WGtM0hhLADF+1SMRKfEB8XbJTaqK8dysxBMup0YyjIxfL+cbubE yw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:14 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:13 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:13 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id E7A313F703F;
        Sun, 26 May 2019 05:24:10 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH v2 net-next 10/11] qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index
Date:   Sun, 26 May 2019 15:22:29 +0300
Message-ID: <20190526122230.30039-11-michal.kalderon@marvell.com>
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

From: Manish Rangankar <mrangankar@marvell.com>

MSI-X vector index is determined using qed device information and
affinity to use.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f07e0814a657..1a62ab0867ef 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1313,13 +1313,20 @@ static void qedi_simd_int_handler(void *cookie)
 static void qedi_sync_free_irqs(struct qedi_ctx *qedi)
 {
 	int i;
+	u16 idx;
 
 	if (qedi->int_info.msix_cnt) {
 		for (i = 0; i < qedi->int_info.used_cnt; i++) {
-			synchronize_irq(qedi->int_info.msix[i].vector);
-			irq_set_affinity_hint(qedi->int_info.msix[i].vector,
+			idx = i * qedi->dev_info.common.num_hwfns +
+			qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
+
+			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+				  "Freeing IRQ #%d vector_idx=%d.\n", i, idx);
+
+			synchronize_irq(qedi->int_info.msix[idx].vector);
+			irq_set_affinity_hint(qedi->int_info.msix[idx].vector,
 					      NULL);
-			free_irq(qedi->int_info.msix[i].vector,
+			free_irq(qedi->int_info.msix[idx].vector,
 				 &qedi->fp_array[i]);
 		}
 	} else {
@@ -1334,20 +1341,28 @@ static void qedi_sync_free_irqs(struct qedi_ctx *qedi)
 static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 {
 	int i, rc, cpu;
+	u16 idx;
 
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {
-		rc = request_irq(qedi->int_info.msix[i].vector,
+		idx = i * qedi->dev_info.common.num_hwfns +
+			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev);
+
+		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+			  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+			  qedi->dev_info.common.num_hwfns,
+			  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev));
+
+		rc = request_irq(qedi->int_info.msix[idx].vector,
 				 qedi_msix_handler, 0, "qedi",
 				 &qedi->fp_array[i]);
-
 		if (rc) {
 			QEDI_WARN(&qedi->dbg_ctx, "request_irq failed.\n");
 			qedi_sync_free_irqs(qedi);
 			return rc;
 		}
 		qedi->int_info.used_cnt++;
-		rc = irq_set_affinity_hint(qedi->int_info.msix[i].vector,
+		rc = irq_set_affinity_hint(qedi->int_info.msix[idx].vector,
 					   get_cpu_mask(cpu));
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
@@ -2415,6 +2430,11 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	if (rc)
 		goto free_host;
 
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+		  "dev_info: num_hwfns=%d affin_hwfn_idx=%d.\n",
+		  qedi->dev_info.common.num_hwfns,
+		  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev));
+
 	if (mode != QEDI_MODE_RECOVERY) {
 		rc = qedi_set_iscsi_pf_param(qedi);
 		if (rc) {
-- 
2.14.5

