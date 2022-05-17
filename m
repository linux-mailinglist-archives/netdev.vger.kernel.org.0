Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588A352A80B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350963AbiEQQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350959AbiEQQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:00 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FF4EDF1;
        Tue, 17 May 2022 09:34:58 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BBAD11BF20B;
        Tue, 17 May 2022 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHe7QpRZDkkDN5jx8ES3bIsouncXdhD8eetbRXsACsQ=;
        b=VDsskbylzk/uVJdYhL7VKYo4gUMAH4vh+6o4Z32Ei3/wjtTIFEWu7R920E3BA6fGh3jxKS
        vp+cp0i+3bAuZK3zmjk/vKukr+uHMW1+2aU/7Dq5VXVHVRalFhkUhaMiL9eLselu5vQHqF
        dOjCupA0Yj/WxAKqmMdAmbSgkAWpmfOhxSdtX9sb/Is4pSrgRxX1CoXCnPYq7Yxm9pZYTv
        bhOz6j5NPT3C2MgwN55wB79TcK20Nio69f9GgbZkTs3+xdgAfOeOw+nVNz7wals8jKET57
        WawuUOrJfBGmXq+3szkoDa8cSv/OxKAK52Kf5/6aFLktLx1PV966GicESo0HpA==
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
Subject: [PATCH wpan-next v3 02/11] net: mac802154: Rename the main tx_work struct
Date:   Tue, 17 May 2022 18:34:41 +0200
Message-Id: <20220517163450.240299-3-miquel.raynal@bootlin.com>
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

This entry is dedicated to synchronous transmissions done by drivers
without async hook. Make this clearer that this is not a work that any
driver can use by at least prefixing it with "sync_". While at it, let's
enhance the comment explaining why we choose one or the other.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 +-
 net/mac802154/main.c         | 2 +-
 net/mac802154/tx.c           | 9 ++++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index d7632c6d225f..a8b7b9049f14 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -55,7 +55,7 @@ struct ieee802154_local {
 	struct sk_buff_head skb_queue;
 
 	struct sk_buff *tx_skb;
-	struct work_struct tx_work;
+	struct work_struct sync_tx_work;
 	/* A negative Linux error code or a null/positive MLME error status */
 	int tx_result;
 };
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 392771bba9dd..40fab08df24b 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -95,7 +95,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	skb_queue_head_init(&local->skb_queue);
 
-	INIT_WORK(&local->tx_work, ieee802154_xmit_sync_worker);
+	INIT_WORK(&local->sync_tx_work, ieee802154_xmit_sync_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 97df5985b830..a01689ddd547 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -25,7 +25,7 @@
 void ieee802154_xmit_sync_worker(struct work_struct *work)
 {
 	struct ieee802154_local *local =
-		container_of(work, struct ieee802154_local, tx_work);
+		container_of(work, struct ieee802154_local, sync_tx_work);
 	struct sk_buff *skb = local->tx_skb;
 	struct net_device *dev = skb->dev;
 	int res;
@@ -76,7 +76,10 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	/* Stop the netif queue on each sub_if_data object. */
 	ieee802154_stop_queue(&local->hw);
 
-	/* async is priority, otherwise sync is fallback */
+	/* Drivers should preferably implement the async callback. In some rare
+	 * cases they only provide a sync callback which we will use as a
+	 * fallback.
+	 */
 	if (local->ops->xmit_async) {
 		unsigned int len = skb->len;
 
@@ -90,7 +93,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		dev->stats.tx_bytes += len;
 	} else {
 		local->tx_skb = skb;
-		queue_work(local->workqueue, &local->tx_work);
+		queue_work(local->workqueue, &local->sync_tx_work);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.34.1

