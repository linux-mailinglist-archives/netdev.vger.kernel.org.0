Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1AA3B76CE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhF2RC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:02:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234537AbhF2RCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:02:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TGod0Z024624;
        Tue, 29 Jun 2021 10:00:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yw8HZGC675g2dTYaotGZnn8Rsj5mrvSfQJZ9e3Tvujs=;
 b=Xp1iutJbgy9zGtGOrx4yPfUmfxG7gqiV4kTapelTuhX51HJezXVQhUcrqEWMGYl6dIHm
 xzZn/SC0XuXWDewtwgA6Ia0VeIei6G90rov/VpyP8wciT3k6Dn9nG1I9ktVFY+17L4Rp
 +7S7lHwDzIToe1MBtlR+RoXhLmaAEnZr1NAKMH0QHt3JOjj2CYsiq63le1+MV+TdgNFL
 lvo17QcdankEbd4+R15lGOOGLv/eU6kuY16b8McZgbE8WtslrmvuJ7JRaw+WSXipxMf/
 R1mdSSQw7eaDPNwf6+K5Gh+KxS0NgZddYjYQXuvZrBT+pq8/17Z7Iw2Gnc2TptyqIP7R Fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39fuw5316f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 10:00:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 10:00:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 10:00:21 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9C5CB5B6926;
        Tue, 29 Jun 2021 10:00:18 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <sgoutham@marvell.com>,
        <hkalra@marvell.com>
Subject: [net-next PATCH 3/3] octeontx2-pf: cn10k: Use runtime allocated LMTLINE region
Date:   Tue, 29 Jun 2021 22:30:06 +0530
Message-ID: <20210629170006.722-4-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210629170006.722-1-gakula@marvell.com>
References: <20210629170006.722-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2rJZudBhzCbfl6c4V9vCz6QwA2flPOkG
X-Proofpoint-GUID: 2rJZudBhzCbfl6c4V9vCz6QwA2flPOkG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current driver uses static LMTST region allocated by firmware.
This memory gets populated as PF/VF BAR2. RVU PF/VF driver ioremap
the memory as device memory for NIX/NPA operation. Since the memory
is mapped as device memory we see performance degration. To address
this issue this patch implements runtime memory allocation.
RVU PF/VF allocates memory during device probe and share the base
address with RVU AF. RVU AF then configure the LMT MAP table
accordingly.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k.c    | 87 ++++++++-----------
 .../ethernet/marvell/octeontx2/nic/cn10k.h    |  3 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  7 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 17 ++--
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 12 ++-
 6 files changed, 54 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 1b08896b46d2..184de9466286 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -22,69 +22,52 @@ static struct dev_hw_ops cn10k_hw_ops = {
 	.refill_pool_ptrs = cn10k_refill_pool_ptrs,
 };
 
-int cn10k_pf_lmtst_init(struct otx2_nic *pf)
+int cn10k_lmtst_init(struct otx2_nic *pfvf)
 {
-	int size, num_lines;
-	u64 base;
 
-	if (!test_bit(CN10K_LMTST, &pf->hw.cap_flag)) {
-		pf->hw_ops = &otx2_hw_ops;
+	struct lmtst_tbl_setup_req *req;
+	int qcount, err;
+
+	if (!test_bit(CN10K_LMTST, &pfvf->hw.cap_flag)) {
+		pfvf->hw_ops = &otx2_hw_ops;
 		return 0;
 	}
 
-	pf->hw_ops = &cn10k_hw_ops;
-	base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
-		       (MBOX_SIZE * (pf->total_vfs + 1));
-
-	size = pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM) -
-	       (MBOX_SIZE * (pf->total_vfs + 1));
-
-	pf->hw.lmt_base = ioremap(base, size);
+	pfvf->hw_ops = &cn10k_hw_ops;
+	qcount = pfvf->hw.max_queues;
+	/* LMTST lines allocation
+	 * qcount = num_online_cpus();
+	 * NPA = TX + RX + XDP.
+	 * NIX = TX * 32 (For Burst SQE flush).
+	 */
+	pfvf->tot_lmt_lines = (qcount * 3) + (qcount * 32);
+	pfvf->npa_lmt_lines = qcount * 3;
+	pfvf->nix_lmt_size =  LMT_BURST_SIZE * LMT_LINE_SIZE;
 
-	if (!pf->hw.lmt_base) {
-		dev_err(pf->dev, "Unable to map PF LMTST region\n");
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_lmtst_tbl_setup(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
 		return -ENOMEM;
 	}
 
-	/* FIXME: Get the num of LMTST lines from LMT table */
-	pf->tot_lmt_lines = size / LMT_LINE_SIZE;
-	num_lines = (pf->tot_lmt_lines - NIX_LMTID_BASE) /
-			    pf->hw.tx_queues;
-	/* Number of LMT lines per SQ queues */
-	pf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
-
-	pf->nix_lmt_size = pf->nix_lmt_lines * LMT_LINE_SIZE;
-	return 0;
-}
+	req->use_local_lmt_region = true;
 
-int cn10k_vf_lmtst_init(struct otx2_nic *vf)
-{
-	int size, num_lines;
-
-	if (!test_bit(CN10K_LMTST, &vf->hw.cap_flag)) {
-		vf->hw_ops = &otx2_hw_ops;
-		return 0;
+	err = qmem_alloc(pfvf->dev, &pfvf->dync_lmt, pfvf->tot_lmt_lines,
+			 LMT_LINE_SIZE);
+	if (err) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return err;
 	}
+	pfvf->hw.lmt_base = (u64 *)pfvf->dync_lmt->base;
+	req->lmt_iova = (u64)pfvf->dync_lmt->iova;
 
-	vf->hw_ops = &cn10k_hw_ops;
-	size = pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM);
-	vf->hw.lmt_base = ioremap_wc(pci_resource_start(vf->pdev,
-							PCI_MBOX_BAR_NUM),
-				     size);
-	if (!vf->hw.lmt_base) {
-		dev_err(vf->dev, "Unable to map VF LMTST region\n");
-		return -ENOMEM;
-	}
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
 
-	vf->tot_lmt_lines = size / LMT_LINE_SIZE;
-	/* LMTST lines per SQ */
-	num_lines = (vf->tot_lmt_lines - NIX_LMTID_BASE) /
-			    vf->hw.tx_queues;
-	vf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
-	vf->nix_lmt_size = vf->nix_lmt_lines * LMT_LINE_SIZE;
 	return 0;
 }
-EXPORT_SYMBOL(cn10k_vf_lmtst_init);
+EXPORT_SYMBOL(cn10k_lmtst_init);
 
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 {
@@ -93,9 +76,11 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	struct otx2_snd_queue *sq;
 
 	sq = &pfvf->qset.sq[qidx];
-	sq->lmt_addr = (__force u64 *)((u64)pfvf->hw.nix_lmt_base +
+	sq->lmt_addr = (u64 *)((u64)pfvf->hw.nix_lmt_base +
 			       (qidx * pfvf->nix_lmt_size));
 
+	sq->lmt_id = pfvf->npa_lmt_lines + (qidx * LMT_BURST_SIZE);
+
 	/* Get memory to put this msg */
 	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
 	if (!aq)
@@ -158,15 +143,13 @@ void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq)
 
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx)
 {
-	struct otx2_nic *pfvf = dev;
-	int lmt_id = NIX_LMTID_BASE + (qidx * pfvf->nix_lmt_lines);
 	u64 val = 0, tar_addr = 0;
 
 	/* FIXME: val[0:10] LMT_ID.
 	 * [12:15] no of LMTST - 1 in the burst.
 	 * [19:63] data size of each LMTST in the burst except first.
 	 */
-	val = (lmt_id & 0x7FF);
+	val = (sq->lmt_id & 0x7FF);
 	/* Target address for LMTST flush tells HW how many 128bit
 	 * words are present.
 	 * tar_addr[6:4] size of first LMTST - 1 in units of 128b.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
index 71292a4cf1f3..1a1ae334477d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -12,8 +12,7 @@
 void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
-int cn10k_pf_lmtst_init(struct otx2_nic *pf);
-int cn10k_vf_lmtst_init(struct otx2_nic *vf);
+int cn10k_lmtst_init(struct otx2_nic *pfvf);
 int cn10k_free_all_ipolicers(struct otx2_nic *pfvf);
 int cn10k_alloc_matchall_ipolicer(struct otx2_nic *pfvf);
 int cn10k_free_matchall_ipolicer(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 234b330f3183..20a9c69f020f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -218,8 +218,8 @@ struct otx2_hw {
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
-#define NIX_LMTID_BASE		72 /* RX + TX + XDP */
-	void __iomem		*lmt_base;
+#define LMT_BURST_SIZE		32 /* 32 LMTST lines for burst SQE flush */
+	u64			*lmt_base;
 	u64			*npa_lmt_base;
 	u64			*nix_lmt_base;
 };
@@ -363,8 +363,9 @@ struct otx2_nic {
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
 	/* LMTST Lines info */
+	struct qmem		*dync_lmt;
 	u16			tot_lmt_lines;
-	u16			nix_lmt_lines;
+	u16			npa_lmt_lines;
 	u32			nix_lmt_size;
 
 	struct otx2_ptp		*ptp;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 59912f73417b..088c28df849d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1533,10 +1533,10 @@ int otx2_open(struct net_device *netdev)
 
 	if (test_bit(CN10K_LMTST, &pf->hw.cap_flag)) {
 		/* Reserve LMT lines for NPA AURA batch free */
-		pf->hw.npa_lmt_base = (__force u64 *)pf->hw.lmt_base;
+		pf->hw.npa_lmt_base = pf->hw.lmt_base;
 		/* Reserve LMT lines for NIX TX */
-		pf->hw.nix_lmt_base = (__force u64 *)((u64)pf->hw.npa_lmt_base +
-				      (NIX_LMTID_BASE * LMT_LINE_SIZE));
+		pf->hw.nix_lmt_base = (u64 *)((u64)pf->hw.npa_lmt_base +
+				      (pf->npa_lmt_lines * LMT_LINE_SIZE));
 	}
 
 	err = otx2_init_hw_resources(pf);
@@ -2526,7 +2526,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	err = cn10k_pf_lmtst_init(pf);
+	err = cn10k_lmtst_init(pf);
 	if (err)
 		goto err_detach_rsrc;
 
@@ -2630,8 +2630,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_ptp_destroy:
 	otx2_ptp_destroy(pf);
 err_detach_rsrc:
-	if (hw->lmt_base)
-		iounmap(hw->lmt_base);
+	if (test_bit(CN10K_LMTST, &pf->hw.cap_flag))
+		qmem_free(pf->dev, pf->dync_lmt);
 	otx2_detach_resources(&pf->mbox);
 err_disable_mbox_intr:
 	otx2_disable_mbox_intr(pf);
@@ -2772,9 +2772,8 @@ static void otx2_remove(struct pci_dev *pdev)
 	otx2_mcam_flow_del(pf);
 	otx2_shutdown_tc(pf);
 	otx2_detach_resources(&pf->mbox);
-	if (pf->hw.lmt_base)
-		iounmap(pf->hw.lmt_base);
-
+	if (test_bit(CN10K_LMTST, &pf->hw.cap_flag))
+		qmem_free(pf->dev, pf->dync_lmt);
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
 	pci_free_irq_vectors(pf->pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 52486c1f0973..2f144e2cf436 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -83,6 +83,7 @@ struct otx2_snd_queue {
 	u16			num_sqbs;
 	u16			sqe_thresh;
 	u8			sqe_per_sqb;
+	u32			lmt_id;
 	u64			 io_addr;
 	u64			*aura_fc_addr;
 	u64			*lmt_addr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 13a908f75ba0..a8bee5aefec1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -609,7 +609,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	err = cn10k_vf_lmtst_init(vf);
+	err = cn10k_lmtst_init(vf);
 	if (err)
 		goto err_detach_rsrc;
 
@@ -667,8 +667,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_unreg_netdev:
 	unregister_netdev(netdev);
 err_detach_rsrc:
-	if (hw->lmt_base)
-		iounmap(hw->lmt_base);
+	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
+		qmem_free(vf->dev, vf->dync_lmt);
 	otx2_detach_resources(&vf->mbox);
 err_disable_mbox_intr:
 	otx2vf_disable_mbox_intr(vf);
@@ -700,10 +700,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
 		destroy_workqueue(vf->otx2_wq);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
-
-	if (vf->hw.lmt_base)
-		iounmap(vf->hw.lmt_base);
-
+	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
+		qmem_free(vf->dev, vf->dync_lmt);
 	otx2vf_vfaf_mbox_destroy(vf);
 	pci_free_irq_vectors(vf->pdev);
 	pci_set_drvdata(pdev, NULL);
-- 
2.17.1

