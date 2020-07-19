Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02682253F2
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGSUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:15:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbgGSUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:15:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFcKs012592;
        Sun, 19 Jul 2020 13:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=VayE/f20mjuKduSHythXIwBfh/PAx7jFdoQFzfHzo3A=;
 b=nvgTCpj8V45ouP1LATW7Sy2h++CldSsShAJzSqDULbW1JfihmoMtibkQ3XgjwJC4NIjl
 H/Lmv5VNStNgPYZGISPpcKheJuYgp2EP2oyiVvwBFW+gZewmVtF8zzbUpffcyUMDFmrM
 n5uAgq7mfOYl8oeECrw1loBJhOzRsm8qXtYAnr3pJr+UMynOonNjFX9LbZ9wbp9lOwPc
 V64gaxgpi3wDGz1r4nkQ6ANfJN6KLkkx/neCK+VHH7hynJAS9d3IPfYMW6kt3SJy0po4
 yvOt+DayAc48nb2rk2IwugXMSycu3tMYqfIjR9p/9mUBJdN6EedCcN5qY88yK1TOc640 jQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxenbysx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:15:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:15:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:15:36 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 0A0C93F703F;
        Sun, 19 Jul 2020 13:15:31 -0700 (PDT)
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
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 04/14] qed: use transceiver data to fill link partner's advertising speeds
Date:   Sun, 19 Jul 2020 23:14:43 +0300
Message-ID: <20200719201453.3648-5-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719201453.3648-1-alobakin@marvell.com>
References: <20200719201453.3648-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
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
index 9df27c3f5cab..1639210044a7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1870,6 +1870,27 @@ static void qed_fill_link_capability(struct qed_hwfn *hwfn,
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
@@ -1877,7 +1898,7 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	struct qed_mcp_link_capabilities link_caps;
 	struct qed_mcp_link_params params;
 	struct qed_mcp_link_state link;
-	u32 media_type;
+	u32 media_type, speed_mask;
 
 	memset(if_link, 0, sizeof(*if_link));
 
@@ -1908,13 +1929,18 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	else
 		__clear_bit(QED_LM_Autoneg, if_link->advertised_caps);
 
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
 
@@ -1932,23 +1958,6 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	if (params.pause.forced_tx)
 		if_link->pause_config |= QED_LINK_PAUSE_TX_ENABLE;
 
-	/* Link partner capabilities */
-
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_1G_FD)
-		__set_bit(QED_LM_1000baseT_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_10G)
-		__set_bit(QED_LM_10000baseKR_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_20G)
-		__set_bit(QED_LM_20000baseKR2_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_25G)
-		__set_bit(QED_LM_25000baseKR_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_40G)
-		__set_bit(QED_LM_40000baseLR4_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_50G)
-		__set_bit(QED_LM_50000baseKR2_Full, if_link->lp_caps);
-	if (link.partner_adv_speed & QED_LINK_PARTNER_SPEED_100G)
-		__set_bit(QED_LM_100000baseKR4_Full, if_link->lp_caps);
-
 	if (link.an_complete)
 		__set_bit(QED_LM_Autoneg, if_link->lp_caps);
 	if (link.partner_adv_pause)
-- 
2.25.1

