Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509F548C97F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355658AbiALRdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:33 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:33093 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355632AbiALRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:29 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id E985D2000B;
        Wed, 12 Jan 2022 17:33:23 +0000 (UTC)
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
Subject: [wpan-next v2 05/27] net: mac802154: Convert the symbol duration into nanoseconds
Date:   Wed, 12 Jan 2022 18:32:50 +0100
Message-Id: <20220112173312.764660-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tdsym is often given in the spec as pretty small numbers in microseconds
and hence was reflected in the code as symbol_duration and was stored as
a u8. Actually, for UWB PHYs, the symbol duration is given in
nanoseconds and are as precise as picoseconds. In order to handle better
these PHYs, change the type of symbol_duration to u32 and store this
value in nanoseconds.

All the users of this variable are updated in a mechanical change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 22 +++++++++++-----------
 drivers/net/ieee802154/atusb.c     | 22 +++++++++++-----------
 drivers/net/ieee802154/ca8210.c    |  2 +-
 drivers/net/ieee802154/mcr20a.c    |  4 ++--
 include/net/cfg802154.h            |  4 ++--
 net/mac802154/main.c               |  8 ++++----
 6 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index cdf5d2a4f763..47dafefedf79 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1066,24 +1066,24 @@ at86rf212_set_channel(struct at86rf230_local *lp, u8 page, u8 channel)
 	if (channel == 0) {
 		if (page == 0) {
 			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50;
+			lp->hw->phy->symbol_duration = 50 * 1000;
 		} else {
 			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25;
+			lp->hw->phy->symbol_duration = 25 * 1000;
 		}
 	} else {
 		if (page == 0)
 			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40;
+			lp->hw->phy->symbol_duration = 40 * 1000;
 		else
 			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16;
+			lp->hw->phy->symbol_duration = 16 * 1000;
 	}
 
-	lp->hw->phy->lifs_period = IEEE802154_LIFS_PERIOD *
-				   lp->hw->phy->symbol_duration;
-	lp->hw->phy->sifs_period = IEEE802154_SIFS_PERIOD *
-				   lp->hw->phy->symbol_duration;
+	lp->hw->phy->lifs_period =
+		(IEEE802154_LIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
+	lp->hw->phy->sifs_period =
+		(IEEE802154_SIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
 
 	return at86rf230_write_subreg(lp, SR_CHANNEL, channel);
 }
@@ -1561,7 +1561,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[0].nchunks = 1;
 		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		lp->hw->phy->current_channel = 11;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * 1000;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf231_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf231_ed_levels;
@@ -1576,7 +1576,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[2].nchunks = 1;
 		lp->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
 		lp->hw->phy->current_channel = 5;
-		lp->hw->phy->symbol_duration = 25;
+		lp->hw->phy->symbol_duration = 25 * 1000;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		lp->hw->phy->supported.tx_powers = at86rf212_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
@@ -1589,7 +1589,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[0].nchunks = 1;
 		lp->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		lp->hw->phy->current_channel = 13;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * 1000;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf233_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf233_ed_levels;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 38ebfacf2698..099113bd4a26 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -678,24 +678,24 @@ static int hulusb_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 	if (channel == 0) {
 		if (page == 0) {
 			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50;
+			lp->hw->phy->symbol_duration = 50 * 1000;
 		} else {
 			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25;
+			lp->hw->phy->symbol_duration = 25 * 1000;
 		}
 	} else {
 		if (page == 0)
 			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40;
+			lp->hw->phy->symbol_duration = 40 * 1000;
 		else
 			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16;
+			lp->hw->phy->symbol_duration = 16 * 1000;
 	}
 
-	lp->hw->phy->lifs_period = IEEE802154_LIFS_PERIOD *
-				   lp->hw->phy->symbol_duration;
-	lp->hw->phy->sifs_period = IEEE802154_SIFS_PERIOD *
-				   lp->hw->phy->symbol_duration;
+	lp->hw->phy->lifs_period =
+		(IEEE802154_LIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
+	lp->hw->phy->sifs_period =
+		(IEEE802154_SIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
 
 	return atusb_write_subreg(lp, SR_CHANNEL, channel);
 }
@@ -917,7 +917,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[0].nchunks = 1;
 		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * 1000;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -928,7 +928,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[0].nchunks = 1;
 		atusb->hw->phy->supported.page[0].chunk[0].channels = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * 1000;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -942,7 +942,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[2].nchunks = 1;
 		atusb->hw->phy->supported.page[2].chunk[0].channels = 0x00007FF;
 		atusb->hw->phy->current_channel = 5;
-		atusb->hw->phy->symbol_duration = 25;
+		atusb->hw->phy->symbol_duration = 25 * 1000;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		atusb->hw->phy->supported.tx_powers = at86rf212_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index f42a0b719a33..82b2a173bdbd 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2977,7 +2977,7 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
-	ca8210_hw->phy->symbol_duration = 16;
+	ca8210_hw->phy->symbol_duration = 16 * 1000;
 	ca8210_hw->phy->lifs_period = 40;
 	ca8210_hw->phy->sifs_period = 12;
 	ca8210_hw->flags =
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index f0eb2d3b1c4e..8aa87e9bf92e 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -975,7 +975,7 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
-	phy->symbol_duration = 16;
+	phy->symbol_duration = 16 * 1000;
 	phy->lifs_period = 40;
 	phy->sifs_period = 12;
 
@@ -1010,7 +1010,7 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
-	phy->symbol_duration = 16;
+	phy->symbol_duration = 16 * 1000;
 	phy->supported.tx_powers = mcr20a_powers;
 	phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
 	phy->cca_ed_level = phy->supported.cca_ed_levels[75];
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 03c8008217fb..286709a9dd0b 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -253,8 +253,8 @@ struct wpan_phy {
 
 	/* PHY depended MAC PIB values */
 
-	/* 802.15.4 acronym: Tdsym in usec */
-	u8 symbol_duration;
+	/* 802.15.4 acronym: Tdsym in nsec */
+	u32 symbol_duration;
 	/* lifs and sifs periods timing */
 	u16 lifs_period;
 	u16 sifs_period;
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 12ab1545e871..77a4943f345f 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -131,10 +131,10 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
 	 * Should be done when all drivers sets this value.
 	 */
 
-	wpan_phy->lifs_period = IEEE802154_LIFS_PERIOD *
-				wpan_phy->symbol_duration;
-	wpan_phy->sifs_period = IEEE802154_SIFS_PERIOD *
-				wpan_phy->symbol_duration;
+	wpan_phy->lifs_period =
+		(IEEE802154_LIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
+	wpan_phy->sifs_period =
+		(IEEE802154_SIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
 }
 
 int ieee802154_register_hw(struct ieee802154_hw *hw)
-- 
2.27.0

