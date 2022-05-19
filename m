Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C2252D6DC
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiESPF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbiESPF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:28 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1308335A80;
        Thu, 19 May 2022 08:05:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 318D31BF208;
        Thu, 19 May 2022 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLZj6ae8rzh7gmQIs0cx6yI6fkYST5qGPSiZFaqno7o=;
        b=DsiRKE6aQuAs6+c3xZDaSJaWVPlBaoz3jzciZzNDfXNedEamGF5vxnIyB8lSLKKUKXiwsG
        oIM9HhIThc9MYceP+BJkXxb1Hbe4qPk/s7CM8vsA14oZHMESKApFsmxiQbfVDJSBu2X5TB
        w1Zsd4Oi7VtmLFn8tPBi/AAHNeMmsEeyciFPkRXHJGO1Vn1oQQvODCesjoq03hkGnDC38j
        9dSo9xzpnWRqB4PDszC7Lg42+U1mNHxC8NwHfZF5xpma+kr03jHdWh2neQElsQlKjXnlqu
        YngDDOPw8Ar6CtfJoFGVm/kn5OgwopWpCXJDetaCqWOl9i2v4KSjaEIFm1/oqw==
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
Subject: [PATCH wpan-next v4 03/11] net: mac802154: Enhance the error path in the main tx helper
Date:   Thu, 19 May 2022 17:05:08 +0200
Message-Id: <20220519150516.443078-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
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

Before adding more logic in the error path, let's move the wake queue
call there, rename the default label and create an additional one.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a01689ddd547..4a46ce8d2ac8 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -65,7 +65,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 				consume_skb(skb);
 				skb = nskb;
 			} else {
-				goto err_tx;
+				goto err_free_skb;
 			}
 		}
 
@@ -84,10 +84,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		unsigned int len = skb->len;
 
 		ret = drv_xmit_async(local, skb);
-		if (ret) {
-			ieee802154_wake_queue(&local->hw);
-			goto err_tx;
-		}
+		if (ret)
+			goto err_wake_netif_queue;
 
 		dev->stats.tx_packets++;
 		dev->stats.tx_bytes += len;
@@ -98,7 +96,9 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 	return NETDEV_TX_OK;
 
-err_tx:
+err_wake_netif_queue:
+	ieee802154_wake_queue(&local->hw);
+err_free_skb:
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
-- 
2.34.1

