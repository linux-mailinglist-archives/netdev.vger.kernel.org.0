Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB734944C9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357876AbiATAhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357868AbiATAg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:36:59 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C35BC06173F;
        Wed, 19 Jan 2022 16:36:58 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 551A2C000A;
        Thu, 20 Jan 2022 00:36:55 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 5/9] net: ieee802154: ca8210: Stop leaking skb's
Date:   Thu, 20 Jan 2022 01:36:41 +0100
Message-Id: <20220120003645.308498-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120003645.308498-1-miquel.raynal@bootlin.com>
References: <20220120003645.308498-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon error the ieee802154_xmit_complete() helper is not called. Only
ieee802154_wake_queue() is called manually. We then leak the skb
structure.

Free the skb structure upon error before returning.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index ece6ff6049f6..5d1b356cb9d3 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1772,6 +1772,7 @@ static int ca8210_async_xmit_complete(
 		);
 		if (status != MAC_TRANSACTION_OVERFLOW) {
 			ieee802154_wake_queue(priv->hw);
+			dev_kfree_skb_any(atusb->tx_skb);
 			return 0;
 		}
 	}
-- 
2.27.0

