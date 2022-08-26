Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034955A29C2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344522AbiHZOlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344480AbiHZOlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:41:02 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED0ACC33F;
        Fri, 26 Aug 2022 07:40:59 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6B0261BF20D;
        Fri, 26 Aug 2022 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fY3AHa++QoYX1T0AIKr3WtVFrfOKMtJ/BSj+z0SXYXs=;
        b=Y1Pnxs8fvUcI7jFf4rLyWWsYZzDFcWmWoM5jEiHBqVq2TpYFfQyDrgvdfLyrWAfS5t/u9r
        yGRqJWBqvwp7lVEipSvvt3i42pPMCP9psTM9OTwp2bGTbra65Q/bjeDng7xBfkcPI8nra6
        LmZppEDxengmW1LBF51bsrPe+qZRdWlBR9MGc+oQi1CNnfQMt0trV7l/XyoLo5dksBl8rZ
        vvhlt4Z6QKwHNifMBH6jS8p4i+HmeKLZTyDZeFuTQ3/rTgRJYsd+AI+p8PEkOLYTbQzDD0
        TkgZxRIPB3Sqe2I7jqZp7pEK5BPplPR0mEZkokSqC9d++kowSxVlep819+Itkw==
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
Subject: [PATCH wpan-next v2 02/11] net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
Date:   Fri, 26 Aug 2022 16:40:40 +0200
Message-Id: <20220826144049.256134-3-miquel.raynal@bootlin.com>
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

This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
reflect the fact that it would not validate the checksum (FCS). In other
words, the filtering level of hwsim is always "NONE" while the core
expects it to be higher.

Now that we have access to real filtering levels, we can actually use
them and always enforce the "NONE" level in hwsim. Handling this case
correctly in the receive path permits to drop the above mentioned flag.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 10 +++++++++-
 include/net/mac802154.h                  |  4 ----
 net/mac802154/rx.c                       |  6 ++----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 38c217bd7c82..d7e4048e8743 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -148,6 +148,8 @@ static int hwsim_hw_start(struct ieee802154_hw *hw)
 	struct hwsim_phy *phy = hw->priv;
 
 	phy->suspended = false;
+	hw->phy->filtering = IEEE802154_FILTERING_NONE;
+
 	return 0;
 }
 
@@ -161,6 +163,9 @@ static void hwsim_hw_stop(struct ieee802154_hw *hw)
 static int
 hwsim_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
 {
+	/* hwsim does not filter anything, so enforce the NONE level */
+	hw->phy->filtering = IEEE802154_FILTERING_NONE;
+
 	return 0;
 }
 
@@ -791,7 +796,10 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
 
-	hw->flags = IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_RX_DROP_BAD_CKSUM;
+	/* This is a lie, hwsim does not even filter bad FCS, but we need to
+	 * advertize a PROMISCUOUS to be able to create COORD interfaces.
+	 */
+	hw->flags = IEEE802154_HW_PROMISCUOUS;
 	hw->parent = dev;
 
 	err = ieee802154_register_hw(hw);
diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 41c28118790c..a45ec09723f3 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -111,9 +111,6 @@ struct ieee802154_hw {
  *	promiscuous mode setting.
  *
  * @IEEE802154_HW_RX_OMIT_CKSUM: Indicates that receiver omits FCS.
- *
- * @IEEE802154_HW_RX_DROP_BAD_CKSUM: Indicates that receiver will not filter
- *	frames with bad checksum.
  */
 enum ieee802154_hw_flags {
 	IEEE802154_HW_TX_OMIT_CKSUM	= BIT(0),
@@ -123,7 +120,6 @@ enum ieee802154_hw_flags {
 	IEEE802154_HW_AFILT		= BIT(4),
 	IEEE802154_HW_PROMISCUOUS	= BIT(5),
 	IEEE802154_HW_RX_OMIT_CKSUM	= BIT(6),
-	IEEE802154_HW_RX_DROP_BAD_CKSUM	= BIT(7),
 };
 
 /* Indicates that receiver omits FCS and xmitter will add FCS on it's own. */
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c439125ef2b9..42ebbe45a4c5 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -268,10 +268,8 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	ieee802154_monitors_rx(local, skb);
 
-	/* Check if transceiver doesn't validate the checksum.
-	 * If not we validate the checksum here.
-	 */
-	if (local->hw.flags & IEEE802154_HW_RX_DROP_BAD_CKSUM) {
+	/* Level 1 filtering: Check the FCS by software when relevant */
+	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
 		if (crc) {
 			rcu_read_unlock();
-- 
2.34.1

