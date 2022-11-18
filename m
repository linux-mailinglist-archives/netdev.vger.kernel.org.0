Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82162ED8E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241018AbiKRGXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiKRGXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:23:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B1D9A279;
        Thu, 17 Nov 2022 22:23:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1x3TE004814;
        Thu, 17 Nov 2022 22:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=lPfBL+VDy769EgJ4V8YQIve34aohPUuZ8dN3gigT6z4=;
 b=HG2zi+BU+QoWY2Mwq+JXg1tq3MiY7NE1B1jSJ6Nglz4t0rt39AfgSTRDRmZVgDHWW7m4
 BhEUgqsRH/KLcds/grUSZrD2Y51wQSKGTKbqj32sR7mznJW2zqneauk0slIuzS4fQ93X
 nhlg3GjzkPXFiNqfCwCmYDef+ci1nDsrV975uIyao7ens6OWlNoqQs1s48C2+ztwJwUy
 +Do/gvCCHK1pPuGiKS+k+uMq7ispJvWAeEBmNkIL2UeIN0VmRPr2bpS2j6An+fM1cLXn
 s2jrN0wuBEJcQpqGxuscSxqdTf7dINovmIr47rvjZwn7n7rPBkDOln4QkENBCkzyf0Y8 XQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kx0ut8spr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 22:22:56 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Nov
 2022 22:22:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Nov 2022 22:22:54 -0800
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id E7E0E3F705A;
        Thu, 17 Nov 2022 22:22:50 -0800 (PST)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <jerinj@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Add support to filter packet based on IP fragment
Date:   Fri, 18 Nov 2022 11:52:48 +0530
Message-ID: <20221118062248.2532370-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PUV5Rr7U3IJCHLFs1NRXu5-urocZVzKr
X-Proofpoint-ORIG-GUID: PUV5Rr7U3IJCHLFs1NRXu5-urocZVzKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Added support to filter packets based on IP fragment.
For IPv4 packets check for ip_flag == 0x20 (more fragment bit set).
For IPv6 packets check for next_header == 0x2c (next_header set to
'fragment headre for IPv6')
2. Added configuration support from both "ethtool ntuple" and "tc flower".

Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  4 +++
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  2 ++
 .../marvell/octeontx2/af/rvu_debugfs.c        |  8 ++++++
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  8 ++++++
 .../marvell/octeontx2/nic/otx2_flows.c        | 25 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 25 +++++++++++++++++++
 6 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index c7c92c7510fa..d2584ebb7a70 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1440,6 +1440,10 @@ struct flow_msg {
 	u8 tc;
 	__be16 sport;
 	__be16 dport;
+	union {
+		u8 ip_flag;
+		u8 next_header;
+	};
 };
 
 struct npc_install_flow_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index d027c23b8ef8..9beeead56d7b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -185,8 +185,10 @@ enum key_fields {
 	NPC_VLAN_ETYPE_STAG, /* 0x88A8 */
 	NPC_OUTER_VID,
 	NPC_TOS,
+	NPC_IPFRAG_IPV4,
 	NPC_SIP_IPV4,
 	NPC_DIP_IPV4,
+	NPC_IPFRAG_IPV6,
 	NPC_SIP_IPV6,
 	NPC_DIP_IPV6,
 	NPC_IPPROTO_TCP,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 642e58a04da0..1cf026de5f1a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2799,6 +2799,14 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 			seq_printf(s, "%pI6 ", rule->packet.ip6dst);
 			seq_printf(s, "mask %pI6\n", rule->mask.ip6dst);
 			break;
+		case NPC_IPFRAG_IPV6:
+			seq_printf(s, "%d ", rule->packet.next_header);
+			seq_printf(s, "mask 0x%x\n", rule->mask.next_header);
+			break;
+		case NPC_IPFRAG_IPV4:
+			seq_printf(s, "%d ", rule->packet.ip_flag);
+			seq_printf(s, "mask 0x%x\n", rule->mask.ip_flag);
+			break;
 		case NPC_SPORT_TCP:
 		case NPC_SPORT_UDP:
 		case NPC_SPORT_SCTP:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index f3fecd2a4015..006beb5cf98d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -26,8 +26,10 @@ static const char * const npc_flow_names[] = {
 	[NPC_VLAN_ETYPE_STAG] = "vlan ether type stag",
 	[NPC_OUTER_VID]	= "outer vlan id",
 	[NPC_TOS]	= "tos",
+	[NPC_IPFRAG_IPV4] = "fragmented IPv4 header ",
 	[NPC_SIP_IPV4]	= "ipv4 source ip",
 	[NPC_DIP_IPV4]	= "ipv4 destination ip",
+	[NPC_IPFRAG_IPV6] = "fragmented IPv6 header ",
 	[NPC_SIP_IPV6]	= "ipv6 source ip",
 	[NPC_DIP_IPV6]	= "ipv6 destination ip",
 	[NPC_IPPROTO_TCP] = "ip proto tcp",
@@ -484,8 +486,10 @@ do {									       \
 	 * Example: Source IP is 4 bytes and starts at 12th byte of IP header
 	 */
 	NPC_SCAN_HDR(NPC_TOS, NPC_LID_LC, NPC_LT_LC_IP, 1, 1);
+	NPC_SCAN_HDR(NPC_IPFRAG_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 6, 1);
 	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
 	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
+	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC, NPC_LT_LC_IP6_EXT, 6, 1);
 	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
 	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
 	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
@@ -899,6 +903,8 @@ do {									      \
 	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
 		       ntohs(mask->etype), 0);
 	NPC_WRITE_FLOW(NPC_TOS, tos, pkt->tos, 0, mask->tos, 0);
+	NPC_WRITE_FLOW(NPC_IPFRAG_IPV4, ip_flag, pkt->ip_flag, 0,
+		       mask->ip_flag, 0);
 	NPC_WRITE_FLOW(NPC_SIP_IPV4, ip4src, ntohl(pkt->ip4src), 0,
 		       ntohl(mask->ip4src), 0);
 	NPC_WRITE_FLOW(NPC_DIP_IPV4, ip4dst, ntohl(pkt->ip4dst), 0,
@@ -919,6 +925,8 @@ do {									      \
 	NPC_WRITE_FLOW(NPC_OUTER_VID, vlan_tci, ntohs(pkt->vlan_tci), 0,
 		       ntohs(mask->vlan_tci), 0);
 
+	NPC_WRITE_FLOW(NPC_IPFRAG_IPV6, next_header, pkt->next_header, 0,
+		       mask->next_header, 0);
 	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
 	npc_update_vlan_features(rvu, entry, features, intf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 13aa79efee03..ac0aa0530399 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -711,6 +711,11 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip6dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV6);
 		}
+		if (ipv6_usr_hdr->l4_proto == IPPROTO_FRAGMENT) {
+			pkt->next_header = ipv6_usr_hdr->l4_proto;
+			pmask->next_header = ipv6_usr_mask->l4_proto;
+			req->features |= BIT_ULL(NPC_IPFRAG_IPV6);
+		}
 		pkt->etype = cpu_to_be16(ETH_P_IPV6);
 		pmask->etype = cpu_to_be16(0xFFFF);
 		req->features |= BIT_ULL(NPC_ETYPE);
@@ -891,10 +896,22 @@ static int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 			req->features |= BIT_ULL(NPC_OUTER_VID);
 		}
 
-		/* Not Drop/Direct to queue but use action in default entry */
-		if (fsp->m_ext.data[1] &&
-		    fsp->h_ext.data[1] == cpu_to_be32(OTX2_DEFAULT_ACTION))
-			req->op = NIX_RX_ACTION_DEFAULT;
+		if (fsp->m_ext.data[1]) {
+			if (flow_type == IP_USER_FLOW) {
+				if (be32_to_cpu(fsp->h_ext.data[1]) != 0x20)
+					return -EINVAL;
+
+				pkt->ip_flag = be32_to_cpu(fsp->h_ext.data[1]);
+				pmask->ip_flag = fsp->m_ext.data[1];
+				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
+			} else if (fsp->h_ext.data[1] ==
+					cpu_to_be32(OTX2_DEFAULT_ACTION)) {
+				/* Not Drop/Direct to queue but use action
+				 * in default entry
+				 */
+				req->op = NIX_RX_ACTION_DEFAULT;
+			}
+		}
 	}
 
 	if (fsp->flow_type & FLOW_MAC_EXT &&
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index e64318c110fd..a4a85e075eeb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -532,6 +532,31 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 			req->features |= BIT_ULL(NPC_IPPROTO_ICMP6);
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
+		struct flow_match_control match;
+
+		flow_rule_match_control(rule, &match);
+		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			netdev_info(nic->netdev, "HW doesn't support frag first/later");
+			return -EOPNOTSUPP;
+		}
+
+		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+			if (ntohs(flow_spec->etype) == ETH_P_IP) {
+				flow_spec->ip_flag = 0x20;
+				flow_mask->ip_flag = 0xff;
+				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
+			} else if (ntohs(flow_spec->etype) == ETH_P_IPV6) {
+				flow_spec->next_header = IPPROTO_FRAGMENT;
+				flow_mask->next_header = 0xff;
+				req->features |= BIT_ULL(NPC_IPFRAG_IPV6);
+			} else {
+				netdev_info(nic->netdev, "flow-type should be either IPv4 and IPv6");
+				return -EOPNOTSUPP;
+			}
+		}
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
-- 
2.25.1

