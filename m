Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEF92AE976
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgKKHQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:16:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726348AbgKKHOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:14:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB758LV017975;
        Tue, 10 Nov 2020 23:14:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HIz//2h3t51QE/QaJhzpc4tqnZUPPriV82G8qCToSF0=;
 b=fx1CQNaKXTwFAcDl9yxNOBw51ShF6U/oKmwkn8oLTa/XTgyt3mhoFHVK8jR4h4x7pTrg
 xH4oUcNAfFtjFlyg2Sn7wbeAfEFWNif8FI/kYIbUPHjwQLyK6HEIF9l17PExnw5vDuEx
 vs11nXy0Ob9wforPD+W3xQQO4pdZlszglTO3JK9B/7k1AmRgXnjYWWMuljDbSCa4Z9/e
 8OLnyccoLe1Xz08ot/PwWuKbm+4kmNXJgJNDCvAE5paSxFI5hRw+uZqWxG+XJe6zpjPL
 nswQ/2qtekgLE/uYWtZvAFuf7Pm3dmGXfP6XbYpKnWJ9XCGC8gCSg1k+aFod6mVxreEk dQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34nstu6840-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 23:14:53 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 23:14:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 23:14:53 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 8AD7D3F7040;
        Tue, 10 Nov 2020 23:14:49 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [PATCH v3 net-next 11/13] octeontx2-af: Handle PF-VF mac address changes
Date:   Wed, 11 Nov 2020 12:44:02 +0530
Message-ID: <20201111071404.29620-12-naveenm@marvell.com>
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
index 15e668a87aa1..4bc75be6d45b 100644
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
index 53c5556d7061..f5affb809c77 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3737,3 +3737,12 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
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
index 7bb5e6760509..2f4030821d8d 100644
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

