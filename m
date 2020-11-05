Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5552F2A7A81
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgKEJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:29:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731510AbgKEJ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:29:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A59PhOV017255;
        Thu, 5 Nov 2020 01:29:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OWJ0mO/mdPyofm5HF3EJv8vOOUUrdEXzz+8BaMdCS/k=;
 b=TpGpA1BtTGs3s11g55Fu89JtaDLfgdMfctOpKM3HF7Xk0IFc+nM6htuY8obq4lmDf5y6
 slXqMmfSLBHTAbIu9SpLgmYXr0Bv577HcGg11ZYGUYWl0xdD/kf+Z5kkrCaZ5gyuUVCv
 GxxLMQ2nMZwLtwo8e60KrwJGXJWYigWPnMWjzxRS8fxbsGvOz+WAmgbEhlWiahjoY1ZD
 3GBQioDh1de5jLjpKEQWfE6aOLAzfKWR2zWr0fhgiEwIHn0lRQAS7eWmEJeFteOe+ZYN
 9l9eai8QSGHKOHQfGiCFfRHUDRC26fc84rdxpcP9wNHr7QQVewdH2ERM9y9PNJJgyKJy wA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ep6met-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 01:29:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Nov
 2020 01:29:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 01:29:08 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 1AE7A3F704C;
        Thu,  5 Nov 2020 01:29:03 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>
Subject: [PATCH v2 net-next 10/13] octeontx2-pf: Add support for SR-IOV management functions
Date:   Thu, 5 Nov 2020 14:58:13 +0530
Message-ID: <20201105092816.819-11-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201105092816.819-1-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_05:2020-11-05,2020-11-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for ndo_set_vf_mac, ndo_set_vf_vlan
and ndo_get_vf_config handlers. The traffic redirection
based on the VF mac address or vlan id is done by installing
MCAM rules. Reserved RX_VTAG_TYPE7 in each NIXLF for VF VLAN
which strips the VLAN tag from ingress VLAN traffic. The NIX PF
allocates two MCAM entries for VF VLAN feature, one used for
ingress VTAG strip and another entry for egress VTAG insertion.

This patch also updates the MAC address in PF installed VF VLAN
rule upon receiving nix_lf_start_rx mbox request for VF since
Administrative Function driver will assign a valid MAC addr
in nix_lf_start_rx function.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Co-developed-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  14 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  88 +++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  40 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   9 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  19 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 255 +++++++++++++++++++++
 9 files changed, 432 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 860706033aad..35d0348a9d29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -452,6 +452,7 @@ struct rvu_npc_mcam_rule {
 	bool has_cntr;
 	u8 default_rule;
 	bool enable;
+	bool vfvlan_cfg;
 };
 
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 6a45573724b4..15e668a87aa1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -209,6 +209,7 @@ struct rvu_pfvf {
 	u16		maxlen;
 	u16		minlen;
 
+	u8		pf_set_vf_cfg;
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 
 	/* Broadcast pkt replication info */
@@ -596,6 +597,9 @@ void npc_mcam_enable_flows(struct rvu *rvu, u16 target);
 void npc_mcam_disable_flows(struct rvu *rvu, u16 target);
 void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			   int blkaddr, int index, bool enable);
+void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
+			 int blkaddr, u16 src, struct mcam_entry *entry,
+			 u8 *intf, u8 *ena);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 97a8f932d1e2..53c5556d7061 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1196,6 +1196,11 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Disable NPC entries as NIXLF's contexts are not initialized yet */
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
 
+	/* Configure RX VTAG Type 7 (strip) for vf vlan */
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_LFX_RX_VTAG_TYPEX(nixlf, NIX_AF_LFX_RX_VTAG_TYPE7),
+		    VTAGSIZE_T4 | VTAG_STRIP);
+
 	goto exit;
 
 free_mem:
@@ -1990,6 +1995,10 @@ static int nix_rx_vtag_cfg(struct rvu *rvu, int nixlf, int blkaddr,
 	    req->vtag_size > VTAGSIZE_T8)
 		return -EINVAL;
 
+	/* RX VTAG Type 7 reserved for vf vlan */
+	if (req->rx.vtag_type == NIX_AF_LFX_RX_VTAG_TYPE7)
+		return NIX_AF_ERR_RX_VTAG_INUSE;
+
 	if (req->rx.capture_vtag)
 		regval |= BIT_ULL(5);
 	if (req->rx.strip_vtag)
@@ -2933,6 +2942,7 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 				      struct nix_set_mac_addr *req,
 				      struct msg_rsp *rsp)
 {
+	bool from_vf = req->hdr.pcifunc & RVU_PFVF_FUNC_MASK;
 	u16 pcifunc = req->hdr.pcifunc;
 	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
@@ -2943,6 +2953,10 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 
+	/* VF can't overwrite admin(PF) changes */
+	if (from_vf && pfvf->pf_set_vf_cfg)
+		return -EPERM;
+
 	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
 
 	rvu_npc_install_ucast_entry(rvu, pcifunc, nixlf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index a7759ecfa586..84e954dafe85 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -359,6 +359,58 @@ static void npc_get_keyword(struct mcam_entry *entry, int idx,
 	*cam0 = ~*cam1 & kw_mask;
 }
 
+static void npc_fill_entryword(struct mcam_entry *entry, int idx,
+			       u64 cam0, u64 cam1)
+{
+	/* Similar to npc_get_keyword, but fills mcam_entry structure from
+	 * CAM registers.
+	 */
+	switch (idx) {
+	case 0:
+		entry->kw[0] = cam1;
+		entry->kw_mask[0] = cam1 ^ cam0;
+		break;
+	case 1:
+		entry->kw[1] = cam1;
+		entry->kw_mask[1] = cam1 ^ cam0;
+		break;
+	case 2:
+		entry->kw[1] |= (cam1 & CAM_MASK(16)) << 48;
+		entry->kw[2] = (cam1 >> 16) & CAM_MASK(48);
+		entry->kw_mask[1] |= ((cam1 ^ cam0) & CAM_MASK(16)) << 48;
+		entry->kw_mask[2] = ((cam1 ^ cam0) >> 16) & CAM_MASK(48);
+		break;
+	case 3:
+		entry->kw[2] |= (cam1 & CAM_MASK(16)) << 48;
+		entry->kw[3] = (cam1 >> 16) & CAM_MASK(32);
+		entry->kw_mask[2] |= ((cam1 ^ cam0) & CAM_MASK(16)) << 48;
+		entry->kw_mask[3] = ((cam1 ^ cam0) >> 16) & CAM_MASK(32);
+		break;
+	case 4:
+		entry->kw[3] |= (cam1 & CAM_MASK(32)) << 32;
+		entry->kw[4] = (cam1 >> 32) & CAM_MASK(32);
+		entry->kw_mask[3] |= ((cam1 ^ cam0) & CAM_MASK(32)) << 32;
+		entry->kw_mask[4] = ((cam1 ^ cam0) >> 32) & CAM_MASK(32);
+		break;
+	case 5:
+		entry->kw[4] |= (cam1 & CAM_MASK(32)) << 32;
+		entry->kw[5] = (cam1 >> 32) & CAM_MASK(16);
+		entry->kw_mask[4] |= ((cam1 ^ cam0) & CAM_MASK(32)) << 32;
+		entry->kw_mask[5] = ((cam1 ^ cam0) >> 32) & CAM_MASK(16);
+		break;
+	case 6:
+		entry->kw[5] |= (cam1 & CAM_MASK(48)) << 16;
+		entry->kw[6] = (cam1 >> 48) & CAM_MASK(16);
+		entry->kw_mask[5] |= ((cam1 ^ cam0) & CAM_MASK(48)) << 16;
+		entry->kw_mask[6] = ((cam1 ^ cam0) >> 48) & CAM_MASK(16);
+		break;
+	case 7:
+		entry->kw[6] |= (cam1 & CAM_MASK(48)) << 16;
+		entry->kw_mask[6] |= ((cam1 ^ cam0) & CAM_MASK(48)) << 16;
+		break;
+	}
+}
+
 static void npc_get_default_entry_action(struct rvu *rvu, struct npc_mcam *mcam,
 					 int blkaddr, int index,
 					 struct mcam_entry *entry)
@@ -459,6 +511,42 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 		npc_enable_mcam_entry(rvu, mcam, blkaddr, actindex, true);
 }
 
+void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
+			 int blkaddr, u16 src,
+			 struct mcam_entry *entry, u8 *intf, u8 *ena)
+{
+	int sbank = npc_get_bank(mcam, src);
+	int bank, kw = 0;
+	u64 cam0, cam1;
+
+	src &= (mcam->banksize - 1);
+	bank = sbank;
+
+	for (; bank < (sbank + mcam->banks_per_entry); bank++, kw = kw + 2) {
+		cam1 = rvu_read64(rvu, blkaddr,
+				  NPC_AF_MCAMEX_BANKX_CAMX_W0(src, bank, 1));
+		cam0 = rvu_read64(rvu, blkaddr,
+				  NPC_AF_MCAMEX_BANKX_CAMX_W0(src, bank, 0));
+		npc_fill_entryword(entry, kw, cam0, cam1);
+
+		cam1 = rvu_read64(rvu, blkaddr,
+				  NPC_AF_MCAMEX_BANKX_CAMX_W1(src, bank, 1));
+		cam0 = rvu_read64(rvu, blkaddr,
+				  NPC_AF_MCAMEX_BANKX_CAMX_W1(src, bank, 0));
+		npc_fill_entryword(entry, kw + 1, cam0, cam1);
+	}
+
+	entry->action = rvu_read64(rvu, blkaddr,
+				   NPC_AF_MCAMEX_BANKX_ACTION(src, sbank));
+	entry->vtag_action =
+		rvu_read64(rvu, blkaddr,
+			   NPC_AF_MCAMEX_BANKX_TAG_ACT(src, sbank));
+	*intf = rvu_read64(rvu, blkaddr,
+			   NPC_AF_MCAMEX_BANKX_CAMX_INTF(src, sbank, 1)) & 3;
+	*ena = rvu_read64(rvu, blkaddr,
+			  NPC_AF_MCAMEX_BANKX_CFG(src, sbank)) & 1;
+}
+
 static void npc_copy_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				int blkaddr, u16 src, u16 dest)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 94b52dfb6ac6..7bb5e6760509 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1065,6 +1065,9 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	if (req->default_rule)
 		pfvf->def_ucast_rule = rule;
 
+	if (pfvf->pf_set_vf_cfg && req->vtag0_type == NIX_AF_LFX_RX_VTAG_TYPE7)
+		rule->vfvlan_cfg = true;
+
 	return 0;
 }
 
@@ -1113,6 +1116,10 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 
 	pfvf = rvu_get_pfvf(rvu, target);
 
+	/* PF installing for its VF */
+	if (req->hdr.pcifunc && !from_vf && req->vf)
+		pfvf->pf_set_vf_cfg = 1;
+
 	/* update req destination mac addr */
 	if ((req->features & BIT_ULL(NPC_DMAC)) && is_npc_intf_rx(req->intf) &&
 	    is_zero_ether_addr(req->packet.dmac)) {
@@ -1210,6 +1217,36 @@ int rvu_mbox_handler_npc_delete_flow(struct rvu *rvu,
 	return 0;
 }
 
+static int npc_update_dmac_value(struct rvu *rvu, int npcblkaddr,
+				 struct rvu_npc_mcam_rule *rule,
+				 struct rvu_pfvf *pfvf)
+{
+	struct npc_mcam_write_entry_req write_req = { 0 };
+	struct mcam_entry *entry = &write_req.entry_data;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct msg_rsp rsp;
+	u8 intf, enable;
+	int err;
+
+	ether_addr_copy(rule->packet.dmac, pfvf->mac_addr);
+
+	npc_read_mcam_entry(rvu, mcam, npcblkaddr, rule->entry,
+			    entry, &intf,  &enable);
+
+	npc_update_entry(rvu, NPC_DMAC, entry,
+			 ether_addr_to_u64(pfvf->mac_addr), 0,
+			 0xffffffffffffull, 0, intf);
+
+	write_req.hdr.pcifunc = rule->owner;
+	write_req.entry = rule->entry;
+
+	mutex_unlock(&mcam->lock);
+	err = rvu_mbox_handler_npc_mcam_write_entry(rvu, &write_req, &rsp);
+	mutex_lock(&mcam->lock);
+
+	return err;
+}
+
 void npc_mcam_enable_flows(struct rvu *rvu, u16 target)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, target);
@@ -1236,6 +1273,9 @@ void npc_mcam_enable_flows(struct rvu *rvu, u16 target)
 				continue;
 			}
 
+			if (rule->vfvlan_cfg)
+				npc_update_dmac_value(rvu, blkaddr, rule, pfvf);
+
 			if (rule->rx_action.op == NIX_RX_ACTION_DEFAULT) {
 				if (!def_ucast_rule)
 					continue;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 9a7eb074cdc2..723643868589 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -921,4 +921,15 @@ enum nix_vtag_size {
 	VTAGSIZE_T4   = 0x0,
 	VTAGSIZE_T8   = 0x1,
 };
+
+enum nix_tx_vtag_op {
+	NOP		= 0x0,
+	VTAG_INSERT	= 0x1,
+	VTAG_REPLACE	= 0x2,
+};
+
+/* NIX RX VTAG actions */
+#define VTAG_STRIP	BIT_ULL(4)
+#define VTAG_CAPTURE	BIT_ULL(5)
+
 #endif /* RVU_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 535235bc8649..d9b8f2dbb5c4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -206,6 +206,9 @@ struct otx2_vf_config {
 	struct otx2_nic *pf;
 	struct delayed_work link_event_work;
 	bool intf_down; /* interface was either configured or not */
+	u8 mac[ETH_ALEN];
+	u16 vlan;
+	int tx_vtag_idx;
 };
 
 struct flr_work {
@@ -241,6 +244,10 @@ struct otx2_flow_config {
 	u32			ntuple_offset;
 	u32			unicast_offset;
 	u32			rx_vlan_offset;
+	u32			vf_vlan_offset;
+#define OTX2_PER_VF_VLAN_FLOWS	2 /* rx+tx per VF */
+#define OTX2_VF_VLAN_RX_INDEX	0
+#define OTX2_VF_VLAN_TX_INDEX	1
 	u32                     ntuple_max_flows;
 	struct list_head	flow_list;
 };
@@ -259,6 +266,8 @@ struct otx2_nic {
 #define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
 #define OTX2_FLAG_UCAST_FLTR_SUPPORT		BIT_ULL(5)
 #define OTX2_FLAG_RX_VLAN_SUPPORT		BIT_ULL(6)
+#define OTX2_FLAG_VF_VLAN_SUPPORT		BIT_ULL(7)
+#define OTX2_FLAG_PF_SHUTDOWN			BIT_ULL(8)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 826e65954186..3b111b3e4469 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -40,7 +40,9 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
 
 	pf->flags |= (OTX2_FLAG_NTUPLE_SUPPORT |
-		      OTX2_FLAG_UCAST_FLTR_SUPPORT | OTX2_FLAG_RX_VLAN_SUPPORT);
+		      OTX2_FLAG_UCAST_FLTR_SUPPORT |
+		      OTX2_FLAG_RX_VLAN_SUPPORT |
+		      OTX2_FLAG_VF_VLAN_SUPPORT);
 
 	pf->mac_table = devm_kzalloc(pf->dev, sizeof(struct otx2_mac_table)
 					* OTX2_MAX_UNICAST_FLOWS, GFP_KERNEL);
@@ -62,6 +64,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 				   NETIF_F_HW_VLAN_CTAG_RX;
 	struct npc_mcam_alloc_entry_req *req;
 	struct npc_mcam_alloc_entry_rsp *rsp;
+	int vf_vlan_max_flows;
 	int i;
 
 	mutex_lock(&pfvf->mbox.lock);
@@ -77,8 +80,9 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
+	vf_vlan_max_flows = pfvf->total_vfs * OTX2_PER_VF_VLAN_FLOWS;
 	req->contig = false;
-	req->count = OTX2_MCAM_COUNT;
+	req->count = OTX2_MCAM_COUNT + vf_vlan_max_flows;
 
 	/* Send message to AF */
 	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
@@ -100,10 +104,13 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		pfvf->netdev->priv_flags &= ~IFF_UNICAST_FLT;
 		pfvf->flags &= ~OTX2_FLAG_UCAST_FLTR_SUPPORT;
 		pfvf->flags &= ~OTX2_FLAG_RX_VLAN_SUPPORT;
+		pfvf->flags &= ~OTX2_FLAG_VF_VLAN_SUPPORT;
 		pfvf->netdev->features &= ~wanted;
 		pfvf->netdev->hw_features &= ~wanted;
 	} else {
-		flow_cfg->ntuple_offset = 0;
+		flow_cfg->vf_vlan_offset = 0;
+		flow_cfg->ntuple_offset = flow_cfg->vf_vlan_offset +
+						vf_vlan_max_flows;
 		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
 						OTX2_MAX_NTUPLE_FLOWS;
 		flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
@@ -802,12 +809,6 @@ int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable)
 	struct mbox_msghdr *rsp_hdr;
 	int err;
 
-	if (!(pf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC)) {
-		err = otx2_alloc_mcam_entries(pf);
-		if (err)
-			return err;
-	}
-
 	/* Dont have enough mcam entries */
 	if (!(pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT))
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 4411270509d0..cc483d6d3e92 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1425,6 +1425,8 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	free_req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
 	if (free_req) {
 		free_req->flags = NIX_LF_DISABLE_FLOWS;
+		if (!(pf->flags & OTX2_FLAG_PF_SHUTDOWN))
+			free_req->flags |= NIX_LF_DONT_FREE_TX_VTAG;
 		if (otx2_sync_mbox_msg(mbox))
 			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
 	}
@@ -1566,6 +1568,15 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_set_cints_affinity(pf);
 
+	if ((pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT) ||
+	    (pf->flags & OTX2_FLAG_VF_VLAN_SUPPORT)) {
+		if (!(pf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC)) {
+			err = otx2_alloc_mcam_entries(pf);
+			if (err)
+				goto err_free_cints;
+		}
+	}
+
 	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 		otx2_enable_rxvlan(pf, true);
 
@@ -1929,6 +1940,245 @@ otx2_features_check(struct sk_buff *skb, struct net_device *dev,
 	return features;
 }
 
+static int otx2_do_set_vf_mac(struct otx2_nic *pf, int vf, const u8 *mac)
+{
+	struct npc_install_flow_req *req;
+	int err;
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ether_addr_copy(req->packet.dmac, mac);
+	eth_broadcast_addr((u8 *)&req->mask.dmac);
+	req->features = BIT_ULL(NPC_DMAC);
+	req->channel = pf->hw.rx_chan_base;
+	req->intf = NIX_INTF_RX;
+	req->default_rule = 1;
+	req->append = 1;
+	req->vf = vf + 1;
+	req->op = NIX_RX_ACTION_DEFAULT;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+out:
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+static int otx2_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct pci_dev *pdev = pf->pdev;
+	struct otx2_vf_config *config;
+	int ret;
+
+	if (!netif_running(netdev))
+		return -EAGAIN;
+
+	if (vf >= pci_num_vf(pdev))
+		return -EINVAL;
+
+	if (!is_valid_ether_addr(mac))
+		return -EINVAL;
+
+	config = &pf->vf_configs[vf];
+	ether_addr_copy(config->mac, mac);
+
+	ret = otx2_do_set_vf_mac(pf, vf, mac);
+	if (ret == 0)
+		dev_info(&pdev->dev, "Reload VF driver to apply the changes\n");
+
+	return ret;
+}
+
+static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
+			       __be16 proto)
+{
+	struct otx2_flow_config *flow_cfg = pf->flow_cfg;
+	struct nix_vtag_config_rsp *vtag_rsp;
+	struct npc_delete_flow_req *del_req;
+	struct nix_vtag_config *vtag_req;
+	struct npc_install_flow_req *req;
+	struct otx2_vf_config *config;
+	int err = 0;
+	u32 idx;
+
+	config = &pf->vf_configs[vf];
+
+	if (!vlan && !config->vlan)
+		goto out;
+
+	mutex_lock(&pf->mbox.lock);
+
+	/* free old tx vtag entry */
+	if (config->vlan) {
+		vtag_req = otx2_mbox_alloc_msg_nix_vtag_cfg(&pf->mbox);
+		if (!vtag_req) {
+			err = -ENOMEM;
+			goto out;
+		}
+		vtag_req->cfg_type = 0;
+		vtag_req->tx.free_vtag0 = 1;
+		vtag_req->tx.vtag0_idx = config->tx_vtag_idx;
+
+		err = otx2_sync_mbox_msg(&pf->mbox);
+		if (err)
+			goto out;
+	}
+
+	if (!vlan && config->vlan) {
+		/* rx */
+		del_req = otx2_mbox_alloc_msg_npc_delete_flow(&pf->mbox);
+		if (!del_req) {
+			err = -ENOMEM;
+			goto out;
+		}
+		idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_RX_INDEX);
+		del_req->entry =
+			flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+		err = otx2_sync_mbox_msg(&pf->mbox);
+		if (err)
+			goto out;
+
+		/* tx */
+		del_req = otx2_mbox_alloc_msg_npc_delete_flow(&pf->mbox);
+		if (!del_req) {
+			err = -ENOMEM;
+			goto out;
+		}
+		idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_TX_INDEX);
+		del_req->entry =
+			flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+		err = otx2_sync_mbox_msg(&pf->mbox);
+
+		goto out;
+	}
+
+	/* rx */
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_RX_INDEX);
+	req->entry = flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+	req->packet.vlan_tci = htons(vlan);
+	req->mask.vlan_tci = htons(VLAN_VID_MASK);
+	/* af fills the destination mac addr */
+	eth_broadcast_addr((u8 *)&req->mask.dmac);
+	req->features = BIT_ULL(NPC_OUTER_VID) | BIT_ULL(NPC_DMAC);
+	req->channel = pf->hw.rx_chan_base;
+	req->intf = NIX_INTF_RX;
+	req->vf = vf + 1;
+	req->op = NIX_RX_ACTION_DEFAULT;
+	req->vtag0_valid = true;
+	req->vtag0_type = NIX_AF_LFX_RX_VTAG_TYPE7;
+	req->set_cntr = 1;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err)
+		goto out;
+
+	/* tx */
+	vtag_req = otx2_mbox_alloc_msg_nix_vtag_cfg(&pf->mbox);
+	if (!vtag_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* configure tx vtag params */
+	vtag_req->vtag_size = VTAGSIZE_T4;
+	vtag_req->cfg_type = 0; /* tx vlan cfg */
+	vtag_req->tx.cfg_vtag0 = 1;
+	vtag_req->tx.vtag0 = (ntohs(proto) << 16) | vlan;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err)
+		goto out;
+
+	vtag_rsp = (struct nix_vtag_config_rsp *)otx2_mbox_get_rsp
+			(&pf->mbox.mbox, 0, &vtag_req->hdr);
+	if (IS_ERR(vtag_rsp)) {
+		err = PTR_ERR(vtag_rsp);
+		goto out;
+	}
+	config->tx_vtag_idx = vtag_rsp->vtag0_idx;
+
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	eth_zero_addr((u8 *)&req->mask.dmac);
+	idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_TX_INDEX);
+	req->entry = flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+	req->features = BIT_ULL(NPC_DMAC);
+	req->channel = pf->hw.tx_chan_base;
+	req->intf = NIX_INTF_TX;
+	req->vf = vf + 1;
+	req->op = NIX_TX_ACTIONOP_UCAST_DEFAULT;
+	req->vtag0_def = vtag_rsp->vtag0_idx;
+	req->vtag0_op = VTAG_INSERT;
+	req->set_cntr = 1;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+out:
+	config->vlan = vlan;
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+static int otx2_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
+			    __be16 proto)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct pci_dev *pdev = pf->pdev;
+
+	if (!netif_running(netdev))
+		return -EAGAIN;
+
+	if (vf >= pci_num_vf(pdev))
+		return -EINVAL;
+
+	/* qos is currently unsupported */
+	if (vlan >= VLAN_N_VID || qos)
+		return -EINVAL;
+
+	if (proto != htons(ETH_P_8021Q))
+		return -EPROTONOSUPPORT;
+
+	if (!(pf->flags & OTX2_FLAG_VF_VLAN_SUPPORT))
+		return -EOPNOTSUPP;
+
+	return otx2_do_set_vf_vlan(pf, vf, vlan, qos, proto);
+}
+
+static int otx2_get_vf_config(struct net_device *netdev, int vf,
+			      struct ifla_vf_info *ivi)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct pci_dev *pdev = pf->pdev;
+	struct otx2_vf_config *config;
+
+	if (!netif_running(netdev))
+		return -EAGAIN;
+
+	if (vf >= pci_num_vf(pdev))
+		return -EINVAL;
+
+	config = &pf->vf_configs[vf];
+	ivi->vf = vf;
+	ether_addr_copy(ivi->mac, config->mac);
+	ivi->vlan = config->vlan;
+
+	return 0;
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
@@ -1941,6 +2191,9 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_get_stats64	= otx2_get_stats64,
 	.ndo_do_ioctl		= otx2_ioctl,
 	.ndo_features_check     = otx2_features_check,
+	.ndo_set_vf_mac		= otx2_set_vf_mac,
+	.ndo_set_vf_vlan	= otx2_set_vf_vlan,
+	.ndo_get_vf_config	= otx2_get_vf_config,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
@@ -2328,6 +2581,8 @@ static void otx2_remove(struct pci_dev *pdev)
 
 	pf = netdev_priv(netdev);
 
+	pf->flags |= OTX2_FLAG_PF_SHUTDOWN;
+
 	if (pf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED)
 		otx2_config_hw_tx_tstamp(pf, false);
 	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED)
-- 
2.16.5

