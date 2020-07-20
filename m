Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2D226E00
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389252AbgGTSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:10:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731171AbgGTSJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqtE024216;
        Mon, 20 Jul 2020 11:09:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=hSsXK4bxMvd3qNlQMElYnmoEd2LDlecuSpKzLJJ3PeE=;
 b=QSOgLo+/P8KJHXeRdcn71BG/UygSUMIpihoDzOwXH+xO03JaBaqQUiAlgAbCaCr4UTh2
 yoIto4Uo7Alz4LzC1QIPZ9kFTjTe5u8AM5dXR5/W/7hkddincXXX3RxRM4kT1pmsWOOz
 PS+pabUUPuOuDasnPAsiJjh5w63U7hoADkrRN4qoCzVl7P5b23tmmqpq/vfLJDKAoLLU
 eshh8m8xVf/pmpjlAh83FOixFGSdKN9QwFMPl2EgL0ighmwLz1sSXtDD2i/cRNRNuj3/
 ZDIJ//qB2ZbZTq6TgSmhTWVmTTpNxmlQPNbT1/SyugN38E1bnD14Q61JHN4nDfAN/kQJ Xw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:08:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:08:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:08:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:08:56 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 1A1CC3F703F;
        Mon, 20 Jul 2020 11:08:51 -0700 (PDT)
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
Subject: [PATCH v3 net-next 02/16] qed, qede, qedf: convert link mode from u32 to ETHTOOL_LINK_MODE
Date:   Mon, 20 Jul 2020 21:08:01 +0300
Message-ID: <20200720180815.107-3-alobakin@marvell.com>
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

Currently qed driver already ran out of 32 bits to store link modes,
and this doesn't allow to add and support more speeds.
Convert custom link mode to generic Ethtool bitmap and definitions
(convenient Phylink shorthands are used for elegance and readability).
This allowed us to drop all conversions/mappings between the driver
and Ethtool.

This involves changes in qede and qedf as well, as they used definitions
from shared "qed_if.h".

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 288 ++++++++++--------
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 200 ++++--------
 drivers/scsi/qedf/qedf_main.c                 |  78 +++--
 include/linux/qed/qed_if.h                    |  47 +--
 4 files changed, 268 insertions(+), 345 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 4c5f5bd91359..afc4fa3bdcaa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -24,6 +24,7 @@
 #include <linux/qed/qed_ll2_if.h>
 #include <net/devlink.h>
 #include <linux/aer.h>
+#include <linux/phylink.h>
 
 #include "qed.h"
 #include "qed_sriov.h"
@@ -1456,10 +1457,11 @@ static bool qed_can_link_change(struct qed_dev *cdev)
 
 static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 {
-	struct qed_hwfn *hwfn;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sup_caps);
 	struct qed_mcp_link_params *link_params;
+	struct qed_hwfn *hwfn;
 	struct qed_ptt *ptt;
-	u32 sup_caps;
+	u32 as;
 	int rc;
 
 	if (!cdev)
@@ -1482,57 +1484,79 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 		return -EBUSY;
 
 	link_params = qed_mcp_get_link_params(hwfn);
+	if (!link_params)
+		return -ENODATA;
+
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_AUTONEG)
 		link_params->speed.autoneg = params->autoneg;
+
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_ADV_SPEEDS) {
-		link_params->speed.advertised_speeds = 0;
-		sup_caps = QED_LM_1000baseT_Full_BIT |
-			   QED_LM_1000baseKX_Full_BIT |
-			   QED_LM_1000baseX_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
-		sup_caps = QED_LM_10000baseT_Full_BIT |
-			   QED_LM_10000baseKR_Full_BIT |
-			   QED_LM_10000baseKX4_Full_BIT |
-			   QED_LM_10000baseR_FEC_BIT |
-			   QED_LM_10000baseCR_Full_BIT |
-			   QED_LM_10000baseSR_Full_BIT |
-			   QED_LM_10000baseLR_Full_BIT |
-			   QED_LM_10000baseLRM_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
-		if (params->adv_speeds & QED_LM_20000baseKR2_Full_BIT)
-			link_params->speed.advertised_speeds |=
-				NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G;
-		sup_caps = QED_LM_25000baseKR_Full_BIT |
-			   QED_LM_25000baseCR_Full_BIT |
-			   QED_LM_25000baseSR_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G;
-		sup_caps = QED_LM_40000baseLR4_Full_BIT |
-			   QED_LM_40000baseKR4_Full_BIT |
-			   QED_LM_40000baseCR4_Full_BIT |
-			   QED_LM_40000baseSR4_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-				NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
-		sup_caps = QED_LM_50000baseKR2_Full_BIT |
-			   QED_LM_50000baseCR2_Full_BIT |
-			   QED_LM_50000baseSR2_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G;
-		sup_caps = QED_LM_100000baseKR4_Full_BIT |
-			   QED_LM_100000baseSR4_Full_BIT |
-			   QED_LM_100000baseCR4_Full_BIT |
-			   QED_LM_100000baseLR4_ER4_Full_BIT;
-		if (params->adv_speeds & sup_caps)
-			link_params->speed.advertised_speeds |=
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G;
+		as = 0;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 1000baseT_Full);
+		phylink_set(sup_caps, 1000baseKX_Full);
+		phylink_set(sup_caps, 1000baseX_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 10000baseT_Full);
+		phylink_set(sup_caps, 10000baseKR_Full);
+		phylink_set(sup_caps, 10000baseKX4_Full);
+		phylink_set(sup_caps, 10000baseR_FEC);
+		phylink_set(sup_caps, 10000baseCR_Full);
+		phylink_set(sup_caps, 10000baseSR_Full);
+		phylink_set(sup_caps, 10000baseLR_Full);
+		phylink_set(sup_caps, 10000baseLRM_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 20000baseKR2_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 25000baseKR_Full);
+		phylink_set(sup_caps, 25000baseCR_Full);
+		phylink_set(sup_caps, 25000baseSR_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 40000baseLR4_Full);
+		phylink_set(sup_caps, 40000baseKR4_Full);
+		phylink_set(sup_caps, 40000baseCR4_Full);
+		phylink_set(sup_caps, 40000baseSR4_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 50000baseKR2_Full);
+		phylink_set(sup_caps, 50000baseCR2_Full);
+		phylink_set(sup_caps, 50000baseSR2_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G;
+
+		phylink_zero(sup_caps);
+		phylink_set(sup_caps, 100000baseKR4_Full);
+		phylink_set(sup_caps, 100000baseSR4_Full);
+		phylink_set(sup_caps, 100000baseCR4_Full);
+		phylink_set(sup_caps, 100000baseLR4_ER4_Full);
+
+		if (linkmode_intersects(params->adv_speeds, sup_caps))
+			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G;
+
+		link_params->speed.advertised_speeds = as;
 	}
+
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_FORCED_SPEED)
 		link_params->speed.forced_speed = params->forced_speed;
 	if (params->override_flags & QED_LINK_OVERRIDE_PAUSE_CONFIG) {
@@ -1644,7 +1668,7 @@ static int qed_get_link_data(struct qed_hwfn *hwfn,
 
 static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 				     struct qed_ptt *ptt, u32 capability,
-				     u32 *if_capability)
+				     unsigned long *if_caps)
 {
 	u32 media_type, tcvr_state, tcvr_type;
 	u32 speed_mask, board_cfg;
@@ -1667,113 +1691,117 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 
 	switch (media_type) {
 	case MEDIA_DA_TWINAX:
-		*if_capability |= QED_LM_FIBRE_BIT;
+		phylink_set(if_caps, FIBRE);
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
-			*if_capability |= QED_LM_20000baseKR2_Full_BIT;
+			phylink_set(if_caps, 20000baseKR2_Full);
+
 		/* For DAC media multiple speed capabilities are supported*/
 		capability = capability & speed_mask;
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
-			*if_capability |= QED_LM_1000baseKX_Full_BIT;
+			phylink_set(if_caps, 1000baseKX_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
-			*if_capability |= QED_LM_10000baseCR_Full_BIT;
+			phylink_set(if_caps, 10000baseCR_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
-			*if_capability |= QED_LM_40000baseCR4_Full_BIT;
+			phylink_set(if_caps, 40000baseCR4_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
-			*if_capability |= QED_LM_25000baseCR_Full_BIT;
+			phylink_set(if_caps, 25000baseCR_Full);
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
-			*if_capability |= QED_LM_50000baseCR2_Full_BIT;
+			phylink_set(if_caps, 50000baseCR2_Full);
 		if (capability &
-			NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
-			*if_capability |= QED_LM_100000baseCR4_Full_BIT;
+		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
+			phylink_set(if_caps, 100000baseCR4_Full);
+
 		break;
 	case MEDIA_BASE_T:
-		*if_capability |= QED_LM_TP_BIT;
+		phylink_set(if_caps, TP);
+
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_EXT_PHY) {
 			if (capability &
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
-				*if_capability |= QED_LM_1000baseT_Full_BIT;
-			}
+			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
+				phylink_set(if_caps, 1000baseT_Full);
 			if (capability &
-			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G) {
-				*if_capability |= QED_LM_10000baseT_Full_BIT;
-			}
+			    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
+				phylink_set(if_caps, 10000baseT_Full);
 		}
+
 		if (board_cfg & NVM_CFG1_PORT_PORT_TYPE_MODULE) {
-			*if_capability |= QED_LM_FIBRE_BIT;
+			phylink_set(if_caps, FIBRE);
+
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_1000BASET)
-				*if_capability |= QED_LM_1000baseT_Full_BIT;
+				phylink_set(if_caps, 1000baseT_Full);
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_BASET)
-				*if_capability |= QED_LM_10000baseT_Full_BIT;
+				phylink_set(if_caps, 10000baseT_Full);
 		}
+
 		break;
 	case MEDIA_SFP_1G_FIBER:
 	case MEDIA_SFPP_10G_FIBER:
 	case MEDIA_XFP_FIBER:
 	case MEDIA_MODULE_FIBER:
-		*if_capability |= QED_LM_FIBRE_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
+		phylink_set(if_caps, FIBRE);
+
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G) {
 			if ((tcvr_type == ETH_TRANSCEIVER_TYPE_1G_LX) ||
 			    (tcvr_type == ETH_TRANSCEIVER_TYPE_1G_SX))
-				*if_capability |= QED_LM_1000baseKX_Full_BIT;
+				phylink_set(if_caps, 1000baseKX_Full);
 		}
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G) {
+
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G) {
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_SR)
-				*if_capability |= QED_LM_10000baseSR_Full_BIT;
+				phylink_set(if_caps, 10000baseSR_Full);
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LR)
-				*if_capability |= QED_LM_10000baseLR_Full_BIT;
+				phylink_set(if_caps, 10000baseLR_Full);
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_LRM)
-				*if_capability |= QED_LM_10000baseLRM_Full_BIT;
+				phylink_set(if_caps, 10000baseLRM_Full);
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_10G_ER)
-				*if_capability |= QED_LM_10000baseR_FEC_BIT;
+				phylink_set(if_caps, 10000baseR_FEC);
 		}
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
-			*if_capability |= QED_LM_20000baseKR2_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G) {
+			phylink_set(if_caps, 20000baseKR2_Full);
+
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G) {
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_25G_SR)
-				*if_capability |= QED_LM_25000baseSR_Full_BIT;
+				phylink_set(if_caps, 25000baseSR_Full);
 		}
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G) {
+
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G) {
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_40G_LR4)
-				*if_capability |= QED_LM_40000baseLR4_Full_BIT;
+				phylink_set(if_caps, 40000baseLR4_Full);
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_40G_SR4)
-				*if_capability |= QED_LM_40000baseSR4_Full_BIT;
+				phylink_set(if_caps, 40000baseSR4_Full);
 		}
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
-			*if_capability |= QED_LM_50000baseKR2_Full_BIT;
+
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
+			phylink_set(if_caps, 50000baseKR2_Full);
+
 		if (capability &
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G) {
 			if (tcvr_type == ETH_TRANSCEIVER_TYPE_100G_SR4)
-				*if_capability |= QED_LM_100000baseSR4_Full_BIT;
+				phylink_set(if_caps, 100000baseSR4_Full);
 		}
 
 		break;
 	case MEDIA_KR:
-		*if_capability |= QED_LM_Backplane_BIT;
+		phylink_set(if_caps, Backplane);
+
 		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G)
-			*if_capability |= QED_LM_20000baseKR2_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
-			*if_capability |= QED_LM_1000baseKX_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
-			*if_capability |= QED_LM_10000baseKR_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
-			*if_capability |= QED_LM_25000baseKR_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
-			*if_capability |= QED_LM_40000baseKR4_Full_BIT;
-		if (capability &
-		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
-			*if_capability |= QED_LM_50000baseKR2_Full_BIT;
+			phylink_set(if_caps, 20000baseKR2_Full);
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G)
+			phylink_set(if_caps, 1000baseKX_Full);
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G)
+			phylink_set(if_caps, 10000baseKR_Full);
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G)
+			phylink_set(if_caps, 25000baseKR_Full);
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G)
+			phylink_set(if_caps, 40000baseKR4_Full);
+		if (capability & NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G)
+			phylink_set(if_caps, 50000baseKR2_Full);
 		if (capability &
 		    NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G)
-			*if_capability |= QED_LM_100000baseKR4_Full_BIT;
+			phylink_set(if_caps, 100000baseKR4_Full);
+
 		break;
 	case MEDIA_UNSPECIFIED:
 	case MEDIA_NOT_PRESENT:
@@ -1806,26 +1834,27 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 
 	/* TODO - at the moment assume supported and advertised speed equal */
 	if (link_caps.default_speed_autoneg)
-		if_link->supported_caps |= QED_LM_Autoneg_BIT;
+		phylink_set(if_link->supported_caps, Autoneg);
 	if (params.pause.autoneg ||
 	    (params.pause.forced_rx && params.pause.forced_tx))
-		if_link->supported_caps |= QED_LM_Asym_Pause_BIT;
+		phylink_set(if_link->supported_caps, Asym_Pause);
 	if (params.pause.autoneg || params.pause.forced_rx ||
 	    params.pause.forced_tx)
-		if_link->supported_caps |= QED_LM_Pause_BIT;
+		phylink_set(if_link->supported_caps, Pause);
+
+	linkmode_copy(if_link->advertised_caps, if_link->supported_caps);
 
-	if_link->advertised_caps = if_link->supported_caps;
 	if (params.speed.autoneg)
-		if_link->advertised_caps |= QED_LM_Autoneg_BIT;
+		phylink_set(if_link->advertised_caps, Autoneg);
 	else
-		if_link->advertised_caps &= ~QED_LM_Autoneg_BIT;
+		phylink_clear(if_link->advertised_caps, Autoneg);
 
 	/* Fill link advertised capability*/
 	qed_fill_link_capability(hwfn, ptt, params.speed.advertised_speeds,
-				 &if_link->advertised_caps);
+				 if_link->advertised_caps);
 	/* Fill link supported capability*/
 	qed_fill_link_capability(hwfn, ptt, link_caps.speed_capabilities,
-				 &if_link->supported_caps);
+				 if_link->supported_caps);
 
 	if (link.link_up)
 		if_link->speed = link.speed;
@@ -1845,30 +1874,29 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 		if_link->pause_config |= QED_LINK_PAUSE_TX_ENABLE;
 
 	/* Link partner capabilities */
-	if (link.partner_adv_speed &
-	    QED_LINK_PARTNER_SPEED_1G_FD)
-		if_link->lp_caps |= QED_LM_1000baseT_Full_BIT;
+
+	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_1G_FD)
+		phylink_set(if_link->lp_caps, 1000baseT_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_10G)
-		if_link->lp_caps |= QED_LM_10000baseKR_Full_BIT;
+		phylink_set(if_link->lp_caps, 10000baseKR_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_20G)
-		if_link->lp_caps |= QED_LM_20000baseKR2_Full_BIT;
+		phylink_set(if_link->lp_caps, 20000baseKR2_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_25G)
-		if_link->lp_caps |= QED_LM_25000baseKR_Full_BIT;
+		phylink_set(if_link->lp_caps, 25000baseKR_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_40G)
-		if_link->lp_caps |= QED_LM_40000baseLR4_Full_BIT;
+		phylink_set(if_link->lp_caps, 40000baseLR4_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_50G)
-		if_link->lp_caps |= QED_LM_50000baseKR2_Full_BIT;
+		phylink_set(if_link->lp_caps, 50000baseKR2_Full);
 	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_100G)
-		if_link->lp_caps |= QED_LM_100000baseKR4_Full_BIT;
+		phylink_set(if_link->lp_caps, 100000baseKR4_Full);
 
 	if (link.an_complete)
-		if_link->lp_caps |= QED_LM_Autoneg_BIT;
-
+		phylink_set(if_link->lp_caps, Autoneg);
 	if (link.partner_adv_pause)
-		if_link->lp_caps |= QED_LM_Pause_BIT;
+		phylink_set(if_link->lp_caps, Pause);
 	if (link.partner_adv_pause == QED_LINK_PARTNER_ASYMMETRIC_PAUSE ||
 	    link.partner_adv_pause == QED_LINK_PARTNER_BOTH_PAUSE)
-		if_link->lp_caps |= QED_LM_Asym_Pause_BIT;
+		phylink_set(if_link->lp_caps, Asym_Pause);
 
 	if (link_caps.default_eee == QED_MCP_EEE_UNSUPPORTED) {
 		if_link->eee_supported = false;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index d3fc7403d095..0a564b06d697 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -13,6 +13,8 @@
 #include <linux/pci.h>
 #include <linux/capability.h>
 #include <linux/vmalloc.h>
+#include <linux/phylink.h>
+
 #include "qede.h"
 #include "qede_ptp.h"
 
@@ -418,76 +420,10 @@ static int qede_set_priv_flags(struct net_device *dev, u32 flags)
 	return 0;
 }
 
-struct qede_link_mode_mapping {
-	u32 qed_link_mode;
-	u32 ethtool_link_mode;
-};
-
-static const struct qede_link_mode_mapping qed_lm_map[] = {
-	{QED_LM_FIBRE_BIT, ETHTOOL_LINK_MODE_FIBRE_BIT},
-	{QED_LM_Autoneg_BIT, ETHTOOL_LINK_MODE_Autoneg_BIT},
-	{QED_LM_Asym_Pause_BIT, ETHTOOL_LINK_MODE_Asym_Pause_BIT},
-	{QED_LM_Pause_BIT, ETHTOOL_LINK_MODE_Pause_BIT},
-	{QED_LM_1000baseT_Full_BIT, ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
-	{QED_LM_10000baseT_Full_BIT, ETHTOOL_LINK_MODE_10000baseT_Full_BIT},
-	{QED_LM_TP_BIT, ETHTOOL_LINK_MODE_TP_BIT},
-	{QED_LM_Backplane_BIT, ETHTOOL_LINK_MODE_Backplane_BIT},
-	{QED_LM_1000baseKX_Full_BIT, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT},
-	{QED_LM_10000baseKX4_Full_BIT, ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT},
-	{QED_LM_10000baseKR_Full_BIT, ETHTOOL_LINK_MODE_10000baseKR_Full_BIT},
-	{QED_LM_10000baseKR_Full_BIT, ETHTOOL_LINK_MODE_10000baseKR_Full_BIT},
-	{QED_LM_10000baseR_FEC_BIT, ETHTOOL_LINK_MODE_10000baseR_FEC_BIT},
-	{QED_LM_20000baseKR2_Full_BIT, ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT},
-	{QED_LM_40000baseKR4_Full_BIT, ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT},
-	{QED_LM_40000baseCR4_Full_BIT, ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT},
-	{QED_LM_40000baseSR4_Full_BIT, ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT},
-	{QED_LM_40000baseLR4_Full_BIT, ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT},
-	{QED_LM_25000baseCR_Full_BIT, ETHTOOL_LINK_MODE_25000baseCR_Full_BIT},
-	{QED_LM_25000baseKR_Full_BIT, ETHTOOL_LINK_MODE_25000baseKR_Full_BIT},
-	{QED_LM_25000baseSR_Full_BIT, ETHTOOL_LINK_MODE_25000baseSR_Full_BIT},
-	{QED_LM_50000baseCR2_Full_BIT, ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT},
-	{QED_LM_50000baseKR2_Full_BIT, ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT},
-	{QED_LM_100000baseKR4_Full_BIT,
-		ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT},
-	{QED_LM_100000baseSR4_Full_BIT,
-		ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT},
-	{QED_LM_100000baseCR4_Full_BIT,
-		ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT},
-	{QED_LM_100000baseLR4_ER4_Full_BIT,
-		ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT},
-	{QED_LM_50000baseSR2_Full_BIT, ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT},
-	{QED_LM_1000baseX_Full_BIT, ETHTOOL_LINK_MODE_1000baseX_Full_BIT},
-	{QED_LM_10000baseCR_Full_BIT, ETHTOOL_LINK_MODE_10000baseCR_Full_BIT},
-	{QED_LM_10000baseSR_Full_BIT, ETHTOOL_LINK_MODE_10000baseSR_Full_BIT},
-	{QED_LM_10000baseLR_Full_BIT, ETHTOOL_LINK_MODE_10000baseLR_Full_BIT},
-	{QED_LM_10000baseLRM_Full_BIT, ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT},
-};
-
-#define QEDE_DRV_TO_ETHTOOL_CAPS(caps, lk_ksettings, name)	\
-{								\
-	int i;							\
-								\
-	for (i = 0; i < ARRAY_SIZE(qed_lm_map); i++) {		\
-		if ((caps) & (qed_lm_map[i].qed_link_mode))	\
-			__set_bit(qed_lm_map[i].ethtool_link_mode,\
-				  lk_ksettings->link_modes.name); \
-	}							\
-}
-
-#define QEDE_ETHTOOL_TO_DRV_CAPS(caps, lk_ksettings, name)	\
-{								\
-	int i;							\
-								\
-	for (i = 0; i < ARRAY_SIZE(qed_lm_map); i++) {		\
-		if (test_bit(qed_lm_map[i].ethtool_link_mode,	\
-			     lk_ksettings->link_modes.name))	\
-			caps |= qed_lm_map[i].qed_link_mode;	\
-	}							\
-}
-
 static int qede_get_link_ksettings(struct net_device *dev,
 				   struct ethtool_link_ksettings *cmd)
 {
+	typeof(cmd->link_modes) *link_modes = &cmd->link_modes;
 	struct ethtool_link_settings *base = &cmd->base;
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qed_link_output current_link;
@@ -497,14 +433,9 @@ static int qede_get_link_ksettings(struct net_device *dev,
 	memset(&current_link, 0, sizeof(current_link));
 	edev->ops->common->get_link(edev->cdev, &current_link);
 
-	ethtool_link_ksettings_zero_link_mode(cmd, supported);
-	QEDE_DRV_TO_ETHTOOL_CAPS(current_link.supported_caps, cmd, supported)
-
-	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
-	QEDE_DRV_TO_ETHTOOL_CAPS(current_link.advertised_caps, cmd, advertising)
-
-	ethtool_link_ksettings_zero_link_mode(cmd, lp_advertising);
-	QEDE_DRV_TO_ETHTOOL_CAPS(current_link.lp_caps, cmd, lp_advertising)
+	linkmode_copy(link_modes->supported, current_link.supported_caps);
+	linkmode_copy(link_modes->advertising, current_link.advertised_caps);
+	linkmode_copy(link_modes->lp_advertising, current_link.lp_caps);
 
 	if ((edev->state == QEDE_STATE_OPEN) && (current_link.link_up)) {
 		base->speed = current_link.speed;
@@ -527,10 +458,10 @@ static int qede_set_link_ksettings(struct net_device *dev,
 				   const struct ethtool_link_ksettings *cmd)
 {
 	const struct ethtool_link_settings *base = &cmd->base;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sup_caps);
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qed_link_output current_link;
 	struct qed_link_params params;
-	u32 sup_caps;
 
 	if (!edev->ops || !edev->ops->common->can_link_change(edev->cdev)) {
 		DP_INFO(edev, "Link settings are not allowed to be changed\n");
@@ -542,105 +473,79 @@ static int qede_set_link_ksettings(struct net_device *dev,
 
 	params.override_flags |= QED_LINK_OVERRIDE_SPEED_ADV_SPEEDS;
 	params.override_flags |= QED_LINK_OVERRIDE_SPEED_AUTONEG;
+
 	if (base->autoneg == AUTONEG_ENABLE) {
-		if (!(current_link.supported_caps & QED_LM_Autoneg_BIT)) {
+		if (!phylink_test(current_link.supported_caps, Autoneg)) {
 			DP_INFO(edev, "Auto negotiation is not supported\n");
 			return -EOPNOTSUPP;
 		}
 
 		params.autoneg = true;
 		params.forced_speed = 0;
-		QEDE_ETHTOOL_TO_DRV_CAPS(params.adv_speeds, cmd, advertising)
+
+		linkmode_copy(params.adv_speeds, cmd->link_modes.advertising);
 	} else {		/* forced speed */
 		params.override_flags |= QED_LINK_OVERRIDE_SPEED_FORCED_SPEED;
 		params.autoneg = false;
 		params.forced_speed = base->speed;
+
+		phylink_zero(sup_caps);
+
 		switch (base->speed) {
 		case SPEED_1000:
-			sup_caps = QED_LM_1000baseT_Full_BIT |
-					QED_LM_1000baseKX_Full_BIT |
-					QED_LM_1000baseX_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "1G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 1000baseT_Full);
+			phylink_set(sup_caps, 1000baseKX_Full);
+			phylink_set(sup_caps, 1000baseX_Full);
 			break;
 		case SPEED_10000:
-			sup_caps = QED_LM_10000baseT_Full_BIT |
-					QED_LM_10000baseKR_Full_BIT |
-					QED_LM_10000baseKX4_Full_BIT |
-					QED_LM_10000baseR_FEC_BIT |
-					QED_LM_10000baseCR_Full_BIT |
-					QED_LM_10000baseSR_Full_BIT |
-					QED_LM_10000baseLR_Full_BIT |
-					QED_LM_10000baseLRM_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "10G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 10000baseT_Full);
+			phylink_set(sup_caps, 10000baseKR_Full);
+			phylink_set(sup_caps, 10000baseKX4_Full);
+			phylink_set(sup_caps, 10000baseR_FEC);
+			phylink_set(sup_caps, 10000baseCR_Full);
+			phylink_set(sup_caps, 10000baseSR_Full);
+			phylink_set(sup_caps, 10000baseLR_Full);
+			phylink_set(sup_caps, 10000baseLRM_Full);
 			break;
 		case SPEED_20000:
-			if (!(current_link.supported_caps &
-			    QED_LM_20000baseKR2_Full_BIT)) {
-				DP_INFO(edev, "20G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = QED_LM_20000baseKR2_Full_BIT;
+			phylink_set(sup_caps, 20000baseKR2_Full);
 			break;
 		case SPEED_25000:
-			sup_caps = QED_LM_25000baseKR_Full_BIT |
-					QED_LM_25000baseCR_Full_BIT |
-					QED_LM_25000baseSR_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "25G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 25000baseKR_Full);
+			phylink_set(sup_caps, 25000baseCR_Full);
+			phylink_set(sup_caps, 25000baseSR_Full);
 			break;
 		case SPEED_40000:
-			sup_caps = QED_LM_40000baseLR4_Full_BIT |
-					QED_LM_40000baseKR4_Full_BIT |
-					QED_LM_40000baseCR4_Full_BIT |
-					QED_LM_40000baseSR4_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "40G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 40000baseLR4_Full);
+			phylink_set(sup_caps, 40000baseKR4_Full);
+			phylink_set(sup_caps, 40000baseCR4_Full);
+			phylink_set(sup_caps, 40000baseSR4_Full);
 			break;
 		case SPEED_50000:
-			sup_caps = QED_LM_50000baseKR2_Full_BIT |
-					QED_LM_50000baseCR2_Full_BIT |
-					QED_LM_50000baseSR2_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "50G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 50000baseKR2_Full);
+			phylink_set(sup_caps, 50000baseCR2_Full);
+			phylink_set(sup_caps, 50000baseSR2_Full);
 			break;
 		case SPEED_100000:
-			sup_caps = QED_LM_100000baseKR4_Full_BIT |
-					QED_LM_100000baseSR4_Full_BIT |
-					QED_LM_100000baseCR4_Full_BIT |
-					QED_LM_100000baseLR4_ER4_Full_BIT;
-			if (!(current_link.supported_caps & sup_caps)) {
-				DP_INFO(edev, "100G speed not supported\n");
-				return -EINVAL;
-			}
-			params.adv_speeds = current_link.supported_caps &
-						sup_caps;
+			phylink_set(sup_caps, 100000baseKR4_Full);
+			phylink_set(sup_caps, 100000baseSR4_Full);
+			phylink_set(sup_caps, 100000baseCR4_Full);
+			phylink_set(sup_caps, 100000baseLR4_ER4_Full);
 			break;
 		default:
 			DP_INFO(edev, "Unsupported speed %u\n", base->speed);
 			return -EINVAL;
 		}
+
+		if (!linkmode_intersects(current_link.supported_caps,
+					 sup_caps)) {
+			DP_INFO(edev, "%uG speed not supported\n",
+				base->speed / 1000);
+			return -EINVAL;
+		}
+
+		linkmode_and(params.adv_speeds, current_link.supported_caps,
+			     sup_caps);
 	}
 
 	params.link_up = true;
@@ -1006,13 +911,16 @@ static int qede_set_pauseparam(struct net_device *dev,
 
 	memset(&params, 0, sizeof(params));
 	params.override_flags |= QED_LINK_OVERRIDE_PAUSE_CONFIG;
+
 	if (epause->autoneg) {
-		if (!(current_link.supported_caps & QED_LM_Autoneg_BIT)) {
+		if (!phylink_test(current_link.supported_caps, Autoneg)) {
 			DP_INFO(edev, "autoneg not supported\n");
 			return -EINVAL;
 		}
+
 		params.pause_config |= QED_LINK_PAUSE_AUTONEG_ENABLE;
 	}
+
 	if (epause->rx_pause)
 		params.pause_config |= QED_LINK_PAUSE_RX_ENABLE;
 	if (epause->tx_pause)
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 36b1ca2dadbb..6e77e4908605 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/kthread.h>
+#include <linux/phylink.h>
 #include <scsi/libfc.h>
 #include <scsi/scsi_host.h>
 #include <scsi/fc_frame.h>
@@ -440,6 +441,7 @@ static void qedf_link_recovery(struct work_struct *work)
 static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	struct qed_link_output *link)
 {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sup_caps);
 	struct fc_lport *lport = qedf->lport;
 
 	lport->link_speed = FC_PORTSPEED_UNKNOWN;
@@ -474,40 +476,60 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	 * Set supported link speed by querying the supported
 	 * capabilities of the link.
 	 */
-	if ((link->supported_caps & QED_LM_10000baseT_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseKX4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseR_FEC_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseCR_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseSR_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseLR_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseLRM_Full_BIT) ||
-	    (link->supported_caps & QED_LM_10000baseKR_Full_BIT)) {
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 10000baseT_Full);
+	phylink_set(sup_caps, 10000baseKX4_Full);
+	phylink_set(sup_caps, 10000baseR_FEC);
+	phylink_set(sup_caps, 10000baseCR_Full);
+	phylink_set(sup_caps, 10000baseSR_Full);
+	phylink_set(sup_caps, 10000baseLR_Full);
+	phylink_set(sup_caps, 10000baseLRM_Full);
+	phylink_set(sup_caps, 10000baseKR_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_10GBIT;
-	}
-	if ((link->supported_caps & QED_LM_25000baseKR_Full_BIT) ||
-	    (link->supported_caps & QED_LM_25000baseCR_Full_BIT) ||
-	    (link->supported_caps & QED_LM_25000baseSR_Full_BIT)) {
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 25000baseKR_Full);
+	phylink_set(sup_caps, 25000baseCR_Full);
+	phylink_set(sup_caps, 25000baseSR_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_25GBIT;
-	}
-	if ((link->supported_caps & QED_LM_40000baseLR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_40000baseKR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_40000baseCR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_40000baseSR4_Full_BIT)) {
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 40000baseLR4_Full);
+	phylink_set(sup_caps, 40000baseKR4_Full);
+	phylink_set(sup_caps, 40000baseCR4_Full);
+	phylink_set(sup_caps, 40000baseSR4_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
-	}
-	if ((link->supported_caps & QED_LM_50000baseKR2_Full_BIT) ||
-	    (link->supported_caps & QED_LM_50000baseCR2_Full_BIT) ||
-	    (link->supported_caps & QED_LM_50000baseSR2_Full_BIT)) {
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 50000baseKR2_Full);
+	phylink_set(sup_caps, 50000baseCR2_Full);
+	phylink_set(sup_caps, 50000baseSR2_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_50GBIT;
-	}
-	if ((link->supported_caps & QED_LM_100000baseKR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_100000baseSR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_100000baseCR4_Full_BIT) ||
-	    (link->supported_caps & QED_LM_100000baseLR4_ER4_Full_BIT)) {
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 100000baseKR4_Full);
+	phylink_set(sup_caps, 100000baseSR4_Full);
+	phylink_set(sup_caps, 100000baseCR4_Full);
+	phylink_set(sup_caps, 100000baseLR4_ER4_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_100GBIT;
-	}
-	if (link->supported_caps & QED_LM_20000baseKR2_Full_BIT)
+
+	phylink_zero(sup_caps);
+	phylink_set(sup_caps, 20000baseKR2_Full);
+
+	if (linkmode_intersects(link->supported_caps, sup_caps))
 		lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
+
 	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
 }
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 8a6e3ad436d1..f82db1b92d45 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -661,42 +661,6 @@ enum qed_protocol {
 	QED_PROTOCOL_FCOE,
 };
 
-enum qed_link_mode_bits {
-	QED_LM_FIBRE_BIT = BIT(0),
-	QED_LM_Autoneg_BIT = BIT(1),
-	QED_LM_Asym_Pause_BIT = BIT(2),
-	QED_LM_Pause_BIT = BIT(3),
-	QED_LM_1000baseT_Full_BIT = BIT(4),
-	QED_LM_10000baseT_Full_BIT = BIT(5),
-	QED_LM_10000baseKR_Full_BIT = BIT(6),
-	QED_LM_20000baseKR2_Full_BIT = BIT(7),
-	QED_LM_25000baseKR_Full_BIT = BIT(8),
-	QED_LM_40000baseLR4_Full_BIT = BIT(9),
-	QED_LM_50000baseKR2_Full_BIT = BIT(10),
-	QED_LM_100000baseKR4_Full_BIT = BIT(11),
-	QED_LM_TP_BIT = BIT(12),
-	QED_LM_Backplane_BIT = BIT(13),
-	QED_LM_1000baseKX_Full_BIT = BIT(14),
-	QED_LM_10000baseKX4_Full_BIT = BIT(15),
-	QED_LM_10000baseR_FEC_BIT = BIT(16),
-	QED_LM_40000baseKR4_Full_BIT = BIT(17),
-	QED_LM_40000baseCR4_Full_BIT = BIT(18),
-	QED_LM_40000baseSR4_Full_BIT = BIT(19),
-	QED_LM_25000baseCR_Full_BIT = BIT(20),
-	QED_LM_25000baseSR_Full_BIT = BIT(21),
-	QED_LM_50000baseCR2_Full_BIT = BIT(22),
-	QED_LM_100000baseSR4_Full_BIT = BIT(23),
-	QED_LM_100000baseCR4_Full_BIT = BIT(24),
-	QED_LM_100000baseLR4_ER4_Full_BIT = BIT(25),
-	QED_LM_50000baseSR2_Full_BIT = BIT(26),
-	QED_LM_1000baseX_Full_BIT = BIT(27),
-	QED_LM_10000baseCR_Full_BIT = BIT(28),
-	QED_LM_10000baseSR_Full_BIT = BIT(29),
-	QED_LM_10000baseLR_Full_BIT = BIT(30),
-	QED_LM_10000baseLRM_Full_BIT = BIT(31),
-	QED_LM_COUNT = 32
-};
-
 struct qed_link_params {
 	bool	link_up;
 
@@ -708,7 +672,9 @@ struct qed_link_params {
 #define QED_LINK_OVERRIDE_EEE_CONFIG            BIT(5)
 	u32	override_flags;
 	bool	autoneg;
-	u32	adv_speeds;
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_speeds);
+
 	u32	forced_speed;
 #define QED_LINK_PAUSE_AUTONEG_ENABLE           BIT(0)
 #define QED_LINK_PAUSE_RX_ENABLE                BIT(1)
@@ -726,10 +692,9 @@ struct qed_link_params {
 struct qed_link_output {
 	bool	link_up;
 
-	/* In QED_LM_* defs */
-	u32	supported_caps;
-	u32	advertised_caps;
-	u32	lp_caps;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_caps);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertised_caps);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_caps);
 
 	u32	speed;                  /* In Mb/s */
 	u8	duplex;                 /* In DUPLEX defs */
-- 
2.25.1

