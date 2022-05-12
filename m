Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7783525015
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355341AbiELOdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355323AbiELOd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:27 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D373725F78E;
        Thu, 12 May 2022 07:33:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CA4E3FF813;
        Thu, 12 May 2022 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7eQ2QxN67uBMocQZANqKQDKfsx58Be6cxD8wB3BLfw=;
        b=k/i8K9HvT1PmX+7wbDBNKK1tFvM4iwma5ZexBhI5ud/x84YyH2NvBPbhK5qVtA8o1QNdwv
        QJZ//zZNC++waNAPaOBhL6smM5D440HcgSMZG7veUuvylRG+K6k6XQ+SNaFvwPjG2N1n18
        6WwqdtssdaNpCTEvRuxAWbyQSKn7iI10kN+0Mp8HDSYNx5ZX6GadbKCGh+hgpEI9Qqdx3E
        zDdojXpbYczZMno1rwqntPrVyuqlU9Y4wo5SewwP89SOSWfYAjVtFDVGqBNMyoRH5xWwC6
        HjsMHrVI3Eo/OCEZEnglXjukS5OiAMcRYO10OhF/Ba6oXKhMmbWn5aVL3hkchQ==
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
Subject: [PATCH wpan-next v2 03/11] net: mac802154: Enhance the error path in the main tx helper
Date:   Thu, 12 May 2022 16:33:06 +0200
Message-Id: <20220512143314.235604-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512143314.235604-1-miquel.raynal@bootlin.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
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
2.27.0

