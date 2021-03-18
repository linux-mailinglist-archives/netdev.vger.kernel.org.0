Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5E03402A4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCRKCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:02:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229883AbhCRKCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:02:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IA0gR5020909;
        Thu, 18 Mar 2021 03:02:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/dHbVe1/D1vMFnD3V7p6epC9TOJRyViLILJT5VXI9EI=;
 b=kQ7Rnz1WsGQQtBF/bOBP/Dncum8uclMiNj1JInSH8O+0SdN6YT2oKoN/syCjLqXm7iv3
 jjt8C0j7ZTfZ+uYNPGWYjoA4ZOeRIMkhFFVedQoXuLPr8+hQBqNc8zmszzUyyCvGNRGP
 3feUlshRaB1OfLLX7A0mZPZMwxCP/KDGuwO4wynKMSq+3hnGqYpj6e6EPThOqR/6msVE
 fhD5LWZ6rDtyLoRXVLgDoHseNq90D2bzvxpAjAsHJiBnztGeDIg+DXbZ4/fttX5welB3
 PoxrjOL6m/2UB4yb2B8r9WpHN0SaovQMb+Eu8VrKRxjys/G9F5edCvbF3PbawDgMkVH8 /w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqyxw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 03:02:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 03:02:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 03:02:27 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 85DCF3F703F;
        Thu, 18 Mar 2021 03:02:24 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 1/4] octeontx2-pf: Add ip tos and ip proto icmp/icmpv6 flow offload support
Date:   Thu, 18 Mar 2021 15:32:12 +0530
Message-ID: <20210318100215.15795-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210318100215.15795-1-naveenm@marvell.com>
References: <20210318100215.15795-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for programming the HW MCAM match key with IP tos, IP(v6)
proto icmp/icmpv6, allowing flow offload rules to be installed using
those fields. The NPC HW extracts layer type, which will be used as a
matching criteria for different IP protocols.

The ethtool n-tuple filter logic has been updated to parse the IP tos
and l4proto for HW offloading. l4proto tcp/udp/sctp/ah/esp/icmp are
supported. See example usage below.

Ex: Redirect l4proto icmp to vf 0 queue 0
ethtool -U eth0 flow-type ip4 l4proto 1 action vf 0 queue 0

Ex: Redirect flow with ip tos 8 to vf 0 queue 0
ethtool -U eth0 flow-type ip4 tos 8 vf 0 queue 0

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 17 +++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 42 ++++++++++++++++++++--
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 0675c55dcc7a..1e012e787260 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -167,6 +167,8 @@ enum key_fields {
 	NPC_IPPROTO_SCTP,
 	NPC_IPPROTO_AH,
 	NPC_IPPROTO_ESP,
+	NPC_IPPROTO_ICMP,
+	NPC_IPPROTO_ICMP6,
 	NPC_SPORT_TCP,
 	NPC_DPORT_TCP,
 	NPC_SPORT_UDP,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index d805a189a268..7f35b62eea13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -29,6 +29,8 @@ static const char * const npc_flow_names[] = {
 	[NPC_IPPROTO_TCP] = "ip proto tcp",
 	[NPC_IPPROTO_UDP] = "ip proto udp",
 	[NPC_IPPROTO_SCTP] = "ip proto sctp",
+	[NPC_IPPROTO_ICMP] = "ip proto icmp",
+	[NPC_IPPROTO_ICMP6] = "ip proto icmp6",
 	[NPC_IPPROTO_AH] = "ip proto AH",
 	[NPC_IPPROTO_ESP] = "ip proto ESP",
 	[NPC_SPORT_TCP]	= "tcp source port",
@@ -427,6 +429,7 @@ do {									       \
 	 * packet header fields below.
 	 * Example: Source IP is 4 bytes and starts at 12th byte of IP header
 	 */
+	NPC_SCAN_HDR(NPC_TOS, NPC_LID_LC, NPC_LT_LC_IP, 1, 1);
 	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
 	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
 	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
@@ -477,9 +480,12 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 				     BIT_ULL(NPC_IPPROTO_SCTP);
 	}
 
-	/* for AH, check if corresponding layer type is present in the key */
-	if (npc_check_field(rvu, blkaddr, NPC_LD, intf))
+	/* for AH/ICMP/ICMPv6/, check if corresponding layer type is present in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LD, intf)) {
 		*features |= BIT_ULL(NPC_IPPROTO_AH);
+		*features |= BIT_ULL(NPC_IPPROTO_ICMP);
+		*features |= BIT_ULL(NPC_IPPROTO_ICMP6);
+	}
 
 	/* for ESP, check if corresponding layer type is present in the key */
 	if (npc_check_field(rvu, blkaddr, NPC_LE, intf))
@@ -769,6 +775,12 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 	if (features & BIT_ULL(NPC_IPPROTO_SCTP))
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_SCTP,
 				 0, ~0ULL, 0, intf);
+	if (features & BIT_ULL(NPC_IPPROTO_ICMP))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_ICMP,
+				 0, ~0ULL, 0, intf);
+	if (features & BIT_ULL(NPC_IPPROTO_ICMP6))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_ICMP6,
+				 0, ~0ULL, 0, intf);
 
 	if (features & BIT_ULL(NPC_OUTER_VID))
 		npc_update_entry(rvu, NPC_LB, entry,
@@ -798,6 +810,7 @@ do {									      \
 	NPC_WRITE_FLOW(NPC_SMAC, smac, smac_val, 0, smac_mask, 0);
 	NPC_WRITE_FLOW(NPC_ETYPE, etype, ntohs(pkt->etype), 0,
 		       ntohs(mask->etype), 0);
+	NPC_WRITE_FLOW(NPC_TOS, tos, pkt->tos, 0, mask->tos, 0);
 	NPC_WRITE_FLOW(NPC_SIP_IPV4, ip4src, ntohl(pkt->ip4src), 0,
 		       ntohl(mask->ip4src), 0);
 	NPC_WRITE_FLOW(NPC_DIP_IPV4, ip4dst, ntohl(pkt->ip4dst), 0,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0dbbf38e0597..3264cb793f02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -301,6 +301,35 @@ static int otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip4dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV4);
 		}
+		if (ipv4_usr_mask->tos) {
+			pkt->tos = ipv4_usr_hdr->tos;
+			pmask->tos = ipv4_usr_mask->tos;
+			req->features |= BIT_ULL(NPC_TOS);
+		}
+		if (ipv4_usr_mask->proto) {
+			switch (ipv4_usr_hdr->proto) {
+			case IPPROTO_ICMP:
+				req->features |= BIT_ULL(NPC_IPPROTO_ICMP);
+				break;
+			case IPPROTO_TCP:
+				req->features |= BIT_ULL(NPC_IPPROTO_TCP);
+				break;
+			case IPPROTO_UDP:
+				req->features |= BIT_ULL(NPC_IPPROTO_UDP);
+				break;
+			case IPPROTO_SCTP:
+				req->features |= BIT_ULL(NPC_IPPROTO_SCTP);
+				break;
+			case IPPROTO_AH:
+				req->features |= BIT_ULL(NPC_IPPROTO_AH);
+				break;
+			case IPPROTO_ESP:
+				req->features |= BIT_ULL(NPC_IPPROTO_ESP);
+				break;
+			default:
+				return -EOPNOTSUPP;
+			}
+		}
 		pkt->etype = cpu_to_be16(ETH_P_IP);
 		pmask->etype = cpu_to_be16(0xFFFF);
 		req->features |= BIT_ULL(NPC_ETYPE);
@@ -325,6 +354,11 @@ static int otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip4dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV4);
 		}
+		if (ipv4_l4_mask->tos) {
+			pkt->tos = ipv4_l4_hdr->tos;
+			pmask->tos = ipv4_l4_mask->tos;
+			req->features |= BIT_ULL(NPC_TOS);
+		}
 		if (ipv4_l4_mask->psrc) {
 			memcpy(&pkt->sport, &ipv4_l4_hdr->psrc,
 			       sizeof(pkt->sport));
@@ -375,10 +409,14 @@ static int otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip4dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV4);
 		}
+		if (ah_esp_mask->tos) {
+			pkt->tos = ah_esp_hdr->tos;
+			pmask->tos = ah_esp_mask->tos;
+			req->features |= BIT_ULL(NPC_TOS);
+		}
 
 		/* NPC profile doesn't extract AH/ESP header fields */
-		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
-		    (ah_esp_mask->tos & ah_esp_mask->tos))
+		if (ah_esp_mask->spi & ah_esp_hdr->spi)
 			return -EOPNOTSUPP;
 
 		if (flow_type == AH_V4_FLOW)
-- 
2.16.5

