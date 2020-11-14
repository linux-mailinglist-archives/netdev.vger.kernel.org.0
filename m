Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1AD2B3061
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgKNTyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:54:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50248 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbgKNTyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:54:00 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJoo2X005445;
        Sat, 14 Nov 2020 11:53:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PRshOa0EX13EbEWt7qezLmh2EXkXAgwgmrXUEcEH+5I=;
 b=flPUwIPFY6xIIucd3qudm84Uge+9Qvl4XpfrLsmhxpw1aaqgpEemUiPGkQcVyOK596t3
 hcBs7HHubGTtZlVhu0WEz8cmZHCaA/oizoYS95Cp9xyjhFamLPMJ9ukVCzkBNjsqHHum
 pKPy/fTtmi0oOMwL3XJd88y765syK51f7yZ+eoK527ieC3JFa1sSoNf9tCmhV2RAdb5G
 08VHhZNSdfEt8QaQXgwmKwfwI62RLxrd2lSfvwtnLBhduhXR0QD6teQQPH6qCpVnzdsP
 aAzohXKUMr37+UIyMsHvi1I9bRLg9bsLW6lqvHY84gVuMV1P3Dg9nAJVbFe8KqutcPW1 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfms8qfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:56 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:54 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 8E4593F703F;
        Sat, 14 Nov 2020 11:53:50 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 11/13] octeontx2-af: Handle PF-VF mac address changes
Date:   Sun, 15 Nov 2020 01:23:01 +0530
Message-ID: <20201114195303.25967-12-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
References: <20201114195303.25967-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

This patch handles the VF mac address changes as given below.
    1. mac addr configrued by VF will be retained until VF module unload.
    2. mac addr configred by PF for VF will be retained until power cycle.
    3. mac addr confgired by PF for its VF can't be overwritten by VF.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c        | 12 +++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h        |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  9 +++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 17 ++++++++++++++---
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8b5aaf73201..9f901c0edcbb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -727,6 +727,10 @@ static void rvu_setup_pfvf_macaddress(struct rvu *rvu)
 	u64 *mac;
 
 	for (pf = 0; pf < hw->total_pfs; pf++) {
+		/* For PF0(AF), Assign MAC address to only VFs (LBKVFs) */
+		if (!pf)
+			goto lbkvf;
+
 		if (!is_pf_cgxmapped(rvu, pf))
 			continue;
 		/* Assign MAC address to PF */
@@ -740,8 +744,10 @@ static void rvu_setup_pfvf_macaddress(struct rvu *rvu)
 		} else {
 			eth_random_addr(pfvf->mac_addr);
 		}
+		ether_addr_copy(pfvf->default_mac, pfvf->mac_addr);
 
-		/* Assign MAC address to VFs */
+lbkvf:
+		/* Assign MAC address to VFs*/
 		rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvf);
 		for (vf = 0; vf < numvfs; vf++, hwvf++) {
 			pfvf = &rvu->hwvf[hwvf];
@@ -754,6 +760,7 @@ static void rvu_setup_pfvf_macaddress(struct rvu *rvu)
 			} else {
 				eth_random_addr(pfvf->mac_addr);
 			}
+			ether_addr_copy(pfvf->default_mac, pfvf->mac_addr);
 		}
 	}
 }
@@ -1176,6 +1183,9 @@ static void rvu_detach_block(struct rvu *rvu, int pcifunc, int blktype)
 	if (blkaddr < 0)
 		return;
 
+	if (blktype == BLKTYPE_NIX)
+		rvu_nix_reset_mac(pfvf, pcifunc);
+
 	block = &hw->block[blkaddr];
 
 	num_lfs = rvu_get_rsrc_mapcount(pfvf, block->addr);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 90a9529f6555..fd46092ad189 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -211,6 +211,7 @@ struct rvu_pfvf {
 
 	u8		pf_set_vf_cfg;
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
+	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
 	/* Broadcast pkt replication info */
 	u16			bcast_mce_idx;
@@ -553,6 +554,7 @@ int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
 int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
 struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr);
 int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr);
+void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index e74bcd8395bc..9444c857ed3d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3735,3 +3735,12 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
 	return 0;
 }
+
+void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc)
+{
+	bool from_vf = !!(pcifunc & RVU_PFVF_FUNC_MASK);
+
+	/* overwrite vf mac address with default_mac */
+	if (from_vf)
+		ether_addr_copy(pfvf->mac_addr, pfvf->default_mac);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index ca50da714112..4ddfdff33a61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -938,7 +938,8 @@ static void npc_update_tx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			    int nixlf, struct rvu_pfvf *pfvf,
 			    struct npc_install_flow_req *req,
-			    struct npc_install_flow_rsp *rsp, bool enable)
+			    struct npc_install_flow_rsp *rsp, bool enable,
+			    bool pf_set_vfs_mac)
 {
 	struct rvu_npc_mcam_rule *def_ucast_rule = pfvf->def_ucast_rule;
 	u64 features, installed_features, missing_features = 0;
@@ -1065,6 +1066,12 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (req->default_rule)
 		pfvf->def_ucast_rule = rule;
 
+	/* VF's MAC address is being changed via PF  */
+	if (pf_set_vfs_mac) {
+		ether_addr_copy(pfvf->default_mac, req->packet.dmac);
+		ether_addr_copy(pfvf->mac_addr, req->packet.dmac);
+	}
+
 	if (pfvf->pf_set_vf_cfg && req->vtag0_type == NIX_AF_LFX_RX_VTAG_TYPE7)
 		rule->vfvlan_cfg = true;
 
@@ -1078,6 +1085,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	bool from_vf = !!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK);
 	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
+	bool pf_set_vfs_mac = false;
 	bool enable = true;
 	u16 target;
 
@@ -1102,8 +1110,11 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (!req->hdr.pcifunc)
 		target = req->vf;
 	/* PF installing for its VF */
-	else if (!from_vf && req->vf)
+	else if (!from_vf && req->vf) {
 		target = (req->hdr.pcifunc & ~RVU_PFVF_FUNC_MASK) | req->vf;
+		pf_set_vfs_mac = req->default_rule &&
+				(req->features & BIT_ULL(NPC_DMAC));
+	}
 	/* msg received from PF/VF */
 	else
 		target = req->hdr.pcifunc;
@@ -1152,7 +1163,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 		return -EINVAL;
 
 	return npc_install_flow(rvu, blkaddr, target, nixlf, pfvf, req, rsp,
-				enable);
+				enable, pf_set_vfs_mac);
 }
 
 static int npc_delete_flow(struct rvu *rvu, struct rvu_npc_mcam_rule *rule,
-- 
2.16.5

