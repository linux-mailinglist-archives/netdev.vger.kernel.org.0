Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894ED4AC27A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390100AbiBGPFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442275AbiBGOsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:23 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA1C0401C4;
        Mon,  7 Feb 2022 06:48:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4731E20007;
        Mon,  7 Feb 2022 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyHk/vNJ9CLohzVqAxk1jcnh+0stYdDhYZYyTaaCNF4=;
        b=RWUmC4Zi/QqCApH9+cYCdmRsWIhAkEVoLworouNwMn5zcz7GIOnFhmlQPhVnAdbY88atPA
        BLwWz78NsFuUVTrgfZg7n7OT/U5IYGsPmyUHjRWy3FyW1+tFVCSMbWsAdCElQFMZv+fwGp
        3hzAQuoIf6TpoOpqcm8LXocEcBXcz4XQxWLz7yFH6NXsmewTLNZZc1ztujWBVOrXjlFs8n
        1cfntZT8z+4VwEEDLyNnxfZ529qBDtCtbqgGjF7t7Uci4qlNf7+mgDii5oBkC0r3F7vD+N
        ObcFiHykYhOiS2GEupefPkOzE1agqYUAJD3t5x0WOnEp3xSEz7WCIF2YnBigHQ==
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
Subject: [PATCH wpan-next v2 09/14] net: mac802154: Follow the count of ongoing transmissions
Date:   Mon,  7 Feb 2022 15:47:59 +0100
Message-Id: <20220207144804.708118-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220207144804.708118-1-miquel.raynal@bootlin.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
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
introduce an atomic variable which is incremented and decremented when
relevant and now at any moment if a there is an ongoing transmission.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h | 3 +++
 net/mac802154/tx.c      | 3 +++
 net/mac802154/util.c    | 1 +
 3 files changed, 7 insertions(+)

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
index 6c56884ed508..a72d202c212b 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -88,6 +88,7 @@ static void ieee802154_xmit_end(struct ieee802154_hw *hw, bool ifs_handling,
 				unsigned int skb_len)
 {
 	ieee802154_wakeup_after_xmit_done(hw, ifs_handling, skb_len);
+	atomic_dec(&hw->phy->ongoing_txs);
 }
 
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
-- 
2.27.0

