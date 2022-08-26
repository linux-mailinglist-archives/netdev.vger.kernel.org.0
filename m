Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8100A5A29B4
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344480AbiHZOlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344510AbiHZOlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:41:04 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7C2B2D85;
        Fri, 26 Aug 2022 07:41:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 98DF81BF208;
        Fri, 26 Aug 2022 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a9IYMuDIyxj+HLkgz7Y6Y6sR1gMiuEZfqG+jyTP97zw=;
        b=Y8WCw1KNvwhVvLgVRZjtpgUCVwfCwTMQkofzkAIgT2za+K0E5EirGA7Tuic/KShBF+V73j
        Q6+p60TdklKxuOmQm0ZMMHFpENsvOO44F+Bb3q1TOPvIn9AIFoQcU5aeUCE3+J5+N977EP
        leSB6NBoAE4ngs/ElCxvkPi8NuvkkoVUuvWOxqZgy6xYJ201hKk3Y1zP/IbRlk88QBqEo7
        RNbiAg20In7FJYqjdQhWwYRsxN56muz6LKU9kuabCVXFuwFOoJ3d1AkElLLBoPve6qSQI/
        JBoox4DZiJKtGiFs9SnderUA4B1+wcS4Wjy1ebKyEH6tk6VWaPWPKdV6HHzVvg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 03/11] net: mac802154: Allow the creation of coordinator interfaces
Date:   Fri, 26 Aug 2022 16:40:41 +0200
Message-Id: <20220826144049.256134-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826144049.256134-1-miquel.raynal@bootlin.com>
References: <20220826144049.256134-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a first strep in introducing proper PAN management and association,
we need to be able to create coordinator interfaces which might act as
coordinator or PAN coordinator.

Hence, let's add the minimum support to allow the creation of these
interfaces. This support will be improved later, in particular regarding
the filtering.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/iface.c | 14 ++++++++------
 net/mac802154/main.c  |  2 ++
 net/mac802154/rx.c    | 11 +++++++----
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 4bab2807acbe..8467a629e21f 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 		if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
 			int ret;
 
-			/* TODO currently we don't support multiple node types
-			 * we need to run skb_clone at rx path. Check if there
-			 * exist really an use case if we need to support
-			 * multiple node types at the same time.
+			/* TODO currently we don't support multiple node/coord
+			 * types we need to run skb_clone at rx path. Check if
+			 * there exist really an use case if we need to support
+			 * multiple node/coord types at the same time.
 			 */
-			if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
-			    nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
+			if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
+			    nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
 				return -EBUSY;
 
 			/* check all phy mac sublayer settings are the same.
@@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
 
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ieee802154_be64_to_le64(&wpan_dev->extended_addr,
 					sdata->dev->dev_addr);
@@ -638,6 +639,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	ieee802154_le64_to_be64(ndev->perm_addr,
 				&local->hw.phy->perm_extended_addr);
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ndev->type = ARPHRD_IEEE802154;
 		if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 40fab08df24b..d03ecb747afc 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
 
 	if (hw->flags & IEEE802154_HW_PROMISCUOUS)
 		local->phy->supported.iftypes |= BIT(NL802154_IFTYPE_MONITOR);
+	else
+		local->phy->supported.iftypes &= ~BIT(NL802154_IFTYPE_COORD);
 
 	rc = wpan_phy_register(local->phy);
 	if (rc < 0)
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 42ebbe45a4c5..ea5320411848 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -194,6 +194,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	int ret;
 	struct ieee802154_sub_if_data *sdata;
 	struct ieee802154_hdr hdr;
+	struct sk_buff *skb2;
 
 	ret = ieee802154_parse_frame_start(skb, &hdr);
 	if (ret) {
@@ -203,15 +204,17 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
+		if (sdata->wpan_dev.iftype == NL802154_IFTYPE_MONITOR)
 			continue;
 
 		if (!ieee802154_sdata_running(sdata))
 			continue;
 
-		ieee802154_subif_frame(sdata, skb, &hdr);
-		skb = NULL;
-		break;
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		if (skb2) {
+			skb2->dev = sdata->dev;
+			ieee802154_subif_frame(sdata, skb2, &hdr);
+		}
 	}
 
 	kfree_skb(skb);
-- 
2.34.1

