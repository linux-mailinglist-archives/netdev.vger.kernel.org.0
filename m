Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1E62B57AC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgKQDF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:05:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7548 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQDF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:05:56 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZrRR5svwzhYNC;
        Tue, 17 Nov 2020 11:05:39 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 17 Nov 2020 11:05:52 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <amitkarwar@gmail.com>, <siva8118@gmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] rsi_91x: fix error return code in rsi_reset_card()
Date:   Tue, 17 Nov 2020 11:07:34 +0800
Message-ID: <1605582454-39649-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 17ff2c794f39 ("rsi: reset device changes for 9116")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index a62d41c..00b5589 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -741,24 +741,24 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 		if (ret < 0)
 			goto fail;
 	} else {
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_INTERRUPT_TIMER,
-					      NWP_WWD_INT_TIMER_CLKS,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_INTERRUPT_TIMER,
+					       NWP_WWD_INT_TIMER_CLKS,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_SYSTEM_RESET_TIMER,
-					      NWP_WWD_SYS_RESET_TIMER_CLKS,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_SYSTEM_RESET_TIMER,
+					       NWP_WWD_SYS_RESET_TIMER_CLKS,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
-		if ((rsi_usb_master_reg_write(adapter,
-					      NWP_WWD_MODE_AND_RSTART,
-					      NWP_WWD_TIMER_DISABLE,
-					      RSI_9116_REG_SIZE)) < 0) {
+		ret = rsi_usb_master_reg_write(adapter,
+					       NWP_WWD_MODE_AND_RSTART,
+					       NWP_WWD_TIMER_DISABLE,
+					       RSI_9116_REG_SIZE);
+		if (ret < 0)
 			goto fail;
-		}
 	}
 
 	rsi_dbg(INFO_ZONE, "Reset card done\n");
-- 
2.9.5

