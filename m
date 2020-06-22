Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08A5203A06
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgFVOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729157AbgFVOxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEYq9O032123;
        Mon, 22 Jun 2020 07:53:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HeLOubb7Hr8QM9LSiRgpF2w/ojrG8qUEEGsfIAuD88M=;
 b=A4pLyaVDZRqnBSqzTCdR0jnYOI3J38hAf0DtxkUMLqrV4yc3hPoZcDTQraI9JaA5dlr/
 B+I1EbfV3kts3ZnWr8Bhzq8OtZ5x3S+mBfmbs5yJUaI4DVP4TMiK+XRsAF7hxmpU2B9h
 hnuRiP7jrdeq8U/tZrGM73NR3NOrlFCCM6xBdHfr62e7fjz5hgIWYsC0mpNnjeotAP/F
 +a1ghPcuyWqHZzX93Q+mvXdj43cmxGgaNCZQSykaswl5FzwzQWJNxyXNTIQARYRMpqnU
 RSild2n+41VfAQIrCjHZU+Q4GWzapaNzjHrthaNg5D4uML+OK5NgMksQzJKMheYf42fJ Sw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftph23p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:20 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 829973F703F;
        Mon, 22 Jun 2020 07:53:18 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 3/6] net: atlantic: A2: EEE support
Date:   Mon, 22 Jun 2020 17:53:06 +0300
Message-ID: <20200622145309.455-4-irusskikh@marvell.com>
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

From: Nikita Danilov <ndanilov@marvell.com>

This patch adds EEE support on A2.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Co-developed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_common.h    |  5 ++
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 11 +--
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 80 +++++++++++++++++++
 3 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 1587528ca3f6..23b2d390fcdd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -67,5 +67,10 @@
 #define AQ_NIC_RATE_EEE_2G5	BIT(12)
 #define AQ_NIC_RATE_EEE_1G	BIT(13)
 #define AQ_NIC_RATE_EEE_100M	BIT(14)
+#define AQ_NIC_RATE_EEE_MSK     (AQ_NIC_RATE_EEE_10G |\
+				 AQ_NIC_RATE_EEE_5G |\
+				 AQ_NIC_RATE_EEE_2G5 |\
+				 AQ_NIC_RATE_EEE_1G |\
+				 AQ_NIC_RATE_EEE_100M)
 
 #endif /* AQ_COMMON_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index ffcdda70265b..8225187eeef2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_ethtool.c: Definition of ethertool related functions. */
@@ -611,7 +612,7 @@ static int aq_ethtool_get_ts_info(struct net_device *ndev,
 	return 0;
 }
 
-static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
+static u32 eee_mask_to_ethtool_mask(u32 speed)
 {
 	u32 rate = 0;
 
@@ -653,7 +654,7 @@ static int aq_ethtool_get_eee(struct net_device *ndev, struct ethtool_eee *eee)
 	eee->eee_enabled = !!eee->advertised;
 
 	eee->tx_lpi_enabled = eee->eee_enabled;
-	if (eee->advertised & eee->lp_advertised)
+	if ((supported_rates & rate) & AQ_NIC_RATE_EEE_MSK)
 		eee->eee_active = true;
 
 	return 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index d64dfae8803e..9216517f6e65 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -7,6 +7,7 @@
 
 #include "aq_hw.h"
 #include "aq_hw_utils.h"
+#include "aq_nic.h"
 #include "hw_atl/hw_atl_llh.h"
 #include "hw_atl2_utils.h"
 #include "hw_atl2_llh.h"
@@ -141,6 +142,42 @@ static void a2_link_speed_mask2fw(u32 speed,
 	link_options->rate_10M_hd = !!(speed & AQ_NIC_RATE_10M_HALF);
 }
 
+static u32 a2_fw_dev_to_eee_mask(struct device_link_caps_s *device_link_caps)
+{
+	u32 rate = 0;
+
+	if (device_link_caps->eee_10G)
+		rate |= AQ_NIC_RATE_EEE_10G;
+	if (device_link_caps->eee_5G)
+		rate |= AQ_NIC_RATE_EEE_5G;
+	if (device_link_caps->eee_2P5G)
+		rate |= AQ_NIC_RATE_EEE_2G5;
+	if (device_link_caps->eee_1G)
+		rate |= AQ_NIC_RATE_EEE_1G;
+	if (device_link_caps->eee_100M)
+		rate |= AQ_NIC_RATE_EEE_100M;
+
+	return rate;
+}
+
+static u32 a2_fw_lkp_to_mask(struct lkp_link_caps_s *lkp_link_caps)
+{
+	u32 rate = 0;
+
+	if (lkp_link_caps->eee_10G)
+		rate |= AQ_NIC_RATE_EEE_10G;
+	if (lkp_link_caps->eee_5G)
+		rate |= AQ_NIC_RATE_EEE_5G;
+	if (lkp_link_caps->eee_2P5G)
+		rate |= AQ_NIC_RATE_EEE_2G5;
+	if (lkp_link_caps->eee_1G)
+		rate |= AQ_NIC_RATE_EEE_1G;
+	if (lkp_link_caps->eee_100M)
+		rate |= AQ_NIC_RATE_EEE_100M;
+
+	return rate;
+}
+
 static int aq_a2_fw_set_link_speed(struct aq_hw_s *self, u32 speed)
 {
 	struct link_options_s link_options;
@@ -153,6 +190,17 @@ static int aq_a2_fw_set_link_speed(struct aq_hw_s *self, u32 speed)
 	return hw_atl2_shared_buffer_finish_ack(self);
 }
 
+static void aq_a2_fw_upd_eee_rate_bits(struct aq_hw_s *self,
+				       struct link_options_s *link_options,
+				       u32 eee_speeds)
+{
+	link_options->eee_10G =  !!(eee_speeds & AQ_NIC_RATE_EEE_10G);
+	link_options->eee_5G = !!(eee_speeds & AQ_NIC_RATE_EEE_5G);
+	link_options->eee_2P5G = !!(eee_speeds & AQ_NIC_RATE_EEE_2G5);
+	link_options->eee_1G = !!(eee_speeds & AQ_NIC_RATE_EEE_1G);
+	link_options->eee_100M = !!(eee_speeds & AQ_NIC_RATE_EEE_100M);
+}
+
 static int aq_a2_fw_set_state(struct aq_hw_s *self,
 			      enum hal_atl_utils_fw_state_e state)
 {
@@ -163,6 +211,8 @@ static int aq_a2_fw_set_state(struct aq_hw_s *self,
 	switch (state) {
 	case MPI_INIT:
 		link_options.link_up = 1U;
+		aq_a2_fw_upd_eee_rate_bits(self, &link_options,
+					   self->aq_nic_cfg->eee_speeds);
 		break;
 	case MPI_DEINIT:
 		link_options.link_up = 0U;
@@ -265,6 +315,34 @@ static int aq_a2_fw_update_stats(struct aq_hw_s *self)
 	return 0;
 }
 
+static int aq_a2_fw_set_eee_rate(struct aq_hw_s *self, u32 speed)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+
+	aq_a2_fw_upd_eee_rate_bits(self, &link_options, speed);
+
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static int aq_a2_fw_get_eee_rate(struct aq_hw_s *self, u32 *rate,
+				 u32 *supported_rates)
+{
+	struct device_link_caps_s device_link_caps;
+	struct lkp_link_caps_s lkp_link_caps;
+
+	hw_atl2_shared_buffer_read(self, device_link_caps, device_link_caps);
+	hw_atl2_shared_buffer_read(self, lkp_link_caps, lkp_link_caps);
+
+	*supported_rates = a2_fw_dev_to_eee_mask(&device_link_caps);
+	*rate = a2_fw_lkp_to_mask(&lkp_link_caps);
+
+	return 0;
+}
+
 static int aq_a2_fw_renegotiate(struct aq_hw_s *self)
 {
 	struct link_options_s link_options;
@@ -322,4 +400,6 @@ const struct aq_fw_ops aq_a2_fw_ops = {
 	.set_state          = aq_a2_fw_set_state,
 	.update_link_status = aq_a2_fw_update_link_status,
 	.update_stats       = aq_a2_fw_update_stats,
+	.set_eee_rate       = aq_a2_fw_set_eee_rate,
+	.get_eee_rate       = aq_a2_fw_get_eee_rate,
 };
-- 
2.25.1

