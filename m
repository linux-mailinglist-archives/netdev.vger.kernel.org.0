Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C670A49F7E3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbiA1LIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiA1LIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:08:35 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C53C06173B;
        Fri, 28 Jan 2022 03:08:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 28CF110000A;
        Fri, 28 Jan 2022 11:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NqoR6Hg0CZc1pdU+roSRWQu7+FCtC4C31ekHe+ga+8U=;
        b=guVzq198QrBwyrAnEyMpQPOZ1mXz5hT+StL4L8ORqEtWtIZ/1RNDTE/7/+VP+dhoZREbp/
        jAWgxRPgDHyh7vhgF8XsL6w8Cd47UpJD9Y9mCv/sxRKTJ8iKmYtyX/ovT4BzPxlImHsrYz
        IayKcGt8OwlAyb4WAUqiLqPOcWD+scZNodpmEGtHdBWkH7VtzYhUPkz16R517Qa1a4XrOf
        zpC7zL6LUzbcDK4uTbV4b5B+Tmr3hYid+kcrqKeM5SV+kenlHeWRgQmUBTCtkaTjl1aRTM
        pkH1rN+rWrmhPD1MdUiKXMVdX5HI6gybvYKemQr3v/zEOaopC39PCLsHCyx1eg==
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
Subject: [PATCH wpan-next v2 3/5] net: mac802154: Convert the symbol duration into nanoseconds
Date:   Fri, 28 Jan 2022 12:08:23 +0100
Message-Id: <20220128110825.1120678-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
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

All the users of this variable are updated in a mechanical way.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 22 +++++++++++-----------
 drivers/net/ieee802154/atusb.c     | 22 +++++++++++-----------
 drivers/net/ieee802154/ca8210.c    |  2 +-
 drivers/net/ieee802154/mcr20a.c    |  8 ++++----
 include/net/cfg802154.h            |  4 ++--
 net/mac802154/main.c               |  8 ++++----
 6 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index d3dc03926246..b08f08475426 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1075,24 +1075,24 @@ at86rf212_set_channel(struct at86rf230_local *lp, u8 page, u8 channel)
 	if (channel == 0) {
 		if (page == 0) {
 			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50;
+			lp->hw->phy->symbol_duration = 50 * NSEC_PER_USEC;
 		} else {
 			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25;
+			lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		}
 	} else {
 		if (page == 0)
 			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40;
+			lp->hw->phy->symbol_duration = 40 * NSEC_PER_USEC;
 		else
 			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16;
+			lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
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
@@ -1572,7 +1572,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
 		lp->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		lp->hw->phy->current_channel = 11;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf231_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf231_ed_levels;
@@ -1604,7 +1604,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[2].chunk[1].band = IEEE802154_915_MHZ_BAND;
 
 		lp->hw->phy->current_channel = 5;
-		lp->hw->phy->symbol_duration = 25;
+		lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		lp->hw->phy->supported.tx_powers = at86rf212_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
@@ -1619,7 +1619,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
 		lp->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		lp->hw->phy->current_channel = 13;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf233_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf233_ed_levels;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 7e8c9d6db7d7..80382919520e 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -678,24 +678,24 @@ static int hulusb_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 	if (channel == 0) {
 		if (page == 0) {
 			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50;
+			lp->hw->phy->symbol_duration = 50 * NSEC_PER_USEC;
 		} else {
 			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25;
+			lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		}
 	} else {
 		if (page == 0)
 			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40;
+			lp->hw->phy->symbol_duration = 40 * NSEC_PER_USEC;
 		else
 			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16;
+			lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
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
@@ -919,7 +919,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
 		atusb->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -932,7 +932,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[0].chunk[0].protocol = IEEE802154_OQPSK_PHY;
 		atusb->hw->phy->supported.page[0].chunk[0].band = IEEE802154_2400_MHZ_BAND;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -963,7 +963,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.page[2].chunk[1].band = IEEE802154_915_MHZ_BAND;
 
 		atusb->hw->phy->current_channel = 5;
-		atusb->hw->phy->symbol_duration = 25;
+		atusb->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		atusb->hw->phy->supported.tx_powers = at86rf212_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index b4ba38151576..8eb48a8014db 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2978,7 +2978,7 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
-	ca8210_hw->phy->symbol_duration = 16;
+	ca8210_hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 	ca8210_hw->phy->lifs_period = 40;
 	ca8210_hw->phy->sifs_period = 12;
 	ca8210_hw->flags =
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index e2c249aef430..34063b7e663e 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -975,9 +975,9 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
-	phy->symbol_duration = 16;
-	phy->lifs_period = 40 * phy->symbol_duration;
-	phy->sifs_period = 12 * phy->symbol_duration;
+	phy->symbol_duration = 16 * NSEC_PER_USEC;
+	phy->lifs_period = (40 * phy->symbol_duration) / NSEC_PER_USEC;
+	phy->sifs_period = (12 * phy->symbol_duration) / NSEC_PER_USEC;
 
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM |
 			IEEE802154_HW_AFILT |
@@ -1010,7 +1010,7 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
-	phy->symbol_duration = 16;
+	phy->symbol_duration = 16 * NSEC_PER_USEC;
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
index 520cedc594e1..53153367f9d0 100644
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

