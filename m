Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F50554FD89
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 21:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiFQT3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 15:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiFQT3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 15:29:20 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D445454030;
        Fri, 17 Jun 2022 12:29:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6E1B9E000A;
        Fri, 17 Jun 2022 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655494157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HLZNoK3s6nGQbPR4WYJoo22e0BgrLaurywMR0f3XiRU=;
        b=RFBKLTkSkRbxUcE00q4igckhaY+ioKOl0NBKqvVmMjWN44rkgSxUQBJBNq3CSOiU13dcxl
        F5qgN4A5q+e2f7xbzNga48dJi59vlDbAvphQS6Y3JrQbcinWI5PlALlN4jSHyRqKG1GHys
        C4taqRpyaDyWxJRqAwpkoB3oO3GAQDV9QtKGghhW/bJQiZnA5XHi0ytfNOaB0csOQaDlEs
        w+kh4KQqclj24B4nwZyeDdteCBaoMM4bwnrzOyGCghHRXPmHi8uvDvg+vHP1CHIcbE36YJ
        2H5OFarmOPfV55AruGDEtTAONQ8Y3A0DKlJvAaZxS94I/pmNszpIvx8Db6mA6g==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH] net: mac802154: Fix a Tx warning check
Date:   Fri, 17 Jun 2022 21:29:14 +0200
Message-Id: <20220617192914.1275611-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of the netif_is_down() helper was to ensure that the network
interface used was still up when performing the transmission. What it
actually did was to check if _all_ interfaces were up. This was not
noticed at that time because I did not use interfaces at all before
discussing with Alexander Aring about how to handle coordinators
properly.

Drop the helper and call netif_running() on the right sub interface
object directly.

Fixes: 4f790184139b ("net: mac802154: Add a warning in the slow path")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  8 ++++++--
 net/mac802154/tx.c           | 31 ++++++++-----------------------
 2 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 8a4816ae71e7..010365a6364e 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -126,9 +126,13 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
 int ieee802154_mlme_op_pre(struct ieee802154_local *local);
-int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
+int ieee802154_mlme_tx(struct ieee802154_local *local,
+		       struct ieee802154_sub_if_data *sdata,
+		       struct sk_buff *skb);
 void ieee802154_mlme_op_post(struct ieee802154_local *local);
-int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
+int ieee802154_mlme_tx_one(struct ieee802154_local *local,
+			   struct ieee802154_sub_if_data *sdata,
+			   struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 8ddcd2e841ca..9d8d43cf1e64 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -132,31 +132,14 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ret;
 }
 
-static bool ieee802154_netif_is_down(struct ieee802154_local *local)
-{
-	struct ieee802154_sub_if_data *sdata;
-	bool is_down = true;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!sdata->dev)
-			continue;
-
-		is_down = !netif_running(sdata->dev);
-		if (is_down)
-			break;
-	}
-	rcu_read_unlock();
-
-	return is_down;
-}
-
 int ieee802154_mlme_op_pre(struct ieee802154_local *local)
 {
 	return ieee802154_sync_and_hold_queue(local);
 }
 
-int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
+int ieee802154_mlme_tx(struct ieee802154_local *local,
+		       struct ieee802154_sub_if_data *sdata,
+		       struct sk_buff *skb)
 {
 	int ret;
 
@@ -174,7 +157,7 @@ int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	/* Warn if the ieee802154 core thinks MLME frames can be sent while the
 	 * net interface expects this cannot happen.
 	 */
-	if (WARN_ON_ONCE(ieee802154_netif_is_down(local))) {
+	if (WARN_ON_ONCE(!netif_running(sdata->dev))) {
 		rtnl_unlock();
 		return -ENETDOWN;
 	}
@@ -192,12 +175,14 @@ void ieee802154_mlme_op_post(struct ieee802154_local *local)
 	ieee802154_release_queue(local);
 }
 
-int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb)
+int ieee802154_mlme_tx_one(struct ieee802154_local *local,
+			   struct ieee802154_sub_if_data *sdata,
+			   struct sk_buff *skb)
 {
 	int ret;
 
 	ieee802154_mlme_op_pre(local);
-	ret = ieee802154_mlme_tx(local, skb);
+	ret = ieee802154_mlme_tx(local, sdata, skb);
 	ieee802154_mlme_op_post(local);
 
 	return ret;
-- 
2.34.1

