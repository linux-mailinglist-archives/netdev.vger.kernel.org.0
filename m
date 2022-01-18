Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD85A49164B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbiARCcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244507AbiARC2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:28:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E10F611EC;
        Tue, 18 Jan 2022 02:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F26CC36AF4;
        Tue, 18 Jan 2022 02:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472909;
        bh=3+demyXxz1HqrShCU0iSOzn9gxlNu+2vJqtRcEcN270=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkUYOx/EEMVk+bmSYHiGEF0KYI6NC4BSI+5oRsjKLqzGmCwUmTc5PZmJuOHcE7gpk
         1sWtKpYm9LEm55DU612yxsQvYl2Tsj6OqszJvK71AKE4Sas8yTvaSLW1Qo9f+qXH8t
         fZ1TuNl2JZOs+rYcFNTwRuYnOQL4v9pg4Gqr+jphYIJeWNsOFoky/Ws+ovG84CRvD9
         K+CKO2ZgTsQs9kPw+Ou4NbdMlj2DQN3jNkKv+venIldMeVG8hhVKKCkx7ElbrmgFFV
         mBn3ZH6cUixYJ3mZEWDgIzrlr4M64qj5QP8E08fMU2Tx/77HjQk0psgqW3IWOGO7Ef
         EzWBHQxWJWKsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 161/217] rtw88: 8822c: update rx settings to prevent potential hw deadlock
Date:   Mon, 17 Jan 2022 21:18:44 -0500
Message-Id: <20220118021940.1942199-161-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit c1afb26727d9e507d3e17a9890e7aaf7fc85cd55 ]

These settings enables mac to detect and recover when rx fifo
circuit deadlock occurs. Previous version missed this, so we fix it.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211217012708.8623-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c     | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a0d4d6e31fb49..dbf1ce3daeb8e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1868,7 +1868,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	/* default rx filter setting */
 	rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
-			  BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
+			  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
 			  BIT_AB | BIT_AM | BIT_APM;
 
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 112faa60f653e..d9fbddd7b0f35 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -131,7 +131,7 @@ _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
 			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index c409c8c29ec8b..e870ad7518342 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -205,7 +205,7 @@ static void rtw8822b_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
 			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 46b881e8e4feb..0e1c5d95d4649 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -1962,7 +1962,7 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 #define WLAN_MAC_INT_MIG_CFG		0x33330000
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
-- 
2.34.1

