Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4F74A632E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbiBASGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:06:39 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:35137 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241766AbiBASGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:06:38 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 62DECC0010;
        Tue,  1 Feb 2022 18:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6iCxhQS7IwBxiQWf8jBAJOzh10aW2kMIyiKUnlFHKlY=;
        b=hYKu5vGBs+uyL1lOMqpQSxnDqHfXHZk4aYCQLfU2yW7QOrCqYG/xgMbrC4hng92ZRa2sTC
        WM+0fmn8UGwx0CDpdoQj0TZT8WwsLRmHutX6npp0idSPEKQ2Dnw8rk6B/gpERn26JJM9Zm
        I+sgQfowMoV1MYlpm2QC3IazBdV8mXzo7IPXwua43STzTgsb91oSx3nvqKG6+yzLzhql3Z
        ofdYwZ5ZoDh2+/aGt9lcBB6f2uUj+SHQsEvQwfH1FT+gZdCzY4uo67Dd3ZbnVUea/y3A2B
        tqaIUHSnE7KC5iAlq/fC/5+avrKHpLh7wdCI9TY1vCSN/EcAeqmCv00nW+he3Q==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 3/4] net: mac802154: Set durations automatically
Date:   Tue,  1 Feb 2022 19:06:28 +0100
Message-Id: <20220201180629.93410-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As depicted in the IEEE 802.15.4 specification, modulation/bands are
tight to a number of page/channels so we can for most of them derive the
durations automatically.

The two locations that must call this new helper to set the variou
symbol durations are:
- when manually requesting a channel change though the netlink interface
- at PHY creation, once the device driver has set the default
  page/channel

If an information is missing, the symbol duration is not touched, a
debug message is eventually printed. This keeps the compatibility with
the unconverted drivers for which it was too complicated for me to find
their precise information. If they initially provided a symbol duration,
it would be kept. If they don't, the symbol duration value is left
untouched.

Once the symbol duration derived, the lifs and sifs durations are
updated as well.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  2 ++
 net/mac802154/cfg.c     |  1 +
 net/mac802154/main.c    | 46 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 8a4b6a50452f..49b4bcc24032 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -405,4 +405,6 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
 	return dev_name(&phy->dev);
 }
 
+void ieee802154_configure_durations(struct wpan_phy *phy);
+
 #endif /* __NET_CFG802154_H */
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index fbeebe3bc31d..1e4a9f74ed43 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -118,6 +118,7 @@ ieee802154_set_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	if (!ret) {
 		wpan_phy->current_page = page;
 		wpan_phy->current_channel = channel;
+		ieee802154_configure_durations(wpan_phy);
 	}
 
 	return ret;
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 53153367f9d0..5546ef86e231 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -113,6 +113,50 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 }
 EXPORT_SYMBOL(ieee802154_alloc_hw);
 
+void ieee802154_configure_durations(struct wpan_phy *phy)
+{
+	u32 duration = 0;
+
+	switch (phy->current_page) {
+	case 0:
+		if (BIT(phy->current_page) & 0x1)
+			/* 868 MHz BPSK 802.15.4-2003: 20 ksym/s */
+			duration = 50 * NSEC_PER_USEC;
+		else if (phy->current_page & 0x7FE)
+			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
+			duration = 25 * NSEC_PER_USEC;
+		else if (phy->current_page & 0x7FFF800)
+			/* 2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
+			duration = 16 * NSEC_PER_USEC;
+		break;
+	case 2:
+		if (BIT(phy->current_page) & 0x1)
+			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
+			duration = 40 * NSEC_PER_USEC;
+		else if (phy->current_page & 0x7FE)
+			/* 915 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
+			duration = 16 * NSEC_PER_USEC;
+		break;
+	case 3:
+		if (BIT(phy->current_page) & 0x3FFF)
+			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
+			duration = 6 * NSEC_PER_USEC;
+		break;
+	default:
+		break;
+	}
+
+	if (!duration) {
+		pr_debug("Unknown PHY symbol duration\n");
+		return;
+	}
+
+	phy->symbol_duration = duration;
+	phy->lifs_period = (IEEE802154_LIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
+	phy->sifs_period = (IEEE802154_SIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
+}
+EXPORT_SYMBOL(ieee802154_configure_durations);
+
 void ieee802154_free_hw(struct ieee802154_hw *hw)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
@@ -157,6 +201,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	ieee802154_setup_wpan_phy_pib(local->phy);
 
+	ieee802154_configure_durations(local->phy);
+
 	if (!(hw->flags & IEEE802154_HW_CSMA_PARAMS)) {
 		local->phy->supported.min_csma_backoffs = 4;
 		local->phy->supported.max_csma_backoffs = 4;
-- 
2.27.0

