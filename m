Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73203226DD6
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbgGTSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46756 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389231AbgGTSJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqY0024232;
        Mon, 20 Jul 2020 11:09:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=4x0qnhnyjI1ReFYZDxavXJ+kauVBzgPvBR3pYJ+QhP0=;
 b=gLf2JRgijZdGv8r1DUOUQ84Ll0gMpt3yBBvpAJ8hJU13s7C3QwPRH/LgYvL46zk8xLTS
 lHHFR9Z9vpq07DNE7U+S1OexV5LF5KlPWZPSyCxgq2ebXInSZdVlY65UiNBIw2vtgbUx
 YGfvFD+nT8rgvoxUXjWrebFG+Pfx4WWIwuduhx5wBPLC/QEeKf22wd6u5U7Xc3W2YbSU
 ZRoq48QLoQ/ehDM4u+uYK2GC+xHcYf/pTPfwpMTXeUChsQ3dh8tKT8d1cOjUnZOeDsXz
 kQwMscyrp+/m/0R6poo2YdPIW/uS+gp6wqAEr+ENIqwCud/nlJMvS5hb6R5eOOzewjsM +w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:10 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 4AF7E3F703F;
        Mon, 20 Jul 2020 11:09:06 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 05/16] qed: add support for multi-rate transceivers
Date:   Mon, 20 Jul 2020 21:08:04 +0300
Message-ID: <20200720180815.107-6-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the corresponding advertised and supported link modes according
to the detected transceiver type and device capabilities.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h  |   4 +
 drivers/net/ethernet/qlogic/qed/qed_main.c | 120 ++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  |   9 +-
 3 files changed, 106 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 0d0a109d94b4..ebc25b34e491 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -12027,6 +12027,10 @@ struct public_port {
 #define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR	0x34
 #define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR	0x35
 #define ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_AOC	0x36
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_SR	0x37
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_LR	0x38
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_SR	0x39
+#define ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_LR	0x3a
 
 	u32 wol_info;
 	u32 wol_pkt_len;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index afc4fa3bdcaa..172a107f9299 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1696,21 +1696,40 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			phylink_set(if_caps, 20000baseKR2_Full);
 
-		/* For DAC media multiple speed capabilities are supported*/
-		capability = capability & speed_mask;
+		/* For DAC media multiple speed capabilities are supported */
+		capability |= speed_mask;
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
 			phylink_set(if_caps, 1000baseKX_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
 			phylink_set(if_caps, 10000baseCR_Full);
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
-			phylink_set(if_caps, 40000baseCR4_Full);
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_40G_CR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_CR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR:
+				phylink_set(if_caps, 40000baseCR4_Full);
+				break;
+			default:
+				break;
+			}
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
 			phylink_set(if_caps, 25000baseCR_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
 			phylink_set(if_caps, 50000baseCR2_Full);
+
 		if (capability &
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
-			phylink_set(if_caps, 100000baseCR4_Full);
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_100G_CR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR:
+				phylink_set(if_caps, 100000baseCR4_Full);
+				break;
+			default:
+				break;
+			}
 
 		break;
 	case MEDIA_BASE_T:
@@ -1728,10 +1747,16 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_MODULE) {
 			phylink_set(if_caps, FIBRE);
 
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_1000BASET)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_1000BASET:
 				phylink_set(if_caps, 1000baseT_Full);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_BASET)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_BASET:
 				phylink_set(if_caps, 10000baseT_Full);
+				break;
+			default:
+				break;
+			}
 		}
 
 		break;
@@ -1740,47 +1765,89 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 	case MEDIA_XFP_FIBER:
 	case MEDIA_MODULE_FIBER:
 		phylink_set(if_caps, FIBRE);
+		capability |= speed_mask;
 
-		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
-			if ((tcvr_type == ETH_TRANSCEIVER_TYPE_1G_LX) ||
-			    (tcvr_type == ETH_TRANSCEIVER_TYPE_1G_SX))
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_1G_LX:
+			case ETH_TRANSCEIVER_TYPE_1G_SX:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_LR:
 				phylink_set(if_caps, 1000baseKX_Full);
-		}
+				break;
+			default:
+				break;
+			}
 
-		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_SR)
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_10G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_SR:
 				phylink_set(if_caps, 10000baseSR_Full);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LR)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_LR:
 				phylink_set(if_caps, 10000baseLR_Full);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LRM)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_LRM:
 				phylink_set(if_caps, 10000baseLRM_Full);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_ER)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_ER:
 				phylink_set(if_caps, 10000baseR_FEC);
-		}
+				break;
+			default:
+				break;
+			}
 
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			phylink_set(if_caps, 20000baseKR2_Full);
 
-		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_25G_SR)
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_25G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_SR:
 				phylink_set(if_caps, 25000baseSR_Full);
-		}
+				break;
+			default:
+				break;
+			}
 
-		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_40G_LR4)
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_40G_LR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR:
 				phylink_set(if_caps, 40000baseLR4_Full);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_40G_SR4)
+				break;
+			case ETH_TRANSCEIVER_TYPE_40G_SR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_SR:
 				phylink_set(if_caps, 40000baseSR4_Full);
-		}
+				break;
+			default:
+				break;
+			}
 
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
 			phylink_set(if_caps, 50000baseKR2_Full);
 
 		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_100G_SR4)
+		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_100G_SR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR:
 				phylink_set(if_caps, 100000baseSR4_Full);
-		}
+				break;
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR:
+				phylink_set(if_caps, 100000baseLR4_ER4_Full);
+				break;
+			default:
+				break;
+			}
 
 		break;
 	case MEDIA_KR:
@@ -1805,6 +1872,7 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 		break;
 	case MEDIA_UNSPECIFIED:
 	case MEDIA_NOT_PRESENT:
+	default:
 		DP_VERBOSE(hwfn->cdev, QED_MSG_DEBUG,
 			   "Unknown media and transceiver type;\n");
 		break;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 2d12bb27560c..b10a92488630 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -2193,6 +2193,11 @@ int qed_mcp_trans_speed_mask(struct qed_hwfn *p_hwfn,
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G |
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
 		break;
+	case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_SR:
+	case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_LR:
+		*p_speed_mask = NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G |
+				NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
+		break;
 	case ETH_TRANSCEIVER_TYPE_40G_CR4:
 	case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_CR:
 		*p_speed_mask = NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G |
@@ -2223,8 +2228,10 @@ int qed_mcp_trans_speed_mask(struct qed_hwfn *p_hwfn,
 		*p_speed_mask = NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
 		break;
 	case ETH_TRANSCEIVER_TYPE_10G_BASET:
+	case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_SR:
+	case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_LR:
 		*p_speed_mask = NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G |
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
+				NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
 		break;
 	default:
 		DP_INFO(p_hwfn, "Unknown transceiver type 0x%x\n",
-- 
2.25.1

