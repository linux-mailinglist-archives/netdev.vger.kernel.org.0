Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414D647B7B5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhLUCBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbhLUCAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C1861224;
        Tue, 21 Dec 2021 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B7CC36AE8;
        Tue, 21 Dec 2021 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052018;
        bh=DVsjwuENV7Dn/qi9ZrDUy4tQc3WvxzzxhuIEzUxhbNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STYN6xmCHea4hLwxWwgk26WcK5cccZRZPog3W9j7htKgnLWdA7GtgA3U8YGbi56aU
         HayqGNXlKD4+ApPbxUKkCdYFTvTNZNSYcD/tuS6Lgj50/AMWEU7Gg/g7+yHq2W55LX
         BFp3gw5d0FOS90Z295/jbjq1iyVjj36hheJg/u8kNGN6ZE/XF7f/tsB9KsuEfDw3bo
         ZPem8ZlQhqRHJFk6DXlyMLMKAk+5MdRyECLXLrVWY6znJpx8C0HFiEtHemBXffYHgK
         bcnJuX7dpxu5cWLuFrPENaqjII8eicQrAK3KMvWbTAlUEe285DEv54QVENKL0Cq5Z2
         A03rrhrO0CsFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stf_xl@wp.pl, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/14] iwlwifi: fix LED dependencies
Date:   Mon, 20 Dec 2021 20:59:44 -0500
Message-Id: <20211221015952.117052-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit efdbfa0ad03e764419378485d1b8f6e7706fb1a3 ]

The dependencies for LED configuration are highly inconsistent and too
complicated at the moment. One of the results is a randconfig failure I
get very rarely when LEDS_CLASS is in a loadable module, but the wireless
core is built-in:

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
  Selected by [m]:
  - IWLEGACY [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y]
  - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])

aarch64-linux-ld: drivers/net/wireless/ath/ath5k/led.o: in function `ath5k_register_led':
led.c:(.text+0x60): undefined reference to `led_classdev_register_ext'
aarch64-linux-ld: drivers/net/wireless/ath/ath5k/led.o: in function `ath5k_unregister_leds':
led.c:(.text+0x200): undefined reference to `led_classdev_unregister'

For iwlwifi, the dependency is wrong, since this config prevents the
MAC80211_LEDS code from being part of a built-in MAC80211 driver.

For iwlegacy, this is worse because the driver tries to force-enable
the other subsystems, which is both a layering violation and a bug
because it will still fail with MAC80211=y and IWLEGACY=m, leading
to LEDS_CLASS being a module as well.

The actual link failure in the ath5k driver is a result of MAC80211_LEDS
being enabled but not usable. With the Kconfig logic fixed in the
Intel drivers, the ath5k driver works as expected again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211204173848.873293-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/Kconfig | 4 ++--
 drivers/net/wireless/intel/iwlwifi/Kconfig  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/Kconfig b/drivers/net/wireless/intel/iwlegacy/Kconfig
index 100f55858b133..490ef62605455 100644
--- a/drivers/net/wireless/intel/iwlegacy/Kconfig
+++ b/drivers/net/wireless/intel/iwlegacy/Kconfig
@@ -2,14 +2,13 @@
 config IWLEGACY
 	tristate
 	select FW_LOADER
-	select NEW_LEDS
-	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
 
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN (iwl4965)"
 	depends on PCI && MAC80211
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select IWLEGACY
 	---help---
 	  This option enables support for
@@ -38,6 +37,7 @@ config IWL4965
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on PCI && MAC80211
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select IWLEGACY
 	---help---
 	  Select to build the driver supporting the:
diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 091d621ad25fd..9805e5d13b5a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -47,7 +47,7 @@ if IWLWIFI
 
 config IWLWIFI_LEDS
 	bool
-	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	depends on IWLMVM || IWLDVM
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
-- 
2.34.1

