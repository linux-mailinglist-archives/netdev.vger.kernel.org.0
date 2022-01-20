Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056F349452D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357993AbiATAvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357995AbiATAvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:39 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C32CC061574;
        Wed, 19 Jan 2022 16:51:38 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E38FD100004;
        Thu, 20 Jan 2022 00:51:35 +0000 (UTC)
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
Subject: [wpan-next 08/14] net: mac802154: Rename the main tx_work struct
Date:   Thu, 20 Jan 2022 01:51:16 +0100
Message-Id: <20220120005122.309104-9-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This entry is dedicated to synchronous transmissions done by drivers
without async hook. Make this clearer that this is not a work that any
driver can use by at least prefixing it with "sync_". While at it, let's
enhance the comment explaining why we choose one or the other.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 +-
 net/mac802154/main.c         | 2 +-
 net/mac802154/tx.c           | 9 ++++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index b4882b2d7688..18d1f6804810 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -55,7 +55,7 @@ struct ieee802154_local {
 	struct sk_buff_head skb_queue;
 
 	struct sk_buff *tx_skb;
-	struct work_struct tx_work;
+	struct work_struct sync_tx_work;
 };
 
 enum {
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index bfd7c431cdea..0023c6e80725 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -95,7 +95,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	skb_queue_head_init(&local->skb_queue);
 
-	INIT_WORK(&local->tx_work, ieee802154_xmit_sync_worker);
+	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 97df5985b830..a01689ddd547 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -25,7 +25,7 @@
 void ieee802154_xmit_sync_worker(struct work_struct *work)
 {
 	struct ieee802154_local *local =
-		container_of(work, struct ieee802154_local, tx_work);
+		container_of(work, struct ieee802154_local, sync_tx_work);
 	struct sk_buff *skb = local->tx_skb;
 	struct net_device *dev = skb->dev;
 	int res;
@@ -76,7 +76,10 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	/* Stop the netif queue on each sub_if_data object. */
 	ieee802154_stop_queue(&local->hw);
 
-	/* async is priority, otherwise sync is fallback */
+	/* Drivers should preferably implement the async callback. In some rare
+	 * cases they only provide a sync callback which we will use as a
+	 * fallback.
+	 */
 	if (local->ops->xmit_async) {
 		unsigned int len = skb->len;
 
@@ -90,7 +93,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		dev->stats.tx_bytes += len;
 	} else {
 		local->tx_skb = skb;
-		queue_work(local->workqueue, &local->tx_work);
+		queue_work(local->workqueue, &local->sync_tx_work);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.27.0

