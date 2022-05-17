Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11BB52A81B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350966AbiEQQfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350962AbiEQQfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:01 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF94EDE9;
        Tue, 17 May 2022 09:35:00 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5136D1BF204;
        Tue, 17 May 2022 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mLZj6ae8rzh7gmQIs0cx6yI6fkYST5qGPSiZFaqno7o=;
        b=EA/BM/Bc2QGd4+nB0LRBrNbmnJooVJArccgKyXBPjigaLvd3Un/gmZqiYDeStk9eJcvlLd
        neb0CkxFfqhqeVv7gdV5OTFTYOlT1MW9YatRYme2b3sR5zgzDVLmp5uscqKhBilYAGwki7
        q9LYAVOTuHAlHQ4nP/ffEHuqpPqBd5JKHxXnwUQZej8KtIULXwZdIow2eqmPfpQE9lpzOE
        O2iXX0/azFa+NC7mmRx5QuOVpY89BXWBILpjwoVi7rGqyrQegDKHiqor5yZ7KWylkKPh60
        QzFF1yEw1y+YdMOyUu/AaYgOZGPOnvtybGglTxVzfzWJxNtXq75DZJS+wyuhNQ==
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
Subject: [PATCH wpan-next v3 03/11] net: mac802154: Enhance the error path in the main tx helper
Date:   Tue, 17 May 2022 18:34:42 +0200
Message-Id: <20220517163450.240299-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163450.240299-1-miquel.raynal@bootlin.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
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
2.34.1

