Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C85E3667DF
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhDUJYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:24:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238106AbhDUJYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:24:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L9LPHT030185;
        Wed, 21 Apr 2021 02:23:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=OXxC+OV2QO60nYSft7aow4HM2vrAPqxTkBEc5GYzy5E=;
 b=P3tehC5mxWJdwx69tiau0cQoKlIcIe1knuNW1eG41ybFva0w4D8X13ldOQX23QlYdWoC
 wCfs0R77O2O8c1MXKssHm7yS6W8ytf2p6kxAT/+srkD8XsLhyuz46/cSapdSXxUWb8qX
 CMwzw+epXDRrL14UY1/xQ+luAGX3Q/8RkjGALOY2asAUiuf3I0V7qHO89791ki5X+N8N
 DfsfY4DF/5m6mbXyEeQCzwXjfO9oAWv4LOnMaKgO+y5zpLKB/uo3WbMfvJoEb6MUeStA
 gNx282oV5LCpTXD0x4kGw+pmbTR0ocedv1Y5LW9KIYCXcx/HEECv6qb1c7nIkWYZpBa3 /A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3828x6hey5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:23:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 02:23:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 02:23:31 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 89A963F7040;
        Wed, 21 Apr 2021 02:23:28 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH v2 3/3] octeontx2-af: Add mailbox for CPT stats
Date:   Wed, 21 Apr 2021 14:53:02 +0530
Message-ID: <20210421092302.22402-4-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210421092302.22402-1-schalla@marvell.com>
References: <20210421092302.22402-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Qu3oCC8851r2y8wo0XWrHdy2PenBTyiV
X-Proofpoint-ORIG-GUID: Qu3oCC8851r2y8wo0XWrHdy2PenBTyiV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-21,2021-04-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new mailbox to get CPT stats, includes performance
counters, CPT engines status and RXC status.

Signed-off-by: Narayana Prasad Raju Atherya <pathreya@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  48 ++++++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 112 ++++++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 84e4178e8a13..cedb2616c509 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -177,6 +177,7 @@ M(CPT_LF_ALLOC,		0xA00, cpt_lf_alloc, cpt_lf_alloc_req_msg,	\
 M(CPT_LF_FREE,		0xA01, cpt_lf_free, msg_req, msg_rsp)		\
 M(CPT_RD_WR_REGISTER,	0xA02, cpt_rd_wr_register,  cpt_rd_wr_reg_msg,	\
 			       cpt_rd_wr_reg_msg)			\
+M(CPT_STATS,            0xA05, cpt_sts, cpt_sts_req, cpt_sts_rsp)	\
 M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
@@ -1257,6 +1258,53 @@ struct cpt_lf_alloc_req_msg {
 	int blkaddr;
 };
 
+/* Mailbox message request and response format for CPT stats. */
+struct cpt_sts_req {
+	struct mbox_msghdr hdr;
+	u8 blkaddr;
+};
+
+struct cpt_sts_rsp {
+	struct mbox_msghdr hdr;
+	u64 inst_req_pc;
+	u64 inst_lat_pc;
+	u64 rd_req_pc;
+	u64 rd_lat_pc;
+	u64 rd_uc_pc;
+	u64 active_cycles_pc;
+	u64 ctx_mis_pc;
+	u64 ctx_hit_pc;
+	u64 ctx_aop_pc;
+	u64 ctx_aop_lat_pc;
+	u64 ctx_ifetch_pc;
+	u64 ctx_ifetch_lat_pc;
+	u64 ctx_ffetch_pc;
+	u64 ctx_ffetch_lat_pc;
+	u64 ctx_wback_pc;
+	u64 ctx_wback_lat_pc;
+	u64 ctx_psh_pc;
+	u64 ctx_psh_lat_pc;
+	u64 ctx_err;
+	u64 ctx_enc_id;
+	u64 ctx_flush_timer;
+	u64 rxc_time;
+	u64 rxc_time_cfg;
+	u64 rxc_active_sts;
+	u64 rxc_zombie_sts;
+	u64 busy_sts_ae;
+	u64 free_sts_ae;
+	u64 busy_sts_se;
+	u64 free_sts_se;
+	u64 busy_sts_ie;
+	u64 free_sts_ie;
+	u64 exe_err_info;
+	u64 cptclk_cnt;
+	u64 diag;
+	u64 rxc_dfrg;
+	u64 x2p_link_cfg0;
+	u64 x2p_link_cfg1;
+};
+
 /* Mailbox message request format to configure reassembly timeout. */
 struct cpt_rxc_time_cfg_req {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 2824175dceaa..89253f7bdadb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -15,6 +15,24 @@
 /* Length of initial context fetch in 128 byte words */
 #define CPT_CTX_ILEN    2
 
+#define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
+({                                                                  \
+	u64 free_sts = 0, busy_sts = 0;                             \
+	typeof(rsp) _rsp = rsp;                                     \
+	u32 e, i;                                                   \
+								    \
+	for (e = (e_min), i = 0; e < (e_max); e++, i++) {           \
+		reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e)); \
+		if (reg & 0x1)                                      \
+			busy_sts |= 1ULL << i;                      \
+								    \
+		if (reg & 0x2)                                      \
+			free_sts |= 1ULL << i;                      \
+	}                                                           \
+	(_rsp)->busy_sts_##etype = busy_sts;                        \
+	(_rsp)->free_sts_##etype = free_sts;                        \
+})
+
 static int get_cpt_pf_num(struct rvu *rvu)
 {
 	int i, domain_nr, cpt_pf_num = -1;
@@ -264,6 +282,100 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 	return 0;
 }
 
+static void get_ctx_pc(struct rvu *rvu, struct cpt_sts_rsp *rsp, int blkaddr)
+{
+	if (is_rvu_otx2(rvu))
+		return;
+
+	rsp->ctx_mis_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_MIS_PC);
+	rsp->ctx_hit_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_HIT_PC);
+	rsp->ctx_aop_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_AOP_PC);
+	rsp->ctx_aop_lat_pc = rvu_read64(rvu, blkaddr,
+					 CPT_AF_CTX_AOP_LATENCY_PC);
+	rsp->ctx_ifetch_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_IFETCH_PC);
+	rsp->ctx_ifetch_lat_pc = rvu_read64(rvu, blkaddr,
+					    CPT_AF_CTX_IFETCH_LATENCY_PC);
+	rsp->ctx_ffetch_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_FFETCH_PC);
+	rsp->ctx_ffetch_lat_pc = rvu_read64(rvu, blkaddr,
+					    CPT_AF_CTX_FFETCH_LATENCY_PC);
+	rsp->ctx_wback_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_FFETCH_PC);
+	rsp->ctx_wback_lat_pc = rvu_read64(rvu, blkaddr,
+					   CPT_AF_CTX_FFETCH_LATENCY_PC);
+	rsp->ctx_psh_pc = rvu_read64(rvu, blkaddr, CPT_AF_CTX_FFETCH_PC);
+	rsp->ctx_psh_lat_pc = rvu_read64(rvu, blkaddr,
+					 CPT_AF_CTX_FFETCH_LATENCY_PC);
+	rsp->ctx_err = rvu_read64(rvu, blkaddr, CPT_AF_CTX_ERR);
+	rsp->ctx_enc_id = rvu_read64(rvu, blkaddr, CPT_AF_CTX_ENC_ID);
+	rsp->ctx_flush_timer = rvu_read64(rvu, blkaddr, CPT_AF_CTX_FLUSH_TIMER);
+
+	rsp->rxc_time = rvu_read64(rvu, blkaddr, CPT_AF_RXC_TIME);
+	rsp->rxc_time_cfg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_TIME_CFG);
+	rsp->rxc_active_sts = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ACTIVE_STS);
+	rsp->rxc_zombie_sts = rvu_read64(rvu, blkaddr, CPT_AF_RXC_ZOMBIE_STS);
+	rsp->rxc_dfrg = rvu_read64(rvu, blkaddr, CPT_AF_RXC_DFRG);
+	rsp->x2p_link_cfg0 = rvu_read64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0));
+	rsp->x2p_link_cfg1 = rvu_read64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1));
+}
+
+static void get_eng_sts(struct rvu *rvu, struct cpt_sts_rsp *rsp, int blkaddr)
+{
+	u16 max_ses, max_ies, max_aes;
+	u32 e_min = 0, e_max = 0;
+	u64 reg;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
+	max_ses = reg & 0xffff;
+	max_ies = (reg >> 16) & 0xffff;
+	max_aes = (reg >> 32) & 0xffff;
+
+	/* Get AE status */
+	e_min = max_ses + max_ies;
+	e_max = max_ses + max_ies + max_aes;
+	cpt_get_eng_sts(e_min, e_max, rsp, ae);
+	/* Get SE status */
+	e_min = 0;
+	e_max = max_ses;
+	cpt_get_eng_sts(e_min, e_max, rsp, se);
+	/* Get IE status */
+	e_min = max_ses;
+	e_max = max_ses + max_ies;
+	cpt_get_eng_sts(e_min, e_max, rsp, ie);
+}
+
+int rvu_mbox_handler_cpt_sts(struct rvu *rvu, struct cpt_sts_req *req,
+			     struct cpt_sts_rsp *rsp)
+{
+	int blkaddr;
+
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* This message is accepted only if sent from CPT PF/VF */
+	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
+	    !is_cpt_vf(rvu, req->hdr.pcifunc))
+		return CPT_AF_ERR_ACCESS_DENIED;
+
+	get_ctx_pc(rvu, rsp, blkaddr);
+
+	/* Get CPT engines status */
+	get_eng_sts(rvu, rsp, blkaddr);
+
+	/* Read CPT instruction PC registers */
+	rsp->inst_req_pc = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
+	rsp->inst_lat_pc = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
+	rsp->rd_req_pc = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
+	rsp->rd_lat_pc = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
+	rsp->rd_uc_pc = rvu_read64(rvu, blkaddr, CPT_AF_RD_UC_PC);
+	rsp->active_cycles_pc = rvu_read64(rvu, blkaddr,
+					   CPT_AF_ACTIVE_CYCLES_PC);
+	rsp->exe_err_info = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
+	rsp->cptclk_cnt = rvu_read64(rvu, blkaddr, CPT_AF_CPTCLK_CNT);
+	rsp->diag = rvu_read64(rvu, blkaddr, CPT_AF_DIAG);
+
+	return 0;
+}
+
 #define RXC_ZOMBIE_THRES  GENMASK_ULL(59, 48)
 #define RXC_ZOMBIE_LIMIT  GENMASK_ULL(43, 32)
 #define RXC_ACTIVE_THRES  GENMASK_ULL(27, 16)
-- 
2.25.1

