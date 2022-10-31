Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E101613240
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJaJJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiJaJJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:09:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEEBDE8A;
        Mon, 31 Oct 2022 02:09:19 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29V5IBMR015349;
        Mon, 31 Oct 2022 02:09:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=AU95ZJiRld81oq3O7vkFXe8vU8Pm9LBVuEizq6911t0=;
 b=OEmypvI8ymwJL1bommn93ClJUZPaVXA2tU+HKpABFU9zBzOqNLUCt8w73i6lh7ywZdul
 qMhc1Vm+SL0+HAPhebqNprYVKwIWr5F+YIpwVzeB8A5/dr49150W03PM/nT7LFICdZM2
 2IZqDxne4RX+d5drG+6t8NXAtPlCIevP17fpXfjEoUYRkeNpAB+KKUBmyIP/yy5yOfVF
 oCofmY2/66jq8w/4RJhcjpMpNobnd43UVE+p6bE+rFuWQctCwhGzuuswmZXCfF7fYBLa
 RlT/8oIAyvz9jmtdQ1ZwCOhdQ2MygU5sWkB4M4Q1zYHG5d1fzn77b88EHJsyUalhd9cb Tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kj83c8nrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 02:09:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Oct
 2022 02:09:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 31 Oct 2022 02:09:03 -0700
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id 0A49E3F70B4;
        Mon, 31 Oct 2022 02:08:59 -0700 (PDT)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <rkannoth@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <naveenm@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Allow mkex profile without DMAC and add L2M/L2B header extraction support
Date:   Mon, 31 Oct 2022 14:38:56 +0530
Message-ID: <20221031090856.1404303-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OWzt6H1qzeNrQsJwG4Lbr2sj1Mdb4cB4
X-Proofpoint-GUID: OWzt6H1qzeNrQsJwG4Lbr2sj1Mdb4cB4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_06,2022-10-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. It is possible to have custom mkex profiles which do not extract
DMAC at all into the key. Hence allow mkex profiles which do not
have DMAC to be loaded into MCAM hardware. This patch also adds
debugging prints needed to identify profiles with wrong
configuration.

2. If a mkex profile set "l2l3mb" field for Rx interface,
then Rx multicast and broadcast entry should be configured.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  1 +
 .../marvell/octeontx2/af/rvu_debugfs.c        |  6 ++
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 81 ++++++++++++++-----
 3 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index f187293e3e08..d027c23b8ef8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -620,6 +620,7 @@ struct rvu_npc_mcam_rule {
 	bool vfvlan_cfg;
 	u16 chan;
 	u16 chan_mask;
+	u8 lxmb;
 };
 
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index a1970ebedf95..642e58a04da0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2756,6 +2756,12 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
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
index 7c4e1acd0f77..50d3994efa97 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -43,6 +43,7 @@ static const char * const npc_flow_names[] = {
 	[NPC_DPORT_UDP]	= "udp destination port",
 	[NPC_SPORT_SCTP] = "sctp source port",
 	[NPC_DPORT_SCTP] = "sctp destination port",
+	[NPC_LXMB]	= "Mcast/Bcast header ",
 	[NPC_UNKNOWN]	= "unknown",
 };
 
@@ -340,8 +341,10 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 	vlan_tag2 = &key_fields[NPC_VLAN_TAG2];
 
 	/* if key profile programmed does not extract Ethertype at all */
-	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
+	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws) {
+		dev_err(rvu->dev, "mkex: Ethertype is not extracted.\n");
 		goto vlan_tci;
+	}
 
 	/* if key profile programmed extracts Ethertype from one layer */
 	if (etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
@@ -354,35 +357,45 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
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
@@ -393,15 +406,19 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
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
@@ -522,6 +539,10 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 	if (npc_check_field(rvu, blkaddr, NPC_LB, intf))
 		*features |= BIT_ULL(NPC_VLAN_ETYPE_CTAG) |
 			     BIT_ULL(NPC_VLAN_ETYPE_STAG);
+
+	/* for L2M/L2B/L3M/L3B, check if the type is present in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LXMB, intf))
+		*features |= BIT_ULL(NPC_LXMB);
 }
 
 /* Scan key extraction profile and record how fields of our interest
@@ -599,16 +620,6 @@ static int npc_scan_verify_kex(struct rvu *rvu, int blkaddr)
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
@@ -851,6 +862,11 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
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
@@ -1153,6 +1169,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	rule->chan_mask = write_req.entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
 	rule->chan = write_req.entry_data.kw[0] & NPC_KEX_CHAN_MASK;
 	rule->chan &= rule->chan_mask;
+	rule->lxmb = dummy.lxmb;
 	if (is_npc_intf_tx(req->intf))
 		rule->intf = pfvf->nix_tx_intf;
 	else
@@ -1215,6 +1232,34 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	if (!is_npc_interface_valid(rvu, req->intf))
 		return NPC_FLOW_INTF_INVALID;
 
+	/* If DMAC is not extracted in MKEX, rules installed by AF
+	 * can rely on L2MB bit set by hardware protocol checker for
+	 * broadcast and multicast addresses.
+	 */
+	if (npc_check_field(rvu, blkaddr, NPC_DMAC, req->intf))
+		goto process_flow;
+
+	if (is_pffunc_af(req->hdr.pcifunc)) {
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
+process_flow:
 	if (from_vf && req->default_rule)
 		return NPC_FLOW_VF_PERM_DENIED;
 
-- 
2.25.1

