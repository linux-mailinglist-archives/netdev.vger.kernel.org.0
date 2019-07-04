Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8015F6DE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfGDKzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:55:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39146 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfGDKzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 06:55:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so2268128pgi.6
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 03:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFkhCc619vRd94uoe7aHJSBMFEl+zNjNnFnyvCKwJS0=;
        b=QjuddBdT3mG9W3uWDvKTXBPIOLTcSFsfepx1jK2sznc1aG6YJkBmHbP+BsddK1cqr1
         lfAS53bpdUpcra2w7BKad2vDOuh/obpSEYT4QwKuKbXr+XwQRj5DejtAClEcHInc7bJ5
         wDhMvcZj2LuRhZViyKpcs4Y+eTTOw89Bo6VKmTjlMvKmsrh8N9yE+bzGpz8e+nW2TUaL
         9sPBD+us9WHl3Y6g+GydcriY2ya1U0KWpXbTTn3MVPjn1x1LiXAlmzzK6vc7bFUhrJx7
         u666QJY8Ppoyaj3tQSJzarTiql3uQng0hs5n/o4X5EZWazShxbTgeDz+ZCKNE1H0ffMd
         OVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFkhCc619vRd94uoe7aHJSBMFEl+zNjNnFnyvCKwJS0=;
        b=AnPrS675Exp5NOrGMTjjL5CwYNEhGAUa/YJmsVzzOX0KJ8HUjo5dfB/ha2fcW2a7JO
         hkytW9LHGUIEtpsxiqvV1HZl54sJ9WaL8e9sb3GmlRF98KP7Z4wZsTZWw24SBWZ+gxw1
         czOj0iZcy/xldcTcKbYi1iMq4z1tJqp57IAXVg1x8Qml25GyrQ+XhoGBH8hXbBaP6nGZ
         FHrQSVaHKvBzcfm7bCKH+/ddbjkqI+js84mtmQ9uFH/Y2HPEZwtuDC0UPoTWdhbFX0Xk
         M52XHc9ypjVmRUZWAdTB1X3Xxs0F7unNYAR0v0lPe4HYF+fWSIxsoZmra+Fu80oftJCa
         l7+w==
X-Gm-Message-State: APjAAAWFpAB/dgBcLgoP8Zmo3ruqCd61qSoX04bGm3R9Tk0ujDTgA2WX
        eR4jdtink8q90rF8QctqXN6SfQ==
X-Google-Smtp-Source: APXvYqz5o52E88f0jIRgzlTBYcftTP9a6vzhxvfuOSWu42Tgt4yPhyIirW2xi948NDsJcJHMStf+3A==
X-Received: by 2002:a17:90a:a407:: with SMTP id y7mr18979498pjp.97.1562237738664;
        Thu, 04 Jul 2019 03:55:38 -0700 (PDT)
Received: from localhost.localdomain (220-133-8-232.HINET-IP.hinet.net. [220.133.8.232])
        by smtp.gmail.com with ESMTPSA id k22sm5562533pfk.157.2019.07.04.03.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 03:55:38 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     jes.sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
Date:   Thu,  4 Jul 2019 18:55:28 +0800
Message-Id: <20190704105528.74028-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WiFi tx power of RTL8723BU is extremely low after booting. So
the WiFi scan gives very limited AP list and it always fails to
connect to the selected AP. This module only supports 1x1 antenna
and the antenna is switched to bluetooth due to some incorrect
register settings.

Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
we realized that the 8723bu's enable_rf() does the same thing as
rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
sets the antenna path to BTC_ANT_PATH_BT which we verified it's
the cause of the wifi weak tx power. The vendor driver will set
the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
mechanism, by the function halbtc8723b1ant_PsTdma.

This commit hand over the antenna control to PTA(Packet Traffic
Arbitration), which compares the weight of bluetooth/wifi traffic
then determine whether to continue current wifi traffic or not.
After PTA take control, The wifi signal will be back to normal and
the bluetooth scan can also work at the same time. However, the
btcoexist still needs to be handled under different circumstances.
If there's a BT connection established, the wifi still fails to
connect until BT disconnected.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---


Note:
 v2:
  - Replace BIT(11) with the descriptive definition
  - Meaningful comment for the REG_S0S1_PATH_SWITCH setting


 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 11 ++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 3adb1d3d47ac..ceffe05bd65b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	/*
 	 * WLAN action by PTA
 	 */
-	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
+	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
 
 	/*
 	 * BT select S0/S1 controlled by WiFi
@@ -1568,9 +1568,14 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
 
 	/*
-	 * 0x280, 0x00, 0x200, 0x80 - not clear
+	 * Different settings per different antenna position.
+	 *      Antenna Position:   | Normal   Inverse
+	 * --------------------------------------------------
+	 * Antenna switch to BT:    |  0x280,   0x00
+	 * Antenna switch to WiFi:  |  0x0,     0x280
+	 * Antenna switch to PTA:   |  0x200,   0x80
 	 */
-	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
+	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
 
 	/*
 	 * Software control, antenna at WiFi side
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 8136e268b4e6..c6c41fb962ff 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	/* Check if MAC is already powered on */
 	val8 = rtl8xxxu_read8(priv, REG_CR);
+	val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
 
 	/*
 	 * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
 	 * initialized. First MAC returns 0xea, second MAC returns 0x00
 	 */
-	if (val8 == 0xea)
+	if (val8 == 0xea || !(val16 & SYS_CLK_MAC_CLK_ENABLE))
 		macpower = false;
 	else
 		macpower = true;
-- 
2.11.0

