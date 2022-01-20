Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C66E4944E4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiATAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240388AbiATAl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:41:29 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA6C061574;
        Wed, 19 Jan 2022 16:41:27 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 34013200006;
        Thu, 20 Jan 2022 00:41:25 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Xue Liu <liuxuenetmail@gmail.com>,
        Alan Ott <alan@signal11.us>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 2/5] net: ieee802154: Give more details to the core about the channel configurations
Date:   Thu, 20 Jan 2022 01:41:17 +0100
Message-Id: <20220120004120.308709-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120004120.308709-1-miquel.raynal@bootlin.com>
References: <20220120004120.308709-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to let the core derive eg. the symbol duration for a given
channel, it needs to know which protocol is being used, on which band,
and eventually more details such as the mean PRF in the case of UWB.

Create the necessary enumerations to declare all of that. Include them
in the currently-almost-empty phy_channels structure which until now
only declared the supported channels as bitfields.

The PRF is declared in a union as this clearly is a parameter that does
not apply to most of the protocols. It is very likely that other
parameters will get added in the future to further define specific
protocols and the union will likely be a good location for them.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c       | 29 ++++++++++++++---
 drivers/net/ieee802154/atusb.c           | 29 ++++++++++++++---
 drivers/net/ieee802154/ca8210.c          |  3 ++
 drivers/net/ieee802154/mac802154_hwsim.c | 33 +++++++++++++++++++
 drivers/net/ieee802154/mcr20a.c          |  3 ++
 include/net/cfg802154.h                  | 41 ++++++++++++++++++++++++
 6 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 144553f156dd..84e5dcd9df09 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1561,6 +1561,8 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf231_data;
 		lp->hw->phy->supported.page[0].nchunks = 1;
 		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
+		lp->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+		lp->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		lp->hw->phy->current_channel = 11;
 		lp->hw->phy->symbol_duration = 16;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
@@ -1572,10 +1574,27 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		chip = "at86rf212";
 		lp->data = &at86rf212_data;
 		lp->hw->flags |= IEEE802154_HW_LBT;
-		lp->hw->phy->supported.page[0].nchunks = 1;
-		lp->hw->phy->supported.page[0].chunk[0].channels = 0x00007FF;
-		lp->hw->phy->supported.page[2].nchunks = 1;
-		lp->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
+
+		lp->hw->phy->supported.page[0].nchunks = 2;
+		/* SUB:0 and BPSK:0 -> BPSK-20 */
+		lp->hw->phy->supported.page[0].chunk[0].channels = 1;
+		lp->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_BPSK_PHY;
+		lp->hw->phy->supported.page[0].chunk[0].band = IEEE802154_868_MHZ_BAND;
+		/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
+		lp->hw->phy->supported.page[0].chunk[1].channels = 0x00007FE;
+		lp->hw->phy->supported.page[0].chunk[1].protocol = IEEE802154_OQPSK_PHY;
+		lp->hw->phy->supported.page[0].chunk[1].band = IEEE802154_868_MHZ_BAND;
+
+		lp->hw->phy->supported.page[2].nchunks = 2;
+		/* SUB:1 and BPSK:0 -> BPSK-40 */
+		lp->hw->phy->supported.page[2].chunk[0].channels = 1;
+		lp->hw->phy->supported.page[2].chunk[0].protocol = IEEE802154_BPSK_PHY;
+		lp->hw->phy->supported.page[2].chunk[0].band = IEEE802154_915_MHZ_BAND;
+		/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
+		lp->hw->phy->supported.page[2].chunk[1].channels = 0x00007FE;
+		lp->hw->phy->supported.page[2].chunk[1].protocol = IEEE802154_OQPSK_PHY;
+		lp->hw->phy->supported.page[2].chunk[1].band = IEEE802154_915_MHZ_BAND;
+
 		lp->hw->phy->current_channel = 5;
 		lp->hw->phy->symbol_duration = 25;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
@@ -1589,6 +1608,8 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf233_data;
 		lp->hw->phy->supported.page[0].nchunks = 1;
 		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
+		lp->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+		lp->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		lp->hw->phy->current_channel = 13;
 		lp->hw->phy->symbol_duration = 16;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 38ebfacf2698..7e8c9d6db7d7 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -916,6 +916,8 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF230";
 		atusb->hw->phy->supported.page[0].nchunks = 1;
 		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
+		atusb->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+		atusb->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
 		atusb->hw->phy->symbol_duration = 16;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
@@ -927,6 +929,8 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF231";
 		atusb->hw->phy->supported.page[0].nchunks = 1;
 		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
+		atusb->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+		atusb->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
 		atusb->hw->phy->symbol_duration = 16;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
@@ -937,10 +941,27 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 	case 7:
 		chip = "AT86RF212";
 		atusb->hw->flags |= IEEE802154_HW_LBT;
-		atusb->hw->phy->supported.page[0].nchunks = 1;
-		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x00007FF;
-		atusb->hw->phy->supported.page[2].nchunks = 1;
-		atusb->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
+
+		atusb->hw->phy->supported.page[0].nchunks = 2;
+		/* SUB:0 and BPSK:0 -> BPSK-20 */
+		atusb->hw->phy->supported.page[0].chunk[0].channels = 1;
+		atusb->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_BPSK_PHY;
+		atusb->hw->phy->supported.page[0].chunk[0].band = IEEE802154_868_MHZ_BAND;
+		/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
+		atusb->hw->phy->supported.page[0].chunk[1].channels = 0x00007FE;
+		atusb->hw->phy->supported.page[0].chunk[1].protocol = IEEE802154_OQPSK_PHY;
+		atusb->hw->phy->supported.page[0].chunk[1].band = IEEE802154_868_MHZ_BAND;
+
+		atusb->hw->phy->supported.page[2].nchunks = 2;
+		/* SUB:1 and BPSK:0 -> BPSK-40 */
+		atusb->hw->phy->supported.page[2].chunk[0].channels = 1;
+		atusb->hw->phy->supported.page[2].chunk[0].protocol = IEEE802154_BPSK_PHY;
+		atusb->hw->phy->supported.page[2].chunk[0].band = IEEE802154_915_MHZ_BAND;
+		/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
+		atusb->hw->phy->supported.page[2].chunk[1].channels = 0x00007FE;
+		atusb->hw->phy->supported.page[2].chunk[1].protocol = IEEE802154_OQPSK_PHY;
+		atusb->hw->phy->supported.page[2].chunk[1].band = IEEE802154_915_MHZ_BAND;
+
 		atusb->hw->phy->current_channel = 5;
 		atusb->hw->phy->symbol_duration = 25;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index cf31655fe714..6854ec7747c0 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2964,7 +2964,10 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 {
 	/* Support channels 11-26 */
 	ca8210_hw->phy->supported.page[0].nchunks = 1;
+	/* 2.4 GHz O-QPSK */
 	ca8210_hw->phy->supported.page[0].chunk[0].channels = CA8210_VALID_CHANNELS;
+	ca8210_hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+	ca8210_hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 	ca8210_hw->phy->supported.tx_powers_size = CA8210_MAX_TX_POWERS;
 	ca8210_hw->phy->supported.tx_powers = ca8210_tx_powers;
 	ca8210_hw->phy->supported.cca_ed_levels_size = CA8210_MAX_ED_LEVELS;
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 76fa532d8891..583fcdf7d267 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -747,46 +747,79 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	hw->phy->supported.page[0].nchunks = 3;
 	/* 868 MHz BPSK	802.15.4-2003 */
 	hw->phy->supported.page[0].chunk[0].channels |= 1;
+	hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_BPSK_PHY;
+	hw->phy->supported.page[0].chunk[0].band = IEEE802154_868_MHZ_BAND;
 	/* 915 MHz BPSK	802.15.4-2003 */
 	hw->phy->supported.page[0].chunk[1].channels |= 0x7fe;
+	hw->phy->supported.page[0].chunk[1].protocol = IEEE802154_BPSK_PHY;
+	hw->phy->supported.page[0].chunk[1].band = IEEE802154_915_MHZ_BAND;
 	/* 2.4 GHz O-QPSK 802.15.4-2003 */
 	hw->phy->supported.page[0].chunk[2].channels |= 0x7FFF800;
+	hw->phy->supported.page[0].chunk[2].protocol = IEEE802154_OQPSK_PHY;
+	hw->phy->supported.page[0].chunk[2].band = IEEE802154_2400_MHZ_BAND;
 
 	hw->phy->supported.page[1].nchunks = 2;
 	/* 868 MHz ASK 802.15.4-2006 */
 	hw->phy->supported.page[1].chunk[0].channels |= 1;
+	hw->phy->supported.page[1].chunk[0].protocol = IEEE802154_ASK_PHY;
+	hw->phy->supported.page[1].chunk[0].band = IEEE802154_868_MHZ_BAND;
 	/* 915 MHz ASK 802.15.4-2006 */
 	hw->phy->supported.page[1].chunk[1].channels |= 0x7fe;
+	hw->phy->supported.page[1].chunk[1].protocol = IEEE802154_ASK_PHY;
+	hw->phy->supported.page[1].chunk[1].band = IEEE802154_915_MHZ_BAND;
 
 	hw->phy->supported.page[2].nchunks = 2;
 	/* 868 MHz O-QPSK 802.15.4-2006 */
 	hw->phy->supported.page[2].chunk[0].channels |= 1;
+	hw->phy->supported.page[2].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+	hw->phy->supported.page[2].chunk[0].band = IEEE802154_868_MHZ_BAND;
 	/* 915 MHz O-QPSK 802.15.4-2006 */
 	hw->phy->supported.page[2].chunk[1].channels |= 0x7fe;
+	hw->phy->supported.page[2].chunk[1].protocol = IEEE802154_OQPSK_PHY;
+	hw->phy->supported.page[2].chunk[1].band = IEEE802154_915_MHZ_BAND;
 
 	hw->phy->supported.page[3].nchunks = 1;
 	/* 2.4 GHz CSS 802.15.4a-2007 */
 	hw->phy->supported.page[3].chunk[0].channels |= 0x3fff;
+	hw->phy->supported.page[3].chunk[0].protocol = IEEE802154_CSS_PHY;
+	hw->phy->supported.page[3].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 
 	hw->phy->supported.page[4].nchunks = 3;
 	/* UWB Sub-gigahertz 802.15.4a-2007 */
 	hw->phy->supported.page[4].chunk[0].channels |= 1;
+	hw->phy->supported.page[4].chunk[0].protocol = IEEE802154_HRP_UWB_PHY;
+	hw->phy->supported.page[4].chunk[0].band = IEEE802154_250_750_MHZ_BAND;
+	hw->phy->supported.page[4].chunk[0].prf = IEEE802154_62890KHZ_MEAN_PRF;
 	/* UWB Low band 802.15.4a-2007 */
 	hw->phy->supported.page[4].chunk[1].channels |= 0x1e;
+	hw->phy->supported.page[4].chunk[1].protocol = IEEE802154_HRP_UWB_PHY;
+	hw->phy->supported.page[4].chunk[1].band = IEEE802154_3100_4800_MHZ_BAND;
+	hw->phy->supported.page[4].chunk[1].prf = IEEE802154_62890KHZ_MEAN_PRF;
 	/* UWB High band 802.15.4a-2007 */
 	hw->phy->supported.page[4].chunk[2].channels |= 0xffe0;
+	hw->phy->supported.page[4].chunk[2].protocol = IEEE802154_HRP_UWB_PHY;
+	hw->phy->supported.page[4].chunk[2].band = IEEE802154_6000_10600_MHZ_BAND;
+	hw->phy->supported.page[4].chunk[2].prf = IEEE802154_62890KHZ_MEAN_PRF;
 
 	hw->phy->supported.page[5].nchunks = 2;
 	/* 750 MHz O-QPSK 802.15.4c-2009 */
 	hw->phy->supported.page[5].chunk[0].channels |= 0xf;
+	hw->phy->supported.page[5].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+	hw->phy->supported.page[5].chunk[0].band = IEEE802154_750_MHZ_BAND;
 	/* 750 MHz MPSK 802.15.4c-2009 */
 	hw->phy->supported.page[5].chunk[1].channels |= 0xf0;
+	hw->phy->supported.page[5].chunk[1].protocol = IEEE802154_MQPSK_PHY;
+	hw->phy->supported.page[5].chunk[1].band = IEEE802154_750_MHZ_BAND;
 
 	hw->phy->supported.page[6].nchunks = 2;
 	/* 950 MHz BPSK 802.15.4d-2009 */
 	hw->phy->supported.page[6].chunk[0].channels |= 0x3ff;
+	hw->phy->supported.page[6].chunk[0].protocol = IEEE802154_BPSK_PHY;
+	hw->phy->supported.page[6].chunk[0].band = IEEE802154_950_MHZ_BAND;
 	/* 950 MHz GFSK 802.15.4d-2009 */
 	hw->phy->supported.page[6].chunk[1].channels |= 0x3ffc00;
+	hw->phy->supported.page[6].chunk[1].protocol = IEEE802154_GFSK_PHY;
+	hw->phy->supported.page[6].chunk[1].band = IEEE802154_950_MHZ_BAND;
 
 	ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
 
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 80bed905acf9..e2c249aef430 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1003,7 +1003,10 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->cca.mode = NL802154_CCA_ENERGY;
 
 	phy->supported.page[0].nchunks = 1;
+	/* 2.4 GHz O-QPSK */
 	phy->supported.page[0].chunk[0].channels = MCR20A_VALID_CHANNELS;
+	phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
+	phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index ef49a23801c6..03c8008217fb 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -131,8 +131,49 @@ wpan_phy_supported_bool(bool b, enum nl802154_supported_bool_states st)
 	return false;
 }
 
+enum ieee802154_phy_protocols {
+	IEEE802154_UNKNOWN_PHY,
+	IEEE802154_BPSK_PHY,
+	IEEE802154_OQPSK_PHY,
+	IEEE802154_MQPSK_PHY,
+	IEEE802154_GFSK_PHY,
+	IEEE802154_ASK_PHY,
+	IEEE802154_CSS_PHY,
+	IEEE802154_HRP_UWB_PHY,
+
+	IEEE802154_MAX_PHY,
+};
+
+enum ieee802154_phy_bands {
+	IEEE802154_UNKNOWN_BAND,
+	IEEE802154_750_MHZ_BAND,
+	IEEE802154_868_MHZ_BAND,
+	IEEE802154_915_MHZ_BAND,
+	IEEE802154_950_MHZ_BAND,
+	IEEE802154_2400_MHZ_BAND,
+	IEEE802154_250_750_MHZ_BAND,
+	IEEE802154_3100_4800_MHZ_BAND,
+	IEEE802154_6000_10600_MHZ_BAND,
+
+	IEEE802154_MAX_BAND,
+};
+
+enum ieee802154_phy_mean_prfs {
+	IEEE802154_UNKNOWN_MEAN_PRF,
+	IEEE802154_16100KHZ_MEAN_PRF,
+	IEEE802154_4030KHZ_MEAN_PRF,
+	IEEE802154_62890KHZ_MEAN_PRF,
+
+	IEEE802154_MAX_PRF,
+};
+
 struct phy_channels {
 	u32 channels;
+	enum ieee802154_phy_protocols protocol;
+	enum ieee802154_phy_bands band;
+	union {
+		enum ieee802154_phy_mean_prfs prf;
+	};
 };
 
 struct phy_page {
-- 
2.27.0

