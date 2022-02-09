Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4854AEADC
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbiBIHPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiBIHPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:15:40 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C2C0612C3;
        Tue,  8 Feb 2022 23:15:43 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2196PfVU019548;
        Tue, 8 Feb 2022 23:15:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2+usUML3asRaxQD1yrVWBptBzb+mqVrfMIXpGWd18ys=;
 b=Lm6/qI8z93hgzcoHjdlmUjDnqdd08AnY7WA0nKJtEItOKjlwMgx3d0QCZbRlXFd371i5
 +cp2KatvxNBECO6dwI7J0oIUq8MB62OtnLBl7ssGE62yNpWP/FlmQilR8+UA9NAYfhty
 Ubkdw3U6a8Lt+4u07auI4sj021GbM51Qe2/XpwLpaC/+40sOOvNghZpENzGcjOGUvF8I
 yrWhWnFj+APtPmUE56p8DO5n+Jxxfuu3ZjxrlVqLu2OwE1JH0dWLN40FxLnVva6gIeea
 rxEKK1KnD+bmZAhlX7BCcTBoswB1m7U4h6kX8r5peUn+l9gV6MgyImHgxMMUfwRSM8AI Vw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e3nuy4wa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 23:15:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Feb
 2022 23:15:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Feb 2022 23:15:37 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 75B253F7053;
        Tue,  8 Feb 2022 23:15:34 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH V2 4/4] octeontx2-pf: PFC config support with DCBx
Date:   Wed, 9 Feb 2022 12:45:19 +0530
Message-ID: <20220209071519.10403-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209071519.10403-1-hkelam@marvell.com>
References: <20220209071519.10403-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -4W2Ds6TxmtKaST5DO_U5A3BmsD9q0td
X-Proofpoint-ORIG-GUID: -4W2Ds6TxmtKaST5DO_U5A3BmsD9q0td
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_03,2022-02-07_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data centric bridging designed to eliminate packet loss due to
queue overflow by adding enhancements to ethernet network such as
proprity flow control etc. This patch adds support for management
of Priority flow control(PFC) on Octeontx2 and CN10K interfaces.

To enable PFC for all priorities
	dcb pfc set dev eth0 prio-pfc all:on/off

To enable PFC on selected priorites
	dcb pfc set dev eth0 prio-pfc 0:on/off 1:on/off ..7:on/off

With the ntuple commands user can map Priority to receive queues.
On queue overflow NIX will assert backpressure such that PFC pause frames
are genarated with mapped priority.

To map priority 7 to Queue 1
ethtool -U eth0 flow-type ether dst xx:xx:xx:xx:xx:xx vlan 0xe00a
m 0x1fff  queue 1

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/Makefile   |   3 +
 .../marvell/octeontx2/nic/otx2_common.c       |  17 +-
 .../marvell/octeontx2/nic/otx2_common.h       |  12 ++
 .../marvell/octeontx2/nic/otx2_dcbnl.c        | 170 ++++++++++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        |  50 +++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  13 ++
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  14 ++
 7 files changed, 271 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 0048b5946712..d463dc72d80a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -11,4 +11,7 @@ rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
                otx2_devlink.o
 rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
+rvu_nicpf-$(CONFIG_DCB) += otx2_dcbnl.o
+rvu_nicvf-$(CONFIG_DCB) += otx2_dcbnl.o
+
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 52615bd9b9bf..358e5b216698 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -939,7 +939,11 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		if (!is_otx2_lbkvf(pfvf->pdev)) {
 			/* Enable receive CQ backpressure */
 			aq->cq.bp_ena = 1;
+#ifdef CONFIG_DCB
+			aq->cq.bpid = pfvf->bpid[pfvf->queue_to_pfc_map[qidx]];
+#else
 			aq->cq.bpid = pfvf->bpid[0];
+#endif
 
 			/* Set backpressure level is same as cq pass level */
 			aq->cq.bp = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
@@ -1219,7 +1223,11 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 		 */
 		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
 			aq->aura.bp_ena = 1;
+#ifdef CONFIG_DCB
+		aq->aura.nix0_bpid = pfvf->bpid[pfvf->queue_to_pfc_map[aura_id]];
+#else
 		aq->aura.nix0_bpid = pfvf->bpid[0];
+#endif
 
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
@@ -1546,11 +1554,18 @@ int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable)
 		return -ENOMEM;
 
 	req->chan_base = 0;
-	req->chan_cnt = 1;
+#ifdef CONFIG_DCB
+	req->chan_cnt = pfvf->pfc_en ? IEEE_8021QAZ_MAX_TCS : 1;
+	req->bpid_per_chan = pfvf->pfc_en ? 1 : 0;
+#else
+	req->chan_cnt =  1;
 	req->bpid_per_chan = 0;
+#endif
+
 
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
+EXPORT_SYMBOL(otx2_nix_config_bp);
 
 /* Mbox message handlers */
 void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 56be20053931..b6be9784ea36 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -399,6 +399,11 @@ struct otx2_nic {
 
 	/* Devlink */
 	struct otx2_devlink	*dl;
+#ifdef CONFIG_DCB
+	/* PFC */
+	u8			pfc_en;
+	u8			*queue_to_pfc_map;
+#endif
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
@@ -879,4 +884,11 @@ int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
 int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos);
 void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf);
 void otx2_dmacflt_update_pfmac_flow(struct otx2_nic *pfvf);
+
+#ifdef CONFIG_DCB
+/* DCB support*/
+void otx2_update_bpid_in_rqctx(struct otx2_nic *pfvf, int vlan_prio, int qidx, bool pfc_enable);
+int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf);
+int otx2_dcbnl_set_ops(struct net_device *dev);
+#endif
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
new file mode 100644
index 000000000000..723d2506d309
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
+ *
+ */
+
+#include "otx2_common.h"
+
+int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
+{
+	struct cgx_pfc_cfg *req;
+	struct cgx_pfc_rsp *rsp;
+	int err = 0;
+
+	if (is_otx2_lbkvf(pfvf->pdev))
+		return 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_prio_flow_ctrl_cfg(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	if (pfvf->pfc_en) {
+		req->rx_pause = true;
+		req->tx_pause = true;
+	} else {
+		req->rx_pause = false;
+		req->tx_pause = false;
+	}
+	req->pfc_en = pfvf->pfc_en;
+
+	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
+		rsp = (struct cgx_pfc_rsp *)
+		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (req->rx_pause != rsp->rx_pause || req->tx_pause != rsp->tx_pause) {
+			dev_warn(pfvf->dev,
+				 "Failed to config PFC\n");
+			err = -EPERM;
+		}
+	}
+unlock:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+void otx2_update_bpid_in_rqctx(struct otx2_nic *pfvf, int vlan_prio, int qidx,
+			       bool pfc_enable)
+{
+	bool if_up = netif_running(pfvf->netdev);
+	struct npa_aq_enq_req *npa_aq;
+	struct nix_aq_enq_req *aq;
+	int err = 0;
+
+	if (pfvf->queue_to_pfc_map[qidx] && pfc_enable) {
+		dev_warn(pfvf->dev,
+			 "PFC enable not permitted as Priority %d already mapped to Queue %d\n",
+			 pfvf->queue_to_pfc_map[qidx], qidx);
+		return;
+	}
+
+	if (if_up) {
+		netif_tx_stop_all_queues(pfvf->netdev);
+		netif_carrier_off(pfvf->netdev);
+	}
+
+	pfvf->queue_to_pfc_map[qidx] = vlan_prio;
+
+	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+	if (!aq) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	aq->cq.bpid = pfvf->bpid[vlan_prio];
+	aq->cq_mask.bpid = GENMASK(8, 0);
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_CQ;
+	aq->op = NIX_AQ_INSTOP_WRITE;
+
+	otx2_sync_mbox_msg(&pfvf->mbox);
+
+	npa_aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!npa_aq) {
+		err = -ENOMEM;
+		goto out;
+	}
+	npa_aq->aura.nix0_bpid = pfvf->bpid[vlan_prio];
+	npa_aq->aura_mask.nix0_bpid = GENMASK(8, 0);
+
+	/* Fill NPA AQ info */
+	npa_aq->aura_id = qidx;
+	npa_aq->ctype = NPA_AQ_CTYPE_AURA;
+	npa_aq->op = NPA_AQ_INSTOP_WRITE;
+	otx2_sync_mbox_msg(&pfvf->mbox);
+
+out:
+	if (if_up) {
+		netif_carrier_on(pfvf->netdev);
+		netif_tx_start_all_queues(pfvf->netdev);
+	}
+
+	if (err)
+		dev_warn(pfvf->dev,
+			 "Updating BPIDs in CQ and Aura contexts of RQ%d failed with err %d\n",
+			 qidx, err);
+}
+
+static int otx2_dcbnl_ieee_getpfc(struct net_device *dev, struct ieee_pfc *pfc)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+
+	pfc->pfc_cap = IEEE_8021QAZ_MAX_TCS;
+	pfc->pfc_en = pfvf->pfc_en;
+
+	return 0;
+}
+
+static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	int err;
+
+	/* Save PFC configuration to interface */
+	pfvf->pfc_en = pfc->pfc_en;
+
+	err = otx2_config_priority_flow_ctrl(pfvf);
+	if (err)
+		return err;
+
+	/* Request Per channel Bpids */
+	if (pfc->pfc_en)
+		otx2_nix_config_bp(pfvf, true);
+
+	return 0;
+}
+
+static u8 otx2_dcbnl_getdcbx(struct net_device __always_unused *dev)
+{
+	return DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
+}
+
+static u8 otx2_dcbnl_setdcbx(struct net_device __always_unused *dev, u8 mode)
+{
+	return (mode != (DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE)) ? 1 : 0;
+}
+
+static const struct dcbnl_rtnl_ops otx2_dcbnl_ops = {
+	.ieee_getpfc	= otx2_dcbnl_ieee_getpfc,
+	.ieee_setpfc	= otx2_dcbnl_ieee_setpfc,
+	.getdcbx	= otx2_dcbnl_getdcbx,
+	.setdcbx	= otx2_dcbnl_setdcbx,
+};
+
+int otx2_dcbnl_set_ops(struct net_device *dev)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+
+	pfvf->queue_to_pfc_map = devm_kzalloc(pfvf->dev, pfvf->hw.rx_queues,
+					      GFP_KERNEL);
+	if (!pfvf->queue_to_pfc_map)
+		return -ENOMEM;
+	dev->dcbnl_ops = &otx2_dcbnl_ops;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb..54f235c216a9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -21,8 +21,10 @@ struct otx2_flow {
 	u16 entry;
 	bool is_vf;
 	u8 rss_ctx_id;
+#define DMAC_FILTER_RULE		BIT(0)
+#define PFC_FLOWCTRL_RULE		BIT(1)
+	u16 rule_type;
 	int vf;
-	bool dmac_filter;
 };
 
 enum dmac_req {
@@ -899,6 +901,9 @@ static int otx2_is_flow_rule_dmacfilter(struct otx2_nic *pfvf,
 static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 {
 	u64 ring_cookie = flow->flow_spec.ring_cookie;
+#ifdef CONFIG_DCB
+	int vlan_prio, qidx, pfc_rule = 0;
+#endif
 	struct npc_install_flow_req *req;
 	int err, vf = 0;
 
@@ -940,6 +945,24 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 			mutex_unlock(&pfvf->mbox.lock);
 			return -EINVAL;
 		}
+
+#ifdef CONFIG_DCB
+		/* Identify PFC rule if PFC enabled and ntuple rule is vlan */
+		if (!vf && (req->features & BIT_ULL(NPC_OUTER_VID)) &&
+		    pfvf->pfc_en && req->op != NIX_RX_ACTIONOP_RSS) {
+			vlan_prio = ntohs(req->packet.vlan_tci) &
+				    ntohs(req->mask.vlan_tci);
+
+			/* Get the priority */
+			vlan_prio >>= 13;
+			flow->rule_type |= PFC_FLOWCTRL_RULE;
+			/* Check if PFC enabled for this priority */
+			if (pfvf->pfc_en & BIT(vlan_prio)) {
+				pfc_rule = true;
+				qidx = req->index;
+			}
+		}
+#endif
 	}
 
 	/* ethtool ring_cookie has (VF + 1) for VF */
@@ -951,6 +974,12 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 
 	/* Send message to AF */
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+
+#ifdef CONFIG_DCB
+	if (!err && pfc_rule)
+		otx2_update_bpid_in_rqctx(pfvf, vlan_prio, qidx, true);
+#endif
+
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
@@ -966,7 +995,7 @@ static int otx2_add_flow_with_pfmac(struct otx2_nic *pfvf,
 		return -ENOMEM;
 
 	pf_mac->entry = 0;
-	pf_mac->dmac_filter = true;
+	pf_mac->rule_type |= DMAC_FILTER_RULE;
 	pf_mac->location = pfvf->flow_cfg->max_flows;
 	memcpy(&pf_mac->flow_spec, &flow->flow_spec,
 	       sizeof(struct ethtool_rx_flow_spec));
@@ -1031,7 +1060,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		eth_hdr = &flow->flow_spec.h_u.ether_spec;
 
 		/* Sync dmac filter table with updated fields */
-		if (flow->dmac_filter)
+		if (flow->rule_type & DMAC_FILTER_RULE)
 			return otx2_dmacflt_update(pfvf, eth_hdr->h_dest,
 						   flow->entry);
 
@@ -1052,7 +1081,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		if (!test_bit(0, &flow_cfg->dmacflt_bmap))
 			otx2_add_flow_with_pfmac(pfvf, flow);
 
-		flow->dmac_filter = true;
+		flow->rule_type |= DMAC_FILTER_RULE;
 		flow->entry = find_first_zero_bit(&flow_cfg->dmacflt_bmap,
 						  flow_cfg->dmacflt_max_flows);
 		fsp->location = flow_cfg->max_flows + flow->entry;
@@ -1120,7 +1149,7 @@ static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 	bool found = false;
 
 	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
-		if (iter->dmac_filter && iter->entry == 0) {
+		if ((iter->rule_type & DMAC_FILTER_RULE) && iter->entry == 0) {
 			eth_hdr = &iter->flow_spec.h_u.ether_spec;
 			if (req == DMAC_ADDR_DEL) {
 				otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
@@ -1156,7 +1185,7 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 	if (!flow)
 		return -ENOENT;
 
-	if (flow->dmac_filter) {
+	if (flow->rule_type & DMAC_FILTER_RULE) {
 		struct ethhdr *eth_hdr = &flow->flow_spec.h_u.ether_spec;
 
 		/* user not allowed to remove dmac filter with interface mac */
@@ -1174,6 +1203,13 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 				  flow_cfg->dmacflt_max_flows) == 1)
 			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
 	} else {
+#ifdef CONFIG_DCB
+		if (flow->rule_type & PFC_FLOWCTRL_RULE)
+			otx2_update_bpid_in_rqctx(pfvf, 0,
+						  flow->flow_spec.ring_cookie,
+						  false);
+#endif
+
 		err = otx2_remove_flow_msg(pfvf, flow->entry, false);
 	}
 
@@ -1383,7 +1419,7 @@ void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf)
 	struct ethhdr *eth_hdr;
 
 	list_for_each_entry(iter, &pf->flow_cfg->flow_list, list) {
-		if (iter->dmac_filter) {
+		if (iter->rule_type & DMAC_FILTER_RULE) {
 			eth_hdr = &iter->flow_spec.h_u.ether_spec;
 			otx2_dmacflt_add(pf, eth_hdr->h_dest,
 					 iter->entry);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 67fbe6ec0030..ede4df51648b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2779,6 +2779,12 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
+#ifdef CONFIG_DCB
+	err = otx2_dcbnl_set_ops(netdev);
+	if (err)
+		goto err_pf_sriov_init;
+#endif
+
 	return 0;
 
 err_pf_sriov_init:
@@ -2930,6 +2936,13 @@ static void otx2_remove(struct pci_dev *pdev)
 		otx2_config_pause_frm(pf);
 	}
 
+#ifdef CONFIG_DCB
+	/* Disable PFC config */
+	if (pf->pfc_en) {
+		pf->pfc_en = 0;
+		otx2_config_priority_flow_ctrl(pf);
+	}
+#endif
 	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index c154b09ec12f..78142498d046 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -702,6 +702,12 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
+#ifdef CONFIG_DCB
+	err = otx2_dcbnl_set_ops(netdev);
+	if (err)
+		goto err_unreg_netdev;
+#endif
+
 	return 0;
 
 err_unreg_netdev:
@@ -744,6 +750,14 @@ static void otx2vf_remove(struct pci_dev *pdev)
 		otx2_config_pause_frm(vf);
 	}
 
+#ifdef CONFIG_DCB
+	/* Disable PFC config */
+	if (vf->pfc_en) {
+		vf->pfc_en = 0;
+		otx2_config_priority_flow_ctrl(vf);
+	}
+#endif
+
 	cancel_work_sync(&vf->reset_task);
 	otx2_unregister_dl(vf);
 	unregister_netdev(netdev);
-- 
2.17.1

