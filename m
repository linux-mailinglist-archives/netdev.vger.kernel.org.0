Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0343033F146
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhCQNg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231313AbhCQNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:36:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQCHS006922;
        Wed, 17 Mar 2021 06:35:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hpmh2LhDNm+oS1qudApm0GxNrnI+OajCgYSdJjFttUc=;
 b=bkn6e/o2BisWi3W+h5hpeA6NyIW2Pv5i0An8QNIGAyMh8Jnbu0ymEzo+WhrfB7R4SkGt
 M1wZIZkQsXSuDqlf24f1Q1VzQ78P6N34z7TV5SPVrvVxJMT5EW2ycdXwbjS6NpFQAA9I
 7oVpnfwk8q9/C3+CSQYChKJLD1zer1fjmY2gmlPxx6BYf86gMW1575UidN/Q2f49hutL
 orjlTuAPCxkNZ+Me/Aohxnj1UKIsaFDalLsbkZbLlZh+Ai6anyWDVqKFk5BEFRsYiTIv
 sTNYH5ibFiHJdNXsDF3ilcjtDjWHyEDuLHcCWY7aP13qUqST4Y7+UxcoJlmt3rwlFIEA XQ== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:35:58 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:35:57 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:35:56 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 91BAE3F703F;
        Wed, 17 Mar 2021 06:35:53 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 3/5] octeontx2-af: Use npc_install_flow API for promisc and broadcast entries
Date:   Wed, 17 Mar 2021 19:05:36 +0530
Message-ID: <20210317133538.15609-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
References: <20210317133538.15609-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use npc_install_flow mailbox API for installing the default promisc
and broadcast match entries. Earlier these entries were installed
using low level npc_config_mcam_entry API, which does not store these
rules and is not available when the rules are dumped using debugfs.
Added chan_mask field to npc_install_flow_req to calculate channel
mask when channel count is greater than 1 and configure the channel
mask in entry kw_mask.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 107 +++++++++++----------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  10 +-
 3 files changed, 67 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ea456099b33c..1dca2ca115c7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1141,6 +1141,7 @@ struct npc_install_flow_req {
 	u64 features;
 	u16 entry;
 	u16 channel;
+	u16 chan_mask;
 	u8 intf;
 	u8 set_cntr; /* If counter is available set counter for this entry ? */
 	u8 default_rule;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 73b430ce52d0..4c3f6432b671 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -651,10 +651,12 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 				   bool allmulti)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	int blkaddr, ucast_idx, index, kwi;
-	struct mcam_entry entry = { {0} };
-	struct nix_rx_action action = { };
+	int blkaddr, ucast_idx, index;
+	u8 mac_addr[ETH_ALEN] = { 0 };
+	struct nix_rx_action action;
 	u64 relaxed_mask;
 
 	/* Only PF or AF VF can add a promiscuous entry */
@@ -665,34 +667,15 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	if (blkaddr < 0)
 		return;
 
+	*(u64 *)&action = 0x00;
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_PROMISC_ENTRY);
 
-	entry.kw[0] = chan;
-	entry.kw_mask[0] = 0xFFFULL;
-
-	if (chan_cnt > 1) {
-		if (!is_power_of_2(chan_cnt)) {
-			dev_err(rvu->dev, "channel count more than 1, must be power of 2\n");
-			return;
-		}
-		relaxed_mask = GENMASK_ULL(BITS_PER_LONG_LONG - 1,
-					   ilog2(chan_cnt));
-		entry.kw_mask[0] &= relaxed_mask;
-	}
-
-	if (allmulti) {
-		kwi = NPC_KEXOF_DMAC / sizeof(u64);
-		entry.kw[kwi] = BIT_ULL(40); /* LSB bit of 1st byte in DMAC */
-		entry.kw_mask[kwi] = BIT_ULL(40);
-	}
-
-	ucast_idx = npc_get_nixlf_mcam_index(mcam, pcifunc,
-					     nixlf, NIXLF_UCAST_ENTRY);
-
 	/* If the corresponding PF's ucast action is RSS,
 	 * use the same action for promisc also
 	 */
+	ucast_idx = npc_get_nixlf_mcam_index(mcam, pcifunc,
+					     nixlf, NIXLF_UCAST_ENTRY);
 	if (is_mcam_entry_enabled(rvu, mcam, blkaddr, ucast_idx))
 		*(u64 *)&action = npc_get_mcam_action(rvu, mcam,
 							blkaddr, ucast_idx);
@@ -703,9 +686,36 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 		action.pf_func = pcifunc;
 	}
 
-	entry.action = *(u64 *)&action;
-	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      pfvf->nix_rx_intf, &entry, true);
+	if (allmulti) {
+		mac_addr[0] = 0x01;	/* LSB bit of 1st byte in DMAC */
+		ether_addr_copy(req.packet.dmac, mac_addr);
+		ether_addr_copy(req.mask.dmac, mac_addr);
+		req.features = BIT_ULL(NPC_DMAC);
+	}
+
+	req.chan_mask = 0xFFFU;
+	if (chan_cnt > 1) {
+		if (!is_power_of_2(chan_cnt)) {
+			dev_err(rvu->dev,
+				"%s: channel count more than 1, must be power of 2\n", __func__);
+			return;
+		}
+		relaxed_mask = GENMASK_ULL(BITS_PER_LONG_LONG - 1,
+					   ilog2(chan_cnt));
+		req.chan_mask &= relaxed_mask;
+	}
+
+	req.channel = chan;
+	req.intf = pfvf->nix_rx_intf;
+	req.entry = index;
+	req.op = action.op;
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = pcifunc;
+	req.index = action.index;
+	req.match_id = action.match_id;
+	req.flow_key_alg = action.flow_key_alg;
+
+	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
 
 static void npc_enadis_promisc_entry(struct rvu *rvu, u16 pcifunc,
@@ -740,12 +750,14 @@ void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf)
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct mcam_entry entry = { {0} };
 	struct rvu_hwinfo *hw = rvu->hw;
-	struct nix_rx_action action;
-	struct rvu_pfvf *pfvf;
 	int blkaddr, index;
+	u32 req_index = 0;
+	u8 op;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -767,32 +779,29 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_BCAST_ENTRY);
 
-	/* Match ingress channel */
-	entry.kw[0] = chan;
-	entry.kw_mask[0] = 0xfffull;
-
-	/* Match broadcast MAC address.
-	 * DMAC is extracted at 0th bit of PARSE_KEX::KW1
-	 */
-	entry.kw[1] = 0xffffffffffffull;
-	entry.kw_mask[1] = 0xffffffffffffull;
-
-	*(u64 *)&action = 0x00;
 	if (!hw->cap.nix_rx_multicast) {
 		/* Early silicon doesn't support pkt replication,
 		 * so install entry with UCAST action, so that PF
 		 * receives all broadcast packets.
 		 */
-		action.op = NIX_RX_ACTIONOP_UCAST;
-		action.pf_func = pcifunc;
+		op = NIX_RX_ACTIONOP_UCAST;
 	} else {
-		action.index = pfvf->bcast_mce_idx;
-		action.op = NIX_RX_ACTIONOP_MCAST;
+		op = NIX_RX_ACTIONOP_MCAST;
+		req_index = pfvf->bcast_mce_idx;
 	}
 
-	entry.action = *(u64 *)&action;
-	npc_config_mcam_entry(rvu, mcam, blkaddr, index,
-			      pfvf->nix_rx_intf, &entry, true);
+	eth_broadcast_addr((u8 *)&req.packet.dmac);
+	eth_broadcast_addr((u8 *)&req.mask.dmac);
+	req.features = BIT_ULL(NPC_DMAC);
+	req.channel = chan;
+	req.intf = pfvf->nix_rx_intf;
+	req.entry = index;
+	req.op = op;
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = pcifunc;
+	req.index = req_index;
+
+	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
 
 void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 9e710a534796..a31b46d65cc5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -903,9 +903,11 @@ static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 				struct npc_install_flow_req *req, u16 target)
 {
 	struct nix_rx_action action;
+	u64 chan_mask;
 
-	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0,
-			 ~0ULL, 0, NIX_INTF_RX);
+	chan_mask = req->chan_mask ? req->chan_mask : ~0ULL;
+	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0, chan_mask, 0,
+			 NIX_INTF_RX);
 
 	*(u64 *)&action = 0x00;
 	action.pf_func = target;
@@ -1137,6 +1139,10 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	else
 		target = req->hdr.pcifunc;
 
+	/* ignore chan_mask in case pf func is not AF, revisit later */
+	if (!is_pffunc_af(req->hdr.pcifunc))
+		req->chan_mask = 0xFFF;
+
 	if (npc_check_unsupported_flows(rvu, req->features, req->intf))
 		return -EOPNOTSUPP;
 
-- 
2.16.5

