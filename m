Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02789411452
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbhITMZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235204AbhITMZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:25:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC6A60F58;
        Mon, 20 Sep 2021 12:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632140645;
        bh=QAFA1wMFi/Pt4kxfmYpb2lbYqcOVrXCfBWOndEjPAec=;
        h=From:To:Cc:Subject:Date:From;
        b=KNmdjrKewHJ7XmsH64GBGGbmuCbR9yFQsMo5kVFKh7gos0w4bh4CnC4ceeFYThhy6
         p7QXI1HcpmIhmILsF51Km2dgWxLHy88eZHnqxWzyLMSk2/iGj+Vj4Gfxvs+zQLwLMa
         ssgWJuICSY0zJVQsn3rYmcm+I1tMgzlx1G8ez1EKTWN1xd/XgcFK+2IKqauengYrq6
         POlT0HCl9zqiCfZyq8zCmLDvHMU9EWhRBIcN4O8nAMAGqpph3cgsDNKuthDjdO0Rqv
         Z5wixoL3kGZarkZMeyxtWFJmKDX8V4HB+Hlb46Amhp9E/FGtNjeK9rHglHbYGHiSea
         ZJREI+jT7XGDA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] ath5k: fix building with LEDS=m
Date:   Mon, 20 Sep 2021 14:23:44 +0200
Message-Id: <20210920122359.353810-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Randconfig builds still show a failure for the ath5k driver,
similar to the one that was fixed for ath9k earlier:

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
  Selected by [m]:
  - ATH5K [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && (PCI [=y] || ATH25) && MAC80211 [=y]
net/mac80211/led.c: In function 'ieee80211_alloc_led_names':
net/mac80211/led.c:34:22: error: 'struct led_trigger' has no member named 'name'
   34 |         local->rx_led.name = kasprintf(GFP_KERNEL, "%srx",
      |                      ^

Copying the same logic from my ath9k patch makes this one work
as well, stubbing out the calls to the LED subsystem.

Fixes: b64acb28da83 ("ath9k: fix build error with LEDS_CLASS=m")
Fixes: 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by default")
Fixes: 3a078876caee ("ath5k: convert LED code to use mac80211 triggers")
Link: https://lore.kernel.org/all/20210722105501.1000781-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
- avoid link failure when NEW_LEDS is disabled
---
 drivers/net/wireless/ath/ath5k/Kconfig |  4 +---
 drivers/net/wireless/ath/ath5k/led.c   | 10 ++++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index f35cd8de228e..6914b37bb0fb 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -3,9 +3,7 @@ config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on (PCI || ATH25) && MAC80211
 	select ATH_COMMON
-	select MAC80211_LEDS
-	select LEDS_CLASS
-	select NEW_LEDS
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH5K_AHB if ATH25
 	select ATH5K_PCI if !ATH25
 	help
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 6a2a16856763..33e9928af363 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -89,7 +89,8 @@ static const struct pci_device_id ath5k_led_devices[] = {
 
 void ath5k_led_enable(struct ath5k_hw *ah)
 {
-	if (test_bit(ATH_STAT_LEDSOFT, ah->status)) {
+	if (IS_ENABLED(CONFIG_MAC80211_LEDS) &&
+	    test_bit(ATH_STAT_LEDSOFT, ah->status)) {
 		ath5k_hw_set_gpio_output(ah, ah->led_pin);
 		ath5k_led_off(ah);
 	}
@@ -104,7 +105,8 @@ static void ath5k_led_on(struct ath5k_hw *ah)
 
 void ath5k_led_off(struct ath5k_hw *ah)
 {
-	if (!test_bit(ATH_STAT_LEDSOFT, ah->status))
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) ||
+	    !test_bit(ATH_STAT_LEDSOFT, ah->status))
 		return;
 	ath5k_hw_set_gpio(ah, ah->led_pin, !ah->led_on);
 }
@@ -146,7 +148,7 @@ ath5k_register_led(struct ath5k_hw *ah, struct ath5k_led *led,
 static void
 ath5k_unregister_led(struct ath5k_led *led)
 {
-	if (!led->ah)
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) || !led->ah)
 		return;
 	led_classdev_unregister(&led->led_dev);
 	ath5k_led_off(led->ah);
@@ -169,7 +171,7 @@ int ath5k_init_leds(struct ath5k_hw *ah)
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
-	if (!ah->pdev)
+	if (!IS_ENABLED(CONFIG_MAC80211_LEDS) || !ah->pdev)
 		return 0;
 
 #ifdef CONFIG_ATH5K_AHB
-- 
2.29.2

