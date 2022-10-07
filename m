Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C9C5F759A
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJGIxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJGIx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:28 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6778615A10;
        Fri,  7 Oct 2022 01:53:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9836C1BF207;
        Fri,  7 Oct 2022 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DF6PKvDaSz3K2zSJGl6IY5GBOmmyj4SPFWUBU2dG1L0=;
        b=Sq/HasdhTTBrYomTUkZiHMXNkWKCGBqRrSLdtwCxx2tSR8wH8yrR++H0/FLL0fXAVF4vKR
        huInyIjtBaFeCgtiJrPj2tAhZU0FKd5ERaS6Kfg62YUlMA5oKE1NUTRJBh92BvGBMmO7vx
        d/o80WQs/Z3t25/tvoMqE4fnq0uWVjW89xKOxEdoDLPDpVrNBo+LJnOlOfPBrBRX0k0f3t
        TgqpRUCs34/8bjt1QztaZv5/YtG2Z9/F4ZQuX1nMlZthqnBgy9i5G4OP2ZMUJfu2DQQQ37
        H7qqmKLzTwUtIlEgSUfO1uiZWL7y6gVMJGwPHtcTutmghmcwAn75iDmD1nLqcg==
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
Subject: [PATCH wpan/next v4 4/8] ieee802154: hwsim: Record the address filter values
Date:   Fri,  7 Oct 2022 10:53:06 +0200
Message-Id: <20221007085310.503366-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221007085310.503366-1-miquel.raynal@bootlin.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
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

As a first step, introduce a basic implementation for the
->set_hw_addr_filt() hook. In a second step, the values recorded here
will be used to perform proper filtering during reception.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 38c217bd7c82..458be66b5195 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -47,6 +47,7 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
 struct hwsim_pib {
 	u8 page;
 	u8 channel;
+	struct ieee802154_hw_addr_filt filt;
 
 	struct rcu_head rcu;
 };
@@ -101,6 +102,38 @@ static int hwsim_hw_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 	pib->channel = channel;
 
 	pib_old = rtnl_dereference(phy->pib);
+
+	pib->filt.short_addr = pib_old->filt.short_addr;
+	pib->filt.pan_id = pib_old->filt.pan_id;
+	pib->filt.ieee_addr = pib_old->filt.ieee_addr;
+	pib->filt.pan_coord = pib_old->filt.pan_coord;
+
+	rcu_assign_pointer(phy->pib, pib);
+	kfree_rcu(pib_old, rcu);
+	return 0;
+}
+
+static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
+			      struct ieee802154_hw_addr_filt *filt,
+			      unsigned long changed)
+{
+	struct hwsim_phy *phy = hw->priv;
+	struct hwsim_pib *pib, *pib_old;
+
+	pib = kzalloc(sizeof(*pib), GFP_KERNEL);
+	if (!pib)
+		return -ENOMEM;
+
+	pib_old = rtnl_dereference(phy->pib);
+
+	pib->page = pib_old->page;
+	pib->channel = pib_old->channel;
+
+	pib->filt.short_addr = filt->short_addr;
+	pib->filt.pan_id = filt->pan_id;
+	pib->filt.ieee_addr = filt->ieee_addr;
+	pib->filt.pan_coord = filt->pan_coord;
+
 	rcu_assign_pointer(phy->pib, pib);
 	kfree_rcu(pib_old, rcu);
 	return 0;
@@ -172,6 +205,7 @@ static const struct ieee802154_ops hwsim_ops = {
 	.start = hwsim_hw_start,
 	.stop = hwsim_hw_stop,
 	.set_promiscuous_mode = hwsim_set_promiscuous_mode,
+	.set_hw_addr_filt = hwsim_hw_addr_filt,
 };
 
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -787,6 +821,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 	}
 
 	pib->channel = 13;
+	pib->filt.short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
+	pib->filt.pan_id = cpu_to_le16(IEEE802154_PANID_BROADCAST);
 	rcu_assign_pointer(phy->pib, pib);
 	phy->idx = idx;
 	INIT_LIST_HEAD(&phy->edges);
-- 
2.34.1

