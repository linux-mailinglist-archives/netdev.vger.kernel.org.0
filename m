Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CC42B639
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 07:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhJMF6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 01:58:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhJMF6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 01:58:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMf8dP022202;
        Tue, 12 Oct 2021 22:56:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=UT2AKkpYFdv7/b0livE40KmCFpIaPORcqQCn4eEjClY=;
 b=PnsGqXcDIlkqoNTY8vTI76LRl4vYrOMKrlpg3NaVvyMPIVkIdsoMVdstAAxI2a/y4Z/3
 FOi5lWNDePccBWJOlkm39bP0tUmZHCiW62bi29tFPUOCKnoeXdRwGgwrR7L3dWBVMYxR
 avb5RgxLAUJUoFJKSaow3ZnpPTlvaheYSf9zLWFtpL7m+/3CdqOZIpLK5w60dagXoUNm
 TIDCbq4zyPcm2Wzz/ZRSyoyPyMancJbCvaJBKqDCKri79pDvxaMdELx8XDH0i33f0H77
 GnwGgRr9UEd5A2bEEWtYGD9bC+Cs9O0eB1attnebW+pCHZIG6Vdunxu65R0yrJJsozz9 8g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bnkcchhpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:56:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 22:56:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 22:56:36 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 9F6773F708A;
        Tue, 12 Oct 2021 22:56:33 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next 3/3] octeontx2-af: Add support to flush full CPT CTX cache
Date:   Wed, 13 Oct 2021 11:26:21 +0530
Message-ID: <20211013055621.1812301-4-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013055621.1812301-1-schalla@marvell.com>
References: <20211013055621.1812301-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qkGOIjilqWm29ayM-Ax8iY0I3ZrMm5_B
X-Proofpoint-GUID: qkGOIjilqWm29ayM-Ax8iY0I3ZrMm5_B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_01,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support to flush or invalidate CPT CTX entries as part of FLR
and also provides a mailbox to flush CPT CTX entries in case of
graceful exit.
This patch also adds support for AF -> CPT PF uplink mailbox messages
and adds a new mbox message to submit a CPT instruction from AF.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  12 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 206 ++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   2 +
 5 files changed, 232 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index dfe487235007..4e79e918a161 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -191,6 +191,7 @@ M(CPT_INLINE_IPSEC_CFG,	0xA04, cpt_inline_ipsec_cfg,			\
 M(CPT_STATS,            0xA05, cpt_sts, cpt_sts_req, cpt_sts_rsp)	\
 M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
+M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -292,10 +293,14 @@ M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
 #define MBOX_UP_CGX_MESSAGES						\
 M(CGX_LINK_EVENT,	0xC00, cgx_link_event, cgx_link_info_msg, msg_rsp)
 
+#define MBOX_UP_CPT_MESSAGES						\
+M(CPT_INST_LMTST,	0xD00, cpt_inst_lmtst, cpt_inst_lmtst_req, msg_rsp)
+
 enum {
 #define M(_name, _id, _1, _2, _3) MBOX_MSG_ ## _name = _id,
 MBOX_MESSAGES
 MBOX_UP_CGX_MESSAGES
+MBOX_UP_CPT_MESSAGES
 #undef M
 };
 
@@ -1562,6 +1567,13 @@ struct cpt_rxc_time_cfg_req {
 	u16 active_limit;
 };
 
+/* Mailbox message request format to request for CPT_INST_S lmtst. */
+struct cpt_inst_lmtst_req {
+	struct mbox_msghdr hdr;
+	u64 inst[8];
+	u64 rsvd;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 75aa0b8cfe58..66e45d733824 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -817,6 +817,7 @@ int rvu_cpt_register_interrupts(struct rvu *rvu);
 void rvu_cpt_unregister_interrupts(struct rvu *rvu);
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf,
 			int slot);
+int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc);
 
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 7bab20403bba..45357deecabb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -795,6 +795,58 @@ int rvu_mbox_handler_cpt_rxc_time_cfg(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_cpt_ctx_cache_sync(struct rvu *rvu, struct msg_req *req,
+					struct msg_rsp *rsp)
+{
+	return rvu_cpt_ctx_flush(rvu, req->hdr.pcifunc);
+}
+
+static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
+{
+	struct cpt_rxc_time_cfg_req req;
+	int timeout = 2000;
+	u64 reg;
+
+	if (is_rvu_otx2(rvu))
+		return;
+
+	/* Set time limit to minimum values, so that rxc entries will be
+	 * flushed out quickly.
+	 */
+	req.step = 1;
+	req.zombie_thres = 1;
+	req.zombie_limit = 1;
+	req.active_thres = 1;
+	req.active_limit = 1;
+
+	cpt_rxc_time_cfg(rvu, &req, blkaddr);
+
+	do {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ACTIVE_STS);
+		udelay(1);
+		if (FIELD_GET(RXC_ACTIVE_COUNT, reg))
+			timeout--;
+		else
+			break;
+	} while (timeout);
+
+	if (timeout == 0)
+		dev_warn(rvu->dev, "Poll for RXC active count hits hard loop counter\n");
+
+	timeout = 2000;
+	do {
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ZOMBIE_STS);
+		udelay(1);
+		if (FIELD_GET(RXC_ZOMBIE_COUNT, reg))
+			timeout--;
+		else
+			break;
+	} while (timeout);
+
+	if (timeout == 0)
+		dev_warn(rvu->dev, "Poll for RXC zombie count hits hard loop counter\n");
+}
+
 #define INPROG_INFLIGHT(reg)    ((reg) & 0x1FF)
 #define INPROG_GRB_PARTIAL(reg) ((reg) & BIT_ULL(31))
 #define INPROG_GRB(reg)         (((reg) >> 32) & 0xFF)
@@ -863,6 +915,9 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 {
 	u64 reg;
 
+	if (is_cpt_pf(rvu, pcifunc) || is_cpt_vf(rvu, pcifunc))
+		cpt_rxc_teardown(rvu, blkaddr);
+
 	/* Enable BAR2 ALIAS for this pcifunc. */
 	reg = BIT_ULL(16) | pcifunc;
 	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
@@ -878,3 +933,154 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
 
 	return 0;
 }
+
+#define CPT_RES_LEN    16
+#define CPT_SE_IE_EGRP 1ULL
+
+static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
+				      int nix_blkaddr)
+{
+	int cpt_pf_num = get_cpt_pf_num(rvu);
+	struct cpt_inst_lmtst_req *req;
+	dma_addr_t res_daddr;
+	int timeout = 3000;
+	u8 cpt_idx;
+	u64 *inst;
+	u16 *res;
+	int rc;
+
+	res = kzalloc(CPT_RES_LEN, GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	res_daddr = dma_map_single(rvu->dev, res, CPT_RES_LEN,
+				   DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(rvu->dev, res_daddr)) {
+		dev_err(rvu->dev, "DMA mapping failed for CPT result\n");
+		rc = -EFAULT;
+		goto res_free;
+	}
+	*res = 0xFFFF;
+
+	/* Send mbox message to CPT PF */
+	req = (struct cpt_inst_lmtst_req *)
+	       otx2_mbox_alloc_msg_rsp(&rvu->afpf_wq_info.mbox_up,
+				       cpt_pf_num, sizeof(*req),
+				       sizeof(struct msg_rsp));
+	if (!req) {
+		rc = -ENOMEM;
+		goto res_daddr_unmap;
+	}
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.id = MBOX_MSG_CPT_INST_LMTST;
+
+	inst = req->inst;
+	/* Prepare CPT_INST_S */
+	inst[0] = 0;
+	inst[1] = res_daddr;
+	/* AF PF FUNC */
+	inst[2] = 0;
+	/* Set QORD */
+	inst[3] = 1;
+	inst[4] = 0;
+	inst[5] = 0;
+	inst[6] = 0;
+	/* Set EGRP */
+	inst[7] = CPT_SE_IE_EGRP << 61;
+
+	/* Subtract 1 from the NIX-CPT credit count to preserve
+	 * credit counts.
+	 */
+	cpt_idx = (blkaddr == BLKADDR_CPT0) ? 0 : 1;
+	rvu_write64(rvu, nix_blkaddr, NIX_AF_RX_CPTX_CREDIT(cpt_idx),
+		    BIT_ULL(22) - 1);
+
+	otx2_mbox_msg_send(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
+	rc = otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, cpt_pf_num);
+	if (rc)
+		dev_warn(rvu->dev, "notification to pf %d failed\n",
+			 cpt_pf_num);
+	/* Wait for CPT instruction to be completed */
+	do {
+		mdelay(1);
+		if (*res == 0xFFFF)
+			timeout--;
+		else
+			break;
+	} while (timeout);
+
+	if (timeout == 0)
+		dev_warn(rvu->dev, "Poll for result hits hard loop counter\n");
+
+res_daddr_unmap:
+	dma_unmap_single(rvu->dev, res_daddr, CPT_RES_LEN, DMA_BIDIRECTIONAL);
+res_free:
+	kfree(res);
+
+	return 0;
+}
+
+#define CTX_CAM_PF_FUNC   GENMASK_ULL(61, 46)
+#define CTX_CAM_CPTR      GENMASK_ULL(45, 0)
+
+int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
+{
+	int nix_blkaddr, blkaddr;
+	u16 max_ctx_entries, i;
+	int slot = 0, num_lfs;
+	u64 reg, cam_data;
+	int rc;
+
+	nix_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (nix_blkaddr < 0)
+		return -EINVAL;
+
+	if (is_rvu_otx2(rvu))
+		return 0;
+
+	blkaddr = (nix_blkaddr == BLKADDR_NIX1) ? BLKADDR_CPT1 : BLKADDR_CPT0;
+
+	/* Submit CPT_INST_S to track when all packets have been
+	 * flushed through for the NIX PF FUNC in inline inbound case.
+	 */
+	rc = cpt_inline_inb_lf_cmd_send(rvu, blkaddr, nix_blkaddr);
+	if (rc)
+		return rc;
+
+	/* Wait for rxc entries to be flushed out */
+	cpt_rxc_teardown(rvu, blkaddr);
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS0);
+	max_ctx_entries = (reg >> 48) & 0xFFF;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	num_lfs = rvu_get_rsrc_mapcount(rvu_get_pfvf(rvu, pcifunc),
+					blkaddr);
+	if (num_lfs == 0) {
+		dev_warn(rvu->dev, "CPT LF is not configured\n");
+		goto unlock;
+	}
+
+	/* Enable BAR2 ALIAS for this pcifunc. */
+	reg = BIT_ULL(16) | pcifunc;
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, reg);
+
+	for (i = 0; i < max_ctx_entries; i++) {
+		cam_data = rvu_read64(rvu, blkaddr, CPT_AF_CTX_CAM_DATA(i));
+
+		if ((FIELD_GET(CTX_CAM_PF_FUNC, cam_data) == pcifunc) &&
+		    FIELD_GET(CTX_CAM_CPTR, cam_data)) {
+			reg = BIT_ULL(46) | FIELD_GET(CTX_CAM_CPTR, cam_data);
+			rvu_write64(rvu, blkaddr,
+				    CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTX_FLUSH),
+				    reg);
+		}
+	}
+	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_SEL, 0);
+
+unlock:
+	mutex_unlock(&rvu->rsrc_lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 67feb26792e4..7761dcf17b91 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4512,6 +4512,8 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
 }
 
+#define RX_SA_BASE  GENMASK_ULL(52, 7)
+
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
@@ -4519,6 +4521,7 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	int pf = rvu_get_pf(pcifunc);
 	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
+	u64 sa_base;
 	void *cgxd;
 	int err;
 
@@ -4575,6 +4578,14 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_ctx_free(rvu, pfvf);
 
 	nix_free_all_bandprof(rvu, pcifunc);
+
+	sa_base = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_SA_BASE(nixlf));
+	if (FIELD_GET(RX_SA_BASE, sa_base)) {
+		err = rvu_cpt_ctx_flush(rvu, pcifunc);
+		if (err)
+			dev_err(rvu->dev,
+				"CPT ctx flush failed with error: %d\n", err);
+	}
 }
 
 #define NIX_AF_LFX_TX_CFG_PTP_EN	BIT_ULL(32)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index dbaeb10de7c2..22cd751613cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -527,6 +527,7 @@
 #define CPT_AF_CTX_WBACK_LATENCY_PC     (0x49448ull)
 #define CPT_AF_CTX_PSH_PC               (0x49450ull)
 #define CPT_AF_CTX_PSH_LATENCY_PC       (0x49458ull)
+#define CPT_AF_CTX_CAM_DATA(a)          (0x49800ull | (u64)(a) << 3)
 #define CPT_AF_RXC_TIME                 (0x50010ull)
 #define CPT_AF_RXC_TIME_CFG             (0x50018ull)
 #define CPT_AF_RXC_DFRG                 (0x50020ull)
@@ -544,6 +545,7 @@
 #define CPT_LF_CTL                      0x10
 #define CPT_LF_INPROG                   0x40
 #define CPT_LF_Q_GRP_PTR                0x120
+#define CPT_LF_CTX_FLUSH                0x510
 
 #define NPC_AF_BLK_RST                  (0x00040)
 
-- 
2.25.1

