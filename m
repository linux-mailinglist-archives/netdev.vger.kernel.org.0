Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D474907A7
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiAQLzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239359AbiAQLzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:17 -0500
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B37C06173E;
        Mon, 17 Jan 2022 03:55:16 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id C0C91200008;
        Mon, 17 Jan 2022 11:55:13 +0000 (UTC)
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
Subject: [PATCH v3 16/41] net: mac802154: Explain the use of ieee802154_wake/stop_queue()
Date:   Mon, 17 Jan 2022 12:54:15 +0100
Message-Id: <20220117115440.60296-17-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
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

