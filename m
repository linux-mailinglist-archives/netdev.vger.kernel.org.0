Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386583D2252
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 12:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhGVKOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGVKOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10ACB60FF2;
        Thu, 22 Jul 2021 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626951306;
        bh=BJ6APhf3RzDbaRx9MSskmKukvlPphUZjkNXAiCLjq4U=;
        h=From:To:Cc:Subject:Date:From;
        b=tJS6H2raoggEzh/mOaRoAOyvnEvMH57PAQXqTQ7G1iQeQk6jp5JoZOjYupmVbzTt4
         LrObS2Rf0tmov1bl59+wmqC+UO0vcN4IdgI9b6v5T90iNWgxV/NIjoaRqZaHBUy2n+
         hx98jCTyUah9HfLz927v588OnDw5qI0POpV1Y3dCx61TN7ua+H+eVG1S/bzZ3Skd+T
         HcybZomMzitJHpskL8JFWx6PACzq++Lajp5pJUTBPTKWb4uXCpIaevB7mLRSxU9xIq
         qFdJfU8S8F1FM8ukEPBSH4FztIYCngfZ90hqEQ8lzov4WXOknIAgEYeRO/mxVVwX51
         4M6PBGbiocQAA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath5k: fix building with LEDS=m
Date:   Thu, 22 Jul 2021 12:54:46 +0200
Message-Id: <20210722105501.1000781-1-arnd@kernel.org>
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
as well.

Alternatively, we could just drop the 'select' from both ath5k and
ath9k.

Fixes: b64acb28da83 ("ath9k: fix build error with LEDS_CLASS=m")
Fixes: 72cdab808714 ("ath9k: Do not select MAC80211_LEDS by default")
Fixes: 3a078876caee ("ath5k: convert LED code to use mac80211 triggers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath5k/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

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
-- 
2.29.2

