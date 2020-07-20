Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50B226DF5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgGTSKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:10:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55660 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389366AbgGTSKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:10:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHuAVw024321;
        Mon, 20 Jul 2020 11:10:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=jUtwuC3+Gvoq69R6fifrsrwJX8t+9EYJGoC0LxCVz3k=;
 b=goSOgG9OxtgP4Y8PrrCLOu0WwETnEMjdThNJbP2K89rHwzOXp3wadfDCsCbbwBvW1bRr
 HR8wmTlMfu99yolQxUG6W6RNFWe6nL9QC07vtbKUNRhONzfZF9JaltXm8x7Y5UKtz0x8
 C+GDuFM07r/sCKdQmTxd5BEVHtbLkRwT3yBToyT2mY+DJuxTo99Nbcpp7IItfpvX0Bef
 KHIi1+iJqtghZWjefJkU5qHi1Sg5eZTIjrw3FmKUK4+hcoHv40xBjmAZgFsD1uGL3ilD
 UD6K+V1M2ZviVr/ZDeTFDCqFZ+S9qEi9MaQ0rvoG5k2REJoTJ5zXnD8ZJRpGL2nRRldL tA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf92a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:58 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C73B03F703F;
        Mon, 20 Jul 2020 11:09:53 -0700 (PDT)
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
Subject: [PATCH v3 net-next 15/16] qed: populate supported link modes maps on module init
Date:   Mon, 20 Jul 2020 21:08:14 +0300
Message-ID: <20200720180815.107-16-alobakin@marvell.com>
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

Simplify and lighten qed_set_link() by declaring static link modes maps
and populating them on module init. This way we save plenty of text size
at the low expense of __ro_after_init and __initconst data (the latter
will be purged after module init is done).

Misc: sanitize exit callback.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 189 +++++++++++++--------
 1 file changed, 118 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index fea155c6ff11..4fe66cf60f24 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -65,20 +65,118 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 
 MODULE_FIRMWARE(QED_FW_FILE_NAME);
 
+/* MFW speed capabilities maps */
+
+struct qed_mfw_speed_map {
+	u32		mfw_val;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(caps);
+
+	const u32	*cap_arr;
+	u32		arr_size;
+};
+
+#define QED_MFW_SPEED_MAP(type, arr)		\
+{						\
+	.mfw_val	= (type),		\
+	.cap_arr	= (arr),		\
+	.arr_size	= ARRAY_SIZE(arr),	\
+}
+
+static const u32 qed_mfw_legacy_1g[] __initconst = {
+	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_10g[] __initconst = {
+	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
+	ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_20g[] __initconst = {
+	ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_25g[] __initconst = {
+	ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_40g[] __initconst = {
+	ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_50g[] __initconst = {
+	ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+};
+
+static const u32 qed_mfw_legacy_bb_100g[] __initconst = {
+	ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+};
+
+static struct qed_mfw_speed_map qed_mfw_legacy_maps[] __ro_after_init = {
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G,
+			  qed_mfw_legacy_1g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G,
+			  qed_mfw_legacy_10g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G,
+			  qed_mfw_legacy_20g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G,
+			  qed_mfw_legacy_25g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G,
+			  qed_mfw_legacy_40g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G,
+			  qed_mfw_legacy_50g),
+	QED_MFW_SPEED_MAP(NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G,
+			  qed_mfw_legacy_bb_100g),
+};
+
+static void __init qed_mfw_speed_map_populate(struct qed_mfw_speed_map *map)
+{
+	linkmode_set_bit_array(map->cap_arr, map->arr_size, map->caps);
+
+	map->cap_arr = NULL;
+	map->arr_size = 0;
+}
+
+static void __init qed_mfw_speed_maps_init(void)
+{
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(qed_mfw_legacy_maps); i++)
+		qed_mfw_speed_map_populate(qed_mfw_legacy_maps + i);
+}
+
 static int __init qed_init(void)
 {
 	pr_info("%s", version);
 
+	qed_mfw_speed_maps_init();
+
 	return 0;
 }
+module_init(qed_init);
 
-static void __exit qed_cleanup(void)
+static void __exit qed_exit(void)
 {
-	pr_notice("qed_cleanup called\n");
+	/* To prevent marking this module as "permanent" */
 }
-
-module_init(qed_init);
-module_exit(qed_cleanup);
+module_exit(qed_exit);
 
 /* Check if the DMA controller on the machine can properly handle the DMA
  * addressing required by the device.
@@ -1457,12 +1555,13 @@ static bool qed_can_link_change(struct qed_dev *cdev)
 
 static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(sup_caps);
 	struct qed_mcp_link_params *link_params;
+	struct qed_mcp_link_speed_params *speed;
+	const struct qed_mfw_speed_map *map;
 	struct qed_hwfn *hwfn;
 	struct qed_ptt *ptt;
-	u32 as;
 	int rc;
+	u32 i;
 
 	if (!cdev)
 		return -ENODEV;
@@ -1487,78 +1586,25 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 	if (!link_params)
 		return -ENODATA;
 
+	speed = &link_params->speed;
+
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_AUTONEG)
-		link_params->speed.autoneg = params->autoneg;
+		speed->autoneg = !!params->autoneg;
 
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_ADV_SPEEDS) {
-		as = 0;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 1000baseT_Full);
-		phylink_set(sup_caps, 1000baseKX_Full);
-		phylink_set(sup_caps, 1000baseX_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 10000baseT_Full);
-		phylink_set(sup_caps, 10000baseKR_Full);
-		phylink_set(sup_caps, 10000baseKX4_Full);
-		phylink_set(sup_caps, 10000baseR_FEC);
-		phylink_set(sup_caps, 10000baseCR_Full);
-		phylink_set(sup_caps, 10000baseSR_Full);
-		phylink_set(sup_caps, 10000baseLR_Full);
-		phylink_set(sup_caps, 10000baseLRM_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
+		speed->advertised_speeds = 0;
 
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 20000baseKR2_Full);
+		for (i = 0; i < ARRAY_SIZE(qed_mfw_legacy_maps); i++) {
+			map = qed_mfw_legacy_maps + i;
 
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 25000baseKR_Full);
-		phylink_set(sup_caps, 25000baseCR_Full);
-		phylink_set(sup_caps, 25000baseSR_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 40000baseLR4_Full);
-		phylink_set(sup_caps, 40000baseKR4_Full);
-		phylink_set(sup_caps, 40000baseCR4_Full);
-		phylink_set(sup_caps, 40000baseSR4_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 50000baseKR2_Full);
-		phylink_set(sup_caps, 50000baseCR2_Full);
-		phylink_set(sup_caps, 50000baseSR2_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G;
-
-		phylink_zero(sup_caps);
-		phylink_set(sup_caps, 100000baseKR4_Full);
-		phylink_set(sup_caps, 100000baseSR4_Full);
-		phylink_set(sup_caps, 100000baseCR4_Full);
-		phylink_set(sup_caps, 100000baseLR4_ER4_Full);
-
-		if (linkmode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G;
-
-		link_params->speed.advertised_speeds = as;
+			if (linkmode_intersects(params->adv_speeds, map->caps))
+				speed->advertised_speeds |= map->mfw_val;
+		}
 	}
 
 	if (params->override_flags & QED_LINK_OVERRIDE_SPEED_FORCED_SPEED)
-		link_params->speed.forced_speed = params->forced_speed;
+		speed->forced_speed = params->forced_speed;
+
 	if (params->override_flags & QED_LINK_OVERRIDE_PAUSE_CONFIG) {
 		if (params->pause_config & QED_LINK_PAUSE_AUTONEG_ENABLE)
 			link_params->pause.autoneg = true;
@@ -1573,6 +1619,7 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 		else
 			link_params->pause.forced_tx = false;
 	}
+
 	if (params->override_flags & QED_LINK_OVERRIDE_LOOPBACK_MODE) {
 		switch (params->loopback_mode) {
 		case QED_LINK_LOOPBACK_INT_PHY:
-- 
2.25.1

