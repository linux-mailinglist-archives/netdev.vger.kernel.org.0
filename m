Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A70512134
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiD0QuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243383AbiD0QuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:50:20 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB1331FABA;
        Wed, 27 Apr 2022 09:47:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 145F0100009;
        Wed, 27 Apr 2022 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651078027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqllBuCqgaIf9HUIzN59jKwQs6BNFOqCkdFJ8C6y3XU=;
        b=X3hACt2PyPA/jiGi8cbdyKm6VsApmldO6vSwDxKArrdlTorKr920Uaztfn+j9ox0+2Y1bY
        otQPfyL4HaUJPnVe4Isf3ebyeDr7ffKneWvXUJiLk7CJ0O2ynXEyFH/VIet5o9xSZXFSfh
        NO4/2T3FzIJ+Lv4zJ24HCTy4yURnHzVNVCTyCYiDlwZhTMosM9SGpryhAhumMdrx/WiY0M
        hxp//8AugQJn+DgrwXou+92pno+NsMDByJcDOCLnmzpOYlRiERCEx0g8F1tELGwRA2cWiA
        7wiWr5wgSSBF1DXjm1sNPpzX9g15n5IroA48//bA9ALjsur45n415VvMy3Y7ng==
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
Subject: [PATCH wpan-next 03/11] net: mac802154: Rename the synchronous xmit worker
Date:   Wed, 27 Apr 2022 18:46:51 +0200
Message-Id: <20220427164659.106447-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220427164659.106447-1-miquel.raynal@bootlin.com>
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
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

There are currently two driver hooks: one is synchronous, the other is
not. We cannot rely on driver implementations to provide a synchronous
API (which is related to the bus medium more than a wish to have a
synchronized implementation) so we are going to introduce a sync API
above any kind of driver transmit function. In order to clarify what
this worker is for (synchronous driver implementation), let's rename it
so that people don't get bothered by the fact that their driver does not
make use of the "xmit worker" which is a too generic name.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 2 +-
 net/mac802154/main.c         | 2 +-
 net/mac802154/tx.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 6652445a1147..d27e9fe363b6 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -123,7 +123,7 @@ ieee802154_sdata_running(struct ieee802154_sub_if_data *sdata)
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
-void ieee802154_xmit_worker(struct work_struct *work);
+void ieee802154_xmit_sync_worker(struct work_struct *work);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 5546ef86e231..13c6b3cd0429 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -95,7 +95,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 
 	skb_queue_head_init(&local->skb_queue);
 
-	INIT_WORK(&local->tx_work, ieee802154_xmit_worker);
+	INIT_WORK(&local->tx_work, ieee802154_xmit_sync_worker);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index c5befaca5366..0ebe39169309 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -22,7 +22,7 @@
 #include "ieee802154_i.h"
 #include "driver-ops.h"
 
-void ieee802154_xmit_worker(struct work_struct *work)
+void ieee802154_xmit_sync_worker(struct work_struct *work)
 {
 	struct ieee802154_local *local =
 		container_of(work, struct ieee802154_local, tx_work);
-- 
2.27.0

