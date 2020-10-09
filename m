Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC6B288CDE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389402AbgJIPf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:35:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389388AbgJIPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:35:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUPx1019588;
        Fri, 9 Oct 2020 08:35:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=28sMbhRLbOAZCDYEg3zth3nuQEtnHekgQ0LlNdXqzwY=;
 b=MFw5uZ3JTaCyc8tB9/4ArGPIBjWRvueGPeUd1ofydXC4XQXFi5p5iYlArdCHHkU3sF9Q
 7zL685RQRFLcx1CuoVtIIW/xdjivSEjs9X7lc5YQ9ArAi30S1TlcQYk8blMTkfDpiaZe
 y5/ZHnsdGUph/czaILJHo3H+yUDPgC6S4o4TCI6/9RZsJmvtb4KUskF8KH1Ly9r/ssVA
 fMpNpJRcKB6T1O7KhZ2WA0rth9WiWk+t9eY0okUAJoQcfIi4Uq3d5Jkmccz2/NNpVG9A
 wLgTD4Dw3w4YHL4m32w/9XaduwiuBV4O+VnhqxLH12uS9qQYVOoWHMrncOmNOLI+8Y2u Fg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3429h8bbw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:35:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:35:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:35:52 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 5F4B23F703F;
        Fri,  9 Oct 2020 08:35:49 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,09/13] crypto: octeontx2: add support to get engine capabilities
Date:   Fri, 9 Oct 2020 21:04:17 +0530
Message-ID: <20201009153421.30562-10-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support to get engine capabilities and adds a new mailbox
to share the engine capabilities to CPT VFIO drivers.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cpt_common.h       |  36 ++++
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  51 ++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  62 +++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   3 +
 .../marvell/octeontx2/otx2_cptpf_main.c       |   5 +
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  31 ++++
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 165 ++++++++++++++++++
 .../marvell/octeontx2/otx2_cptpf_ucode.h      |   1 +
 8 files changed, 354 insertions(+)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index d5576f5d3b90..705a0503b962 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -20,6 +20,7 @@
 
 #define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
 #define OTX2_CPT_NAME_LENGTH 64
+#define OTX2_CPT_DMA_MINALIGN 128
 
 #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
 
@@ -32,6 +33,7 @@ enum otx2_cpt_eng_type {
 
 /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
 #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
+#define MBOX_MSG_GET_CAPS               0xBFD
 
 /*
  * Message request and response to get engine group number
@@ -49,6 +51,40 @@ struct otx2_cpt_egrp_num_rsp {
 	u8 eng_grp_num;
 };
 
+/* CPT HW capabilities */
+union otx2_cpt_eng_caps {
+	u64 u;
+	struct {
+		u64 reserved_0_4:5;
+		u64 mul:1;
+		u64 sha1_sha2:1;
+		u64 chacha20:1;
+		u64 zuc_snow3g:1;
+		u64 sha3:1;
+		u64 aes:1;
+		u64 kasumi:1;
+		u64 des:1;
+		u64 crc:1;
+		u64 reserved_14_63:50;
+	};
+};
+
+/*
+ * Message request and response to get HW capabilities for each
+ * engine type (SE, IE, AE).
+ * This messages are only used between CPT PF <=> CPT VF
+ */
+struct otx2_cpt_caps_msg {
+	struct mbox_msghdr hdr;
+};
+
+struct otx2_cpt_caps_rsp {
+	struct mbox_msghdr hdr;
+	u16 cpt_pf_drv_version;
+	u8 cpt_revision;
+	union otx2_cpt_eng_caps eng_caps[OTX2_CPT_MAX_ENG_TYPES];
+};
+
 static inline void otx2_cpt_write64(void __iomem *reg_base, u64 blk, u64 slot,
 				    u64 offs, u64 val)
 {
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
new file mode 100644
index 000000000000..9184f91c68c1
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_REQMGR_H
+#define __OTX2_CPT_REQMGR_H
+
+#include "otx2_cpt_common.h"
+
+/* Completion code size and initial value */
+#define OTX2_CPT_COMPLETION_CODE_SIZE 8
+#define OTX2_CPT_COMPLETION_CODE_INIT OTX2_CPT_COMP_E_NOTDONE
+
+union otx2_cpt_opcode {
+	u16 flags;
+	struct {
+		u8 major;
+		u8 minor;
+	} s;
+};
+
+/*
+ * CPT_INST_S software command definitions
+ * Words EI (0-3)
+ */
+union otx2_cpt_iq_cmd_word0 {
+	u64 u;
+	struct {
+		__be16 opcode;
+		__be16 param1;
+		__be16 param2;
+		__be16 dlen;
+	} s;
+};
+
+union otx2_cpt_iq_cmd_word3 {
+	u64 u;
+	struct {
+		u64 cptr:61;
+		u64 grp:3;
+	} s;
+};
+
+struct otx2_cpt_iq_command {
+	union otx2_cpt_iq_cmd_word0 cmd;
+	u64 dptr;
+	u64 rptr;
+	union otx2_cpt_iq_cmd_word3 cptr;
+};
+
+#endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index be1315ddfb7b..edf404f039cf 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -4,9 +4,11 @@
 #ifndef __OTX2_CPTLF_H
 #define __OTX2_CPTLF_H
 
+#include <linux/soc/marvell/octeontx2/asm.h>
 #include <mbox.h>
 #include <rvu.h>
 #include "otx2_cpt_common.h"
+#include "otx2_cpt_reqmgr.h"
 
 /*
  * CPT instruction and pending queues user requested length in CPT_INST_S msgs
@@ -271,6 +273,66 @@ static inline void otx2_cptlf_enable_iqueues(struct otx2_cptlfs_info *lfs)
 	}
 }
 
+static inline void otx2_cpt_fill_inst(union otx2_cpt_inst_s *cptinst,
+				      struct otx2_cpt_iq_command *iq_cmd,
+				      u64 comp_baddr)
+{
+	cptinst->u[0] = 0x0;
+	cptinst->s.doneint = true;
+	cptinst->s.res_addr = comp_baddr;
+	cptinst->u[2] = 0x0;
+	cptinst->u[3] = 0x0;
+	cptinst->s.ei0 = iq_cmd->cmd.u;
+	cptinst->s.ei1 = iq_cmd->dptr;
+	cptinst->s.ei2 = iq_cmd->rptr;
+	cptinst->s.ei3 = iq_cmd->cptr.u;
+}
+
+/*
+ * On OcteonTX2 platform the parameter insts_num is used as a count of
+ * instructions to be enqueued. The valid values for insts_num are:
+ * 1 - 1 CPT instruction will be enqueued during LMTST operation
+ * 2 - 2 CPT instructions will be enqueued during LMTST operation
+ */
+static inline void otx2_cpt_send_cmd(union otx2_cpt_inst_s *cptinst,
+				     u32 insts_num, struct otx2_cptlf_info *lf)
+{
+	void __iomem *lmtline = lf->lmtline;
+	long ret;
+
+	/*
+	 * Make sure memory areas pointed in CPT_INST_S
+	 * are flushed before the instruction is sent to CPT
+	 */
+	dma_wmb();
+
+	do {
+		/* Copy CPT command to LMTLINE */
+		memcpy_toio(lmtline, cptinst, insts_num * OTX2_CPT_INST_SIZE);
+
+		/*
+		 * LDEOR initiates atomic transfer to I/O device
+		 * The following will cause the LMTST to fail (the LDEOR
+		 * returns zero):
+		 * - No stores have been performed to the LMTLINE since it was
+		 * last invalidated.
+		 * - The bytes which have been stored to LMTLINE since it was
+		 * last invalidated form a pattern that is non-contiguous, does
+		 * not start at byte 0, or does not end on a 8-byte boundary.
+		 * (i.e.comprises a formation of other than 1–16 8-byte
+		 * words.)
+		 *
+		 * These rules are designed such that an operating system
+		 * context switch or hypervisor guest switch need have no
+		 * knowledge of the LMTST operations; the switch code does not
+		 * need to store to LMTCANCEL. Also note as LMTLINE data cannot
+		 * be read, there is no information leakage between processes.
+		 */
+		ret = otx2_lmt_flush(lf->ioreg);
+
+	} while (!ret);
+}
+
 int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_msk, int pri,
 		    int lfs_num);
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
index 15561fe50bc0..fabe9fd33ee7 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf.h
@@ -26,6 +26,9 @@ struct otx2_cptpf_dev {
 	struct otx2_cptvf_info vf[OTX2_CPT_MAX_VFS_NUM];
 	struct otx2_cpt_eng_grps eng_grps;/* Engine groups information */
 	struct otx2_cptlfs_info lfs;      /* CPT LFs attached to this PF */
+	/* HW capabilities for each engine type */
+	union otx2_cpt_eng_caps eng_caps[OTX2_CPT_MAX_ENG_TYPES];
+	bool is_eng_caps_discovered;
 
 	/* AF <=> PF mbox */
 	struct otx2_mbox	afpf_mbox;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index b1bd2e668898..548bf614dda5 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -319,6 +319,11 @@ static int cptpf_sriov_enable(struct pci_dev *pdev, int numvfs)
 	if (ret)
 		goto free_mbox;
 
+	/* Get CPT HW capabilities using LOAD_FVC operation. */
+	ret = otx2_cpt_discover_eng_capabilities(cptpf);
+	if (ret)
+		goto disable_intr;
+
 	ret = otx2_cpt_create_eng_grps(cptpf->pdev, &cptpf->eng_grps);
 	if (ret)
 		goto disable_intr;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index c9bb6b14876c..c273e6a2a3b7 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -5,6 +5,12 @@
 #include "otx2_cptpf.h"
 #include "rvu_reg.h"
 
+/*
+ * CPT PF driver version, It will be incremented by 1 for every feature
+ * addition in CPT mailbox messages.
+ */
+#define OTX2_CPT_PF_DRV_VERSION 0x1
+
 static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 			 struct otx2_cptvf_info *vf,
 			 struct mbox_msghdr *req, int size)
@@ -35,6 +41,28 @@ static int forward_to_af(struct otx2_cptpf_dev *cptpf,
 	return 0;
 }
 
+static int handle_msg_get_caps(struct otx2_cptpf_dev *cptpf,
+			       struct otx2_cptvf_info *vf,
+			       struct mbox_msghdr *req)
+{
+	struct otx2_cpt_caps_rsp *rsp;
+
+	rsp = (struct otx2_cpt_caps_rsp *)
+	      otx2_mbox_alloc_msg(&cptpf->vfpf_mbox, vf->vf_id,
+				  sizeof(*rsp));
+	if (!rsp)
+		return -ENOMEM;
+
+	rsp->hdr.id = MBOX_MSG_GET_CAPS;
+	rsp->hdr.sig = OTX2_MBOX_RSP_SIG;
+	rsp->hdr.pcifunc = req->pcifunc;
+	rsp->cpt_pf_drv_version = OTX2_CPT_PF_DRV_VERSION;
+	rsp->cpt_revision = cptpf->pdev->revision;
+	memcpy(&rsp->eng_caps, &cptpf->eng_caps, sizeof(rsp->eng_caps));
+
+	return 0;
+}
+
 static int handle_msg_get_eng_grp_num(struct otx2_cptpf_dev *cptpf,
 				      struct otx2_cptvf_info *vf,
 				      struct mbox_msghdr *req)
@@ -72,6 +100,9 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
 	case MBOX_MSG_GET_ENG_GRP_NUM:
 		err = handle_msg_get_eng_grp_num(cptpf, vf, req);
 		break;
+	case MBOX_MSG_GET_CAPS:
+		err = handle_msg_get_caps(cptpf, vf, req);
+		break;
 	default:
 		err = forward_to_af(cptpf, vf, req, size);
 		break;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 190937b6515b..f6223673b60f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -6,6 +6,8 @@
 #include "otx2_cptpf_ucode.h"
 #include "otx2_cpt_common.h"
 #include "otx2_cptpf.h"
+#include "otx2_cptlf.h"
+#include "otx2_cpt_reqmgr.h"
 #include "rvu_reg.h"
 
 #define CSR_DELAY 30
@@ -1366,3 +1368,166 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 	otx2_cpt_cleanup_eng_grps(pdev, eng_grps);
 	return ret;
 }
+
+static int create_eng_caps_discovery_grps(struct pci_dev *pdev,
+					  struct otx2_cpt_eng_grps *eng_grps)
+{
+	struct tar_ucode_info_t *tar_info[OTX2_CPT_MAX_ETYPES_PER_GRP] = {  };
+	struct otx2_cpt_engines engs[OTX2_CPT_MAX_ETYPES_PER_GRP] = { {0} };
+	struct tar_arch_info_t *tar_arch = NULL;
+	char tar_filename[OTX2_CPT_NAME_LENGTH];
+	int ret = -EINVAL;
+
+	sprintf(tar_filename, "cpt%02d-mc.tar", pdev->revision);
+	tar_arch = load_tar_archive(&pdev->dev, tar_filename);
+	if (!tar_arch)
+		return -EINVAL;
+
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_AE_TYPES);
+	if (tar_info[0] == NULL) {
+		dev_err(&pdev->dev, "Unable to find AE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto release_tar;
+	}
+	engs[0].type = OTX2_CPT_AE_TYPES;
+	engs[0].count = 2;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+				  (void **) tar_info, 0);
+	if (ret)
+		goto release_tar;
+
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_SE_TYPES);
+	if (tar_info[0] == NULL) {
+		dev_err(&pdev->dev, "Unable to find SE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto delete_eng_grp;
+	}
+	engs[0].type = OTX2_CPT_SE_TYPES;
+	engs[0].count = 2;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+				  (void **) tar_info, 0);
+	if (ret)
+		goto delete_eng_grp;
+
+	tar_info[0] = get_uc_from_tar_archive(tar_arch, OTX2_CPT_IE_TYPES);
+	if (tar_info[0] == NULL) {
+		dev_err(&pdev->dev, "Unable to find AE firmware in %s\n",
+			tar_filename);
+		ret = -EINVAL;
+		goto delete_eng_grp;
+	}
+	engs[0].type = OTX2_CPT_IE_TYPES;
+	engs[0].count = 2;
+
+	ret = create_engine_group(&pdev->dev, eng_grps, engs, 1,
+				  (void **) tar_info, 0);
+	if (ret)
+		goto delete_eng_grp;
+
+	release_tar_archive(tar_arch);
+	return 0;
+
+delete_eng_grp:
+	delete_engine_grps(pdev, eng_grps);
+release_tar:
+	release_tar_archive(tar_arch);
+	return ret;
+}
+
+/*
+ * Get CPT HW capabilities using LOAD_FVC operation.
+ */
+int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
+{
+	struct otx2_cptlfs_info *lfs = &cptpf->lfs;
+	struct otx2_cpt_iq_command iq_cmd;
+	union otx2_cpt_opcode opcode;
+	union otx2_cpt_res_s *result;
+	union otx2_cpt_inst_s inst;
+	dma_addr_t rptr_baddr;
+	struct pci_dev *pdev;
+	u32 len, compl_rlen;
+	int ret, etype;
+	void *rptr;
+
+	/*
+	 * We don't get capabilities if it was already done
+	 * (when user enabled VFs for the first time)
+	 */
+	if (cptpf->is_eng_caps_discovered)
+		return 0;
+
+	pdev = cptpf->pdev;
+	/*
+	 * Create engine groups for each type to submit LOAD_FVC op and
+	 * get engine's capabilities.
+	 */
+	ret = create_eng_caps_discovery_grps(pdev, &cptpf->eng_grps);
+	if (ret)
+		goto delete_grps;
+
+	lfs->pdev = pdev;
+	lfs->reg_base = cptpf->reg_base;
+	lfs->mbox = &cptpf->afpf_mbox;
+	ret = otx2_cptlf_init(&cptpf->lfs, OTX2_CPT_ALL_ENG_GRPS_MASK,
+			      OTX2_CPT_QUEUE_HI_PRIO, 1);
+	if (ret)
+		goto delete_grps;
+
+	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
+	len = compl_rlen + LOADFVC_RLEN;
+
+	result = kzalloc(len, GFP_KERNEL);
+	if (!result) {
+		ret = -ENOMEM;
+		goto lf_cleanup;
+	}
+	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
+				    DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
+		dev_err(&pdev->dev, "DMA mapping failed\n");
+		ret = -EFAULT;
+		goto free_result;
+	}
+	rptr = (u8 *)result + compl_rlen;
+
+	/* Fill in the command */
+	opcode.s.major = LOADFVC_MAJOR_OP;
+	opcode.s.minor = LOADFVC_MINOR_OP;
+
+	iq_cmd.cmd.u = 0;
+	iq_cmd.cmd.s.opcode = cpu_to_be16(opcode.flags);
+
+	/* 64-bit swap for microcode data reads, not needed for addresses */
+	cpu_to_be64s(&iq_cmd.cmd.u);
+	iq_cmd.dptr = 0;
+	iq_cmd.rptr = rptr_baddr + compl_rlen;
+	iq_cmd.cptr.u = 0;
+
+	for (etype = 1; etype < OTX2_CPT_MAX_ENG_TYPES; etype++) {
+		result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
+		iq_cmd.cptr.s.grp = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
+							 etype);
+		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
+		otx2_cpt_send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+
+		while (result->s.compcode == OTX2_CPT_COMPLETION_CODE_INIT)
+			cpu_relax();
+
+		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
+	}
+	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
+	cptpf->is_eng_caps_discovered = true;
+free_result:
+	kzfree(result);
+lf_cleanup:
+	otx2_cptlf_shutdown(&cptpf->lfs);
+delete_grps:
+	delete_engine_grps(pdev, &cptpf->eng_grps);
+
+	return ret;
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
index ab7a1461b095..2decbf2f1e4a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
@@ -157,5 +157,6 @@ int otx2_cpt_create_eng_grps(struct pci_dev *pdev,
 			     struct otx2_cpt_eng_grps *eng_grps);
 int otx2_cpt_disable_all_cores(struct otx2_cptpf_dev *cptpf);
 int otx2_cpt_get_eng_grp(struct otx2_cpt_eng_grps *eng_grps, int eng_type);
+int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf);
 
 #endif /* __OTX2_CPTPF_UCODE_H */
-- 
2.28.0

