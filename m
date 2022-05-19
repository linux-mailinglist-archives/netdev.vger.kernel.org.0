Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D298052D6F5
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbiESPG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiESPFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:42 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017963DDEF;
        Thu, 19 May 2022 08:05:38 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 545D11BF20C;
        Thu, 19 May 2022 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rz4pN+v//GRbkoIs5vxd8IEp/m7blHAPfWinvOQCaqc=;
        b=eQvnDZ/gnMHDjyfNwn0pmCP65Xv0DcFcatwMT/9eZ34T3iJBWRs0WgO6xECXGQRatcJnXi
        tHkhYrl0d1X2nkt47LkQ22+QecGQcphFjT2aYNYINqjCfyxT4gBpwBayxAh7mAh2ctWU72
        z+vqchegI9KD081ltjLt8s2oqLnk8e6pQ96RXQ/72NWAXDVbPGYEfyDzJ2y3HmbOPHIIhe
        jQ/OY4jU2EVnJ6apDhVZhinS7cCLJi/jAcG5+2B+4D7+sANW47J8m7BMAdIQ/C3fYci91b
        rrB9m5YW6NBwh8plfp7e4MwV4lG3BFS+6rhDN9V7xYBgF58EYrpk2Hpohn+F+g==
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
Subject: [PATCH wpan-next v4 10/11] net: mac802154: Add a warning in the hot path
Date:   Thu, 19 May 2022 17:05:15 +0200
Message-Id: <20220519150516.443078-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
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

We should never start a transmission after the queue has been stopped.

But because it might work we don't kill the function here but rather
warn loudly the user that something is wrong.

Set a flag when the queue should remain stopped. Reset this flag when
the queue actually gets restarded. Just check this value to know if a
transmission is legitimate, warn if it is not.

Turn the flags variable into an unsigned long to allow the use of atomic
helpers on it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  5 ++++-
 net/mac802154/tx.c      | 16 +++++++++++++++-
 net/mac802154/util.c    |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 8881b6126b58..04b996895fc1 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -166,11 +166,14 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, const struct wpan_phy_cca *b)
  *	level setting.
  * @WPAN_PHY_FLAG_CCA_MODE: Indicates that transceiver will support cca mode
  *	setting.
+ * @WPAN_PHY_FLAG_STATE_QUEUE_STOPPED: Indicates that the transmit queue was
+ *	temporarily stopped.
  */
 enum wpan_phy_flags {
 	WPAN_PHY_FLAG_TXPOWER		= BIT(1),
 	WPAN_PHY_FLAG_CCA_ED_LEVEL	= BIT(2),
 	WPAN_PHY_FLAG_CCA_MODE		= BIT(3),
+	WPAN_PHY_FLAG_STATE_QUEUE_STOPPED = BIT(4),
 };
 
 struct wpan_phy {
@@ -182,7 +185,7 @@ struct wpan_phy {
 	 */
 	const void *privid;
 
-	u32 flags;
+	unsigned long flags;
 
 	/*
 	 * This is a PIB according to 802.15.4-2011.
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 4827391600f6..6188f42276e7 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -123,9 +123,13 @@ static int ieee802154_sync_queue(struct ieee802154_local *local)
 
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 {
+	int ret;
+
 	ieee802154_hold_queue(local);
+	ret = ieee802154_sync_queue(local);
+	set_bit(WPAN_PHY_FLAG_STATE_QUEUE_STOPPED, &local->phy->flags);
 
-	return ieee802154_sync_queue(local);
+	return ret;
 }
 
 int ieee802154_mlme_op_pre(struct ieee802154_local *local)
@@ -172,9 +176,19 @@ int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb)
 	return ret;
 }
 
+static bool ieee802154_queue_is_stopped(struct ieee802154_local *local)
+{
+	return test_bit(WPAN_PHY_FLAG_STATE_QUEUE_STOPPED, &local->phy->flags);
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
+	/* Warn if the net interface tries to transmit frames while the
+	 * ieee802154 core assumes the queue is stopped.
+	 */
+	WARN_ON_ONCE(ieee802154_queue_is_stopped(local));
+
 	return ieee802154_tx(local, skb);
 }
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 5e1fcc7b0123..60eb7bd3bfc1 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -29,6 +29,7 @@ static void ieee802154_wake_queue(struct ieee802154_hw *hw)
 	struct ieee802154_sub_if_data *sdata;
 
 	rcu_read_lock();
+	clear_bit(WPAN_PHY_FLAG_STATE_QUEUE_STOPPED, &local->phy->flags);
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!sdata->dev)
 			continue;
-- 
2.34.1

