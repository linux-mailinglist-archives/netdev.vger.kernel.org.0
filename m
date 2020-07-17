Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9022454A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgGQUkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:40:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36794 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgGQUkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:40:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HKaVIH010633;
        Fri, 17 Jul 2020 13:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=+dWO9hNY1J6hvGwEiTahc52uAq14jPbHFenKvnhnr+g=;
 b=bqshqr4qWm8uCfg1UWy7r8y7Qy5Og4ifdqTHurn3aldRyBszlQNuk+j//nWIX2e0+5Qk
 LpIT6i7KFQrAbtmO/yvqjWI60ioInI6F4TO5H3XD+LuzRsOhg4ZgrDf6nTq+DuT9kRDK
 +Dcapeuafml0dLQQvw8hpkLTgJFxWnR+Ox3QK+EkVI5qjjfsXhwdOtdVDCRw2KaH4U+E
 fhzBrTeTPTtQe9bZm+3vlFraWz+KnXJj4uO1+K57TH5QnG92V3rkUTJq3OONd4B27yuw
 iWnJKNjPtK1R88HOS5BiDvX5wP8iRusSDUWJYUoFTcnm+Aq5RumUjBQmccI/keqFWjTW DQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7vev44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 13:40:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jul
 2020 13:40:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jul 2020 13:40:12 -0700
Received: from NN-LT0044.marvell.com (unknown [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 96FBA3F7043;
        Fri, 17 Jul 2020 13:40:09 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH net] net: atlantic: disable PTP on AQC111, AQC112
Date:   Fri, 17 Jul 2020 23:39:49 +0300
Message-ID: <20200717203949.9098-1-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

This patch disables PTP on AQC111 and AQC112 due to a known HW issue,
which can cause datapath issues.

Ideally PTP block should have been disabled via PHY provisioning, but
unfortunately many units have been shipped with enabled PTP block.
Thus, we have to work around this in the driver.

Fixes: dbcd6806af420 ("net: aquantia: add support for Phy access")
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  9 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 ++
 .../net/ethernet/aquantia/atlantic/aq_phy.c   | 29 +++++++++++++++++--
 .../net/ethernet/aquantia/atlantic/aq_phy.h   |  8 +++--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 19 ++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      | 10 +++----
 7 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index ed5b465bc664..992fedbe4ce3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -64,6 +64,7 @@ struct aq_hw_caps_s {
 	u8 rx_rings;
 	bool flow_control;
 	bool is_64_dma;
+	u32 quirks;
 	u32 priv_data_len;
 };
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 4435c6374f7e..7c7bf6bf163f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -415,6 +415,15 @@ int aq_nic_init(struct aq_nic_s *self)
 	    self->aq_nic_cfg.aq_hw_caps->media_type == AQ_HW_MEDIA_TYPE_TP) {
 		self->aq_hw->phy_id = HW_ATL_PHY_ID_MAX;
 		err = aq_phy_init(self->aq_hw);
+
+		/* Disable the PTP on NICs where it's known to cause datapath
+		 * problems.
+		 * Ideally this should have been done by PHY provisioning, but
+		 * many units have been shipped with enabled PTP block already.
+		 */
+		if (self->aq_nic_cfg.aq_hw_caps->quirks & AQ_NIC_QUIRK_BAD_PTP)
+			if (self->aq_hw->phy_id != HW_ATL_PHY_ID_MAX)
+				aq_phy_disable_ptp(self->aq_hw);
 	}
 
 	for (i = 0U; i < self->aq_vecs; i++) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 2ab003065e62..439ce9692dac 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -81,6 +81,8 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_NIC_FLAG_ERR_HW      0x80000000U
 
+#define AQ_NIC_QUIRK_BAD_PTP    BIT(0)
+
 #define AQ_NIC_WOL_MODES        (WAKE_MAGIC |\
 				 WAKE_PHY)
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_phy.c b/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
index 51ae921e3e1f..949ac2351701 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_phy.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* aQuantia Corporation Network Driver
- * Copyright (C) 2018-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2018-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 #include "aq_phy.h"
 
+#define HW_ATL_PTP_DISABLE_MSK	BIT(10)
+
 bool aq_mdio_busy_wait(struct aq_hw_s *aq_hw)
 {
 	int err = 0;
@@ -145,3 +149,24 @@ bool aq_phy_init(struct aq_hw_s *aq_hw)
 
 	return true;
 }
+
+void aq_phy_disable_ptp(struct aq_hw_s *aq_hw)
+{
+	static const u16 ptp_registers[] = {
+		0x031e,
+		0x031d,
+		0x031c,
+		0x031b,
+	};
+	u16 val;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptp_registers); i++) {
+		val = aq_phy_read_reg(aq_hw, MDIO_MMD_VEND1,
+				      ptp_registers[i]);
+
+		aq_phy_write_reg(aq_hw, MDIO_MMD_VEND1,
+				 ptp_registers[i],
+				 val & ~HW_ATL_PTP_DISABLE_MSK);
+	}
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_phy.h b/drivers/net/ethernet/aquantia/atlantic/aq_phy.h
index 84b72ad04a4a..86cc1ee836e2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_phy.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_phy.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* aQuantia Corporation Network Driver
- * Copyright (C) 2018-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2018-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 #ifndef AQ_PHY_H
@@ -29,4 +31,6 @@ bool aq_phy_init_phy_id(struct aq_hw_s *aq_hw);
 
 bool aq_phy_init(struct aq_hw_s *aq_hw);
 
+void aq_phy_disable_ptp(struct aq_hw_s *aq_hw);
+
 #endif /* AQ_PHY_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 14d79f70cad7..d2bc6b289a54 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -93,6 +93,25 @@ const struct aq_hw_caps_s hw_atl_b0_caps_aqc109 = {
 			  AQ_NIC_RATE_100M,
 };
 
+const struct aq_hw_caps_s hw_atl_b0_caps_aqc111 = {
+	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_5G |
+			  AQ_NIC_RATE_2G5 |
+			  AQ_NIC_RATE_1G |
+			  AQ_NIC_RATE_100M,
+	.quirks = AQ_NIC_QUIRK_BAD_PTP,
+};
+
+const struct aq_hw_caps_s hw_atl_b0_caps_aqc112 = {
+	DEFAULT_B0_BOARD_BASIC_CAPABILITIES,
+	.media_type = AQ_HW_MEDIA_TYPE_TP,
+	.link_speed_msk = AQ_NIC_RATE_2G5 |
+			  AQ_NIC_RATE_1G  |
+			  AQ_NIC_RATE_100M,
+	.quirks = AQ_NIC_QUIRK_BAD_PTP,
+};
+
 static int hw_atl_b0_hw_reset(struct aq_hw_s *self)
 {
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
index 30f468f2084d..16091af17980 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h
@@ -18,17 +18,15 @@ extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc100;
 extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc107;
 extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc108;
 extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc109;
-
-#define hw_atl_b0_caps_aqc111 hw_atl_b0_caps_aqc108
-#define hw_atl_b0_caps_aqc112 hw_atl_b0_caps_aqc109
+extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc111;
+extern const struct aq_hw_caps_s hw_atl_b0_caps_aqc112;
 
 #define hw_atl_b0_caps_aqc100s hw_atl_b0_caps_aqc100
 #define hw_atl_b0_caps_aqc107s hw_atl_b0_caps_aqc107
 #define hw_atl_b0_caps_aqc108s hw_atl_b0_caps_aqc108
 #define hw_atl_b0_caps_aqc109s hw_atl_b0_caps_aqc109
-
-#define hw_atl_b0_caps_aqc111s hw_atl_b0_caps_aqc108
-#define hw_atl_b0_caps_aqc112s hw_atl_b0_caps_aqc109
+#define hw_atl_b0_caps_aqc111s hw_atl_b0_caps_aqc111
+#define hw_atl_b0_caps_aqc112s hw_atl_b0_caps_aqc112
 
 extern const struct aq_hw_ops hw_atl_ops_b0;
 
-- 
2.25.1

