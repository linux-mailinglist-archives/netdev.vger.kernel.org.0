Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF163A57BE
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFMKzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 06:55:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231176AbhFMKzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 06:55:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15DAox9C031134;
        Sun, 13 Jun 2021 03:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=szRGrvR2/Tau7W+54fgt8GvVZu4Vco/9Lh2y6tO1efg=;
 b=W7J6hetoSULCdsO+VswDALqhD7inv0mSZ6v6wBdmjde3+XMFFRM6fSsF0hM+iQ6SujjQ
 +4BPY9R4tmfVMXGrXSAQGzOz+4z8ju65TUBcv6v/Cm1WenaWMUoLVXwM3waUAZY7yj8E
 5vA/SkIwhSYFuxrcaclMfl0EInUDN+/iWZfNSI6SuHnu06BN+NX6HSpRNL+BGjUpxRL2
 FezRxRt+VgyeQMaMc9SYDGONRrJF7lCDqjBBweKfCxUU3Zm2DACP+v8Wo9Visp0EsAcz
 r8wPPF5/Fx3PNx9UPA0/1+DePE3RbLIE/2E6OgaVuQ8U7fZAq/2m0Wi3P6OIjI9yh29F 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 394t9qk9y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 03:53:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 13 Jun
 2021 03:53:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 13 Jun 2021 03:53:15 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id CB55F3F70BF;
        Sun, 13 Jun 2021 03:53:13 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Cleanup flow rule management
Date:   Sun, 13 Jun 2021 16:23:05 +0530
Message-ID: <1623581585-1416-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 7Xz9VI-9EuICAswgS7xJXvxw4zqRsCAc
X-Proofpoint-ORIG-GUID: 7Xz9VI-9EuICAswgS7xJXvxw4zqRsCAc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_04:2021-06-11,2021-06-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Current MCAM allocation scheme allocates a single lot of
MCAM entries for ntuple filters, unicast filters and VF VLAN
rules. This patch attempts to cleanup this logic by segregating
MCAM rule allocation and management for Ntuple rules and unicast,
VF VLAN rules. This segregation will result in reusing most of
the logic for supporting ntuple filters for VF devices.

Also added debug messages for MCAM entry allocation failures.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  30 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 191 ++++++++++++++++-----
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   4 +-
 5 files changed, 181 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 5c2bd43..ef833fe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2537,8 +2537,11 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 	rsp->free_count = 0;
 
 	/* Check if ref_entry is within range */
-	if (req->priority && req->ref_entry >= mcam->bmap_entries)
+	if (req->priority && req->ref_entry >= mcam->bmap_entries) {
+		dev_err(rvu->dev, "%s: reference entry %d is out of range\n",
+			__func__, req->ref_entry);
 		return NPC_MCAM_INVALID_REQ;
+	}
 
 	/* ref_entry can't be '0' if requested priority is high.
 	 * Can't be last entry if requested priority is low.
@@ -2551,8 +2554,12 @@ int rvu_mbox_handler_npc_mcam_alloc_entry(struct rvu *rvu,
 	/* Since list of allocated indices needs to be sent to requester,
 	 * max number of non-contiguous entries per mbox msg is limited.
 	 */
-	if (!req->contig && req->count > NPC_MAX_NONCONTIG_ENTRIES)
+	if (!req->contig && req->count > NPC_MAX_NONCONTIG_ENTRIES) {
+		dev_err(rvu->dev,
+			"%s: %d Non-contiguous MCAM entries requested is morethan max (%d) allowed\n",
+			__func__, req->count, NPC_MAX_NONCONTIG_ENTRIES);
 		return NPC_MCAM_INVALID_REQ;
+	}
 
 	/* Alloc request from PFFUNC with no NIXLF attached should be denied */
 	if (!is_nixlf_attached(rvu, pcifunc))
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 543aee7..e5616d4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -267,24 +267,26 @@ struct otx2_mac_table {
 
 struct otx2_flow_config {
 	u16			entry[NPC_MAX_NONCONTIG_ENTRIES];
-	u32			nr_flows;
-#define OTX2_MAX_NTUPLE_FLOWS	32
-#define OTX2_MAX_UNICAST_FLOWS	8
-#define OTX2_MAX_VLAN_FLOWS	1
-#define OTX2_MAX_TC_FLOWS	OTX2_MAX_NTUPLE_FLOWS
-#define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
+	u16			*flow_ent;
+	u16			*def_ent;
+	u16			nr_flows;
+#define OTX2_DEFAULT_FLOWCOUNT		16
+#define OTX2_MAX_UNICAST_FLOWS		8
+#define OTX2_MAX_VLAN_FLOWS		1
+#define OTX2_MAX_TC_FLOWS	OTX2_DEFAULT_FLOWCOUNT
+#define OTX2_MCAM_COUNT		(OTX2_DEFAULT_FLOWCOUNT + \
 				 OTX2_MAX_UNICAST_FLOWS + \
 				 OTX2_MAX_VLAN_FLOWS)
-	u32			ntuple_offset;
-	u32			unicast_offset;
-	u32			rx_vlan_offset;
-	u32			vf_vlan_offset;
-#define OTX2_PER_VF_VLAN_FLOWS	2 /* rx+tx per VF */
+	u16			ntuple_offset;
+	u16			unicast_offset;
+	u16			rx_vlan_offset;
+	u16			vf_vlan_offset;
+#define OTX2_PER_VF_VLAN_FLOWS	2 /* Rx + Tx per VF */
 #define OTX2_VF_VLAN_RX_INDEX	0
 #define OTX2_VF_VLAN_TX_INDEX	1
-	u32			tc_flower_offset;
-	u32                     ntuple_max_flows;
-	u32			tc_max_flows;
+	u16			tc_flower_offset;
+	u16                     ntuple_max_flows;
+	u16			tc_max_flows;
 	struct list_head	flow_list;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 80b7690..8c97106 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -20,13 +20,125 @@ struct otx2_flow {
 	int vf;
 };
 
+static void otx2_clear_ntuple_flow_info(struct otx2_nic *pfvf, struct otx2_flow_config *flow_cfg)
+{
+	devm_kfree(pfvf->dev, flow_cfg->flow_ent);
+	flow_cfg->flow_ent = NULL;
+	flow_cfg->ntuple_max_flows = 0;
+	flow_cfg->tc_max_flows = 0;
+}
+
+static int otx2_free_ntuple_mcam_entries(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_mcam_free_entry_req *req;
+	int ent, err;
+
+	if (!flow_cfg->ntuple_max_flows)
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	for (ent = 0; ent < flow_cfg->ntuple_max_flows; ent++) {
+		req = otx2_mbox_alloc_msg_npc_mcam_free_entry(&pfvf->mbox);
+		if (!req)
+			break;
+
+		req->entry = flow_cfg->flow_ent[ent];
+
+		/* Send message to AF to free MCAM entries */
+		err = otx2_sync_mbox_msg(&pfvf->mbox);
+		if (err)
+			break;
+	}
+	mutex_unlock(&pfvf->mbox.lock);
+	otx2_clear_ntuple_flow_info(pfvf, flow_cfg);
+	return 0;
+}
+
+static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_mcam_alloc_entry_req *req;
+	struct npc_mcam_alloc_entry_rsp *rsp;
+	int ent, allocated = 0;
+
+	/* Free current ones and allocate new ones with requested count */
+	otx2_free_ntuple_mcam_entries(pfvf);
+
+	if (!count)
+		return 0;
+
+	flow_cfg->flow_ent = devm_kmalloc_array(pfvf->dev, count,
+						sizeof(u16), GFP_KERNEL);
+	if (!flow_cfg->flow_ent)
+		return -ENOMEM;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	/* In a single request a max of NPC_MAX_NONCONTIG_ENTRIES MCAM entries
+	 * can only be allocated.
+	 */
+	while (allocated < count) {
+		req = otx2_mbox_alloc_msg_npc_mcam_alloc_entry(&pfvf->mbox);
+		if (!req)
+			goto exit;
+
+		req->contig = false;
+		req->count = (count - allocated) > NPC_MAX_NONCONTIG_ENTRIES ?
+				NPC_MAX_NONCONTIG_ENTRIES : count - allocated;
+		req->priority = NPC_MCAM_HIGHER_PRIO;
+		req->ref_entry = flow_cfg->def_ent[0];
+
+		/* Send message to AF */
+		if (otx2_sync_mbox_msg(&pfvf->mbox))
+			goto exit;
+
+		rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
+			(&pfvf->mbox.mbox, 0, &req->hdr);
+
+		for (ent = 0; ent < rsp->count; ent++)
+			flow_cfg->flow_ent[ent + allocated] = rsp->entry_list[ent];
+
+		allocated += rsp->count;
+
+		/* If this request is not fulfilled, no need to send
+		 * further requests.
+		 */
+		if (rsp->count != req->count)
+			break;
+	}
+
+exit:
+	mutex_unlock(&pfvf->mbox.lock);
+
+	flow_cfg->ntuple_offset = 0;
+	flow_cfg->ntuple_max_flows = allocated;
+	flow_cfg->tc_max_flows = allocated;
+
+	if (allocated != count)
+		netdev_info(pfvf->netdev,
+			    "Unable to allocate %d MCAM entries for ntuple, got %d\n",
+			    count, allocated);
+
+	return allocated;
+}
+
 int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
 	struct npc_mcam_alloc_entry_req *req;
 	struct npc_mcam_alloc_entry_rsp *rsp;
 	int vf_vlan_max_flows;
-	int i;
+	int ent, count;
+
+	vf_vlan_max_flows = pfvf->total_vfs * OTX2_PER_VF_VLAN_FLOWS;
+	count = OTX2_MAX_UNICAST_FLOWS +
+			OTX2_MAX_VLAN_FLOWS + vf_vlan_max_flows;
+
+	flow_cfg->def_ent = devm_kmalloc_array(pfvf->dev, count,
+					       sizeof(u16), GFP_KERNEL);
+	if (!flow_cfg->def_ent)
+		return -ENOMEM;
 
 	mutex_lock(&pfvf->mbox.lock);
 
@@ -36,9 +148,8 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	vf_vlan_max_flows = pfvf->total_vfs * OTX2_PER_VF_VLAN_FLOWS;
 	req->contig = false;
-	req->count = OTX2_MCAM_COUNT + vf_vlan_max_flows;
+	req->count = count;
 
 	/* Send message to AF */
 	if (otx2_sync_mbox_msg(&pfvf->mbox)) {
@@ -51,37 +162,36 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 
 	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev,
-			    "Unable to allocate %d MCAM entries, got %d\n",
-			    req->count, rsp->count);
-		/* support only ntuples here */
-		flow_cfg->ntuple_max_flows = rsp->count;
-		flow_cfg->ntuple_offset = 0;
-		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
-		flow_cfg->tc_max_flows = flow_cfg->ntuple_max_flows;
-		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
-	} else {
-		flow_cfg->vf_vlan_offset = 0;
-		flow_cfg->ntuple_offset = flow_cfg->vf_vlan_offset +
-						vf_vlan_max_flows;
-		flow_cfg->tc_flower_offset = flow_cfg->ntuple_offset;
-		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
-						OTX2_MAX_NTUPLE_FLOWS;
-		flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
-						OTX2_MAX_UNICAST_FLOWS;
-		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
-		pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
-		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
-		pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
-		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
-	}
-
-	for (i = 0; i < rsp->count; i++)
-		flow_cfg->entry[i] = rsp->entry_list[i];
+			    "Unable to allocate MCAM entries for ucast, vlan and vf_vlan\n");
+		mutex_unlock(&pfvf->mbox.lock);
+		devm_kfree(pfvf->dev, flow_cfg->def_ent);
+		return 0;
+	}
 
-	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
+	for (ent = 0; ent < rsp->count; ent++)
+		flow_cfg->def_ent[ent] = rsp->entry_list[ent];
 
+	flow_cfg->vf_vlan_offset = 0;
+	flow_cfg->unicast_offset = vf_vlan_max_flows;
+	flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
+					OTX2_MAX_UNICAST_FLOWS;
+	pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
+	pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
+	pfvf->flags |= OTX2_FLAG_VF_VLAN_SUPPORT;
+
+	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 	mutex_unlock(&pfvf->mbox.lock);
 
+	/* Allocate entries for Ntuple filters */
+	count = otx2_alloc_ntuple_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
+	if (count <= 0) {
+		otx2_clear_ntuple_flow_info(pfvf, flow_cfg);
+		return 0;
+	}
+
+	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+	pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
+
 	return 0;
 }
 
@@ -96,13 +206,14 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
 
-	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
-	pf->flow_cfg->tc_max_flows = pf->flow_cfg->ntuple_max_flows;
-
 	err = otx2_alloc_mcam_entries(pf);
 	if (err)
 		return err;
 
+	/* Check if MCAM entries are allocate or not */
+	if (!(pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT))
+		return 0;
+
 	pf->mac_table = devm_kzalloc(pf->dev, sizeof(struct otx2_mac_table)
 					* OTX2_MAX_UNICAST_FLOWS, GFP_KERNEL);
 	if (!pf->mac_table)
@@ -146,7 +257,7 @@ static int otx2_do_add_macfilter(struct otx2_nic *pf, const u8 *mac)
 		ether_addr_copy(pf->mac_table[i].addr, mac);
 		pf->mac_table[i].inuse = true;
 		pf->mac_table[i].mcam_entry =
-			flow_cfg->entry[i + flow_cfg->unicast_offset];
+			flow_cfg->def_ent[i + flow_cfg->unicast_offset];
 		req->entry =  pf->mac_table[i].mcam_entry;
 		break;
 	}
@@ -732,8 +843,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		if (!flow)
 			return -ENOMEM;
 		flow->location = fsp->location;
-		flow->entry = flow_cfg->entry[flow_cfg->ntuple_offset +
-						flow->location];
+		flow->entry = flow_cfg->flow_ent[flow->location];
 		new = true;
 	}
 	/* struct copy */
@@ -837,9 +947,8 @@ int otx2_destroy_ntuple_flows(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	req->start = flow_cfg->entry[flow_cfg->ntuple_offset];
-	req->end   = flow_cfg->entry[flow_cfg->ntuple_offset +
-				      flow_cfg->ntuple_max_flows - 1];
+	req->start = flow_cfg->flow_ent[0];
+	req->end   = flow_cfg->flow_ent[flow_cfg->ntuple_max_flows - 1];
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
 
@@ -906,7 +1015,7 @@ int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	req->entry = flow_cfg->entry[flow_cfg->rx_vlan_offset];
+	req->entry = flow_cfg->def_ent[flow_cfg->rx_vlan_offset];
 	req->intf = NIX_INTF_RX;
 	ether_addr_copy(req->packet.dmac, pfvf->netdev->dev_addr);
 	eth_broadcast_addr((u8 *)&req->mask.dmac);
@@ -935,7 +1044,7 @@ static int otx2_delete_rxvlan_offload_flow(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	req->entry = flow_cfg->entry[flow_cfg->rx_vlan_offset];
+	req->entry = flow_cfg->def_ent[flow_cfg->rx_vlan_offset];
 	/* Send message to AF */
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 82b53e72..65f505b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2109,7 +2109,7 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 		}
 		idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_RX_INDEX);
 		del_req->entry =
-			flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+			flow_cfg->def_ent[flow_cfg->vf_vlan_offset + idx];
 		err = otx2_sync_mbox_msg(&pf->mbox);
 		if (err)
 			goto out;
@@ -2122,7 +2122,7 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 		}
 		idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_TX_INDEX);
 		del_req->entry =
-			flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+			flow_cfg->def_ent[flow_cfg->vf_vlan_offset + idx];
 		err = otx2_sync_mbox_msg(&pf->mbox);
 
 		goto out;
@@ -2136,7 +2136,7 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 	}
 
 	idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_RX_INDEX);
-	req->entry = flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+	req->entry = flow_cfg->def_ent[flow_cfg->vf_vlan_offset + idx];
 	req->packet.vlan_tci = htons(vlan);
 	req->mask.vlan_tci = htons(VLAN_VID_MASK);
 	/* af fills the destination mac addr */
@@ -2187,7 +2187,7 @@ static int otx2_do_set_vf_vlan(struct otx2_nic *pf, int vf, u16 vlan, u8 qos,
 
 	eth_zero_addr((u8 *)&req->mask.dmac);
 	idx = ((vf * OTX2_PER_VF_VLAN_FLOWS) + OTX2_VF_VLAN_TX_INDEX);
-	req->entry = flow_cfg->entry[flow_cfg->vf_vlan_offset + idx];
+	req->entry = flow_cfg->def_ent[flow_cfg->vf_vlan_offset + idx];
 	req->features = BIT_ULL(NPC_DMAC);
 	req->channel = pf->hw.tx_chan_base;
 	req->intf = NIX_INTF_TX;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 51157b2..26712c0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -570,8 +570,8 @@ static int otx2_tc_add_flow(struct otx2_nic *nic,
 	new_node->bitpos = find_first_zero_bit(tc_info->tc_entries_bitmap,
 					       nic->flow_cfg->tc_max_flows);
 	req->channel = nic->hw.rx_chan_base;
-	req->entry = nic->flow_cfg->entry[nic->flow_cfg->tc_flower_offset +
-					  nic->flow_cfg->tc_max_flows - new_node->bitpos];
+	req->entry = nic->flow_cfg->flow_ent[nic->flow_cfg->tc_flower_offset +
+				nic->flow_cfg->tc_max_flows - new_node->bitpos];
 	req->intf = NIX_INTF_RX;
 	req->set_cntr = 1;
 	new_node->entry = req->entry;
-- 
2.7.4

