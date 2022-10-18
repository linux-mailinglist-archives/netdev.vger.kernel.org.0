Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DF3603290
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJRSc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJRScz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:32:55 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885C192F4D;
        Tue, 18 Oct 2022 11:32:53 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2CC1F20003;
        Tue, 18 Oct 2022 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666117970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fcNlh4YYDUmBXasaCeDeHRaIml7estVWt8prgBYpz1U=;
        b=Ub3RBnjTIhZr0Zz4XjuW8OHzU9qVLvT3ers+VuTa9uy2gXGFdKX7lR85r1EzxtsiToOcdx
        v6cuGICM+ork4sD4Fq9qUU2oxxbC8f+xKd67HvlCr/CYKGiN28ip2XvQ67tLQtXtReJ1Ib
        KFTl6LsNJqOm9mhmp4QN1lJ6gM5QOMQKenhS0ZE6uUUlqWAF7Fb+C4Xof0x/6HFHVT1zTT
        +WKlt4dZV6yEhD1Qk+MJUd0G862AVPBeB4ol6A9mNtzaBa7dnmoJNK3LTye9gd27Kbe0qH
        wjiN/nvSe5P2llG9JP+pClUtbr+6SCN/F7vfxuWp/+57uTcPEyntFSMiSvpb2A==
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
Subject: [PATCH wpan-next 1/2] ieee802154: hwsim: Introduce a helper to update all the PIB attributes
Date:   Tue, 18 Oct 2022 20:32:46 +0200
Message-Id: <20221018183247.806108-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

Perform the update of the PIB structure only in a single place. This way
we can have much simpler functions when updating the page, channel or
address filters. This helper will become even more useful when we will
update the ->set_promiscuous() callback to actually save the filtering
level in the PIB structure.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 66 +++++++++++++-----------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 1db7da3ccc1a..44dbd5f27dc5 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -90,46 +90,20 @@ static int hwsim_hw_ed(struct ieee802154_hw *hw, u8 *level)
 	return 0;
 }
 
-static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
+static int hwsim_update_pib(struct ieee802154_hw *hw, u8 page, u8 channel,
+			    struct ieee802154_hw_addr_filt *filt)
 {
 	struct hwsim_phy *phy = hw->priv;
 	struct hwsim_pib *pib, *pib_old;
 
-	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
+	pib = kzalloc(sizeof(*pib), GFP_ATOMIC);
 	if (!pib)
 		return -ENOMEM;
 
+	pib_old = rtnl_dereference(phy->pib);
+
 	pib->page = page;
 	pib->channel = channel;
-
-	pib_old = rtnl_dereference(phy->pib);
-
-	pib->filt.short_addr = pib_old->filt.short_addr;
-	pib->filt.pan_id = pib_old->filt.pan_id;
-	pib->filt.ieee_addr = pib_old->filt.ieee_addr;
-	pib->filt.pan_coord = pib_old->filt.pan_coord;
-
-	rcu_assign_pointer(phy->pib, pib);
-	kfree_rcu(pib_old, rcu);
-	return 0;
-}
-
-static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
-			      struct ieee802154_hw_addr_filt *filt,
-			      unsigned long changed)
-{
-	struct hwsim_phy *phy = hw->priv;
-	struct hwsim_pib *pib, *pib_old;
-
-	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
-	if (!pib)
-		return -ENOMEM;
-
-	pib_old = rtnl_dereference(phy->pib);
-
-	pib->page = pib_old->page;
-	pib->channel = pib_old->channel;
-
 	pib->filt.short_addr = filt->short_addr;
 	pib->filt.pan_id = filt->pan_id;
 	pib->filt.ieee_addr = filt->ieee_addr;
@@ -140,6 +114,36 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
 	return 0;
 }
 
+static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
+{
+	struct hwsim_phy *phy = hw->priv;
+	struct hwsim_pib *pib;
+	int ret;
+
+	rcu_read_lock();
+	pib = rcu_dereference(phy->pib);
+	ret = hwsim_update_pib(hw, page, channel, &pib->filt);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
+			      struct ieee802154_hw_addr_filt *filt,
+			      unsigned long changed)
+{
+	struct hwsim_phy *phy = hw->priv;
+	struct hwsim_pib *pib;
+	int ret;
+
+	rcu_read_lock();
+	pib = rcu_dereference(phy->pib);
+	ret = hwsim_update_pib(hw, pib->page, pib->channel, filt);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
 			     u8 lqi)
 {
-- 
2.34.1

