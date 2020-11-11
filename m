Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6412AE98E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgKKHT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:19:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37980 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgKKHOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:14:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB76CJv002830;
        Tue, 10 Nov 2020 23:14:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tgc4kqQ0+uCSl8bslxgbAiKNvm7EJz/CPtZgUkYp1+I=;
 b=VqSObKgMjeD72QSEkHPmp1BJ+b6znMr7NyOlS2ch/b4w2WA8ApVXxEOnK0o5g7mE3FvF
 BGgFTBveWdnmxvcRn+IIVu0cl01NwAuJaves4K5XM0VLEtM2MPoxZCi4FovErIW1VMzr
 +bboTJi+WnRRBGZCGg4QL4JDfo+DCoZ7XpP01ESBwjsRttlfh70xuovPE25y6auuexpV
 r5XECBxcRB4Jo12QmMOwD442RiKsxWlZS9hOhIj3nvc+Rw6ahonxA/gttcQqmGZ11PS/
 0Dj1EPh7RQyRwpWjQTYRl+xPPVR4OrLhThiWWjONQuPNwJTAJvELu/ZzO4IUwfJb94Nx Kg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuysner6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 23:14:36 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 23:14:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 23:14:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Nov 2020 23:14:33 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 058EC3F703F;
        Tue, 10 Nov 2020 23:14:29 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [PATCH v3 net-next 06/13] octeontx2-pf: Add support for unicast MAC address filtering
Date:   Wed, 11 Nov 2020 12:43:57 +0530
Message-ID: <20201111071404.29620-7-naveenm@marvell.com>
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

Add unicast MAC address filtering support using install flow
message. Total of 8 MCAM entries are allocated for adding
unicast mac filtering rules. If the MCAM allocation fails,
the unicast filtering support will not be advertised.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  15 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 120 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  15 ++-
 3 files changed, 143 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 2387c40a2a8f..f959688e14a3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -229,12 +229,21 @@ struct otx2_ptp {
 
 #define OTX2_HW_TIMESTAMP_LEN	8
 
+struct otx2_mac_table {
+	u8 addr[ETH_ALEN];
+	u16 mcam_entry;
+	bool inuse;
+};
+
 struct otx2_flow_config {
 	u16			entry[NPC_MAX_NONCONTIG_ENTRIES];
 	u32			nr_flows;
 #define OTX2_MAX_NTUPLE_FLOWS	32
-#define OTX2_MCAM_COUNT		OTX2_MAX_NTUPLE_FLOWS
+#define OTX2_MAX_UNICAST_FLOWS	8
+#define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
+				 OTX2_MAX_UNICAST_FLOWS)
 	u32			ntuple_offset;
+	u32			unicast_offset;
 	u32                     ntuple_max_flows;
 	struct list_head	flow_list;
 };
@@ -251,6 +260,7 @@ struct otx2_nic {
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
 #define OTX2_FLAG_MCAM_ENTRIES_ALLOC		BIT_ULL(3)
 #define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
+#define OTX2_FLAG_UCAST_FLTR_SUPPORT		BIT_ULL(5)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
@@ -279,6 +289,7 @@ struct otx2_nic {
 	struct refill_work	*refill_wrk;
 	struct workqueue_struct	*otx2_wq;
 	struct work_struct	rx_mode_work;
+	struct otx2_mac_table	*mac_table;
 
 	/* Ethtool stuff */
 	u32			msg_enable;
@@ -674,5 +685,7 @@ int otx2_add_flow(struct otx2_nic *pfvf,
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
+int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
+int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 094f547c9889..7da80aa3f063 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -46,14 +46,21 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &req->hdr);
 
-	if (rsp->count != req->count)
+	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev,
 			    "Unable to allocate %d MCAM entries, got %d\n",
 			    req->count, rsp->count);
-
-	flow_cfg->ntuple_max_flows = rsp->count;
-	flow_cfg->ntuple_offset = 0;
-	pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		/* support only ntuples here */
+		flow_cfg->ntuple_max_flows = rsp->count;
+		flow_cfg->ntuple_offset = 0;
+		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+	} else {
+		flow_cfg->ntuple_offset = 0;
+		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
+						OTX2_MAX_NTUPLE_FLOWS;
+		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_UCAST_FLTR_SUPPORT;
+	}
 
 	for (i = 0; i < rsp->count; i++)
 		flow_cfg->entry[i] = rsp->entry_list[i];
@@ -82,6 +89,11 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	if (err)
 		return err;
 
+	pf->mac_table = devm_kzalloc(pf->dev, sizeof(struct otx2_mac_table)
+					* OTX2_MAX_UNICAST_FLOWS, GFP_KERNEL);
+	if (!pf->mac_table)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -90,6 +102,104 @@ void otx2_mcam_flow_del(struct otx2_nic *pf)
 	otx2_destroy_mcam_flows(pf);
 }
 
+/*  On success adds mcam entry
+ *  On failure enable promisous mode
+ */
+static int otx2_do_add_macfilter(struct otx2_nic *pf, const u8 *mac)
+{
+	struct otx2_flow_config *flow_cfg = pf->flow_cfg;
+	struct npc_install_flow_req *req;
+	int err, i;
+
+	if (!(pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT))
+		return -ENOMEM;
+
+	/* dont have free mcam entries or uc list is greater than alloted */
+	if (netdev_uc_count(pf->netdev) > OTX2_MAX_UNICAST_FLOWS)
+		return -ENOMEM;
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_install_flow(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	/* unicast offset starts with 32 0..31 for ntuple */
+	for (i = 0; i <  OTX2_MAX_UNICAST_FLOWS; i++) {
+		if (pf->mac_table[i].inuse)
+			continue;
+		ether_addr_copy(pf->mac_table[i].addr, mac);
+		pf->mac_table[i].inuse = true;
+		pf->mac_table[i].mcam_entry =
+			flow_cfg->entry[i + flow_cfg->unicast_offset];
+		req->entry =  pf->mac_table[i].mcam_entry;
+		break;
+	}
+
+	ether_addr_copy(req->packet.dmac, mac);
+	eth_broadcast_addr((u8 *)&req->mask.dmac);
+	req->features = BIT_ULL(NPC_DMAC);
+	req->channel = pf->hw.rx_chan_base;
+	req->intf = NIX_INTF_RX;
+	req->op = NIX_RX_ACTION_DEFAULT;
+	req->set_cntr = 1;
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
+
+	return err;
+}
+
+int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+
+	return otx2_do_add_macfilter(pf, mac);
+}
+
+static bool otx2_get_mcamentry_for_mac(struct otx2_nic *pf, const u8 *mac,
+				       int *mcam_entry)
+{
+	int i;
+
+	for (i = 0; i < OTX2_MAX_UNICAST_FLOWS; i++) {
+		if (!pf->mac_table[i].inuse)
+			continue;
+
+		if (ether_addr_equal(pf->mac_table[i].addr, mac)) {
+			*mcam_entry = pf->mac_table[i].mcam_entry;
+			pf->mac_table[i].inuse = false;
+			return true;
+		}
+	}
+	return false;
+}
+
+int otx2_del_macfilter(struct net_device *netdev, const u8 *mac)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct npc_delete_flow_req *req;
+	int err, mcam_entry;
+
+	/* check does mcam entry exists for given mac */
+	if (!otx2_get_mcamentry_for_mac(pf, mac, &mcam_entry))
+		return 0;
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_npc_delete_flow(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+	req->entry = mcam_entry;
+	/* Send message to AF */
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
+
+	return err;
+}
+
 static struct otx2_flow *otx2_find_flow(struct otx2_nic *pfvf, u32 location)
 {
 	struct otx2_flow *iter;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9cf3e19cf1d8..ac90302b1d81 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1720,10 +1720,20 @@ static void otx2_do_set_rx_mode(struct work_struct *work)
 	struct otx2_nic *pf = container_of(work, struct otx2_nic, rx_mode_work);
 	struct net_device *netdev = pf->netdev;
 	struct nix_rx_mode *req;
+	bool promisc = false;
 
 	if (!(netdev->flags & IFF_UP))
 		return;
 
+	if ((netdev->flags & IFF_PROMISC) ||
+	    (netdev_uc_count(netdev) > OTX2_MAX_UNICAST_FLOWS)) {
+		promisc = true;
+	}
+
+	/* Write unicast address to mcam entries or del from mcam */
+	if (!promisc && netdev->priv_flags & IFF_UNICAST_FLT)
+		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
+
 	mutex_lock(&pf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
 	if (!req) {
@@ -1733,7 +1743,7 @@ static void otx2_do_set_rx_mode(struct work_struct *work)
 
 	req->mode = NIX_RX_MODE_UCAST;
 
-	if (netdev->flags & IFF_PROMISC)
+	if (promisc)
 		req->mode |= NIX_RX_MODE_PROMISC;
 	else if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
 		req->mode |= NIX_RX_MODE_ALLMULTI;
@@ -2125,6 +2135,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
 		netdev->hw_features |= NETIF_F_NTUPLE;
 
+	if (pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT)
+		netdev->priv_flags |= IFF_UNICAST_FLT;
+
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
 
-- 
2.16.5

