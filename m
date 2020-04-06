Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D40F19F2B0
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 11:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgDFJgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 05:36:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53751 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgDFJgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 05:36:38 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jLOB8-0002nT-Rr; Mon, 06 Apr 2020 09:36:27 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] rtw88: Add delay on polling h2c command status bit
Date:   Mon,  6 Apr 2020 17:36:22 +0800
Message-Id: <20200406093623.3980-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems we can constanly see rtw88 complains:
[39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command

Increase interval of each check to wait the status bit really changes.

While at it, add some helpers so we can use standarized
readx_poll_timeout() macro.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c  | 12 ++++++------
 drivers/net/wireless/realtek/rtw88/hci.h |  4 ++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 05c430b3489c..bc9982e77524 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/iopoll.h>
+
 #include "main.h"
 #include "coex.h"
 #include "fw.h"
@@ -193,8 +195,8 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 	u8 box;
 	u8 box_state;
 	u32 box_reg, box_ex_reg;
-	u32 h2c_wait;
 	int idx;
+	int ret;
 
 	rtw_dbg(rtwdev, RTW_DBG_FW,
 		"send H2C content %02x%02x%02x%02x %02x%02x%02x%02x\n",
@@ -226,12 +228,10 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		goto out;
 	}
 
-	h2c_wait = 20;
-	do {
-		box_state = rtw_read8(rtwdev, REG_HMETFR);
-	} while ((box_state >> box) & 0x1 && --h2c_wait > 0);
+	ret = readx_poll_timeout(rr8, REG_HMETFR, box_state,
+				 !((box_state >> box) & 0x1), 100, 3000);
 
-	if (!h2c_wait) {
+	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
 		goto out;
 	}
diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 2cba327e6218..24062c7079c6 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u8 data)
 	rtw_write8(rtwdev, addr, set);
 }
 
+#define rr8(addr)      rtw_read8(rtwdev, addr)
+#define rr16(addr)     rtw_read16(rtwdev, addr)
+#define rr32(addr)     rtw_read32(rtwdev, addr)
+
 static inline enum rtw_hci_type rtw_hci_type(struct rtw_dev *rtwdev)
 {
 	return rtwdev->hci.type;
-- 
2.17.1

