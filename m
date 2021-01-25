Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12B9304AD1
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbhAZE5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:57:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbhAYMKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:10:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3AB722ADC;
        Mon, 25 Jan 2021 11:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611574619;
        bh=WZ4OUPFOvGvy2rifYYkrii+pkg7vZ94TulWEdEn/oG8=;
        h=From:To:Cc:Subject:Date:From;
        b=MXSHl6tzmf+NO9TJ6DSLHRZUPT+ML9yWvxVKPvwd1nb9ZzENuIWhGewqT0VtgiIx9
         oNKUoScrs4sE5cxanWynV1qDGgLyv8tK79qUoFM2ulsF26+5R03R8wbIlSv4INVVEV
         F2834dCHBuH8kapy8YmAQbNCvTM4rIiyPHbvpCakcbcCOxdNrI4kMTJGR4gS0RioOi
         IRt3cg5Mkm9SfBibJst5YOeLVn1YWYw5C11blK+NSiq2898gJEVsF2JBcQ12TYdzoD
         EKXWHabpsxZyG/5/3SfEfFqkMGu/DjoWh7wYHDVSv8uVlDlz59FJi/CWug3WDLgKUk
         C+FVZQU2mCNIw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: fix build error with LEDS_CLASS=m
Date:   Mon, 25 Jan 2021 12:36:42 +0100
Message-Id: <20210125113654.2408057-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_ATH9K is built-in but LED support is in a loadable
module, both ath9k drivers fails to link:

x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_deinit_leds':
gpio.c:(.text+0x36): undefined reference to `led_classdev_unregister'
x86_64-linux-ld: drivers/net/wireless/ath/ath9k/gpio.o: in function `ath_init_leds':
gpio.c:(.text+0x179): undefined reference to `led_classdev_register_ext'

The problem is that the 'imply' keyword does not enforce any dependency
but is only a weak hint to Kconfig to enable another symbol from a
defconfig file.

Change imply to a 'depends on LEDS_CLASS' that prevents the incorrect
configuration but still allows building the driver without LED support.

The 'select MAC80211_LEDS' is now ensures that the LED support is
actually used if it is present, and the added Kconfig dependency
on MAC80211_LEDS ensures that it cannot be enabled manually when it
has no effect.

Fixes: 197f466e93f5 ("ath9k_htc: Do not select MAC80211_LEDS by default")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 8 ++------
 net/mac80211/Kconfig                   | 2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index a84bb9b6573f..e150d82eddb6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -21,11 +21,9 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211 && HAS_DMA
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
@@ -176,11 +174,9 @@ config ATH9K_PCI_NO_EEPROM
 config ATH9K_HTC
 	tristate "Atheros HTC based wireless cards support"
 	depends on USB && MAC80211
+	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
-	imply NEW_LEDS
-	imply LEDS_CLASS
-	imply MAC80211_LEDS
 	help
 	  Support for Atheros HTC based cards.
 	  Chipsets supported: AR9271
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index cd9a9bd242ba..51ec8256b7fa 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,7 +69,7 @@ config MAC80211_MESH
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select LEDS_TRIGGERS
 	help
 	  This option enables a few LED triggers for different
-- 
2.29.2

