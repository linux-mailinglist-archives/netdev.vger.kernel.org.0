Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE611511DC8
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiD0Qu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243456AbiD0QuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:23 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE7F3681D5;
        Wed, 27 Apr 2022 09:47:11 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 12F4310000E;
        Wed, 27 Apr 2022 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lcIaN5D9rzzs6ODl/fOVj+Kiy8zn//WpgkmzEbJrQLM=;
        b=gJzdMXBPYFKVnZb9nUp+5uS0WzhUJj/apePAZW5vuZfUnB/ibIFv5SBQLO3JwhYgvfmQ+r
        e6rZafIVrWJzg0RmrPQ8VwRHdqarazJdVc4N0UtzC20rhr9z53z8FxU9lhSrYFiD9+uFFs
        AwtBsfS+FZ7zSX5fPwwy7r1DQgY1cylDsFX2K5hQl1KcofR1eJJ1xkA8H9M6l1nPvQ3Udk
        OH/B9udP8VJMQmZBlU1Yk+RpjFjHJv7Q0Ln/uAa1ZYMBoWqwQP69iWfKmETa3/zFj9t3e1
        I5oYvrnlC98FZJxCCJIB/X0mShXwj5mZe4U6piDnQd/ocvYZQi9QH2FiURrOVA==
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
Subject: [PATCH wpan-next 05/11] net: mac802154: Follow the count of ongoing transmissions
Date:   Wed, 27 Apr 2022 18:46:53 +0200
Message-Id: <20220427164659.106447-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220427164659.106447-1-miquel.raynal@bootlin.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to create a synchronous API for MLME command purposes, we need
to be able to track the end of the ongoing transmissions. Let's
introduce an atomic variable which is incremented when a transmission
starts and decremented when relevant so that we know at any moment
whether there is an ongoing transmission.

The counter gets decremented in the following situations:
- The operation is asynchronous and there was a failure during the
  offloading process.
- The operation is synchronous and the synchronous operation failed.
- The operation finished, either successfully or not.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h | 3 +++
 net/mac802154/tx.c      | 3 +++
 net/mac802154/util.c    | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 85f9e8417688..473ebcb9b155 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -214,6 +214,9 @@ struct wpan_phy {
 	/* the network namespace this phy lives in currently */
 	possible_net_t _net;
 
+	/* Transmission monitoring */
+	atomic_t ongoing_txs;
+
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 6d559f96664d..8c0bad7796ba 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -45,6 +45,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_wake_queue(local);
 	kfree_skb(skb);
+	atomic_dec(&local->phy->ongoing_txs);
 	netdev_dbg(dev, "transmission failed\n");
 }
 
@@ -75,6 +76,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	/* Stop the netif queue on each sub_if_data object. */
 	ieee802154_stop_queue(local);
+	atomic_inc(&local->phy->ongoing_txs);
 
 	/* Drivers should preferably implement the async callback. In some rare
 	 * cases they only provide a sync callback which we will use as a
@@ -99,6 +101,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 
 err_tx:
+	atomic_dec(&local->phy->ongoing_txs);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 6ded390f0132..4bcc9cd2eb9d 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -84,6 +84,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
@@ -95,6 +96,7 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	local->tx_result = reason;
 	ieee802154_wake_queue(local);
 	dev_kfree_skb_any(skb);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
-- 
2.27.0

