Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284CF106BA
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfEAJ64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbfEAJ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419tf5l014716;
        Wed, 1 May 2019 02:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=pylv6Q36P3r0O02Sqp69GavYjwWOkjrv81IEC/g5TAE=;
 b=cmaJk6rJKAf/aOQj6+ijS/2dh6V77ap8c7GgbDIGFCTNIbNZGSl0xUxlT1+7l24WdJ6y
 L6ZpNkh50AFjfKPcAfIBX58IhfOPuTYHZzm/NkWqNtoHh/qxhavLghtnBq+B/hFzqa5O
 /dyXJYh0zS6xGdPIJm+kG50eBbqJDmJbqxAYYCqOmzjJs23pH53N3P5XrPHsjMH5egwS
 pdOJ8nS+CfNV6s0Iy2wXWHafX2Ax0+zGUk0l6ppaGIq0mT0qQvKt71yAvBBFOHYRiobG
 mM8QwUM1JPNWNDTvIeN7LjGMa4yHL10WuB4yXcbacEpq4VXwQIuswFkFjhem03NyH7dp aQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s6xgchwbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:52 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:51 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:51 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id C43BB3F7043;
        Wed,  1 May 2019 02:58:48 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH net-next 09/10] qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index
Date:   Wed, 1 May 2019 12:57:21 +0300
Message-ID: <20190501095722.6902-10-michal.kalderon@marvell.com>
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

