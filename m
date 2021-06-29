Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F943B7200
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhF2MX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:23:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47490 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233689AbhF2MXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 08:23:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TCFY4p024380;
        Tue, 29 Jun 2021 05:20:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=nYLj6AjWuEaDFlV9iqQRhokArR5gWtOJX0d2c1D6ua4=;
 b=GC1bQOUJ8b0zyo4gftQaLID7qHNalXdXeZYCnwgk3eSWd5gJcmaeFRF3qvarTIxEUGdX
 VNrGmElSOkNyzfv/RSrc/A9Co39hB5sMCJWDXkMNdDCX00SZZWm86c1rKvIvQpCndNVS
 2VOsd72ebXyZ3pewI33t5s9aiVOAQUbzWy80yOV4BcOJ4dej5ZYT01gxc50b8//KXpPd
 Wx2UGGpPtS1n8PyWOmAF4fVOD7lh6Tv5qGlP2KYUOzPLunh1IKR7++DRkSGj1jRh09J2
 P4LCNKeYC4CZ+84hKscLLLQ7O3DuXQwer1rNIvbYicNkpMRDyATtxZEv2WLfLeM7VoSr 8A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39f964drdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 05:20:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 05:20:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 05:20:49 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 51F5D5B6925;
        Tue, 29 Jun 2021 05:20:46 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next Patch v2 3/3] octeontx2-pf: offload DMAC filters to CGX/RPM block
Date:   Tue, 29 Jun 2021 17:50:33 +0530
Message-ID: <20210629122033.10051-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210629122033.10051-1-hkelam@marvell.com>
References: <20210629122033.10051-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -lrhZO2ofY1hhFAsNIOuExv1jqwxPBIK
X-Proofpoint-GUID: -lrhZO2ofY1hhFAsNIOuExv1jqwxPBIK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMAC filtering can be achieved by either NPC MCAM rules or
CGX/RPM MAC filters. Currently we are achieving this by NPC
MCAM rules. This patch offloads DMAC filters to CGX/RPM MAC
filters instead of NPC MCAM rules. Offloading DMAC filter to
CGX/RPM block helps in reducing traffic to NPC block and
save MCAM rules

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   3 +
 .../marvell/octeontx2/nic/otx2_common.h       |  11 +
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     | 173 +++++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        | 229 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
 6 files changed, 417 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 457c94793e63..3254b02205ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_OCTEONTX2_PF) += rvu_nicpf.o
 obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-		     otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o
+               otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o
 rvu_nicvf-y := otx2_vf.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cf7875d51d87..7cccd802c4ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -210,6 +210,9 @@ int otx2_set_mac_address(struct net_device *netdev, void *p)
 		/* update dmac field in vlan offload rule */
 		if (pfvf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 			otx2_install_rxvlan_offload_flow(pfvf);
+		/* update dmac address in ntuple and DMAC filter list */
+		if (pfvf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
+			otx2_dmacflt_update_pfmac_flow(pfvf);
 	} else {
 		return -EPERM;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 234b330f3183..71448674fb24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -288,6 +288,9 @@ struct otx2_flow_config {
 	u16			tc_flower_offset;
 	u16                     ntuple_max_flows;
 	u16			tc_max_flows;
+	u8			dmacflt_max_flows;
+	u8			*bmap_to_dmacindex;
+	unsigned long		dmacflt_bmap;
 	struct list_head	flow_list;
 };
 
@@ -329,6 +332,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_FLOWER_SUPPORT		BIT_ULL(11)
 #define OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED	BIT_ULL(12)
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
+#define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 	u64			flags;
 
 	struct otx2_qset	qset;
@@ -833,4 +837,11 @@ int otx2_init_tc(struct otx2_nic *nic);
 void otx2_shutdown_tc(struct otx2_nic *nic);
 int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		  void *type_data);
+/* CGX/RPM DMAC filters support */
+int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf);
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
+int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos);
+void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf);
+void otx2_dmacflt_update_pfmac_flow(struct otx2_nic *pfvf);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
new file mode 100644
index 000000000000..ffe3e94562d0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Physcial Function ethernet driver
+ *
+ * Copyright (C) 2021 Marvell.
+ */
+
+#include "otx2_common.h"
+
+static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
+			       u8 *dmac_index)
+{
+	struct cgx_mac_addr_add_req *req;
+	struct cgx_mac_addr_add_rsp *rsp;
+	int err;
+
+	mutex_lock(&pf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_cgx_mac_addr_add(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	ether_addr_copy(req->mac_addr, mac);
+	err = otx2_sync_mbox_msg(&pf->mbox);
+
+	if (!err) {
+		rsp = (struct cgx_mac_addr_add_rsp *)
+			 otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+		*dmac_index = rsp->index;
+	}
+
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf)
+{
+	struct cgx_mac_addr_set_or_get *req;
+	int err;
+
+	mutex_lock(&pf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_cgx_mac_addr_set(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	ether_addr_copy(req->mac_addr, pf->netdev->dev_addr);
+	err = otx2_sync_mbox_msg(&pf->mbox);
+
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos)
+{
+	u8 *dmacindex;
+
+	/* Store dmacindex returned by CGX/RPM driver which will
+	 * be used for macaddr update/remove
+	 */
+	dmacindex = &pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+
+	if (ether_addr_equal(mac, pf->netdev->dev_addr))
+		return otx2_dmacflt_add_pfmac(pf);
+	else
+		return otx2_dmacflt_do_add(pf, mac, dmacindex);
+}
+
+static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
+				  u8 dmac_index)
+{
+	struct cgx_mac_addr_del_req *req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_mac_addr_del(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->index = dmac_index;
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	return err;
+}
+
+static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
+{
+	struct msg_req *req;
+	int err;
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_mac_addr_reset(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac,
+			u8 bit_pos)
+{
+	u8 dmacindex = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+
+	if (ether_addr_equal(mac, pf->netdev->dev_addr))
+		return otx2_dmacflt_remove_pfmac(pf);
+	else
+		return otx2_dmacflt_do_remove(pf, mac, dmacindex);
+}
+
+/* CGX/RPM blocks support max unicast entries of 32.
+ * on typical configuration MAC block associated
+ * with 4 lmacs, each lmac will have 8 dmac entries
+ */
+int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf)
+{
+	struct cgx_max_dmac_entries_get_rsp *rsp;
+	struct msg_req *msg;
+	int err;
+
+	mutex_lock(&pf->mbox.lock);
+	msg = otx2_mbox_alloc_msg_cgx_mac_max_entries_get(&pf->mbox);
+
+	if (!msg) {
+		mutex_unlock(&pf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err)
+		goto out;
+
+	rsp = (struct cgx_max_dmac_entries_get_rsp *)
+		     otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &msg->hdr);
+	pf->flow_cfg->dmacflt_max_flows = rsp->max_dmac_filters;
+
+out:
+	mutex_unlock(&pf->mbox.lock);
+	return err;
+}
+
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos)
+{
+	struct cgx_mac_addr_update_req *req;
+	int rc;
+
+	mutex_lock(&pf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_cgx_mac_addr_update(&pf->mbox);
+
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		rc = -ENOMEM;
+	}
+
+	ether_addr_copy(req->mac_addr, mac);
+	req->index = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+	rc = otx2_sync_mbox_msg(&pf->mbox);
+
+	mutex_unlock(&pf->mbox.lock);
+	return rc;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 8c97106bdd1c..4d9de525802d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -18,6 +18,12 @@ struct otx2_flow {
 	bool is_vf;
 	u8 rss_ctx_id;
 	int vf;
+	bool dmac_filter;
+};
+
+enum dmac_req {
+	DMAC_ADDR_UPDATE,
+	DMAC_ADDR_DEL
 };
 
 static void otx2_clear_ntuple_flow_info(struct otx2_nic *pfvf, struct otx2_flow_config *flow_cfg)
@@ -219,6 +225,22 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	if (!pf->mac_table)
 		return -ENOMEM;
 
+	otx2_dmacflt_get_max_cnt(pf);
+
+	/* DMAC filters are not allocated */
+	if (!pf->flow_cfg->dmacflt_max_flows)
+		return 0;
+
+	pf->flow_cfg->bmap_to_dmacindex =
+			devm_kzalloc(pf->dev, sizeof(u8) *
+				     pf->flow_cfg->dmacflt_max_flows,
+				     GFP_KERNEL);
+
+	if (!pf->flow_cfg->bmap_to_dmacindex)
+		return -ENOMEM;
+
+	pf->flags |= OTX2_FLAG_DMACFLTR_SUPPORT;
+
 	return 0;
 }
 
@@ -280,6 +302,12 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 
+	if (bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+			  pf->flow_cfg->dmacflt_max_flows))
+		netdev_warn(netdev,
+			    "Add %pM to CGX/RPM DMAC filters list as well\n",
+			    mac);
+
 	return otx2_do_add_macfilter(pf, mac);
 }
 
@@ -351,12 +379,22 @@ static void otx2_add_flow_to_list(struct otx2_nic *pfvf, struct otx2_flow *flow)
 	list_add(&flow->list, head);
 }
 
+static int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
+{
+	if (flow_cfg->nr_flows == flow_cfg->ntuple_max_flows ||
+	    bitmap_weight(&flow_cfg->dmacflt_bmap,
+			  flow_cfg->dmacflt_max_flows))
+		return flow_cfg->ntuple_max_flows + flow_cfg->dmacflt_max_flows;
+	else
+		return flow_cfg->ntuple_max_flows;
+}
+
 int otx2_get_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 		  u32 location)
 {
 	struct otx2_flow *iter;
 
-	if (location >= pfvf->flow_cfg->ntuple_max_flows)
+	if (location >= otx2_get_maxflows(pfvf->flow_cfg))
 		return -EINVAL;
 
 	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
@@ -378,7 +416,7 @@ int otx2_get_all_flows(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 	int idx = 0;
 	int err = 0;
 
-	nfc->data = pfvf->flow_cfg->ntuple_max_flows;
+	nfc->data = otx2_get_maxflows(pfvf->flow_cfg);
 	while ((!err || err == -ENOENT) && idx < rule_cnt) {
 		err = otx2_get_flow(pfvf, nfc, location);
 		if (!err)
@@ -760,6 +798,32 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 	return 0;
 }
 
+static int otx2_is_flow_rule_dmacfilter(struct otx2_nic *pfvf,
+					struct ethtool_rx_flow_spec *fsp)
+{
+	struct ethhdr *eth_mask = &fsp->m_u.ether_spec;
+	struct ethhdr *eth_hdr = &fsp->h_u.ether_spec;
+	u64 ring_cookie = fsp->ring_cookie;
+	u32 flow_type;
+
+	if (!(pfvf->flags & OTX2_FLAG_DMACFLTR_SUPPORT))
+		return false;
+
+	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
+
+	/* CGX/RPM block dmac filtering configured for white listing
+	 * check for action other than DROP
+	 */
+	if (flow_type == ETHER_FLOW && ring_cookie != RX_CLS_FLOW_DISC &&
+	    !ethtool_get_flow_spec_ring_vf(ring_cookie)) {
+		if (is_zero_ether_addr(eth_mask->h_dest) &&
+		    is_valid_ether_addr(eth_hdr->h_dest))
+			return true;
+	}
+
+	return false;
+}
+
 static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 {
 	u64 ring_cookie = flow->flow_spec.ring_cookie;
@@ -818,14 +882,46 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 	return err;
 }
 
+static int otx2_add_flow_with_pfmac(struct otx2_nic *pfvf,
+				    struct otx2_flow *flow)
+{
+	struct otx2_flow *pf_mac;
+	struct ethhdr *eth_hdr;
+
+	pf_mac = kzalloc(sizeof(*pf_mac), GFP_KERNEL);
+	if (!pf_mac)
+		return -ENOMEM;
+
+	pf_mac->entry = 0;
+	pf_mac->dmac_filter = true;
+	pf_mac->location = pfvf->flow_cfg->ntuple_max_flows;
+	memcpy(&pf_mac->flow_spec, &flow->flow_spec,
+	       sizeof(struct ethtool_rx_flow_spec));
+	pf_mac->flow_spec.location = pf_mac->location;
+
+	/* Copy PF mac address */
+	eth_hdr = &pf_mac->flow_spec.h_u.ether_spec;
+	ether_addr_copy(eth_hdr->h_dest, pfvf->netdev->dev_addr);
+
+	/* Install DMAC filter with PF mac address */
+	otx2_dmacflt_add(pfvf, eth_hdr->h_dest, 0);
+
+	otx2_add_flow_to_list(pfvf, pf_mac);
+	pfvf->flow_cfg->nr_flows++;
+	set_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
+
+	return 0;
+}
+
 int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
 	struct ethtool_rx_flow_spec *fsp = &nfc->fs;
 	struct otx2_flow *flow;
+	struct ethhdr *eth_hdr;
 	bool new = false;
+	int err = 0;
 	u32 ring;
-	int err;
 
 	ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
 	if (!(pfvf->flags & OTX2_FLAG_NTUPLE_SUPPORT))
@@ -834,16 +930,15 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	if (ring >= pfvf->hw.rx_queues && fsp->ring_cookie != RX_CLS_FLOW_DISC)
 		return -EINVAL;
 
-	if (fsp->location >= flow_cfg->ntuple_max_flows)
+	if (fsp->location >= otx2_get_maxflows(flow_cfg))
 		return -EINVAL;
 
 	flow = otx2_find_flow(pfvf, fsp->location);
 	if (!flow) {
-		flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 		if (!flow)
 			return -ENOMEM;
 		flow->location = fsp->location;
-		flow->entry = flow_cfg->flow_ent[flow->location];
 		new = true;
 	}
 	/* struct copy */
@@ -852,7 +947,54 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 	if (fsp->flow_type & FLOW_RSS)
 		flow->rss_ctx_id = nfc->rss_context;
 
-	err = otx2_add_flow_msg(pfvf, flow);
+	if (otx2_is_flow_rule_dmacfilter(pfvf, &flow->flow_spec)) {
+		eth_hdr = &flow->flow_spec.h_u.ether_spec;
+
+		/* Sync dmac filter table with updated fields */
+		if (flow->dmac_filter)
+			return otx2_dmacflt_update(pfvf, eth_hdr->h_dest,
+						   flow->entry);
+
+		if (bitmap_full(&flow_cfg->dmacflt_bmap,
+				flow_cfg->dmacflt_max_flows)) {
+			netdev_warn(pfvf->netdev,
+				    "Can't insert the rule %d as max allowed dmac filters are %d\n",
+				    flow->location +
+				    flow_cfg->dmacflt_max_flows,
+				    flow_cfg->dmacflt_max_flows);
+			err = -EINVAL;
+			if (new)
+				kfree(flow);
+			return err;
+		}
+
+		/* Install PF mac address to DMAC filter list */
+		if (!test_bit(0, &flow_cfg->dmacflt_bmap))
+			otx2_add_flow_with_pfmac(pfvf, flow);
+
+		flow->dmac_filter = true;
+		flow->entry = find_first_zero_bit(&flow_cfg->dmacflt_bmap,
+						  flow_cfg->dmacflt_max_flows);
+		fsp->location = flow_cfg->ntuple_max_flows + flow->entry;
+		flow->flow_spec.location = fsp->location;
+		flow->location = fsp->location;
+
+		set_bit(flow->entry, &flow_cfg->dmacflt_bmap);
+		otx2_dmacflt_add(pfvf, eth_hdr->h_dest, flow->entry);
+
+	} else {
+		if (flow->location >= pfvf->flow_cfg->ntuple_max_flows) {
+			netdev_warn(pfvf->netdev,
+				    "Can't insert non dmac ntuple rule at %d, allowed range %d-0\n",
+				    flow->location,
+				    flow_cfg->ntuple_max_flows - 1);
+			err = -EINVAL;
+		} else {
+			flow->entry = flow_cfg->flow_ent[flow->location];
+			err = otx2_add_flow_msg(pfvf, flow);
+		}
+	}
+
 	if (err) {
 		if (new)
 			kfree(flow);
@@ -890,20 +1032,70 @@ static int otx2_remove_flow_msg(struct otx2_nic *pfvf, u16 entry, bool all)
 	return err;
 }
 
+static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
+{
+	struct otx2_flow *iter;
+	struct ethhdr *eth_hdr;
+	bool found = false;
+
+	list_for_each_entry(iter, &pfvf->flow_cfg->flow_list, list) {
+		if (iter->dmac_filter && iter->entry == 0) {
+			eth_hdr = &iter->flow_spec.h_u.ether_spec;
+			if (req == DMAC_ADDR_DEL) {
+				otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
+						    0);
+				clear_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
+				found = true;
+			} else {
+				ether_addr_copy(eth_hdr->h_dest,
+						pfvf->netdev->dev_addr);
+				otx2_dmacflt_update(pfvf, eth_hdr->h_dest, 0);
+			}
+			break;
+		}
+	}
+
+	if (found) {
+		list_del(&iter->list);
+		kfree(iter);
+		pfvf->flow_cfg->nr_flows--;
+	}
+}
+
 int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 {
 	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
 	struct otx2_flow *flow;
 	int err;
 
-	if (location >= flow_cfg->ntuple_max_flows)
+	if (location >= otx2_get_maxflows(flow_cfg))
 		return -EINVAL;
 
 	flow = otx2_find_flow(pfvf, location);
 	if (!flow)
 		return -ENOENT;
 
-	err = otx2_remove_flow_msg(pfvf, flow->entry, false);
+	if (flow->dmac_filter) {
+		struct ethhdr *eth_hdr = &flow->flow_spec.h_u.ether_spec;
+
+		/* user not allowed to remove dmac filter with interface mac */
+		if (ether_addr_equal(pfvf->netdev->dev_addr, eth_hdr->h_dest))
+			return -EPERM;
+
+		err = otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
+					  flow->entry);
+		clear_bit(flow->entry, &flow_cfg->dmacflt_bmap);
+		/* If all dmac filters are removed delete macfilter with
+		 * interface mac address and configure CGX/RPM block in
+		 * promiscuous mode
+		 */
+		if (bitmap_weight(&flow_cfg->dmacflt_bmap,
+				  flow_cfg->dmacflt_max_flows) == 1)
+			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
+	} else {
+		err = otx2_remove_flow_msg(pfvf, flow->entry, false);
+	}
+
 	if (err)
 		return err;
 
@@ -1100,3 +1292,22 @@ int otx2_enable_rxvlan(struct otx2_nic *pf, bool enable)
 	mutex_unlock(&pf->mbox.lock);
 	return rsp_hdr->rc;
 }
+
+void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf)
+{
+	struct otx2_flow *iter;
+	struct ethhdr *eth_hdr;
+
+	list_for_each_entry(iter, &pf->flow_cfg->flow_list, list) {
+		if (iter->dmac_filter) {
+			eth_hdr = &iter->flow_spec.h_u.ether_spec;
+			otx2_dmacflt_add(pf, eth_hdr->h_dest,
+					 iter->entry);
+		}
+	}
+}
+
+void otx2_dmacflt_update_pfmac_flow(struct otx2_nic *pfvf)
+{
+	otx2_update_rem_pfmac(pfvf, DMAC_ADDR_UPDATE);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 59912f73417b..fe8789357746 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1110,6 +1110,11 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
+	if (enable && bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+				    pf->flow_cfg->dmacflt_max_flows))
+		netdev_warn(pf->netdev,
+			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
+
 	mutex_lock(&pf->mbox.lock);
 	if (enable)
 		msg = otx2_mbox_alloc_msg_cgx_intlbk_enable(&pf->mbox);
@@ -1644,6 +1649,10 @@ int otx2_open(struct net_device *netdev)
 	/* Restore pause frame settings */
 	otx2_config_pause_frm(pf);
 
+	/* Install DMAC Filters */
+	if (pf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
+		otx2_dmacflt_reinstall_flows(pf);
+
 	err = otx2_rxtx_enable(pf, true);
 	if (err)
 		goto err_tx_stop_queues;
-- 
2.17.1

