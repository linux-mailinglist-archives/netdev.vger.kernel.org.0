Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D092A249F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgKBGNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:13:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgKBGNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:13:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A261YMH017643;
        Sun, 1 Nov 2020 22:13:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=xg4UwfjNHTqiYKFAxy0e7m4Gbar2CmAvS/05hjROe68=;
 b=aTFwsCzfTZPikwX+bcGFNMZlmFSgtW8BqRdGc7nG7avUO71dmxe5JyFAd0yzRfQuSPsd
 J5G4IiJFRED/TNkgIwJU+0SeaOBX75++BOHbjwt69qCA/f8pnjK/rZbSzVmy15ypJcHN
 ltiOu2c4RWQa9t3pRoXd1krOb8o5Dc8SZKKzmLBxeSa6KfjaxZcU3GsWbBUYJner4Urb
 mdpy7aq3fijPnuDsLzZK8njd2lbRsLanPmyQik0S6QoJ4Vnf/SZMQ/60IBoIhdqtyO+o
 +ZeTDveYhM4Clc6CJkqaBS8YZjGxijslDZdAwMa6LjmQBc4N0xudn0FSTXWSgMvjYaRg LQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7enp51x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 22:13:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 22:13:38 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 22:13:38 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 420733F703F;
        Sun,  1 Nov 2020 22:13:32 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH net-next 06/13] octeontx2-pf: Add support for unicast MAC address filtering
Date:   Mon, 2 Nov 2020 11:41:15 +0530
Message-ID: <20201102061122.8915-7-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201102061122.8915-1-naveenm@marvell.com>
References: <20201102061122.8915-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  10 ++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 138 +++++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 3 files changed, 146 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index fb11a3508766..0ad5ec8555b1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -228,10 +228,17 @@ struct otx2_ptp {
 
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
 	u32			ntuple_offset;
+	u32			unicast_offset;
 	u32                     ntuple_max_flows;
 	struct list_head	flow_list;
 };
@@ -248,6 +255,7 @@ struct otx2_nic {
 #define OTX2_FLAG_INTF_DOWN			BIT_ULL(2)
 #define OTX2_FLAG_MCAM_ENTRIES_ALLOC		BIT_ULL(3)
 #define OTX2_FLAG_NTUPLE_SUPPORT		BIT_ULL(4)
+#define OTX2_FLAG_UCAST_FLTR_SUPPORT		BIT_ULL(5)
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 	u64			flags;
@@ -673,5 +681,7 @@ int otx2_add_flow(struct otx2_nic *pfvf,
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location);
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			      struct npc_install_flow_req *req);
+int otx2_del_macfilter(struct net_device *netdev, const u8 *mac);
+int otx2_add_macfilter(struct net_device *netdev, const u8 *mac);
 
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index a66b19c58f51..32346dff0f44 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -10,8 +10,10 @@
 
 /* helper macros to support mcam flows */
 #define OTX2_MAX_NTUPLE_FLOWS	32
+#define OTX2_MAX_UNICAST_FLOWS	8
 
-#define OTX2_MCAM_COUNT		OTX2_MAX_NTUPLE_FLOWS
+#define OTX2_MCAM_COUNT		(OTX2_MAX_NTUPLE_FLOWS + \
+				 OTX2_MAX_UNICAST_FLOWS)
 
 #define OTX2_DEFAULT_ACTION	0x1
 
@@ -35,7 +37,13 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 
 	pf->flow_cfg->ntuple_max_flows = OTX2_MAX_NTUPLE_FLOWS;
 
-	pf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+	pf->flags |= OTX2_FLAG_NTUPLE_SUPPORT |
+		     OTX2_FLAG_UCAST_FLTR_SUPPORT;
+
+	pf->mac_table = devm_kzalloc(pf->dev, sizeof(struct otx2_mac_table)
+					* OTX2_MAX_UNICAST_FLOWS, GFP_KERNEL);
+	if (!pf->mac_table)
+		return -ENOMEM;
 
 	return 0;
 }
@@ -77,13 +85,19 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &req->hdr);
 
-	if (rsp->count != req->count)
+	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev, "number of rules truncated to %d\n",
 			    rsp->count);
-
-	/* support only ntuples here */
-	flow_cfg->ntuple_max_flows = rsp->count;
-	flow_cfg->ntuple_offset = 0;
+		/* support only ntuples here */
+		flow_cfg->ntuple_max_flows = rsp->count;
+		flow_cfg->ntuple_offset = 0;
+		pfvf->netdev->priv_flags &= ~IFF_UNICAST_FLT;
+		pfvf->flags &= ~OTX2_FLAG_UCAST_FLTR_SUPPORT;
+	} else {
+		flow_cfg->ntuple_offset = 0;
+		flow_cfg->unicast_offset = flow_cfg->ntuple_offset +
+						OTX2_MAX_NTUPLE_FLOWS;
+	}
 
 	for (i = 0; i < rsp->count; i++)
 		flow_cfg->entry[i] = rsp->entry_list[i];
@@ -94,6 +108,116 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
 	return 0;
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
+	if (!(pf->flags & OTX2_FLAG_MCAM_ENTRIES_ALLOC)) {
+		err = otx2_alloc_mcam_entries(pf);
+		if (err)
+			return err;
+	}
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
+	u64_to_ether_addr(0xffffffffffffull, req->mask.dmac);
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
+	int err;
+
+	err = otx2_do_add_macfilter(pf, mac);
+	if (err) {
+		netdev->flags |= IFF_PROMISC;
+		return err;
+	}
+	return 0;
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
index f85073528eb9..8f9b5f539069 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1724,6 +1724,10 @@ void otx2_do_set_rx_mode(struct work_struct *work)
 	if (!(netdev->flags & IFF_UP))
 		return;
 
+	/* Write unicast address to mcam entries or del from mcam */
+	if (netdev->priv_flags & IFF_UNICAST_FLT)
+		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
+
 	mutex_lock(&pf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
 	if (!req) {
@@ -2118,6 +2122,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_NTUPLE |
 			       NETIF_F_RXALL;
+	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
-- 
2.16.5

