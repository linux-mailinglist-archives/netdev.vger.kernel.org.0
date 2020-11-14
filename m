Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF802B305D
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKNTxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4030 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgKNTxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJoKVF028820;
        Sat, 14 Nov 2020 11:53:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Gb113dQ1gm9iY3VwMuk2TjtbRmirkUI5B8/wqmEKRUY=;
 b=Y8GzKMZTECFsLZLgXOI/j8pPYHdUnjA1gIQjDMX4qQt6DhcHNuwAC0NVD1XeQTwSiMB2
 YaEGQiF4ewYt2qtaOVF2BhV/v2Ok1+zVxOAf8bSP+qIpUKjg7YZk4+Ok9//8pZhSbPk2
 xij3Ads4OUGamnQbLPAySxkDFWyxdSPo2wmKsrHh/rXY+A9dDDpyksMXHmvPBfBLRCCw
 u615VROcha/C2u2bKDpJyS2c8Zhis8Rr0/wggCChYZ4CbxT/SH1B5E8NJOmztsnG5fJP
 Gz78KZaQSqEppcRDzQCJQqAi/WcINHhyqG2SB5+sX8117JOEfNat5ADahTkMPHbE0MGu mQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts05g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:45 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 359C03F7040;
        Sat, 14 Nov 2020 11:53:41 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 09/13] octeontx2-pf: Implement ingress/egress VLAN offload
Date:   Sun, 15 Nov 2020 01:22:59 +0530
Message-ID: <20201114195303.25967-10-naveenm@marvell.com>
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

This patch implements egress VLAN offload by appending NIX_SEND_EXT_S
header to NIX_SEND_HDR_S. The VLAN TCI information is specified
in the NIX_SEND_EXT_S. The VLAN offload in the ingress path is
implemented by configuring the NIX_RX_VTAG_ACTION_S to strip and
capture the outer vlan fields. The NIX PF allocates one MCAM entry
for Rx VLAN offload.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  13 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 102 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  16 ++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  16 ++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   5 +
 8 files changed, 167 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4f230a7272ce..ef20078508a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -479,6 +479,19 @@ enum nix_af_status {
 	NIX_AF_INVAL_NPA_PF_FUNC    = -419,
 	NIX_AF_INVAL_SSO_PF_FUNC    = -420,
 	NIX_AF_ERR_TX_VTAG_NOSPC    = -421,
+	NIX_AF_ERR_RX_VTAG_INUSE    = -422,
+};
+
+/* For NIX RX vtag action  */
+enum nix_rx_vtag0_type {
+	NIX_AF_LFX_RX_VTAG_TYPE0, /* reserved for rx vlan offload */
+	NIX_AF_LFX_RX_VTAG_TYPE1,
+	NIX_AF_LFX_RX_VTAG_TYPE2,
+	NIX_AF_LFX_RX_VTAG_TYPE3,
+	NIX_AF_LFX_RX_VTAG_TYPE4,
+	NIX_AF_LFX_RX_VTAG_TYPE5,
+	NIX_AF_LFX_RX_VTAG_TYPE6,
+	NIX_AF_LFX_RX_VTAG_TYPE7,
 };
 
 /* For NIX LF context alloc and init */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index bf844df30464..6665df0ac359 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1984,7 +1984,8 @@ static int nix_rx_vtag_cfg(struct rvu *rvu, int nixlf, int blkaddr,
 {
 	u64 regval = req->vtag_size;
 
-	if (req->rx.vtag_type > 7 || req->vtag_size > VTAGSIZE_T8)
+	if (req->rx.vtag_type > NIX_AF_LFX_RX_VTAG_TYPE7 ||
+	    req->vtag_size > VTAGSIZE_T8)
 		return -EINVAL;
 
 	if (req->rx.capture_vtag)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9f3d6715748e..68fb4e4757aa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -191,10 +191,14 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data))
+	if (!otx2_hw_set_mac_addr(pfvf, addr->sa_data)) {
 		memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
-	else
+		/* update dmac field in vlan offload rule */
+		if (pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+			otx2_install_rxvlan_offload_flow(pfvf);
+	} else {
 		return -EPERM;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index f959688e14a3..7819f278b99c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -240,10 +240,13 @@ struct otx2_flow_config {
 	u32			nr_flows;
 #define OTX2_MAX_NTUPLE_FLOWS	32
 #define OTX2_MAX_UNICAST_FLOWS	8
+#define OTX2_MAX_VLAN_FLOWS	1
 #define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
-				 OTX2_MAX_UNICAST_FLOWS)
+				 OTX2_MAX_UNICAST_FLOWS + \
+				 OTX2_MAX_VLAN_FLOWS)
 	u32			ntuple_offset;
 	u32			unicast_offset;
+	u32			rx_vlan_offset;
 	u32                     ntuple_max_flows;
 	struct list_head	flow_list;
 };
@@ -261,6 +264,7 @@ struct otx2_nic {
 #define OTX2_FLAG_MCAM_ENTRIES_ALLOC		BIT_ULL(3)
 #define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
 #define OTX2_FLAG_UCAST_FLTR_SUPPORT		BIT_ULL(5)
+#define OTX2_FLAG_RX_VLAN_SUPPORT		BIT_ULL(6)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
@@ -687,5 +691,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
+int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
+int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index f297edb2717e..ba49c5108edc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -58,8 +58,11 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		flow_cfg->ntuple_offset = 0;
 		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
 						OTX2_MAX_NTUPLE_FLOWS;
+		flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
+						OTX2_MAX_UNICAST_FLOWS;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
 		pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
 	}
 
 	for (i = 0; i < rsp->count; i++)
@@ -711,3 +714,102 @@ int otx2_destroy_mcam_flows(struct otx2_nic *pfvf)
 
 	return 0;
 }
+
+int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_install_flow_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->entry = flow_cfg->entry[flow_cfg->rx_vlan_offset];
+	req->intf = NIX_INTF_RX;
+	ether_addr_copy(req->packet.dmac, pfvf->netdev->dev_addr);
+	eth_broadcast_addr((u8 *)&req->mask.dmac);
+	req->channel = pfvf->hw.rx_chan_base;
+	req->op = NIX_RX_ACTION_DEFAULT;
+	req->features = BIT_ULL(NPC_OUTER_VID) | BIT_ULL(NPC_DMAC);
+	req->vtag0_valid = true;
+	req->vtag0_type = NIX_AF_LFX_RX_VTAG_TYPE0;
+
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+static int otx2_delete_rxvlan_offload_flow(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_delete_flow_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->entry = flow_cfg->entry[flow_cfg->rx_vlan_offset];
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable)
+{
+	struct nix_vtag_config *req;
+	struct mbox_msghdr *rsp_hdr;
+	int err;
+
+	/* Dont have enough mcam entries */
+	if (!(pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT))
+		return -ENOMEM;
+
+	if (enable) {
+		err = otx2_install_rxvlan_offload_flow(pf);
+		if (err)
+			return err;
+	} else {
+		err = otx2_delete_rxvlan_offload_flow(pf);
+		if (err)
+			return err;
+	}
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_vtag_cfg(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	/* config strip, capture and size */
+	req->vtag_size = VTAGSIZE_T4;
+	req->cfg_type = 1; /* rx vlan cfg */
+	req->rx.vtag_type = NIX_AF_LFX_RX_VTAG_TYPE0;
+	req->rx.strip_vtag = enable;
+	req->rx.capture_vtag = enable;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err) {
+		mutex_unlock(&pf->mbox.lock);
+		return err;
+	}
+
+	rsp_hdr = otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp_hdr)) {
+		mutex_unlock(&pf->mbox.lock);
+		return PTR_ERR(rsp_hdr);
+	}
+
+	mutex_unlock(&pf->mbox.lock);
+	return rsp_hdr->rc;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ac90302b1d81..22513e58f7bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1566,6 +1566,9 @@ int otx2_open(struct net_device *netdev)
 
 	otx2_set_cints_affinity(pf);
 
+	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+		otx2_enable_rxvlan(pf, true);
+
 	/* When reinitializing enable time stamping if it is enabled before */
 	if (pf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED) {
 		pf->flags &= ~OTX2_FLAG_TX_TSTAMP_ENABLED;
@@ -1763,6 +1766,10 @@ static int otx2_set_features(struct net_device *netdev,
 		return otx2_cgx_config_loopback(pf,
 						features & NETIF_F_LOOPBACK);
 
+	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(netdev))
+		return otx2_enable_rxvlan(pf,
+					  features & NETIF_F_HW_VLAN_CTAG_RX);
+
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
@@ -2138,6 +2145,15 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
+	/* Support TSO on tag interface */
+	netdev->vlan_features |= netdev->features;
+	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX;
+	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
+		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
+				       NETIF_F_HW_VLAN_STAG_RX;
+	netdev->features |= netdev->hw_features;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index d5d7a2f37493..d0e25414f1a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -556,6 +556,19 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 		ext->tstmp = 1;
 	}
 
+#define OTX2_VLAN_PTR_OFFSET     (ETH_HLEN - ETH_TLEN)
+	if (skb_vlan_tag_present(skb)) {
+		if (skb->vlan_proto == htons(ETH_P_8021Q)) {
+			ext->vlan1_ins_ena = 1;
+			ext->vlan1_ins_ptr = OTX2_VLAN_PTR_OFFSET;
+			ext->vlan1_ins_tci = skb_vlan_tag_get(skb);
+		} else if (skb->vlan_proto == htons(ETH_P_8021AD)) {
+			ext->vlan0_ins_ena = 1;
+			ext->vlan0_ins_ptr = OTX2_VLAN_PTR_OFFSET;
+			ext->vlan0_ins_tci = skb_vlan_tag_get(skb);
+		}
+	}
+
 	*offset += sizeof(*ext);
 }
 
@@ -871,6 +884,9 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 	}
 
 	if (skb_shinfo(skb)->gso_size && !is_hw_tso_supported(pfvf, skb)) {
+		/* Insert vlan tag before giving pkt to tso */
+		if (skb_vlan_tag_present(skb))
+			skb = __vlan_hwaccel_push_inside(skb);
 		otx2_sq_append_tso(pfvf, sq, skb, qidx);
 		return true;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 67fabf265fe6..d3e4cfd244e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -558,6 +558,11 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
 			      NETIF_F_GSO_UDP_L4;
 	netdev->features = netdev->hw_features;
+	/* Support TSO on tag interface */
+	netdev->vlan_features |= netdev->features;
+	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX;
+	netdev->features |= netdev->hw_features;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
-- 
2.16.5

