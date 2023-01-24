Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED3679A0E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbjAXNoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbjAXNnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:43:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D6222E0;
        Tue, 24 Jan 2023 05:42:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C1960FAC;
        Tue, 24 Jan 2023 13:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1235C4339C;
        Tue, 24 Jan 2023 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567772;
        bh=g+K0JXbsCSeZByFw0evBidowk4dbrOeSeO06x4AdzDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9iATxH0UjGO4TlAGODCCq3vGdBuarto5l95dW7P9Le0bPA3VQUgaIbG8g/YeFFKM
         c/9p7li1Ch5kTYasJmXQzp3g6UPNQQVb8kuVZpMQlsLdvE/e0bWLsOocRm9Kywfmdm
         KGmoEGokVXrmmBI1Di5WDBf0qLScydJ4FD2VKOUIZlFCvUKUZJ1wNncKE05vHDQ4Yu
         9FO3nDDuq2p3QC1AyqicTmMOatDdjp/ogwpfc2Vxyd76Q/EdDlzsarSiycJC+odetK
         BgLNpVbL0fEaRQG8BzS7afBf+QUj97IKudsz7QmJdw6SAdJv57L2J6u9e8OFWj46zO
         3zJmrqgHN7PdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 33/35] octeontx2-af: add mbox to return CPT_AF_FLT_INT info
Date:   Tue, 24 Jan 2023 08:41:29 -0500
Message-Id: <20230124134131.637036-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 8299ffe3dc3dc9ac2bd60e3a8332008f03156aca ]

CPT HW would trigger the CPT AF FLT interrupt when CPT engines
hits some uncorrectable errors and AF is the one which receives
the interrupt and recovers the engines.
This patch adds a mailbox for CPT VFs to request for CPT faulted
and recovered engines info.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 17 +++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  4 +++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 35 +++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index afcdd579a8fd..158ac89bd4ed 100644
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
@@ -1684,6 +1686,21 @@ struct cpt_lf_rst_req {
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
index 0210318698b2..bcbfcd72a9b3 100644
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
@@ -520,6 +522,8 @@ struct rvu {
 	struct list_head	mcs_intrq_head;
 	/* mcs interrupt queue lock */
 	spinlock_t		mcs_intrq_lock;
+	/* CPT interrupt lock */
+	spinlock_t		cpt_intr_lock;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index d7ca7e953683..f047185f38e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -70,6 +70,14 @@ static irqreturn_t cpt_af_flt_intr_handler(int vec, void *ptr)
 
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng), grp);
 		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng), val | 1ULL);
+
+		spin_lock(&rvu->cpt_intr_lock);
+		block->cpt_flt_eng_map[vec] |= BIT_ULL(i);
+		val = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(eng));
+		val = val & 0x3;
+		if (val == 0x1 || val == 0x2)
+			block->cpt_rcvrd_eng_map[vec] |= BIT_ULL(i);
+		spin_unlock(&rvu->cpt_intr_lock);
 	}
 	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(vec), reg);
 
@@ -899,6 +907,31 @@ int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
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
@@ -1182,5 +1215,7 @@ int rvu_cpt_init(struct rvu *rvu)
 {
 	/* Retrieve CPT PF number */
 	rvu->cpt_pf_num = get_cpt_pf_num(rvu);
+	spin_lock_init(&rvu->cpt_intr_lock);
+
 	return 0;
 }
-- 
2.39.0

