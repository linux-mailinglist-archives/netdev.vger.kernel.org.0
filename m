Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B827225402
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgGSUQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:16:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17042 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgGSUQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:16:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFnmI017996;
        Sun, 19 Jul 2020 13:16:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=H5ZZnVGRPimm90r1SWalo1spdE3e+9tQZ8ia1G3nPgE=;
 b=DYINnCSkG78XzQUtvGn7r5hPzXaWSXbqKdrjaOQQoMuePomi2jF3qi8mGjKYBYD4o5rJ
 QPxwoOoeQ1i563G1CFWqmNRv1r8Xe2mhRpVP6+WJpfYYQJl1/MajVrwoCvc8KTTlAl58
 arwcunw8fpaA2mXN7Hcg/hFW0lImmZwh2P+2WMYLV+KlWHAAd8qQNZvI/4yq72USM3K3
 vWJMiewvbIz7J7YJ4V5VE7V2oMTPW/MwcuUvevTezqysFYDNoUIonw2POKx2Kzv0FCJ4
 AF3gBTqAU2U6R5++ZPTtVTX/GDBIcksLGG/hjFWzmoFyCQsleR6NKzJrv9AZ9tWgGeLa Kg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkbf5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:16:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:16:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:16:17 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 6AB243F7041;
        Sun, 19 Jul 2020 13:16:13 -0700 (PDT)
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
Subject: [PATCH v2 net-next 13/14] qed: populate supported link modes maps on module init
Date:   Sun, 19 Jul 2020 23:14:52 +0300
Message-ID: <20200719201453.3648-14-alobakin@marvell.com>
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

Simplify and lighten qed_set_link() by declaring static link modes maps
and populating them on module init. This way we save plenty of text size
at the low expense of __ro_after_init and __initconst data (the latter
will be purged after module init is done).

Misc: sanitize exit callback.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 194 +++++++++++++--------
 1 file changed, 123 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index ff8e41694f65..28f13cd7bd9b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -64,20 +64,122 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 
 MODULE_FIRMWARE(QED_FW_FILE_NAME);
 
+/* MFW speed capabilities maps */
+
+struct qed_mfw_speed_map {
+	u32		mfw_val;
+
+	QED_LM_DECLARE(caps);
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
+	QED_LM_1000baseT_Full,
+	QED_LM_1000baseKX_Full,
+	QED_LM_1000baseX_Full,
+};
+
+static const u32 qed_mfw_legacy_10g[] __initconst = {
+	QED_LM_10000baseT_Full,
+	QED_LM_10000baseKR_Full,
+	QED_LM_10000baseKX4_Full,
+	QED_LM_10000baseR_FEC,
+	QED_LM_10000baseCR_Full,
+	QED_LM_10000baseSR_Full,
+	QED_LM_10000baseLR_Full,
+	QED_LM_10000baseLRM_Full,
+};
+
+static const u32 qed_mfw_legacy_20g[] __initconst = {
+	QED_LM_20000baseKR2_Full,
+};
+
+static const u32 qed_mfw_legacy_25g[] __initconst = {
+	QED_LM_25000baseKR_Full,
+	QED_LM_25000baseCR_Full,
+	QED_LM_25000baseSR_Full,
+};
+
+static const u32 qed_mfw_legacy_40g[] __initconst = {
+	QED_LM_40000baseLR4_Full,
+	QED_LM_40000baseKR4_Full,
+	QED_LM_40000baseCR4_Full,
+	QED_LM_40000baseSR4_Full,
+};
+
+static const u32 qed_mfw_legacy_50g[] __initconst = {
+	QED_LM_50000baseKR2_Full,
+	QED_LM_50000baseCR2_Full,
+	QED_LM_50000baseSR2_Full,
+};
+
+static const u32 qed_mfw_legacy_bb_100g[] __initconst = {
+	QED_LM_100000baseKR4_Full,
+	QED_LM_100000baseSR4_Full,
+	QED_LM_100000baseCR4_Full,
+	QED_LM_100000baseLR4_ER4_Full,
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
+	u32 i;
+
+	for (i = 0; i < map->arr_size; i++)
+		__set_bit(map->cap_arr[i], map->caps);
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
@@ -1457,11 +1559,12 @@ static bool qed_can_link_change(struct qed_dev *cdev)
 static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 {
 	struct qed_mcp_link_params *link_params;
-	QED_LM_DECLARE(sup_caps);
+	struct qed_mcp_link_speed_params *speed;
+	const struct qed_mfw_speed_map *map;
 	struct qed_hwfn *hwfn;
 	struct qed_ptt *ptt;
-	u32 as;
 	int rc;
+	u32 i;
 
 	if (!cdev)
 		return -ENODEV;
@@ -1486,78 +1589,26 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
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
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_1000baseT_Full, sup_caps);
-		__set_bit(QED_LM_1000baseKX_Full, sup_caps);
-		__set_bit(QED_LM_1000baseX_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_1G;
-
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_10000baseT_Full, sup_caps);
-		__set_bit(QED_LM_10000baseKR_Full, sup_caps);
-		__set_bit(QED_LM_10000baseKX4_Full, sup_caps);
-		__set_bit(QED_LM_10000baseR_FEC, sup_caps);
-		__set_bit(QED_LM_10000baseCR_Full, sup_caps);
-		__set_bit(QED_LM_10000baseSR_Full, sup_caps);
-		__set_bit(QED_LM_10000baseLR_Full, sup_caps);
-		__set_bit(QED_LM_10000baseLRM_Full, sup_caps);
+		speed->advertised_speeds = 0;
 
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_10G;
+		for (i = 0; i < ARRAY_SIZE(qed_mfw_legacy_maps); i++) {
+			map = qed_mfw_legacy_maps + i;
 
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_20000baseKR2_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_20G;
-
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_25000baseKR_Full, sup_caps);
-		__set_bit(QED_LM_25000baseCR_Full, sup_caps);
-		__set_bit(QED_LM_25000baseSR_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_25G;
-
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_40000baseLR4_Full, sup_caps);
-		__set_bit(QED_LM_40000baseKR4_Full, sup_caps);
-		__set_bit(QED_LM_40000baseCR4_Full, sup_caps);
-		__set_bit(QED_LM_40000baseSR4_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_40G;
-
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_50000baseKR2_Full, sup_caps);
-		__set_bit(QED_LM_50000baseCR2_Full, sup_caps);
-		__set_bit(QED_LM_50000baseSR2_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_50G;
-
-		qed_link_mode_zero(sup_caps);
-		__set_bit(QED_LM_100000baseKR4_Full, sup_caps);
-		__set_bit(QED_LM_100000baseSR4_Full, sup_caps);
-		__set_bit(QED_LM_100000baseCR4_Full, sup_caps);
-		__set_bit(QED_LM_100000baseLR4_ER4_Full, sup_caps);
-
-		if (qed_link_mode_intersects(params->adv_speeds, sup_caps))
-			as |= NVM_CFG1_PORT_DRV_SPEED_CAPABILITY_MASK_BB_100G;
-
-		link_params->speed.advertised_speeds = as;
+			if (qed_link_mode_intersects(params->adv_speeds,
+						     map->caps))
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
@@ -1572,6 +1623,7 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 		else
 			link_params->pause.forced_tx = false;
 	}
+
 	if (params->override_flags & QED_LINK_OVERRIDE_LOOPBACK_MODE) {
 		switch (params->loopback_mode) {
 		case QED_LINK_LOOPBACK_INT_PHY:
-- 
2.25.1

