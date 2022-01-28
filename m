Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B5049F7E5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348106AbiA1LI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348048AbiA1LIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:08:36 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D179FC061747;
        Fri, 28 Jan 2022 03:08:35 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C6743100012;
        Fri, 28 Jan 2022 11:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WFq11z0XCdil/n6iW7536mP8jlZALGA1IzxCOJ43Y/0=;
        b=LuSxh6D3PJru+E4BsjKg2XUMHgE2DT3stVt5ZCvG3WtvznyhQ0LpPjTByAqRRPVBi52UGD
        xfplVC2C7XzuouvoFZLISg3QV8f3l3UBA1iPmaVacKWelZSk+4YxoROD6jrKke8zFZGznI
        XuR2pyNhUMOdtduIxSN5TL+vFKI2Iqc8daU7Jmpi38o8+VsslRDpnBRdqVpIQszA+OfyH4
        4OpbSAlIoWHQt80xnHpUQXXvd3oeqEm3FZOc6KS8UsnrZ5X2cMOrgoVud6J003UeEvL4jZ
        GiQA2XL0FHWdOj/LE7w2vtyG/U/W1ZHyAhWY5g6UDEyEotIYNPm/U8M1ICoVkw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 4/5] net: mac802154: Set durations automatically
Date:   Fri, 28 Jan 2022 12:08:24 +0100
Message-Id: <20220128110825.1120678-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
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

Once the symbol duration derived, the lifs and sifs durations are
updated as well.

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

