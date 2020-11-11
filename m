Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853FB2AE979
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgKKHQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:16:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgKKHO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:14:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB76sKl003437;
        Tue, 10 Nov 2020 23:14:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=O5ykryv3fgawqjEEFpABWxrHsuI7g2nWYmoRzvYkgxY=;
 b=RpWO2NBGViFNS0v8r+OZetHpCdOIr2H/QmrJ4d3fccrAxgLb2O888F+AaUK1o8dD32uc
 HxqYRRH45VyeAC2p7LFEieBLGh6oKbKOqmXSFasc66Ir9vRPTtgi3uOiI5ij/vfU4Yud
 pcx/g/jZTLjksLJSHkid1mxPIvjt4AyW7JjnKYaOBKWR/npbFPWoPzqMcKMVvxYVSmX1
 L4kHvRw+JFsibJZkrN8GtwX4Bzw0Nqr3csUo+O+WANwD7FYG8zuDibkktYJNo93FG+S+
 cxkV3BW0cXb1mNSUTfFc4R4EmaZl5z0qEJuwtfWENENiC3qEu2pmb5H606cnQwjc1U9X VQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysneqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 23:14:18 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 23:14:16 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 23:14:17 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 89FBC3F7040;
        Tue, 10 Nov 2020 23:14:13 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [PATCH v3 net-next 02/13] octeontx2-af: Verify MCAM entry channel and PF_FUNC
Date:   Wed, 11 Nov 2020 12:43:53 +0530
Message-ID: <20201111071404.29620-3-naveenm@marvell.com>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

This patch adds support to verify the channel number sent by
mailbox requester before writing MCAM entry for Ingress packets.
Similarly for Egress packets, verifying the PF_FUNC sent by the
mailbox user.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 78 ++++++++++++++++++++++
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index a28a518c0eae..e8b5aaf73201 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2642,7 +2642,7 @@ static void rvu_enable_afvf_intr(struct rvu *rvu)
 
 #define PCI_DEVID_OCTEONTX2_LBK 0xA061
 
-static int lbk_get_num_chans(void)
+int rvu_get_num_lbk_chans(void)
 {
 	struct pci_dev *pdev;
 	void __iomem *base;
@@ -2677,7 +2677,7 @@ static int rvu_enable_sriov(struct rvu *rvu)
 		return 0;
 	}
 
-	chans = lbk_get_num_chans();
+	chans = rvu_get_num_lbk_chans();
 	if (chans < 0)
 		return chans;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 5ac9bb12415f..1724dbd18847 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -445,6 +445,7 @@ int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot);
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
 int rvu_get_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc);
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero);
+int rvu_get_num_lbk_chans(void);
 
 /* RVU HW reg validation */
 enum regmap_block {
@@ -535,6 +536,7 @@ bool is_npc_intf_tx(u8 intf);
 bool is_npc_intf_rx(u8 intf);
 bool is_npc_interface_valid(struct rvu *rvu, u8 intf);
 int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
+int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 989533a3d2ce..3666159bb6b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -28,6 +28,8 @@
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
 #define NPC_HW_TSTAMP_OFFSET		8
+#define NPC_KEX_CHAN_MASK		0xFFFULL
+#define NPC_KEX_PF_FUNC_MASK		0xFFFFULL
 
 static const char def_pfl_name[] = "default";
 
@@ -63,6 +65,54 @@ int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena)
 	return 0;
 }
 
+static int npc_mcam_verify_pf_func(struct rvu *rvu,
+				   struct mcam_entry *entry_data, u8 intf,
+				   u16 pcifunc)
+{
+	u16 pf_func, pf_func_mask;
+
+	if (is_npc_intf_rx(intf))
+		return 0;
+
+	pf_func_mask = (entry_data->kw_mask[0] >> 32) &
+		NPC_KEX_PF_FUNC_MASK;
+	pf_func = (entry_data->kw[0] >> 32) & NPC_KEX_PF_FUNC_MASK;
+
+	pf_func = be16_to_cpu((__force __be16)pf_func);
+	if (pf_func_mask != NPC_KEX_PF_FUNC_MASK ||
+	    ((pf_func & ~RVU_PFVF_FUNC_MASK) !=
+	     (pcifunc & ~RVU_PFVF_FUNC_MASK)))
+		return -EINVAL;
+
+	return 0;
+}
+
+int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel)
+{
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	int base = 0, end;
+
+	if (is_npc_intf_tx(intf))
+		return 0;
+
+	if (is_afvf(pcifunc)) {
+		end = rvu_get_num_lbk_chans();
+		if (end < 0)
+			return -EINVAL;
+	} else {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		base = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0x0);
+		/* CGX mapped functions has maximum of 16 channels */
+		end = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0xF);
+	}
+
+	if (channel < base || channel > end)
+		return -EINVAL;
+
+	return 0;
+}
+
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf)
 {
 	int blkaddr;
@@ -1935,6 +1985,7 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
+	u16 channel, chan_mask;
 	int blkaddr, rc;
 	u8 nix_intf;
 
@@ -1942,6 +1993,10 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	if (blkaddr < 0)
 		return NPC_MCAM_INVALID_REQ;
 
+	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	channel &= chan_mask;
+
 	mutex_lock(&mcam->lock);
 	rc = npc_mcam_verify_entry(mcam, pcifunc, req->entry);
 	if (rc)
@@ -1963,6 +2018,17 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	else
 		nix_intf = pfvf->nix_rx_intf;
 
+	if (npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
+		rc = NPC_MCAM_INVALID_REQ;
+		goto exit;
+	}
+
+	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
+				    pcifunc)) {
+		rc = NPC_MCAM_INVALID_REQ;
+		goto exit;
+	}
+
 	npc_config_mcam_entry(rvu, mcam, blkaddr, req->entry, nix_intf,
 			      &req->entry_data, req->enable_entry);
 
@@ -2299,6 +2365,7 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 entry = NPC_MCAM_ENTRY_INVALID;
 	u16 cntr = NPC_MCAM_ENTRY_INVALID;
+	u16 channel, chan_mask;
 	int blkaddr, rc;
 	u8 nix_intf;
 
@@ -2309,6 +2376,17 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	if (!is_npc_interface_valid(rvu, req->intf))
 		return NPC_MCAM_INVALID_REQ;
 
+	chan_mask = req->entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	channel = req->entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	channel &= chan_mask;
+
+	if (npc_mcam_verify_channel(rvu, req->hdr.pcifunc, req->intf, channel))
+		return NPC_MCAM_INVALID_REQ;
+
+	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
+				    req->hdr.pcifunc))
+		return NPC_MCAM_INVALID_REQ;
+
 	/* Try to allocate a MCAM entry */
 	entry_req.hdr.pcifunc = req->hdr.pcifunc;
 	entry_req.contig = true;
-- 
2.16.5

