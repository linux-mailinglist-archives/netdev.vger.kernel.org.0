Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1554907A6
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiAQLz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:28 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39685 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbiAQLzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:20 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 2CEEA200012;
        Mon, 17 Jan 2022 11:55:17 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 18/41] net: ieee802154: atusb: Call the complete helper when a transmission is over
Date:   Mon, 17 Jan 2022 12:54:17 +0100
Message-Id: <20220117115440.60296-19-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_complete() is the right helper to call when a
transmission is over. The fact that it completed or not is not really a
question, but drivers must tell the core that the completion is over,
even if it was canceled. Do not call ieee802154_wake_queue() manually,
in order to let full control of this task to the core.

Here the skb is freed with a particular helper because it is done in irq
context. It is not necessary to do that as the *_xmit_complete() helper
will handle it properly anyway.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/atusb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 1a56073c1c52..4bc7b2dcbdd2 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -262,19 +262,16 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
 	u8 expect = atusb->tx_ack_seq;
 
 	dev_dbg(&usb_dev->dev, "%s (0x%02x/0x%02x)\n", __func__, seq, expect);
-	if (seq == expect) {
-		/* TODO check for ifs handling in firmware */
-		ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
-	} else {
-		/* TODO I experience this case when atusb has a tx complete
-		 * irq before probing, we should fix the firmware it's an
-		 * unlikely case now that seq == expect is then true, but can
-		 * happen and fail with a tx_skb = NULL;
-		 */
-		ieee802154_wake_queue(atusb->hw);
-		if (atusb->tx_skb)
-			dev_kfree_skb_irq(atusb->tx_skb);
-	}
+
+	/* TODO:
+	 * seq == expect: Check for ifs handling in firmware.
+	 * seq != expect: I experience this case when atusb has a tx complete
+	 * irq before probing, we should fix the firmware it's an unlikely case
+	 * now that seq == expect is then true, but can happen and fail with a
+	 * tx_skb = NULL;
+	 */
+
+	ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
 }
 
 static void atusb_in_good(struct urb *urb)
-- 
2.27.0

