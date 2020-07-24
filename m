Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2341322C5C0
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXNIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:08:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39104 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726182AbgGXNIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:08:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06OD52IN002527;
        Fri, 24 Jul 2020 06:08:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=RuqpEt43AvGZTQI/qikAjkCh/bboGYzDJkZ1VuPTKeI=;
 b=mcT2y7oMGjpX2f0IdRe17y1xAIfFkLk2VGmqSqYVauvaUNQgm8AZ/8393gQAC9ylv9yo
 5ggasmezbkaxRTHdEi/I/uilOJTf82BRw3gNYc6S9TQ0Lbjw4djrf4e9wuAUfRByhaou
 8jEnCwV7OEIxcmZZLOeTsoHA29zE/V1dEYQYiRgk1lHmIxQY6tSqXIhywRj4tJ/XlHIp
 R8Uk9gEsl2tuMTa54YyeUYJ24cJUezapANXfV/IR++QiLQbOoh6J/v0KhB048iNKz89Z
 rB1u9ptVcFGl5XDg0NE/jFrp1EMC3X5zTgKv43d3wvqPiKbF8YHwj6mXkTgDaEAbezbR NQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxep2sk1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 06:08:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 06:08:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jul 2020 06:08:38 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 409423F703F;
        Fri, 24 Jul 2020 06:08:36 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <schandran@marvell.com>,
        <pathreya@marvell.com>, <sgoutham@marvell.com>,
        Srujana Challa <schalla@marvell.com>
Subject: [PATCH 1/4] octeontx2-af: add support to manage the CPT unit
Date:   Fri, 24 Jul 2020 18:38:01 +0530
Message-ID: <1595596084-29809-2-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1595596084-29809-1-git-send-email-schalla@marvell.com>
References: <1595596084-29809-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_04:2020-07-24,2020-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Admin function (AF) manages hardware resources on the cryptographic
acceleration unit(CPT). This patch adds a mailbox interface for PFs and
VFs to configure hardware resources for cryptography and inline-ipsec.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  85 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   7 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    | 343 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 342 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  76 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  65 +++-
 8 files changed, 914 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 1b25948..2f2efef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o rvu_cpt.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6dfd0f9..4ec2ec7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -154,6 +154,13 @@ static inline struct mbox_msghdr *otx2_mbox_alloc_msg(struct otx2_mbox *mbox,
 /* SSO/SSOW mbox IDs (range 0x600 - 0x7FF) */				\
 /* TIM mbox IDs (range 0x800 - 0x9FF) */				\
 /* CPT mbox IDs (range 0xA00 - 0xBFF) */				\
+M(CPT_LF_ALLOC,		0xA00, cpt_lf_alloc, cpt_lf_alloc_req_msg,	\
+			       msg_rsp)			\
+M(CPT_LF_FREE,		0xA01, cpt_lf_free, msg_req, msg_rsp)		\
+M(CPT_RD_WR_REGISTER,	0xA02, cpt_rd_wr_register,  cpt_rd_wr_reg_msg,	\
+			       cpt_rd_wr_reg_msg)			\
+M(CPT_INLINE_IPSEC_CFG,	0xA04, cpt_inline_ipsec_cfg,			\
+			       cpt_inline_ipsec_cfg_msg, msg_rsp)	\
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
 M(NPC_MCAM_ALLOC_ENTRY,	0x6000, npc_mcam_alloc_entry, npc_mcam_alloc_entry_req,\
 				npc_mcam_alloc_entry_rsp)		\
@@ -217,6 +224,10 @@ static inline struct mbox_msghdr *otx2_mbox_alloc_msg(struct otx2_mbox *mbox,
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
+M(NIX_INLINE_IPSEC_CFG, 0x8019, nix_inline_ipsec_cfg,			\
+				nix_inline_ipsec_cfg, msg_rsp)		\
+M(NIX_INLINE_IPSEC_LF_CFG, 0x801a, nix_inline_ipsec_lf_cfg,		\
+				nix_inline_ipsec_lf_cfg, msg_rsp)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -710,6 +721,38 @@ struct nix_bp_cfg_rsp {
 	u8	chan_cnt; /* Number of channel for which bpids are assigned */
 };
 
+/* Global NIX inline IPSec configuration */
+struct nix_inline_ipsec_cfg {
+	struct mbox_msghdr hdr;
+	u32 cpt_credit;
+	struct {
+		u8 egrp;
+		u8 opcode;
+	} gen_cfg;
+	struct {
+		u16 cpt_pf_func;
+		u8 cpt_slot;
+	} inst_qsel;
+	u8 enable;
+};
+
+/* Per NIX LF inline IPSec configuration */
+struct nix_inline_ipsec_lf_cfg {
+	struct mbox_msghdr hdr;
+	u64 sa_base_addr;
+	struct {
+		u32 tag_const;
+		u16 lenm1_max;
+		u8 sa_pow2_size;
+		u8 tt;
+	} ipsec_cfg0;
+	struct {
+		u32 sa_idx_max;
+		u8 sa_idx_w;
+	} ipsec_cfg1;
+	u8 enable;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
@@ -858,4 +901,46 @@ struct npc_get_kex_cfg_rsp {
 	u8 mkex_pfl_name[MKEX_NAME_LEN];
 };
 
+/* CPT mailbox error codes
+ * Range 901 - 1000.
+ */
+enum cpt_af_status {
+	CPT_AF_ERR_PARAM		= -901,
+	CPT_AF_ERR_GRP_INVALID		= -902,
+	CPT_AF_ERR_LF_INVALID		= -903,
+	CPT_AF_ERR_ACCESS_DENIED	= -904,
+	CPT_AF_ERR_SSO_PF_FUNC_INVALID	= -905,
+	CPT_AF_ERR_NIX_PF_FUNC_INVALID	= -906,
+	CPT_AF_ERR_INLINE_IPSEC_INB_ENA	= -907,
+	CPT_AF_ERR_INLINE_IPSEC_OUT_ENA	= -908
+};
+
+/* CPT mbox message formats */
+struct cpt_rd_wr_reg_msg {
+	struct mbox_msghdr hdr;
+	u64 reg_offset;
+	u64 *ret_val;
+	u64 val;
+	u8 is_write;
+};
+
+struct cpt_lf_alloc_req_msg {
+	struct mbox_msghdr hdr;
+	u16 nix_pf_func;
+	u16 sso_pf_func;
+	u16 eng_grpmsk;
+};
+
+#define CPT_INLINE_INBOUND      0
+#define CPT_INLINE_OUTBOUND     1
+struct cpt_inline_ipsec_cfg_msg {
+	struct mbox_msghdr hdr;
+	u8 enable;
+	u8 slot;
+	u8 dir;
+	u8 sso_pf_func_ovrd;
+	u16 sso_pf_func; /* inbound path SSO_PF_FUNC */
+	u16 nix_pf_func; /* outbound path NIX_PF_FUNC */
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 557e429..b3111c0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1022,7 +1022,7 @@ int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 /* Get current count of a RVU block's LF/slots
  * provisioned to a given RVU func.
  */
-static u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype)
 {
 	switch (blktype) {
 	case BLKTYPE_NPA:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a0..f057825 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -42,6 +42,10 @@ struct dump_ctx {
 	bool	all;
 };
 
+struct cpt_dump_ctx {
+	char    e_type[NAME_SIZE];
+};
+
 struct rvu_debugfs {
 	struct dentry *root;
 	struct dentry *cgx_root;
@@ -50,11 +54,13 @@ struct rvu_debugfs {
 	struct dentry *npa;
 	struct dentry *nix;
 	struct dentry *npc;
+	struct dentry *cpt;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
 	struct dump_ctx nix_rq_ctx;
 	struct dump_ctx nix_sq_ctx;
+	struct cpt_dump_ctx cpt_ctx;
 	int npa_qsize_id;
 	int nix_qsize_id;
 };
@@ -408,6 +414,7 @@ static inline bool is_rvu_fwdata_valid(struct rvu *rvu)
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
 int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc);
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero);
+u16 rvu_get_rsrc_mapcount(struct rvu_pfvf *pfvf, int blktype);
 
 /* RVU HW reg validation */
 enum regmap_block {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
new file mode 100644
index 0000000..3a41767
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <linux/pci.h>
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "mbox.h"
+#include "rvu.h"
+
+/* CPT PF device id */
+#define	PCI_DEVID_OTX2_CPT_PF	0xA0FD
+
+/* Maximum supported microcode groups */
+#define CPT_MAX_ENGINE_GROUPS	8
+
+static int get_cpt_pf_num(struct rvu *rvu)
+{
+	int i, domain_nr, cpt_pf_num = -1;
+	struct pci_dev *pdev;
+
+	domain_nr = pci_domain_nr(rvu->pdev->bus);
+	for (i = 0; i < rvu->hw->total_pfs; i++) {
+		pdev = pci_get_domain_bus_and_slot(domain_nr, i + 1, 0);
+		if (!pdev)
+			continue;
+
+		if (pdev->device == PCI_DEVID_OTX2_CPT_PF) {
+			cpt_pf_num = i;
+			put_device(&pdev->dev);
+			break;
+		}
+		put_device(&pdev->dev);
+	}
+	return cpt_pf_num;
+}
+
+static bool is_cpt_pf(struct rvu *rvu, u16 pcifunc)
+{
+	int cpt_pf_num = get_cpt_pf_num(rvu);
+
+	if (rvu_get_pf(pcifunc) != cpt_pf_num)
+		return false;
+	if (pcifunc & RVU_PFVF_FUNC_MASK)
+		return false;
+
+	return true;
+}
+
+static bool is_cpt_vf(struct rvu *rvu, u16 pcifunc)
+{
+	int cpt_pf_num = get_cpt_pf_num(rvu);
+
+	if (rvu_get_pf(pcifunc) != cpt_pf_num)
+		return false;
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
+		return false;
+
+	return true;
+}
+
+int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
+				  struct cpt_lf_alloc_req_msg *req,
+				  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr;
+	int num_lfs, slot;
+	u64 val;
+
+	if (req->eng_grpmsk == 0x0)
+		return CPT_AF_ERR_GRP_INVALID;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->type);
+	if (!num_lfs)
+		return CPT_AF_ERR_LF_INVALID;
+
+	/* Check if requested 'CPTLF <=> NIXLF' mapping is valid */
+	if (req->nix_pf_func) {
+		/* If default, use 'this' CPTLF's PFFUNC */
+		if (req->nix_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->nix_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->nix_pf_func, BLKTYPE_NIX))
+			return CPT_AF_ERR_NIX_PF_FUNC_INVALID;
+	}
+
+	/* Check if requested 'CPTLF <=> SSOLF' mapping is valid */
+	if (req->sso_pf_func) {
+		/* If default, use 'this' CPTLF's PFFUNC */
+		if (req->sso_pf_func == RVU_DEFAULT_PF_FUNC)
+			req->sso_pf_func = pcifunc;
+		if (!is_pffunc_map_valid(rvu, req->sso_pf_func, BLKTYPE_SSO))
+			return CPT_AF_ERR_SSO_PF_FUNC_INVALID;
+	}
+
+	for (slot = 0; slot < num_lfs; slot++) {
+		cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+		if (cptlf < 0)
+			return CPT_AF_ERR_LF_INVALID;
+
+		/* Set CPT LF group and priority */
+		val = (u64)req->eng_grpmsk << 48 | 1;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
+
+		/* Set CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
+		val = (u64)req->nix_pf_func << 48 |
+		      (u64)req->sso_pf_func << 32;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), val);
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
+				 struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr;
+	int num_lfs, slot;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->type);
+	if (!num_lfs)
+		return CPT_AF_ERR_LF_INVALID;
+
+	for (slot = 0; slot < num_lfs; slot++) {
+		cptlf = rvu_get_lf(rvu, block, pcifunc, slot);
+		if (cptlf < 0)
+			return CPT_AF_ERR_LF_INVALID;
+
+		/* Reset CPT LF group and priority */
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), 0x0);
+		/* Reset CPT LF NIX_PF_FUNC and SSO_PF_FUNC */
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), 0x0);
+	}
+
+	return 0;
+}
+
+static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
+					struct cpt_inline_ipsec_cfg_msg *req)
+{
+	u16 sso_pf_func = req->sso_pf_func;
+	u64 val;
+
+	val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	if (req->enable && (val & BIT_ULL(16))) {
+		/* IPSec inline outbound path is already enabled for a given
+		 * CPT LF, HRM states that inline inbound & outbound paths
+		 * must not be enabled at the same time for a given CPT LF
+		 */
+		return CPT_AF_ERR_INLINE_IPSEC_INB_ENA;
+	}
+	/* Check if requested 'CPTLF <=> SSOLF' mapping is valid */
+	if (sso_pf_func && !is_pffunc_map_valid(rvu, sso_pf_func, BLKTYPE_SSO))
+		return CPT_AF_ERR_SSO_PF_FUNC_INVALID;
+
+	/* Set PF_FUNC_INST */
+	if (req->enable)
+		val |= BIT_ULL(9);
+	else
+		val &= ~BIT_ULL(9);
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
+
+	if (sso_pf_func) {
+		/* Set SSO_PF_FUNC */
+		val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+		val |= (u64)sso_pf_func << 32;
+		val |= (u64)req->nix_pf_func << 48;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), val);
+	}
+	if (req->sso_pf_func_ovrd)
+		/* Set SSO_PF_FUNC_OVRD for inline IPSec */
+		rvu_write64(rvu, blkaddr, CPT_AF_ECO, 0x1);
+
+	return 0;
+}
+
+static int cpt_inline_ipsec_cfg_outbound(struct rvu *rvu, int blkaddr, u8 cptlf,
+					 struct cpt_inline_ipsec_cfg_msg *req)
+{
+	u16 nix_pf_func = req->nix_pf_func;
+	u64 val;
+
+	val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	if (req->enable && (val & BIT_ULL(9))) {
+		/* IPSec inline inbound path is already enabled for a given
+		 * CPT LF, HRM states that inline inbound & outbound paths
+		 * must not be enabled at the same time for a given CPT LF
+		 */
+		return CPT_AF_ERR_INLINE_IPSEC_OUT_ENA;
+	}
+
+	/* Check if requested 'CPTLF <=> NIXLF' mapping is valid */
+	if (nix_pf_func && !is_pffunc_map_valid(rvu, nix_pf_func, BLKTYPE_NIX))
+		return CPT_AF_ERR_NIX_PF_FUNC_INVALID;
+
+	/* Set PF_FUNC_INST */
+	if (req->enable)
+		val |= BIT_ULL(16);
+	else
+		val &= ~BIT_ULL(16);
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
+
+	if (nix_pf_func) {
+		/* Set NIX_PF_FUNC */
+		val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+		val |= (u64)nix_pf_func << 48;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), val);
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_cpt_inline_ipsec_cfg(struct rvu *rvu,
+					  struct cpt_inline_ipsec_cfg_msg *req,
+					  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr;
+	int num_lfs, ret;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, pcifunc);
+	if (blkaddr < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	block = &rvu->hw->block[blkaddr];
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					block->type);
+	if (req->slot >= num_lfs)
+		return CPT_AF_ERR_LF_INVALID;
+
+	cptlf = rvu_get_lf(rvu, block, pcifunc, req->slot);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	switch (req->dir) {
+	case CPT_INLINE_INBOUND:
+		ret = cpt_inline_ipsec_cfg_inbound(rvu, blkaddr, cptlf, req);
+		break;
+
+	case CPT_INLINE_OUTBOUND:
+		ret = cpt_inline_ipsec_cfg_outbound(rvu, blkaddr, cptlf, req);
+		break;
+
+	default:
+		return CPT_AF_ERR_PARAM;
+	}
+
+	return ret;
+}
+
+int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
+					struct cpt_rd_wr_reg_msg *req,
+					struct cpt_rd_wr_reg_msg *rsp)
+{
+	int blkaddr, num_lfs, offs, lf;
+	struct rvu_block *block;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* This message is accepted only if sent from CPT PF/VF */
+	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
+	    !is_cpt_vf(rvu, req->hdr.pcifunc))
+		return CPT_AF_ERR_ACCESS_DENIED;
+
+	rsp->reg_offset = req->reg_offset;
+	rsp->ret_val = req->ret_val;
+	rsp->is_write = req->is_write;
+
+	/* Registers that can be accessed from PF/VF */
+	if ((req->reg_offset & 0xFF000) ==  CPT_AF_LFX_CTL(0) ||
+	    (req->reg_offset & 0xFF000) ==  CPT_AF_LFX_CTL2(0)) {
+		offs = req->reg_offset & 0xFFF;
+		if (offs % 8)
+			return CPT_AF_ERR_ACCESS_DENIED;
+		lf = offs >> 3;
+		block = &rvu->hw->block[blkaddr];
+		num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu,
+							     req->hdr.pcifunc),
+						block->type);
+		if (lf >= num_lfs)
+			/* Slot is not valid for that PF/VF */
+			return CPT_AF_ERR_ACCESS_DENIED;
+
+		/* Need to translate CPT LF slot to global number because
+		 * VFs use local numbering from 0 to number of LFs - 1
+		 */
+		lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr],
+				req->hdr.pcifunc, lf);
+		if (lf < 0)
+			return CPT_AF_ERR_ACCESS_DENIED;
+
+		req->reg_offset &= 0xFF000;
+		req->reg_offset += lf << 3;
+		rsp->reg_offset = req->reg_offset;
+	} else if (!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK)) {
+		/* Registers that can be accessed from PF */
+		switch (req->reg_offset & 0xFF000) {
+		case CPT_AF_PF_FUNC:
+		case CPT_AF_BLK_RST:
+		case CPT_AF_CONSTANTS1:
+			if (req->reg_offset & 0xFFF)
+				return CPT_AF_ERR_ACCESS_DENIED;
+			break;
+
+		case CPT_AF_EXEX_STS(0):
+		case CPT_AF_EXEX_CTL(0):
+		case CPT_AF_EXEX_CTL2(0):
+		case CPT_AF_EXEX_UCODE_BASE(0):
+			offs = req->reg_offset & 0xFFF;
+			if ((offs % 8) || (offs >> 3) > 127)
+				return CPT_AF_ERR_ACCESS_DENIED;
+			break;
+		default:
+			return CPT_AF_ERR_ACCESS_DENIED;
+		}
+	} else {
+		return CPT_AF_ERR_ACCESS_DENIED;
+	}
+
+	if (req->is_write)
+		rvu_write64(rvu, blkaddr, req->reg_offset, req->val);
+	else
+		rsp->val = rvu_read64(rvu, blkaddr, req->reg_offset);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 77adad4..9dbfcb7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1676,6 +1676,347 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npc);
 }
 
+/* CPT debugfs APIs */
+static int parse_cpt_cmd_buffer(char *cmd_buf, size_t *count,
+				const char __user *buffer, char *e_type)
+{
+	int  bytes_not_copied;
+	char *cmd_buf_tmp;
+	char *subtoken;
+
+	bytes_not_copied = copy_from_user(cmd_buf, buffer, *count);
+	if (bytes_not_copied)
+		return -EFAULT;
+
+	cmd_buf[*count] = '\0';
+	cmd_buf_tmp = strchr(cmd_buf, '\n');
+
+	if (cmd_buf_tmp) {
+		*cmd_buf_tmp = '\0';
+		*count = cmd_buf_tmp - cmd_buf + 1;
+	}
+
+	subtoken = strsep(&cmd_buf, " ");
+	if (subtoken)
+		strcpy(e_type, subtoken);
+	else
+		return -EINVAL;
+
+	if (cmd_buf)
+		return -EINVAL;
+
+	if (strcmp(e_type, "SE") && strcmp(e_type, "IE") &&
+	    strcmp(e_type, "AE") && strcmp(e_type, "all"))
+		return -EINVAL;
+
+	return 0;
+}
+
+static ssize_t rvu_dbg_cpt_cmd_parser(struct file *filp,
+				      const char __user *buffer, size_t count,
+				      loff_t *ppos)
+{
+	struct seq_file *s = filp->private_data;
+	struct rvu *rvu = s->private;
+	char *cmd_buf;
+	int ret = 0;
+
+	if ((*ppos != 0) || !count)
+		return -EINVAL;
+
+	cmd_buf = kzalloc(count + 1, GFP_KERNEL);
+	if (!cmd_buf)
+		return -ENOSPC;
+
+	if (parse_cpt_cmd_buffer(cmd_buf, &count, buffer,
+				 rvu->rvu_dbg.cpt_ctx.e_type) < 0)
+		ret = -EINVAL;
+
+	kfree(cmd_buf);
+
+	if (ret)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t rvu_dbg_cpt_engines_sts_write(struct file *filp,
+					     const char __user *buffer,
+					     size_t count, loff_t *ppos)
+{
+	return rvu_dbg_cpt_cmd_parser(filp, buffer, count, ppos);
+}
+
+static int rvu_dbg_cpt_engines_sts_display(struct seq_file *filp, void *unused)
+{
+	u64  busy_sts[2] = {0}, free_sts[2] = {0};
+	struct rvu *rvu = filp->private;
+	u16  max_ses, max_ies, max_aes;
+	u32  e_min = 0, e_max = 0, e;
+	int  blkaddr;
+	char *e_type;
+	u64  reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	e_type = rvu->rvu_dbg.cpt_ctx.e_type;
+
+	if (strcmp(e_type, "SE") == 0) {
+		e_min = 0;
+		e_max = max_ses - 1;
+	} else if (strcmp(e_type, "IE") == 0) {
+		e_min = max_ses;
+		e_max = max_ses + max_ies - 1;
+	} else if (strcmp(e_type, "AE") == 0) {
+		e_min = max_ses + max_ies;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else if (strcmp(e_type, "all") == 0) {
+		e_min = 0;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else {
+		return -EINVAL;
+	}
+
+	for (e = e_min; e <= e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
+		if (reg & 0x1) {
+			if (e < max_ses)
+				busy_sts[0] |= 1ULL << e;
+			else if (e >= max_ses)
+				busy_sts[1] |= 1ULL << (e - max_ses);
+		}
+		if (reg & 0x2) {
+			if (e < max_ses)
+				free_sts[0] |= 1ULL << e;
+			else if (e >= max_ses)
+				free_sts[1] |= 1ULL << (e - max_ses);
+		}
+	}
+	seq_printf(filp, "FREE STS : 0x%016llx  0x%016llx\n", free_sts[1],
+		   free_sts[0]);
+	seq_printf(filp, "BUSY STS : 0x%016llx  0x%016llx\n", busy_sts[1],
+		   busy_sts[0]);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_engines_sts, cpt_engines_sts_display,
+		   cpt_engines_sts_write);
+
+static ssize_t rvu_dbg_cpt_engines_info_write(struct file *filp,
+					      const char __user *buffer,
+					      size_t count, loff_t *ppos)
+{
+	return rvu_dbg_cpt_cmd_parser(filp, buffer, count, ppos);
+}
+
+static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u16  max_ses, max_ies, max_aes;
+	u32  e_min, e_max, e;
+	int  blkaddr;
+	char *e_type;
+	u64  reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	e_type = rvu->rvu_dbg.cpt_ctx.e_type;
+
+	if (strcmp(e_type, "SE") == 0) {
+		e_min = 0;
+		e_max = max_ses - 1;
+	} else if (strcmp(e_type, "IE") == 0) {
+		e_min = max_ses;
+		e_max = max_ses + max_ies - 1;
+	} else if (strcmp(e_type, "AE") == 0) {
+		e_min = max_ses + max_ies;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else if (strcmp(e_type, "all") == 0) {
+		e_min = 0;
+		e_max = max_ses + max_ies + max_aes - 1;
+	} else {
+		return -EINVAL;
+	}
+
+	seq_puts(filp, "===========================================\n");
+	for (e = e_min; e <= e_max; e++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
+		seq_printf(filp, "CPT Engine[%u] Group Enable   0x%02llx\n", e,
+			   reg & 0xff);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_ACTIVE(e));
+		seq_printf(filp, "CPT Engine[%u] Active Info    0x%llx\n", e,
+			   reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(e));
+		seq_printf(filp, "CPT Engine[%u] Control        0x%llx\n", e,
+			   reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display,
+		   cpt_engines_info_write);
+
+static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr;
+	u64 reg;
+	u32 lf;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	block = &hw->block[blkaddr];
+	if (!block->lf.bmap)
+		return -ENODEV;
+
+	seq_puts(filp, "===========================================\n");
+	for (lf = 0; lf < block->lf.max; lf++) {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL          0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(lf));
+		seq_printf(filp, "CPT Lf[%u] CTL2         0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_PTR_CTL(lf));
+		seq_printf(filp, "CPT Lf[%u] PTR_CTL      0x%llx\n", lf, reg);
+		reg = rvu_read64(rvu, blkaddr, block->lfcfg_reg |
+				(lf << block->lfshift));
+		seq_printf(filp, "CPT Lf[%u] CFG          0x%llx\n", lf, reg);
+		seq_puts(filp, "===========================================\n");
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_lfs_info, cpt_lfs_info_display, NULL);
+
+static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	u64 reg0, reg1;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
+	seq_printf(filp, "CPT_AF_FLTX_INT:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(1));
+	seq_printf(filp, "CPT_AF_PSNX_EXE:       0x%llx 0x%llx\n", reg0, reg1);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_LF(0));
+	seq_printf(filp, "CPT_AF_PSNX_LF:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
+	seq_printf(filp, "CPT_AF_RVU_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
+	seq_printf(filp, "CPT_AF_RAS_INT:        0x%llx\n", reg0);
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
+	seq_printf(filp, "CPT_AF_EXE_ERR_INFO:   0x%llx\n", reg0);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_err_info, cpt_err_info_display, NULL);
+
+static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu;
+	int blkaddr;
+	u64 reg;
+
+	rvu = filp->private;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	if (blkaddr < 0)
+		return -ENODEV;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
+	seq_printf(filp, "CPT instruction requests   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
+	seq_printf(filp, "CPT instruction latency    %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
+	seq_printf(filp, "CPT NCB read requests      %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
+	seq_printf(filp, "CPT NCB read latency       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_UC_PC);
+	seq_printf(filp, "CPT read requests caused by UC fills   %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_ACTIVE_CYCLES_PC);
+	seq_printf(filp, "CPT active cycles pc       %llu\n", reg);
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CPTCLK_CNT);
+	seq_printf(filp, "CPT clock count pc         %llu\n", reg);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(cpt_pc, cpt_pc_display, NULL);
+
+static void rvu_dbg_cpt_init(struct rvu *rvu)
+{
+	const struct device *dev = &rvu->pdev->dev;
+	struct dentry *pfile;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return;
+
+	rvu->rvu_dbg.cpt = debugfs_create_dir("cpt", rvu->rvu_dbg.root);
+	if (!rvu->rvu_dbg.cpt)
+		return;
+
+	pfile = debugfs_create_file("cpt_pc", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_pc_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_engines_sts", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_engines_sts_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_engines_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_engines_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_lfs_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_lfs_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	pfile = debugfs_create_file("cpt_err_info", 0600,
+				    rvu->rvu_dbg.cpt, rvu,
+				    &rvu_dbg_cpt_err_info_fops);
+	if (!pfile)
+		goto create_failed;
+
+	return;
+
+create_failed:
+	dev_err(dev, "Failed to create debugfs dir/file for CPT\n");
+	debugfs_remove_recursive(rvu->rvu_dbg.cpt);
+}
+
 void rvu_dbg_init(struct rvu *rvu)
 {
 	struct device *dev = &rvu->pdev->dev;
@@ -1695,6 +2036,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_nix_init(rvu);
 	rvu_dbg_cgx_init(rvu);
 	rvu_dbg_npc_init(rvu);
+	rvu_dbg_cpt_init(rvu);
 
 	return;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4..cc3d3c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3369,3 +3369,79 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
 	return 0;
 }
+
+int rvu_mbox_handler_nix_inline_ipsec_cfg(struct rvu *rvu,
+					  struct nix_inline_ipsec_cfg *req,
+					  struct msg_rsp *rsp)
+{
+	int blkaddr;
+	u64 val;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	if (req->enable) {
+		/* Set OPCODE and EGRP */
+		val = (u64)req->gen_cfg.egrp << 48 |
+		      (u64)req->gen_cfg.opcode << 32;
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_IPSEC_GEN_CFG, val);
+
+		/* Set CPT queue for inline IPSec */
+		val = (u64)req->inst_qsel.cpt_pf_func << 8 |
+		      req->inst_qsel.cpt_slot;
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_INST_QSEL(0), val);
+
+		/* Set CPT credit */
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(0),
+			    req->cpt_credit);
+	} else {
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_IPSEC_GEN_CFG, 0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_INST_QSEL(0), 0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(0), 0x3FFFFF);
+	}
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
+		struct nix_inline_ipsec_lf_cfg *req, struct msg_rsp *rsp)
+{
+	int lf, blkaddr, err;
+	u64 val;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return 0;
+
+	err = nix_get_nixlf(rvu, req->hdr.pcifunc, &lf, &blkaddr);
+	if (err)
+		return err;
+
+	if (req->enable) {
+		/* Set TT, TAG_CONST, SA_POW2_SIZE and LENM1_MAX */
+		val = (u64)req->ipsec_cfg0.tt << 44 |
+		      (u64)req->ipsec_cfg0.tag_const << 20 |
+		      (u64)req->ipsec_cfg0.sa_pow2_size << 16 |
+		      req->ipsec_cfg0.lenm1_max;
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG0(lf), val);
+
+		/* Set SA_IDX_W and SA_IDX_MAX */
+		val = (u64)req->ipsec_cfg1.sa_idx_w << 32 |
+		      req->ipsec_cfg1.sa_idx_max;
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(lf), val);
+
+		/* Set SA base address */
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_SA_BASE(lf),
+			    req->sa_base_addr);
+	} else {
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG0(lf), 0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(lf), 0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_SA_BASE(lf),
+			    0x0);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 7ca599b..351b383 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -216,6 +216,8 @@
 #define NIX_AF_RX_DEF_IPSECX		(0x02B0)
 #define NIX_AF_RX_IPSEC_GEN_CFG		(0x0300)
 #define NIX_AF_RX_CPTX_INST_ADDR	(0x0310)
+#define NIX_AF_RX_CPTX_INST_QSEL(a)	(0x0320ull | (uint64_t)(a) << 3)
+#define NIX_AF_RX_CPTX_CREDIT(a)	(0x0360ull | (uint64_t)(a) << 3)
 #define NIX_AF_NDC_TX_SYNC		(0x03F0)
 #define NIX_AF_AQ_CFG			(0x0400)
 #define NIX_AF_AQ_BASE			(0x0410)
@@ -429,12 +431,63 @@
 #define TIM_AF_LF_RST			(0x20)
 
 /* CPT */
-#define CPT_AF_CONSTANTS0		(0x0000)
-#define CPT_PRIV_LFX_CFG		(0x41000)
-#define CPT_PRIV_LFX_INT_CFG		(0x43000)
-#define CPT_AF_RVU_LF_CFG_DEBUG		(0x45000)
-#define CPT_AF_LF_RST			(0x44000)
-#define CPT_AF_BLK_RST			(0x46000)
+#define CPT_AF_CONSTANTS0               (0x0000)
+#define CPT_AF_CONSTANTS1               (0x1000)
+#define CPT_AF_DIAG                     (0x3000)
+#define CPT_AF_ECO                      (0x4000)
+#define CPT_AF_FLTX_INT(a)              (0xa000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_W1S(a)          (0xb000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_ENA_W1C(a)      (0xc000ull | (u64)(a) << 3)
+#define CPT_AF_FLTX_INT_ENA_W1S(a)      (0xd000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_EXE(a)              (0xe000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_EXE_W1S(a)          (0xf000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_LF(a)               (0x10000ull | (u64)(a) << 3)
+#define CPT_AF_PSNX_LF_W1S(a)           (0x11000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_CTL2(a)             (0x12000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_STS(a)              (0x13000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_ERR_INFO             (0x14000)
+#define CPT_AF_EXEX_ACTIVE(a)           (0x16000ull | (u64)(a) << 3)
+#define CPT_AF_INST_REQ_PC              (0x17000)
+#define CPT_AF_INST_LATENCY_PC          (0x18000)
+#define CPT_AF_RD_REQ_PC                (0x19000)
+#define CPT_AF_RD_LATENCY_PC            (0x1a000)
+#define CPT_AF_RD_UC_PC                 (0x1b000)
+#define CPT_AF_ACTIVE_CYCLES_PC         (0x1c000)
+#define CPT_AF_EXE_DBG_CTL              (0x1d000)
+#define CPT_AF_EXE_DBG_DATA             (0x1e000)
+#define CPT_AF_EXE_REQ_TIMER            (0x1f000)
+#define CPT_AF_EXEX_CTL(a)              (0x20000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_PERF_CTL             (0x21000)
+#define CPT_AF_EXE_DBG_CNTX(a)          (0x22000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_PERF_EVENT_CNT       (0x23000)
+#define CPT_AF_EXE_EPCI_INBX_CNT(a)     (0x24000ull | (u64)(a) << 3)
+#define CPT_AF_EXE_EPCI_OUTBX_CNT(a)    (0x25000ull | (u64)(a) << 3)
+#define CPT_AF_EXEX_UCODE_BASE(a)       (0x26000ull | (u64)(a) << 3)
+#define CPT_AF_LFX_CTL(a)               (0x27000ull | (u64)(a) << 3)
+#define CPT_AF_LFX_CTL2(a)              (0x29000ull | (u64)(a) << 3)
+#define CPT_AF_CPTCLK_CNT               (0x2a000)
+#define CPT_AF_PF_FUNC                  (0x2b000)
+#define CPT_AF_LFX_PTR_CTL(a)           (0x2c000ull | (u64)(a) << 3)
+#define CPT_AF_GRPX_THR(a)              (0x2d000ull | (u64)(a) << 3)
+#define CPT_AF_CTL                      (0x2e000ull)
+#define CPT_AF_XEX_THR(a)               (0x2f000ull | (u64)(a) << 3)
+#define CPT_PRIV_LFX_CFG                (0x41000)
+#define CPT_PRIV_AF_INT_CFG             (0x42000)
+#define CPT_PRIV_LFX_INT_CFG            (0x43000)
+#define CPT_AF_LF_RST                   (0x44000)
+#define CPT_AF_RVU_LF_CFG_DEBUG         (0x45000)
+#define CPT_AF_BLK_RST                  (0x46000)
+#define CPT_AF_RVU_INT                  (0x47000)
+#define CPT_AF_RVU_INT_W1S              (0x47008)
+#define CPT_AF_RVU_INT_ENA_W1S          (0x47010)
+#define CPT_AF_RVU_INT_ENA_W1C          (0x47018)
+#define CPT_AF_RAS_INT                  (0x47020)
+#define CPT_AF_RAS_INT_W1S              (0x47028)
+#define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
+#define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
+
+#define CPT_AF_LF_CTL2_SHIFT 3
+#define CPT_AF_LF_SSO_PF_FUNC_SHIFT 32
 
 #define NPC_AF_BLK_RST                  (0x00040)
 
-- 
1.9.1

