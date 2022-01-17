Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A449078E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiAQLzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239332AbiAQLzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:03 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C887DC061401;
        Mon, 17 Jan 2022 03:55:01 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id DA48F200005;
        Mon, 17 Jan 2022 11:54:58 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 09/41] net: mac802154: Set the symbol duration automatically
Date:   Mon, 17 Jan 2022 12:54:08 +0100
Message-Id: <20220117115440.60296-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
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
 include/net/cfg802154.h |   2 +
 net/mac802154/cfg.c     |   1 +
 net/mac802154/main.c    | 105 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 286709a9dd0b..4491e2724ff2 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -455,4 +455,6 @@ static inline const char *wpan_phy_name(struct wpan_phy *phy)
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
index 53153367f9d0..f08c34c27ea9 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -113,6 +113,109 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 }
 EXPORT_SYMBOL(ieee802154_alloc_hw);
 
+void ieee802154_configure_durations(struct wpan_phy *phy)
+{
+	struct phy_page *page = &phy->supported.page[phy->current_page];
+	struct phy_channels *chan;
+	bool valid_band = false;
+	unsigned int chunk;
+	u32 duration = 0;
+
+	for (chunk = 0; chunk < page->nchunks; chunk++) {
+		if (page->chunk[chunk].channels & BIT(phy->current_channel))
+			break;
+	}
+
+	if (chunk == page->nchunks) {
+		pr_debug("Wrong channels description\n");
+		return;
+	}
+
+	chan = &page->chunk[chunk];
+	switch (chan->protocol) {
+	case IEEE802154_BPSK_PHY:
+		switch (chan->band) {
+		case IEEE802154_868_MHZ_BAND:
+			/* 868 MHz BPSK	802.15.4-2003: 20 ksym/s */
+			duration = 50 * NSEC_PER_USEC;
+			break;
+		case IEEE802154_915_MHZ_BAND:
+			/* 915 MHz BPSK	802.15.4-2003: 40 ksym/s */
+			duration = 25 * NSEC_PER_USEC;
+			break;
+		default:
+			break;
+		}
+		break;
+	case IEEE802154_OQPSK_PHY:
+		switch (chan->band) {
+		case IEEE802154_868_MHZ_BAND:
+			/* 868 MHz O-QPSK 802.15.4-2006: 25 ksym/s */
+			duration = 40 * NSEC_PER_USEC;
+			break;
+		case IEEE802154_915_MHZ_BAND:
+		case IEEE802154_2400_MHZ_BAND:
+			/* 915/2400 MHz O-QPSK 802.15.4-2006: 62.5 ksym/s */
+			duration = 16 * NSEC_PER_USEC;
+			break;
+		default:
+			break;
+		}
+		break;
+	case IEEE802154_CSS_PHY:
+		switch (chan->band) {
+		case IEEE802154_2400_MHZ_BAND:
+			/* 2.4 GHz CSS 802.15.4a-2007: 1/6 Msym/s */
+			duration = 6 * NSEC_PER_USEC;
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
+			valid_band = true;
+			break;
+		default:
+			break;
+		}
+
+		if (!valid_band)
+			break;
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
@@ -157,6 +260,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	ieee802154_setup_wpan_phy_pib(local->phy);
 
+	ieee802154_configure_durations(local->phy);
+
 	if (!(hw->flags & IEEE802154_HW_CSMA_PARAMS)) {
 		local->phy->supported.min_csma_backoffs = 4;
 		local->phy->supported.max_csma_backoffs = 4;
-- 
2.27.0

