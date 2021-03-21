Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44B4343254
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhCUMLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:11:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42638 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhCUMKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5JPk017915;
        Sun, 21 Mar 2021 05:10:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FBwC12MY/d8yk/RQLb2j0ATHKQfuuSGB24FXm7rm9xA=;
 b=OcyyPQ0oqSq5/mMJfYLh3rYMyD7zh7tEd0F9KRTUGD2C8raRwz2GF7s6l8j2I1SW+yUn
 JSOmfhB/suNTfyarlsp/HIXEdYIOazjQaNo/yYngWna5PgV2mhL5ZmvUrIXhWoIiSnFI
 5r7VfdWE1/QEYr9mY0jvGytvMTV9SA39SPSwA2rIQcI6Hs/mf1yrOH9T8QK/8AyZKveG
 8xV2jt5k6rmIIeOZtuC9YQoSanOTAQQImEqElJs3HqMUFVI7Ef2ubakNS9wlFFDWobE0
 6ezwkREKNXGc606vPz6vZQ5NsFjBARASOhxk3F0zYafEvuQcCqEVl4MC2l4Qp2JKjr1a wQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnt352-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:27 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E5FC13F7041;
        Sun, 21 Mar 2021 05:10:23 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 7/8] octeontx2-af: Add flow steering support for FDSA tag
Date:   Sun, 21 Mar 2021 17:39:57 +0530
Message-ID: <20210321120958.17531-8-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210321120958.17531-1-hkelam@marvell.com>
References: <20210321120958.17531-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell switches support distributed switch architecture (DSA) by
implementing FORWARD(FDSA). Special pkind 62 is reserved to parse
this tag.

This patch adds support to configure pkind and flow steering for
the same. To distribute fdsa packets among PF/VF , one can
specify NPC_FDSA_VAL in mcam features .Rx vtag Type 6 is reserved
to strip FDSA tag.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  8 ++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  3 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  9 +++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 10 +++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 14 ++++++++++++--
 7 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index a1f71ee9e98..8e0d1e47876 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -482,6 +482,7 @@ struct npc_set_pkind {
 #define OTX2_PRIV_FLAGS_DEFAULT  BIT_ULL(0)
 #define OTX2_PRIV_FLAGS_EDSA     BIT_ULL(1)
 #define OTX2_PRIV_FLAGS_HIGIG    BIT_ULL(2)
+#define OTX2_PRIV_FLAGS_FDSA     BIT_ULL(3)
 #define OTX2_PRIV_FLAGS_CUSTOM   BIT_ULL(63)
 	u64 mode;
 #define PKIND_TX		BIT_ULL(0)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index e60f1fa2d55..059de54a4dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -179,6 +179,7 @@ enum key_fields {
 	NPC_DPORT_UDP,
 	NPC_SPORT_SCTP,
 	NPC_DPORT_SCTP,
+	NPC_FDSA_VAL,
 	NPC_HEADER_FIELDS_MAX,
 	NPC_CHAN = NPC_HEADER_FIELDS_MAX, /* Valid when Rx */
 	NPC_PF_FUNC, /* Valid when Tx */
@@ -208,6 +209,13 @@ enum key_fields {
 	NPC_KEY_FIELDS_MAX,
 };
 
+enum npc_interface_type {
+	NPC_INTF_MODE_DEF,
+	NPC_INTF_MODE_EDSA,
+	NPC_INTF_MODE_HIGIG,
+	NPC_INTF_MODE_FDSA,
+};
+
 struct npc_kpu_profile_cam {
 	u8 state;
 	u8 state_mask;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index ae51937ee46..f9fd443a34d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -239,6 +239,7 @@ struct rvu_pfvf {
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
+	int     intf_mode;
 };
 
 struct nix_txsch {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 741da112fdf..791eaf5e2ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2002,7 +2002,8 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.etype));
 			break;
 		case NPC_OUTER_VID:
-			seq_printf(s, "0x%x ", ntohs(rule->packet.vlan_tci));
+		case NPC_FDSA_VAL:
+			seq_printf(s, "%d ", ntohs(rule->packet.vlan_tci));
 			seq_printf(s, "mask 0x%x\n",
 				   ntohs(rule->mask.vlan_tci));
 			break;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 56ade799011..8959f03867f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1217,6 +1217,11 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	rvu_write64(rvu, blkaddr,
 		    NIX_AF_LFX_RX_VTAG_TYPEX(nixlf, NIX_AF_LFX_RX_VTAG_TYPE7),
 		    VTAGSIZE_T4 | VTAG_STRIP);
+	/* Configure RX VTAG Type 6 (strip) for fdsa */
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_LFX_RX_VTAG_TYPEX(nixlf, NIX_AF_LFX_RX_VTAG_TYPE6),
+		    VTAGSIZE_T4 | VTAG_STRIP | VTAG_CAPTURE);
+
 
 	goto exit;
 
@@ -2016,8 +2021,8 @@ static int nix_rx_vtag_cfg(struct rvu *rvu, int nixlf, int blkaddr,
 	    req->vtag_size > VTAGSIZE_T8)
 		return -EINVAL;
 
-	/* RX VTAG Type 7 reserved for vf vlan */
-	if (req->rx.vtag_type == NIX_AF_LFX_RX_VTAG_TYPE7)
+	/* RX VTAG Type 7,6 are reserved for vf vlan& FDSA tag strip */
+	if (req->rx.vtag_type >= NIX_AF_LFX_RX_VTAG_TYPE6)
 		return NIX_AF_ERR_RX_VTAG_INUSE;
 
 	if (req->rx.capture_vtag)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index dba57a6b439..70a4243056e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2849,18 +2849,24 @@ int rvu_mbox_handler_npc_mcam_entry_stats(struct rvu *rvu,
 int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 			   u64 pkind)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr, nixlf, rc, intf_mode;
 	int pf = rvu_get_pf(pcifunc);
 	bool enable_higig2 = false;
-	int blkaddr, nixlf, rc;
 	u64 rxpkind, txpkind;
 	u8 cgx_id, lmac_id;
 
 	/* use default pkind to disable edsa/higig */
 	rxpkind = rvu_npc_get_pkind(rvu, pf);
 	txpkind = NPC_TX_DEF_PKIND;
+	intf_mode = NPC_INTF_MODE_DEF;
 
 	if (mode & OTX2_PRIV_FLAGS_EDSA) {
 		rxpkind = NPC_RX_EDSA_PKIND;
+		intf_mode = NPC_INTF_MODE_EDSA;
+	} else if (mode & OTX2_PRIV_FLAGS_FDSA) {
+		rxpkind = NPC_RX_EDSA_PKIND;
+		intf_mode = NPC_INTF_MODE_FDSA;
 	} else if (mode & OTX2_PRIV_FLAGS_HIGIG) {
 		/* Silicon does not support enabling higig in time stamp mode */
 		if (rvu_nix_is_ptp_tx_enabled(rvu, pcifunc))
@@ -2872,6 +2878,7 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 
 		rxpkind = NPC_RX_HIGIG_PKIND;
 		txpkind = NPC_TX_HIGIG_PKIND;
+		intf_mode = NPC_INTF_MODE_HIGIG;
 		enable_higig2 = true;
 	} else if (mode & OTX2_PRIV_FLAGS_CUSTOM) {
 		rxpkind = pkind;
@@ -2903,6 +2910,7 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 	if (enable_higig2 ^ rvu_cgx_is_higig2_enabled(rvu, pf))
 		rvu_cgx_enadis_higig2(rvu, pf, enable_higig2);
 
+	pfvf->intf_mode = intf_mode;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 7f35b62eea1..17097a07ccb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -39,6 +39,7 @@ static const char * const npc_flow_names[] = {
 	[NPC_DPORT_UDP]	= "udp destination port",
 	[NPC_SPORT_SCTP] = "sctp source port",
 	[NPC_DPORT_SCTP] = "sctp destination port",
+	[NPC_FDSA_VAL]	= "FDSA tag value ",
 	[NPC_UNKNOWN]	= "unknown",
 };
 
@@ -445,6 +446,7 @@ do {									       \
 	NPC_SCAN_HDR(NPC_ETYPE_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 8, 2);
 	NPC_SCAN_HDR(NPC_VLAN_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 2, 2);
 	NPC_SCAN_HDR(NPC_VLAN_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 2, 2);
+	NPC_SCAN_HDR(NPC_FDSA_VAL, NPC_LID_LB, NPC_LT_LB_FDSA, 1, 1);
 	NPC_SCAN_HDR(NPC_DMAC, NPC_LID_LA, la_ltype, la_start, 6);
 	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start, 6);
 	/* PF_FUNC is 2 bytes at 0th byte of NPC_LT_LA_IH_NIX_ETHER */
@@ -492,9 +494,12 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 		*features |= BIT_ULL(NPC_IPPROTO_ESP);
 
 	/* for vlan corresponding layer type should be in the key */
-	if (*features & BIT_ULL(NPC_OUTER_VID))
-		if (!npc_check_field(rvu, blkaddr, NPC_LB, intf))
+	if (*features & BIT_ULL(NPC_OUTER_VID) ||
+	    *features & BIT_ULL(NPC_FDSA_VAL))
+		if (!npc_check_field(rvu, blkaddr, NPC_LB, intf)) {
 			*features &= ~BIT_ULL(NPC_OUTER_VID);
+			*features &= ~BIT_ULL(NPC_FDSA_VAL);
+		}
 }
 
 /* Scan key extraction profile and record how fields of our interest
@@ -786,6 +791,9 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 		npc_update_entry(rvu, NPC_LB, entry,
 				 NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
 				 NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
+	if (features & BIT_ULL(NPC_FDSA_VAL))
+		npc_update_entry(rvu, NPC_LB, entry, NPC_LT_LB_FDSA,
+				 0, ~0ULL, 0, intf);
 
 	/* For AH, LTYPE should be present in entry */
 	if (features & BIT_ULL(NPC_IPPROTO_AH))
@@ -830,6 +838,8 @@ do {									      \
 
 	NPC_WRITE_FLOW(NPC_OUTER_VID, vlan_tci, ntohs(pkt->vlan_tci), 0,
 		       ntohs(mask->vlan_tci), 0);
+	NPC_WRITE_FLOW(NPC_FDSA_VAL, vlan_tci, ntohs(pkt->vlan_tci), 0,
+		       ntohs(mask->vlan_tci), 0);
 
 	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
 }
-- 
2.17.1

