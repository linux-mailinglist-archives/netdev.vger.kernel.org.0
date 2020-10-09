Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D2288CDD
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbgJIPfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:35:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389257AbgJIPfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUPx0019588;
        Fri, 9 Oct 2020 08:35:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=taF/XNVg1/pUikFcZYG2vKGEo78ScLL22JznNpyV/68=;
 b=b09FuIrYKgi0VpY1r/Mptw/leEzt7W6r+FjoNDbJxlCgJGS0J75BNToobvB//8CFeesA
 QBKjCfF3gfvql9JV4BPVFCGOsBQHvVQ/rre0ZwwUQ8EHHsZ0JFBUoaIC5zwb6y//wgFg
 1msLdwscG62r1hJYnVBBu8JJh+ltEry8OCGnjmUqOTYO0gb8WZj5AgFxniaybV84hgp4
 X/J4uM4qJ/H2/rX/B62oeFqIBKja8nv01hS5ertvHlhkdofpRC73CApWLachWvBFnL9e
 w73bKFmafEeH1x5ybqvxD5eOfh0lQArbzVJJQqeekqCCI6fWJhCysrw2MvA6FlhIY2P9 EQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3429h8bbvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:43 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:42 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 459C03F703F;
        Fri,  9 Oct 2020 08:35:38 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,07/13] crypto: octeontx2: load microcode and create engine groups
Date:   Fri, 9 Oct 2020 21:04:15 +0530
Message-ID: <20201009153421.30562-8-schalla@marvell.com>
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

CPT includes microcoded GigaCypher symmetric engines(SEs), IPsec
symmetric engines(IEs), and asymmetric engines (AEs).
Each engine receives CPT instructions from the engine groups it has
subscribed to. This patch loads microcode, configures three engine
groups(one for SEs, one for IEs and one for AEs), and configures
all engines.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |    2 +-
 .../marvell/octeontx2/otx2_cpt_common.h       |   42 +
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  |   77 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |    3 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |   73 +
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |   46 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1368 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |  161 ++
 8 files changed, 1770 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index 8c8262e94f78..3c4155446296 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -2,6 +2,6 @@
 obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o
 
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
-		      otx2_cpt_mbox_common.o
+		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 277c7c7f95cf..ae16dc102459 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -18,6 +18,37 @@
 #define OTX2_CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
 		(((blk) << 20) | ((slot) << 12) | (offs))
 
+#define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
+#define OTX2_CPT_NAME_LENGTH 64
+
+#define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
+
+enum otx2_cpt_eng_type {
+	OTX2_CPT_AE_TYPES = 1,
+	OTX2_CPT_SE_TYPES = 2,
+	OTX2_CPT_IE_TYPES = 3,
+	OTX2_CPT_MAX_ENG_TYPES,
+};
+
+/* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
+#define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
+
+/*
+ * Message request and response to get engine group number
+ * which has attached a given type of engines (SE, AE, IE)
+ * This messages are only used between CPT PF <=> CPT VF
+ */
+struct otx2_cpt_egrp_num_msg {
+	struct mbox_msghdr hdr;
+	u8 eng_type;
+};
+
+struct otx2_cpt_egrp_num_rsp {
+	struct mbox_msghdr hdr;
+	u8 eng_type;
+	u8 eng_grp_num;
+};
+
 static inline void otx2_cpt_write64(void __iomem *reg_base, u64 blk, u64 slot,
 				    u64 offs, u64 val)
 {
@@ -34,4 +65,15 @@ static inline u64 otx2_cpt_read64(void __iomem *reg_base, u64 blk, u64 slot,
 
 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
 int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev);
+
+int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox,
+				  struct pci_dev *pdev);
+int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox,
+			     struct pci_dev *pdev, u64 reg, u64 *val);
+int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			      u64 reg, u64 val);
+int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			 u64 reg, u64 *val);
+int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			  u64 reg, u64 val);
 #endif /* __OTX2_CPT_COMMON_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index a122483b5976..ef1291c4881b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -35,3 +35,80 @@ int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 
 	return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+
+int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox, struct pci_dev *pdev)
+{
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
+}
+
+int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			     u64 reg, u64 *val)
+{
+	struct cpt_rd_wr_reg_msg *reg_msg;
+
+	reg_msg = (struct cpt_rd_wr_reg_msg *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*reg_msg),
+						sizeof(*reg_msg));
+	if (reg_msg == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	reg_msg->hdr.id = MBOX_MSG_CPT_RD_WR_REGISTER;
+	reg_msg->hdr.sig = OTX2_MBOX_REQ_SIG;
+	reg_msg->hdr.pcifunc = 0;
+
+	reg_msg->is_write = 0;
+	reg_msg->reg_offset = reg;
+	reg_msg->ret_val = val;
+
+	return 0;
+}
+
+int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			      u64 reg, u64 val)
+{
+	struct cpt_rd_wr_reg_msg *reg_msg;
+
+	reg_msg = (struct cpt_rd_wr_reg_msg *)
+			otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*reg_msg),
+						sizeof(*reg_msg));
+	if (reg_msg == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+
+	reg_msg->hdr.id = MBOX_MSG_CPT_RD_WR_REGISTER;
+	reg_msg->hdr.sig = OTX2_MBOX_REQ_SIG;
+	reg_msg->hdr.pcifunc = 0;
+
+	reg_msg->is_write = 1;
+	reg_msg->reg_offset = reg;
+	reg_msg->val = val;
+
+	return 0;
+}
+
+int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			 u64 reg, u64 *val)
+{
+	int ret;
+
+	ret = otx2_cpt_add_read_af_reg(mbox, pdev, reg, val);
+	if (ret)
+		return ret;
+
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
+}
+
+int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
+			  u64 reg, u64 val)
+{
+	int ret;
+
+	ret = otx2_cpt_add_write_af_reg(mbox, pdev, reg, val);
+	if (ret)
+		return ret;
+
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index c7c687cb091e..528a3975b9c2 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -6,6 +6,7 @@
 #define __OTX2_CPTPF_H
 
 #include "otx2_cpt_common.h"
+#include "otx2_cptpf_ucode.h"
 
 struct otx2_cptpf_dev;
 struct otx2_cptvf_info {
@@ -22,6 +23,8 @@ struct otx2_cptpf_dev {
 	void __iomem *vfpf_mbox_base;   /* VF-PF mbox start address */
 	struct pci_dev *pdev;		/* PCI device handle */
 	struct otx2_cptvf_info vf[OTX2_CPT_MAX_VFS_NUM];
+	struct otx2_cpt_eng_grps eng_grps;/* Engine groups information */
+
 	/* AF <=> PF mbox */
 	struct otx2_mbox	afpf_mbox;
 	struct work_struct	afpf_mbox_work;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 5464193ad338..b1bd2e668898 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -4,6 +4,7 @@
 #include <linux/firmware.h>
 #include "otx2_cpt_hw_types.h"
 #include "otx2_cpt_common.h"
+#include "otx2_cptpf_ucode.h"
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
@@ -234,6 +235,59 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 	return 0;
 }
 
+static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
+{
+	int timeout = 10, ret;
+	u64 reg = 0;
+
+	ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+				    CPT_AF_BLK_RST, 0x1);
+	if (ret)
+		return ret;
+
+	do {
+		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+					   CPT_AF_BLK_RST, &reg);
+		if (ret)
+			return ret;
+
+		if (!((reg >> 63) & 0x1))
+			break;
+
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+	} while (1);
+
+	return ret;
+}
+
+static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
+{
+	union otx2_cptx_af_constants1 af_cnsts1 = {0};
+	int ret = 0;
+
+	/* Reset the CPT PF device */
+	ret = cptpf_device_reset(cptpf);
+	if (ret)
+		return ret;
+
+	/* Get number of SE, IE and AE engines */
+	ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+				   CPT_AF_CONSTANTS1, &af_cnsts1.u);
+	if (ret)
+		return ret;
+
+	cptpf->eng_grps.avail.max_se_cnt = af_cnsts1.s.se;
+	cptpf->eng_grps.avail.max_ie_cnt = af_cnsts1.s.ie;
+	cptpf->eng_grps.avail.max_ae_cnt = af_cnsts1.s.ae;
+
+	/* Disable all cores */
+	ret = otx2_cpt_disable_all_cores(cptpf);
+
+	return ret;
+}
+
 static int cptpf_sriov_disable(struct pci_dev *pdev)
 {
 	struct otx2_cptpf_dev *cptpf = pci_get_drvdata(pdev);
@@ -265,6 +319,10 @@ static int cptpf_sriov_enable(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		goto free_mbox;
 
+	ret = otx2_cpt_create_eng_grps(cptpf->pdev, &cptpf->eng_grps);
+	if (ret)
+		goto disable_intr;
+
 	cptpf->enabled_vfs = numvfs;
 	ret = pci_enable_sriov(pdev, numvfs);
 	if (ret)
@@ -366,7 +424,19 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
 
 	cptpf->max_vfs = pci_sriov_get_totalvfs(pdev);
 
+	/* Initialize CPT PF device */
+	err = cptpf_device_init(cptpf);
+	if (err)
+		goto unregister_intr;
+
+	/* Initialize engine groups */
+	err = otx2_cpt_init_eng_grps(pdev, &cptpf->eng_grps);
+	if (err)
+		goto unregister_intr;
+
 	return 0;
+unregister_intr:
+	cptpf_disable_afpf_mbox_intr(cptpf);
 free_mbox:
 	cptpf_afpf_mbox_destroy(cptpf);
 clear_drvdata:
@@ -380,7 +450,10 @@ static void otx2_cptpf_remove(struct pci_dev *pdev)
 
 	if (!cptpf)
 		return;
+
 	cptpf_sriov_disable(pdev);
+	/* Cleanup engine groups */
+	otx2_cpt_cleanup_eng_grps(pdev, &cptpf->eng_grps);
 	/* Disable AF<=>PF mailbox interrupt */
 	cptpf_disable_afpf_mbox_intr(cptpf);
 	/* Destroy AF<=>PF mbox */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index 398f1c6402d9..8852a7e5e035 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -35,6 +35,29 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 	return 0;
 }
 
+static int handle_msg_get_eng_grp_num(struct otx2_cptpf_dev *cptpf,
+				      struct otx2_cptvf_info *vf,
+				      struct mbox_msghdr *req)
+{
+	struct otx2_cpt_egrp_num_msg *grp_req;
+	struct otx2_cpt_egrp_num_rsp *rsp;
+
+	grp_req = (struct otx2_cpt_egrp_num_msg *)req;
+	rsp = (struct otx2_cpt_egrp_num_rsp *)
+	       otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id, sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_GET_ENG_GRP_NUM;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+	rsp->eng_type = grp_req->eng_type;
+	rsp->eng_grp_num = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
+						grp_req->eng_type);
+
+	return 0;
+}
+
 static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 			       struct otx2_cptvf_info *vf,
 			       struct mbox_msghdr *req, int size)
@@ -45,7 +68,15 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 	if (req->sig != OTX2_MBOX_REQ_SIG)
 		goto inval_msg;
 
-	return forward_to_af(cptpf, vf, req, size);
+	switch (req->id) {
+	case MBOX_MSG_GET_ENG_GRP_NUM:
+		err = handle_msg_get_eng_grp_num(cptpf, vf, req);
+		break;
+	default:
+		err = forward_to_af(cptpf, vf, req, size);
+		break;
+	}
+	return err;
 
 inval_msg:
 	otx2_reply_invalid_msg(&cptpf->vfpf_mbox, vf->vf_id, 0, req->id);
@@ -148,6 +179,7 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 				  struct mbox_msghdr *msg)
 {
 	struct device *dev = &cptpf->pdev->dev;
+	struct cpt_rd_wr_reg_msg *rsp_rd_wr;
 
 	if (msg->id >= MBOX_MSG_MAX) {
 		dev_err(dev, "MBOX msg with unknown ID %d\n", msg->id);
@@ -164,6 +196,18 @@ static void process_afpf_mbox_msg(struct otx2_cptpf_dev *cptpf,
 		cptpf->pf_id = (msg->pcifunc >> RVU_PFVF_PF_SHIFT) &
 				RVU_PFVF_PF_MASK;
 		break;
+	case MBOX_MSG_CPT_RD_WR_REGISTER:
+		rsp_rd_wr = (struct cpt_rd_wr_reg_msg *)msg;
+		if (msg->rc) {
+			dev_err(dev, "Reg %llx rd/wr(%d) failed %d\n",
+				rsp_rd_wr->reg_offset, rsp_rd_wr->is_write,
+				msg->rc);
+			return;
+		}
+		if (!rsp_rd_wr->is_write)
+			*rsp_rd_wr->ret_val = rsp_rd_wr->val;
+		break;
+
 	default:
 		dev_err(dev,
 			"Unsupported msg %d received.\n", msg->id);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
new file mode 100644
index 000000000000..190937b6515b
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -0,0 +1,1368 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/ctype.h>
+#include <linux/firmware.h>
+#include "otx2_cptpf_ucode.h"
+#include "otx2_cpt_common.h"
+#include "otx2_cptpf.h"
+#include "rvu_reg.h"
+
+#define CSR_DELAY 30
+/* Tar archive defines */
+#define TAR_MAGIC "ustar"
+#define TAR_MAGIC_LEN 6
+#define TAR_BLOCK_LEN 512
+#define REGTYPE '0'
+#define AREGTYPE '\0'
+
+#define LOADFVC_RLEN 8
+#define LOADFVC_MAJOR_OP 0x01
+#define LOADFVC_MINOR_OP 0x08
+
+/* tar header as defined in POSIX 1003.1-1990. */
+struct tar_hdr_t {
+	char name[100];
+	char mode[8];
+	char uid[8];
+	char gid[8];
+	char size[12];
+	char mtime[12];
+	char chksum[8];
+	char typeflag;
+	char linkname[100];
+	char magic[6];
+	char version[2];
+	char uname[32];
+	char gname[32];
+	char devmajor[8];
+	char devminor[8];
+	char prefix[155];
+};
+
+struct tar_blk_t {
+	union {
+		struct tar_hdr_t hdr;
+		char block[TAR_BLOCK_LEN];
+	};
+};
+
+struct tar_arch_info_t {
+	struct list_head ucodes;
+	const struct firmware *fw;
+};
+
+static struct otx2_cpt_bitmap get_cores_bmap(struct device *dev,
+					struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_bitmap bmap = { {0} };
+	bool found = false;
+	int i;
+
+	if (eng_grp->g->engs_num > OTX2_CPT_MAX_ENGINES) {
+		dev_err(dev, "unsupported number of engines %d on octeontx2\n",
+			eng_grp->g->engs_num);
+		return bmap;
+	}
+
+	for (i = 0; i  < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (eng_grp->engs[i].type) {
+			bitmap_or(bmap.bits, bmap.bits,
+				  eng_grp->engs[i].bmap,
+				  eng_grp->g->engs_num);
+			bmap.size = eng_grp->g->engs_num;
+			found = true;
+		}
+	}
+
+	if (!found)
+		dev_err(dev, "No engines reserved for engine group %d\n",
+			eng_grp->idx);
+	return bmap;
+}
+
+static int is_eng_type(int val, int eng_type)
+{
+	return val & (1 << eng_type);
+}
+
+static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	if (eng_grp->ucode[1].type)
+		return true;
+	else
+		return false;
+}
+
+static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
+				      const char *filename)
+{
+	strlcpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
+}
+
+static char *get_eng_type_str(int eng_type)
+{
+	char *str = "unknown";
+
+	switch (eng_type) {
+	case OTX2_CPT_SE_TYPES:
+		str = "SE";
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		str = "IE";
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		str = "AE";
+		break;
+	}
+	return str;
+}
+
+static char *get_ucode_type_str(int ucode_type)
+{
+	char *str = "unknown";
+
+	switch (ucode_type) {
+	case (1 << OTX2_CPT_SE_TYPES):
+		str = "SE";
+		break;
+
+	case (1 << OTX2_CPT_IE_TYPES):
+		str = "IE";
+		break;
+
+	case (1 << OTX2_CPT_AE_TYPES):
+		str = "AE";
+		break;
+
+	case (1 << OTX2_CPT_SE_TYPES | 1 << OTX2_CPT_IE_TYPES):
+		str = "SE+IPSEC";
+		break;
+	}
+	return str;
+}
+
+static int get_ucode_type(struct device *dev,
+			  struct otx2_cpt_ucode_hdr *ucode_hdr,
+			  int *ucode_type)
+{
+	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
+	char ver_str_prefix[OTX2_CPT_UCODE_VER_STR_SZ];
+	char tmp_ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
+	struct pci_dev *pdev = cptpf->pdev;
+	int i, val = 0;
+	u8 nn;
+
+	strlcpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
+	for (i = 0; i < strlen(tmp_ver_str); i++)
+		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
+
+	sprintf(ver_str_prefix, "ocpt-%02d", pdev->revision);
+	if (!strnstr(tmp_ver_str, ver_str_prefix, OTX2_CPT_UCODE_VER_STR_SZ))
+		return -EINVAL;
+
+	nn = ucode_hdr->ver_num.nn;
+	if (strnstr(tmp_ver_str, "se-", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    (nn == OTX2_CPT_SE_UC_TYPE1 || nn == OTX2_CPT_SE_UC_TYPE2 ||
+	     nn == OTX2_CPT_SE_UC_TYPE3))
+		val |= 1 << OTX2_CPT_SE_TYPES;
+	if (strnstr(tmp_ver_str, "ie-", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    (nn == OTX2_CPT_IE_UC_TYPE1 || nn == OTX2_CPT_IE_UC_TYPE2 ||
+	     nn == OTX2_CPT_IE_UC_TYPE3))
+		val |= 1 << OTX2_CPT_IE_TYPES;
+	if (strnstr(tmp_ver_str, "ae", OTX2_CPT_UCODE_VER_STR_SZ) &&
+	    nn == OTX2_CPT_AE_UC_TYPE)
+		val |= 1 << OTX2_CPT_AE_TYPES;
+
+	*ucode_type = val;
+
+	if (!val)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int is_mem_zero(const char *ptr, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (ptr[i])
+			return 0;
+	}
+	return 1;
+}
+
+static int __write_ucode_base(struct otx2_cptpf_dev *cptpf, int eng,
+			      dma_addr_t dma_addr)
+{
+	return otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+				     CPT_AF_EXEX_UCODE_BASE(eng),
+				     (u64)dma_addr);
+}
+
+static int cpt_set_ucode_base(struct otx2_cpt_eng_grp_info *eng_grp, void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_engs_rsvd *engs;
+	dma_addr_t dma_addr;
+	int i, bit, ret;
+
+	/* Set PF number for microcode fetches */
+	ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+				    CPT_AF_PF_FUNC,
+				    cptpf->pf_id << RVU_PFVF_PF_SHIFT);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+
+		dma_addr = engs->ucode->dma;
+
+		/*
+		 * Set UCODE_BASE only for the cores which are not used,
+		 * other cores should have already valid UCODE_BASE set
+		 */
+		for_each_set_bit(bit, engs->bmap, eng_grp->g->engs_num)
+			if (!eng_grp->g->eng_ref_cnt[bit]) {
+				ret = __write_ucode_base(cptpf, bit, dma_addr);
+				if (ret)
+					return ret;
+			}
+	}
+	return 0;
+}
+
+static int cpt_detach_and_disable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+					void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	int i, timeout = 10;
+	int busy, ret;
+	u64 reg = 0;
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size)
+		return -EINVAL;
+
+	/* Detach the cores from group */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+					   CPT_AF_EXEX_CTL2(i), &reg);
+		if (ret)
+			return ret;
+
+		if (reg & (1ull << eng_grp->idx)) {
+			eng_grp->g->eng_ref_cnt[i]--;
+			reg &= ~(1ull << eng_grp->idx);
+
+			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
+						    cptpf->pdev,
+						    CPT_AF_EXEX_CTL2(i), reg);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Wait for cores to become idle */
+	do {
+		busy = 0;
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+
+		for_each_set_bit(i, bmap.bits, bmap.size) {
+			ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox,
+						   cptpf->pdev,
+						   CPT_AF_EXEX_STS(i), &reg);
+			if (ret)
+				return ret;
+
+			if (reg & 0x1) {
+				busy = 1;
+				break;
+			}
+		}
+	} while (busy);
+
+	/* Disable the cores only if they are not used anymore */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		if (!eng_grp->g->eng_ref_cnt[i]) {
+			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
+						    cptpf->pdev,
+						    CPT_AF_EXEX_CTL(i), 0x0);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int cpt_attach_and_enable_cores(struct otx2_cpt_eng_grp_info *eng_grp,
+				       void *obj)
+{
+	struct otx2_cptpf_dev *cptpf = obj;
+	struct otx2_cpt_bitmap bmap;
+	u64 reg = 0;
+	int i, ret;
+
+	bmap = get_cores_bmap(&cptpf->pdev->dev, eng_grp);
+	if (!bmap.size)
+		return -EINVAL;
+
+	/* Attach the cores to the group */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+					   CPT_AF_EXEX_CTL2(i), &reg);
+		if (ret)
+			return ret;
+
+		if (!(reg & (1ull << eng_grp->idx))) {
+			eng_grp->g->eng_ref_cnt[i]++;
+			reg |= 1ull << eng_grp->idx;
+
+			ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox,
+						    cptpf->pdev,
+						    CPT_AF_EXEX_CTL2(i), reg);
+			if (ret)
+				return ret;
+		}
+	}
+
+	/* Enable the cores */
+	for_each_set_bit(i, bmap.bits, bmap.size) {
+		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox,
+						cptpf->pdev,
+						CPT_AF_EXEX_CTL(i), 0x1);
+		if (ret)
+			return ret;
+	}
+	ret = otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
+
+	return ret;
+}
+
+static int process_tar_file(struct device *dev,
+			    struct tar_arch_info_t *tar_arch, char *filename,
+			    const u8 *data, int size)
+{
+	struct tar_ucode_info_t *tar_ucode_info;
+	struct otx2_cpt_ucode_hdr *ucode_hdr;
+	int ucode_type, ucode_size;
+
+	/*
+	 * If size is less than microcode header size then don't report
+	 * an error because it might not be microcode file, just process
+	 * next file from archive
+	 */
+	if (size < sizeof(struct otx2_cpt_ucode_hdr))
+		return 0;
+
+	ucode_hdr = (struct otx2_cpt_ucode_hdr *) data;
+	/*
+	 * If microcode version can't be found don't report an error
+	 * because it might not be microcode file, just process next file
+	 */
+	if (get_ucode_type(dev, ucode_hdr, &ucode_type))
+		return 0;
+
+	ucode_size = ntohl(ucode_hdr->code_length) * 2;
+	if (!ucode_size || (size < round_up(ucode_size, 16) +
+	    sizeof(struct otx2_cpt_ucode_hdr) + OTX2_CPT_UCODE_SIGN_LEN)) {
+		dev_err(dev, "Ucode %s invalid size\n", filename);
+		return -EINVAL;
+	}
+
+	tar_ucode_info = kzalloc(sizeof(*tar_ucode_info), GFP_KERNEL);
+	if (!tar_ucode_info)
+		return -ENOMEM;
+
+	tar_ucode_info->ucode_ptr = data;
+	set_ucode_filename(&tar_ucode_info->ucode, filename);
+	memcpy(tar_ucode_info->ucode.ver_str, ucode_hdr->ver_str,
+	       OTX2_CPT_UCODE_VER_STR_SZ);
+	tar_ucode_info->ucode.ver_num = ucode_hdr->ver_num;
+	tar_ucode_info->ucode.type = ucode_type;
+	tar_ucode_info->ucode.size = ucode_size;
+	list_add_tail(&tar_ucode_info->list, &tar_arch->ucodes);
+
+	return 0;
+}
+
+static void release_tar_archive(struct tar_arch_info_t *tar_arch)
+{
+	struct tar_ucode_info_t *curr, *temp;
+
+	if (!tar_arch)
+		return;
+
+	list_for_each_entry_safe(curr, temp, &tar_arch->ucodes, list) {
+		list_del(&curr->list);
+		kfree(curr);
+	}
+
+	if (tar_arch->fw)
+		release_firmware(tar_arch->fw);
+	kfree(tar_arch);
+}
+
+static struct tar_ucode_info_t *get_uc_from_tar_archive(
+					struct tar_arch_info_t *tar_arch,
+					int ucode_type)
+{
+	struct tar_ucode_info_t *curr;
+
+	list_for_each_entry(curr, &tar_arch->ucodes, list) {
+		if (!is_eng_type(curr->ucode.type, ucode_type))
+			continue;
+
+		return curr;
+	}
+	return NULL;
+}
+
+static void print_tar_dbg_info(struct tar_arch_info_t *tar_arch,
+			       char *tar_filename)
+{
+	struct tar_ucode_info_t *curr;
+
+	pr_debug("Tar archive filename %s\n", tar_filename);
+	pr_debug("Tar archive pointer %p, size %ld\n", tar_arch->fw->data,
+		 tar_arch->fw->size);
+	list_for_each_entry(curr, &tar_arch->ucodes, list) {
+		pr_debug("Ucode filename %s\n", curr->ucode.filename);
+		pr_debug("Ucode version string %s\n", curr->ucode.ver_str);
+		pr_debug("Ucode version %d.%d.%d.%d\n",
+			 curr->ucode.ver_num.nn, curr->ucode.ver_num.xx,
+			 curr->ucode.ver_num.yy, curr->ucode.ver_num.zz);
+		pr_debug("Ucode type (%d) %s\n", curr->ucode.type,
+			 get_ucode_type_str(curr->ucode.type));
+		pr_debug("Ucode size %d\n", curr->ucode.size);
+		pr_debug("Ucode ptr %p\n", curr->ucode_ptr);
+	}
+}
+
+static struct tar_arch_info_t *load_tar_archive(struct device *dev,
+						char *tar_filename)
+{
+	struct tar_arch_info_t *tar_arch = NULL;
+	struct tar_blk_t *tar_blk;
+	unsigned int cur_size;
+	size_t tar_offs = 0;
+	size_t tar_size;
+	int ret;
+
+	tar_arch = kzalloc(sizeof(struct tar_arch_info_t), GFP_KERNEL);
+	if (!tar_arch)
+		return NULL;
+
+	INIT_LIST_HEAD(&tar_arch->ucodes);
+
+	/* Load tar archive */
+	ret = request_firmware(&tar_arch->fw, tar_filename, dev);
+	if (ret)
+		goto release_tar_arch;
+
+	if (tar_arch->fw->size < TAR_BLOCK_LEN) {
+		dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+		goto release_tar_arch;
+	}
+
+	tar_size = tar_arch->fw->size;
+	tar_blk = (struct tar_blk_t *) tar_arch->fw->data;
+	if (strncmp(tar_blk->hdr.magic, TAR_MAGIC, TAR_MAGIC_LEN - 1)) {
+		dev_err(dev, "Unsupported format of tar archive %s\n",
+			tar_filename);
+		goto release_tar_arch;
+	}
+
+	while (1) {
+		/* Read current file size */
+		ret = kstrtouint(tar_blk->hdr.size, 8, &cur_size);
+		if (ret)
+			goto release_tar_arch;
+
+		if (tar_offs + cur_size > tar_size ||
+		    tar_offs + 2 * TAR_BLOCK_LEN > tar_size) {
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+			goto release_tar_arch;
+		}
+
+		tar_offs += TAR_BLOCK_LEN;
+		if (tar_blk->hdr.typeflag == REGTYPE ||
+		    tar_blk->hdr.typeflag == AREGTYPE) {
+			ret = process_tar_file(dev, tar_arch,
+					       tar_blk->hdr.name,
+					       &tar_arch->fw->data[tar_offs],
+					       cur_size);
+			if (ret)
+				goto release_tar_arch;
+		}
+
+		tar_offs += (cur_size/TAR_BLOCK_LEN) * TAR_BLOCK_LEN;
+		if (cur_size % TAR_BLOCK_LEN)
+			tar_offs += TAR_BLOCK_LEN;
+
+		/* Check for the end of the archive */
+		if (tar_offs + 2 * TAR_BLOCK_LEN > tar_size) {
+			dev_err(dev, "Invalid tar archive %s\n", tar_filename);
+			goto release_tar_arch;
+		}
+
+		if (is_mem_zero(&tar_arch->fw->data[tar_offs],
+		    2 * TAR_BLOCK_LEN))
+			break;
+
+		/* Read next block from tar archive */
+		tar_blk = (struct tar_blk_t *) &tar_arch->fw->data[tar_offs];
+	}
+
+	print_tar_dbg_info(tar_arch, tar_filename);
+	return tar_arch;
+release_tar_arch:
+	release_tar_archive(tar_arch);
+	return NULL;
+}
+
+static struct otx2_cpt_engs_rsvd *find_engines_by_type(
+					struct otx2_cpt_eng_grp_info *eng_grp,
+					int eng_type)
+{
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!eng_grp->engs[i].type)
+			continue;
+
+		if (eng_grp->engs[i].type == eng_type)
+			return &eng_grp->engs[i];
+	}
+	return NULL;
+}
+
+static int eng_grp_has_eng_type(struct otx2_cpt_eng_grp_info *eng_grp,
+				int eng_type)
+{
+	struct otx2_cpt_engs_rsvd *engs;
+
+	engs = find_engines_by_type(eng_grp, eng_type);
+
+	return (engs != NULL ? 1 : 0);
+}
+
+static int update_engines_avail_count(struct device *dev,
+				      struct otx2_cpt_engs_available *avail,
+				      struct otx2_cpt_engs_rsvd *engs, int val)
+{
+	switch (engs->type) {
+	case OTX2_CPT_SE_TYPES:
+		avail->se_cnt += val;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		avail->ie_cnt += val;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		avail->ae_cnt += val;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", engs->type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int update_engines_offset(struct device *dev,
+				 struct otx2_cpt_engs_available *avail,
+				 struct otx2_cpt_engs_rsvd *engs)
+{
+	switch (engs->type) {
+	case OTX2_CPT_SE_TYPES:
+		engs->offset = 0;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		engs->offset = avail->max_se_cnt;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		engs->offset = avail->max_se_cnt + avail->max_ie_cnt;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", engs->type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int release_engines(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *grp)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!grp->engs[i].type)
+			continue;
+
+		if (grp->engs[i].count > 0) {
+			ret = update_engines_avail_count(dev, &grp->g->avail,
+							 &grp->engs[i],
+							 grp->engs[i].count);
+			if (ret)
+				return ret;
+		}
+
+		grp->engs[i].type = 0;
+		grp->engs[i].count = 0;
+		grp->engs[i].offset = 0;
+		grp->engs[i].ucode = NULL;
+		bitmap_zero(grp->engs[i].bmap, grp->g->engs_num);
+	}
+	return 0;
+}
+
+static int do_reserve_engines(struct device *dev,
+			      struct otx2_cpt_eng_grp_info *grp,
+			      struct otx2_cpt_engines *req_engs)
+{
+	struct otx2_cpt_engs_rsvd *engs = NULL;
+	int i, ret;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!grp->engs[i].type) {
+			engs = &grp->engs[i];
+			break;
+		}
+	}
+
+	if (!engs)
+		return -ENOMEM;
+
+	engs->type = req_engs->type;
+	engs->count = req_engs->count;
+
+	ret = update_engines_offset(dev, &grp->g->avail, engs);
+	if (ret)
+		return ret;
+
+	if (engs->count > 0) {
+		ret = update_engines_avail_count(dev, &grp->g->avail, engs,
+						 -engs->count);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int check_engines_availability(struct device *dev,
+				      struct otx2_cpt_eng_grp_info *grp,
+				      struct otx2_cpt_engines *req_eng)
+{
+	int avail_cnt = 0;
+
+	switch (req_eng->type) {
+	case OTX2_CPT_SE_TYPES:
+		avail_cnt = grp->g->avail.se_cnt;
+		break;
+
+	case OTX2_CPT_IE_TYPES:
+		avail_cnt = grp->g->avail.ie_cnt;
+		break;
+
+	case OTX2_CPT_AE_TYPES:
+		avail_cnt = grp->g->avail.ae_cnt;
+		break;
+
+	default:
+		dev_err(dev, "Invalid engine type %d\n", req_eng->type);
+		return -EINVAL;
+	}
+
+	if (avail_cnt < req_eng->count) {
+		dev_err(dev,
+			"Error available %s engines %d < than requested %d\n",
+			get_eng_type_str(req_eng->type),
+			avail_cnt, req_eng->count);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int reserve_engines(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *grp,
+			   struct otx2_cpt_engines *req_engs, int ucodes_cnt)
+{
+	int i, ret = 0;
+
+	/* Validate if a number of requested engines are available */
+	for (i = 0; i < ucodes_cnt; i++) {
+		ret = check_engines_availability(dev, grp, &req_engs[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* Reserve requested engines for this engine group */
+	for (i = 0; i < ucodes_cnt; i++) {
+		ret = do_reserve_engines(dev, grp, &req_engs[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static void ucode_unload(struct device *dev, struct otx2_cpt_ucode *ucode)
+{
+	if (ucode->va) {
+		dma_free_coherent(dev, ucode->size, ucode->va, ucode->dma);
+		ucode->va = NULL;
+		ucode->dma = 0;
+		ucode->size = 0;
+	}
+
+	memset(&ucode->ver_str, 0, OTX2_CPT_UCODE_VER_STR_SZ);
+	memset(&ucode->ver_num, 0, sizeof(struct otx2_cpt_ucode_ver_num));
+	set_ucode_filename(ucode, "");
+	ucode->type = 0;
+}
+
+static int copy_ucode_to_dma_mem(struct device *dev,
+				 struct otx2_cpt_ucode *ucode,
+				 const u8 *ucode_data)
+{
+	u32 i;
+
+	/*  Allocate DMAable space */
+	ucode->va = dma_alloc_coherent(dev, ucode->size, &ucode->dma,
+				       GFP_KERNEL);
+	if (!ucode->va)
+		return -ENOMEM;
+
+	memcpy(ucode->va, ucode_data + sizeof(struct otx2_cpt_ucode_hdr),
+	       ucode->size);
+
+	/* Byte swap 64-bit */
+	for (i = 0; i < (ucode->size / 8); i++)
+		cpu_to_be64s(&((u64 *)ucode->va)[i]);
+	/*  Ucode needs 16-bit swap */
+	for (i = 0; i < (ucode->size / 2); i++)
+		cpu_to_be16s(&((u16 *)ucode->va)[i]);
+	return 0;
+}
+
+static int enable_eng_grp(struct otx2_cpt_eng_grp_info *eng_grp,
+			  void *obj)
+{
+	int ret;
+
+	/* Point microcode to each core of the group */
+	ret = cpt_set_ucode_base(eng_grp, obj);
+	if (ret)
+		return ret;
+
+	/* Attach the cores to the group and enable them */
+	ret = cpt_attach_and_enable_cores(eng_grp, obj);
+
+	return ret;
+}
+
+static int disable_eng_grp(struct device *dev,
+			   struct otx2_cpt_eng_grp_info *eng_grp,
+			   void *obj)
+{
+	int i, ret;
+
+	/* Disable all engines used by this group */
+	ret = cpt_detach_and_disable_cores(eng_grp, obj);
+	if (ret)
+		return ret;
+
+	/* Unload ucode used by this engine group */
+	ucode_unload(dev, &eng_grp->ucode[0]);
+	ucode_unload(dev, &eng_grp->ucode[1]);
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		if (!eng_grp->engs[i].type)
+			continue;
+
+		eng_grp->engs[i].ucode = &eng_grp->ucode[0];
+	}
+
+	/* Clear UCODE_BASE register for each engine used by this group */
+	ret = cpt_set_ucode_base(eng_grp, obj);
+
+	return ret;
+}
+
+static void setup_eng_grp_mirroring(struct otx2_cpt_eng_grp_info *dst_grp,
+				    struct otx2_cpt_eng_grp_info *src_grp)
+{
+	/* Setup fields for engine group which is mirrored */
+	src_grp->mirror.is_ena = false;
+	src_grp->mirror.idx = 0;
+	src_grp->mirror.ref_count++;
+
+	/* Setup fields for mirroring engine group */
+	dst_grp->mirror.is_ena = true;
+	dst_grp->mirror.idx = src_grp->idx;
+	dst_grp->mirror.ref_count = 0;
+}
+
+static void remove_eng_grp_mirroring(struct otx2_cpt_eng_grp_info *dst_grp)
+{
+	struct otx2_cpt_eng_grp_info *src_grp;
+
+	if (!dst_grp->mirror.is_ena)
+		return;
+
+	src_grp = &dst_grp->g->grp[dst_grp->mirror.idx];
+
+	src_grp->mirror.ref_count--;
+	dst_grp->mirror.is_ena = false;
+	dst_grp->mirror.idx = 0;
+	dst_grp->mirror.ref_count = 0;
+}
+
+static void update_requested_engs(struct otx2_cpt_eng_grp_info *mirror_eng_grp,
+				  struct otx2_cpt_engines *engs, int engs_cnt)
+{
+	struct otx2_cpt_engs_rsvd *mirrored_engs;
+	int i;
+
+	for (i = 0; i < engs_cnt; i++) {
+		mirrored_engs = find_engines_by_type(mirror_eng_grp,
+						     engs[i].type);
+		if (!mirrored_engs)
+			continue;
+
+		/*
+		 * If mirrored group has this type of engines attached then
+		 * there are 3 scenarios possible:
+		 * 1) mirrored_engs.count == engs[i].count then all engines
+		 * from mirrored engine group will be shared with this engine
+		 * group
+		 * 2) mirrored_engs.count > engs[i].count then only a subset of
+		 * engines from mirrored engine group will be shared with this
+		 * engine group
+		 * 3) mirrored_engs.count < engs[i].count then all engines
+		 * from mirrored engine group will be shared with this group
+		 * and additional engines will be reserved for exclusively use
+		 * by this engine group
+		 */
+		engs[i].count -= mirrored_engs->count;
+	}
+}
+
+static struct otx2_cpt_eng_grp_info *find_mirrored_eng_grp(
+					struct otx2_cpt_eng_grp_info *grp)
+{
+	struct otx2_cpt_eng_grps *eng_grps = grp->g;
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		if (!eng_grps->grp[i].is_enabled)
+			continue;
+		if (eng_grps->grp[i].ucode[0].type &&
+		    eng_grps->grp[i].ucode[1].type)
+			continue;
+		if (grp->idx == i)
+			continue;
+		if (!strncasecmp(eng_grps->grp[i].ucode[0].ver_str,
+				 grp->ucode[0].ver_str,
+				 OTX2_CPT_UCODE_VER_STR_SZ))
+			return &eng_grps->grp[i];
+	}
+
+	return NULL;
+}
+
+static struct otx2_cpt_eng_grp_info *find_unused_eng_grp(
+					struct otx2_cpt_eng_grps *eng_grps)
+{
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		if (!eng_grps->grp[i].is_enabled)
+			return &eng_grps->grp[i];
+	}
+	return NULL;
+}
+
+static int eng_grp_update_masks(struct device *dev,
+				struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_engs_rsvd *engs, *mirrored_engs;
+	struct otx2_cpt_bitmap tmp_bmap = { {0} };
+	int i, j, cnt, max_cnt;
+	int bit;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+		if (engs->count <= 0)
+			continue;
+
+		switch (engs->type) {
+		case OTX2_CPT_SE_TYPES:
+			max_cnt = eng_grp->g->avail.max_se_cnt;
+			break;
+
+		case OTX2_CPT_IE_TYPES:
+			max_cnt = eng_grp->g->avail.max_ie_cnt;
+			break;
+
+		case OTX2_CPT_AE_TYPES:
+			max_cnt = eng_grp->g->avail.max_ae_cnt;
+			break;
+
+		default:
+			dev_err(dev, "Invalid engine type %d\n", engs->type);
+			return -EINVAL;
+		}
+
+		cnt = engs->count;
+		WARN_ON(engs->offset + max_cnt > OTX2_CPT_MAX_ENGINES);
+		bitmap_zero(tmp_bmap.bits, eng_grp->g->engs_num);
+		for (j = engs->offset; j < engs->offset + max_cnt; j++) {
+			if (!eng_grp->g->eng_ref_cnt[j]) {
+				bitmap_set(tmp_bmap.bits, j, 1);
+				cnt--;
+				if (!cnt)
+					break;
+			}
+		}
+
+		if (cnt)
+			return -ENOSPC;
+
+		bitmap_copy(engs->bmap, tmp_bmap.bits, eng_grp->g->engs_num);
+	}
+
+	if (!eng_grp->mirror.is_ena)
+		return 0;
+
+	for (i = 0; i < OTX2_CPT_MAX_ETYPES_PER_GRP; i++) {
+		engs = &eng_grp->engs[i];
+		if (!engs->type)
+			continue;
+
+		mirrored_engs = find_engines_by_type(
+					&eng_grp->g->grp[eng_grp->mirror.idx],
+					engs->type);
+		WARN_ON(!mirrored_engs && engs->count <= 0);
+		if (!mirrored_engs)
+			continue;
+
+		bitmap_copy(tmp_bmap.bits, mirrored_engs->bmap,
+			    eng_grp->g->engs_num);
+		if (engs->count < 0) {
+			bit = find_first_bit(mirrored_engs->bmap,
+					     eng_grp->g->engs_num);
+			bitmap_clear(tmp_bmap.bits, bit, -engs->count);
+		}
+		bitmap_or(engs->bmap, engs->bmap, tmp_bmap.bits,
+			  eng_grp->g->engs_num);
+	}
+	return 0;
+}
+
+static int delete_engine_group(struct device *dev,
+			       struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	int ret;
+
+	if (!eng_grp->is_enabled)
+		return 0;
+
+	if (eng_grp->mirror.ref_count)
+		return -EINVAL;
+
+	/* Removing engine group mirroring if enabled */
+	remove_eng_grp_mirroring(eng_grp);
+
+	/* Disable engine group */
+	ret = disable_eng_grp(dev, eng_grp, eng_grp->g->obj);
+	if (ret)
+		return ret;
+
+	/* Release all engines held by this engine group */
+	ret = release_engines(dev, eng_grp);
+	if (ret)
+		return ret;
+
+	eng_grp->is_enabled = false;
+
+	return 0;
+}
+
+static void update_ucode_ptrs(struct otx2_cpt_eng_grp_info *eng_grp)
+{
+	struct otx2_cpt_ucode *ucode;
+
+	if (eng_grp->mirror.is_ena)
+		ucode = &eng_grp->g->grp[eng_grp->mirror.idx].ucode[0];
+	else
+		ucode = &eng_grp->ucode[0];
+	WARN_ON(!eng_grp->engs[0].type);
+	eng_grp->engs[0].ucode = ucode;
+
+	if (eng_grp->engs[1].type) {
+		if (is_2nd_ucode_used(eng_grp))
+			eng_grp->engs[1].ucode = &eng_grp->ucode[1];
+		else
+			eng_grp->engs[1].ucode = ucode;
+	}
+}
+
+static int create_engine_group(struct device *dev,
+			       struct otx2_cpt_eng_grps *eng_grps,
+			       struct otx2_cpt_engines *engs, int ucodes_cnt,
+			       void *ucode_data[], int is_print)
+{
+	struct otx2_cpt_eng_grp_info *mirrored_eng_grp;
+	struct tar_ucode_info_t *tar_ucode_info;
+	struct otx2_cpt_eng_grp_info *eng_grp;
+	int i, ret = 0;
+
+	/* Find engine group which is not used */
+	eng_grp = find_unused_eng_grp(eng_grps);
+	if (!eng_grp) {
+		dev_err(dev, "Error all engine groups are being used\n");
+		return -ENOSPC;
+	}
+	/* Load ucode */
+	for (i = 0; i < ucodes_cnt; i++) {
+		tar_ucode_info = (struct tar_ucode_info_t *) ucode_data[i];
+		eng_grp->ucode[i] = tar_ucode_info->ucode;
+		ret = copy_ucode_to_dma_mem(dev, &eng_grp->ucode[i],
+					    tar_ucode_info->ucode_ptr);
+		if (ret)
+			goto unload_ucode;
+	}
+
+	/* Check if this group mirrors another existing engine group */
+	mirrored_eng_grp = find_mirrored_eng_grp(eng_grp);
+	if (mirrored_eng_grp) {
+		/* Setup mirroring */
+		setup_eng_grp_mirroring(eng_grp, mirrored_eng_grp);
+
+		/*
+		 * Update count of requested engines because some
+		 * of them might be shared with mirrored group
+		 */
+		update_requested_engs(mirrored_eng_grp, engs, ucodes_cnt);
+	}
+	ret = reserve_engines(dev, eng_grp, engs, ucodes_cnt);
+	if (ret)
+		goto unload_ucode;
+
+	/* Update ucode pointers used by engines */
+	update_ucode_ptrs(eng_grp);
+
+	/* Update engine masks used by this group */
+	ret = eng_grp_update_masks(dev, eng_grp);
+	if (ret)
+		goto release_engs;
+
+	/* Enable engine group */
+	ret = enable_eng_grp(eng_grp, eng_grps->obj);
+	if (ret)
+		goto release_engs;
+
+	/*
+	 * If this engine group mirrors another engine group
+	 * then we need to unload ucode as we will use ucode
+	 * from mirrored engine group
+	 */
+	if (eng_grp->mirror.is_ena)
+		ucode_unload(dev, &eng_grp->ucode[0]);
+
+	eng_grp->is_enabled = true;
+
+	if (!is_print)
+		return 0;
+
+	if (mirrored_eng_grp)
+		dev_info(dev,
+			 "Engine_group%d: reuse microcode %s from group %d\n",
+			 eng_grp->idx, mirrored_eng_grp->ucode[0].ver_str,
+			 mirrored_eng_grp->idx);
+	else
+		dev_info(dev, "Engine_group%d: microcode loaded %s\n",
+			 eng_grp->idx, eng_grp->ucode[0].ver_str);
+	if (is_2nd_ucode_used(eng_grp))
+		dev_info(dev, "Engine_group%d: microcode loaded %s\n",
+			 eng_grp->idx, eng_grp->ucode[1].ver_str);
+
+	return 0;
+
+release_engs:
+	release_engines(dev, eng_grp);
+unload_ucode:
+	ucode_unload(dev, &eng_grp->ucode[0]);
+	ucode_unload(dev, &eng_grp->ucode[1]);
+	return ret;
+}
+
+static void delete_engine_grps(struct pci_dev *pdev,
+			       struct otx2_cpt_eng_grps *eng_grps)
+{
+	int i;
+
+	/* First delete all mirroring engine groups */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++)
+		if (eng_grps->grp[i].mirror.is_ena)
+			delete_engine_group(&pdev->dev, &eng_grps->grp[i]);
+
+	/* Delete remaining engine groups */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++)
+		delete_engine_group(&pdev->dev, &eng_grps->grp[i]);
+}
+
+int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type)
+{
+
+	int eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	struct otx2_cpt_eng_grp_info *grp;
+	int i;
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		if (!grp->is_enabled)
+			continue;
+
+		if (eng_type == OTX2_CPT_SE_TYPES) {
+			if (eng_grp_has_eng_type(grp, eng_type) &&
+			    !eng_grp_has_eng_type(grp, OTX2_CPT_IE_TYPES)) {
+				eng_grp_num = i;
+				break;
+			}
+		} else {
+			if (eng_grp_has_eng_type(grp, eng_type)) {
+				eng_grp_num = i;
+				break;
+			}
+		}
+	}
+	return eng_grp_num;
+}
+
+int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
+			     struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct tar_ucode_info_t *tar_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {  };
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	struct tar_arch_info_t *tar_arch = NULL;
+	char tar_filename[OTX2_CPT_NAME_LENGTH];
+	int ret;
+
+	/*
+	 * We don't create engine groups if it was already
+	 * made (when user enabled VFs for the first time)
+	 */
+	if (eng_grps->is_grps_created)
+		return 0;
+
+	sprintf(tar_filename, "cpt%02d-mc.tar", pdev->revision);
+
+	tar_arch = load_tar_archive(&pdev->dev, tar_filename);
+	if (!tar_arch)
+		return -EINVAL;
+
+	/*
+	 * Create engine group with SE engines for kernel
+	 * crypto functionality (symmetric crypto)
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	if (tar_info[0] == NULL) {
+		dev_err(&pdev->dev, "Unable to find SE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto release_tar_arch;
+	}
+	engs[0].type = OTX2_CPT_SE_TYPES;
+	engs[0].count = eng_grps->avail.max_se_cnt;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+				  (void **) tar_info, 1);
+	if (ret)
+		goto release_tar_arch;
+
+	/*
+	 * Create engine group with SE+IE engines for IPSec.
+	 * All SE engines will be shared with engine group 0.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	tar_info[1] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_IE_TYPES);
+
+	if (tar_info[1] == NULL) {
+		dev_err(&pdev->dev, "Unable to find IE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto delete_eng_grp;
+	}
+	engs[0].type = OTX2_CPT_SE_TYPES;
+	engs[0].count = eng_grps->avail.max_se_cnt;
+	engs[1].type = OTX2_CPT_IE_TYPES;
+	engs[1].count = eng_grps->avail.max_ie_cnt;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 2,
+				  (void **) tar_info, 1);
+	if (ret)
+		goto delete_eng_grp;
+
+	/*
+	 * Create engine group with AE engines for asymmetric
+	 * crypto functionality.
+	 */
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_AE_TYPES);
+	if (tar_info[0] == NULL) {
+		dev_err(&pdev->dev, "Unable to find AE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto delete_eng_grp;
+	}
+	engs[0].type = OTX2_CPT_AE_TYPES;
+	engs[0].count = eng_grps->avail.max_ae_cnt;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+				  (void **) tar_info, 1);
+	if (ret)
+		goto delete_eng_grp;
+
+	eng_grps->is_grps_created = true;
+
+	release_tar_archive(tar_arch);
+	return 0;
+
+delete_eng_grp:
+	delete_engine_grps(pdev, eng_grps);
+release_tar_arch:
+	release_tar_archive(tar_arch);
+	return ret;
+}
+
+int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf)
+{
+	int i, ret, busy, total_cores;
+	int timeout = 10;
+	u64 reg = 0;
+
+	total_cores = cptpf->eng_grps.avail.max_se_cnt +
+		      cptpf->eng_grps.avail.max_ie_cnt +
+		      cptpf->eng_grps.avail.max_ae_cnt;
+
+	/* Disengage the cores from groups */
+	for (i = 0; i < total_cores; i++) {
+		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+						CPT_AF_EXEX_CTL2(i), 0x0);
+		if (ret)
+			return ret;
+
+		cptpf->eng_grps.eng_ref_cnt[i] = 0;
+	}
+	ret = otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
+	if (ret)
+		return ret;
+
+	/* Wait for cores to become idle */
+	do {
+		busy = 0;
+		usleep_range(10000, 20000);
+		if (timeout-- < 0)
+			return -EBUSY;
+
+		for (i = 0; i < total_cores; i++) {
+			ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox,
+						   cptpf->pdev,
+						   CPT_AF_EXEX_STS(i), &reg);
+			if (ret)
+				return ret;
+
+			if (reg & 0x1) {
+				busy = 1;
+				break;
+			}
+		}
+	} while (busy);
+
+	/* Disable the cores */
+	for (i = 0; i < total_cores; i++) {
+		ret = otx2_cpt_add_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
+						CPT_AF_EXEX_CTL(i), 0x0);
+		if (ret)
+			return ret;
+	}
+	return otx2_cpt_send_af_reg_requests(&cptpf->afpf_mbox, cptpf->pdev);
+}
+
+void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
+			       struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int i, j;
+
+	delete_engine_grps(pdev, eng_grps);
+	/* Release memory */
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			kfree(grp->engs[j].bmap);
+			grp->engs[j].bmap = NULL;
+		}
+	}
+}
+
+int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
+			   struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct otx2_cpt_eng_grp_info *grp;
+	int i, j, ret;
+
+	eng_grps->obj = pci_get_drvdata(pdev);
+	eng_grps->avail.se_cnt = eng_grps->avail.max_se_cnt;
+	eng_grps->avail.ie_cnt = eng_grps->avail.max_ie_cnt;
+	eng_grps->avail.ae_cnt = eng_grps->avail.max_ae_cnt;
+
+	eng_grps->engs_num = eng_grps->avail.max_se_cnt +
+			     eng_grps->avail.max_ie_cnt +
+			     eng_grps->avail.max_ae_cnt;
+	if (eng_grps->engs_num > OTX2_CPT_MAX_ENGINES) {
+		dev_err(&pdev->dev,
+			"Number of engines %d > than max supported %d\n",
+			eng_grps->engs_num, OTX2_CPT_MAX_ENGINES);
+		ret = -EINVAL;
+		goto cleanup_eng_grps;
+	}
+
+	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
+		grp = &eng_grps->grp[i];
+		grp->g = eng_grps;
+		grp->idx = i;
+
+		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
+			grp->engs[j].bmap =
+				kcalloc(BITS_TO_LONGS(eng_grps->engs_num),
+					sizeof(long), GFP_KERNEL);
+			if (!grp->engs[j].bmap) {
+				ret = -ENOMEM;
+				goto cleanup_eng_grps;
+			}
+		}
+	}
+	return 0;
+cleanup_eng_grps:
+	otx2_cpt_cleanup_eng_grps(pdev, eng_grps);
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
new file mode 100644
index 000000000000..ab7a1461b095
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -0,0 +1,161 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPTPF_UCODE_H
+#define __OTX2_CPTPF_UCODE_H
+
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include "otx2_cpt_hw_types.h"
+#include "otx2_cpt_common.h"
+
+/*
+ * On OcteonTX2 platform IPSec ucode can use both IE and SE engines therefore
+ * IE and SE engines can be attached to the same engine group.
+ */
+#define OTX2_CPT_MAX_ETYPES_PER_GRP 2
+
+/* CPT ucode signature size */
+#define OTX2_CPT_UCODE_SIGN_LEN     256
+
+/* Microcode version string length */
+#define OTX2_CPT_UCODE_VER_STR_SZ   44
+
+/* Maximum number of supported engines/cores on OcteonTX2 platform */
+#define OTX2_CPT_MAX_ENGINES        128
+
+#define OTX2_CPT_ENGS_BITMASK_LEN   BITS_TO_LONGS(OTX2_CPT_MAX_ENGINES)
+
+/* Microcode types */
+enum otx2_cpt_ucode_type {
+	OTX2_CPT_AE_UC_TYPE = 1,  /* AE-MAIN */
+	OTX2_CPT_SE_UC_TYPE1 = 20,/* SE-MAIN - combination of 21 and 22 */
+	OTX2_CPT_SE_UC_TYPE2 = 21,/* Fast Path IPSec + AirCrypto */
+	OTX2_CPT_SE_UC_TYPE3 = 22,/*
+				   * Hash + HMAC + FlexiCrypto + RNG +
+				   * Full Feature IPSec + AirCrypto + Kasumi
+				   */
+	OTX2_CPT_IE_UC_TYPE1 = 30, /* IE-MAIN - combination of 31 and 32 */
+	OTX2_CPT_IE_UC_TYPE2 = 31, /* Fast Path IPSec */
+	OTX2_CPT_IE_UC_TYPE3 = 32, /*
+				    * Hash + HMAC + FlexiCrypto + RNG +
+				    * Full Future IPSec
+				    */
+};
+
+struct otx2_cpt_bitmap {
+	unsigned long bits[OTX2_CPT_ENGS_BITMASK_LEN];
+	int size;
+};
+
+struct otx2_cpt_engines {
+	int type;
+	int count;
+};
+
+/* Microcode version number */
+struct otx2_cpt_ucode_ver_num {
+	u8 nn;
+	u8 xx;
+	u8 yy;
+	u8 zz;
+};
+
+struct otx2_cpt_ucode_hdr {
+	struct otx2_cpt_ucode_ver_num ver_num;
+	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
+	__be32 code_length;
+	u32 padding[3];
+};
+
+struct otx2_cpt_ucode {
+	u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];/*
+					       * ucode version in readable
+					       * format
+					       */
+	struct otx2_cpt_ucode_ver_num ver_num;/* ucode version number */
+	char filename[OTX2_CPT_NAME_LENGTH];/* ucode filename */
+	dma_addr_t dma;		/* phys address of ucode image */
+	void *va;		/* virt address of ucode image */
+	u32 size;		/* ucode image size */
+	int type;		/* ucode image type SE, IE, AE or SE+IE */
+};
+
+struct tar_ucode_info_t {
+	struct list_head list;
+	struct otx2_cpt_ucode ucode;/* microcode information */
+	const u8 *ucode_ptr;	/* pointer to microcode in tar archive */
+};
+
+/* Maximum and current number of engines available for all engine groups */
+struct otx2_cpt_engs_available {
+	int max_se_cnt;
+	int max_ie_cnt;
+	int max_ae_cnt;
+	int se_cnt;
+	int ie_cnt;
+	int ae_cnt;
+};
+
+/* Engines reserved to an engine group */
+struct otx2_cpt_engs_rsvd {
+	int type;	/* engine type */
+	int count;	/* number of engines attached */
+	int offset;     /* constant offset of engine type in the bitmap */
+	unsigned long *bmap;		/* attached engines bitmap */
+	struct otx2_cpt_ucode *ucode;	/* ucode used by these engines */
+};
+
+struct otx2_cpt_mirror_info {
+	int is_ena;	/*
+			 * is mirroring enabled, it is set only for engine
+			 * group which mirrors another engine group
+			 */
+	int idx;	/*
+			 * index of engine group which is mirrored by this
+			 * group, set only for engine group which mirrors
+			 * another group
+			 */
+	int ref_count;	/*
+			 * number of times this engine group is mirrored by
+			 * other groups, this is set only for engine group
+			 * which is mirrored by other group(s)
+			 */
+};
+
+struct otx2_cpt_eng_grp_info {
+	struct otx2_cpt_eng_grps *g; /* pointer to engine_groups structure */
+	/* engines attached */
+	struct otx2_cpt_engs_rsvd engs[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	/* ucodes information */
+	struct otx2_cpt_ucode ucode[OTX2_CPT_MAX_ETYPES_PER_GRP];
+	/* engine group mirroring information */
+	struct otx2_cpt_mirror_info mirror;
+	int idx;	 /* engine group index */
+	bool is_enabled; /*
+			  * is engine group enabled, engine group is enabled
+			  * when it has engines attached and ucode loaded
+			  */
+};
+
+struct otx2_cpt_eng_grps {
+	struct otx2_cpt_eng_grp_info grp[OTX2_CPT_MAX_ENGINE_GROUPS];
+	struct otx2_cpt_engs_available avail;
+	void *obj;			/* device specific data */
+	int engs_num;			/* total number of engines supported */
+	u8 eng_ref_cnt[OTX2_CPT_MAX_ENGINES];/* engines reference count */
+	bool is_grps_created; /* Is the engine groups are already created */
+};
+struct otx2_cptpf_dev;
+int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
+			   struct otx2_cpt_eng_grps *eng_grps);
+void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
+			       struct otx2_cpt_eng_grps *eng_grps);
+int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
+			     struct otx2_cpt_eng_grps *eng_grps);
+int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
+int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type);
+
+#endif /* __OTX2_CPTPF_UCODE_H */
-- 
2.28.0

