Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04254907B4
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiAQLzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:47 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39685 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbiAQLzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:25 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A8A5B20000F;
        Mon, 17 Jan 2022 11:55:22 +0000 (UTC)
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
Subject: [PATCH v3 21/41] net: mac802154: Rename the synchronous xmit worker
Date:   Mon, 17 Jan 2022 12:54:20 +0100
Message-Id: <20220117115440.60296-22-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two driver hooks: one is synchronous, the other is
not. We cannot rely on driver implementations to provide a synchronous
API (which is related to the bus medium more than a wish to have a
synchronized implementation) so we are going to introduce a sync API
above any kind of driver transmit function. In order to clarify what
this worker is for (synchronous driver implementation), let's rename it
so that people don't get bothered by the fact that their driver does not
make use of the "xmit worker" which is a too generic name.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 +-
 net/mac802154/main.c         | 4 +++-
 net/mac802154/tx.c           | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 97b66088532b..b4882b2d7688 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -121,7 +121,7 @@ ieee802154_sdata_running(struct ieee802154_sub_if_data *sdata)
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
-void ieee802154_xmit_worker(struct work_struct *work);
+void ieee802154_xmit_sync_worker(struct work_struct *work);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index f08c34c27ea9..a938e49bf5dc 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -95,7 +95,9 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	skb_queue_head_init(&local->skb_queue);
 
-	INIT_WORK(&local->tx_work, ieee802154_xmit_worker);
+	INIT_WORK(&local->tx_work, ieee802154_xmit_sync_worker);
+	INIT_DELAYED_WORK(&local->scan_work, mac802154_scan_work);
+	INIT_DELAYED_WORK(&local->beacons_work, mac802154_beacons_work);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index c829e4a75325..97df5985b830 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -22,7 +22,7 @@
 #include "ieee802154_i.h"
 #include "driver-ops.h"
 
-void ieee802154_xmit_worker(struct work_struct *work)
+void ieee802154_xmit_sync_worker(struct work_struct *work)
 {
 	struct ieee802154_local *local =
 		container_of(work, struct ieee802154_local, tx_work);
-- 
2.27.0

