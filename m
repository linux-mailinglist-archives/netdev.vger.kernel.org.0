Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D31E30F209
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbhBDL0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:26:02 -0500
Received: from [1.6.215.26] ([1.6.215.26]:24392 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235697AbhBDLZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:25:56 -0500
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 114BP57g051814;
        Thu, 4 Feb 2021 16:55:05 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 114BP5JY051813;
        Thu, 4 Feb 2021 16:55:05 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sbhatta@marvell.com, hkelam@marvell.com,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v3 02/14] octeontx2-pf: cn10k: Add mbox support for CN10K
Date:   Thu,  4 Feb 2021 16:55:04 +0530
Message-Id: <1612437904-51773-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Firmware allocates memory regions for PFs and VFs in DRAM.
The PFs memory region is used for AF-PF and PF-VF mailbox.
This mbox facilitate communication between AF-PF and PF-VF.

On CN10K platform:
The DRAM region allocated to PF is enumerated as PF BAR4 memory.
PF BAR4 contains AF-PF mbox region followed by its VFs mbox region.
AF-PF mbox region base address is configured at RVU_AF_PFX_BAR4_ADDR
PF-VF mailbox base address is configured at
RVU_PF(x)_VF_MBOX_ADDR = RVU_AF_PF()_BAR4_ADDR+64KB. PF access its
mbox region via BAR4, whereas VF accesses PF-VF DRAM mailboxes via
BAR2 indirect access.

On CN9XX platform:
Mailbox region in DRAM is divided into two parts AF-PF mbox region and
PF-VF mbox region i.e all PFs mbox region is contiguous similarly all
VFs.
The base address of the AF-PF mbox region is configured at
RVU_AF_PF_BAR4_ADDR.
AF-PF1 mbox address can be calculated as RVU_AF_PF_BAR4_ADDR * mbox
size.
The base address of PF-VF mbox region for each PF is configure at
RVU_AF_PF(0..15)_VF_BAR4_ADDR.PF access its mbox region via BAR4 and its
VF mbox regions from RVU_PF_VF_BAR4_ADDR register, whereas VF access its
mbox region via BAR4.

This patch changes mbox initialization to support both CN9XX and CN10K
platform.
The patch also adds new hw_cap flag to setting hw features like TSO etc
and removes platform specific name from the PF/VF driver name to make it
appropriate for all supported platforms

This patch also removes platform specific name from the PF/VF driver name
to make it appropriate for all supported platforms

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |  8 ++---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 29 +++++++++++++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 18 ++++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  3 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  5 +--
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 37 ++++++++++++++--------
 6 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 4193ae3..29c82b9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -3,11 +3,11 @@
 # Makefile for Marvell's OcteonTX2 ethernet device drivers
 #
 
-obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
-obj-$(CONFIG_OCTEONTX2_VF) += octeontx2_nicvf.o
+obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
+obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 
-octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
+rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
 		     otx2_ptp.o otx2_flows.o
-octeontx2_nicvf-y := otx2_vf.o
+rvu_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 143ae04..e05a5d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -190,7 +190,6 @@ struct otx2_hw {
 	u8			lso_tsov6_idx;
 	u8			lso_udpv4_idx;
 	u8			lso_udpv6_idx;
-	u8			hw_tso;
 
 	/* MSI-X */
 	u8			cint_cnt; /* CQ interrupt count */
@@ -206,6 +205,9 @@ struct otx2_hw {
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
+#define HW_TSO			BIT_ULL(0)
+#define CN10K_MBOX		BIT_ULL(1)
+	unsigned long		cap_flag;
 };
 
 struct otx2_vf_config {
@@ -339,6 +341,25 @@ static inline bool is_96xx_B0(struct pci_dev *pdev)
 		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX_RVU_PFVF);
 }
 
+/* REVID for PCIe devices.
+ * Bits 0..1: minor pass, bit 3..2: major pass
+ * bits 7..4: midr id
+ */
+#define PCI_REVISION_ID_96XX		0x00
+#define PCI_REVISION_ID_95XX		0x10
+#define PCI_REVISION_ID_LOKI		0x20
+#define PCI_REVISION_ID_98XX		0x30
+#define PCI_REVISION_ID_95XXMM		0x40
+
+static inline bool is_dev_otx2(struct pci_dev *pdev)
+{
+	u8 midr = pdev->revision & 0xF0;
+
+	return (midr == PCI_REVISION_ID_96XX || midr == PCI_REVISION_ID_95XX ||
+		midr == PCI_REVISION_ID_LOKI || midr == PCI_REVISION_ID_98XX ||
+		midr == PCI_REVISION_ID_95XXMM);
+}
+
 static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 {
 	struct otx2_hw *hw = &pfvf->hw;
@@ -347,10 +368,10 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 	pfvf->hw.cq_ecount_wait = CQ_CQE_THRESH_DEFAULT;
 	pfvf->hw.cq_qcount_wait = CQ_QCOUNT_DEFAULT;
 
-	hw->hw_tso = true;
+	__set_bit(HW_TSO, &hw->cap_flag);
 
 	if (is_96xx_A0(pfvf->pdev)) {
-		hw->hw_tso = false;
+		__clear_bit(HW_TSO, &hw->cap_flag);
 
 		/* Time based irq coalescing is not supported */
 		pfvf->hw.cq_qcount_wait = 0x0;
@@ -361,6 +382,8 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		pfvf->hw.rq_skid = 600;
 		pfvf->qset.rqe_cnt = Q_COUNT(Q_SIZE_1K);
 	}
+	if (!is_dev_otx2(pfvf->pdev))
+		__set_bit(CN10K_MBOX, &hw->cap_flag);
 }
 
 /* Register read/write APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 07ec85a..55df8ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -24,8 +24,8 @@
 #include "otx2_ptp.h"
 #include <rvu_trace.h>
 
-#define DRV_NAME	"octeontx2-nicpf"
-#define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
+#define DRV_NAME	"rvu_nicpf"
+#define DRV_STRING	"Marvell RVU NIC Physical Function Driver"
 
 /* Supported devices */
 static const struct pci_device_id otx2_pf_id_table[] = {
@@ -585,9 +585,17 @@ static int otx2_pfvf_mbox_init(struct otx2_nic *pf, int numvfs)
 	if (!pf->mbox_pfvf_wq)
 		return -ENOMEM;
 
-	base = readq((void __iomem *)((u64)pf->reg_base + RVU_PF_VF_BAR4_ADDR));
-	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
+	/* On CN10K platform, PF <-> VF mailbox region follows after
+	 * PF <-> AF mailbox region.
+	 */
+	if (test_bit(CN10K_MBOX, &pf->hw.cap_flag))
+		base = pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM) +
+		       MBOX_SIZE;
+	else
+		base = readq((void __iomem *)((u64)pf->reg_base +
+					      RVU_PF_VF_BAR4_ADDR));
 
+	hwbase = ioremap_wc(base, MBOX_SIZE * pf->total_vfs);
 	if (!hwbase) {
 		err = -ENOMEM;
 		goto free_wq;
@@ -1039,7 +1047,7 @@ static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
 	 * device memory to allow unaligned accesses.
 	 */
 	hwbase = ioremap_wc(pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM),
-			    pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM));
+			    MBOX_SIZE);
 	if (!hwbase) {
 		dev_err(pf->dev, "Unable to map PFAF mailbox region\n");
 		err = -ENOMEM;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 867f646..1e052d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -44,6 +44,8 @@
 #define RVU_PF_MSIX_VECX_ADDR(a)            (0x000 | (a) << 4)
 #define RVU_PF_MSIX_VECX_CTL(a)             (0x008 | (a) << 4)
 #define RVU_PF_MSIX_PBAX(a)                 (0xF0000 | (a) << 3)
+#define RVU_PF_VF_MBOX_ADDR                 (0xC40)
+#define RVU_PF_LMTLINE_ADDR                 (0xC48)
 
 /* RVU VF registers */
 #define	RVU_VF_VFPF_MBOX0		    (0x00000)
@@ -57,6 +59,7 @@
 #define	RVU_VF_MSIX_VECX_ADDR(a)	    (0x000 | (a) << 4)
 #define	RVU_VF_MSIX_VECX_CTL(a)		    (0x008 | (a) << 4)
 #define	RVU_VF_MSIX_PBAX(a)		    (0xF0000 | (a) << 3)
+#define RVU_VF_MBOX_REGION                  (0xC0000)
 
 #define RVU_FUNC_BLKADDR_SHIFT		20
 #define RVU_FUNC_BLKADDR_MASK		0x1FULL
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index d0e2541..a7eb5ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -806,8 +806,6 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
 {
 	int payload_len, last_seg_size;
 
-	if (!pfvf->hw.hw_tso)
-		return false;
 
 	/* HW has an issue due to which when the payload of the last LSO
 	 * segment is shorter than 16 bytes, some header fields may not
@@ -821,6 +819,9 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
 	if (last_seg_size && last_seg_size < 16)
 		return false;
 
+	if (!test_bit(HW_TSO, &pfvf->hw.cap_flag))
+		return false;
+
 	return true;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index d3e4cfd..e7d8fef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -8,8 +8,8 @@
 #include "otx2_common.h"
 #include "otx2_reg.h"
 
-#define DRV_NAME	"octeontx2-nicvf"
-#define DRV_STRING	"Marvell OcteonTX2 NIC Virtual Function Driver"
+#define DRV_NAME	"rvu_nicvf"
+#define DRV_STRING	"Marvell RVU NIC Virtual Function Driver"
 
 static const struct pci_device_id otx2_vf_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
@@ -277,7 +277,7 @@ static void otx2vf_vfaf_mbox_destroy(struct otx2_nic *vf)
 		vf->mbox_wq = NULL;
 	}
 
-	if (mbox->mbox.hwbase)
+	if (mbox->mbox.hwbase && !test_bit(CN10K_MBOX, &vf->hw.cap_flag))
 		iounmap((void __iomem *)mbox->mbox.hwbase);
 
 	otx2_mbox_destroy(&mbox->mbox);
@@ -297,16 +297,25 @@ static int otx2vf_vfaf_mbox_init(struct otx2_nic *vf)
 	if (!vf->mbox_wq)
 		return -ENOMEM;
 
-	/* Mailbox is a reserved memory (in RAM) region shared between
-	 * admin function (i.e PF0) and this VF, shouldn't be mapped as
-	 * device memory to allow unaligned accesses.
-	 */
-	hwbase = ioremap_wc(pci_resource_start(vf->pdev, PCI_MBOX_BAR_NUM),
-			    pci_resource_len(vf->pdev, PCI_MBOX_BAR_NUM));
-	if (!hwbase) {
-		dev_err(vf->dev, "Unable to map VFAF mailbox region\n");
-		err = -ENOMEM;
-		goto exit;
+	if (test_bit(CN10K_MBOX, &vf->hw.cap_flag)) {
+		/* For cn10k platform, VF mailbox region is in its BAR2
+		 * register space
+		 */
+		hwbase = vf->reg_base + RVU_VF_MBOX_REGION;
+	} else {
+		/* Mailbox is a reserved memory (in RAM) region shared between
+		 * admin function (i.e PF0) and this VF, shouldn't be mapped as
+		 * device memory to allow unaligned accesses.
+		 */
+		hwbase = ioremap_wc(pci_resource_start(vf->pdev,
+						       PCI_MBOX_BAR_NUM),
+				    pci_resource_len(vf->pdev,
+						     PCI_MBOX_BAR_NUM));
+		if (!hwbase) {
+			dev_err(vf->dev, "Unable to map VFAF mailbox region\n");
+			err = -ENOMEM;
+			goto exit;
+		}
 	}
 
 	err = otx2_mbox_init(&mbox->mbox, hwbase, vf->pdev, vf->reg_base,
@@ -329,6 +338,8 @@ static int otx2vf_vfaf_mbox_init(struct otx2_nic *vf)
 
 	return 0;
 exit:
+	if (hwbase && !test_bit(CN10K_MBOX, &vf->hw.cap_flag))
+		iounmap(hwbase);
 	destroy_workqueue(vf->mbox_wq);
 	return err;
 }
-- 
2.7.4

