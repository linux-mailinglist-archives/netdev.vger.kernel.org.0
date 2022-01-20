Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEC74944D4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357825AbiATAhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357894AbiATAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:37:04 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1FBC06173F;
        Wed, 19 Jan 2022 16:37:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7619EC0004;
        Thu, 20 Jan 2022 00:37:00 +0000 (UTC)
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
Subject: [wpan-next 8/9] net: mac802154: Explain the use of ieee802154_wake/stop_queue()
Date:   Thu, 20 Jan 2022 01:36:44 +0100
Message-Id: <20220120003645.308498-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120003645.308498-1-miquel.raynal@bootlin.com>
References: <20220120003645.308498-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not straightforward to the newcomer that a single skb can be sent
at a time and that the internal process is to stop the queue when
processing a frame before re-enabling it. Make this clear by documenting
the ieee802154_wake/stop_queue() helpers.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index d524ffb9eb25..94b2e3008e77 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -464,6 +464,12 @@ void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
  * ieee802154_wake_queue - wake ieee802154 queue
  * @hw: pointer as obtained from ieee802154_alloc_hw().
  *
+ * Tranceivers have either one transmit framebuffer or one framebuffer for both
+ * transmitting and receiving. Hence, the core only handles one frame at a time
+ * for each phy, which means we had to stop the queue to avoid new skb to come
+ * during the transmission. The queue then needs to be woken up after the
+ * operation.
+ *
  * Drivers should use this function instead of netif_wake_queue.
  */
 void ieee802154_wake_queue(struct ieee802154_hw *hw);
@@ -472,6 +478,12 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw);
  * ieee802154_stop_queue - stop ieee802154 queue
  * @hw: pointer as obtained from ieee802154_alloc_hw().
  *
+ * Tranceivers have either one transmit framebuffer or one framebuffer for both
+ * transmitting and receiving. Hence, the core only handles one frame at a time
+ * for each phy, which means we need to tell upper layers to stop giving us new
+ * skbs while we are busy with the transmitted one. The queue must then be
+ * stopped before transmitting.
+ *
  * Drivers should use this function instead of netif_stop_queue.
  */
 void ieee802154_stop_queue(struct ieee802154_hw *hw);
-- 
2.27.0

