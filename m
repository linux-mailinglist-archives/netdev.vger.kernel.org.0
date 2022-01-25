Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7349B3CA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444901AbiAYMRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359466AbiAYMOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:14:43 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7983CC061749;
        Tue, 25 Jan 2022 04:14:42 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 58D9F10000F;
        Tue, 25 Jan 2022 12:14:35 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan v3 3/6] net: ieee802154: at86rf230: Stop leaking skb's
Date:   Tue, 25 Jan 2022 13:14:23 +0100
Message-Id: <20220125121426.848337-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125121426.848337-1-miquel.raynal@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon error the ieee802154_xmit_complete() helper is not called. Only
ieee802154_wake_queue() is called manually. In the Tx case we then leak
the skb structure.

Free the skb structure upon error before returning when appropriate.

As the 'is_tx = 0' cannot be moved in the complete handler because of a
possible race between the delay in switching to STATE_RX_AACK_ON and a
new interrupt, we introduce an intermediate 'was_tx' boolean just for
this purpose.

There is no Fixes tag applying here, many changes have been made on this
area and the issue kind of always existed.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 7d67f41387f5..4f5ef8a9a9a8 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -100,6 +100,7 @@ struct at86rf230_local {
 	unsigned long cal_timeout;
 	bool is_tx;
 	bool is_tx_from_off;
+	bool was_tx;
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
@@ -343,7 +344,11 @@ at86rf230_async_error_recover_complete(void *context)
 	if (ctx->free)
 		kfree(ctx);
 
-	ieee802154_wake_queue(lp->hw);
+	if (lp->was_tx) {
+		lp->was_tx = 0;
+		dev_kfree_skb_any(lp->tx_skb);
+		ieee802154_wake_queue(lp->hw);
+	}
 }
 
 static void
@@ -352,7 +357,11 @@ at86rf230_async_error_recover(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	lp->is_tx = 0;
+	if (lp->is_tx) {
+		lp->was_tx = 1;
+		lp->is_tx = 0;
+	}
+
 	at86rf230_async_state_change(lp, ctx, STATE_RX_AACK_ON,
 				     at86rf230_async_error_recover_complete);
 }
-- 
2.27.0

