Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33670203A04
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgFVOxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22882 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728918AbgFVOxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEZHHk003841;
        Mon, 22 Jun 2020 07:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Sjnx4ozO1zKbFuBPwWv5OXgb2spWINcT5JveEzIffsE=;
 b=NgDQW8w7sU8u5PddJKMu93l+FRi5pVhZS8NtuG0hv6IEahSgKyynqAZjtqufj9vNFtNN
 ddLBuj//8j8d0EK1pMIZeqfNMfNeKoKADmBErRQjYEdH6jliuK0p8uKtKsn1qlCIcbm8
 k6BBWueJAz9eMTYernCp1lDwGjCFWSGnh/4FUhgIdf7uDLv+uhfbjZl4UhQISk6Qi9Kf
 zdxcE8A/Tc/uA/eQHKU1n83dTKrIpBAAATj9+umay3FgCVkyvVaFJ8fOc9IoYLjoUdD2
 KdV3wGCMwvxe7aYoqhU1exQDPlG1s4kxHecLeKyZY7ik0YB+3alo/kIkhrqE+w5ow0n5 qA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynrhqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:15 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 0F7CB3F7043;
        Mon, 22 Jun 2020 07:53:13 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 1/6] net: atlantic: A2: half duplex support
Date:   Mon, 22 Jun 2020 17:53:04 +0300
Message-ID: <20200622145309.455-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for 10M/100M/1G half duplex rates, which are
supported by A2 in additional to full duplex rates supported by A1.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_common.h    | 13 ++--
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  8 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 60 ++++++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  5 +-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  5 ++
 7 files changed, 70 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 52ad9433cabc..1587528ca3f6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -58,11 +58,14 @@
 #define AQ_NIC_RATE_1G		BIT(4)
 #define AQ_NIC_RATE_100M	BIT(5)
 #define AQ_NIC_RATE_10M		BIT(6)
+#define AQ_NIC_RATE_1G_HALF	BIT(7)
+#define AQ_NIC_RATE_100M_HALF	BIT(8)
+#define AQ_NIC_RATE_10M_HALF	BIT(9)
 
-#define AQ_NIC_RATE_EEE_10G	BIT(7)
-#define AQ_NIC_RATE_EEE_5G	BIT(8)
-#define AQ_NIC_RATE_EEE_2G5	BIT(9)
-#define AQ_NIC_RATE_EEE_1G	BIT(10)
-#define AQ_NIC_RATE_EEE_100M	BIT(11)
+#define AQ_NIC_RATE_EEE_10G	BIT(10)
+#define AQ_NIC_RATE_EEE_5G	BIT(11)
+#define AQ_NIC_RATE_EEE_2G5	BIT(12)
+#define AQ_NIC_RATE_EEE_1G	BIT(13)
+#define AQ_NIC_RATE_EEE_100M	BIT(14)
 
 #endif /* AQ_COMMON_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index ed5b465bc664..1408a522eff1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_hw.h: Declaration of abstract interface for NIC hardware specific
@@ -69,6 +70,7 @@ struct aq_hw_caps_s {
 
 struct aq_hw_link_status_s {
 	unsigned int mbps;
+	bool full_duplex;
 };
 
 struct aq_stats_s {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 4435c6374f7e..49528fcdc947 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -939,8 +939,11 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		cmd->base.port = PORT_FIBRE;
 	else
 		cmd->base.port = PORT_TP;
-	/* This driver supports only 10G capable adapters, so DUPLEX_FULL */
-	cmd->base.duplex = DUPLEX_FULL;
+
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+	if (self->link_status.mbps)
+		cmd->base.duplex = self->link_status.full_duplex ?
+				   DUPLEX_FULL : DUPLEX_HALF;
 	cmd->base.autoneg = self->aq_nic_cfg.is_autoneg;
 
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
@@ -961,14 +964,26 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     1000baseT_Full);
 
+	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_1G_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     1000baseT_Half);
+
 	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_100M)
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     100baseT_Full);
 
+	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_100M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     100baseT_Half);
+
 	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_10M)
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     10baseT_Full);
 
+	if (self->aq_nic_cfg.aq_hw_caps->link_speed_msk & AQ_NIC_RATE_10M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     10baseT_Half);
+
 	if (self->aq_nic_cfg.aq_hw_caps->flow_control) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     Pause);
@@ -988,30 +1003,42 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 	if (self->aq_nic_cfg.is_autoneg)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_10G)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_10G)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     10000baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_5G)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_5G)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     5000baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_2G5)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_2G5)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     2500baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_1G)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_1G)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     1000baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_100M)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_1G_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     1000baseT_Half);
+
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_100M)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     100baseT_Full);
 
-	if (self->aq_nic_cfg.link_speed_msk  & AQ_NIC_RATE_10M)
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_100M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     100baseT_Half);
+
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_10M)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     10baseT_Full);
 
+	if (self->aq_nic_cfg.link_speed_msk & AQ_NIC_RATE_10M_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     10baseT_Half);
+
 	if (self->aq_nic_cfg.fc.cur & AQ_NIC_FC_RX)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     Pause);
@@ -1031,27 +1058,32 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 			      const struct ethtool_link_ksettings *cmd)
 {
-	u32 speed = 0U;
+	int fduplex = (cmd->base.duplex == DUPLEX_FULL);
+	u32 speed = cmd->base.speed;
 	u32 rate = 0U;
 	int err = 0;
 
+	if (!fduplex && speed > SPEED_1000) {
+		err = -EINVAL;
+		goto err_exit;
+	}
+
 	if (cmd->base.autoneg == AUTONEG_ENABLE) {
 		rate = self->aq_nic_cfg.aq_hw_caps->link_speed_msk;
 		self->aq_nic_cfg.is_autoneg = true;
 	} else {
-		speed = cmd->base.speed;
-
 		switch (speed) {
 		case SPEED_10:
-			rate = AQ_NIC_RATE_10M;
+			rate = fduplex ? AQ_NIC_RATE_10M : AQ_NIC_RATE_10M_HALF;
 			break;
 
 		case SPEED_100:
-			rate = AQ_NIC_RATE_100M;
+			rate = fduplex ? AQ_NIC_RATE_100M
+				       : AQ_NIC_RATE_100M_HALF;
 			break;
 
 		case SPEED_1000:
-			rate = AQ_NIC_RATE_1G;
+			rate = fduplex ? AQ_NIC_RATE_1G : AQ_NIC_RATE_1G_HALF;
 			break;
 
 		case SPEED_2500:
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 73c0f41df8d8..1d9dee4951f9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -704,6 +704,7 @@ int hw_atl_utils_mpi_get_link_status(struct aq_hw_s *self)
 			return -EBUSY;
 		}
 	}
+	link_status->full_duplex = true;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index eeedd8c90067..013676cd38e4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -274,6 +274,7 @@ static int aq_fw2x_update_link_status(struct aq_hw_s *self)
 	} else {
 		link_status->mbps = 0;
 	}
+	link_status->full_duplex = true;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 8df9d4ef36f0..239d077e21d7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -64,8 +64,11 @@ const struct aq_hw_caps_s hw_atl2_caps_aqc113 = {
 			  AQ_NIC_RATE_5G  |
 			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_1G_HALF   |
 			  AQ_NIC_RATE_100M      |
-			  AQ_NIC_RATE_10M,
+			  AQ_NIC_RATE_100M_HALF |
+			  AQ_NIC_RATE_10M       |
+			  AQ_NIC_RATE_10M_HALF,
 };
 
 static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index 0ffc33bd67d0..d64dfae8803e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -135,6 +135,10 @@ static void a2_link_speed_mask2fw(u32 speed,
 	link_options->rate_1G = !!(speed & AQ_NIC_RATE_1G);
 	link_options->rate_100M = !!(speed & AQ_NIC_RATE_100M);
 	link_options->rate_10M = !!(speed & AQ_NIC_RATE_10M);
+
+	link_options->rate_1G_hd = !!(speed & AQ_NIC_RATE_1G_HALF);
+	link_options->rate_100M_hd = !!(speed & AQ_NIC_RATE_100M_HALF);
+	link_options->rate_10M_hd = !!(speed & AQ_NIC_RATE_10M_HALF);
 }
 
 static int aq_a2_fw_set_link_speed(struct aq_hw_s *self, u32 speed)
@@ -202,6 +206,7 @@ static int aq_a2_fw_update_link_status(struct aq_hw_s *self)
 	default:
 		self->aq_link_status.mbps = 0;
 	}
+	self->aq_link_status.full_duplex = link_status.duplex;
 
 	return 0;
 }
-- 
2.25.1

