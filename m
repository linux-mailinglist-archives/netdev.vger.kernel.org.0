Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB221D530
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgGMLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728714AbgGMLnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBfkiv014168;
        Mon, 13 Jul 2020 04:43:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=dfyTwREfWmeugenuiKZjG5rqEWVH187t4WQVFVHod4k=;
 b=LdqcaQU2znQ6gcPEWtr+OZC0dn+3DbRZCw8elzFVzwXFy/+hF7WJY9uMbaS1b2XVpVkz
 l25IAkuA4zkqyOjKhhgsQXpwZlnN+uYv1G46qZ15dy5CEUtadp+mJjTbdd4XxnHvBByk
 jhdiVBv5+swVZ/003YN9L+eCxRbkaTLuePwcPiYCjZ0fDZoX0ZuBu/opnJu59/Awc5Vd
 HPZ7V5qvNUVfseY7BeZmMdMPs8TWm+lIeU3nygScdzqIR/yav6ZH86f4egbYRd2K7Qr8
 HWK/wlX1xGJbO+y0EhxvgI3R4UIXCKFmvbwoc2+uuOOCshCA1gqqHU8AXrNJjnGyn+Q0 Qg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhgfhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:43:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:43:03 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 7FE793F703F;
        Mon, 13 Jul 2020 04:43:00 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Belous <pbelous@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 06/10] net: atlantic: add support for 64-bit reads/writes
Date:   Mon, 13 Jul 2020 14:42:29 +0300
Message-ID: <20200713114233.436-7-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

This patch adds support for 64-bit reads/writes where applicable, e.g.
A2 supports them.

Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  1 +
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  | 35 ++++++++++++++++---
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |  8 +++--
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  1 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  1 +
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  1 +
 6 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 9505918f252c..31606f512e05 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -67,6 +67,7 @@ struct aq_hw_caps_s {
 	u8 rx_rings;
 	bool flow_control;
 	bool is_64_dma;
+	bool op64bit;
 	u32 priv_data_len;
 };
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 342c5179f846..0172d2206685 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_hw_utils.c: Definitions of helper functions used across
@@ -56,13 +57,37 @@ void aq_hw_write_reg(struct aq_hw_s *hw, u32 reg, u32 value)
  */
 u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg)
 {
-	u64 value = aq_hw_read_reg(hw, reg);
+	u64 value = U64_MAX;
+#ifdef CONFIG_X86_64
+	if (hw->aq_nic_cfg->aq_hw_caps->op64bit)
+		value = readq(hw->mmio + reg);
+	else
+#endif
+	{
+		value = aq_hw_read_reg(hw, reg);
+		value |= (u64)aq_hw_read_reg(hw, reg + 4) << 32;
+	}
 
-	value |= (u64)aq_hw_read_reg(hw, reg + 4) << 32;
+	if (value == U64_MAX &&
+	    readl(hw->mmio + hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr) == U32_MAX)
+		aq_utils_obj_set(&hw->flags, AQ_HW_FLAG_ERR_UNPLUG);
 
 	return value;
 }
 
+void aq_hw_write_reg64(struct aq_hw_s *hw, u32 reg, u64 value)
+{
+#ifdef CONFIG_X86_64
+	if (hw->aq_nic_cfg->aq_hw_caps->op64bit)
+		writeq(value, hw->mmio + reg);
+	else
+#endif
+	{
+		writel(lower_32_bits(value), hw->mmio + reg);
+		writel(upper_32_bits(value), hw->mmio + reg + sizeof(u32));
+	}
+}
+
 int aq_hw_err_from_flags(struct aq_hw_s *hw)
 {
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
index 32aa5f2fb840..ffa6e4067c21 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_hw_utils.h: Declaration of helper functions used across hardware
@@ -33,6 +34,7 @@ u32 aq_hw_read_reg_bit(struct aq_hw_s *aq_hw, u32 addr, u32 msk, u32 shift);
 u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg);
 void aq_hw_write_reg(struct aq_hw_s *hw, u32 reg, u32 value);
 u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg);
+void aq_hw_write_reg64(struct aq_hw_s *hw, u32 reg, u64 value);
 int aq_hw_err_from_flags(struct aq_hw_s *hw);
 int aq_hw_num_tcs(struct aq_hw_s *hw);
 int aq_hw_q_per_tc(struct aq_hw_s *hw);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index a312864969af..8f8b90436ced 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -18,6 +18,7 @@
 
 #define DEFAULT_A0_BOARD_BASIC_CAPABILITIES \
 	.is_64_dma = true,		  \
+	.op64bit = false,		  \
 	.msix_irqs = 4U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL_A0_RSS_MAX,	  \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 51c8962b7a0e..ee74cad4a168 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -20,6 +20,7 @@
 
 #define DEFAULT_B0_BOARD_BASIC_CAPABILITIES \
 	.is_64_dma = true,		  \
+	.op64bit = false,		  \
 	.msix_irqs = 8U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL_B0_RSS_MAX,	  \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index c65e6daad0e5..92f64048bf69 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -21,6 +21,7 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 
 #define DEFAULT_BOARD_BASIC_CAPABILITIES \
 	.is_64_dma = true,		  \
+	.op64bit = true,		  \
 	.msix_irqs = 8U,		  \
 	.irq_mask = ~0U,		  \
 	.vecs = HW_ATL2_RSS_MAX,	  \
-- 
2.17.1

