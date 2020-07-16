Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D07222205
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgGPL5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:57:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17408 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728500AbgGPLz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:55:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBp71h006965;
        Thu, 16 Jul 2020 04:55:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=gqHzddxXNL1kLeB7UxsH/ZDxivMxLXQstkcfoKf/b78=;
 b=l452QEXYo27ZTpGWJcrNiG2/jVZYBVqG1Da0qCJicyQIv3YoxElEnba2LVyriuG2BHl2
 4muwjJg7iT/onykSWCNImUMq5LOHSSiCE+PL2u1NiGX2Ybg0JIor7F29JZWfCUfw9xoe
 qWWZ6WX/Wxi6qL6kmrRUiXUHdovCbONL10wNC7xEZA+P26uYaCZy12XOz87429uTyJvC
 VAF2ObwL43WBjsXDFMy8plpogpXXz5VRtyPT7aV7+Kne38M2Oc3ncFU4GrJDSN8XDpKC
 6JtOYutoT8Ia/DRu9Avkbrejf0BBqW1DdCdG8cQAzTls3dHnzLGna6eUaE00xvQtCKWN sg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhyg15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:55:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:55:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:55:49 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C00153F703F;
        Thu, 16 Jul 2020 04:55:45 -0700 (PDT)
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
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 03/13] qed: add support for multi-rate transceivers
Date:   Thu, 16 Jul 2020 14:54:36 +0300
Message-ID: <20200716115446.994-4-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716115446.994-1-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
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
 drivers/net/ethernet/qlogic/qed/qed_main.c | 112 ++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  |   9 +-
 3 files changed, 98 insertions(+), 27 deletions(-)

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
index 8a0b8da19547..9df27c3f5cab 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1695,21 +1695,38 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			__set_bit(QED_LM_20000baseKR2_Full, if_caps);
 
-		/* For DAC media multiple speed capabilities are supported*/
-		capability = capability & speed_mask;
+		/* For DAC media multiple speed capabilities are supported */
+		capability |= speed_mask;
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
 			__set_bit(QED_LM_1000baseKX_Full, if_caps);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
 			__set_bit(QED_LM_10000baseCR_Full, if_caps);
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
-			__set_bit(QED_LM_40000baseCR4_Full, if_caps);
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_40G_CR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_CR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR:
+				__set_bit(QED_LM_40000baseCR4_Full, if_caps);
+			default:
+				break;
+			}
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
 			__set_bit(QED_LM_25000baseCR_Full, if_caps);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
 			__set_bit(QED_LM_50000baseCR2_Full, if_caps);
+
 		if (capability &
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
-			__set_bit(QED_LM_100000baseCR4_Full, if_caps);
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_100G_CR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_CR:
+				__set_bit(QED_LM_100000baseCR4_Full, if_caps);
+			default:
+				break;
+			}
 
 		break;
 	case MEDIA_BASE_T:
@@ -1727,10 +1744,15 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_MODULE) {
 			__set_bit(QED_LM_FIBRE, if_caps);
 
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_1000BASET)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_1000BASET:
 				__set_bit(QED_LM_1000baseT_Full, if_caps);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_BASET)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_BASET:
 				__set_bit(QED_LM_10000baseT_Full, if_caps);
+			default:
+				break;
+			}
 		}
 
 		break;
@@ -1739,47 +1761,85 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 	case MEDIA_XFP_FIBER:
 	case MEDIA_MODULE_FIBER:
 		__set_bit(QED_LM_FIBRE, if_caps);
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
 				__set_bit(QED_LM_1000baseKX_Full, if_caps);
-		}
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
 				__set_bit(QED_LM_10000baseSR_Full, if_caps);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LR)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_LR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_1G_10G_LR:
 				__set_bit(QED_LM_10000baseLR_Full, if_caps);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LRM)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_LRM:
 				__set_bit(QED_LM_10000baseLRM_Full, if_caps);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_ER)
+				break;
+			case ETH_TRANSCEIVER_TYPE_10G_ER:
 				__set_bit(QED_LM_10000baseR_FEC, if_caps);
-		}
+			default:
+				break;
+			}
 
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
 			__set_bit(QED_LM_20000baseKR2_Full, if_caps);
 
-		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_25G_SR)
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_25G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_25G_SR:
 				__set_bit(QED_LM_25000baseSR_Full, if_caps);
-		}
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
 				__set_bit(QED_LM_40000baseLR4_Full, if_caps);
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_40G_SR4)
+				break;
+			case ETH_TRANSCEIVER_TYPE_40G_SR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_10G_40G_SR:
 				__set_bit(QED_LM_40000baseSR4_Full, if_caps);
-		}
+			default:
+				break;
+			}
 
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
 			__set_bit(QED_LM_50000baseKR2_Full, if_caps);
 
 		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G) {
-			if (tcvr_type == ETH_TRANSCEIVER_TYPE_100G_SR4)
+		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
+			switch (tcvr_type) {
+			case ETH_TRANSCEIVER_TYPE_100G_SR4:
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_SR:
 				__set_bit(QED_LM_100000baseSR4_Full, if_caps);
-		}
+				break;
+			case ETH_TRANSCEIVER_TYPE_MULTI_RATE_40G_100G_LR:
+				__set_bit(QED_LM_100000baseLR4_ER4_Full,
+					  if_caps);
+			default:
+				break;
+			}
 
 		break;
 	case MEDIA_KR:
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

