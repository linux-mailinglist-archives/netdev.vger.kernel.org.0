Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37381226DCF
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbgGTSJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729029AbgGTSJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqtF024216;
        Mon, 20 Jul 2020 11:09:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=dj2hvRHTv7WmYRoePHxiWZT0a+Yyb8TB3pWFl6TCnF8=;
 b=mmbjBXEl1eI2/TjFnxC2ivqx3N+RRqByzq6rz7fqUN5bu+7D8Rf6N6YR3ijBCuVJ89O+
 78ZcUDQzlxny8FnoZzWrtkFfxvmz1/5McK1Kzo9CEOYf2NOyFkhLbApLyjs7t897AkN2
 kA5c9vVeTCfUMqmFJ6uYmGkh/1cU8FUcQNI81IvXOwdOj0/lhp42Q+fe/SIiNlNonXiz
 6wIbYfEBc+pAmd4v0NvAGFE2ZRbQqnyvswpBP4DyW/bZOVc55DEkyVQaiKCeUeIykI7/
 PyuoBKAH3Ac9my2zdtse2LtW7uCSMt6r7691Gu4D1qRy5eWWcCYllnsY5Ueo90gmYYB9 +g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:01 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C8B0A3F7040;
        Mon, 20 Jul 2020 11:08:56 -0700 (PDT)
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
Subject: [PATCH v3 net-next 03/16] qede: populate supported link modes maps on module init
Date:   Mon, 20 Jul 2020 21:08:02 +0300
Message-ID: <20200720180815.107-4-alobakin@marvell.com>
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

Simplify and lighten qede_set_link_ksettings() by declaring static link
modes maps and populating them on module init. This way we save plenty
of text size at the low expense of __ro_after_init and __initconst data
(the latter will be purged after module init is done).

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 158 ++++++++++++------
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +
 3 files changed, 108 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 8adda5dc9e88..f1d7f73de902 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -557,6 +557,8 @@ void qede_update_rx_prod(struct qede_dev *edev, struct qede_rx_queue *rxq);
 int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f);
 
+void qede_forced_speed_maps_init(void);
+
 #define RX_RING_SIZE_POW	13
 #define RX_RING_SIZE		((u16)BIT(RX_RING_SIZE_POW))
 #define NUM_RX_BDS_MAX		(RX_RING_SIZE - 1)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 0a564b06d697..7a985307cdd5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -196,6 +196,96 @@ static const char qede_tests_str_arr[QEDE_ETHTOOL_TEST_MAX][ETH_GSTRING_LEN] = {
 	"Nvram (online)\t\t",
 };
 
+/* Forced speed capabilities maps */
+
+struct qede_forced_speed_map {
+	u32		speed;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(caps);
+
+	const u32	*cap_arr;
+	u32		arr_size;
+};
+
+#define QEDE_FORCED_SPEED_MAP(value)					\
+{									\
+	.speed		= SPEED_##value,				\
+	.cap_arr	= qede_forced_speed_##value,			\
+	.arr_size	= ARRAY_SIZE(qede_forced_speed_##value),	\
+}
+
+static const u32 qede_forced_speed_1000[] __initconst = {
+	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+};
+
+static const u32 qede_forced_speed_10000[] __initconst = {
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
+static const u32 qede_forced_speed_20000[] __initconst = {
+	ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
+};
+
+static const u32 qede_forced_speed_25000[] __initconst = {
+	ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+};
+
+static const u32 qede_forced_speed_40000[] __initconst = {
+	ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+};
+
+static const u32 qede_forced_speed_50000[] __initconst = {
+	ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+};
+
+static const u32 qede_forced_speed_100000[] __initconst = {
+	ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+};
+
+static struct qede_forced_speed_map qede_forced_speed_maps[] __ro_after_init = {
+	QEDE_FORCED_SPEED_MAP(1000),
+	QEDE_FORCED_SPEED_MAP(10000),
+	QEDE_FORCED_SPEED_MAP(20000),
+	QEDE_FORCED_SPEED_MAP(25000),
+	QEDE_FORCED_SPEED_MAP(40000),
+	QEDE_FORCED_SPEED_MAP(50000),
+	QEDE_FORCED_SPEED_MAP(100000),
+};
+
+void __init qede_forced_speed_maps_init(void)
+{
+	struct qede_forced_speed_map *map;
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(qede_forced_speed_maps); i++) {
+		map = qede_forced_speed_maps + i;
+
+		linkmode_set_bit_array(map->cap_arr, map->arr_size, map->caps);
+		map->cap_arr = NULL;
+		map->arr_size = 0;
+	}
+}
+
+/* Ethtool callbacks */
+
 static void qede_get_strings_stats_txq(struct qede_dev *edev,
 				       struct qede_tx_queue *txq, u8 **buf)
 {
@@ -458,10 +548,11 @@ static int qede_set_link_ksettings(struct net_device *dev,
 				   const struct ethtool_link_ksettings *cmd)
 {
 	const struct ethtool_link_settings *base = &cmd->base;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(sup_caps);
 	struct qede_dev *edev = netdev_priv(dev);
+	const struct qede_forced_speed_map *map;
 	struct qed_link_output current_link;
 	struct qed_link_params params;
+	u32 i;
 
 	if (!edev->ops || !edev->ops->common->can_link_change(edev->cdev)) {
 		DP_INFO(edev, "Link settings are not allowed to be changed\n");
@@ -489,65 +580,24 @@ static int qede_set_link_ksettings(struct net_device *dev,
 		params.autoneg = false;
 		params.forced_speed = base->speed;
 
-		phylink_zero(sup_caps);
+		for (i = 0; i < ARRAY_SIZE(qede_forced_speed_maps); i++) {
+			map = qede_forced_speed_maps + i;
 
-		switch (base->speed) {
-		case SPEED_1000:
-			phylink_set(sup_caps, 1000baseT_Full);
-			phylink_set(sup_caps, 1000baseKX_Full);
-			phylink_set(sup_caps, 1000baseX_Full);
-			break;
-		case SPEED_10000:
-			phylink_set(sup_caps, 10000baseT_Full);
-			phylink_set(sup_caps, 10000baseKR_Full);
-			phylink_set(sup_caps, 10000baseKX4_Full);
-			phylink_set(sup_caps, 10000baseR_FEC);
-			phylink_set(sup_caps, 10000baseCR_Full);
-			phylink_set(sup_caps, 10000baseSR_Full);
-			phylink_set(sup_caps, 10000baseLR_Full);
-			phylink_set(sup_caps, 10000baseLRM_Full);
-			break;
-		case SPEED_20000:
-			phylink_set(sup_caps, 20000baseKR2_Full);
-			break;
-		case SPEED_25000:
-			phylink_set(sup_caps, 25000baseKR_Full);
-			phylink_set(sup_caps, 25000baseCR_Full);
-			phylink_set(sup_caps, 25000baseSR_Full);
-			break;
-		case SPEED_40000:
-			phylink_set(sup_caps, 40000baseLR4_Full);
-			phylink_set(sup_caps, 40000baseKR4_Full);
-			phylink_set(sup_caps, 40000baseCR4_Full);
-			phylink_set(sup_caps, 40000baseSR4_Full);
-			break;
-		case SPEED_50000:
-			phylink_set(sup_caps, 50000baseKR2_Full);
-			phylink_set(sup_caps, 50000baseCR2_Full);
-			phylink_set(sup_caps, 50000baseSR2_Full);
-			break;
-		case SPEED_100000:
-			phylink_set(sup_caps, 100000baseKR4_Full);
-			phylink_set(sup_caps, 100000baseSR4_Full);
-			phylink_set(sup_caps, 100000baseCR4_Full);
-			phylink_set(sup_caps, 100000baseLR4_ER4_Full);
-			break;
-		default:
-			DP_INFO(edev, "Unsupported speed %u\n", base->speed);
-			return -EINVAL;
-		}
+			if (base->speed != map->speed ||
+			    !linkmode_intersects(current_link.supported_caps,
+						 map->caps))
+				continue;
 
-		if (!linkmode_intersects(current_link.supported_caps,
-					 sup_caps)) {
-			DP_INFO(edev, "%uG speed not supported\n",
-				base->speed / 1000);
-			return -EINVAL;
+			linkmode_and(params.adv_speeds,
+				     current_link.supported_caps, map->caps);
+			goto set_link;
 		}
 
-		linkmode_and(params.adv_speeds, current_link.supported_caps,
-			     sup_caps);
+		DP_INFO(edev, "Unsupported speed %u\n", base->speed);
+		return -EINVAL;
 	}
 
+set_link:
 	params.link_up = true;
 	edev->ops->common->set_link(edev->cdev, &params);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index a653dd0e5c22..6f2171dc0dea 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -263,6 +263,8 @@ int __init qede_init(void)
 
 	pr_info("qede_init: %s\n", version);
 
+	qede_forced_speed_maps_init();
+
 	qed_ops = qed_get_eth_ops();
 	if (!qed_ops) {
 		pr_notice("Failed to get qed ethtool operations\n");
-- 
2.25.1

