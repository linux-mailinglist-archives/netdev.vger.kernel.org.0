Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312EF25AC95
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgIBOJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:09:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60938 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726928AbgIBOJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 10:09:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 167854F4ABFBBC0CE5F6;
        Wed,  2 Sep 2020 22:09:03 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Sep 2020
 22:08:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mwifiex: wmm: Fix -Wunused-const-variable warnings
Date:   Wed, 2 Sep 2020 22:08:46 +0800
Message-ID: <20200902140846.29024-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file included from drivers/net/wireless/marvell/mwifiex//cmdevt.c:26:0:
drivers/net/wireless/marvell/mwifiex//wmm.h:41:17: warning: ‘tos_to_tid_inv’ defined but not used [-Wunused-const-variable=]
 static const u8 tos_to_tid_inv[] = {
                 ^~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex//wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
 static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
                  ^~~~~~~~~~~~~~~~~~~~~~~

move the variables definition to .c file, and leave declarations
in the header file to fix these warnings.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c |  2 ++
 drivers/net/wireless/marvell/mwifiex/wmm.c  | 15 +++++++++++++++
 drivers/net/wireless/marvell/mwifiex/wmm.h  | 18 ++----------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 9ee5600351a7..9ba8a8f64976 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -48,6 +48,8 @@ bool aggr_ctrl;
 module_param(aggr_ctrl, bool, 0000);
 MODULE_PARM_DESC(aggr_ctrl, "usb tx aggregation enable:1, disable:0");
 
+const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
+
 /*
  * This function registers the device and performs all the necessary
  * initializations.
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index a06fff199ea3..b8f19ca73414 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -40,6 +40,21 @@
 static bool disable_tx_amsdu;
 module_param(disable_tx_amsdu, bool, 0644);
 
+/* This table inverses the tos_to_tid operation to get a priority
+ * which is in sequential order, and can be compared.
+ * Use this to compare the priority of two different TIDs.
+ */
+const u8 tos_to_tid_inv[] = {
+	0x02,  /* from tos_to_tid[2] = 0 */
+	0x00,  /* from tos_to_tid[0] = 1 */
+	0x01,  /* from tos_to_tid[1] = 2 */
+	0x03,
+	0x04,
+	0x05,
+	0x06,
+	0x07
+};
+
 /* WMM information IE */
 static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
 	0x00, 0x50, 0xf2, 0x02,
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.h b/drivers/net/wireless/marvell/mwifiex/wmm.h
index 04d7da95e307..1cb3d1804758 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.h
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.h
@@ -31,22 +31,8 @@ enum ieee_types_wmm_ecw_bitmasks {
 	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
 };
 
-static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
-
-/*
- * This table inverses the tos_to_tid operation to get a priority
- * which is in sequential order, and can be compared.
- * Use this to compare the priority of two different TIDs.
- */
-static const u8 tos_to_tid_inv[] = {
-	0x02,  /* from tos_to_tid[2] = 0 */
-	0x00,  /* from tos_to_tid[0] = 1 */
-	0x01,  /* from tos_to_tid[1] = 2 */
-	0x03,
-	0x04,
-	0x05,
-	0x06,
-	0x07};
+extern const u16 mwifiex_1d_to_wmm_queue[];
+extern const u8 tos_to_tid_inv[];
 
 /*
  * This function retrieves the TID of the given RA list.
-- 
2.17.1


