Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3201A085C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 09:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgDGHdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 03:33:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36949 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGHdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 03:33:42 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jLijo-00029a-4E; Tue, 07 Apr 2020 07:33:36 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] rtw88: Add delay on polling h2c command status bit
Date:   Tue,  7 Apr 2020 15:33:31 +0800
Message-Id: <20200407073331.397-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems we can constanly see rtw88 complains:
[39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command

Increase interval of each check to wait the status bit really changed.

Use read_poll_timeout() macro which fits anything we need here.

Suggested-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
- Use read_poll_timeout macro.

 drivers/net/wireless/realtek/rtw88/fw.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 05c430b3489c..8508b83d98ed 100644
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
@@ -226,12 +228,11 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		goto out;
 	}
 
-	h2c_wait = 20;
-	do {
-		box_state = rtw_read8(rtwdev, REG_HMETFR);
-	} while ((box_state >> box) & 0x1 && --h2c_wait > 0);
+	ret = read_poll_timeout(rtw_read8, box_state,
+				!((box_state >> box) & 0x1), 100, 3000, false,
+				rtwdev, REG_HMETFR);
 
-	if (!h2c_wait) {
+	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
 		goto out;
 	}
-- 
2.17.1

