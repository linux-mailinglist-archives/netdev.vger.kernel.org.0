Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9832A9BB
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfEZMYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:24:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42694 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727811AbfEZMYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:24:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCNtBc028842;
        Sun, 26 May 2019 05:24:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Saj9HvW7dVBqLXkDmA4C3Xlvf5Hzdti5ZO7u/rd9WVQ=;
 b=PW5WCb/T8V8cOCN2aUL9cEUaemoZfeBLEPTpmHRHoOGFtLbGPyRYr9/SQZMqIm6DgGNF
 ZZn47rqLBQQfwM8pUMyhLSBlR5KJ8AinSQ6CpBjC4znu895egzTsD3+Unt80BDuxG0tq
 Ir+VFHbEZS1NSFVmcMd1u/qPsemyVH2N1YoPzU+22J5Tnepm+cdtuYLSm6uPeQYKdlo5
 ASxZQ33JXxRqFilzafla2+/Z/fk+vfRl6vVWdFfgxeJl/7iqNiQ1uAx6KQLhVW8pWV2f
 vsAtvt7xZFuCAV2ECw6r5LjW35H3VzPWQz5l9mx428QKqoqcoWb+6ihWAdC3ITQQPoXD DQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2sqm7r11yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:24:01 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:24:00 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:24:00 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id D08DA3F7040;
        Sun, 26 May 2019 05:23:57 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 05/11] qedr: Change the MSI-X vectors selection to be based on affined engine
Date:   Sun, 26 May 2019 15:22:24 +0300
Message-ID: <20190526122230.30039-6-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the msix vectors of the affined hwfn and not the
leading one.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/main.c         | 9 +++++++--
 drivers/infiniband/hw/qedr/qedr.h         | 2 ++
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index fd94100ee03a..d93c8a893a89 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -520,11 +520,13 @@ static irqreturn_t qedr_irq_handler(int irq, void *handle)
 static void qedr_sync_free_irqs(struct qedr_dev *dev)
 {
 	u32 vector;
+	u16 idx;
 	int i;
 
 	for (i = 0; i < dev->int_info.used_cnt; i++) {
 		if (dev->int_info.msix_cnt) {
-			vector = dev->int_info.msix[i * dev->num_hwfns].vector;
+			idx = i * dev->num_hwfns + dev->affin_hwfn_idx;
+			vector = dev->int_info.msix[idx].vector;
 			synchronize_irq(vector);
 			free_irq(vector, &dev->cnq_array[i]);
 		}
@@ -536,6 +538,7 @@ static void qedr_sync_free_irqs(struct qedr_dev *dev)
 static int qedr_req_msix_irqs(struct qedr_dev *dev)
 {
 	int i, rc = 0;
+	u16 idx;
 
 	if (dev->num_cnq > dev->int_info.msix_cnt) {
 		DP_ERR(dev,
@@ -545,7 +548,8 @@ static int qedr_req_msix_irqs(struct qedr_dev *dev)
 	}
 
 	for (i = 0; i < dev->num_cnq; i++) {
-		rc = request_irq(dev->int_info.msix[i * dev->num_hwfns].vector,
+		idx = i * dev->num_hwfns + dev->affin_hwfn_idx;
+		rc = request_irq(dev->int_info.msix[idx].vector,
 				 qedr_irq_handler, 0, dev->cnq_array[i].name,
 				 &dev->cnq_array[i]);
 		if (rc) {
@@ -882,6 +886,7 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
 	dev->rdma_type = dev_info.rdma_type;
 	dev->num_hwfns = dev_info.common.num_hwfns;
+	dev->affin_hwfn_idx = dev->ops->common->get_affin_hwfn_idx(cdev);
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
 	dev->num_cnq = dev->ops->rdma_get_min_cnq_msix(cdev);
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 53bbe6b4e6e6..18778694f652 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -162,6 +162,8 @@ struct qedr_dev {
 	u32			dp_module;
 	u8			dp_level;
 	u8			num_hwfns;
+#define QEDR_IS_CMT(dev)        ((dev)->num_hwfns > 1)
+	u8			affin_hwfn_idx;
 	u8			gsi_ll2_handle;
 
 	uint			wq_multiplier;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index dcff69aa8613..19a1a58d60f8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -2156,8 +2156,8 @@ static void _qed_ll2_get_pstats(struct qed_hwfn *p_hwfn,
 	p_stats->sent_bcast_pkts += HILO_64_REGPAIR(pstats.sent_bcast_pkts);
 }
 
-int __qed_ll2_get_stats(void *cxt,
-			u8 connection_handle, struct qed_ll2_stats *p_stats)
+static int __qed_ll2_get_stats(void *cxt, u8 connection_handle,
+			       struct qed_ll2_stats *p_stats)
 {
 	struct qed_hwfn *p_hwfn = cxt;
 	struct qed_ll2_info *p_ll2_conn = NULL;
-- 
2.14.5

