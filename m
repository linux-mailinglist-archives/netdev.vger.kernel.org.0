Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26C4A6330
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbiBASGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241780AbiBASGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:06:42 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12A5C061714;
        Tue,  1 Feb 2022 10:06:40 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 14608C0012;
        Tue,  1 Feb 2022 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9fmcW0+tCYntuRcE31Aa1Sgx07ZuGbl0uF4LQI6EME=;
        b=C2Qjznj04o0MSanJ5NjsorZobIgpID9Pd3Atz23Iu9oaYsmudo90YaQvZ5Pzr++vuleQCK
        QdWvkWLpdv6ch9Ar1z1gL6MHoAihEQjV9BDNX3AJYWLxpXWwUpsSlj3TaZAWkUxbmNeTR9
        OoRqcaQ+e5gMhLxVigbehFg/p7bTv/YfP166Mc1RrSrGFvry2iK+vxlhZgNdjZLMdEwqKh
        dM5TZYi/SYRXzBp6ctYJTHKwkQ1R4dQUJiVIRuCjTIg45MUsppf+JC6NJExGXb6F820eCM
        3OE/w1qcBPh0emstoITM+REMjkphx3L4WJnGmG9/s1nqNwAGYeq2gQKc4zGcaQ==
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
Subject: [PATCH wpan-next v3 4/4] net: ieee802154: Drop duration settings when the core does it already
Date:   Tue,  1 Feb 2022 19:06:29 +0100
Message-Id: <20220201180629.93410-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core now knows how to set the symbol duration in a few cases, when
drivers correctly advertise the protocols used on each channel. For
these drivers, there is no more need to bother with symbol duration,
lifs and sifs periods so just drop the duplicated code.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 33 ------------------------------
 drivers/net/ieee802154/atusb.c     | 33 ------------------------------
 drivers/net/ieee802154/ca8210.c    |  3 ---
 drivers/net/ieee802154/mcr20a.c    |  5 -----
 4 files changed, 74 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 0264e43a1080..563031ce76f0 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -1064,36 +1064,6 @@ at86rf212_set_channel(struct at86rf230_local *lp, u8 page, u8 channel)
 	if (rc < 0)
 		return rc;
 
-	/* This sets the symbol_duration according frequency on the 212.
-	 * TODO move this handling while set channel and page in cfg802154.
-	 * We can do that, this timings are according 802.15.4 standard.
-	 * If we do that in cfg802154, this is a more generic calculation.
-	 *
-	 * This should also protected from ifs_timer. Means cancel timer and
-	 * init with a new value. For now, this is okay.
-	 */
-	if (channel == 0) {
-		if (page == 0) {
-			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50 * NSEC_PER_USEC;
-		} else {
-			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
-		}
-	} else {
-		if (page == 0)
-			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40 * NSEC_PER_USEC;
-		else
-			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
-	}
-
-	lp->hw->phy->lifs_period =
-		(IEEE802154_LIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
-	lp->hw->phy->sifs_period =
-		(IEEE802154_SIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
-
 	return at86rf230_write_subreg(lp, SR_CHANNEL, channel);
 }
 
@@ -1569,7 +1539,6 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf231_data;
 		lp->hw->phy->supported.channels[0] = 0x7FFF800;
 		lp->hw->phy->current_channel = 11;
-		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf231_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf231_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf231_ed_levels;
@@ -1582,7 +1551,6 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->hw->phy->supported.channels[0] = 0x00007FF;
 		lp->hw->phy->supported.channels[2] = 0x00007FF;
 		lp->hw->phy->current_channel = 5;
-		lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		lp->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		lp->hw->phy->supported.tx_powers = at86rf212_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
@@ -1594,7 +1562,6 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 		lp->data = &at86rf233_data;
 		lp->hw->phy->supported.channels[0] = 0x7FFF800;
 		lp->hw->phy->current_channel = 13;
-		lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		lp->hw->phy->supported.tx_powers = at86rf233_powers;
 		lp->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf233_powers);
 		lp->hw->phy->supported.cca_ed_levels = at86rf233_ed_levels;
diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index eb27d0fb4f5f..f27a5f535808 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -667,36 +667,6 @@ static int hulusb_set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 	if (rc < 0)
 		return rc;
 
-	/* This sets the symbol_duration according frequency on the 212.
-	 * TODO move this handling while set channel and page in cfg802154.
-	 * We can do that, this timings are according 802.15.4 standard.
-	 * If we do that in cfg802154, this is a more generic calculation.
-	 *
-	 * This should also protected from ifs_timer. Means cancel timer and
-	 * init with a new value. For now, this is okay.
-	 */
-	if (channel == 0) {
-		if (page == 0) {
-			/* SUB:0 and BPSK:0 -> BPSK-20 */
-			lp->hw->phy->symbol_duration = 50 * NSEC_PER_USEC;
-		} else {
-			/* SUB:1 and BPSK:0 -> BPSK-40 */
-			lp->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
-		}
-	} else {
-		if (page == 0)
-			/* SUB:0 and BPSK:1 -> OQPSK-100/200/400 */
-			lp->hw->phy->symbol_duration = 40 * NSEC_PER_USEC;
-		else
-			/* SUB:1 and BPSK:1 -> OQPSK-250/500/1000 */
-			lp->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
-	}
-
-	lp->hw->phy->lifs_period =
-		(IEEE802154_LIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
-	lp->hw->phy->sifs_period =
-		(IEEE802154_SIFS_PERIOD * lp->hw->phy->symbol_duration) / 1000;
-
 	return atusb_write_subreg(lp, SR_CHANNEL, channel);
 }
 
@@ -916,7 +886,6 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF230";
 		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -926,7 +895,6 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		chip = "AT86RF231";
 		atusb->hw->phy->supported.channels[0] = 0x7FFF800;
 		atusb->hw->phy->current_channel = 11;	/* reset default */
-		atusb->hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.tx_powers = atusb_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(atusb_powers);
 		hw->phy->supported.cca_ed_levels = atusb_ed_levels;
@@ -938,7 +906,6 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 		atusb->hw->phy->supported.channels[0] = 0x00007FF;
 		atusb->hw->phy->supported.channels[2] = 0x00007FF;
 		atusb->hw->phy->current_channel = 5;
-		atusb->hw->phy->symbol_duration = 25 * NSEC_PER_USEC;
 		atusb->hw->phy->supported.lbt = NL802154_SUPPORTED_BOOL_BOTH;
 		atusb->hw->phy->supported.tx_powers = at86rf212_powers;
 		atusb->hw->phy->supported.tx_powers_size = ARRAY_SIZE(at86rf212_powers);
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e88cdbf6673b..fc74fa0f1ddd 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2974,9 +2974,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
-	ca8210_hw->phy->symbol_duration = 16 * NSEC_PER_USEC;
-	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
-	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->flags =
 		IEEE802154_HW_AFILT |
 		IEEE802154_HW_OMIT_CKSUM |
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index c925e629ddf3..2b4ba3f9ecd7 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -975,10 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
-	phy->symbol_duration = 16 * NSEC_PER_USEC;
-	phy->lifs_period = (40 * phy->symbol_duration) / NSEC_PER_USEC;
-	phy->sifs_period = (12 * phy->symbol_duration) / NSEC_PER_USEC;
-
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM |
 			IEEE802154_HW_AFILT |
 			IEEE802154_HW_PROMISCUOUS;
@@ -1006,7 +1002,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
-	phy->symbol_duration = 16 * NSEC_PER_USEC;
 	phy->supported.tx_powers = mcr20a_powers;
 	phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
 	phy->cca_ed_level = phy->supported.cca_ed_levels[75];
-- 
2.27.0

