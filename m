Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E8226DDA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbgGTSJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63034 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389251AbgGTSJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqID024225;
        Mon, 20 Jul 2020 11:09:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=9pYExr+cNdN0CDx0ex7jSFCDugxXCRMevldkMQjg8UE=;
 b=r6tSz0mlh0KZRpcetihzGCutJt0C4X7tgfg7QYXwREe7SvcQonFmPxnA/yB/tntB+Pce
 wMcEnmFrpBdZ9dx4v+Mde5kd4QbJggmY/h7MqHqdjruPEHzs/3I1CKTL6RB0A5B4jq6S
 w0ORZ/lGICt5EGEoenhIflVcQB27RO+XS6dJ6beCtqZWWGgO4UmP4r2eextNJJLGKPDb
 l+l2z1sFyswO6rXoRGv3pNnm2iyAE96k4OtpdX+UKb0ikOA1o45WfYBsKQ3OkuRS88Vp
 DNSz17ptBeeDc2gRUAvKMjJp5RIlCsb77uyG16e122VWO3L9rcioJFleUoKx+Sripjw1 9g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:15 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 00FA63F703F;
        Mon, 20 Jul 2020 11:09:10 -0700 (PDT)
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
Subject: [PATCH v3 net-next 06/16] qed: use transceiver data to fill link partner's advertising speeds
Date:   Mon, 20 Jul 2020 21:08:05 +0300
Message-ID: <20200720180815.107-7-alobakin@marvell.com>
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

Currently qed driver does not take into consideration transceiver's
capabilities when generating link partner's speed advertisement. This
leads to e.g. incorrect ethtool link info on 10GbaseT modules.
Use transceiver info not only for advertisement and support arrays, but
also for link partner's abilities to fix it.

Misc: fix a couple of comments nearby.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 49 +++++++++++++---------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 172a107f9299..2be9ed39c450 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1879,6 +1879,27 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
 	}
 }
 
+static void qed_lp_caps_to_speed_mask(u32 caps, u32 *speed_mask)
+{
+	*speed_mask = 0;
+
+	if (caps &
+	    (QED_LINK_PARTNER_SPEED_1G_FD | QED_LINK_PARTNER_SPEED_1G_HD))
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
+	if (caps & QED_LINK_PARTNER_SPEED_10G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
+	if (caps & QED_LINK_PARTNER_SPEED_20G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G;
+	if (caps & QED_LINK_PARTNER_SPEED_25G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G;
+	if (caps & QED_LINK_PARTNER_SPEED_40G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
+	if (caps & QED_LINK_PARTNER_SPEED_50G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G;
+	if (caps & QED_LINK_PARTNER_SPEED_100G)
+		*speed_mask |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G;
+}
+
 static void qed_fill_link(struct qed_hwfn *hwfn,
 			  struct qed_ptt *ptt,
 			  struct qed_link_output *if_link)
@@ -1886,7 +1907,7 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	struct qed_mcp_link_capabilities link_caps;
 	struct qed_mcp_link_params params;
 	struct qed_mcp_link_state link;
-	u32 media_type;
+	u32 media_type, speed_mask;
 
 	memset(if_link, 0, sizeof(*if_link));
 
@@ -1917,13 +1938,18 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	else
 		phylink_clear(if_link->advertised_caps, Autoneg);
 
-	/* Fill link advertised capability*/
+	/* Fill link advertised capability */
 	qed_fill_link_capability(hwfn, ptt, params.speed.advertised_speeds,
 				 if_link->advertised_caps);
-	/* Fill link supported capability*/
+
+	/* Fill link supported capability */
 	qed_fill_link_capability(hwfn, ptt, link_caps.speed_capabilities,
 				 if_link->supported_caps);
 
+	/* Fill partner advertised capability */
+	qed_lp_caps_to_speed_mask(link.partner_adv_speed, &speed_mask);
+	qed_fill_link_capability(hwfn, ptt, speed_mask, if_link->lp_caps);
+
 	if (link.link_up)
 		if_link->speed = link.speed;
 
@@ -1941,23 +1967,6 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	if (params.pause.forced_tx)
 		if_link->pause_config |= QED_LINK_PAUSE_TX_ENABLE;
 
-	/* Link partner capabilities */
-
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_1G_FD)
-		phylink_set(if_link->lp_caps, 1000baseT_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_10G)
-		phylink_set(if_link->lp_caps, 10000baseKR_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_20G)
-		phylink_set(if_link->lp_caps, 20000baseKR2_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_25G)
-		phylink_set(if_link->lp_caps, 25000baseKR_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_40G)
-		phylink_set(if_link->lp_caps, 40000baseLR4_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_50G)
-		phylink_set(if_link->lp_caps, 50000baseKR2_Full);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_100G)
-		phylink_set(if_link->lp_caps, 100000baseKR4_Full);
-
 	if (link.an_complete)
 		phylink_set(if_link->lp_caps, Autoneg);
 	if (link.partner_adv_pause)
-- 
2.25.1

