Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C16494531
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358025AbiATAvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:44 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:47315 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358005AbiATAvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:42 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 97275100005;
        Thu, 20 Jan 2022 00:51:40 +0000 (UTC)
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
Subject: [wpan-next 11/14] net: mac802154: Create a hot tx path
Date:   Thu, 20 Jan 2022 01:51:19 +0100
Message-Id: <20220120005122.309104-12-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120005122.309104-1-miquel.raynal@bootlin.com>
References: <20220120005122.309104-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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

