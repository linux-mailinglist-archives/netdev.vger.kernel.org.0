Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819AE56B1B9
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbiGHEoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiGHEny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:43:54 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C468B79683;
        Thu,  7 Jul 2022 21:42:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267GcTX1008611;
        Thu, 7 Jul 2022 21:42:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=TLWPACD6JnypQ9HKMX4FNwaUC/y0RfptYGBOQ58GtOM=;
 b=hN5rJgMhYYbsascCCil7EZLt+30sps/RbfWnASYpehjenSF9PP/SMU+Oqs+uFvJP71r1
 Y8wzb+4RHK/Vhdd2d4SUNfat00sqUla38F9gj4eA3PVpcx/N8jExvwtY5gPTQegSKRsw
 OTEEsfI8C6/A/mejwzPx6DkdHj8xpuDbe86wvTXxyblcrqqZGIzXBcDH8ZN5xAcJhG1y
 dQO+fRM+lZLvouF+SfQpA+ZAupHceqKqQCylPAb+UMw6Ma1FuiHWP9EeJty38w4GBGLe
 imCbCIrOwHCbHTbNSvYKWNl7Vp3mB53SmPgtp7tbRlomrp5Qm+pBaMxA611pUwi8B19u pA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h635w2cy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:42:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 7 Jul
 2022 21:42:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 7 Jul 2022 21:42:38 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 9883F3F7074;
        Thu,  7 Jul 2022 21:42:35 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v5 11/12] octeontx2-pf: Add support for exact match table.
Date:   Fri, 8 Jul 2022 10:11:50 +0530
Message-ID: <20220708044151.2972645-12-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708044151.2972645-1-rkannoth@marvell.com>
References: <20220708044151.2972645-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: IIfMW4MgTyvA3xPqw9lgZVMy0nalk0Xc
X-Proofpoint-ORIG-GUID: IIfMW4MgTyvA3xPqw9lgZVMy0nalk0Xc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NPC exact match table can support more entries than RPM
dmac filters. This requires field size of DMAC filter count
and index to be increased.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.h       | 10 ++---
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     | 44 ++++++++++++++-----
 .../marvell/octeontx2/nic/otx2_flows.c        | 40 ++++++++++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 4 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ce2766317c0b..e795f9ee76dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -314,8 +314,8 @@ struct otx2_flow_config {
 #define OTX2_VF_VLAN_TX_INDEX	1
 	u16			max_flows;
 	u8			dmacflt_max_flows;
-	u8			*bmap_to_dmacindex;
-	unsigned long		dmacflt_bmap;
+	u32			*bmap_to_dmacindex;
+	unsigned long		*dmacflt_bmap;
 	struct list_head	flow_list;
 };
 
@@ -895,9 +895,9 @@ int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic);
 /* CGX/RPM DMAC filters support */
 int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf);
-int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
-int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u8 bit_pos);
-int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos);
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u32 bit_pos);
+int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac, u32 bit_pos);
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos);
 void otx2_dmacflt_reinstall_flows(struct otx2_nic *pf);
 void otx2_dmacflt_update_pfmac_flow(struct otx2_nic *pfvf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 142d87722bed..846a0294a215 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -8,7 +8,7 @@
 #include "otx2_common.h"
 
 static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
-			       u8 *dmac_index)
+			       u32 *dmac_index)
 {
 	struct cgx_mac_addr_add_req *req;
 	struct cgx_mac_addr_add_rsp *rsp;
@@ -35,9 +35,10 @@ static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
 	return err;
 }
 
-static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf)
+static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf, u32 *dmac_index)
 {
 	struct cgx_mac_addr_set_or_get *req;
+	struct cgx_mac_addr_set_or_get *rsp;
 	int err;
 
 	mutex_lock(&pf->mbox.lock);
@@ -48,16 +49,24 @@ static int otx2_dmacflt_add_pfmac(struct otx2_nic *pf)
 		return -ENOMEM;
 	}
 
+	req->index = *dmac_index;
+
 	ether_addr_copy(req->mac_addr, pf->netdev->dev_addr);
 	err = otx2_sync_mbox_msg(&pf->mbox);
 
+	if (!err) {
+		rsp = (struct cgx_mac_addr_set_or_get *)
+			 otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+		*dmac_index = rsp->index;
+	}
+
 	mutex_unlock(&pf->mbox.lock);
 	return err;
 }
 
-int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos)
+int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u32 bit_pos)
 {
-	u8 *dmacindex;
+	u32 *dmacindex;
 
 	/* Store dmacindex returned by CGX/RPM driver which will
 	 * be used for macaddr update/remove
@@ -65,13 +74,13 @@ int otx2_dmacflt_add(struct otx2_nic *pf, const u8 *mac, u8 bit_pos)
 	dmacindex = &pf->flow_cfg->bmap_to_dmacindex[bit_pos];
 
 	if (ether_addr_equal(mac, pf->netdev->dev_addr))
-		return otx2_dmacflt_add_pfmac(pf);
+		return otx2_dmacflt_add_pfmac(pf, dmacindex);
 	else
 		return otx2_dmacflt_do_add(pf, mac, dmacindex);
 }
 
 static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
-				  u8 dmac_index)
+				  u32 dmac_index)
 {
 	struct cgx_mac_addr_del_req *req;
 	int err;
@@ -91,7 +100,7 @@ static int otx2_dmacflt_do_remove(struct otx2_nic *pfvf, const u8 *mac,
 	return err;
 }
 
-static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
+static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf, u32 dmac_index)
 {
 	struct cgx_mac_addr_reset_req *req;
 	int err;
@@ -102,6 +111,7 @@ static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
 		mutex_unlock(&pf->mbox.lock);
 		return -ENOMEM;
 	}
+	req->index = dmac_index;
 
 	err = otx2_sync_mbox_msg(&pf->mbox);
 
@@ -110,12 +120,12 @@ static int otx2_dmacflt_remove_pfmac(struct otx2_nic *pf)
 }
 
 int otx2_dmacflt_remove(struct otx2_nic *pf, const u8 *mac,
-			u8 bit_pos)
+			u32 bit_pos)
 {
-	u8 dmacindex = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+	u32 dmacindex = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
 
 	if (ether_addr_equal(mac, pf->netdev->dev_addr))
-		return otx2_dmacflt_remove_pfmac(pf);
+		return otx2_dmacflt_remove_pfmac(pf, dmacindex);
 	else
 		return otx2_dmacflt_do_remove(pf, mac, dmacindex);
 }
@@ -151,9 +161,10 @@ int otx2_dmacflt_get_max_cnt(struct otx2_nic *pf)
 	return err;
 }
 
-int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos)
+int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos)
 {
 	struct cgx_mac_addr_update_req *req;
+	struct cgx_mac_addr_update_rsp *rsp;
 	int rc;
 
 	mutex_lock(&pf->mbox.lock);
@@ -167,8 +178,19 @@ int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u8 bit_pos)
 
 	ether_addr_copy(req->mac_addr, mac);
 	req->index = pf->flow_cfg->bmap_to_dmacindex[bit_pos];
+
+	/* check the response and change index */
+
 	rc = otx2_sync_mbox_msg(&pf->mbox);
+	if (rc)
+		goto out;
 
+	rsp = (struct cgx_mac_addr_update_rsp *)
+		otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+
+	pf->flow_cfg->bmap_to_dmacindex[bit_pos] = rsp->index;
+
+out:
 	mutex_unlock(&pf->mbox.lock);
 	return rc;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 2dd192b5e4e0..709fc0114fbd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -18,7 +18,7 @@ struct otx2_flow {
 	struct ethtool_rx_flow_spec flow_spec;
 	struct list_head list;
 	u32 location;
-	u16 entry;
+	u32 entry;
 	bool is_vf;
 	u8 rss_ctx_id;
 #define DMAC_FILTER_RULE		BIT(0)
@@ -232,6 +232,9 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 	return 0;
 }
 
+/* TODO : revisit on size */
+#define OTX2_DMAC_FLTR_BITMAP_SZ (4 * 2048 + 32)
+
 int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 {
 	struct otx2_flow_config *flow_cfg;
@@ -242,6 +245,12 @@ int otx2vf_mcam_flow_init(struct otx2_nic *pfvf)
 	if (!pfvf->flow_cfg)
 		return -ENOMEM;
 
+	pfvf->flow_cfg->dmacflt_bmap = devm_kcalloc(pfvf->dev,
+						    BITS_TO_LONGS(OTX2_DMAC_FLTR_BITMAP_SZ),
+						    sizeof(long), GFP_KERNEL);
+	if (!pfvf->flow_cfg->dmacflt_bmap)
+		return -ENOMEM;
+
 	flow_cfg = pfvf->flow_cfg;
 	INIT_LIST_HEAD(&flow_cfg->flow_list);
 	flow_cfg->max_flows = 0;
@@ -259,6 +268,12 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 	if (!pf->flow_cfg)
 		return -ENOMEM;
 
+	pf->flow_cfg->dmacflt_bmap = devm_kcalloc(pf->dev,
+						  BITS_TO_LONGS(OTX2_DMAC_FLTR_BITMAP_SZ),
+						  sizeof(long), GFP_KERNEL);
+	if (!pf->flow_cfg->dmacflt_bmap)
+		return -ENOMEM;
+
 	INIT_LIST_HEAD(&pf->flow_cfg->flow_list);
 
 	/* Allocate bare minimum number of MCAM entries needed for
@@ -284,7 +299,7 @@ int otx2_mcam_flow_init(struct otx2_nic *pf)
 		return 0;
 
 	pf->flow_cfg->bmap_to_dmacindex =
-			devm_kzalloc(pf->dev, sizeof(u8) *
+			devm_kzalloc(pf->dev, sizeof(u32) *
 				     pf->flow_cfg->dmacflt_max_flows,
 				     GFP_KERNEL);
 
@@ -355,7 +370,7 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 
-	if (!bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
+	if (!bitmap_empty(pf->flow_cfg->dmacflt_bmap,
 			  pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(netdev,
 			    "Add %pM to CGX/RPM DMAC filters list as well\n",
@@ -438,7 +453,7 @@ int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 		return 0;
 
 	if (flow_cfg->nr_flows == flow_cfg->max_flows ||
-	    !bitmap_empty(&flow_cfg->dmacflt_bmap,
+	    !bitmap_empty(flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
 		return flow_cfg->max_flows + flow_cfg->dmacflt_max_flows;
 	else
@@ -1010,7 +1025,7 @@ static int otx2_add_flow_with_pfmac(struct otx2_nic *pfvf,
 
 	otx2_add_flow_to_list(pfvf, pf_mac);
 	pfvf->flow_cfg->nr_flows++;
-	set_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
+	set_bit(0, pfvf->flow_cfg->dmacflt_bmap);
 
 	return 0;
 }
@@ -1064,7 +1079,7 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 			return otx2_dmacflt_update(pfvf, eth_hdr->h_dest,
 						   flow->entry);
 
-		if (bitmap_full(&flow_cfg->dmacflt_bmap,
+		if (bitmap_full(flow_cfg->dmacflt_bmap,
 				flow_cfg->dmacflt_max_flows)) {
 			netdev_warn(pfvf->netdev,
 				    "Can't insert the rule %d as max allowed dmac filters are %d\n",
@@ -1078,17 +1093,17 @@ int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
 		}
 
 		/* Install PF mac address to DMAC filter list */
-		if (!test_bit(0, &flow_cfg->dmacflt_bmap))
+		if (!test_bit(0, flow_cfg->dmacflt_bmap))
 			otx2_add_flow_with_pfmac(pfvf, flow);
 
 		flow->rule_type |= DMAC_FILTER_RULE;
-		flow->entry = find_first_zero_bit(&flow_cfg->dmacflt_bmap,
+		flow->entry = find_first_zero_bit(flow_cfg->dmacflt_bmap,
 						  flow_cfg->dmacflt_max_flows);
 		fsp->location = flow_cfg->max_flows + flow->entry;
 		flow->flow_spec.location = fsp->location;
 		flow->location = fsp->location;
 
-		set_bit(flow->entry, &flow_cfg->dmacflt_bmap);
+		set_bit(flow->entry, flow_cfg->dmacflt_bmap);
 		otx2_dmacflt_add(pfvf, eth_hdr->h_dest, flow->entry);
 
 	} else {
@@ -1154,11 +1169,12 @@ static void otx2_update_rem_pfmac(struct otx2_nic *pfvf, int req)
 			if (req == DMAC_ADDR_DEL) {
 				otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
 						    0);
-				clear_bit(0, &pfvf->flow_cfg->dmacflt_bmap);
+				clear_bit(0, pfvf->flow_cfg->dmacflt_bmap);
 				found = true;
 			} else {
 				ether_addr_copy(eth_hdr->h_dest,
 						pfvf->netdev->dev_addr);
+
 				otx2_dmacflt_update(pfvf, eth_hdr->h_dest, 0);
 			}
 			break;
@@ -1194,12 +1210,12 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 
 		err = otx2_dmacflt_remove(pfvf, eth_hdr->h_dest,
 					  flow->entry);
-		clear_bit(flow->entry, &flow_cfg->dmacflt_bmap);
+		clear_bit(flow->entry, flow_cfg->dmacflt_bmap);
 		/* If all dmac filters are removed delete macfilter with
 		 * interface mac address and configure CGX/RPM block in
 		 * promiscuous mode
 		 */
-		if (bitmap_weight(&flow_cfg->dmacflt_bmap,
+		if (bitmap_weight(flow_cfg->dmacflt_bmap,
 				  flow_cfg->dmacflt_max_flows) == 1)
 			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
 	} else {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9106c359e64c..9376d0e62914 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1120,7 +1120,7 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	if (enable && !bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
+	if (enable && !bitmap_empty(pf->flow_cfg->dmacflt_bmap,
 				    pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(pf->netdev,
 			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
-- 
2.25.1

