Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EFB603292
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJRSc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJRSc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:32:57 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E3690817;
        Tue, 18 Oct 2022 11:32:55 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E1D2720005;
        Tue, 18 Oct 2022 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666117972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFEjhfGI7zVY3yb93JDUDXRMNuuwpASEFUI1ft70yyk=;
        b=e3D4tyZ5oPxJyn/hsYFh16QZNgUP/TgQUK9CTVcFF6ryPES2DdCTMDwnzJcZw4GXQWu6pb
        RiCDqjIx+6IDahHnwmsf8FXOsiNVpH56uGJvE4J4GVPF2JBMx/MZoZsS/qaAsTfLLGy2uj
        hFTY8ZWlt/iMybRAm2a2GkGV+G6I1FL64SHTfODjbi2lGkUeRBBvwqbF0wEMa4pwvYldsR
        fuTmCZZIaYKXAvUi8PkSRwFwonHEuUdb5MoBRN871LPkBJApJ/uWdORE/XjlXyVys4mN7v
        rliYTDkLkDs8v8eDXAyOVQPQ8CoB5HdT3LYblBS+Tl1DG1P4Sa3xCiJWCUUeyw==
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
Subject: [PATCH wpan-next 2/2] ieee802154: hwsim: Save the current filtering level and use it
Date:   Tue, 18 Oct 2022 20:32:47 +0200
Message-Id: <20221018183247.806108-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018183247.806108-1-miquel.raynal@bootlin.com>
References: <20221018183247.806108-1-miquel.raynal@bootlin.com>
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

Save the requested filtering level in the ->set_promiscuous()
helper. The logic is: either we want to enable promiscuous mode and we
want to disable filters entirely, or we want to use the highest
filtering level by default. This is of course an assumption that only
works today, but if in the future intermediate levels (such as scan
filtering level) are implemented in the core, this logic will need to be
updated. This would imply replacing ->set_promiscuous() by something
more fine grained anyway, so we are probably safe with this assumption.

Once saved in the PIB structure, we can use this value instead of trying
to access the PHY structure to know what hardware filtering level has
been advertised.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 28 +++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 44dbd5f27dc5..9034706d4a53 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -49,6 +49,7 @@ struct hwsim_pib {
 	u8 page;
 	u8 channel;
 	struct ieee802154_hw_addr_filt filt;
+	enum ieee802154_filtering_level filt_level;
 
 	struct rcu_head rcu;
 };
@@ -91,7 +92,8 @@ static int hwsim_hw_ed(struct ieee802154_hw *hw, u8 *level)
 }
 
 static int hwsim_update_pib(struct ieee802154_hw *hw, u8 page, u8 channel,
-			    struct ieee802154_hw_addr_filt *filt)
+			    struct ieee802154_hw_addr_filt *filt,
+			    enum ieee802154_filtering_level filt_level)
 {
 	struct hwsim_phy *phy = hw->priv;
 	struct hwsim_pib *pib, *pib_old;
@@ -108,6 +110,7 @@ static int hwsim_update_pib(struct ieee802154_hw *hw, u8 page, u8 channel,
 	pib->filt.pan_id = filt->pan_id;
 	pib->filt.ieee_addr = filt->ieee_addr;
 	pib->filt.pan_coord = filt->pan_coord;
+	pib->filt_level = filt_level;
 
 	rcu_assign_pointer(phy->pib, pib);
 	kfree_rcu(pib_old, rcu);
@@ -122,7 +125,7 @@ static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 
 	rcu_read_lock();
 	pib = rcu_dereference(phy->pib);
-	ret = hwsim_update_pib(hw, page, channel, &pib->filt);
+	ret = hwsim_update_pib(hw, page, channel, &pib->filt, pib->filt_level);
 	rcu_read_unlock();
 
 	return ret;
@@ -138,7 +141,7 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
 
 	rcu_read_lock();
 	pib = rcu_dereference(phy->pib);
-	ret = hwsim_update_pib(hw, pib->page, pib->channel, filt);
+	ret = hwsim_update_pib(hw, pib->page, pib->channel, filt, pib->filt_level);
 	rcu_read_unlock();
 
 	return ret;
@@ -162,7 +165,7 @@ static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
 	memcpy(&hdr, skb->data, 3);
 
 	/* Level 4 filtering: Frame fields validity */
-	if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {
+	if (pib->filt_level == IEEE802154_FILTERING_4_FRAME_FIELDS) {
 		/* a) Drop reserved frame types */
 		switch (mac_cb(skb)->type) {
 		case IEEE802154_FC_TYPE_BEACON:
@@ -305,7 +308,22 @@ static void hwsim_hw_stop(struct ieee802154_hw *hw)
 static int
 hwsim_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
 {
-	return 0;
+	enum ieee802154_filtering_level filt_level;
+	struct hwsim_phy *phy = hw->priv;
+	struct hwsim_pib *pib;
+	int ret;
+
+	if (on)
+		filt_level = IEEE802154_FILTERING_NONE;
+	else
+		filt_level = IEEE802154_FILTERING_4_FRAME_FIELDS;
+
+	rcu_read_lock();
+	pib = rcu_dereference(phy->pib);
+	ret = hwsim_update_pib(hw, pib->page, pib->channel, &pib->filt, filt_level);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static const struct ieee802154_ops hwsim_ops = {
-- 
2.34.1

