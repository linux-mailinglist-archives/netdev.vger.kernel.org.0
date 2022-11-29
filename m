Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226B863C491
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiK2QDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiK2QCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:30 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEDD6A761;
        Tue, 29 Nov 2022 08:01:04 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DEF6A1C0012;
        Tue, 29 Nov 2022 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ocsrVWDse05TiOwgeTNazLf/2kUkHgtJk9TtjrMWVk=;
        b=DOcy8BJpb9CO0bTXkMyViBykgCnstedkMVQ3zyEDm7B0zuXaQoFpeU63xpGZvcYscTnCxq
        f+ccXcy2OfdoAALRmH/YOyCaNrIq5JPIc4e2VoGFYo0+PwkqB1ZClp4HpQZ7bq2vftzS8J
        2nLVHW/CBo8HYzdexQ3EQUNemPkKBWcsXg4q+Cky7+HZTVYdBBrNldLEtTTRedK+v4E0Av
        agjoETy4asWdNntL3B2jGqV/Z73cvBx/qAmuiqkZgAx5C8bz86uWgLeVcbuRZ1EpjELPpH
        Nvouz5K8R3aWyStsJgaQvd5xVefw4c/A26VpdpNnZKy+xgeIsRYtCNAHnr3kqg==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 5/6] mac802154: Add MLME Tx locked helpers
Date:   Tue, 29 Nov 2022 17:00:45 +0100
Message-Id: <20221129160046.538864-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129160046.538864-1-miquel.raynal@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These have the exact same behavior as before, except they expect the
rtnl to be already taken (and will complain otherwise). This allows
performing MLME transmissions from different contexts.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  6 ++++++
 net/mac802154/tx.c           | 42 +++++++++++++++++++++++++-----------
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 509e0172fe82..aeadee543a9c 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -141,10 +141,16 @@ int ieee802154_mlme_op_pre(struct ieee802154_local *local);
 int ieee802154_mlme_tx(struct ieee802154_local *local,
 		       struct ieee802154_sub_if_data *sdata,
 		       struct sk_buff *skb);
+int ieee802154_mlme_tx_locked(struct ieee802154_local *local,
+			      struct ieee802154_sub_if_data *sdata,
+			      struct sk_buff *skb);
 void ieee802154_mlme_op_post(struct ieee802154_local *local);
 int ieee802154_mlme_tx_one(struct ieee802154_local *local,
 			   struct ieee802154_sub_if_data *sdata,
 			   struct sk_buff *skb);
+int ieee802154_mlme_tx_one_locked(struct ieee802154_local *local,
+				  struct ieee802154_sub_if_data *sdata,
+				  struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 9d8d43cf1e64..2a6f1ed763c9 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -137,34 +137,37 @@ int ieee802154_mlme_op_pre(struct ieee802154_local *local)
 	return ieee802154_sync_and_hold_queue(local);
 }
 
-int ieee802154_mlme_tx(struct ieee802154_local *local,
-		       struct ieee802154_sub_if_data *sdata,
-		       struct sk_buff *skb)
+int ieee802154_mlme_tx_locked(struct ieee802154_local *local,
+			      struct ieee802154_sub_if_data *sdata,
+			      struct sk_buff *skb)
 {
-	int ret;
-
 	/* Avoid possible calls to ->ndo_stop() when we asynchronously perform
 	 * MLME transmissions.
 	 */
-	rtnl_lock();
+	ASSERT_RTNL();
 
 	/* Ensure the device was not stopped, otherwise error out */
-	if (!local->open_count) {
-		rtnl_unlock();
+	if (!local->open_count)
 		return -ENETDOWN;
-	}
 
 	/* Warn if the ieee802154 core thinks MLME frames can be sent while the
 	 * net interface expects this cannot happen.
 	 */
-	if (WARN_ON_ONCE(!netif_running(sdata->dev))) {
-		rtnl_unlock();
+	if (WARN_ON_ONCE(!netif_running(sdata->dev)))
 		return -ENETDOWN;
-	}
 
 	ieee802154_tx(local, skb);
-	ret = ieee802154_sync_queue(local);
+	return ieee802154_sync_queue(local);
+}
 
+int ieee802154_mlme_tx(struct ieee802154_local *local,
+		       struct ieee802154_sub_if_data *sdata,
+		       struct sk_buff *skb)
+{
+	int ret;
+
+	rtnl_lock();
+	ret = ieee802154_mlme_tx_locked(local, sdata, skb);
 	rtnl_unlock();
 
 	return ret;
@@ -188,6 +191,19 @@ int ieee802154_mlme_tx_one(struct ieee802154_local *local,
 	return ret;
 }
 
+int ieee802154_mlme_tx_one_locked(struct ieee802154_local *local,
+				  struct ieee802154_sub_if_data *sdata,
+				  struct sk_buff *skb)
+{
+	int ret;
+
+	ieee802154_mlme_op_pre(local);
+	ret = ieee802154_mlme_tx_locked(local, sdata, skb);
+	ieee802154_mlme_op_post(local);
+
+	return ret;
+}
+
 static bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
 {
 	return test_bit(WPAN_PHY_FLAG_STATE_QUEUE_STOPPED, &local->phy->flags);
-- 
2.34.1

