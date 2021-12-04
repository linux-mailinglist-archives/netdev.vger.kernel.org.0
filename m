Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246E34686A3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385233AbhLDRmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:42:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39496 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385218AbhLDRmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:42:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F893B80D1B;
        Sat,  4 Dec 2021 17:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C83C341C2;
        Sat,  4 Dec 2021 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638639558;
        bh=T49Q40LXzK30x9Er29k8SyC9Rt7rFIsSN3OYCmQhgOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a064rUFIHAV0Y4BzLis8lmsdPhJ5nF5Eq/t2EY+Kht6nMT4gKyaoOxnp5HCWEmdJC
         Uhv1RWnVNPijcUYABoSnzk7LrRekfOITiGj2xxduaja3N/DRd6EyxS1lV3qcoueVQ5
         +K7iji/5F8K8lVPzWEaNDp7XWAEFL42hTc6lk8Gjy29coXK9a1OzufMcQ4XXd7LNwM
         LYFt9KL3YTwrOKDTUsHhgjtOs8Sfcw27vlkjPFL+1USGZvXymRts5pDUe3wEBjbArg
         66TxCJoWTICIYzESzh5ovgohVqT1jycA+8MMeag1WQmhEnlzzjd21Kc+ckhQe8Zd8x
         O/Cf0xFB6DFMQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] brcmsmac: rework LED dependencies
Date:   Sat,  4 Dec 2021 18:38:34 +0100
Message-Id: <20211204173848.873293-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211204173848.873293-1-arnd@kernel.org>
References: <20211204173848.873293-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is now the only driver that selects the LEDS_CLASS framework,
which is normally user-selectable. While it doesn't strictly cause
a bug, rework the Kconfig logic to be more consistent with what
other drivers do, and only enable LED support in brcmsmac if the
dependencies are all there, rather than using 'select' to enable
what it needs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/brcm80211/Kconfig    | 14 +++++++++-----
 .../wireless/broadcom/brcm80211/brcmsmac/Makefile  |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.h |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index 5bf2318763c5..3a1a35b5672f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -7,16 +7,20 @@ config BRCMSMAC
 	depends on MAC80211
 	depends on BCMA_POSSIBLE
 	select BCMA
-	select NEW_LEDS if BCMA_DRIVER_GPIO
-	select LEDS_CLASS if BCMA_DRIVER_GPIO
 	select BRCMUTIL
 	select FW_LOADER
 	select CORDIC
 	help
 	  This module adds support for PCIe wireless adapters based on Broadcom
-	  IEEE802.11n SoftMAC chipsets. It also has WLAN led support, which will
-	  be available if you select BCMA_DRIVER_GPIO. If you choose to build a
-	  module, the driver will be called brcmsmac.ko.
+	  IEEE802.11n SoftMAC chipsets. If you choose to build a module, the
+	  driver will be called brcmsmac.ko.
+
+config BRCMSMAC_LEDS
+	def_bool BRCMSMAC && BCMA_DRIVER_GPIO && MAC80211_LEDS
+	help
+	  The brcmsmac LED support depends on the presence of the
+	  BCMA_DRIVER_GPIO driver, and it only works if LED support
+	  is enabled and reachable from the driver module.
 
 source "drivers/net/wireless/broadcom/brcm80211/brcmfmac/Kconfig"
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
index 482d7737764d..090757730ba6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
@@ -42,6 +42,6 @@ brcmsmac-y := \
 	brcms_trace_events.o \
 	debug.o
 
-brcmsmac-$(CONFIG_BCMA_DRIVER_GPIO) += led.o
+brcmsmac-$(CONFIG_BRCMSMAC_LEDS) += led.o
 
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac.o
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.h
index d65f5c268fd7..2a5cbeb9e783 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/led.h
@@ -24,7 +24,7 @@ struct brcms_led {
 	struct gpio_desc *gpiod;
 };
 
-#ifdef CONFIG_BCMA_DRIVER_GPIO
+#ifdef CONFIG_BRCMSMAC_LEDS
 void brcms_led_unregister(struct brcms_info *wl);
 int brcms_led_register(struct brcms_info *wl);
 #else
-- 
2.29.2

