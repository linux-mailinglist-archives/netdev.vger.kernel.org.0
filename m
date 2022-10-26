Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4E60DE2C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJZJfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiJZJfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:35:13 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E5B7F4A;
        Wed, 26 Oct 2022 02:35:12 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BE46B20002;
        Wed, 26 Oct 2022 09:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666776909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZB5f0usf5IvMcUvkbGgXBKLz/Oi1uhjhHZiBstgC44=;
        b=lVYi0HdhoqiRdiRgwOB8205END4+BwCRrm6LMc8bep3dWPqLj+v0fQpjVvCczq6iZjMDf6
        QXuMA5LTKmWnsTHFWsTC2CFRztct0x2QnnfJ/6mJasvuqLbm05WVNDFUVsrY49uLFmUOtv
        MH49BMhGAo1mxC27S58GVmQ4KpXNKarpJfIQ7qf7cGwAqqxahvT+5fiVgolpTdOhAxhHAS
        Vo/dkPOPRrL/FXI8yM5S6BKHddl1HKfSh1yVyF7FYYp61/vcReDB7hnbmC3TL7I38JcLob
        tp/t5NopSpR3eF0UNnLEYhuKBlrP56lr2Y4Cu9fbkCUwKTFXBBL2Mc/n86v5bA==
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
Subject: [PATCH wpan-next v2 1/3] mac802154: Move an skb free within the rx path
Date:   Wed, 26 Oct 2022 11:35:00 +0200
Message-Id: <20221026093502.602734-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026093502.602734-1-miquel.raynal@bootlin.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may appear clearer to free the skb at the end of the path rather than
in the middle, within a helper.

Move kfree_skb() from the end of __ieee802154_rx_handle_packet() to
right after it in the calling function ieee802154_rx(). Doing so implies
reworking a little bit the exit path.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 334aa4e415cc..9f3e72a278cb 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -234,8 +234,6 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 		skb = NULL;
 		break;
 	}
-
-	kfree_skb(skb);
 }
 
 static void
@@ -274,7 +272,7 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 	WARN_ON_ONCE(softirq_count() == 0);
 
 	if (local->suspended)
-		goto drop;
+		goto free_skb;
 
 	/* TODO: When a transceiver omits the checksum here, we
 	 * add an own calculated one. This is currently an ugly
@@ -292,20 +290,17 @@ void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb)
 	/* Level 1 filtering: Check the FCS by software when relevant */
 	if (local->hw.phy->filtering == IEEE802154_FILTERING_NONE) {
 		crc = crc_ccitt(0, skb->data, skb->len);
-		if (crc) {
-			rcu_read_unlock();
+		if (crc)
 			goto drop;
-		}
 	}
 	/* remove crc */
 	skb_trim(skb, skb->len - 2);
 
 	__ieee802154_rx_handle_packet(local, skb);
 
-	rcu_read_unlock();
-
-	return;
 drop:
+	rcu_read_unlock();
+free_skb:
 	kfree_skb(skb);
 }
 
-- 
2.34.1

