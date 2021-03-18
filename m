Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B873E3402A7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhCRKCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:02:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229894AbhCRKCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:02:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IA0gR6020909;
        Thu, 18 Mar 2021 03:02:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=rfOTWm346Bd98LbS/Xh7GeZ/0KxixjOv6TW58kWfZDs=;
 b=T5RRXBVQtTVeMrHDTCQgc2dZtRBKuwtXEbsbMh7ucYkDbVIZrNokdLFcqrt5F0yVFGvP
 XRwK3oln8YxZas9vO2ipVMZRdBrWzhC/0CRRSSOBQE6WH0EThyuomgVw5JZDDjQROzsB
 lpj5dxiZjDEMk60THB0OitFwf31OKUweydxfy7nJqHL72kMNJmrixlz4gBomjtOxZGLK
 M3Q6flU5cTRTNtTATGCCUN7lb2KWZ+C1Vgek9VtEFse6C98NSx69T4pXa+s83HmDwfAV
 qOfUGeiLKFNCEfoSWI1/gUOrKC5Qaic4h2sWieseC04hy13Edx6gnKlWii3ye+A0HJlH jQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqyxwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 03:02:36 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 03:02:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 03:02:34 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 5FCD53F703F;
        Thu, 18 Mar 2021 03:02:31 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 3/4] octeontx2-pf: add tc flower stats handler for hw offloads
Date:   Thu, 18 Mar 2021 15:32:14 +0530
Message-ID: <20210318100215.15795-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210318100215.15795-1-naveenm@marvell.com>
References: <20210318100215.15795-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to get the stats for tc flower flows that are
offloaded to hardware. To support this feature, added a
new AF mbox handler which returns the MCAM entry stats
for a flow that has hardware stat counter enabled.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 14 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 39 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 70 +++++++++++++++++++++-
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 46f919625464..3af4d0ffcf7c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -216,6 +216,9 @@ M(NPC_MCAM_READ_ENTRY,	  0x600f, npc_mcam_read_entry,			\
 				  npc_mcam_read_entry_rsp)		\
 M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 				   msg_req, npc_mcam_read_base_rule_rsp)  \
+M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
+				   npc_mcam_get_stats_req,              \
+				   npc_mcam_get_stats_rsp)              \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -1195,6 +1198,17 @@ struct npc_mcam_read_base_rule_rsp {
 	struct mcam_entry entry;
 };
 
+struct npc_mcam_get_stats_req {
+	struct mbox_msghdr hdr;
+	u16 entry; /* mcam entry */
+};
+
+struct npc_mcam_get_stats_rsp {
+	struct mbox_msghdr hdr;
+	u64 stat;  /* counter stats */
+	u8 stat_ena; /* enabled */
+};
+
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 6cce7ecad007..03248d280e47 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2806,3 +2806,42 @@ int rvu_mbox_handler_npc_read_base_steer_rule(struct rvu *rvu,
 out:
 	return rc;
 }
+
+int rvu_mbox_handler_npc_mcam_entry_stats(struct rvu *rvu,
+					  struct npc_mcam_get_stats_req *req,
+					  struct npc_mcam_get_stats_rsp *rsp)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u16 index, cntr;
+	int blkaddr;
+	u64 regval;
+	u32 bank;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return NPC_MCAM_INVALID_REQ;
+
+	mutex_lock(&mcam->lock);
+
+	index = req->entry & (mcam->banksize - 1);
+	bank = npc_get_bank(mcam, req->entry);
+
+	/* read MCAM entry STAT_ACT register */
+	regval = rvu_read64(rvu, blkaddr, NPC_AF_MCAMEX_BANKX_STAT_ACT(index, bank));
+
+	if (!(regval & BIT_ULL(9))) {
+		rsp->stat_ena = 0;
+		mutex_unlock(&mcam->lock);
+		return 0;
+	}
+
+	cntr = regval & 0x1FF;
+
+	rsp->stat_ena = 1;
+	rsp->stat = rvu_read64(rvu, blkaddr, NPC_AF_MATCH_STATX(cntr));
+	rsp->stat &= BIT_ULL(48) - 1;
+
+	mutex_unlock(&mcam->lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index a361eec568a2..43ef6303ed84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -16,12 +16,20 @@
 
 #include "otx2_common.h"
 
+struct otx2_tc_flow_stats {
+	u64 bytes;
+	u64 pkts;
+	u64 used;
+};
+
 struct otx2_tc_flow {
 	struct rhash_head		node;
 	unsigned long			cookie;
 	u16				entry;
 	unsigned int			bitpos;
 	struct rcu_head			rcu;
+	struct otx2_tc_flow_stats	stats;
+	spinlock_t			lock; /* lock for stats */
 };
 
 static int otx2_tc_parse_actions(struct otx2_nic *nic,
@@ -403,6 +411,66 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	return rc;
 }
 
+static int otx2_tc_get_flow_stats(struct otx2_nic *nic,
+				  struct flow_cls_offload *tc_flow_cmd)
+{
+	struct otx2_tc_info *tc_info = &nic->tc_info;
+	struct npc_mcam_get_stats_req *req;
+	struct npc_mcam_get_stats_rsp *rsp;
+	struct otx2_tc_flow_stats *stats;
+	struct otx2_tc_flow *flow_node;
+	int err;
+
+	flow_node = rhashtable_lookup_fast(&tc_info->flow_table,
+					   &tc_flow_cmd->cookie,
+					   tc_info->flow_ht_params);
+	if (!flow_node) {
+		netdev_info(nic->netdev, "tc flow not found for cookie %lx",
+			    tc_flow_cmd->cookie);
+		return -EINVAL;
+	}
+
+	mutex_lock(&nic->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_npc_mcam_entry_stats(&nic->mbox);
+	if (!req) {
+		mutex_unlock(&nic->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->entry = flow_node->entry;
+
+	err = otx2_sync_mbox_msg(&nic->mbox);
+	if (err) {
+		netdev_err(nic->netdev, "Failed to get stats for MCAM flow entry %d\n",
+			   req->entry);
+		mutex_unlock(&nic->mbox.lock);
+		return -EFAULT;
+	}
+
+	rsp = (struct npc_mcam_get_stats_rsp *)otx2_mbox_get_rsp
+		(&nic->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		mutex_unlock(&nic->mbox.lock);
+		return PTR_ERR(rsp);
+	}
+
+	mutex_unlock(&nic->mbox.lock);
+
+	if (!rsp->stat_ena)
+		return -EINVAL;
+
+	stats = &flow_node->stats;
+
+	spin_lock(&flow_node->lock);
+	flow_stats_update(&tc_flow_cmd->stats, 0x0, rsp->stat - stats->pkts, 0x0, 0x0,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+	stats->pkts = rsp->stat;
+	spin_unlock(&flow_node->lock);
+
+	return 0;
+}
+
 static int otx2_setup_tc_cls_flower(struct otx2_nic *nic,
 				    struct flow_cls_offload *cls_flower)
 {
@@ -412,7 +480,7 @@ static int otx2_setup_tc_cls_flower(struct otx2_nic *nic,
 	case FLOW_CLS_DESTROY:
 		return otx2_tc_del_flow(nic, cls_flower);
 	case FLOW_CLS_STATS:
-		return -EOPNOTSUPP;
+		return otx2_tc_get_flow_stats(nic, cls_flower);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.16.5

