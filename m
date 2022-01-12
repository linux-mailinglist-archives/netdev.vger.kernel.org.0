Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4C48C987
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355737AbiALRdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:33:50 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55691 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355676AbiALRdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:33:35 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 7B14A20009;
        Wed, 12 Jan 2022 17:33:30 +0000 (UTC)
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
Subject: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration settings when the core does it already
Date:   Wed, 12 Jan 2022 18:32:53 +0100
Message-Id: <20220112173312.764660-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core now knows how to set the symbol duration in a few cases, when
drivers correctly advertise the protocols used on each channel. For
these drivers, there is no more need to bother with symbol duration, so
just drop the duplicated code.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 1 -
 drivers/net/ieee802154/mcr20a.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 82b2a173bdbd..d3a9e4fe05f4 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2977,7 +2977,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.mode = NL802154_CCA_ENERGY_CARRIER;
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
-	ca8210_hw->phy->symbol_duration = 16 * 1000;
 	ca8210_hw->phy->lifs_period = 40;
 	ca8210_hw->phy->sifs_period = 12;
 	ca8210_hw->flags =
diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 8aa87e9bf92e..da2ab19cb5ee 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -975,7 +975,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
-	phy->symbol_duration = 16 * 1000;
 	phy->lifs_period = 40;
 	phy->sifs_period = 12;
 
@@ -1010,7 +1009,6 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	phy->current_page = 0;
 	/* MCR20A default reset value */
 	phy->current_channel = 20;
-	phy->symbol_duration = 16 * 1000;
 	phy->supported.tx_powers = mcr20a_powers;
 	phy->supported.tx_powers_size = ARRAY_SIZE(mcr20a_powers);
 	phy->cca_ed_level = phy->supported.cca_ed_levels[75];
-- 
2.27.0

