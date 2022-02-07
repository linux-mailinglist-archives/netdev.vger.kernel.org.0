Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F614AC27E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392340AbiBGPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442276AbiBGOsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:25 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312A2C0401C1;
        Mon,  7 Feb 2022 06:48:25 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2B55A2000F;
        Mon,  7 Feb 2022 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RRFlGdFNmyNFT9F3Xojprp77fOiGY+D8ajPBSP50h8=;
        b=LHwCJJtHuaQaq8rytkfEpPqd4FIfxIlnr9avVXv4FRZrFP9x5Ea0eGbY8EE3b/ZT/wXT//
        2bW4aVhyET86w3npG/eyLdyL/khrf4rQSoBGDfzqmb3uYrHbgvJBMn90uuN/RK47uD3nU4
        l+W0rC0pz+b2wE7jbzmRuFpHoaItjZKfC43WTlsJgRuk/z3RGuMUKe4pca3tdAgdZr9Gki
        4ZcUHXmkzbaZY5V6pjrT+7gHeDnassAUMRJKS0YeXub/v+2tMrhNUUgzJ1tzBBXDMYiU4L
        f58dT1N2bDzfBJsI1Y9lC68ncIE9sbXNA9GsoXNuHpXINbES54UUhdfHg0RaSQ==
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
Subject: [PATCH wpan-next v2 11/14] net: mac802154: Create a hot tx path
Date:   Mon,  7 Feb 2022 15:48:01 +0100
Message-Id: <20220207144804.708118-12-miquel.raynal@bootlin.com>
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

Let's rename the current tx path to show that this is the "hot" path. We
will soon introduce a slower path for MLME commands.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a8d4d5e175b6..18ee6fcfcd7f 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -109,6 +109,12 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t
+ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	return ieee802154_tx(local, skb);
+}
+
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -116,7 +122,7 @@ ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb->skb_iif = dev->ifindex;
 
-	return ieee802154_tx(sdata->local, skb);
+	return ieee802154_hot_tx(sdata->local, skb);
 }
 
 netdev_tx_t
@@ -138,5 +144,5 @@ ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb->skb_iif = dev->ifindex;
 
-	return ieee802154_tx(sdata->local, skb);
+	return ieee802154_hot_tx(sdata->local, skb);
 }
-- 
2.27.0

