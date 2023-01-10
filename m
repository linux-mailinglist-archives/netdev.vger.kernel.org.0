Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39BC66393C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjAJGVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbjAJGVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:21:06 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5D430567
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:21:03 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30A2RIul015458;
        Mon, 9 Jan 2023 22:20:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=f4ckf/fecBmW83tOtnsw+TSxcEkY7gTojjBwvNJ5b5Y=;
 b=VjtA23wrdOumbTbWd9tyj4XEWIyklf2NtVnGrWxAONHaVSVUgYqSMTgnikqpDWG1zyta
 uKkk6tcCJRl3cCuUWSJcx2lvo0dt6PUn+0kSWY9/RT/6wmg/Jd0JTPSSGFYUcHkkNH9e
 iXykxYT2XWXMpwftV/VrtIa/1Lz9ekiXQ84LxvaRi06mwa9SMKWk1aO3ZiGhyO0Xko+M
 dooQXYq+NwYXT5eTutoErI3C9+tn1clmtCNnFjpyUc7+C9tA4vBtxOMmHAq3XvVpOcb4
 x73KREHj7lGwSh9mlVhaGYmi64mOoMCLXGjei0YLixhchWOgBvbZt/M0CfUNGXV5vezq vw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3my94tsn1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 22:20:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 9 Jan
 2023 22:20:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 9 Jan 2023 22:20:55 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id ADE0F3F7077;
        Mon,  9 Jan 2023 22:20:51 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v1 net-next,8/8] octeontx2-af: add mbox to return CPT_AF_FLT_INT info
Date:   Tue, 10 Jan 2023 11:50:19 +0530
Message-ID: <20230110062019.892719-9-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230110062019.892719-1-schalla@marvell.com>
References: <20230110062019.892719-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W7VwcjJpALp52WMgOBfGMHtBE3_M47gA
X-Proofpoint-GUID: W7VwcjJpALp52WMgOBfGMHtBE3_M47gA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_01,2023-01-09_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new mailbox to return CPT faulted engines bitmap
and recovered engines bitmap.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 17 ++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 34 +++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index abe86778b064..5727d67e0259 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -196,6 +196,8 @@ M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
 M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
 M(CPT_LF_RESET,         0xA08, cpt_lf_reset, cpt_lf_rst_req, msg_rsp)	\
+M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_flt_eng_info_req,	\
+			       cpt_flt_eng_info_rsp)			\
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -1706,6 +1708,21 @@ struct cpt_lf_rst_req {
 	u32 rsvd;
 };
 
+/* Mailbox message format to request for CPT faulted engines */
+struct cpt_flt_eng_info_req {
+	struct mbox_msghdr hdr;
+	int blkaddr;
+	bool reset;
+	u32 rsvd;
+};
+
+struct cpt_flt_eng_info_rsp {
+	struct mbox_msghdr hdr;
+	u64 flt_eng_map[CPT_10K_AF_INT_VEC_RVU];
+	u64 rcvrd_eng_map[CPT_10K_AF_INT_VEC_RVU];
+	u64 rsvd;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2f480c73ef55..5eea2b6cf6bd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -108,6 +108,8 @@ struct rvu_block {
 	u64  lfreset_reg;
 	unsigned char name[NAME_SIZE];
 	struct rvu *rvu;
+	u64 cpt_flt_eng_map[3];
+	u64 cpt_rcvrd_eng_map[3];
 };
 
 struct nix_mcast {
@@ -526,6 +528,8 @@ struct rvu {
 	struct list_head	mcs_intrq_head;
 	/* mcs interrupt queue lock */
 	spinlock_t		mcs_intrq_lock;
+	/* CPT interrupt lock */
+	spinlock_t		cpt_intr_lock;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index d7ca7e953683..7cc1efa603ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -70,6 +70,13 @@ static irqreturn_t cpt_af_flt_intr_handler(int vec, void *ptr)
 
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng), grp);
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng), val | 1ULL);
+
+		spin_lock(&rvu->cpt_intr_lock);
+		block->cpt_flt_eng_map[vec] |= BIT_ULL(i);
+		val = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(eng));
+		if ((val & 0x2) || (!(val & 0x2) && (val & 0x1)))
+			block->cpt_rcvrd_eng_map[vec] |= BIT_ULL(i);
+		spin_unlock(&rvu->cpt_intr_lock);
 	}
 	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(vec), reg);
 
@@ -899,6 +906,31 @@ int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cpt_flt_eng_info(struct rvu *rvu, struct cpt_flt_eng_info_req *req,
+				      struct cpt_flt_eng_info_rsp *rsp)
+{
+	struct rvu_block *block;
+	unsigned long flags;
+	int blkaddr, vec;
+
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	block = &rvu->hw->block[blkaddr];
+	for (vec = 0; vec < CPT_10K_AF_INT_VEC_RVU; vec++) {
+		spin_lock_irqsave(&rvu->cpt_intr_lock, flags);
+		rsp->flt_eng_map[vec] = block->cpt_flt_eng_map[vec];
+		rsp->rcvrd_eng_map[vec] = block->cpt_rcvrd_eng_map[vec];
+		if (req->reset) {
+			block->cpt_flt_eng_map[vec] = 0x0;
+			block->cpt_rcvrd_eng_map[vec] = 0x0;
+		}
+		spin_unlock_irqrestore(&rvu->cpt_intr_lock, flags);
+	}
+	return 0;
+}
+
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
 	struct cpt_rxc_time_cfg_req req, prev;
@@ -1182,5 +1214,7 @@ int rvu_cpt_init(struct rvu *rvu)
 {
 	/* Retrieve CPT PF number */
 	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	spin_lock_init(&rvu->cpt_intr_lock);
+
 	return 0;
 }
-- 
2.25.1

