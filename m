Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E85E3CCFBB
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbhGSITo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:19:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235678AbhGSITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:19:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J8u0CR006763;
        Mon, 19 Jul 2021 02:00:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=oTMFG8D/S7z+/0HPHTr0reHEooxAkOs/MFI6UmnBSSI=;
 b=LW51QoZxPS7pZ+qgtuh0wp2YhLFvisn40YJYWihrPjEajI1zZQwaPDCPbdW1kPkio/tq
 RoDhmxfAuWeRK+Ujh+DGek8SqhqR6b/i6F90PY1WhPKiSTf4YT+rONn+RoRfre9ugx82
 6ICQBzuzIlVDl/PO+0U8v6ruaFf4eqVXovUPtg6ww8utnqzIdTFI3t1op76FkspX306y
 osMmOGrx7pOwKp5HlxU2zYLSXGOrdUxmdw8ZnDH1/VMImn5Ui/uAr01FlxBfwqW47tG6
 +sgRrxBQP6FW2WH6visryjM6yA1djC3IVe7bDFtkVQotdmfSDPj/0ag10IRIwcor183H Vw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39vytq9621-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 02:00:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Jul
 2021 02:00:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 19 Jul 2021 02:00:07 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id C00645E686D;
        Mon, 19 Jul 2021 02:00:02 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/3] octeontx2-af: Prepare for allocating MCAM rules for AF
Date:   Mon, 19 Jul 2021 14:29:33 +0530
Message-ID: <1626685174-4766-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
References: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 000aE75mmFWcNZ_OiKtTGW-Re4R05CIe
X-Proofpoint-GUID: 000aE75mmFWcNZ_OiKtTGW-Re4R05CIe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_02:2021-07-16,2021-07-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AF till now only manages the allocation and freeing of
MCAM rules for other PF/VFs in system. To implement
L2 switching between all CGX mapped PF and VFs, AF
requires MCAM entries for DMAC rules for each PF and VF.
This patch modifies AF driver such that AF can also
allocate MCAM rules and install rules for other
PFs and VFs. All the checks like channel verification
for RX rules and PF_FUNC verification for TX rules are
relaxed in case AF is allocating or installing rules.
Also all the entry and counter to owner mappings are
set to NPC_MCAM_INVALID_MAP when they are free indicating
those are not allocated to AF nor PF/VFs.
This patch also ensures that AF allocated and installed
entries are displayed in debugfs.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  5 +---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 32 ++++++++++++++++------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 11 ++++----
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 370d4ca..9b2dfbf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2113,9 +2113,6 @@ static void rvu_print_npc_mcam_info(struct seq_file *s,
 	int entry_acnt, entry_ecnt;
 	int cntr_acnt, cntr_ecnt;
 
-	/* Skip PF0 */
-	if (!pcifunc)
-		return;
 	rvu_npc_get_mcam_entry_alloc_info(rvu, pcifunc, blkaddr,
 					  &entry_acnt, &entry_ecnt);
 	rvu_npc_get_mcam_counter_alloc_info(rvu, pcifunc, blkaddr,
@@ -2298,7 +2295,7 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 static void rvu_dbg_npc_mcam_show_action(struct seq_file *s,
 					 struct rvu_npc_mcam_rule *rule)
 {
-	if (rule->intf == NIX_INTF_TX) {
+	if (is_npc_intf_tx(rule->intf)) {
 		switch (rule->tx_action.op) {
 		case NIX_TX_ACTIONOP_DROP:
 			seq_puts(s, "\taction: Drop\n");
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 16c557c..1097291 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -442,7 +442,8 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 	owner = mcam->entry2pfvf_map[index];
 	target_func = (entry->action >> 4) & 0xffff;
 	/* do nothing when target is LBK/PF or owner is not PF */
-	if (is_afvf(target_func) || (owner & RVU_PFVF_FUNC_MASK) ||
+	if (is_pffunc_af(owner) || is_afvf(target_func) ||
+	    (owner & RVU_PFVF_FUNC_MASK) ||
 	    !(target_func & RVU_PFVF_FUNC_MASK))
 		return;
 
@@ -661,6 +662,7 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 	eth_broadcast_addr((u8 *)&req.mask.dmac);
 	req.features = BIT_ULL(NPC_DMAC);
 	req.channel = chan;
+	req.chan_mask = 0xFFFU;
 	req.intf = pfvf->nix_rx_intf;
 	req.op = action.op;
 	req.hdr.pcifunc = 0; /* AF is requester */
@@ -810,6 +812,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	eth_broadcast_addr((u8 *)&req.mask.dmac);
 	req.features = BIT_ULL(NPC_DMAC);
 	req.channel = chan;
+	req.chan_mask = 0xFFFU;
 	req.intf = pfvf->nix_rx_intf;
 	req.entry = index;
 	req.hdr.pcifunc = 0; /* AF is requester */
@@ -1756,6 +1759,8 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	int nixlf_count = rvu_get_nixlf_count(rvu);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int rsvd, err;
+	u16 index;
+	int cntr;
 	u64 cfg;
 
 	/* Actual number of MCAM entries vary by entry size */
@@ -1856,6 +1861,14 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	if (!mcam->entry2target_pffunc)
 		goto free_mem;
 
+	for (index = 0; index < mcam->bmap_entries; index++) {
+		mcam->entry2pfvf_map[index] = NPC_MCAM_INVALID_MAP;
+		mcam->entry2cntr_map[index] = NPC_MCAM_INVALID_MAP;
+	}
+
+	for (cntr = 0; cntr < mcam->counters.max; cntr++)
+		mcam->cntr2pfvf_map[cntr] = NPC_MCAM_INVALID_MAP;
+
 	mutex_init(&mcam->lock);
 
 	return 0;
@@ -2573,7 +2586,7 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 	}
 
 	/* Alloc request from PFFUNC with no NIXLF attached should be denied */
-	if (!is_nixlf_attached(rvu, pcifunc))
+	if (!is_pffunc_af(pcifunc) && !is_nixlf_attached(rvu, pcifunc))
 		return NPC_MCAM_ALLOC_DENIED;
 
 	return npc_mcam_alloc_entries(mcam, pcifunc, req, rsp);
@@ -2593,7 +2606,7 @@ int rvu_mbox_handler_npc_mcam_free_entry(struct rvu *rvu,
 		return NPC_MCAM_INVALID_REQ;
 
 	/* Free request from PFFUNC with no NIXLF attached, ignore */
-	if (!is_nixlf_attached(rvu, pcifunc))
+	if (!is_pffunc_af(pcifunc) && !is_nixlf_attached(rvu, pcifunc))
 		return NPC_MCAM_INVALID_REQ;
 
 	mutex_lock(&mcam->lock);
@@ -2605,7 +2618,7 @@ int rvu_mbox_handler_npc_mcam_free_entry(struct rvu *rvu,
 	if (rc)
 		goto exit;
 
-	mcam->entry2pfvf_map[req->entry] = 0;
+	mcam->entry2pfvf_map[req->entry] = NPC_MCAM_INVALID_MAP;
 	mcam->entry2target_pffunc[req->entry] = 0x0;
 	npc_mcam_clear_bit(mcam, req->entry);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, req->entry, false);
@@ -2690,13 +2703,14 @@ int rvu_mbox_handler_npc_mcam_write_entry(struct rvu *rvu,
 	else
 		nix_intf = pfvf->nix_rx_intf;
 
-	if (npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
+	if (!is_pffunc_af(pcifunc) &&
+	    npc_mcam_verify_channel(rvu, pcifunc, req->intf, channel)) {
 		rc = NPC_MCAM_INVALID_REQ;
 		goto exit;
 	}
 
-	if (npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf,
-				    pcifunc)) {
+	if (!is_pffunc_af(pcifunc) &&
+	    npc_mcam_verify_pf_func(rvu, &req->entry_data, req->intf, pcifunc)) {
 		rc = NPC_MCAM_INVALID_REQ;
 		goto exit;
 	}
@@ -2847,7 +2861,7 @@ int rvu_mbox_handler_npc_mcam_alloc_counter(struct rvu *rvu,
 		return NPC_MCAM_INVALID_REQ;
 
 	/* If the request is from a PFFUNC with no NIXLF attached, ignore */
-	if (!is_nixlf_attached(rvu, pcifunc))
+	if (!is_pffunc_af(pcifunc) && !is_nixlf_attached(rvu, pcifunc))
 		return NPC_MCAM_INVALID_REQ;
 
 	/* Since list of allocated counter IDs needs to be sent to requester,
@@ -3092,7 +3106,7 @@ int rvu_mbox_handler_npc_mcam_alloc_and_write_entry(struct rvu *rvu,
 	if (rc) {
 		/* Free allocated MCAM entry */
 		mutex_lock(&mcam->lock);
-		mcam->entry2pfvf_map[entry] = 0;
+		mcam->entry2pfvf_map[entry] = NPC_MCAM_INVALID_MAP;
 		npc_mcam_clear_bit(mcam, entry);
 		mutex_unlock(&mcam->lock);
 		return rc;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 92d64bd..c1f35a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -913,11 +913,9 @@ static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 				struct npc_install_flow_req *req, u16 target)
 {
 	struct nix_rx_action action;
-	u64 chan_mask;
 
-	chan_mask = req->chan_mask ? req->chan_mask : ~0ULL;
-	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0, chan_mask, 0,
-			 NIX_INTF_RX);
+	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0, req->chan_mask,
+			 0, NIX_INTF_RX);
 
 	*(u64 *)&action = 0x00;
 	action.pf_func = target;
@@ -1171,7 +1169,9 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (err)
 		return err;
 
-	if (npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
+	/* Skip channel validation if AF is installing */
+	if (!is_pffunc_af(req->hdr.pcifunc) &&
+	    npc_mcam_verify_channel(rvu, target, req->intf, req->channel))
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, target);
@@ -1187,6 +1187,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 		eth_broadcast_addr((u8 *)&req->mask.dmac);
 	}
 
+	/* Proceed if NIXLF is attached or not for TX rules */
 	err = nix_get_nixlf(rvu, target, &nixlf, NULL);
 	if (err && is_npc_intf_rx(req->intf) && !pf_set_vfs_mac)
 		return -EINVAL;
-- 
2.7.4

