Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1487491A13
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343751AbiARC6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350897AbiARCwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97562C02C30A;
        Mon, 17 Jan 2022 18:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7290C612F3;
        Tue, 18 Jan 2022 02:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B151EC36AE3;
        Tue, 18 Jan 2022 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473799;
        bh=ND1OzIQ4qqHezNqKTpq1HofiiNOFrdx989O0rs0C+SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OY7xyKNwAHj7LXAXKoA5jkVgp+648FGNq50yI0LQ/jCx9DWVgirOIUDKOZyl8RWbk
         1w0j8nbUSrgujea2uoXez6OY6L6xWH8ZQvV1aShUoWg1+I5LpNb54uVQU/ftwbi6+9
         vbXFncRW/CNtlFxfr03BJs42mCQEEC8Tk0WlsQRquzRZEl12AYmVXwZwmsLLC1MOuI
         E9QPDlg3XafWMfN8ybZisuILhG5RrPAfluxtZlECNen3gt+dIFRJYiZcE0wjAsL9kR
         vf9eeSaWWy2QxisN5kpYmlX6ezGiEkyNc9cM3iVha6nXGucz7BdQMlBNef0bjCx9M/
         ACBrhLRBV1n7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 078/116] rtw88: 8822c: update rx settings to prevent potential hw deadlock
Date:   Mon, 17 Jan 2022 21:39:29 -0500
Message-Id: <20220118024007.1950576-78-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 565efd8806247..2ef1416899f03 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1652,7 +1652,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	/* default rx filter setting */
 	rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
-			  BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
+			  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
 			  BIT_AB | BIT_AM | BIT_APM;
 
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index bd01e82b6bcd0..8d1e8ff71d7ef 100644
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
index 22d0dd640ac94..dbfd67c3f598c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -204,7 +204,7 @@ static void rtw8822b_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
 			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 79ad6232dce83..cee586335552d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -1248,7 +1248,7 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 #define WLAN_MAC_INT_MIG_CFG		0x33330000
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
-- 
2.34.1

