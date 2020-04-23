Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAECD1B55AC
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgDWHa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:30:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55812 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:30:27 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jRWJP-0007Ua-IC; Thu, 23 Apr 2020 07:30:20 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] rtw88: Use udelay instead of usleep in atomic context
Date:   Thu, 23 Apr 2020 15:30:07 +0800
Message-Id: <20200423073007.3566-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423063811.2636-2-kai.heng.feng@canonical.com>
References: <20200423063811.2636-2-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's incorrect to use usleep in atomic context.

Switch to a macro which uses udelay instead of usleep to prevent the issue.

Fixes: 6343a6d4b213 ("rtw88: Add delay on polling h2c command status bit")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add Fixes tag.

 drivers/net/wireless/realtek/rtw88/fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 245da96dfddc..8f998b4a7234 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -228,9 +228,9 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		goto out;
 	}
 
-	ret = read_poll_timeout(rtw_read8, box_state,
-				!((box_state >> box) & 0x1), 100, 3000, false,
-				rtwdev, REG_HMETFR);
+	ret = read_poll_timeout_atomic(rtw_read8, box_state,
+				       !((box_state >> box) & 0x1), 100, 3000,
+				       false, rtwdev, REG_HMETFR);
 
 	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
-- 
2.17.1

