Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BF048C979
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355641AbiALRdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:31 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:39961 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355615AbiALRdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:25 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id CCE1B20014;
        Wed, 12 Jan 2022 17:33:19 +0000 (UTC)
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
Subject: [wpan-next v2 03/27] net: ieee802154: Improve the way supported channels are declared
Date:   Wed, 12 Jan 2022 18:32:48 +0100
Message-Id: <20220112173312.764660-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea here is to create a structure per set of channels so that we
can define much more than basic bitfields for these.

The structure is currently almost empty on purpose because this change
is supposed to be a mechanical update without additional information but
more details will be added in the following commits.

For each page, the core now has access to how many "chunks" of channels
are defined. Overall up to only 3 chunks have been defined so let's
hardcode this value to simplify a lot the handling. Then, for each
chunk, we define an independent bitfield of channels. As there are
several users of these bitfields, we also create the
cfg802154_get_supported_chans() helper to reconstruct the bitfield as it
was before when the only information that matters is identifying the
supported/unsupported channels.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/adf7242.c         |  3 +-
 drivers/net/ieee802154/at86rf230.c       | 12 ++++---
 drivers/net/ieee802154/atusb.c           | 12 ++++---
 drivers/net/ieee802154/ca8210.c          |  3 +-
 drivers/net/ieee802154/cc2520.c          |  3 +-
 drivers/net/ieee802154/fakelb.c          | 43 +++++++++++++++---------
 drivers/net/ieee802154/mac802154_hwsim.c | 43 +++++++++++++++---------
 drivers/net/ieee802154/mcr20a.c          |  3 +-
 drivers/net/ieee802154/mrf24j40.c        |  3 +-
 include/net/cfg802154.h                  | 13 +++++--
 net/ieee802154/core.h                    |  2 ++
 net/ieee802154/nl-phy.c                  |  8 +++--
 net/ieee802154/nl802154.c                | 30 +++++++++++++----
 13 files changed, 125 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/adf7242.c
index 7db9cbd0f5de..40c77a643b78 100644
--- a/drivers/net/ieee802154/adf7242.c
+++ b/drivers/net/ieee802154/adf7242.c
@@ -1211,7 +1211,8 @@ static int adf7242_probe(struct spi_device *spi)
 	hw->extra_tx_headroom = 0;
 
 	/* We support only 2.4 Ghz */
-	hw->phy->supported.channels[0] = 0x7FFF800;
+	hw->phy->supported.page[0].nchunks = 1;
+	hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 
 	hw->flags = IEEE802154_HW_OMIT_CKSUM |
 		    IEEE802154_HW_CSMA_PARAMS |
diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 7d67f41387f5..cdf5d2a4f763 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1558,7 +1558,8 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 	case 3:
 		chip = "at86rf231";
 		lp->data = &at86rf231_data;
-		lp->hw->phy->supported.channels[0] = 0x7FFF800;
+		lp->hw->phy->supported.page[0].nchunks = 1;
+		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		lp->hw->phy->current_channel = 11;
 		lp->hw->phy->symbol_duration = 16;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
@@ -1570,8 +1571,10 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		chip = "at86rf212";
 		lp->data = &at86rf212_data;
 		lp->hw->flags |= IEEE802154_HW_LBT;
-		lp->hw->phy->supported.channels[0] = 0x00007FF;
-		lp->hw->phy->supported.channels[2] = 0x00007FF;
+		lp->hw->phy->supported.page[0].nchunks = 1;
+		lp->hw->phy->supported.page[0].chunk[0].channels = 0x00007FF;
+		lp->hw->phy->supported.page[2].nchunks = 1;
+		lp->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
 		lp->hw->phy->current_channel = 5;
 		lp->hw->phy->symbol_duration = 25;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
@@ -1583,7 +1586,8 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 	case 11:
 		chip = "at86rf233";
 		lp->data = &at86rf233_data;
-		lp->hw->phy->supported.channels[0] = 0x7FFF800;
+		lp->hw->phy->supported.page[0].nchunks = 1;
+		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		lp->hw->phy->current_channel = 13;
 		lp->hw->phy->symbol_duration = 16;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 23ee0b14cbfa..38ebfacf2698 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -914,7 +914,8 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 	switch (part_num) {
 	case 2:
 		chip = "AT86RF230";
-		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
+		atusb->hw->phy->supported.page[0].nchunks = 1;
+		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
 		atusb->hw->phy->symbol_duration = 16;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
@@ -924,7 +925,8 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		break;
 	case 3:
 		chip = "AT86RF231";
-		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
+		atusb->hw->phy->supported.page[0].nchunks = 1;
+		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
 		atusb->hw->phy->symbol_duration = 16;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
@@ -935,8 +937,10 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 	case 7:
 		chip = "AT86RF212";
 		atusb->hw->flags |= IEEE802154_HW_LBT;
-		atusb->hw->phy->supported.channels[0] = 0x00007FF;
-		atusb->hw->phy->supported.channels[2] = 0x00007FF;
+		atusb->hw->phy->supported.page[0].nchunks = 1;
+		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x00007FF;
+		atusb->hw->phy->supported.page[2].nchunks = 1;
+		atusb->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
 		atusb->hw->phy->current_channel = 5;
 		atusb->hw->phy->symbol_duration = 25;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index ece6ff6049f6..1a667fceb8ba 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2962,7 +2962,8 @@ static const s32 ca8210_ed_levels[CA8210_MAX_ED_LEVELS] = {
 static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 {
 	/* Support channels 11-26 */
-	ca8210_hw->phy->supported.channels[0] = CA8210_VALID_CHANNELS;
+	ca8210_hw->phy->supported.page[0].nchunks = 1;
+	ca8210_hw->phy->supported.page[0].chunk[0].channels = CA8210_VALID_CHANNELS;
 	ca8210_hw->phy->supported.tx_powers_size = CA8210_MAX_TX_POWERS;
 	ca8210_hw->phy->supported.tx_powers = ca8210_tx_powers;
 	ca8210_hw->phy->supported.cca_ed_levels_size = CA8210_MAX_ED_LEVELS;
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 89c046b204e0..587f050ef4e8 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -836,7 +836,8 @@ static int cc2520_register(struct cc2520_private *priv)
 	ieee802154_random_extended_addr(&priv->hw->phy->perm_extended_addr);
 
 	/* We do support only 2.4 Ghz */
-	priv->hw->phy->supported.channels[0] = 0x7FFF800;
+	priv->hw->phy->supported.page[0].nchunks = 1;
+	priv->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 	priv->hw->flags = IEEE802154_HW_TX_OMIT_CKSUM | IEEE802154_HW_AFILT |
 			  IEEE802154_HW_PROMISCUOUS;
 
diff --git a/drivers/net/ieee802154/fakelb.c b/drivers/net/ieee802154/fakelb.c
index 523d13ee02bf..bc44d1f7551c 100644
--- a/drivers/net/ieee802154/fakelb.c
+++ b/drivers/net/ieee802154/fakelb.c
@@ -137,36 +137,49 @@ static int fakelb_add_one(struct device *dev)
 	phy = hw->priv;
 	phy->hw = hw;
 
+	hw->phy->supported.page[0].nchunks = 3;
 	/* 868 MHz BPSK	802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 1;
+	hw->phy->supported.page[0].chunk[0].channels |= 1;
 	/* 915 MHz BPSK	802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 0x7fe;
+	hw->phy->supported.page[0].chunk[1].channels |= 0x7fe;
 	/* 2.4 GHz O-QPSK 802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 0x7FFF800;
+	hw->phy->supported.page[0].chunk[2].channels |= 0x7FFF800;
+
+	hw->phy->supported.page[1].nchunks = 2;
 	/* 868 MHz ASK 802.15.4-2006 */
-	hw->phy->supported.channels[1] |= 1;
+	hw->phy->supported.page[1].chunk[0].channels |= 1;
 	/* 915 MHz ASK 802.15.4-2006 */
-	hw->phy->supported.channels[1] |= 0x7fe;
+	hw->phy->supported.page[1].chunk[1].channels |= 0x7fe;
+
+	hw->phy->supported.page[2].nchunks = 2;
 	/* 868 MHz O-QPSK 802.15.4-2006 */
-	hw->phy->supported.channels[2] |= 1;
+	hw->phy->supported.page[2].chunk[0].channels |= 1;
 	/* 915 MHz O-QPSK 802.15.4-2006 */
-	hw->phy->supported.channels[2] |= 0x7fe;
+	hw->phy->supported.page[2].chunk[1].channels |= 0x7fe;
+
+	hw->phy->supported.page[3].nchunks = 1;
 	/* 2.4 GHz CSS 802.15.4a-2007 */
-	hw->phy->supported.channels[3] |= 0x3fff;
+	hw->phy->supported.page[3].chunk[0].channels |= 0x3fff;
+
+	hw->phy->supported.page[4].nchunks = 3;
 	/* UWB Sub-gigahertz 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 1;
+	hw->phy->supported.page[4].chunk[0].channels |= 1;
 	/* UWB Low band 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 0x1e;
+	hw->phy->supported.page[4].chunk[1].channels |= 0x1e;
 	/* UWB High band 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 0xffe0;
+	hw->phy->supported.page[4].chunk[2].channels |= 0xffe0;
+
+	hw->phy->supported.page[5].nchunks = 2;
 	/* 750 MHz O-QPSK 802.15.4c-2009 */
-	hw->phy->supported.channels[5] |= 0xf;
+	hw->phy->supported.page[5].chunk[0].channels |= 0xf;
 	/* 750 MHz MPSK 802.15.4c-2009 */
-	hw->phy->supported.channels[5] |= 0xf0;
+	hw->phy->supported.page[5].chunk[1].channels |= 0xf0;
+
+	hw->phy->supported.page[6].nchunks = 2;
 	/* 950 MHz BPSK 802.15.4d-2009 */
-	hw->phy->supported.channels[6] |= 0x3ff;
+	hw->phy->supported.page[6].chunk[0].channels |= 0x3ff;
 	/* 950 MHz GFSK 802.15.4d-2009 */
-	hw->phy->supported.channels[6] |= 0x3ffc00;
+	hw->phy->supported.page[6].chunk[1].channels |= 0x3ffc00;
 
 	ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
 	/* fake phy channel 13 as default */
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 8caa61ec718f..3a491e755022 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -745,36 +745,49 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	phy = hw->priv;
 	phy->hw = hw;
 
+	hw->phy->supported.page[0].nchunks = 3;
 	/* 868 MHz BPSK	802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 1;
+	hw->phy->supported.page[0].chunk[0].channels |= 1;
 	/* 915 MHz BPSK	802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 0x7fe;
+	hw->phy->supported.page[0].chunk[1].channels |= 0x7fe;
 	/* 2.4 GHz O-QPSK 802.15.4-2003 */
-	hw->phy->supported.channels[0] |= 0x7FFF800;
+	hw->phy->supported.page[0].chunk[2].channels |= 0x7FFF800;
+
+	hw->phy->supported.page[1].nchunks = 2;
 	/* 868 MHz ASK 802.15.4-2006 */
-	hw->phy->supported.channels[1] |= 1;
+	hw->phy->supported.page[1].chunk[0].channels |= 1;
 	/* 915 MHz ASK 802.15.4-2006 */
-	hw->phy->supported.channels[1] |= 0x7fe;
+	hw->phy->supported.page[1].chunk[1].channels |= 0x7fe;
+
+	hw->phy->supported.page[2].nchunks = 2;
 	/* 868 MHz O-QPSK 802.15.4-2006 */
-	hw->phy->supported.channels[2] |= 1;
+	hw->phy->supported.page[2].chunk[0].channels |= 1;
 	/* 915 MHz O-QPSK 802.15.4-2006 */
-	hw->phy->supported.channels[2] |= 0x7fe;
+	hw->phy->supported.page[2].chunk[1].channels |= 0x7fe;
+
+	hw->phy->supported.page[3].nchunks = 1;
 	/* 2.4 GHz CSS 802.15.4a-2007 */
-	hw->phy->supported.channels[3] |= 0x3fff;
+	hw->phy->supported.page[3].chunk[0].channels |= 0x3fff;
+
+	hw->phy->supported.page[4].nchunks = 3;
 	/* UWB Sub-gigahertz 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 1;
+	hw->phy->supported.page[4].chunk[0].channels |= 1;
 	/* UWB Low band 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 0x1e;
+	hw->phy->supported.page[4].chunk[1].channels |= 0x1e;
 	/* UWB High band 802.15.4a-2007 */
-	hw->phy->supported.channels[4] |= 0xffe0;
+	hw->phy->supported.page[4].chunk[2].channels |= 0xffe0;
+
+	hw->phy->supported.page[5].nchunks = 2;
 	/* 750 MHz O-QPSK 802.15.4c-2009 */
-	hw->phy->supported.channels[5] |= 0xf;
+	hw->phy->supported.page[5].chunk[0].channels |= 0xf;
 	/* 750 MHz MPSK 802.15.4c-2009 */
-	hw->phy->supported.channels[5] |= 0xf0;
+	hw->phy->supported.page[5].chunk[1].channels |= 0xf0;
+
+	hw->phy->supported.page[6].nchunks = 2;
 	/* 950 MHz BPSK 802.15.4d-2009 */
-	hw->phy->supported.channels[6] |= 0x3ff;
+	hw->phy->supported.page[6].chunk[0].channels |= 0x3ff;
 	/* 950 MHz GFSK 802.15.4d-2009 */
-	hw->phy->supported.channels[6] |= 0x3ffc00;
+	hw->phy->supported.page[6].chunk[1].channels |= 0x3ffc00;
 
 	ieee802154_random_extended_addr(&hw->phy->perm_extended_addr);
 
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 8dc04e2590b1..5190c4d4f505 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1002,7 +1002,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 
 	phy->cca.mode = NL802154_CCA_ENERGY;
 
-	phy->supported.channels[0] = MCR20A_VALID_CHANNELS;
+	phy->supported.page[0].nchunks = 1;
+	phy->supported.page[0].chunk[0].channels = MCR20A_VALID_CHANNELS;
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index ff83e00b77af..5a38f3077771 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -1287,7 +1287,8 @@ static int mrf24j40_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, devrec);
 	devrec->hw = hw;
 	devrec->hw->parent = &spi->dev;
-	devrec->hw->phy->supported.channels[0] = CHANNEL_MASK;
+	devrec->hw->phy->supported.page[0].nchunks = 1;
+	devrec->hw->phy->supported.page[0].chunk[0].channels = CHANNEL_MASK;
 	devrec->hw->flags = IEEE802154_HW_TX_OMIT_CKSUM | IEEE802154_HW_AFILT |
 			    IEEE802154_HW_CSMA_PARAMS |
 			    IEEE802154_HW_PROMISCUOUS;
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 6ed07844eb24..ef49a23801c6 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -131,9 +131,18 @@ wpan_phy_supported_bool(bool b, enum nl802154_supported_bool_states st)
 	return false;
 }
 
+struct phy_channels {
+	u32 channels;
+};
+
+struct phy_page {
+	unsigned int nchunks;
+	struct phy_channels chunk[3];
+};
+
 struct wpan_phy_supported {
-	u32 channels[IEEE802154_MAX_PAGE + 1],
-	    cca_modes, cca_opts, iftypes;
+	struct phy_page page[IEEE802154_MAX_PAGE + 1];
+	u32 cca_modes, cca_opts, iftypes;
 	enum nl802154_supported_bool_states lbt;
 	u8 min_minbe, max_minbe, min_maxbe, max_maxbe,
 	   min_csma_backoffs, max_csma_backoffs;
diff --git a/net/ieee802154/core.h b/net/ieee802154/core.h
index 1c19f575d574..a0cf6feffc6a 100644
--- a/net/ieee802154/core.h
+++ b/net/ieee802154/core.h
@@ -47,4 +47,6 @@ struct cfg802154_registered_device *
 cfg802154_rdev_by_wpan_phy_idx(int wpan_phy_idx);
 struct wpan_phy *wpan_phy_idx_to_wpan_phy(int wpan_phy_idx);
 
+u32 cfg802154_get_supported_chans(struct wpan_phy *phy, unsigned int page);
+
 #endif /* __IEEE802154_CORE_H */
diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index dd5a45f8a78a..59e45e554834 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -31,6 +31,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
 	void *hdr;
 	int i, pages = 0;
 	uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
+	u32 chans;
 
 	pr_debug("%s\n", __func__);
 
@@ -48,8 +49,11 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
 	    nla_put_u8(msg, IEEE802154_ATTR_CHANNEL, phy->current_channel))
 		goto nla_put_failure;
 	for (i = 0; i < 32; i++) {
-		if (phy->supported.channels[i])
-			buf[pages++] = phy->supported.channels[i] | (i << 27);
+		chans = cfg802154_get_supported_chans(phy, i);
+		if (!chans)
+			continue;
+
+		buf[pages++] = chans | (i << 27);
 	}
 	if (pages &&
 	    nla_put(msg, IEEE802154_ATTR_CHANNEL_PAGE_LIST,
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 277124f206e0..45e2c9b0505a 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -320,6 +320,21 @@ nl802154_put_flags(struct sk_buff *msg, int attr, u32 mask)
 	return 0;
 }
 
+u32 cfg802154_get_supported_chans(struct wpan_phy *phy, unsigned int page)
+{
+	struct phy_page *ppage;
+	unsigned int chunk;
+	u32 supported = 0;
+
+	ppage = &phy->supported.page[page];
+
+	for (chunk = 0; chunk <= ppage->nchunks; chunk++)
+		supported |= ppage->chunk[chunk].channels;
+
+	return supported;
+}
+EXPORT_SYMBOL(cfg802154_get_supported_chans);
+
 static int
 nl802154_send_wpan_phy_channels(struct cfg802154_registered_device *rdev,
 				struct sk_buff *msg)
@@ -333,7 +348,7 @@ nl802154_send_wpan_phy_channels(struct cfg802154_registered_device *rdev,
 
 	for (page = 0; page <= IEEE802154_MAX_PAGE; page++) {
 		if (nla_put_u32(msg, NL802154_ATTR_SUPPORTED_CHANNEL,
-				rdev->wpan_phy.supported.channels[page]))
+				cfg802154_get_supported_chans(&rdev->wpan_phy, page)))
 			return -ENOBUFS;
 	}
 	nla_nest_end(msg, nl_page);
@@ -347,6 +362,7 @@ nl802154_put_capabilities(struct sk_buff *msg,
 {
 	const struct wpan_phy_supported *caps = &rdev->wpan_phy.supported;
 	struct nlattr *nl_caps, *nl_channels;
+	u32 chans;
 	int i;
 
 	nl_caps = nla_nest_start_noflag(msg, NL802154_ATTR_WPAN_PHY_CAPS);
@@ -358,10 +374,12 @@ nl802154_put_capabilities(struct sk_buff *msg,
 		return -ENOBUFS;
 
 	for (i = 0; i <= IEEE802154_MAX_PAGE; i++) {
-		if (caps->channels[i]) {
-			if (nl802154_put_flags(msg, i, caps->channels[i]))
-				return -ENOBUFS;
-		}
+		chans = cfg802154_get_supported_chans(&rdev->wpan_phy, i);
+		if (!chans)
+			continue;
+
+		if (nl802154_put_flags(msg, i, chans))
+			return -ENOBUFS;
 	}
 
 	nla_nest_end(msg, nl_channels);
@@ -965,7 +983,7 @@ static int nl802154_set_channel(struct sk_buff *skb, struct genl_info *info)
 
 	/* check 802.15.4 constraints */
 	if (page > IEEE802154_MAX_PAGE || channel > IEEE802154_MAX_CHANNEL ||
-	    !(rdev->wpan_phy.supported.channels[page] & BIT(channel)))
+	    !(cfg802154_get_supported_chans(&rdev->wpan_phy, page) & BIT(channel)))
 		return -EINVAL;
 
 	return rdev_set_channel(rdev, page, channel);
-- 
2.27.0

