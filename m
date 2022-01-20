Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6286494CC4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiATLVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:21:31 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48071 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiATLVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:21:25 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2A6DAC0009;
        Thu, 20 Jan 2022 11:21:22 +0000 (UTC)
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
Subject: [wpan-next v2 3/9] net: ieee802154: mcr20a: Fix lifs/sifs periods
Date:   Thu, 20 Jan 2022 12:21:09 +0100
Message-Id: <20220120112115.448077-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These periods are expressed in time units (microseconds) while 40 and 12
are the number of symbol durations these periods will last. We need to
multiply them both with phy->symbol_duration in order to get these
values in microseconds.

Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mcr20a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c
index 8dc04e2590b1..383231b85464 100644
--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -976,8 +976,8 @@ static void mcr20a_hw_setup(struct mcr20a_local *lp)
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
 	phy->symbol_duration = 16;
-	phy->lifs_period = 40;
-	phy->sifs_period = 12;
+	phy->lifs_period = 40 * phy->symbol_duration;
+	phy->sifs_period = 12 * phy->symbol_duration;
 
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM |
 			IEEE802154_HW_AFILT |
-- 
2.27.0

