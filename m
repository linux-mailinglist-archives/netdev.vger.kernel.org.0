Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39662F1174
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbhAKL02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:26:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54578 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729273AbhAKL01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:26:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BBPY2u002953;
        Mon, 11 Jan 2021 03:25:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=wuJYNk4PmwoUaqUX2of1MD2N8tbOFyOHYwu56tBVLzM=;
 b=IL8vypRSRLTNorqt9NAQRemRRTHcxIv3/EZUctjMQO52WXjoecr20+wBXFS/RaT8qmCt
 +hANiM9wwzo7QopLMcgTRd2DopSRtcmxVrXat7vj0MLx94Y5QrtLKExOHeLvYn68qzhI
 HwjRre1ebj2WYyFJyK8jGfVxYPularmS8KeVQS6w0mEObtLevYTL7ZY/mIqjSuFAjtkW
 Hdar9ahBHO4DHDl7FrzQ6zw8v/lL4BqQ1RQbfwm7f4vnor90ad0ZHoEEOp28F5KKq8Vm
 AT8pS+VKCCqW0hrp4eBtXWlwulHc1nJokVQ2NQwltR6UXgdyuRqgd/UcHG7S91X9bhYt sg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsm1g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 03:25:43 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 03:25:41 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 03:25:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 Jan 2021 03:25:41 -0800
Received: from hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 59ED93F703F;
        Mon, 11 Jan 2021 03:25:38 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH] octeontx2-pf: Add flow classification using IP next level protocol
Date:   Mon, 11 Jan 2021 16:55:37 +0530
Message-ID: <20210111112537.3277-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_23:2021-01-11,2021-01-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to install flow rules using ipv4 proto or
ipv6 next header field to distinguish between tcp/udp/sctp/esp/ah
flows when user doesn't specify the other match creteria related to
the flow such as tcp/udp/sctp source port and destination port, ah/esp
spi value. This is achieved by matching the layer type extracted by
NPC HW into the search key. Modified the driver to use Ethertype as
match criteria when user doesn't specify source IP address and dest
IP address. The esp/ah flow rule matching using security parameter
index (spi) is not supported as of now since the field is not extracted
into MCAM search key. Modified npc_check_field function to return bool.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  52 ++++++---
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 116 +++++++++++++++++++--
 4 files changed, 153 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index a1f79445db71..3c640f6aba92 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -162,6 +162,11 @@ enum key_fields {
 	NPC_DIP_IPV4,
 	NPC_SIP_IPV6,
 	NPC_DIP_IPV6,
+	NPC_IPPROTO_TCP,
+	NPC_IPPROTO_UDP,
+	NPC_IPPROTO_SCTP,
+	NPC_IPPROTO_AH,
+	NPC_IPPROTO_ESP,
 	NPC_SPORT_TCP,
 	NPC_DPORT_TCP,
 	NPC_SPORT_UDP,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d27543c1a166..0c6882e84d42 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1757,6 +1757,7 @@ static void rvu_dbg_npc_mcam_show_flows(struct seq_file *s,
 			seq_printf(s, "mask 0x%x\n", ntohs(rule->mask.dport));
 			break;
 		default:
+			seq_puts(s, "\n");
 			break;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 14832b66d1fe..7572321cea79 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -26,6 +26,11 @@ static const char * const npc_flow_names[] = {
 	[NPC_DIP_IPV4]	= "ipv4 destination ip",
 	[NPC_SIP_IPV6]	= "ipv6 source ip",
 	[NPC_DIP_IPV6]	= "ipv6 destination ip",
+	[NPC_IPPROTO_TCP] = "ip proto tcp",
+	[NPC_IPPROTO_UDP] = "ip proto udp",
+	[NPC_IPPROTO_SCTP] = "ip proto sctp",
+	[NPC_IPPROTO_AH] = "ip proto AH",
+	[NPC_IPPROTO_ESP] = "ip proto ESP",
 	[NPC_SPORT_TCP]	= "tcp source port",
 	[NPC_DPORT_TCP]	= "tcp destination port",
 	[NPC_SPORT_UDP]	= "udp source port",
@@ -212,13 +217,13 @@ static bool npc_check_overlap(struct rvu *rvu, int blkaddr,
 	return false;
 }
 
-static int npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
-			   u8 intf)
+static bool npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
+			    u8 intf)
 {
 	if (!npc_is_field_present(rvu, type, intf) ||
 	    npc_check_overlap(rvu, blkaddr, type, 0, intf))
-		return -EOPNOTSUPP;
-	return 0;
+		return false;
+	return true;
 }
 
 static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
@@ -448,14 +453,13 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u64 *features = &mcam->rx_features;
 	u64 tcp_udp_sctp;
-	int err, hdr;
+	int hdr;
 
 	if (is_npc_intf_tx(intf))
 		features = &mcam->tx_features;
 
 	for (hdr = NPC_DMAC; hdr < NPC_HEADER_FIELDS_MAX; hdr++) {
-		err = npc_check_field(rvu, blkaddr, hdr, intf);
-		if (!err)
+		if (npc_check_field(rvu, blkaddr, hdr, intf))
 			*features |= BIT_ULL(hdr);
 	}
 
@@ -464,13 +468,26 @@ static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
 		       BIT_ULL(NPC_SPORT_SCTP) | BIT_ULL(NPC_DPORT_SCTP);
 
 	/* for tcp/udp/sctp corresponding layer type should be in the key */
-	if (*features & tcp_udp_sctp)
-		if (npc_check_field(rvu, blkaddr, NPC_LD, intf))
+	if (*features & tcp_udp_sctp) {
+		if (!npc_check_field(rvu, blkaddr, NPC_LD, intf))
 			*features &= ~tcp_udp_sctp;
+		else
+			*features |= BIT_ULL(NPC_IPPROTO_TCP) |
+				     BIT_ULL(NPC_IPPROTO_UDP) |
+				     BIT_ULL(NPC_IPPROTO_SCTP);
+	}
+
+	/* for AH, check if corresponding layer type is present in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LD, intf))
+		*features |= BIT_ULL(NPC_IPPROTO_AH);
+
+	/* for ESP, check if corresponding layer type is present in the key */
+	if (npc_check_field(rvu, blkaddr, NPC_LE, intf))
+		*features |= BIT_ULL(NPC_IPPROTO_ESP);
 
 	/* for vlan corresponding layer type should be in the key */
 	if (*features & BIT_ULL(NPC_OUTER_VID))
-		if (npc_check_field(rvu, blkaddr, NPC_LB, intf))
+		if (!npc_check_field(rvu, blkaddr, NPC_LB, intf))
 			*features &= ~BIT_ULL(NPC_OUTER_VID);
 }
 
@@ -743,13 +760,13 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 		return;
 
 	/* For tcp/udp/sctp LTYPE should be present in entry */
-	if (features & (BIT_ULL(NPC_SPORT_TCP) | BIT_ULL(NPC_DPORT_TCP)))
+	if (features & BIT_ULL(NPC_IPPROTO_TCP))
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_TCP,
 				 0, ~0ULL, 0, intf);
-	if (features & (BIT_ULL(NPC_SPORT_UDP) | BIT_ULL(NPC_DPORT_UDP)))
+	if (features & BIT_ULL(NPC_IPPROTO_UDP))
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_UDP,
 				 0, ~0ULL, 0, intf);
-	if (features & (BIT_ULL(NPC_SPORT_SCTP) | BIT_ULL(NPC_DPORT_SCTP)))
+	if (features & BIT_ULL(NPC_IPPROTO_SCTP))
 		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_SCTP,
 				 0, ~0ULL, 0, intf);
 
@@ -758,6 +775,15 @@ static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 				 NPC_LT_LB_STAG_QINQ | NPC_LT_LB_CTAG, 0,
 				 NPC_LT_LB_STAG_QINQ & NPC_LT_LB_CTAG, 0, intf);
 
+	/* For AH, LTYPE should be present in entry */
+	if (features & BIT_ULL(NPC_IPPROTO_AH))
+		npc_update_entry(rvu, NPC_LD, entry, NPC_LT_LD_AH,
+				 0, ~0ULL, 0, intf);
+	/* For ESP, LTYPE should be present in entry */
+	if (features & BIT_ULL(NPC_IPPROTO_ESP))
+		npc_update_entry(rvu, NPC_LE, entry, NPC_LT_LE_ESP,
+				 0, ~0ULL, 0, intf);
+
 #define NPC_WRITE_FLOW(field, member, val_lo, val_hi, mask_lo, mask_hi)	      \
 do {									      \
 	if (features & BIT_ULL((field))) {				      \
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 6dd442d88d0e..d6b5bf247e31 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -272,14 +272,16 @@ int otx2_get_all_flows(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc,
 	return err;
 }
 
-static void otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
-				   struct npc_install_flow_req *req,
-				   u32 flow_type)
+static int otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
+				  struct npc_install_flow_req *req,
+				  u32 flow_type)
 {
 	struct ethtool_usrip4_spec *ipv4_usr_mask = &fsp->m_u.usr_ip4_spec;
 	struct ethtool_usrip4_spec *ipv4_usr_hdr = &fsp->h_u.usr_ip4_spec;
 	struct ethtool_tcpip4_spec *ipv4_l4_mask = &fsp->m_u.tcp_ip4_spec;
 	struct ethtool_tcpip4_spec *ipv4_l4_hdr = &fsp->h_u.tcp_ip4_spec;
+	struct ethtool_ah_espip4_spec *ah_esp_hdr = &fsp->h_u.ah_ip4_spec;
+	struct ethtool_ah_espip4_spec *ah_esp_mask = &fsp->m_u.ah_ip4_spec;
 	struct flow_msg *pmask = &req->mask;
 	struct flow_msg *pkt = &req->packet;
 
@@ -299,10 +301,16 @@ static void otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip4dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV4);
 		}
+		pkt->etype = cpu_to_be16(ETH_P_IP);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
 		break;
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 	case SCTP_V4_FLOW:
+		pkt->etype = cpu_to_be16(ETH_P_IP);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
 		if (ipv4_l4_mask->ip4src) {
 			memcpy(&pkt->ip4src, &ipv4_l4_hdr->ip4src,
 			       sizeof(pkt->ip4src));
@@ -341,20 +349,60 @@ static void otx2_prepare_ipv4_flow(struct ethtool_rx_flow_spec *fsp,
 			else
 				req->features |= BIT_ULL(NPC_DPORT_SCTP);
 		}
+		if (flow_type == UDP_V4_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_UDP);
+		else if (flow_type == TCP_V4_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_TCP);
+		else
+			req->features |= BIT_ULL(NPC_IPPROTO_SCTP);
+		break;
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+		pkt->etype = cpu_to_be16(ETH_P_IP);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
+		if (ah_esp_mask->ip4src) {
+			memcpy(&pkt->ip4src, &ah_esp_hdr->ip4src,
+			       sizeof(pkt->ip4src));
+			memcpy(&pmask->ip4src, &ah_esp_mask->ip4src,
+			       sizeof(pmask->ip4src));
+			req->features |= BIT_ULL(NPC_SIP_IPV4);
+		}
+		if (ah_esp_mask->ip4dst) {
+			memcpy(&pkt->ip4dst, &ah_esp_hdr->ip4dst,
+			       sizeof(pkt->ip4dst));
+			memcpy(&pmask->ip4dst, &ah_esp_mask->ip4dst,
+			       sizeof(pmask->ip4dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV4);
+		}
+
+		/* NPC profile doesn't extract AH/ESP header fields */
+		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
+		    (ah_esp_mask->tos & ah_esp_mask->tos))
+			return -EOPNOTSUPP;
+
+		if (flow_type == AH_V4_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_AH);
+		else
+			req->features |= BIT_ULL(NPC_IPPROTO_ESP);
 		break;
 	default:
 		break;
 	}
+
+	return 0;
 }
 
-static void otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
-				   struct npc_install_flow_req *req,
-				   u32 flow_type)
+static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
+				  struct npc_install_flow_req *req,
+				  u32 flow_type)
 {
 	struct ethtool_usrip6_spec *ipv6_usr_mask = &fsp->m_u.usr_ip6_spec;
 	struct ethtool_usrip6_spec *ipv6_usr_hdr = &fsp->h_u.usr_ip6_spec;
 	struct ethtool_tcpip6_spec *ipv6_l4_mask = &fsp->m_u.tcp_ip6_spec;
 	struct ethtool_tcpip6_spec *ipv6_l4_hdr = &fsp->h_u.tcp_ip6_spec;
+	struct ethtool_ah_espip6_spec *ah_esp_hdr = &fsp->h_u.ah_ip6_spec;
+	struct ethtool_ah_espip6_spec *ah_esp_mask = &fsp->m_u.ah_ip6_spec;
 	struct flow_msg *pmask = &req->mask;
 	struct flow_msg *pkt = &req->packet;
 
@@ -374,10 +422,16 @@ static void otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 			       sizeof(pmask->ip6dst));
 			req->features |= BIT_ULL(NPC_DIP_IPV6);
 		}
+		pkt->etype = cpu_to_be16(ETH_P_IPV6);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
 		break;
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
 	case SCTP_V6_FLOW:
+		pkt->etype = cpu_to_be16(ETH_P_IPV6);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
 		if (!ipv6_addr_any((struct in6_addr *)ipv6_l4_mask->ip6src)) {
 			memcpy(&pkt->ip6src, &ipv6_l4_hdr->ip6src,
 			       sizeof(pkt->ip6src));
@@ -416,10 +470,47 @@ static void otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 			else
 				req->features |= BIT_ULL(NPC_DPORT_SCTP);
 		}
+		if (flow_type == UDP_V6_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_UDP);
+		else if (flow_type == TCP_V6_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_TCP);
+		else
+			req->features |= BIT_ULL(NPC_IPPROTO_SCTP);
 		break;
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+		pkt->etype = cpu_to_be16(ETH_P_IPV6);
+		pmask->etype = cpu_to_be16(0xFFFF);
+		req->features |= BIT_ULL(NPC_ETYPE);
+		if (!ipv6_addr_any((struct in6_addr *)ah_esp_hdr->ip6src)) {
+			memcpy(&pkt->ip6src, &ah_esp_hdr->ip6src,
+			       sizeof(pkt->ip6src));
+			memcpy(&pmask->ip6src, &ah_esp_mask->ip6src,
+			       sizeof(pmask->ip6src));
+			req->features |= BIT_ULL(NPC_SIP_IPV6);
+		}
+		if (!ipv6_addr_any((struct in6_addr *)ah_esp_hdr->ip6dst)) {
+			memcpy(&pkt->ip6dst, &ah_esp_hdr->ip6dst,
+			       sizeof(pkt->ip6dst));
+			memcpy(&pmask->ip6dst, &ah_esp_mask->ip6dst,
+			       sizeof(pmask->ip6dst));
+			req->features |= BIT_ULL(NPC_DIP_IPV6);
+		}
+
+		/* NPC profile doesn't extract AH/ESP header fields */
+		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
+		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
+			return -EOPNOTSUPP;
+
+		if (flow_type == AH_V6_FLOW)
+			req->features |= BIT_ULL(NPC_IPPROTO_AH);
+		else
+			req->features |= BIT_ULL(NPC_IPPROTO_ESP);
 	default:
 		break;
 	}
+
+	return 0;
 }
 
 int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
@@ -430,6 +521,7 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 	struct flow_msg *pmask = &req->mask;
 	struct flow_msg *pkt = &req->packet;
 	u32 flow_type;
+	int ret;
 
 	flow_type = fsp->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
 	switch (flow_type) {
@@ -457,13 +549,21 @@ int otx2_prepare_flow_request(struct ethtool_rx_flow_spec *fsp,
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 	case SCTP_V4_FLOW:
-		otx2_prepare_ipv4_flow(fsp, req, flow_type);
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+		ret = otx2_prepare_ipv4_flow(fsp, req, flow_type);
+		if (ret)
+			return ret;
 		break;
 	case IPV6_USER_FLOW:
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
 	case SCTP_V6_FLOW:
-		otx2_prepare_ipv6_flow(fsp, req, flow_type);
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+		ret = otx2_prepare_ipv6_flow(fsp, req, flow_type);
+		if (ret)
+			return ret;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.16.5

