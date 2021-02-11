Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92231833F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 02:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBKBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 20:50:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64390 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhBKBsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 20:48:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B1kgKt000423;
        Wed, 10 Feb 2021 17:47:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F62G4dyQUfrDK+IyPBJmeTn9ilJhWVfUGcNeEcjLjnM=;
 b=P2sjk09LjIvG5ZyOLkS9vhOujm9OL5vOrGpbMW49dBJHFE7HaLylso93Bq4Whk8iXm4R
 /BHulzEtCz1fGOO0eJ6isCaUXGVp6LBjQJf7kesDMLnn8sxU6HKS7vtMzPx7yW36MrBw
 1c5K5QHZgYjzjjJY76RD/g7MMIoeHJ79H0rYGxKYKnWZsNnFOP1ogcvMO2cQ3x+TKoKD
 a4YVCPvWEn/eYLnl6YNXNRVlV6Q4K4jeh2qW02ZsF5lXAKfyw4EZGg3OhgKz/C43pzmu
 xkdCIKv24jlWLoqPiPDy77U5La+aJ/05iXDAhlSX6g8J8FQoi0Pkotnxc3mmccidEX2s Kg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqdhca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:47:37 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:47:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 17:47:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 17:47:34 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B2D183F7041;
        Wed, 10 Feb 2021 17:47:30 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <schalla@marvell.com>, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v5 06/14] octeontx2-pf: cn10k: Map LMTST region
Date:   Thu, 11 Feb 2021 07:16:23 +0530
Message-ID: <20210211014631.9578-7-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210211014631.9578-1-gakula@marvell.com>
References: <20210211014631.9578-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_11:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On CN10K platform transmit/receive buffer alloc and free from/to hardware
had changed to support burst operation. Whereas pervious silicon's only
support single buffer free at a time.
To Support the same firmware allocates a DRAM region for each PF/VF for
storing LMTLINES. These LMTLINES are used for NPA batch free and for
flushing SQE to the hardware.
PF/VF LMTST region is accessed via BAR4. PFs LMTST region is followed
by its VFs mbox memory. The size of region varies from 2KB to 256KB based
on number of LMTLINES configured.

This patch adds support for
- Mapping PF/VF LMTST region.
- Reserves 0-71 (RX + TX + XDP) LMTST lines for NPA batch
  free operation.
- Reserves 72-512 LMTST lines for NIX SQE flush.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.h       | 15 +++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 52 ++++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 37 ++++++++++++-
 3 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index e05a5d59fe0c..80f892fd8800 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -207,7 +207,14 @@ struct otx2_hw {
 	u8			lbk_links;  /* No. of LBK links present in HW */
 #define HW_TSO			BIT_ULL(0)
 #define CN10K_MBOX		BIT_ULL(1)
+#define CN10K_LMTST		BIT_ULL(2)
 	unsigned long		cap_flag;
+
+#define LMT_LINE_SIZE		128
+#define NIX_LMTID_BASE		72 /* RX + TX + XDP */
+	void __iomem		*lmt_base;
+	u64			*npa_lmt_base;
+	u64			*nix_lmt_base;
 };
 
 struct otx2_vf_config {
@@ -317,6 +324,10 @@ struct otx2_nic {
 
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
+	/* LMTST Lines info */
+	u16			tot_lmt_lines;
+	u16			nix_lmt_lines;
+	u32			nix_lmt_size;
 
 	struct otx2_ptp		*ptp;
 	struct hwtstamp_config	tstamp;
@@ -382,8 +393,10 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		pfvf->hw.rq_skid = 600;
 		pfvf->qset.rqe_cnt = Q_COUNT(Q_SIZE_1K);
 	}
-	if (!is_dev_otx2(pfvf->pdev))
+	if (!is_dev_otx2(pfvf->pdev)) {
 		__set_bit(CN10K_MBOX, &hw->cap_flag);
+		__set_bit(CN10K_LMTST, &hw->cap_flag);
+	}
 }
 
 /* Register read/write APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 55df8ad88985..997d1372703f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -46,6 +46,39 @@ enum {
 static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable);
 static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable);
 
+static int cn10k_lmtst_init(struct otx2_nic *pf)
+{
+	int size, num_lines;
+	u64 base;
+
+	if (!test_bit(CN10K_LMTST, &pf->hw.cap_flag))
+		return 0;
+
+	base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
+		       (MBOX_SIZE * (pf->total_vfs + 1));
+
+	size = pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM) -
+	       (MBOX_SIZE * (pf->total_vfs + 1));
+
+	pf->hw.lmt_base = ioremap(base, size);
+
+	if (!pf->hw.lmt_base) {
+		dev_err(pf->dev, "Unable to map PF LMTST region\n");
+		return -ENOMEM;
+	}
+
+	/* FIXME: Get the num of LMTST lines from LMT table */
+	pf->tot_lmt_lines = size / LMT_LINE_SIZE;
+	num_lines = (pf->tot_lmt_lines - NIX_LMTID_BASE) /
+			    pf->hw.tx_queues;
+	/* Number of LMT lines per SQ queues */
+	pf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
+
+	pf->nix_lmt_size = pf->nix_lmt_lines * LMT_LINE_SIZE;
+
+	return 0;
+}
+
 static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	bool if_up = netif_running(netdev);
@@ -1495,6 +1528,14 @@ int otx2_open(struct net_device *netdev)
 	if (!qset->rq)
 		goto err_free_mem;
 
+	if (test_bit(CN10K_LMTST, &pf->hw.cap_flag)) {
+		/* Reserve LMT lines for NPA AURA batch free */
+		pf->hw.npa_lmt_base = (__force u64 *)pf->hw.lmt_base;
+		/* Reserve LMT lines for NIX TX */
+		pf->hw.nix_lmt_base = (__force u64 *)((u64)pf->hw.npa_lmt_base +
+				      (NIX_LMTID_BASE * LMT_LINE_SIZE));
+	}
+
 	err = otx2_init_hw_resources(pf);
 	if (err)
 		goto err_free_mem;
@@ -2333,6 +2374,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_free_netdev;
 	}
 
+	otx2_setup_dev_hw_settings(pf);
+
 	/* Init PF <=> AF mailbox stuff */
 	err = otx2_pfaf_mbox_init(pf);
 	if (err)
@@ -2358,7 +2401,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	otx2_setup_dev_hw_settings(pf);
+	err = cn10k_lmtst_init(pf);
+	if (err)
+		goto err_detach_rsrc;
 
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
@@ -2443,6 +2488,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_ptp_destroy:
 	otx2_ptp_destroy(pf);
 err_detach_rsrc:
+	if (hw->lmt_base)
+		iounmap(hw->lmt_base);
 	otx2_detach_resources(&pf->mbox);
 err_disable_mbox_intr:
 	otx2_disable_mbox_intr(pf);
@@ -2602,6 +2649,9 @@ static void otx2_remove(struct pci_dev *pdev)
 	otx2_ptp_destroy(pf);
 	otx2_mcam_flow_del(pf);
 	otx2_detach_resources(&pf->mbox);
+	if (pf->hw.lmt_base)
+		iounmap(pf->hw.lmt_base);
+
 	otx2_disable_mbox_intr(pf);
 	otx2_pfaf_mbox_destroy(pf);
 	pci_free_irq_vectors(pf->pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index e7d8fef4f53d..9ed850b75d59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -27,6 +27,31 @@ enum {
 	RVU_VF_INT_VEC_MBOX = 0x0,
 };
 
+static int cn10k_lmtst_init(struct otx2_nic *vf)
+{
+	int size, num_lines;
+
+	if (!test_bit(CN10K_LMTST, &vf->hw.cap_flag))
+		return 0;
+
+	size = pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM);
+	vf->hw.lmt_base = ioremap_wc(pci_resource_start(vf->pdev,
+							PCI_MBOX_BAR_NUM),
+				     size);
+	if (!vf->hw.lmt_base) {
+		dev_err(vf->dev, "Unable to map VF LMTST region\n");
+		return -ENOMEM;
+	}
+
+	vf->tot_lmt_lines = size / LMT_LINE_SIZE;
+	/* LMTST lines per SQ */
+	num_lines = (vf->tot_lmt_lines - NIX_LMTID_BASE) /
+			    vf->hw.tx_queues;
+	vf->nix_lmt_lines = num_lines > 32 ? 32 : num_lines;
+	vf->nix_lmt_size = vf->nix_lmt_lines * LMT_LINE_SIZE;
+	return 0;
+}
+
 static void otx2vf_process_vfaf_mbox_msg(struct otx2_nic *vf,
 					 struct mbox_msghdr *msg)
 {
@@ -536,6 +561,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_free_irq_vectors;
 	}
 
+	otx2_setup_dev_hw_settings(vf);
 	/* Init VF <=> PF mailbox stuff */
 	err = otx2vf_vfaf_mbox_init(vf);
 	if (err)
@@ -559,7 +585,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
-	otx2_setup_dev_hw_settings(vf);
+	err = cn10k_lmtst_init(vf);
+	if (err)
+		goto err_detach_rsrc;
 
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
@@ -611,6 +639,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_detach_rsrc:
+	if (hw->lmt_base)
+		iounmap(hw->lmt_base);
 	otx2_detach_resources(&vf->mbox);
 err_disable_mbox_intr:
 	otx2vf_disable_mbox_intr(vf);
@@ -639,8 +669,11 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	cancel_work_sync(&vf->reset_task);
 	unregister_netdev(netdev);
 	otx2vf_disable_mbox_intr(vf);
-
 	otx2_detach_resources(&vf->mbox);
+
+	if (vf->hw.lmt_base)
+		iounmap(vf->hw.lmt_base);
+
 	otx2vf_vfaf_mbox_destroy(vf);
 	pci_free_irq_vectors(vf->pdev);
 	pci_set_drvdata(pdev, NULL);
-- 
2.17.1

