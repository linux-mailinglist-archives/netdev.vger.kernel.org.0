Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5748E2E3189
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 15:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL0ObX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 09:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgL0ObX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 09:31:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 406B022512;
        Sun, 27 Dec 2020 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609079441;
        bh=O2sX8uZjt9scSCcmIw+t7xT09iHcoofo83upKVoPSqo=;
        h=From:To:Cc:Subject:Date:From;
        b=t2yK7i4xhrs/eLYEkhJ7axAvoZeA4PSCfWGFxBLG8J+S6gAOHJGh/KExnILExpSWy
         axC3xOFfmxk5Uo49YKyaUIyMwp6NdkWlk6f+HnlQrSY9XiBZht63jumWFGuCWcTObn
         3XribF+9ZvvgwGSEKMVYzfTBxxfbgbh6f/Au9+VzL0ACWtCCmD9IFHpDpvavrVM/0V
         JALlpyobV5w1C13+Ezcnwi8YJ4ZfEsNWB5t0BRRaZVsKERnra8NKRi7No0uFpR8005
         onoULhVJoHYU4JLBTd4WiopaVez/79gHi9aXKPJc652NWXNYrH0Vf0gg2EzeSkaVDn
         IGb95dTp25lmg==
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ath9k: Add separate entry for LED triggers to fix module builds
Date:   Sun, 27 Dec 2020 15:30:34 +0100
Message-Id: <20201227143034.1134829-1-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by
default") a configuration like:
 - MAC80211_LEDS=y
 - LEDS_CLASS=m
 - NEW_LEDS=y
 - ATH9K=y
leads to a build failure:

    /usr/bin/ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
    drivers/net/wireless/ath/ath9k/gpio.c:69: undefined reference to `led_classdev_unregister'
    /usr/bin/ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `led_classdev_register':
    include/linux/leds.h:190: undefined reference to `led_classdev_register_ext'

To be able to use LED triggers, the LEDS_CLASS can only be a module
if ath9k driver is a module as well.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by default")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig        | 18 ++++++++++++------
 drivers/net/wireless/ath/ath9k/ath9k.h        |  4 ++--
 drivers/net/wireless/ath/ath9k/gpio.c         |  2 +-
 drivers/net/wireless/ath/ath9k/htc.h          |  6 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/init.c         |  4 ++--
 8 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index a84bb9b6573f..6193dd4d85f0 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -23,9 +23,6 @@ config ATH9K
 	depends on MAC80211 && HAS_DMA
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
@@ -38,6 +35,18 @@ config ATH9K
 
 	  If you choose to build a module, it'll be called ath9k.
 
+config ATH9K_LEDS
+	bool "Atheros ath9k LED triggers"
+	default y
+	depends on ATH9K || ATH9K_HTC
+	depends on NEW_LEDS
+	select LEDS_CLASS
+	select MAC80211_LEDS
+	help
+	  This option enables a few LED triggers for different
+	  packet receive/transmit events on Atheros family
+	  of wireless cards (PCI and HTC).
+
 config ATH9K_PCI
 	bool "Atheros ath9k PCI/PCIe bus support"
 	default y
@@ -178,9 +187,6 @@ config ATH9K_HTC
 	depends on USB && MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  Support for Atheros HTC based cards.
 	  Chipsets supported: AR9271
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 13b4f5f50f8a..045118dc2a84 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -839,7 +839,7 @@ static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 #define ATH_LED_PIN_9485		6
 #define ATH_LED_PIN_9462		4
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 void ath_init_leds(struct ath_softc *sc);
 void ath_deinit_leds(struct ath_softc *sc);
 #else
@@ -1030,7 +1030,7 @@ struct ath_softc {
 	struct ath_chanctx *cur_chan;
 	spinlock_t chan_lock;
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 	bool led_registered;
 	char led_name[32];
 	struct led_classdev led_cdev;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b457e52dd365..aeaa7752049d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -20,7 +20,7 @@
 /*	 LED functions		*/
 /********************************/
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 
 static void ath_fill_led_pin(struct ath_softc *sc)
 {
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 0a1634238e67..d3a25c8bfcb5 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -44,7 +44,7 @@
 
 extern struct ieee80211_ops ath9k_htc_ops;
 extern int htc_modparam_nohwcrypt;
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 extern int ath9k_htc_led_blink;
 #endif
 
@@ -510,7 +510,7 @@ struct ath9k_htc_priv {
 	bool ps_enabled;
 	bool ps_idle;
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 	enum led_brightness brightness;
 	bool led_registered;
 	char led_name[32];
@@ -604,7 +604,7 @@ void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
 
 struct base_eep_header *ath9k_htc_get_eeprom_base(struct ath9k_htc_priv *priv);
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 void ath9k_configure_leds(struct ath9k_htc_priv *priv);
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index ecb848b60725..ffb8b656d257 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -222,7 +222,7 @@ void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
 /* LED */
 /*******/
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 void ath9k_led_work(struct work_struct *work)
 {
 	struct ath9k_htc_priv *priv = container_of(work,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index db0c6fa9c9dc..0195983ce79a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -42,7 +42,7 @@ int htc_use_dev_fw = 0;
 module_param_named(use_dev_fw, htc_use_dev_fw, int, 0444);
 MODULE_PARM_DESC(use_dev_fw, "Use development FW version");
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 int ath9k_htc_led_blink = 1;
 module_param_named(blink, ath9k_htc_led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
@@ -867,7 +867,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 		goto err_rx;
 
 	ath9k_hw_disable(priv->ah);
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	priv->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(priv->hw,
 		IEEE80211_TPT_LEDTRIG_FL_RADIO, ath9k_htc_tpt_blink,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2b7832b1c800..aedf325a0320 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1007,7 +1007,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&priv->fatal_work);
 	cancel_work_sync(&priv->ps_work);
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 	cancel_work_sync(&priv->led_work);
 #endif
 	ath9k_htc_stop_ani(priv);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 42a208787f5a..82923d436d80 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -82,7 +82,7 @@ MODULE_PARM_DESC(use_msi, "Use MSI instead of INTx if possible");
 
 bool is_ath9k_unloaded;
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
 	{ .throughput = 0 * 1024, .blink_time = 334 },
 	{ .throughput = 1 * 1024, .blink_time = 260 },
@@ -1035,7 +1035,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 
 	ath9k_init_txpower_limits(sc);
 
-#ifdef CONFIG_MAC80211_LEDS
+#ifdef CONFIG_ATH9K_LEDS
 	/* must be initialized before ieee80211_register_hw */
 	sc->led_cdev.default_trigger = ieee80211_create_tpt_led_trigger(sc->hw,
 		IEEE80211_TPT_LEDTRIG_FL_RADIO, ath9k_tpt_blink,
-- 
2.25.1

