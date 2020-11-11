Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C3D2AE983
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgKKHRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:17:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726351AbgKKHPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:15:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB76X3s003314;
        Tue, 10 Nov 2020 23:14:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=VrXVxz0EhmRnMew41qSiU1p2HGuVEHE4/6Yp/B4MCGk=;
 b=lVGnFSosXGsaenyFrh3kjUFYd7pNoUHIFC6w3Rx74RwDjJ6aA6X51S8298kKnZS3qbeb
 iauai2KXV1ScNyQwMPnXE94MYN8sba7OQQUbLHJYQpm80BXTxVE8+zyuihV8mByZAiJf
 WiG1Uf5e4pfLg9gZBR5Hz582jP3nA3P7o91vWQZsQsLFXKpNJPEYMtdYWV+N9IF9m69E
 VDaBIjy69gKdTCTOGkpwx2PNIGKxM3+GJvUoktPtuNxvbd2uYpKiavBey6mgy+sLyaqh
 Vr9FOuq9LKktpMIWHyyrf1N+jtEUfmGvXrEhdOSn+UFAbsE1yg9m8bv50ewJWsE4T2Dh Dg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysnes2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 23:14:58 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 23:14:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 23:14:56 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 66FC03F7040;
        Tue, 10 Nov 2020 23:14:53 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [PATCH v3 net-next 12/13] octeontx2-af: Add new mbox messages to retrieve MCAM entries
Date:   Wed, 11 Nov 2020 12:44:03 +0530
Message-ID: <20201111071404.29620-13-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201111071404.29620-1-naveenm@marvell.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-11_02:2020-11-10,2020-11-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces new mailbox mesages to retrieve a given
MCAM entry or base flow steering rule of a VF installed by its
parent PF. This helps while updating the existing MCAM rules
with out re-framing the whole mailbox request again. The INSTALL
FLOW mailbox consumer can read-modify-write the existing entry.
Similarly while installing new flow rules for a VF, the base
flow steering rule match creteria is copied to the new flow rule
and the deltas are appended to the new rule.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Co-developed-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 22 +++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 70 ++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ef20078508a5..8ea132ec1784 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -192,6 +192,11 @@ M(NPC_INSTALL_FLOW,	  0x600d, npc_install_flow,			       \
 				  npc_install_flow_req, npc_install_flow_rsp)  \
 M(NPC_DELETE_FLOW,	  0x600e, npc_delete_flow,			\
 				  npc_delete_flow_req, msg_rsp)		\
+M(NPC_MCAM_READ_ENTRY,	  0x600f, npc_mcam_read_entry,			\
+				  npc_mcam_read_entry_req,		\
+				  npc_mcam_read_entry_rsp)		\
+M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
+				   msg_req, npc_mcam_read_base_rule_rsp)  \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -1009,6 +1014,23 @@ struct npc_delete_flow_req {
 	u8 all; /* PF + VFs */
 };
 
+struct npc_mcam_read_entry_req {
+	struct mbox_msghdr hdr;
+	u16 entry;	 /* MCAM entry to read */
+};
+
+struct npc_mcam_read_entry_rsp {
+	struct mbox_msghdr hdr;
+	struct mcam_entry entry_data;
+	u8 intf;
+	u8 enable;
+};
+
+struct npc_mcam_read_base_rule_rsp {
+	struct mbox_msghdr hdr;
+	struct mcam_entry entry;
+};
+
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 84e954dafe85..9b5c5b376cc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2194,6 +2194,30 @@ int rvu_mbox_handler_npc_mcam_free_entry(struct rvu *rvu,
 	return rc;
 }
 
+int rvu_mbox_handler_npc_mcam_read_entry(struct rvu *rvu,
+					 struct npc_mcam_read_entry_req *req,
+					 struct npc_mcam_read_entry_rsp *rsp)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr, rc;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return NPC_MCAM_INVALID_REQ;
+
+	mutex_lock(&mcam->lock);
+	rc = npc_mcam_verify_entry(mcam, pcifunc, req->entry);
+	if (!rc) {
+		npc_read_mcam_entry(rvu, mcam, blkaddr, req->entry,
+				    &rsp->entry_data,
+				    &rsp->intf, &rsp->enable);
+	}
+
+	mutex_unlock(&mcam->lock);
+	return rc;
+}
+
 int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 					  struct npc_mcam_write_entry_req *req,
 					  struct msg_rsp *rsp)
@@ -2754,3 +2778,49 @@ bool rvu_npc_write_default_rule(struct rvu *rvu, int blkaddr, int nixlf,
 
 	return enable;
 }
+
+int rvu_mbox_handler_npc_read_base_steer_rule(struct rvu *rvu,
+					      struct msg_req *req,
+					      struct npc_mcam_read_base_rule_rsp *rsp)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int index, blkaddr, nixlf, rc = 0;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+	u8 intf, enable;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return NPC_MCAM_INVALID_REQ;
+
+	/* Return the channel number in case of PF */
+	if (!(pcifunc & RVU_PFVF_FUNC_MASK)) {
+		pfvf = rvu_get_pfvf(rvu, pcifunc);
+		rsp->entry.kw[0] = pfvf->rx_chan_base;
+		rsp->entry.kw_mask[0] = 0xFFFULL;
+		goto out;
+	}
+
+	/* Find the pkt steering rule installed by PF to this VF */
+	mutex_lock(&mcam->lock);
+	for (index = 0; index < mcam->bmap_entries; index++) {
+		if (mcam->entry2target_pffunc[index] == pcifunc)
+			goto read_entry;
+	}
+
+	rc = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
+	if (rc < 0) {
+		mutex_unlock(&mcam->lock);
+		goto out;
+	}
+	/* Read the default ucast entry if there is no pkt steering rule */
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc, nixlf,
+					 NIXLF_UCAST_ENTRY);
+read_entry:
+	/* Read the mcam entry */
+	npc_read_mcam_entry(rvu, mcam, blkaddr, index, &rsp->entry, &intf,
+			    &enable);
+	mutex_unlock(&mcam->lock);
+out:
+	return rc;
+}
-- 
2.16.5

