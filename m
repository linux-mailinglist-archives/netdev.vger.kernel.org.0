Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04D2A7A8B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbgKEJ3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:29:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18106 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731450AbgKEJ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:29:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A59PlOH017315;
        Thu, 5 Nov 2020 01:29:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FuHJQes0D3OK2/+n6ctG8rzHrg/89rRtCuQBpVhioDU=;
 b=foZt4cRCW9bqhrU3Rg4umj97IJfGz715DS3jNmFW6nkQt6cAicZq1pzRgnX2oY00a05d
 xRmMZjuTsN7VEzJv5Cxs3vWlxe5SKRCKCX6SUtNhcx5qdldJOmvkkq+8NYw6ykWmAUK5
 Rl2KTClJdmL17mea0lvowxIMztDt0TwucmECykZn7eKo/zA+WsoY3RxtDJxcVG1LdDLR
 l/GPNjSn1rdFpM5lrrtrUPTA0XOlpfzs4oUY4UXoF58YHzlbYZETUDZH8puTcPqysvFF
 ywQVVdS3V0wdE/vYHbG8cqpttrzWSEbSoCkXCnOHB638WxiP4jeWszv29nhWcnvb6L0F Jg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7ep6mek-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 01:29:04 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Nov
 2020 01:29:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 01:29:03 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 3B5063F703F;
        Thu,  5 Nov 2020 01:28:59 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH v2 net-next 09/13] octeontx2-pf: Implement ingress/egress VLAN offload
Date:   Thu, 5 Nov 2020 14:58:12 +0530
Message-ID: <20201105092816.819-10-naveenm@marvell.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 125 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  25 +++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  16 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  13 +++
 8 files changed, 201 insertions(+), 6 deletions(-)

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
index 4709d8b6197b..97a8f932d1e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1986,7 +1986,8 @@ static int nix_rx_vtag_cfg(struct rvu *rvu, int nixlf, int blkaddr,
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
index f36972d46771..535235bc8649 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -240,6 +240,7 @@ struct otx2_flow_config {
 	u32			nr_flows;
 	u32			ntuple_offset;
 	u32			unicast_offset;
+	u32			rx_vlan_offset;
 	u32                     ntuple_max_flows;
 	struct list_head	flow_list;
 };
@@ -257,6 +258,7 @@ struct otx2_nic {
 #define OTX2_FLAG_MCAM_ENTRIES_ALLOC		BIT_ULL(3)
 #define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
 #define OTX2_FLAG_UCAST_FLTR_SUPPORT		BIT_ULL(5)
+#define OTX2_FLAG_RX_VLAN_SUPPORT		BIT_ULL(6)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
@@ -684,5 +686,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
+int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable);
+int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 8851f8cd3822..826e65954186 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -11,9 +11,11 @@
 /* helper macros to support mcam flows */
 #define OTX2_MAX_NTUPLE_FLOWS	32
 #define OTX2_MAX_UNICAST_FLOWS	8
+#define OTX2_MAX_VLAN_FLOWS	1
 
 #define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
-				 OTX2_MAX_UNICAST_FLOWS)
+				 OTX2_MAX_UNICAST_FLOWS + \
+				 OTX2_MAX_VLAN_FLOWS)
 
 #define OTX2_DEFAULT_ACTION	0x1
 
@@ -37,8 +39,8 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 
 	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
 
-	pf->flags |= OTX2_FLAG_NTUPLE_SUPPORT |
-		     OTX2_FLAG_UCAST_FLTR_SUPPORT;
+	pf->flags |= (OTX2_FLAG_NTUPLE_SUPPORT |
+		      OTX2_FLAG_UCAST_FLTR_SUPPORT | OTX2_FLAG_RX_VLAN_SUPPORT);
 
 	pf->mac_table = devm_kzalloc(pf->dev, sizeof(struct otx2_mac_table)
 					* OTX2_MAX_UNICAST_FLOWS, GFP_KERNEL);
@@ -56,6 +58,8 @@ void otx2_mcam_flow_del(struct otx2_nic *pf)
 int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	netdev_features_t wanted = NETIF_F_HW_VLAN_STAG_RX |
+				   NETIF_F_HW_VLAN_CTAG_RX;
 	struct npc_mcam_alloc_entry_req *req;
 	struct npc_mcam_alloc_entry_rsp *rsp;
 	int i;
@@ -88,15 +92,22 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev, "number of rules truncated to %d\n",
 			    rsp->count);
+		netdev_info(pfvf->netdev,
+			    "Disabling RX VLAN offload due to non-availability of MCAM space\n");
 		/* support only ntuples here */
 		flow_cfg->ntuple_max_flows = rsp->count;
 		flow_cfg->ntuple_offset = 0;
 		pfvf->netdev->priv_flags &= ~IFF_UNICAST_FLT;
 		pfvf->flags &= ~OTX2_FLAG_UCAST_FLTR_SUPPORT;
+		pfvf->flags &= ~OTX2_FLAG_RX_VLAN_SUPPORT;
+		pfvf->netdev->features &= ~wanted;
+		pfvf->netdev->hw_features &= ~wanted;
 	} else {
 		flow_cfg->ntuple_offset = 0;
 		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
 						OTX2_MAX_NTUPLE_FLOWS;
+		flow_cfg->rx_vlan_offset = flow_cfg->unicast_offset +
+						OTX2_MAX_UNICAST_FLOWS;
 	}
 
 	for (i = 0; i < rsp->count; i++)
@@ -732,3 +743,111 @@ int otx2_destroy_mcam_flows(struct otx2_nic *pfvf)
 
 	return 0;
 }
+
+int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
+	struct npc_install_flow_req *req;
+	int err;
+
+	if (!(pfvf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC))
+		return -ENOMEM;
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
+	if (!(pf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC)) {
+		err = otx2_alloc_mcam_entries(pf);
+		if (err)
+			return err;
+	}
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
index 8f9b5f539069..4411270509d0 100644
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
@@ -1757,6 +1760,10 @@ static int otx2_set_features(struct net_device *netdev,
 		return otx2_cgx_config_loopback(pf,
 						features & NETIF_F_LOOPBACK);
 
+	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(netdev))
+		return otx2_enable_rxvlan(pf,
+					  features & NETIF_F_HW_VLAN_CTAG_RX);
+
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pf);
 
@@ -1915,6 +1922,13 @@ static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
 	}
 }
 
+static netdev_features_t
+otx2_features_check(struct sk_buff *skb, struct net_device *dev,
+		    netdev_features_t features)
+{
+	return features;
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
@@ -1926,6 +1940,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_tx_timeout		= otx2_tx_timeout,
 	.ndo_get_stats64	= otx2_get_stats64,
 	.ndo_do_ioctl		= otx2_ioctl,
+	.ndo_features_check     = otx2_features_check,
 };
 
 static int otx2_wq_init(struct otx2_nic *pf)
@@ -2120,8 +2135,18 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			       NETIF_F_GSO_UDP_L4);
 	netdev->features |= netdev->hw_features;
 
+	/* Support TSO on tag interface */
+	netdev->vlan_features |= netdev->features;
+
+	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_STAG_RX;
+	netdev->features |= netdev->hw_features;
+
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_NTUPLE |
 			       NETIF_F_RXALL;
+
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
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
index 67fabf265fe6..946310ea78fc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -416,6 +416,13 @@ static void otx2vf_reset_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static netdev_features_t
+otx2_features_check(struct sk_buff *skb, struct net_device *dev,
+		    netdev_features_t features)
+{
+	return features;
+}
+
 static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_open = otx2vf_open,
 	.ndo_stop = otx2vf_stop,
@@ -424,6 +431,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_change_mtu = otx2vf_change_mtu,
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
+	.ndo_features_check = otx2_features_check,
 };
 
 static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
@@ -558,6 +566,11 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

