Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0620D52A80E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350959AbiEQQf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350962AbiEQQfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:13 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26B94EF47;
        Tue, 17 May 2022 09:35:06 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 128601BF206;
        Tue, 17 May 2022 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GBcaJ7pKaakuDM+JveCsuJiWc4KTOb4IXIoTonlZDVU=;
        b=V5+2I6/xkcaV5IknxdL8OB1dMG/KSdLe2/Vq7xECpZl9m6zGWliqUE20y5/ZuD1WbywD3R
        IYONVRWDgzAYf5MpUhuWUKObns1OY00hdUb2uvKEqlzB8p/IK2BzCg6UkGz6/P091SbV94
        PM/CbdB1tBk7DfYCHYxTxbAreoYGVTtdyhFXEX6UuOcBMT0nAcl207V0XPEGr5B6zvp/hY
        mocKuzm2JLtdVjNrabzRMwlMs89TVB+2wI5O7ry/jhhQhi3D0bg93IRdKjyvcHf6u4svak
        idL/mNA9IYEWjJuu1i0oEyV2uAyzZwq8txUTALEpKre8r5H7ztHJhiOjVQ64Zg==
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
Subject: [PATCH wpan-next v3 07/11] net: mac802154: Introduce a helper to disable the queue
Date:   Tue, 17 May 2022 18:34:46 +0200
Message-Id: <20220517163450.240299-8-miquel.raynal@bootlin.com>
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

Sometimes calling the stop queue helper is not enough because it does
not hold any lock. In order to be safe and avoid racy situations when
trying to (soon) sync the Tx queue, for instance before sending an MLME
frame, let's now introduce an helper which actually hold the necessary
locks when doing so.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h | 12 ++++++++++++
 net/mac802154/util.c         | 14 ++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index 0c7ff9e0b632..e34db1d49ef4 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -149,6 +149,18 @@ void ieee802154_hold_queue(struct ieee802154_local *local);
  */
 void ieee802154_release_queue(struct ieee802154_local *local);
 
+/**
+ * ieee802154_disable_queue - disable ieee802154 queue
+ * @local: main mac object
+ *
+ * When trying to sync the Tx queue, we cannot just stop the queue
+ * (which is basically a bit being set without proper lock handling)
+ * because it would be racy. We actually need to call netif_tx_disable()
+ * instead, which is done by this helper. Restarting the queue can
+ * however still be done with a regular wake call.
+ */
+void ieee802154_disable_queue(struct ieee802154_local *local);
+
 /* MIB callbacks */
 void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
 
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 6176cc40df91..02645f57fc2a 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -83,6 +83,20 @@ void ieee802154_release_queue(struct ieee802154_local *local)
 	spin_unlock_irqrestore(&local->phy->queue_lock, flags);
 }
 
+void ieee802154_disable_queue(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		netif_tx_disable(sdata->dev);
+	}
+	rcu_read_unlock();
+}
+
 enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer)
 {
 	struct ieee802154_local *local =
-- 
2.34.1

