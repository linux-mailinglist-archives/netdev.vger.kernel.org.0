Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB21306B
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfECOfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:35:19 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:17092 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbfECOfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 10:35:17 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 2BDF24AD4;
        Fri,  3 May 2019 16:27:47 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id cbd31f28;
        Fri, 3 May 2019 16:27:45 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v4 07/10] net: wireless: support of_get_mac_address new ERR_PTR error
Date:   Fri,  3 May 2019 16:27:12 +0200
Message-Id: <1556893635-18549-8-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556893635-18549-1-git-send-email-ynezz@true.cz>
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was NVMEM support added to of_get_mac_address, so it could now return
ERR_PTR encoded error values, so we need to adjust all current users of
of_get_mac_address to this new fact.

Signed-off-by: Petr Štetiar <ynezz@true.cz>
---

 Changes since v3:

  * IS_ERR_OR_NULL -> IS_ERR

 drivers/net/wireless/ath/ath9k/init.c          | 2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c    | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 98141b6..a04d861 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -642,7 +642,7 @@ static int ath9k_of_init(struct ath_softc *sc)
 	}
 
 	mac = of_get_mac_address(np);
-	if (mac)
+	if (!IS_ERR(mac))
 		ether_addr_copy(common->macaddr, mac);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index a1529920d..0496493 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -94,7 +94,7 @@
 		return;
 
 	mac = of_get_mac_address(np);
-	if (mac)
+	if (!IS_ERR(mac))
 		memcpy(dev->macaddr, mac, ETH_ALEN);
 #endif
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 357c094..19a794a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1007,7 +1007,7 @@ void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr
 	const char *mac_addr;
 
 	mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);
-	if (mac_addr)
+	if (!IS_ERR(mac_addr))
 		ether_addr_copy(eeprom_mac_addr, mac_addr);
 
 	if (!is_valid_ether_addr(eeprom_mac_addr)) {
-- 
1.9.1

