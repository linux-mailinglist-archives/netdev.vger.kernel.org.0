Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85132288CDB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389372AbgJIPfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:35:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389257AbgJIPfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUf4s019670;
        Fri, 9 Oct 2020 08:35:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=IALxgRksiup5yjIU5ANjZFcLe0Uq2ZXAiZ7xJJwrK8A=;
 b=SZope26fO/z3tdOLL6yBXXqsSUwJRbYlGU5/03DNJArrR5UG3DZk6YIbgPed4L+mOe1z
 F8COJyBR3QOH4PCuC9+HIDD9doI4WnGUDslaEoOfoow2gxoOCTmOJGlqfPo6IPxmIwsO
 61Ybh0Tv62wfiYYdw2Z10mwr5unfuWGVKLGjdTrPaoNbaDTmLENak2NnmwueIkXCDsFI
 /WrVuaj4jCUiFC64Ve98pPSwEP86C8ifPy1pfy0sFBAzCuik6Qn3xdDH8CLgLWGuwBJ8
 RTdOKnJXYTCP6BjjIRKuTXufXFx2UOYiJukv0NBI0D1AKC+E1yEtbX0awEfY7S0WN5vq ow== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3429h8bbva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:36 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id C3D7B3F703F;
        Fri,  9 Oct 2020 08:35:32 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,06/13] crypto: octeontx2: enable SR-IOV and mailbox communication with VF
Date:   Fri, 9 Oct 2020 21:04:14 +0530
Message-ID: <20201009153421.30562-7-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds 'sriov_configure' to enable/disable virtual functions (VFs).
Also Initializes VF<=>PF mailbox IRQs, register handlers for
processing these mailbox messages.

Admin function (AF) handles resource allocation and configuration for
PFs and their VFs. PFs request the AF directly, via mailboxes.
Unlike PFs, VFs cannot send a mailbox request directly. A VF sends
mailbox messages to its parent PF, with which it shares a mailbox
region. The PF then forwards these messages to the AF. After handling
the request, the AF sends a response back to the VF, through the PF.

This patch adds support for this 'VF <=> PF <=> AF' mailbox
communication.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |   1 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |  19 ++
 .../marvell/octeontx2/otx2_cptpf_main.c       | 209 +++++++++++++++++-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       | 172 +++++++++++++-
 4 files changed, 393 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index b677f8c7e724..277c7c7f95cf 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -14,6 +14,7 @@
 #include "rvu.h"
 #include "mbox.h"
 
+#define OTX2_CPT_MAX_VFS_NUM 128
 #define OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
 		(((blk) << 20) | ((slot) << 12) | (offs))
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 87fe4c6838e5..c7c687cb091e 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -7,19 +7,38 @@
 
 #include "otx2_cpt_common.h"
 
+struct otx2_cptpf_dev;
+struct otx2_cptvf_info {
+	struct otx2_cptpf_dev *cptpf;	/* PF pointer this VF belongs to */
+	struct work_struct vfpf_mbox_work;
+	struct pci_dev *vf_dev;
+	int vf_id;
+	int intr_idx;
+};
+
 struct otx2_cptpf_dev {
 	void __iomem *reg_base;		/* CPT PF registers start address */
 	void __iomem *afpf_mbox_base;	/* PF-AF mbox start address */
+	void __iomem *vfpf_mbox_base;   /* VF-PF mbox start address */
 	struct pci_dev *pdev;		/* PCI device handle */
+	struct otx2_cptvf_info vf[OTX2_CPT_MAX_VFS_NUM];
 	/* AF <=> PF mbox */
 	struct otx2_mbox	afpf_mbox;
 	struct work_struct	afpf_mbox_work;
 	struct workqueue_struct *afpf_mbox_wq;
 
+	/* VF <=> PF mbox */
+	struct otx2_mbox	vfpf_mbox;
+	struct workqueue_struct *vfpf_mbox_wq;
+
 	u8 pf_id;               /* RVU PF number */
+	u8 max_vfs;		/* Maximum number of VFs supported by CPT */
+	u8 enabled_vfs;		/* Number of enabled VFs */
 };
 
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int irq, void *arg);
 void otx2_cptpf_afpf_mbox_handler(struct work_struct *work);
+irqreturn_t otx2_cptpf_vfpf_mbox_intr(int irq, void *arg);
+void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work);
 
 #endif /* __OTX2_CPTPF_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 7f68d35b19f8..5464193ad338 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -11,6 +11,142 @@
 #define OTX2_CPT_DRV_STRING  "Marvell OcteonTX2 CPT Physical Function Driver"
 #define OTX2_CPT_DRV_VERSION "1.0"
 
+static void cptpf_enable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
+					int numvfs)
+{
+	int ena_bits;
+
+	/* Clear any pending interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(0), ~0x0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(1), ~0x0ULL);
+
+	/* Enable VF interrupts for VFs from 0 to 63 */
+	ena_bits = ((numvfs - 1) % 64);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1SX(0),
+			 GENMASK_ULL(ena_bits, 0));
+
+	if (numvfs > 64) {
+		/* Enable VF interrupts for VFs from 64 to 127 */
+		ena_bits = numvfs - 64 - 1;
+		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				RVU_PF_VFPF_MBOX_INT_ENA_W1SX(1),
+				GENMASK_ULL(ena_bits, 0));
+	}
+}
+
+static void cptpf_disable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
+					 int numvfs)
+{
+	int vector;
+
+	/* Disable VF-PF interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1CX(0), ~0ULL);
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INT_ENA_W1CX(1), ~0ULL);
+	/* Clear any pending interrupts */
+	otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+			 RVU_PF_VFPF_MBOX_INTX(0), ~0ULL);
+	vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFPF_MBOX0);
+	free_irq(vector, cptpf);
+
+	if (numvfs > 64) {
+		otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				 RVU_PF_VFPF_MBOX_INTX(1), ~0ULL);
+		vector = pci_irq_vector(cptpf->pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
+		free_irq(vector, cptpf);
+	}
+}
+
+static int cptpf_register_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
+					 int numvfs)
+{
+	struct pci_dev *pdev = cptpf->pdev;
+	struct device *dev = &pdev->dev;
+	int ret, vector;
+
+	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX0);
+	/* Register VF-PF mailbox interrupt handler */
+	ret = request_irq(vector, otx2_cptpf_vfpf_mbox_intr, 0, "CPTVFPF Mbox0",
+			  cptpf);
+	if (ret) {
+		dev_err(dev,
+			"IRQ registration failed for PFVF mbox0 irq\n");
+		return ret;
+	}
+	if (numvfs > 64) {
+		vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX1);
+		ret = request_irq(vector, otx2_cptpf_vfpf_mbox_intr, 0,
+				  "CPTVFPF Mbox1", cptpf);
+		if (ret) {
+			dev_err(dev,
+				"IRQ registration failed for PFVF mbox1 irq\n");
+			goto free_irq;
+		}
+	}
+	cptpf_enable_vfpf_mbox_intr(cptpf, numvfs);
+	return 0;
+
+free_irq:
+	vector = pci_irq_vector(pdev, RVU_PF_INT_VEC_VFPF_MBOX0);
+	free_irq(vector, cptpf);
+	return ret;
+}
+
+static int cptpf_vfpf_mbox_init(struct otx2_cptpf_dev *cptpf, int numvfs)
+{
+	struct device *dev = &cptpf->pdev->dev;
+	u64 vfpf_mbox_base;
+	int err, i;
+
+	cptpf->vfpf_mbox_wq = alloc_workqueue("cpt_vfpf_mailbox",
+					      WQ_UNBOUND | WQ_HIGHPRI |
+					      WQ_MEM_RECLAIM, 1);
+	if (!cptpf->vfpf_mbox_wq)
+		return -ENOMEM;
+
+	/* Map VF-PF mailbox memory */
+	vfpf_mbox_base = readq(cptpf->reg_base + RVU_PF_VF_BAR4_ADDR);
+	if (!vfpf_mbox_base) {
+		dev_err(dev, "VF-PF mailbox address not configured\n");
+		err = -ENOMEM;
+		goto free_wqe;
+	}
+	cptpf->vfpf_mbox_base = devm_ioremap_wc(dev, vfpf_mbox_base,
+						MBOX_SIZE * cptpf->max_vfs);
+	if (!cptpf->vfpf_mbox_base) {
+		dev_err(dev, "Mapping of VF-PF mailbox address failed\n");
+		err = -ENOMEM;
+		goto free_wqe;
+	}
+	err = otx2_mbox_init(&cptpf->vfpf_mbox, cptpf->vfpf_mbox_base,
+			     cptpf->pdev, cptpf->reg_base, MBOX_DIR_PFVF,
+			     numvfs);
+	if (err)
+		goto free_wqe;
+
+	for (i = 0; i < numvfs; i++) {
+		cptpf->vf[i].vf_id = i;
+		cptpf->vf[i].cptpf = cptpf;
+		cptpf->vf[i].intr_idx = i % 64;
+		INIT_WORK(&cptpf->vf[i].vfpf_mbox_work,
+			  otx2_cptpf_vfpf_mbox_handler);
+	}
+	return 0;
+free_wqe:
+	destroy_workqueue(cptpf->vfpf_mbox_wq);
+	return err;
+}
+
+static void cptpf_vfpf_mbox_destroy(struct otx2_cptpf_dev *cptpf)
+{
+	destroy_workqueue(cptpf->vfpf_mbox_wq);
+	otx2_mbox_destroy(&cptpf->vfpf_mbox);
+}
+
 static void cptpf_disable_afpf_mbox_intr(struct otx2_cptpf_dev *cptpf)
 {
 	/* Disable AF-PF interrupt */
@@ -98,6 +234,63 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 	return 0;
 }
 
+static int cptpf_sriov_disable(struct pci_dev *pdev)
+{
+	struct otx2_cptpf_dev *cptpf = pci_get_drvdata(pdev);
+	int numvfs = pci_num_vf(pdev);
+
+	if (!numvfs)
+		return 0;
+
+	pci_disable_sriov(pdev);
+	cptpf_disable_vfpf_mbox_intr(cptpf, numvfs);
+	cptpf_vfpf_mbox_destroy(cptpf);
+	module_put(THIS_MODULE);
+	cptpf->enabled_vfs = 0;
+
+	return 0;
+}
+
+static int cptpf_sriov_enable(struct pci_dev *pdev, int numvfs)
+{
+	struct otx2_cptpf_dev *cptpf = pci_get_drvdata(pdev);
+	int ret;
+
+	/* Initialize VF<=>PF mailbox */
+	ret = cptpf_vfpf_mbox_init(cptpf, cptpf->max_vfs);
+	if (ret)
+		return ret;
+	/* Register VF<=>PF mailbox interrupt */
+	ret = cptpf_register_vfpf_mbox_intr(cptpf, numvfs);
+	if (ret)
+		goto free_mbox;
+
+	cptpf->enabled_vfs = numvfs;
+	ret = pci_enable_sriov(pdev, numvfs);
+	if (ret)
+		goto disable_intr;
+
+	dev_notice(&cptpf->pdev->dev, "VFs enabled: %d\n", numvfs);
+
+	try_module_get(THIS_MODULE);
+	return numvfs;
+disable_intr:
+	cptpf_disable_vfpf_mbox_intr(cptpf, numvfs);
+	cptpf->enabled_vfs = 0;
+free_mbox:
+	cptpf_vfpf_mbox_destroy(cptpf);
+	return ret;
+}
+
+static int otx2_cptpf_sriov_configure(struct pci_dev *pdev, int numvfs)
+{
+	if (numvfs > 0) {
+		return cptpf_sriov_enable(pdev, numvfs);
+	} else {
+		return cptpf_sriov_disable(pdev);
+	}
+}
+
 static int otx2_cptpf_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
@@ -162,17 +355,19 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 			RVU_PF_INT_VEC_CNT);
 		goto clear_drvdata;
 	}
-	/* Initialize AF-PF mailbox */
+	/* Initialize AF<=>PF mailbox */
 	err = cptpf_afpf_mbox_init(cptpf);
 	if (err)
 		goto clear_drvdata;
-	/* Register mailbox interrupt */
+	/* Register AF<=>PF mailbox interrupt */
 	err = cptpf_register_afpf_mbox_intr(cptpf);
 	if (err)
-		goto destroy_afpf_mbox;
+		goto free_mbox;
+
+	cptpf->max_vfs = pci_sriov_get_totalvfs(pdev);
 
 	return 0;
-destroy_afpf_mbox:
+free_mbox:
 	cptpf_afpf_mbox_destroy(cptpf);
 clear_drvdata:
 	pci_set_drvdata(pdev, NULL);
@@ -185,9 +380,10 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 
 	if (!cptpf)
 		return;
-	/* Disable AF-PF mailbox interrupt */
+	cptpf_sriov_disable(pdev);
+	/* Disable AF<=>PF mailbox interrupt */
 	cptpf_disable_afpf_mbox_intr(cptpf);
-	/* Destroy AF-PF mbox */
+	/* Destroy AF<=>PF mbox */
 	cptpf_afpf_mbox_destroy(cptpf);
 	pci_set_drvdata(pdev, NULL);
 }
@@ -203,6 +399,7 @@ static struct pci_driver otx2_cpt_pci_driver = {
 	.id_table = otx2_cpt_id_table,
 	.probe = otx2_cptpf_probe,
 	.remove = otx2_cptpf_remove,
+	.sriov_configure = otx2_cptpf_sriov_configure
 };
 
 module_pci_driver(otx2_cpt_pci_driver);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 0a8bd46b5686..398f1c6402d9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -5,6 +5,127 @@
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
+static int forward_to_af(struct otx2_cptpf_dev *cptpf,
+			 struct otx2_cptvf_info *vf,
+			 struct mbox_msghdr *req, int size)
+{
+	struct mbox_msghdr *msg;
+	int ret;
+
+	msg = otx2_mbox_alloc_msg(&cptpf->afpf_mbox, 0, size);
+	if (msg == NULL)
+		return -ENOMEM;
+
+	memcpy((uint8_t *)msg + sizeof(struct mbox_msghdr),
+	       (uint8_t *)req + sizeof(struct mbox_msghdr), size);
+	msg->id = req->id;
+	msg->pcifunc = req->pcifunc;
+	msg->sig = req->sig;
+	msg->ver = req->ver;
+
+	otx2_mbox_msg_send(&cptpf->afpf_mbox, 0);
+	ret = otx2_mbox_wait_for_rsp(&cptpf->afpf_mbox, 0);
+	if (ret == -EIO) {
+		dev_err(&cptpf->pdev->dev, "RVU MBOX timeout.\n");
+		return ret;
+	} else if (ret) {
+		dev_err(&cptpf->pdev->dev, "RVU MBOX error: %d.\n", ret);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
+			       struct otx2_cptvf_info *vf,
+			       struct mbox_msghdr *req, int size)
+{
+	int err = 0;
+
+	/* Check if msg is valid, if not reply with an invalid msg */
+	if (req->sig != OTX2_MBOX_REQ_SIG)
+		goto inval_msg;
+
+	return forward_to_af(cptpf, vf, req, size);
+
+inval_msg:
+	otx2_reply_invalid_msg(&cptpf->vfpf_mbox, vf->vf_id, 0, req->id);
+	otx2_mbox_msg_send(&cptpf->vfpf_mbox, vf->vf_id);
+	return err;
+}
+
+irqreturn_t otx2_cptpf_vfpf_mbox_intr(int __always_unused irq, void *arg)
+{
+	struct otx2_cptpf_dev *cptpf = arg;
+	struct otx2_cptvf_info *vf;
+	int i, vf_idx;
+	u64 intr;
+
+	/*
+	 * Check which VF has raised an interrupt and schedule
+	 * corresponding work queue to process the messages
+	 */
+	for (i = 0; i < 2; i++) {
+		/* Read the interrupt bits */
+		intr = otx2_cpt_read64(cptpf->reg_base, BLKADDR_RVUM, 0,
+				       RVU_PF_VFPF_MBOX_INTX(i));
+
+		for (vf_idx = i * 64; vf_idx < cptpf->enabled_vfs; vf_idx++) {
+			vf = &cptpf->vf[vf_idx];
+			if (intr & (1ULL << vf->intr_idx)) {
+				queue_work(cptpf->vfpf_mbox_wq,
+					   &vf->vfpf_mbox_work);
+				/* Clear the interrupt */
+				otx2_cpt_write64(cptpf->reg_base, BLKADDR_RVUM,
+						 0, RVU_PF_VFPF_MBOX_INTX(i),
+						 BIT_ULL(vf->intr_idx));
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+void otx2_cptpf_vfpf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_cptpf_dev *cptpf;
+	struct otx2_cptvf_info *vf;
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *req_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+	int offset, i, err;
+
+	vf = container_of(work, struct otx2_cptvf_info, vfpf_mbox_work);
+	cptpf = vf->cptpf;
+	mbox = &cptpf->vfpf_mbox;
+	/* sync with mbox memory region */
+	smp_rmb();
+	mdev = &mbox->dev[vf->vf_id];
+	/* Process received mbox messages */
+	req_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+	offset = mbox->rx_start + ALIGN(sizeof(*req_hdr), MBOX_MSG_ALIGN);
+
+	for (i = 0; i < req_hdr->num_msgs; i++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+
+		/* Set which VF sent this message based on mbox IRQ */
+		msg->pcifunc = ((u16)cptpf->pf_id << RVU_PFVF_PF_SHIFT) |
+				((vf->vf_id + 1) & RVU_PFVF_FUNC_MASK);
+
+		err = cptpf_handle_vf_req(cptpf, vf, msg,
+					  msg->next_msgoff - offset);
+		/*
+		 * Behave as the AF, drop the msg if there is
+		 * no memory, timeout handling also goes here
+		 */
+		if (err == -ENOMEM || err == -EIO)
+			break;
+		offset = msg->next_msgoff;
+	}
+	/* Send mbox responses to VF */
+	if (mdev->num_msgs)
+		otx2_mbox_msg_send(mbox, vf->vf_id);
+}
+
 irqreturn_t otx2_cptpf_afpf_mbox_intr(int __always_unused irq, void *arg)
 {
 	struct otx2_cptpf_dev *cptpf = arg;
@@ -50,6 +171,46 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 	}
 }
 
+static void forward_to_vf(struct otx2_cptpf_dev *cptpf, struct mbox_msghdr *msg,
+			  int vf_id, int size)
+{
+	struct otx2_mbox *vfpf_mbox;
+	struct mbox_msghdr *fwd;
+
+	if (msg->id >= MBOX_MSG_MAX) {
+		dev_err(&cptpf->pdev->dev,
+			"MBOX msg with unknown ID %d\n", msg->id);
+		return;
+	}
+	if (msg->sig != OTX2_MBOX_RSP_SIG) {
+		dev_err(&cptpf->pdev->dev,
+			"MBOX msg with wrong signature %x, ID %d\n",
+			msg->sig, msg->id);
+		return;
+	}
+	vfpf_mbox = &cptpf->vfpf_mbox;
+	vf_id--;
+	if (vf_id >= cptpf->enabled_vfs) {
+		dev_err(&cptpf->pdev->dev,
+			"MBOX msg to unknown VF: %d >= %d\n",
+			vf_id, cptpf->enabled_vfs);
+		return;
+	}
+	fwd = otx2_mbox_alloc_msg(vfpf_mbox, vf_id, size);
+	if (!fwd) {
+		dev_err(&cptpf->pdev->dev,
+			"Forwarding to VF%d failed.\n", vf_id);
+		return;
+	}
+	memcpy((uint8_t *)fwd + sizeof(struct mbox_msghdr),
+		(uint8_t *)msg + sizeof(struct mbox_msghdr), size);
+	fwd->id = msg->id;
+	fwd->pcifunc = msg->pcifunc;
+	fwd->sig = msg->sig;
+	fwd->ver = msg->ver;
+	fwd->rc = msg->rc;
+}
+
 /* Handle mailbox messages received from AF */
 void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 {
@@ -58,7 +219,7 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 	struct otx2_mbox_dev *mdev;
 	struct mbox_hdr *rsp_hdr;
 	struct mbox_msghdr *msg;
-	int offset, i;
+	int offset, vf_id, i;
 
 	cptpf = container_of(work, struct otx2_cptpf_dev, afpf_mbox_work);
 	afpf_mbox = &cptpf->afpf_mbox;
@@ -72,7 +233,14 @@ void otx2_cptpf_afpf_mbox_handler(struct work_struct *work)
 	for (i = 0; i < rsp_hdr->num_msgs; i++) {
 		msg = (struct mbox_msghdr *)(mdev->mbase + afpf_mbox->rx_start +
 					     offset);
-		process_afpf_mbox_msg(cptpf, msg);
+		vf_id = (msg->pcifunc >> RVU_PFVF_FUNC_SHIFT) &
+			 RVU_PFVF_FUNC_MASK;
+		if (vf_id > 0)
+			forward_to_vf(cptpf, msg, vf_id,
+				      msg->next_msgoff - offset);
+		else
+			process_afpf_mbox_msg(cptpf, msg);
+
 		offset = msg->next_msgoff;
 		mdev->msgs_acked++;
 	}
-- 
2.28.0

