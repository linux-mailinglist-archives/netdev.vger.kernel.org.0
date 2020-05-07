Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51811C8496
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgEGIPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:54 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42786 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbgEGIPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478AhMK019767;
        Thu, 7 May 2020 01:15:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=veel1yTQXjlfKJyX2G3cOmlvvwxwN9VJFBvRhcH0MAQ=;
 b=vyAthd3X2M9lCyHLCJ0IDDDhCwh4TRkwwPQ30eTFiA1FgJUjgt1kY3dIIhViDeQs4nZ3
 JrUzgza1zMv+9kYhV5XbtR5hNvo0HtJ8TzRVV32XTXDJGSI8qPU5VB+FANsiPbPPNTXw
 7wWDpaLchtYx8k+Fmejgl3eX6gsBeCC2L41JW1I/CNS1DHWoKJ1nnnhbkxrn6DlqRod7
 ZBkKR33pdgJKShUGIuHew3bNgzXwvX6Huhk6zl0xVPtj8miZAg5K/7jllCZK2WGcysC3
 tjyTJ6phi8YDjaFrUBSH2ers7qiB/JmidPy4Z9U1GfoIU5AqW8ZrS0ZOtJ/lGhelebFH Ew== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaum1ark-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:39 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 2E7FD3F7048;
        Thu,  7 May 2020 01:15:36 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 7/7] net: atlantic: unify get_mac_permanent
Date:   Thu, 7 May 2020 11:15:10 +0300
Message-ID: <20200507081510.2120-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507081510.2120-1-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

MAC generation in case if MAC is not populated is the same for both A1 and
A2.
This patch moves MAC generation into a separate function, which is called
from both places to reduce the amount of copy/paste.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  | 41 +++++++++++++++++--
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |  9 ++--
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 23 +----------
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 24 ++---------
 4 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 7dbf49adcea6..0bc01772ead2 100644
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
@@ -79,3 +80,37 @@ int aq_hw_err_from_flags(struct aq_hw_s *hw)
 err_exit:
 	return err;
 }
+
+static inline bool aq_hw_is_zero_ether_addr(const u8 *addr)
+{
+	return (*(const u16 *)(addr) | addr[2]) == 0;
+}
+
+bool aq_hw_is_valid_ether_addr(const u8 *addr)
+{
+	return !is_multicast_ether_addr(addr) &&
+	       !aq_hw_is_zero_ether_addr(addr);
+}
+
+void aq_hw_eth_random_addr(u8 *mac)
+{
+	unsigned int rnd = 0;
+	u32 h = 0U;
+	u32 l = 0U;
+
+	get_random_bytes(&rnd, sizeof(unsigned int));
+
+	l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
+	h = 0x8001300EU;
+
+	mac[5] = (u8)(0xFFU & l);
+	l >>= 8;
+	mac[4] = (u8)(0xFFU & l);
+	l >>= 8;
+	mac[3] = (u8)(0xFFU & l);
+	l >>= 8;
+	mac[2] = (u8)(0xFFU & l);
+	mac[1] = (u8)(0xFFU & h);
+	h >>= 8;
+	mac[0] = (u8)(0xFFU & h);
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
index 9ef82d487e01..4753e3e301a3 100644
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
@@ -34,5 +35,7 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg);
 void aq_hw_write_reg(struct aq_hw_s *hw, u32 reg, u32 value);
 u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg);
 int aq_hw_err_from_flags(struct aq_hw_s *hw);
+bool aq_hw_is_valid_ether_addr(const u8 *addr);
+void aq_hw_eth_random_addr(u8 *addr);
 
 #endif /* AQ_HW_UTILS_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 017364486703..8a09e86b3990 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -283,8 +283,6 @@ static int aq_fw2x_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 	u32 efuse_addr = aq_hw_read_reg(self, HW_ATL_FW2X_MPI_EFUSE_ADDR);
 	u32 mac_addr[2] = { 0 };
 	int err = 0;
-	u32 h = 0U;
-	u32 l = 0U;
 
 	if (efuse_addr != 0) {
 		err = hw_atl_utils_fw_downld_dwords(self,
@@ -299,25 +297,8 @@ static int aq_fw2x_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 
 	ether_addr_copy(mac, (u8 *)mac_addr);
 
-	if ((mac[0] & 0x01U) || ((mac[0] | mac[1] | mac[2]) == 0x00U)) {
-		unsigned int rnd = 0;
-
-		get_random_bytes(&rnd, sizeof(unsigned int));
-
-		l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
-		h = 0x8001300EU;
-
-		mac[5] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[4] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[3] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[2] = (u8)(0xFFU & l);
-		mac[1] = (u8)(0xFFU & h);
-		h >>= 8;
-		mac[0] = (u8)(0xFFU & h);
-	}
+	if (!aq_hw_is_valid_ether_addr(mac))
+		aq_hw_eth_random_addr(mac);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index e8f4aad8c1e5..87f1133e6c39 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -6,6 +6,7 @@
 #include <linux/iopoll.h>
 
 #include "aq_hw.h"
+#include "aq_hw_utils.h"
 #include "hw_atl/hw_atl_llh.h"
 #include "hw_atl2_utils.h"
 #include "hw_atl2_llh.h"
@@ -212,27 +213,8 @@ static int aq_a2_fw_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 	hw_atl2_shared_buffer_get(self, mac_address, mac_address);
 	ether_addr_copy(mac, (u8 *)mac_address.aligned.mac_address);
 
-	if ((mac[0] & 0x01U) || ((mac[0] | mac[1] | mac[2]) == 0x00U)) {
-		unsigned int rnd = 0;
-		u32 h;
-		u32 l;
-
-		get_random_bytes(&rnd, sizeof(unsigned int));
-
-		l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
-		h = 0x8001300EU;
-
-		mac[5] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[4] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[3] = (u8)(0xFFU & l);
-		l >>= 8;
-		mac[2] = (u8)(0xFFU & l);
-		mac[1] = (u8)(0xFFU & h);
-		h >>= 8;
-		mac[0] = (u8)(0xFFU & h);
-	}
+	if (!aq_hw_is_valid_ether_addr(mac))
+		aq_hw_eth_random_addr(mac);
 
 	return 0;
 }
-- 
2.20.1

