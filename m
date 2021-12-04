Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F0746869C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379087AbhLDRmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345154AbhLDRmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5BFC061751;
        Sat,  4 Dec 2021 09:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D03E60ED3;
        Sat,  4 Dec 2021 17:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAE3C341C2;
        Sat,  4 Dec 2021 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638639534;
        bh=1rvxeX+PruiwEzOMQLSIRqwW69fIVZg2Dc+BhWJCytg=;
        h=From:To:Cc:Subject:Date:From;
        b=NF8cJgXcgYN2qW5oe/SlzotnKKYZSijKQjGPRfzVgWTuZkWFmBvodBIrfElJECCCh
         wOFrNp69gMspq8ZokTpdT/nlSpBnxoj0LO8JXPOJhKjqblTYIEzULD7alcFrujMlA5
         579Uc3XeltlkqyscMzRYUk0gBymsK7sgQtjoK6JKLZ+oJ5HobJ5xVFlISNgvYBURSD
         yQN145dizlGALcymrKzSXJemcN08pYK5TecHhA1BVFHJRJHhE8J2j/mKKYW2zNgJTa
         v4RW6nuYwhPh3dF5QvHD4b5xIDsux7VgE/yjnZWj6Z7u+tK/JcdOkGR+BNcUdgzVcE
         Ny6lEABn6d1rw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] iwlwifi: fix LED dependencies
Date:   Sat,  4 Dec 2021 18:38:33 +0100
Message-Id: <20211204173848.873293-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
---
 drivers/net/wireless/intel/iwlegacy/Kconfig | 4 ++--
 drivers/net/wireless/intel/iwlwifi/Kconfig  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/Kconfig b/drivers/net/wireless/intel/iwlegacy/Kconfig
index 24fe3f63c321..7eacc8e58ee1 100644
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
 	help
 	  This option enables support for
@@ -38,6 +37,7 @@ config IWL4965
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on PCI && MAC80211
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select IWLEGACY
 	help
 	  Select to build the driver supporting the:
diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 337428ef2e67..cf1125d84929 100644
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
2.29.2

