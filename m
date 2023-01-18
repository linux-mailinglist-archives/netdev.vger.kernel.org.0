Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E091671AB2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjARLdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjARLcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:32:25 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BC849952;
        Wed, 18 Jan 2023 02:51:50 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8gARE008715;
        Wed, 18 Jan 2023 02:51:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=S9pH40IbO0i2kKbZ0W07rwnkXJZ/0slCd2dMtCp72As=;
 b=RmcSUpNcvQPzhbV5ii0ABi2pJB8D4jMUNjwMbspG8by3G+Skk6slwYeucGtpIm+LVgD1
 u3T5udCA87AnUkR6UmgFVCgWA8CPaSqxhCY1z4pMDY9eT5Ahh7nL1hScBXGeLPBQ1AUN
 w7VLXsBL56tQUL2aVv1LBuS7ElaEm3VhbWop1kZEjqxve/vpWp/7RrZRyb32U7NjfB+f
 swNfgRP9yirvPzcFgCWYe1nCrsSuFKPhLd4CXycMxfIYZ2oEfKH38AUN54dm1JEPuzUY
 2Mf1pCYdmjoE4hK5+tBQzDtt7cGXA4MS7b0Il/DYSEomCzoRmaolREak2EPlppA8vODh sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgguq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:51:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:51:38 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:51:37 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 64BF23F706A;
        Wed, 18 Jan 2023 02:51:32 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <tariqt@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <maxtram95@gmail.com>
Subject: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to configure TL1 RR_PRIO
Date:   Wed, 18 Jan 2023 16:21:06 +0530
Message-ID: <20230118105107.9516-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118105107.9516-1-hkelam@marvell.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: drjLtNNWlxpd6yfrhtXjaZTEudf6TeMM
X-Proofpoint-GUID: drjLtNNWlxpd6yfrhtXjaZTEudf6TeMM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All VFs and PF netdev shares same TL1 schedular, each interface
PF or VF will have different TL2 schedulars having same parent
TL1. The TL1 RR_PRIO value is static and PF/VFs use the same value
to configure its TL2 node priority in case of DWRR children.

This patch adds support to configure TL1 RR_PRIO value using devlink.
The TL1 RR_PRIO can be configured for each PF. The VFs are not allowed
to configure TL1 RR_PRIO value. The VFs can get the RR_PRIO value from
the mailbox NIX_TXSCH_ALLOC response parameter aggr_lvl_rr_prio.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/common.h    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  9 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 15 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 39 +++++++++-
 .../marvell/octeontx2/nic/otx2_common.c       |  9 ++-
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 .../marvell/octeontx2/nic/otx2_devlink.c      | 78 +++++++++++++++++++
 8 files changed, 147 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8931864ee110..f5bf719a6ccf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -142,7 +142,7 @@ enum nix_scheduler {
 
 #define TXSCH_RR_QTM_MAX		((1 << 24) - 1)
 #define TXSCH_TL1_DFLT_RR_QTM		TXSCH_RR_QTM_MAX
-#define TXSCH_TL1_DFLT_RR_PRIO		(0x1ull)
+#define TXSCH_TL1_DFLT_RR_PRIO		(0x7ull)
 #define CN10K_MAX_DWRR_WEIGHT          16384 /* Weight is 14bit on CN10K */
 
 /* Min/Max packet sizes, excluding FCS */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 94e743b5b545..6f0199766d5a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -84,7 +84,7 @@ struct mbox_msghdr {
 #define OTX2_MBOX_REQ_SIG (0xdead)
 #define OTX2_MBOX_RSP_SIG (0xbeef)
 	u16 sig;         /* Signature, for validating corrupted msgs */
-#define OTX2_MBOX_VERSION (0x000a)
+#define OTX2_MBOX_VERSION (0x000b)
 	u16 ver;         /* Version of msg's structure for this ID */
 	u16 next_msgoff; /* Offset of next msg within mailbox region */
 	int rc;          /* Msg process'ed response code */
@@ -299,6 +299,7 @@ M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
 				nix_bandprof_get_hwinfo_rsp)		    \
 M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
 				msg_req, nix_inline_ipsec_cfg)		\
+M(NIX_TL1_RR_PRIO,	0x8025, nix_tl1_rr_prio, nix_tl1_rr_prio_req, msg_rsp) \
 /* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
 M(MCS_ALLOC_RESOURCES,	0xa000, mcs_alloc_resources, mcs_alloc_rsrc_req,	\
 				mcs_alloc_rsrc_rsp)				\
@@ -825,6 +826,7 @@ enum nix_af_status {
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
 	NIX_AF_ERR_LINK_CREDITS  = -431,
+	NIX_AF_ERR_TL1_RR_PRIO_PERM_DENIED  = -433,
 };
 
 /* For NIX RX vtag action  */
@@ -1269,6 +1271,11 @@ struct nix_bandprof_get_hwinfo_rsp {
 	u32 policer_timeunit;
 };
 
+struct nix_tl1_rr_prio_req {
+	struct mbox_msghdr hdr;
+	u8 tl1_rr_prio;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3f5e09b77d4b..7d2230359bf0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -808,6 +808,18 @@ static void rvu_setup_pfvf_macaddress(struct rvu *rvu)
 	}
 }
 
+static void rvu_setup_pfvf_aggr_lvl_rr_prio(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_pfvf *pfvf;
+	int pf;
+
+	for (pf = 0; pf < hw->total_pfs; pf++) {
+		pfvf = &rvu->pf[pf];
+		pfvf->tl1_rr_prio = TXSCH_TL1_DFLT_RR_PRIO;
+	}
+}
+
 static int rvu_fwdata_init(struct rvu *rvu)
 {
 	u64 fwdbase;
@@ -1136,6 +1148,9 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	/* Assign MACs for CGX mapped functions */
 	rvu_setup_pfvf_macaddress(rvu);
 
+	/* Assign aggr level RR Priority */
+	rvu_setup_pfvf_aggr_lvl_rr_prio(rvu);
+
 	err = rvu_npa_init(rvu);
 	if (err) {
 		dev_err(rvu->dev, "%s: Failed to initialize npa\n", __func__);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7f0a64731c67..eec890f98803 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -254,6 +254,7 @@ struct rvu_pfvf {
 	u64     lmt_map_ent_w1; /* Preseving the word1 of lmtst map table entry*/
 	unsigned long flags;
 	struct  sdp_node_info *sdp_info;
+	u8	tl1_rr_prio; /* RR PRIORITY set by PF */
 };
 
 enum rvu_pfvf_flags {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index c11859999074..ef9f62aa6e2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2001,6 +2001,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *parent_pf;
 	int link, blkaddr, rc = 0;
 	int lvl, idx, start, end;
 	struct nix_txsch *txsch;
@@ -2017,6 +2018,8 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 	if (!nix_hw)
 		return NIX_AF_ERR_INVALID_NIXBLK;
 
+	parent_pf = &rvu->pf[rvu_get_pf(pcifunc)];
+
 	mutex_lock(&rvu->rsrc_lock);
 
 	/* Check if request is valid as per HW capabilities
@@ -2076,7 +2079,7 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 	}
 
 	rsp->aggr_level = hw->cap.nix_tx_aggr_lvl;
-	rsp->aggr_lvl_rr_prio = TXSCH_TL1_DFLT_RR_PRIO;
+	rsp->aggr_lvl_rr_prio = parent_pf->tl1_rr_prio;
 	rsp->link_cfg_lvl = rvu_read64(rvu, blkaddr,
 				       NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
 				       NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
@@ -2375,7 +2378,9 @@ static bool is_txschq_shaping_valid(struct rvu_hwinfo *hw, int lvl, u64 reg)
 static void nix_tl1_default_cfg(struct rvu *rvu, struct nix_hw *nix_hw,
 				u16 pcifunc, int blkaddr)
 {
+	struct rvu_pfvf *parent_pf = &rvu->pf[rvu_get_pf(pcifunc)];
 	u32 *pfvf_map;
+
 	int schq;
 
 	schq = nix_get_tx_link(rvu, pcifunc);
@@ -2384,7 +2389,7 @@ static void nix_tl1_default_cfg(struct rvu *rvu, struct nix_hw *nix_hw,
 	if (TXSCH_MAP_FLAGS(pfvf_map[schq]) & NIX_TXSCHQ_CFG_DONE)
 		return;
 	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_TOPOLOGY(schq),
-		    (TXSCH_TL1_DFLT_RR_PRIO << 1));
+		    (parent_pf->tl1_rr_prio << 1));
 
 	/* On OcteonTx2 the config was in bytes and newer silcons
 	 * it's changed to weight.
@@ -5548,3 +5553,33 @@ int rvu_mbox_handler_nix_bandprof_get_hwinfo(struct rvu *rvu, struct msg_req *re
 
 	return 0;
 }
+
+int rvu_mbox_handler_nix_tl1_rr_prio(struct rvu *rvu,
+				     struct nix_tl1_rr_prio_req *req,
+				     struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr, nixlf, schq, err;
+	struct rvu_pfvf *pfvf;
+	u16 regval;
+
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	if (err)
+		return err;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	/* Only PF is allowed */
+	if (is_vf(pcifunc))
+		return NIX_AF_ERR_TL1_RR_PRIO_PERM_DENIED;
+
+	pfvf->tl1_rr_prio = req->tl1_rr_prio;
+
+	/* update TL1 topology */
+	schq = nix_get_tx_link(rvu, pcifunc);
+	regval = rvu_read64(rvu, blkaddr, NIX_AF_TL1X_TOPOLOGY(schq));
+	regval &= ~GENMASK_ULL(4, 1);
+	regval |= pfvf->tl1_rr_prio << 1;
+	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_TOPOLOGY(schq), regval);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a4c18565f9f4..96132cfe2141 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -591,7 +591,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 	u16 (*schq_list)[MAX_TXSCHQ_PER_FUNC];
 	struct otx2_hw *hw = &pfvf->hw;
 	struct nix_txschq_config *req;
-	u64 schq, parent;
+	u16 schq, parent;
 	u64 dwrr_val;
 
 	dwrr_val = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
@@ -654,7 +654,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
-		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
+		req->regval[1] = hw->txschq_aggr_lvl_rr_prio << 24 | dwrr_val;
 
 		if (lvl == hw->txschq_link_cfg_lvl) {
 			req->num_regs++;
@@ -678,7 +678,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL1X_TOPOLOGY(schq);
-		req->regval[1] = (TXSCH_TL1_DFLT_RR_PRIO << 1);
+		req->regval[1] = hw->txschq_aggr_lvl_rr_prio << 1;
 
 		req->num_regs++;
 		req->reg[2] = NIX_AF_TL1X_CIR(schq);
@@ -742,6 +742,9 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
 			pfvf->hw.txschq_list[lvl][schq] =
 				rsp->schq_list[lvl][schq];
 
+	pfvf->hw.txschq_link_cfg_lvl     = rsp->link_cfg_lvl;
+	pfvf->hw.txschq_aggr_lvl_rr_prio = rsp->aggr_lvl_rr_prio;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b142cc685a28..3e09f52f2dc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -208,6 +208,7 @@ struct otx2_hw {
 
 	/* NIX */
 	u8			txschq_link_cfg_lvl;
+	u8			txschq_aggr_lvl_rr_prio;
 	u16			txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 63ef7c41d18d..b6bb6945f08a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -64,9 +64,82 @@ static int otx2_dl_mcam_count_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int otx2_dl_tl1_rr_prio_validate(struct devlink *devlink, u32 id,
+					union devlink_param_value val,
+					struct netlink_ext_ack *extack)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pf = otx2_dl->pfvf;
+
+	if (is_otx2_vf(pf->pcifunc)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TL1RR PRIORITY setting not allowed on VFs");
+		return -EOPNOTSUPP;
+	}
+
+	if (pci_num_vf(pf->pdev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "TL1RR PRIORITY setting not allowed as VFs are already attached");
+		return -EOPNOTSUPP;
+	}
+
+	if (val.vu8 > 7) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Valid priority range 0 - 7");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int otx2_dl_tl1_rr_prio_get(struct devlink *devlink, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	ctx->val.vu8 = pfvf->hw.txschq_aggr_lvl_rr_prio;
+
+	return 0;
+}
+
+static int otx2_dl_tl1_rr_prio_set(struct devlink *devlink, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+	struct nix_tl1_rr_prio_req *req;
+	bool if_up;
+	int err;
+
+	if_up = netif_running(pfvf->netdev);
+
+	/* send mailbox to AF */
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_tl1_rr_prio(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->tl1_rr_prio = ctx->val.vu8;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	/* Reconfigure TL1/TL2 DWRR PRIORITY */
+	if (!err && if_up) {
+		otx2_stop(pfvf->netdev);
+		otx2_open(pfvf->netdev);
+	}
+
+	return err;
+}
+
 enum otx2_dl_param_id {
 	OTX2_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
+	OTX2_DEVLINK_PARAM_ID_TL1_RR_PRIO,
 };
 
 static const struct devlink_param otx2_dl_params[] = {
@@ -75,6 +148,11 @@ static const struct devlink_param otx2_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_dl_mcam_count_get, otx2_dl_mcam_count_set,
 			     otx2_dl_mcam_count_validate),
+	DEVLINK_PARAM_DRIVER(OTX2_DEVLINK_PARAM_ID_TL1_RR_PRIO,
+			     "tl1_rr_prio", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_dl_tl1_rr_prio_get, otx2_dl_tl1_rr_prio_set,
+			     otx2_dl_tl1_rr_prio_validate),
 };
 
 static const struct devlink_ops otx2_devlink_ops = {
-- 
2.17.1

