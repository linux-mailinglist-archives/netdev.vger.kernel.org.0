Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD7F4A632C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbiBASGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBASGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:06:38 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AF0C061714;
        Tue,  1 Feb 2022 10:06:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7BA60C000F;
        Tue,  1 Feb 2022 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHbJxd+H2L4MimOqR8M0PxUSJYtT7x4rRcT/bkvNJa8=;
        b=E8ek7qkLxkgdvNYzgdW6POOzpnPC9FaOd3roSstNNSh1owH29HZFK0G85nLmt+UbQhEFIN
        809VhYwj8P7M+Dxggy+LmvfzswylsTp/kT6Mh85/QTEDVDt3lZ5Vu1ND5zKYVHjr15Al2/
        1SqzLSDeOtaZgZD6GxmLPiCRPRXu9x64K1lwYKhEbbe4eX2snwnInA+guyGDzgH9DYJ++z
        W0vgvuVUe4oZA/e9hwEDUBMcIeb2Yc6ZghouSQeFFzucIP9PgyZTXXoM7LGFalaZkZTmmn
        vcLqJuy8K1LGrHpT9stkMZXqUZQ07PUDBSy8p5cfn5BMJDcqs0ONvfkmHGQX0Q==
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
Subject: [PATCH wpan-next v3 2/4] net: mac802154: Convert the symbol duration into nanoseconds
Date:   Tue,  1 Feb 2022 19:06:27 +0100
Message-Id: <20220201180629.93410-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
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
index 4f5ef8a9a9a8..0264e43a1080 100644
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
@@ -1569,7 +1569,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf231_data;
 		lp->hw->phy->supported.channels[0] = 0x7FFF800;
 		lp->hw->phy->current_channel = 11;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf231_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf231_ed_levels;
@@ -1582,7 +1582,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.channels[0] = 0x00007FF;
 		lp->hw->phy->supported.channels[2] = 0x00007FF;
 		lp->hw->phy->current_channel = 5;
-		lp->hw->phy->symbol_duration = 25;
+		lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		lp->hw->phy->supported.tx_powers = at86rf212_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
@@ -1594,7 +1594,7 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf233_data;
 		lp->hw->phy->supported.channels[0] = 0x7FFF800;
 		lp->hw->phy->current_channel = 13;
-		lp->hw->phy->symbol_duration = 16;
+		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf233_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf233_ed_levels;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 23ee0b14cbfa..eb27d0fb4f5f 100644
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
@@ -916,7 +916,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF230";
 		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -926,7 +926,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF231";
 		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16;
+		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -938,7 +938,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.channels[0] = 0x00007FF;
 		atusb->hw->phy->supported.channels[2] = 0x00007FF;
 		atusb->hw->phy->current_channel = 5;
-		atusb->hw->phy->symbol_duration = 25;
+		atusb->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		atusb->hw->phy->supported.tx_powers = at86rf212_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 2bc730fd260e..e88cdbf6673b 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2974,7 +2974,7 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
-	ca8210_hw->phy->symbol_duration = 16;
+	ca8210_hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->flags =
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 383231b85464..c925e629ddf3 100644
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
@@ -1006,7 +1006,7 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
-	phy->symbol_duration = 16;
+	phy->symbol_duration = 16 * NSEC_PER_USEC;
 	phy->supported.tx_powers = mcr20a_powers;
 	phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
 	phy->cca_ed_level = phy->supported.cca_ed_levels[75];
diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 6ed07844eb24..8a4b6a50452f 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -203,8 +203,8 @@ struct wpan_phy {
 
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

