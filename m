Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F6D4CC51F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiCCS0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbiCCS0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:04 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363C31A41E2;
        Thu,  3 Mar 2022 10:25:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8115D2000D;
        Thu,  3 Mar 2022 18:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rizhsl0RIirMTOdpmsfneZgvqvSRouzexSJ2mPB9mRo=;
        b=oOMZtKx9QTkYahLs2z5MyMoE1mDdqOtWs5Dl4CECi97Qm6f8YYmG0lcVF44O2RjY6DC51N
        8uH0OhR+R45LRxfC7BZCzwfVzzwWwEgoCYZQXMhQKWgAdbCYYeyvpIgHnyuNa5cprh0gIa
        GYj/zOXEYJLKPAdCPV1Eb8j3Q37zdosrbQq72Qla3xqz8x8cuifYvHHD4lPJe7plCSvbGd
        g1iAkEA11i+QjMAW/8N46Z0zWfr41Pn5RmLZyKk/EfZYdhfyH8ho1yZM98bttzOSX58glG
        GZwlcXsu+jpmTFtP83BQ2TMmgEUdOv9LqffKxwBT99YkwcpydqA9fFMs5tTTiw==
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
Subject: [PATCH wpan-next v3 04/11] net: mac802154: Save a global error code on transmissions
Date:   Thu,  3 Mar 2022 19:25:01 +0100
Message-Id: <20220303182508.288136-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220303182508.288136-1-miquel.raynal@bootlin.com>
References: <20220303182508.288136-1-miquel.raynal@bootlin.com>
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

So far no error is returned from a failing transmission. However it
might sometimes be useful, and particularly easy to use during sync
transfers (for certain MLME commands). Let's create an internal variable
for that, global to the device. Right now only success are registered,
which is rather useless, but soon we will have more situations filling
this field.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 ++
 net/mac802154/util.c         | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 702560acc8ce..1381e6a5e180 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -56,6 +56,8 @@ struct ieee802154_local {
 
 	struct sk_buff *tx_skb;
 	struct work_struct tx_work;
+	/* A negative Linux error code or a null/positive MLME error status */
+	int tx_result;
 };
 
 enum {
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 37d2520804e3..ec523335336c 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -58,8 +58,11 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling)
 {
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	local->tx_result = IEEE802154_SUCCESS;
+
 	if (ifs_handling) {
-		struct ieee802154_local *local = hw_to_local(hw);
 		u8 max_sifs_size;
 
 		/* If transceiver sets CRC on his own we need to use lifs
-- 
2.27.0

