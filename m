Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A34585303
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbiG2PoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbiG2PoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:44:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4044D87343
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:44:11 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T66c1a018181;
        Fri, 29 Jul 2022 08:44:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UEb7NZQ75Gd8d9+wv9CtI8rTAby/fi93p+rstQzbsjo=;
 b=RyJ/oOHDLyfn01FcYs8r84D0bMphBv+OJPsbOqahr0oFy6vwyvlPy922qEmvVk9fQHHB
 giNY7dCYQtv6GxDkdXZoGI4RwabeviyN8chofY1DW6sZRgPrIFG9af2ES3jxY8WfPT6s
 SHRjK/+F/zrb986INe7KJzoWO9nam/0sltDWBq95Cip+XL5SiqMady3LGy7rRMKHBVRt
 LfS3b+sVWHnXgoqnH7QGCZwB8/tdEXHhwAkPXJeJaBK/OPXiszff9gq6brY0YjnKyCdh
 uvmlOxuLCCdajJypdfCo3MU7VIpThmaETLFGi7ZnDAImVZrZWwvhaCRfNvk6YlFSoWky ng== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hkyq13t6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:44:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Jul
 2022 08:44:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 Jul 2022 08:44:03 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 7F42D3F708E;
        Fri, 29 Jul 2022 08:44:01 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net v3 PATCH 3/5] octeontx2-af: Allow mkex profiles without dmac.
Date:   Fri, 29 Jul 2022 21:13:48 +0530
Message-ID: <1659109430-31748-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
References: <1659109430-31748-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: a3DLMJQho8XX-0cTNlp0QEooKacHz8Qe
X-Proofpoint-ORIG-GUID: a3DLMJQho8XX-0cTNlp0QEooKacHz8Qe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_17,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Ghosh <sumang@marvell.com>

It is possible to have custom mkex profiles which do not extract
DMAC into the key to free up space in the key and use it for L3
or L4 packet fields. Current code bails out if DMAC extraction is
not present in the key. This patch fixes it by allowing profiles
without DMAC and also supports installing rules based on L2MB bit
set by hardware for multicast and broadcast packets.

This patch also adds debugging prints needed to identify profiles
with wrong configuration.

Fixes: 9b179a960a96 ("octeontx2-af: Generate key field bit mask from KEX profile")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  6 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 79 +++++++++++++++++-----
 3 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 9b6e587..2d9c767 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -595,6 +595,7 @@ struct rvu_npc_mcam_rule {
 	bool vfvlan_cfg;
 	u16 chan;
 	u16 chan_mask;
+	u8 lxmb;
 };
 
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 2ad73b1..7cd386b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2410,6 +2410,12 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 	for_each_set_bit(bit, (unsigned long *)&rule->features, 64) {
 		seq_printf(s, "\t%s  ", npc_get_field_name(bit));
 		switch (bit) {
+		case NPC_LXMB:
+			if (rule->lxmb == 1)
+				seq_puts(s, "\tL2M nibble is set\n");
+			else
+				seq_puts(s, "\tL2B nibble is set\n");
+			break;
 		case NPC_DMAC:
 			seq_printf(s, "%pM ", rule->packet.dmac);
 			seq_printf(s, "mask %pM\n", rule->mask.dmac);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 19c53e5..977624d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -41,6 +41,7 @@ static const char * const npc_flow_names[] = {
 	[NPC_DPORT_UDP]	= "udp destination port",
 	[NPC_SPORT_SCTP] = "sctp source port",
 	[NPC_DPORT_SCTP] = "sctp destination port",
+	[NPC_LXMB]	= "Mcast/Bcast header ",
 	[NPC_UNKNOWN]	= "unknown",
 };
 
@@ -318,8 +319,10 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 	vlan_tag2 = &key_fields[NPC_VLAN_TAG2];
 
 	/* if key profile programmed does not extract Ethertype at all */
-	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
+	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws) {
+		dev_err(rvu->dev, "mkex: Ethertype is not extracted.\n");
 		goto vlan_tci;
+	}
 
 	/* if key profile programmed extracts Ethertype from one layer */
 	if (etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
@@ -332,35 +335,45 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 	/* if key profile programmed extracts Ethertype from multiple layers */
 	if (etype_ether->nr_kws && etype_tag1->nr_kws) {
 		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
-			if (etype_ether->kw_mask[i] != etype_tag1->kw_mask[i])
+			if (etype_ether->kw_mask[i] != etype_tag1->kw_mask[i]) {
+				dev_err(rvu->dev, "mkex: Etype pos is different for untagged and tagged pkts.\n");
 				goto vlan_tci;
+			}
 		}
 		key_fields[NPC_ETYPE] = *etype_tag1;
 	}
 	if (etype_ether->nr_kws && etype_tag2->nr_kws) {
 		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
-			if (etype_ether->kw_mask[i] != etype_tag2->kw_mask[i])
+			if (etype_ether->kw_mask[i] != etype_tag2->kw_mask[i]) {
+				dev_err(rvu->dev, "mkex: Etype pos is different for untagged and double tagged pkts.\n");
 				goto vlan_tci;
+			}
 		}
 		key_fields[NPC_ETYPE] = *etype_tag2;
 	}
 	if (etype_tag1->nr_kws && etype_tag2->nr_kws) {
 		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
-			if (etype_tag1->kw_mask[i] != etype_tag2->kw_mask[i])
+			if (etype_tag1->kw_mask[i] != etype_tag2->kw_mask[i]) {
+				dev_err(rvu->dev, "mkex: Etype pos is different for tagged and double tagged pkts.\n");
 				goto vlan_tci;
+			}
 		}
 		key_fields[NPC_ETYPE] = *etype_tag2;
 	}
 
 	/* check none of higher layers overwrite Ethertype */
 	start_lid = key_fields[NPC_ETYPE].layer_mdata.lid + 1;
-	if (npc_check_overlap(rvu, blkaddr, NPC_ETYPE, start_lid, intf))
+	if (npc_check_overlap(rvu, blkaddr, NPC_ETYPE, start_lid, intf)) {
+		dev_err(rvu->dev, "mkex: Ethertype is overwritten by higher layers.\n");
 		goto vlan_tci;
+	}
 	*features |= BIT_ULL(NPC_ETYPE);
 vlan_tci:
 	/* if key profile does not extract outer vlan tci at all */
-	if (!vlan_tag1->nr_kws && !vlan_tag2->nr_kws)
+	if (!vlan_tag1->nr_kws && !vlan_tag2->nr_kws) {
+		dev_err(rvu->dev, "mkex: Outer vlan tci is not extracted.\n");
 		goto done;
+	}
 
 	/* if key profile extracts outer vlan tci from one layer */
 	if (vlan_tag1->nr_kws && !vlan_tag2->nr_kws)
@@ -371,15 +384,19 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 	/* if key profile extracts outer vlan tci from multiple layers */
 	if (vlan_tag1->nr_kws && vlan_tag2->nr_kws) {
 		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
-			if (vlan_tag1->kw_mask[i] != vlan_tag2->kw_mask[i])
+			if (vlan_tag1->kw_mask[i] != vlan_tag2->kw_mask[i]) {
+				dev_err(rvu->dev, "mkex: Out vlan tci pos is different for tagged and double tagged pkts.\n");
 				goto done;
+			}
 		}
 		key_fields[NPC_OUTER_VID] = *vlan_tag2;
 	}
 	/* check none of higher layers overwrite outer vlan tci */
 	start_lid = key_fields[NPC_OUTER_VID].layer_mdata.lid + 1;
-	if (npc_check_overlap(rvu, blkaddr, NPC_OUTER_VID, start_lid, intf))
+	if (npc_check_overlap(rvu, blkaddr, NPC_OUTER_VID, start_lid, intf)) {
+		dev_err(rvu->dev, "mkex: Outer vlan tci is overwritten by higher layers.\n");
 		goto done;
+	}
 	*features |= BIT_ULL(NPC_OUTER_VID);
 done:
 	return;
@@ -499,6 +516,10 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 	if (npc_check_field(rvu, blkaddr, NPC_LB, intf))
 		*features |= BIT_ULL(NPC_VLAN_ETYPE_CTAG) |
 			     BIT_ULL(NPC_VLAN_ETYPE_STAG);
+
+	/* for L2M/L2B/L3M/L3B, check if the type is present in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LXMB, intf))
+		*features |= BIT_ULL(NPC_LXMB);
 }
 
 /* Scan key extraction profile and record how fields of our interest
@@ -564,16 +585,6 @@ static int npc_scan_verify_kex(struct rvu *rvu, int blkaddr)
 		dev_err(rvu->dev, "Channel cannot be overwritten\n");
 		return -EINVAL;
 	}
-	/* DMAC should be present in key for unicast filter to work */
-	if (!npc_is_field_present(rvu, NPC_DMAC, NIX_INTF_RX)) {
-		dev_err(rvu->dev, "DMAC not present in Key\n");
-		return -EINVAL;
-	}
-	/* check that none of the fields overwrite DMAC */
-	if (npc_check_overlap(rvu, blkaddr, NPC_DMAC, 0, NIX_INTF_RX)) {
-		dev_err(rvu->dev, "DMAC cannot be overwritten\n");
-		return -EINVAL;
-	}
 
 	npc_set_features(rvu, blkaddr, NIX_INTF_TX);
 	npc_set_features(rvu, blkaddr, NIX_INTF_RX);
@@ -817,6 +828,11 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 		npc_update_entry(rvu, NPC_LE, entry, NPC_LT_LE_ESP,
 				 0, ~0ULL, 0, intf);
 
+	if (features & BIT_ULL(NPC_LXMB)) {
+		output->lxmb = is_broadcast_ether_addr(pkt->dmac) ? 2 : 1;
+		npc_update_entry(rvu, NPC_LXMB, entry, output->lxmb, 0,
+				 output->lxmb, 0, intf);
+	}
 #define NPC_WRITE_FLOW(field, member, val_lo, val_hi, mask_lo, mask_hi)	      \
 do {									      \
 	if (features & BIT_ULL((field))) {				      \
@@ -1114,6 +1130,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	rule->chan_mask = write_req.entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
 	rule->chan = write_req.entry_data.kw[0] & NPC_KEX_CHAN_MASK;
 	rule->chan &= rule->chan_mask;
+	rule->lxmb = dummy.lxmb;
 	if (is_npc_intf_tx(req->intf))
 		rule->intf = pfvf->nix_tx_intf;
 	else
@@ -1176,6 +1193,32 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (!is_npc_interface_valid(rvu, req->intf))
 		return NPC_FLOW_INTF_INVALID;
 
+	/* If DMAC is not extracted in MKEX, rules installed by AF
+	 * can rely on L2MB bit set by hardware protocol checker for
+	 * broadcast and multicast addresses.
+	 */
+	if (!npc_check_field(rvu, blkaddr, NPC_DMAC, req->intf) &&
+	    is_pffunc_af(req->hdr.pcifunc) &&
+	    req->features & BIT_ULL(NPC_DMAC)) {
+		if (is_unicast_ether_addr(req->packet.dmac)) {
+			dev_err(rvu->dev,
+				"%s: mkex profile does not support ucast flow\n",
+				__func__);
+			return NPC_FLOW_NOT_SUPPORTED;
+		}
+
+		if (!npc_is_field_present(rvu, NPC_LXMB, req->intf)) {
+			dev_err(rvu->dev,
+				"%s: mkex profile does not support bcast/mcast flow",
+				__func__);
+			return NPC_FLOW_NOT_SUPPORTED;
+		}
+
+		/* Modify feature to use LXMB instead of DMAC */
+		req->features &= ~BIT_ULL(NPC_DMAC);
+		req->features |= BIT_ULL(NPC_LXMB);
+	}
+
 	if (from_vf && req->default_rule)
 		return NPC_FLOW_VF_PERM_DENIED;
 
-- 
2.7.4

