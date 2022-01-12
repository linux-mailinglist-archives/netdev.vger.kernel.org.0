Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BAD48C984
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355684AbiALRdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:36 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:37001 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355639AbiALRdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:31 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id E578320002;
        Wed, 12 Jan 2022 17:33:25 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 06/27] net: mac802154: Set the symbol duration automatically
Date:   Wed, 12 Jan 2022 18:32:51 +0100
Message-Id: <20220112173312.764660-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have access to all the basic information to know which
symbol duration should be applied, let's set the symbol duration
automatically. The two locations that must call for the symbol duration
to be set are:
- when manually requesting a channel change though the netlink interface
- at PHY creation, ieee802154_alloc_hw() already calls
  ieee802154_change_channel() which will now update the symbol duration
  accordingly.

If an information is missing, the symbol duration is not touched, a
debug message is eventually printed. This keeps the compatibility with
the unconverted drivers for which it was too complicated for me to find
their precise information. If they initially provided a symbol duration,
it would be kept. If they don't, the symbol duration value is left
untouched.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  2 +
 net/mac802154/cfg.c     |  1 +
 net/mac802154/main.c    | 93 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 286709a9dd0b..52eefc4b5b4d 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -455,4 +455,6 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
 	return dev_name(&phy->dev);
 }
 
+void ieee802154_set_symbol_duration(struct wpan_phy *phy);
+
 #endif /* __NET_CFG802154_H */
diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
index 6969f1330ccd..ba57da07c08e 100644
--- a/net/mac802154/cfg.c
+++ b/net/mac802154/cfg.c
@@ -113,6 +113,7 @@ int ieee802154_change_channel(struct wpan_phy *wpan_phy, u8 page, u8 channel)
 	if (!ret) {
 		wpan_phy->current_page = page;
 		wpan_phy->current_channel = channel;
+		ieee802154_set_symbol_duration(wpan_phy);
 	}
 
 	return ret;
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 77a4943f345f..88826c5aa4ba 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -113,6 +113,99 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 }
 EXPORT_SYMBOL(ieee802154_alloc_hw);
 
+void ieee802154_set_symbol_duration(struct wpan_phy *phy)
+{
+	struct phy_page *page = &phy->supported.page[phy->current_page];
+	struct phy_channels *chan;
+	unsigned int chunk;
+	u32 duration = 0;
+
+	for (chunk = 0; chunk < page->nchunks; chunk++) {
+		if (page->chunk[chunk].channels & phy->current_channel)
+			break;
+	}
+
+	if (chunk == page->nchunks)
+		goto set_duration;
+
+	chan = &page->chunk[chunk];
+	switch (chan->protocol) {
+	case IEEE802154_BPSK_PHY:
+		switch (chan->band) {
+		case IEEE802154_868_MHZ_BAND:
+			/* 868 MHz BPSK	802.15.4-2003: 20 ksym/s */
+			duration = 50 * 1000;
+			break;
+		case IEEE802154_915_MHZ_BAND:
+			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
+			duration = 25 * 1000;
+			break;
+		default:
+			break;
+		}
+		break;
+	case IEEE802154_OQPSK_PHY:
+		switch (chan->band) {
+		case IEEE802154_868_MHZ_BAND:
+			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
+			duration = 40 * 1000;
+			break;
+		case IEEE802154_915_MHZ_BAND:
+		case IEEE802154_2400_MHZ_BAND:
+			/* 915/2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
+			duration = 16 * 1000;
+			break;
+		default:
+			break;
+		}
+		break;
+	case IEEE802154_CSS_PHY:
+		switch (chan->band) {
+		case IEEE802154_2400_MHZ_BAND:
+			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
+			duration = 6 * 1000;
+			break;
+		default:
+			break;
+		}
+		break;
+	case IEEE802154_HRP_UWB_PHY:
+		switch (chan->band) {
+		case IEEE802154_250_750_MHZ_BAND:
+		case IEEE802154_3100_4800_MHZ_BAND:
+		case IEEE802154_6000_10600_MHZ_BAND:
+			break;
+		default:
+			goto set_duration;
+		}
+
+		/* UWB 802.15.4a-2007: 993.6 or 1017.6 or 3974.4 ns */
+		switch (chan->prf) {
+		case IEEE802154_16100KHZ_MEAN_PRF:
+			duration = 994;
+			break;
+		case IEEE802154_4030KHZ_MEAN_PRF:
+			duration = 3974;
+			break;
+		case IEEE802154_62890KHZ_MEAN_PRF:
+			duration = 1018;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+set_duration:
+	if (!duration)
+		pr_debug("Unknown PHY symbol duration, the driver should be fixed\n");
+	else
+		phy->symbol_duration = duration;
+}
+EXPORT_SYMBOL(ieee802154_set_symbol_duration);
+
 void ieee802154_free_hw(struct ieee802154_hw *hw)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
-- 
2.27.0

