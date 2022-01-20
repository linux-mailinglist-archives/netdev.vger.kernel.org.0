Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D870349451E
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357970AbiATAvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:33 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:41565 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357953AbiATAvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:32 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 041AE100007;
        Thu, 20 Jan 2022 00:51:29 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 04/14] net: ieee802154: atusb: Call _xmit_error() when a transmission fails
Date:   Thu, 20 Jan 2022 01:51:12 +0100
Message-Id: <20220120005122.309104-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/atusb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 1a56073c1c52..c9664a57e2f0 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -271,9 +271,7 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
 		 * unlikely case now that seq == expect is then true, but can
 		 * happen and fail with a tx_skb = NULL;
 		 */
-		ieee802154_wake_queue(atusb->hw);
-		if (atusb->tx_skb)
-			dev_kfree_skb_irq(atusb->tx_skb);
+		ieee802154_xmit_error(atusb->hw, atusb->tx_skb, false);
 	}
 }
 
-- 
2.27.0

