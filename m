Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4025D525013
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352822AbiELOdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355334AbiELOdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:47 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ACA24F0CF;
        Thu, 12 May 2022 07:33:30 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A35FFFF819;
        Thu, 12 May 2022 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FHoEGkhiwRbRsVPuC1ORFUGK/a2x2h+Fwau/qhtF2Lk=;
        b=PHEF6JxtqEQtHz/bGSFn00C4o860es87RJLw10KiDyXRkvSgMR9Qe/dejM6203Ec2y4dLe
        9v/ortbZlIu6Q03i2RlUW5j9w5r8d1T383bb0tTk3PQwPgh1+8OMqqTNCAhtxll9AC+h2k
        /1LgowMOwtSegX2IGx31zuP+ErKPLqmRqP/O2akotkKAwMptv/Bppu/7pSTB/rXbiB2BBb
        O8xIlvf94uykwAmJEJnPL4j64xJKvASh0pv+X7DzcfJznLK1iTL4maLX+Sx89+CfCqCRud
        V/Jy2vtSYwzDzFO5+zw7Miq6A/5GK4sSKMxs0ACL1/idyNQ0EZiMUyOfa16b2Q==
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
Subject: [PATCH wpan-next v2 07/11] net: mac802154: Introduce a helper to disable the queue
Date:   Thu, 12 May 2022 16:33:10 +0200
Message-Id: <20220512143314.235604-8-miquel.raynal@bootlin.com>
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
index b629c94cfd1b..31b53b3165ec 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -79,6 +79,20 @@ void ieee802154_release_queue(struct ieee802154_local *local)
 	mutex_unlock(&local->phy->queue_lock);
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
2.27.0

