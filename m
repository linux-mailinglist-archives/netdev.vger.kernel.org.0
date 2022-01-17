Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8900F4907B6
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiAQLzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:52 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38101 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbiAQLz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:27 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 6C7B7200017;
        Mon, 17 Jan 2022 11:55:24 +0000 (UTC)
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
Subject: [PATCH v3 22/41] net: mac802154: Rename the main tx_work struct
Date:   Mon, 17 Jan 2022 12:54:21 +0100
Message-Id: <20220117115440.60296-23-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
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
index a938e49bf5dc..43fd4cc13b66 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -95,7 +95,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	skb_queue_head_init(&local->skb_queue);
 
-	INIT_WORK(&local->tx_work, ieee802154_xmit_sync_worker);
+	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_work);
 	INIT_DELAYED_WORK(&local->beacons_work, mac802154_beacons_work);
 
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

