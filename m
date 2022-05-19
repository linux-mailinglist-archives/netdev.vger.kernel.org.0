Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6925552D6E1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240228AbiESPGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240445AbiESPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:30 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735953151E;
        Thu, 19 May 2022 08:05:28 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 45F991BF232;
        Thu, 19 May 2022 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77KsFKV4vH+h+zDyIoYLQKp50NrKJvbXOrVs9D5HCiM=;
        b=CFtTuGceNymm5DUbxyR6h9YIIJvEbN8tDr5uMIyAsg+wOJ7Z3VKjPFW+dRgmAwLJ7/BFqG
        RiiIzuNL4uunKjFm8Cq1rkcz8uNQRFqQz5ZL4bWzbxAHcRuvDlKrF03lPhtVlkN53Nb/L5
        nrOTnJHI09/FYtTT0fPahwUugBo27nlnuV5TtFW//Hr9qkviSQQvPuPf9CB71ryTReRN6B
        1ksgasKyBkO6FUDU90HjjPzIbgiRyAx3R5taYd7ttLvr4SnaCMDbD5x5EyrD3WPnqe/P3g
        f4aPbsg650maL0coR6nIOoVnZCH91/jD7NCzFNOlqazZruMpsrLLJBEv+vmsBg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v4 04/11] net: mac802154: Follow the count of ongoing transmissions
Date:   Thu, 19 May 2022 17:05:09 +0200
Message-Id: <20220519150516.443078-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 4a46ce8d2ac8..33f64ecd96c7 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -44,6 +44,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 err_tx:
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_wake_queue(&local->hw);
+	atomic_dec(&local->phy->ongoing_txs);
 	kfree_skb(skb);
 	netdev_dbg(dev, "transmission failed\n");
 }
@@ -75,6 +76,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	/* Stop the netif queue on each sub_if_data object. */
 	ieee802154_stop_queue(&local->hw);
+	atomic_inc(&local->phy->ongoing_txs);
 
 	/* Drivers should preferably implement the async callback. In some rare
 	 * cases they only provide a sync callback which we will use as a
@@ -98,6 +100,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 err_wake_netif_queue:
 	ieee802154_wake_queue(&local->hw);
+	atomic_dec(&local->phy->ongoing_txs);
 err_free_skb:
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 9f024d85563b..76dc663e2af4 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -88,6 +88,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
 
@@ -99,6 +100,7 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	local->tx_result = reason;
 	ieee802154_wake_queue(hw);
 	dev_kfree_skb_any(skb);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
-- 
2.34.1

