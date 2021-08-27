Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9683F98EC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbhH0MQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 08:16:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39660 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhH0MQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 08:16:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RBHnvq013336;
        Fri, 27 Aug 2021 05:15:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=F1i/7NmPGHzUGAvKk7ujACKas2rCd5S2EGwdaHtX5rM=;
 b=blLdyfNcSKmJLvGeiK5wr0p36t1R66pxUjwTP1QFX1GNRhWFVPZW3dO+IS+MALrIeUt2
 Wsarntzm00wWHaLVfc9+950exC10ZfyPyNMhtHm74w/iPhGlj0fF65bsJxKYZLehxkLi
 PCzo/iRULHbk+ADKcKKijs2xxsOnGmsWv++W5oDi1T4DbuiVVX+QY5idDXCMJRiuJa9l
 ZIlVmQ8ihDjJrbm2PCcy5XQsvI8HQbb+PJLK67zMAhbVPxQJpJpdI34gFoUbQ92Dl3V4
 ETIJ3Rd2OyMRWcgrHMkAN06Kvo3xriiJqHVclC2/Y+6XqdZunkj79Ttyfxi805UNu1+c sw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3apwgp0g4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 05:15:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 27 Aug
 2021 05:15:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 27 Aug 2021 05:15:40 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 59EC33F705B;
        Fri, 27 Aug 2021 05:15:38 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Add vlan-etype to ntuple filters
Date:   Fri, 27 Aug 2021 17:45:36 +0530
Message-ID: <1630066536-879-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: YZXNWsiwQz_v_mnG4R-Hx0-EZy2QOjcJ
X-Proofpoint-ORIG-GUID: YZXNWsiwQz_v_mnG4R-Hx0-EZy2QOjcJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-27_04,2021-08-26_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NPC extraction profile marks layer types
NPC_LT_LB_CTAG for CTAG and NPC_LT_LB_STAG_QINQ for
STAG after parsing input packet. Those layer types
can be used to install ntuple filters using
vlan-etype option. Below are the commands and
corresponding behavior with this patch in place.

> alias nt "ethtool -U eth0 flow-type ether"

> nt vlan 5 m 0xf000 action 0
Input packets with outer VLAN id as 5 i.e,
stag packets with VLAN id 5 and ctag packets with
VLAN id as 5 are hit.

> nt vlan-etype 0x8100 action 0
All input ctag packets with any VLAN id are hit.

> nt vlan-etype 0x88A8 action 0
All input stag packets with any VLAN id are hit.

> nt vlan-etype 0x8100 vlan 5 m 0xf000 action 0
All input ctag packets with VLAN id 5 are hit.

> nt vlan-etype 0x88A8 vlan 5 m 0xf000 action 0
All input stag packets with VLAN id 5 are hit.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 35 ++++++++++++++++++----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 26 ++++++++++++++--
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 243cf80..b426fd5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -172,6 +172,8 @@ enum key_fields {
 	NPC_DMAC,
 	NPC_SMAC,
 	NPC_ETYPE,
+	NPC_VLAN_ETYPE_CTAG, /* 0x8100 */
+	NPC_VLAN_ETYPE_STAG, /* 0x88A8 */
 	NPC_OUTER_VID,
 	NPC_TOS,
 	NPC_SIP_IPV4,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 43874d3..e0634ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -20,6 +20,8 @@ static const char * const npc_flow_names[] = {
 	[NPC_DMAC]	= "dmac",
 	[NPC_SMAC]	= "smac",
 	[NPC_ETYPE]	= "ether type",
+	[NPC_VLAN_ETYPE_CTAG] = "vlan ether type ctag",
+	[NPC_VLAN_ETYPE_STAG] = "vlan ether type stag",
 	[NPC_OUTER_VID]	= "outer vlan id",
 	[NPC_TOS]	= "tos",
 	[NPC_SIP_IPV4]	= "ipv4 source ip",
@@ -492,6 +494,11 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 	if (*features & BIT_ULL(NPC_OUTER_VID))
 		if (!npc_check_field(rvu, blkaddr, NPC_LB, intf))
 			*features &= ~BIT_ULL(NPC_OUTER_VID);
+
+	/* for vlan ethertypes corresponding layer type should be in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LB, intf))
+		*features |= BIT_ULL(NPC_VLAN_ETYPE_CTAG) |
+			     BIT_ULL(NPC_VLAN_ETYPE_STAG);
 }
 
 /* Scan key extraction profile and record how fields of our interest
@@ -747,6 +754,28 @@ static void npc_update_ipv6_flow(struct rvu *rvu, struct mcam_entry *entry,
 	}
 }
 
+static void npc_update_vlan_features(struct rvu *rvu, struct mcam_entry *entry,
+				     u64 features, u8 intf)
+{
+	bool ctag = !!(features & BIT_ULL(NPC_VLAN_ETYPE_CTAG));
+	bool stag = !!(features & BIT_ULL(NPC_VLAN_ETYPE_STAG));
+	bool vid = !!(features & BIT_ULL(NPC_OUTER_VID));
+
+	/* If only VLAN id is given then always match outer VLAN id */
+	if (vid && !ctag && !stag) {
+		npc_update_entry(rvu, NPC_LB, entry,
+				 NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
+				 NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
+		return;
+	}
+	if (ctag)
+		npc_update_entry(rvu, NPC_LB, entry, NPC_LT_LB_CTAG, 0,
+				 ~0ULL, 0, intf);
+	if (stag)
+		npc_update_entry(rvu, NPC_LB, entry, NPC_LT_LB_STAG_QINQ, 0,
+				 ~0ULL, 0, intf);
+}
+
 static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 			    u64 features, struct flow_msg *pkt,
 			    struct flow_msg *mask,
@@ -779,11 +808,6 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_ICMP6,
 				 0, ~0ULL, 0, intf);
 
-	if (features & BIT_ULL(NPC_OUTER_VID))
-		npc_update_entry(rvu, NPC_LB, entry,
-				 NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
-				 NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
-
 	/* For AH, LTYPE should be present in entry */
 	if (features & BIT_ULL(NPC_IPPROTO_AH))
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_AH,
@@ -829,6 +853,7 @@ do {									      \
 		       ntohs(mask->vlan_tci), 0);
 
 	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
+	npc_update_vlan_features(rvu, entry, features, intf);
 }
 
 static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index e949001..283ef6b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -818,8 +818,30 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 		return -EOPNOTSUPP;
 	}
 	if (fsp->flow_type & FLOW_EXT) {
-		if (fsp->m_ext.vlan_etype)
-			return -EINVAL;
+		u16 vlan_etype;
+
+		if (fsp->m_ext.vlan_etype) {
+			/* Partial masks not supported */
+			if (be16_to_cpu(fsp->m_ext.vlan_etype) != 0xFFFF)
+				return -EINVAL;
+
+			vlan_etype = be16_to_cpu(fsp->h_ext.vlan_etype);
+			/* Only ETH_P_8021Q and ETH_P_802AD types supported */
+			if (vlan_etype != ETH_P_8021Q &&
+			    vlan_etype != ETH_P_8021AD)
+				return -EINVAL;
+
+			memcpy(&pkt->vlan_etype, &fsp->h_ext.vlan_etype,
+			       sizeof(pkt->vlan_etype));
+			memcpy(&pmask->vlan_etype, &fsp->m_ext.vlan_etype,
+			       sizeof(pmask->vlan_etype));
+
+			if (vlan_etype == ETH_P_8021Q)
+				req->features |= BIT_ULL(NPC_VLAN_ETYPE_CTAG);
+			else
+				req->features |= BIT_ULL(NPC_VLAN_ETYPE_STAG);
+		}
+
 		if (fsp->m_ext.vlan_tci) {
 			memcpy(&pkt->vlan_tci, &fsp->h_ext.vlan_tci,
 			       sizeof(pkt->vlan_tci));
-- 
2.7.4

