Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE4B4907BA
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiAQLzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:55:53 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:36145 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbiAQLz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:28 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 452C0200009;
        Mon, 17 Jan 2022 11:55:26 +0000 (UTC)
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
Subject: [PATCH v3 23/41] net: mac802154: Follow the count of ongoing transmissions
Date:   Mon, 17 Jan 2022 12:54:22 +0100
Message-Id: <20220117115440.60296-24-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to create a synchronous API for MLME command purposes, we need
to be able to track the end of the ongoing transmissions. Let's
introduce an atomic variable which is incremented and decremented when
relevant and now at any moment if a there is an ongoing transmission.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h | 3 +++
 net/mac802154/tx.c      | 3 +++
 net/mac802154/util.c    | 1 +
 3 files changed, 7 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 0b8b1812cea1..969cae56b000 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -283,6 +283,9 @@ struct wpan_phy {
 	/* the network namespace this phy lives in currently */
 	possible_net_t _net;
 
+	/* Transmission monitoring */
+	atomic_t ongoing_txs;
+
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a01689ddd547..731e86bfe73f 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -45,6 +45,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_wake_queue(&local->hw);
 	kfree_skb(skb);
+	atomic_dec(&local->phy->ongoing_txs);
 	netdev_dbg(dev, "transmission failed\n");
 }
 
@@ -80,6 +81,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	 * cases they only provide a sync callback which we will use as a
 	 * fallback.
 	 */
+	atomic_inc(&local->phy->ongoing_txs);
 	if (local->ops->xmit_async) {
 		unsigned int len = skb->len;
 
@@ -99,6 +101,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 
 err_tx:
+	atomic_dec(&local->phy->ongoing_txs);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index e093ccaebd76..0fa538b0debc 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -83,6 +83,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
-- 
2.27.0

