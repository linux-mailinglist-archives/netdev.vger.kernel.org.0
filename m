Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D32640D66B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbhIPJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:42:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33644 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235304AbhIPJmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 05:42:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G99uEF026652;
        Thu, 16 Sep 2021 02:41:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=2z9vElWn92tr7A40p3xajrs0nSZU/8jpzvmfVf9baQY=;
 b=AyoTaKDdClgdFCnrHt+Tj9Hsv0Jb7lwaoUIxCic7B1CNKS9FWYl2I2VkmYGo51HOsUMl
 VZg3SkDU22Kywqg9X1Zeo9j4mYXWAaXCCShUSB2j4Qp6amzhEbNWzLChul6g3vbSZdDI
 ER7E6MK+CmkiOUvvhrzH3zESIyMLIPP50OWzAC7ATzgHxCQ3m5n1cYN+NP5x0LnS6jpD
 98h/CaQDU5gmD+/dI3V83P/KA4xWRAsbpQBKjQDmUl9ABGNJvQEOIBaGv6Qv7L5UtFqJ
 KTKfDUnZIXo5Q1A+ghZM2ON0ijWqfa0lpFD8uTRBagWq5CZRiJAc/uxcSaxzlJ3FLdJa Eg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b3wft17n5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 02:41:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Sep
 2021 02:41:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 16 Sep 2021 02:41:20 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 91F4D3F704E;
        Thu, 16 Sep 2021 02:41:16 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>,
        Vidya Sagar Velumuri <vvelumuri@marvell.com>
Subject: [PATCH net-next] octeontx2-af: Hardware configuration for inline IPsec
Date:   Thu, 16 Sep 2021 15:11:14 +0530
Message-ID: <20210916094114.1538752-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 26OfKwtEX__kbdIuyCCPwfjdSnj1n9pe
X-Proofpoint-GUID: 26OfKwtEX__kbdIuyCCPwfjdSnj1n9pe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-16_03,2021-09-15_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTX2/CN10K SoC, the admin function (AF) is the only one
with all priviliges to configure HW and alloc resources, PFs and
it's VFs have to request AF via mailbox for all their needs.
This patch adds new mailbox messages for CPT PFs and VFs to configure
HW resources for inline-IPsec.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Vidya Sagar Velumuri <vvelumuri@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/common.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  60 +++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  54 +++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   4 +-
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 135 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 112 +++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 8 files changed, 367 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index d9bea13f15b8..8931864ee110 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -191,6 +191,7 @@ enum nix_scheduler {
 #define NIX_CHAN_SDP_CH_START          (0x700ull)
 #define NIX_CHAN_SDP_CHX(a)            (NIX_CHAN_SDP_CH_START + (a))
 #define NIX_CHAN_SDP_NUM_CHANS		256
+#define NIX_CHAN_CPT_CH_START          (0x800ull)
 
 /* The mask is to extract lower 10-bits of channel number
  * which CPT will pass to X2P.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 154877706a0e..f77f745be05b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -186,6 +186,8 @@ M(CPT_LF_ALLOC,		0xA00, cpt_lf_alloc, cpt_lf_alloc_req_msg,	\
 M(CPT_LF_FREE,		0xA01, cpt_lf_free, msg_req, msg_rsp)		\
 M(CPT_RD_WR_REGISTER,	0xA02, cpt_rd_wr_register,  cpt_rd_wr_reg_msg,	\
 			       cpt_rd_wr_reg_msg)			\
+M(CPT_INLINE_IPSEC_CFG,	0xA04, cpt_inline_ipsec_cfg,			\
+			       cpt_inline_ipsec_cfg_msg, msg_rsp)	\
 M(CPT_STATS,            0xA05, cpt_sts, cpt_sts_req, cpt_sts_rsp)	\
 M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
@@ -270,6 +272,10 @@ M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
+M(NIX_INLINE_IPSEC_CFG, 0x8019, nix_inline_ipsec_cfg,			\
+				nix_inline_ipsec_cfg, msg_rsp)		\
+M(NIX_INLINE_IPSEC_LF_CFG, 0x801a, nix_inline_ipsec_lf_cfg,		\
+				nix_inline_ipsec_lf_cfg, msg_rsp)	\
 M(NIX_CN10K_AQ_ENQ,	0x801b, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
 				nix_cn10k_aq_enq_rsp)			\
 M(NIX_GET_HW_INFO,	0x801c, nix_get_hw_info, msg_req, nix_hw_info)	\
@@ -1065,6 +1071,40 @@ struct nix_bp_cfg_rsp {
 	u8	chan_cnt; /* Number of channel for which bpids are assigned */
 };
 
+/* Global NIX inline IPSec configuration */
+struct nix_inline_ipsec_cfg {
+	struct mbox_msghdr hdr;
+	u32 cpt_credit;
+	struct {
+		u8 egrp;
+		u8 opcode;
+		u16 param1;
+		u16 param2;
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
 struct nix_hw_info {
 	struct mbox_msghdr hdr;
 	u16 rsvs16;
@@ -1399,7 +1439,9 @@ enum cpt_af_status {
 	CPT_AF_ERR_LF_INVALID		= -903,
 	CPT_AF_ERR_ACCESS_DENIED	= -904,
 	CPT_AF_ERR_SSO_PF_FUNC_INVALID	= -905,
-	CPT_AF_ERR_NIX_PF_FUNC_INVALID	= -906
+	CPT_AF_ERR_NIX_PF_FUNC_INVALID	= -906,
+	CPT_AF_ERR_INLINE_IPSEC_INB_ENA	= -907,
+	CPT_AF_ERR_INLINE_IPSEC_OUT_ENA	= -908
 };
 
 /* CPT mbox message formats */
@@ -1420,6 +1462,22 @@ struct cpt_lf_alloc_req_msg {
 	int blkaddr;
 };
 
+#define CPT_INLINE_INBOUND      0
+#define CPT_INLINE_OUTBOUND     1
+
+/* Mailbox message request format for CPT IPsec
+ * inline inbound and outbound configuration.
+ */
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
 /* Mailbox message request and response format for CPT stats. */
 struct cpt_sts_req {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 35836903b7fb..3bba8bc91f35 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1287,6 +1287,60 @@ static int rvu_lookup_rsrc(struct rvu *rvu, struct rvu_block *block,
 	return (val & 0xFFF);
 }
 
+int rvu_get_blkaddr_from_slot(struct rvu *rvu, int blktype, u16 pcifunc,
+			      u16 global_slot, u16 *slot_in_block)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int numlfs, total_lfs = 0, nr_blocks = 0;
+	int i, num_blkaddr[BLK_COUNT] = { 0 };
+	struct rvu_block *block;
+	int blkaddr = -ENODEV;
+	u16 start_slot;
+
+	if (!is_blktype_attached(pfvf, blktype))
+		return -ENODEV;
+
+	/* Get all the block addresses from which LFs are attached to
+	 * the given pcifunc in num_blkaddr[].
+	 */
+	for (blkaddr = BLKADDR_RVUM; blkaddr < BLK_COUNT; blkaddr++) {
+		block = &rvu->hw->block[blkaddr];
+		if (block->type != blktype)
+			continue;
+		if (!is_block_implemented(rvu->hw, blkaddr))
+			continue;
+
+		numlfs = rvu_get_rsrc_mapcount(pfvf, blkaddr);
+		if (numlfs) {
+			total_lfs += numlfs;
+			num_blkaddr[nr_blocks] = blkaddr;
+			nr_blocks++;
+		}
+	}
+
+	if (global_slot >= total_lfs)
+		return -ENODEV;
+
+	/* Based on the given global slot number retrieve the
+	 * correct block address out of all attached block
+	 * addresses and slot number in that block.
+	 */
+	total_lfs = 0;
+	blkaddr = -ENODEV;
+	for (i = 0; i < nr_blocks; i++) {
+		numlfs = rvu_get_rsrc_mapcount(pfvf, num_blkaddr[i]);
+		total_lfs += numlfs;
+		if (global_slot < total_lfs) {
+			blkaddr = num_blkaddr[i];
+			start_slot = total_lfs - numlfs;
+			*slot_in_block = global_slot - start_slot;
+			break;
+		}
+	}
+
+	return blkaddr;
+}
+
 static void rvu_detach_block(struct rvu *rvu, int pcifunc, int blktype)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 1d9411232f1d..f59169cdc0db 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -656,6 +656,8 @@ int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
 int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc);
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero);
 int rvu_get_num_lbk_chans(void);
+int rvu_get_blkaddr_from_slot(struct rvu *rvu, int blktype, u16 pcifunc,
+			      u16 global_slot, u16 *slot_in_block);
 
 /* RVU HW reg validation */
 enum regmap_block {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 46a41cfff575..7dbbc115cde4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -334,8 +334,8 @@ int rvu_set_channels_base(struct rvu *rvu)
 	/* Out of 4096 channels start CPT from 2048 so
 	 * that MSB for CPT channels is always set
 	 */
-	if (cpt_chan_base <= 0x800) {
-		hw->cpt_chan_base = 0x800;
+	if (cpt_chan_base <= NIX_CHAN_CPT_CH_START) {
+		hw->cpt_chan_base = NIX_CHAN_CPT_CH_START;
 	} else {
 		dev_err(rvu->dev,
 			"CPT channels could not fit in the range 2048-4095\n");
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 1f90a7403392..267d092b8e97 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -197,6 +197,141 @@ int rvu_mbox_handler_cpt_lf_free(struct rvu *rvu, struct msg_req *req,
 	return ret;
 }
 
+static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
+					struct cpt_inline_ipsec_cfg_msg *req)
+{
+	u16 sso_pf_func = req->sso_pf_func;
+	u8 nix_sel;
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
+	nix_sel = (blkaddr == BLKADDR_CPT1) ? 1 : 0;
+	/* Enable CPT LF for IPsec inline inbound operations */
+	if (req->enable)
+		val |= BIT_ULL(9);
+	else
+		val &= ~BIT_ULL(9);
+
+	val |= (u64)nix_sel << 8;
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
+	/* Configure the X2P Link register with the cpt base channel number and
+	 * range of channels it should propagate to X2P
+	 */
+	if (!is_rvu_otx2(rvu)) {
+		val = (ilog2(NIX_CHAN_CPT_X2P_MASK + 1) << 16);
+		val |= rvu->hw->cpt_chan_base;
+
+		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0), val);
+		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1), val);
+	}
+
+	return 0;
+}
+
+static int cpt_inline_ipsec_cfg_outbound(struct rvu *rvu, int blkaddr, u8 cptlf,
+					 struct cpt_inline_ipsec_cfg_msg *req)
+{
+	u16 nix_pf_func = req->nix_pf_func;
+	int nix_blkaddr;
+	u8 nix_sel;
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
+	/* Enable CPT LF for IPsec inline outbound operations */
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
+
+		nix_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, nix_pf_func);
+		nix_sel = (nix_blkaddr == BLKADDR_NIX0) ? 0 : 1;
+
+		val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+		val |= (u64)nix_sel << 8;
+		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
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
+	int cptlf, blkaddr, ret;
+	u16 actual_slot;
+
+	blkaddr = rvu_get_blkaddr_from_slot(rvu, BLKTYPE_CPT, pcifunc,
+					    req->slot, &actual_slot);
+	if (blkaddr < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	block = &rvu->hw->block[blkaddr];
+
+	cptlf = rvu_get_lf(rvu, block, pcifunc, actual_slot);
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
 static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 {
 	u64 offset = req->reg_offset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 9ef4e942e31e..ea3e03fa55d4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4579,6 +4579,118 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 	return 0;
 }
 
+#define IPSEC_GEN_CFG_EGRP    GENMASK_ULL(50, 48)
+#define IPSEC_GEN_CFG_OPCODE  GENMASK_ULL(47, 32)
+#define IPSEC_GEN_CFG_PARAM1  GENMASK_ULL(31, 16)
+#define IPSEC_GEN_CFG_PARAM2  GENMASK_ULL(15, 0)
+
+#define CPT_INST_QSEL_BLOCK   GENMASK_ULL(28, 24)
+#define CPT_INST_QSEL_PF_FUNC GENMASK_ULL(23, 8)
+#define CPT_INST_QSEL_SLOT    GENMASK_ULL(7, 0)
+
+static void nix_inline_ipsec_cfg(struct rvu *rvu, struct nix_inline_ipsec_cfg *req,
+				 int blkaddr)
+{
+	u8 cpt_idx, cpt_blkaddr;
+	u64 val;
+
+	cpt_idx = (blkaddr == BLKADDR_NIX0) ? 0 : 1;
+	if (req->enable) {
+		/* Enable context prefetching */
+		if (!is_rvu_otx2(rvu))
+			val = BIT_ULL(51);
+
+		/* Set OPCODE and EGRP */
+		val |= FIELD_PREP(IPSEC_GEN_CFG_EGRP, req->gen_cfg.egrp);
+		val |= FIELD_PREP(IPSEC_GEN_CFG_OPCODE, req->gen_cfg.opcode);
+		val |= FIELD_PREP(IPSEC_GEN_CFG_PARAM1, req->gen_cfg.param1);
+		val |= FIELD_PREP(IPSEC_GEN_CFG_PARAM2, req->gen_cfg.param2);
+
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_IPSEC_GEN_CFG, val);
+
+		/* Set CPT queue for inline IPSec */
+		val = FIELD_PREP(CPT_INST_QSEL_SLOT, req->inst_qsel.cpt_slot);
+		val |= FIELD_PREP(CPT_INST_QSEL_PF_FUNC,
+				  req->inst_qsel.cpt_pf_func);
+
+		if (!is_rvu_otx2(rvu)) {
+			cpt_blkaddr = (cpt_idx == 0) ? BLKADDR_CPT0 :
+						       BLKADDR_CPT1;
+			val |= FIELD_PREP(CPT_INST_QSEL_BLOCK, cpt_blkaddr);
+		}
+
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_INST_QSEL(cpt_idx),
+			    val);
+
+		/* Set CPT credit */
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
+			    req->cpt_credit);
+	} else {
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_IPSEC_GEN_CFG, 0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_INST_QSEL(cpt_idx),
+			    0x0);
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
+			    0x3FFFFF);
+	}
+}
+
+int rvu_mbox_handler_nix_inline_ipsec_cfg(struct rvu *rvu,
+					  struct nix_inline_ipsec_cfg *req,
+					  struct msg_rsp *rsp)
+{
+	if (!is_block_implemented(rvu->hw, BLKADDR_CPT0))
+		return 0;
+
+	nix_inline_ipsec_cfg(rvu, req, BLKADDR_NIX0);
+	if (is_block_implemented(rvu->hw, BLKADDR_CPT1))
+		nix_inline_ipsec_cfg(rvu, req, BLKADDR_NIX1);
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_inline_ipsec_lf_cfg(struct rvu *rvu,
+					     struct nix_inline_ipsec_lf_cfg *req,
+					     struct msg_rsp *rsp)
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
+
+		if (blkaddr == BLKADDR_NIX1)
+			val |= BIT_ULL(46);
+
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
 void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc)
 {
 	bool from_vf = !!(pcifunc & RVU_PFVF_FUNC_MASK);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 21f1ed4e222f..dbaeb10de7c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -236,6 +236,8 @@
 #define NIX_AF_RX_DEF_OIP6_DSCP		(0x02F8)
 #define NIX_AF_RX_IPSEC_GEN_CFG		(0x0300)
 #define NIX_AF_RX_CPTX_INST_ADDR	(0x0310)
+#define NIX_AF_RX_CPTX_INST_QSEL(a)	(0x0320ull | (uint64_t)(a) << 3)
+#define NIX_AF_RX_CPTX_CREDIT(a)	(0x0360ull | (uint64_t)(a) << 3)
 #define NIX_AF_NDC_TX_SYNC		(0x03F0)
 #define NIX_AF_AQ_CFG			(0x0400)
 #define NIX_AF_AQ_BASE			(0x0410)
-- 
2.25.1

