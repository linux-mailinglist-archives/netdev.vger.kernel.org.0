Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817FA3EE5C9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhHQEp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234103AbhHQEpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17GMKkYD011663;
        Mon, 16 Aug 2021 21:45:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=a86m534FVn5HVlkDRDeCXYu4NpE9X0Wkoxp0O9jCOaA=;
 b=Fcmgj9jFaahBkiVMSEk584iwtg9y4j6cyg/+Kq5QTcVIs4olzCImsHB4xspe8FylfgQ6
 tXrJ60Z8eMeOn2XdgAh186nER9fMecY/fIiV9cinKtzEEZ5M7XBrt4GbnANSRb5iR/BM
 j3u2OZaaR9cSSusn6G/jUpNnHDu8L6/6H4Zkyx++yRS9u28bP9wv93mfsE/udfRZA6/O
 GiprkiDDrcRbisKzvGo9z50e6qxvOEKWM3ovjsxS2CuI+/iCecRWW91QGN3t/IBAWVOk
 oBWaB4kLYWJnrSgIH2wuThk7v0btkPemqKATklIddR3wzE1W+VpQ9EmC2C4si9Y9gdI+ /A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ag0qxgxr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:13 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 27D013F70A8;
        Mon, 16 Aug 2021 21:45:10 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        "Rakesh Babu" <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 05/11] octeontx2-pf: Ntuple filters support for VF netdev
Date:   Tue, 17 Aug 2021 10:14:47 +0530
Message-ID: <1629175493-4895-6-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9PB2X4vlZlRCYTzfAh03E2dMK-Zq_YNw
X-Proofpoint-GUID: 9PB2X4vlZlRCYTzfAh03E2dMK-Zq_YNw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

Add packet flow classification support for both LMAC mapped virtual
functions and loopback VFs. This patch adds supports for ntuple
offload feature.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 20 ++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  7 +++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 52 +++++-----------------
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 51 ++++++++++++++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 28 ++++++++++++
 5 files changed, 98 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 5e77bfe..9bde1bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -995,13 +995,11 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct rvu_npc_mcam_rule dummy = { 0 };
 	struct rvu_npc_mcam_rule *rule;
-	bool new = false, msg_from_vf;
 	u16 owner = req->hdr.pcifunc;
 	struct msg_rsp write_rsp;
 	struct mcam_entry *entry;
 	int entry_index, err;
-
-	msg_from_vf = !!(owner & RVU_PFVF_FUNC_MASK);
+	bool new = false;
 
 	installed_features = req->features;
 	features = req->features;
@@ -1027,7 +1025,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	}
 
 	/* update mcam entry with default unicast rule attributes */
-	if (def_ucast_rule && (msg_from_vf || (req->default_rule && req->append))) {
+	if (def_ucast_rule && (req->default_rule && req->append)) {
 		missing_features = (def_ucast_rule->features ^ features) &
 					def_ucast_rule->features;
 		if (missing_features)
@@ -1130,6 +1128,7 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 				      struct npc_install_flow_rsp *rsp)
 {
 	bool from_vf = !!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK);
+	struct rvu_switch *rswitch = &rvu->rswitch;
 	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
 	bool pf_set_vfs_mac = false;
@@ -1221,15 +1220,12 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 		return 0;
 	}
 
-	/* If message is from VF then its flow should not overlap with
-	 * reserved unicast flow.
-	 */
-	if (from_vf && pfvf->def_ucast_rule && is_npc_intf_rx(req->intf) &&
-	    pfvf->def_ucast_rule->features & req->features)
-		return NPC_FLOW_VF_OVERLAP;
+	mutex_lock(&rswitch->switch_lock);
+	err = npc_install_flow(rvu, blkaddr, target, nixlf, pfvf,
+			       req, rsp, enable, pf_set_vfs_mac);
+	mutex_unlock(&rswitch->switch_lock);
 
-	return npc_install_flow(rvu, blkaddr, target, nixlf, pfvf, req, rsp,
-				enable, pf_set_vfs_mac);
+	return err;
 }
 
 static int npc_delete_flow(struct rvu *rvu, struct rvu_npc_mcam_rule *rule,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 2a80cdc..4f95a69 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -710,6 +710,11 @@ MBOX_UP_CGX_MESSAGES
 #define	RVU_PFVF_FUNC_SHIFT	0
 #define	RVU_PFVF_FUNC_MASK	0x3FF
 
+static inline bool is_otx2_vf(u16 pcifunc)
+{
+	return !!(pcifunc & RVU_PFVF_FUNC_MASK);
+}
+
 static inline int rvu_get_pf(u16 pcifunc)
 {
 	return (pcifunc >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
@@ -815,6 +820,7 @@ int otx2_set_real_num_queues(struct net_device *netdev,
 			     int tx_queues, int rx_queues);
 /* MCAM filter related APIs */
 int otx2_mcam_flow_init(struct otx2_nic *pf);
+int otx2vf_mcam_flow_init(struct otx2_nic *pfvf);
 int otx2_alloc_mcam_entries(struct otx2_nic *pfvf);
 void otx2_mcam_flow_del(struct otx2_nic *pf);
 int otx2_destroy_ntuple_flows(struct otx2_nic *pf);
@@ -828,6 +834,7 @@ int otx2_add_flow(struct otx2_nic *pfvf,
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
+int otx2_get_maxflows(struct otx2_flow_config *flow_cfg);
 void otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id);
 int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
 int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b906a0e..620da08 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -645,6 +645,7 @@ static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
 static int otx2_get_rxnfc(struct net_device *dev,
 			  struct ethtool_rxnfc *nfc, u32 *rules)
 {
+	bool ntuple = !!(dev->features & NETIF_F_NTUPLE);
 	struct otx2_nic *pfvf = netdev_priv(dev);
 	int ret = -EOPNOTSUPP;
 
@@ -654,14 +655,18 @@ static int otx2_get_rxnfc(struct net_device *dev,
 		ret = 0;
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
-		nfc->rule_cnt = pfvf->flow_cfg->nr_flows;
-		ret = 0;
+		if (netif_running(dev) && ntuple) {
+			nfc->rule_cnt = pfvf->flow_cfg->nr_flows;
+			ret = 0;
+		}
 		break;
 	case ETHTOOL_GRXCLSRULE:
-		ret = otx2_get_flow(pfvf, nfc,  nfc->fs.location);
+		if (netif_running(dev) && ntuple)
+			ret = otx2_get_flow(pfvf, nfc,  nfc->fs.location);
 		break;
 	case ETHTOOL_GRXCLSRLALL:
-		ret = otx2_get_all_flows(pfvf, nfc, rules);
+		if (netif_running(dev) && ntuple)
+			ret = otx2_get_all_flows(pfvf, nfc, rules);
 		break;
 	case ETHTOOL_GRXFH:
 		return otx2_get_rss_hash_opts(pfvf, nfc);
@@ -696,41 +701,6 @@ static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
 	return ret;
 }
 
-static int otx2vf_get_rxnfc(struct net_device *dev,
-			    struct ethtool_rxnfc *nfc, u32 *rules)
-{
-	struct otx2_nic *pfvf = netdev_priv(dev);
-	int ret = -EOPNOTSUPP;
-
-	switch (nfc->cmd) {
-	case ETHTOOL_GRXRINGS:
-		nfc->data = pfvf->hw.rx_queues;
-		ret = 0;
-		break;
-	case ETHTOOL_GRXFH:
-		return otx2_get_rss_hash_opts(pfvf, nfc);
-	default:
-		break;
-	}
-	return ret;
-}
-
-static int otx2vf_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
-{
-	struct otx2_nic *pfvf = netdev_priv(dev);
-	int ret = -EOPNOTSUPP;
-
-	switch (nfc->cmd) {
-	case ETHTOOL_SRXFH:
-		ret = otx2_set_rss_hash_opts(pfvf, nfc);
-		break;
-	default:
-		break;
-	}
-
-	return ret;
-}
-
 static u32 otx2_get_rxfh_key_size(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -1357,8 +1327,8 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.get_sset_count		= otx2vf_get_sset_count,
 	.set_channels		= otx2_set_channels,
 	.get_channels		= otx2_get_channels,
-	.get_rxnfc		= otx2vf_get_rxnfc,
-	.set_rxnfc              = otx2vf_set_rxnfc,
+	.get_rxnfc		= otx2_get_rxnfc,
+	.set_rxnfc              = otx2_set_rxnfc,
 	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
 	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
 	.get_rxfh		= otx2_get_rxfh,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 4d9de52..a0c4b73 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -92,8 +92,14 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 		req->contig = false;
 		req->count = (count - allocated) > NPC_MAX_NONCONTIG_ENTRIES ?
 				NPC_MAX_NONCONTIG_ENTRIES : count - allocated;
-		req->priority = NPC_MCAM_HIGHER_PRIO;
-		req->ref_entry = flow_cfg->def_ent[0];
+
+		/* Allocate higher priority entries for PFs, so that VF's entries
+		 * will be on top of PF.
+		 */
+		if (!is_otx2_vf(pfvf->pcifunc)) {
+			req->priority = NPC_MCAM_HIGHER_PRIO;
+			req->ref_entry = flow_cfg->def_ent[0];
+		}
 
 		/* Send message to AF */
 		if (otx2_sync_mbox_msg(&pfvf->mbox))
@@ -121,11 +127,13 @@ static int otx2_alloc_ntuple_mcam_entries(struct otx2_nic *pfvf, u16 count)
 	flow_cfg->ntuple_max_flows = allocated;
 	flow_cfg->tc_max_flows = allocated;
 
+	pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
+	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+
 	if (allocated != count)
 		netdev_info(pfvf->netdev,
-			    "Unable to allocate %d MCAM entries for ntuple, got %d\n",
+			    "Unable to allocate %d MCAM entries, got only %d\n",
 			    count, allocated);
-
 	return allocated;
 }
 
@@ -195,12 +203,34 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 		return 0;
 	}
 
-	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
 	pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 
 	return 0;
 }
 
+int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
+{
+	struct otx2_flow_config *flow_cfg;
+	int count;
+
+	pfvf->flow_cfg = devm_kzalloc(pfvf->dev,
+				      sizeof(struct otx2_flow_config),
+				      GFP_KERNEL);
+	if (!pfvf->flow_cfg)
+		return -ENOMEM;
+
+	flow_cfg = pfvf->flow_cfg;
+	INIT_LIST_HEAD(&flow_cfg->flow_list);
+	flow_cfg->ntuple_max_flows = 0;
+
+	count = otx2_alloc_ntuple_mcam_entries(pfvf, OTX2_DEFAULT_FLOWCOUNT);
+	if (count <= 0)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL(otx2vf_mcam_flow_init);
+
 int otx2_mcam_flow_init(struct otx2_nic *pf)
 {
 	int err;
@@ -248,6 +278,7 @@ void otx2_mcam_flow_del(struct otx2_nic *pf)
 {
 	otx2_destroy_mcam_flows(pf);
 }
+EXPORT_SYMBOL(otx2_mcam_flow_del);
 
 /*  On success adds mcam entry
  *  On failure enable promisous mode
@@ -379,8 +410,11 @@ static void otx2_add_flow_to_list(struct otx2_nic *pfvf, struct otx2_flow *flow)
 	list_add(&flow->list, head);
 }
 
-static int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
+int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 {
+	if (!flow_cfg)
+		return 0;
+
 	if (flow_cfg->nr_flows == flow_cfg->ntuple_max_flows ||
 	    bitmap_weight(&flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
@@ -388,6 +422,7 @@ static int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 	else
 		return flow_cfg->ntuple_max_flows;
 }
+EXPORT_SYMBOL(otx2_get_maxflows);
 
 int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 		  u32 location)
@@ -732,7 +767,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			ether_addr_copy(pmask->dmac, eth_mask->h_dest);
 			req->features |= BIT_ULL(NPC_DMAC);
 		}
-		if (eth_mask->h_proto) {
+		if (eth_hdr->h_proto) {
 			memcpy(&pkt->etype, &eth_hdr->h_proto,
 			       sizeof(pkt->etype));
 			memcpy(&pmask->etype, &eth_mask->h_proto,
@@ -996,6 +1031,8 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	}
 
 	if (err) {
+		if (err == MBOX_MSG_INVALID)
+			err = -EINVAL;
 		if (new)
 			kfree(flow);
 		return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 722c601..83a76d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -464,6 +464,28 @@ static void otx2vf_reset_task(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static int otx2vf_set_features(struct net_device *netdev,
+			       netdev_features_t features)
+{
+	netdev_features_t changed = features ^ netdev->features;
+	bool ntuple_enabled = !!(features & NETIF_F_NTUPLE);
+	struct otx2_nic *vf = netdev_priv(netdev);
+
+	if (changed & NETIF_F_NTUPLE) {
+		if (!ntuple_enabled) {
+			otx2_mcam_flow_del(vf);
+			return 0;
+		}
+
+		if (!otx2_get_maxflows(vf->flow_cfg)) {
+			netdev_err(netdev,
+				   "Can't enable NTUPLE, MCAM entries not allocated\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_open = otx2vf_open,
 	.ndo_stop = otx2vf_stop,
@@ -471,6 +493,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_set_rx_mode = otx2vf_set_rx_mode,
 	.ndo_set_mac_address = otx2_set_mac_address,
 	.ndo_change_mtu = otx2vf_change_mtu,
+	.ndo_set_features = otx2vf_set_features,
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
 };
@@ -627,6 +650,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				NETIF_F_HW_VLAN_STAG_TX;
 	netdev->features |= netdev->hw_features;
 
+	netdev->hw_features |= NETIF_F_NTUPLE;
 	netdev->hw_features |= NETIF_F_RXALL;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
@@ -659,6 +683,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	otx2vf_set_ethtool_ops(netdev);
 
+	err = otx2vf_mcam_flow_init(vf);
+	if (err)
+		goto err_unreg_netdev;
+
 	/* Enable pause frames by default */
 	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
 	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-- 
2.7.4

