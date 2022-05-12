Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A3F525024
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355386AbiELOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355346AbiELOdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:53 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A825F7AC;
        Thu, 12 May 2022 07:33:36 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C2A11FF813;
        Thu, 12 May 2022 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V87QhPEf4fMiwaTvp/KGJROCR2XIjXq5O9RjBC7s++M=;
        b=acGc/jj1fCb5b37McJP9Szmodr/aG3mUA7LKTP1ub+DwX15PGVFZ0xWK6o+3jglOWaDpRD
        McJ5N+3fsf0TjDpyTn6ZN1xtveZcQFMr6LhCV90WxCB7wA2RWfLMILtxde4zT0PzWxaf9U
        6oopz3TOG5FRV2HDGw2cyrXRdNtP99zNFekyOJKLsfTXYoqrZNaHLnDM48+xubkNsC/pd/
        ncIEWWcGfqV4zFXcYD266CgoLhH5fyYLufeDRk+oPT4y451V3ygZRJ3UIG3VK7NV2Jq1s1
        S1joC5vAdsRSUwbSLBJ2/c8VFA3i6Gru/9mZCwnffyc4QdAhkodOKeMhM+Gs0Q==
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
Subject: [PATCH wpan-next v2 11/11] net: mac802154: Add a warning in the slow path
Date:   Thu, 12 May 2022 16:33:14 +0200
Message-Id: <20220512143314.235604-12-miquel.raynal@bootlin.com>
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

In order to be able to detect possible conflicts between the net
interface core and the ieee802154 core, let's add a warning in the slow
path: we want to be sure that whenever we start an asynchronous MLME
transmission (which can be fully asynchronous) the net core somehow
agrees that this transmission is possible, ie. the device was not
stopped. Warning in this case would allow us to track down more easily
possible issues with the MLME logic if we ever get reports.

Unlike in the hot path, such a situation cannot be handled.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index a3c9f194c025..d61b076239c3 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ret;
 }
 
+static bool ieee802154_netif_is_down(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool is_down = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		is_down = !(sdata->dev->flags & IFF_UP);
+		if (is_down)
+			break;
+	}
+	rcu_read_unlock();
+
+	return is_down;
+}
+
 int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
 	int ret;
@@ -145,6 +164,12 @@ int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
 	if (!local->open_count)
 		return -EBUSY;
 
+	/* Warn if the ieee802154 core thinks MLME frames can be sent while the
+	 * net interface expects this cannot happen.
+	 */
+	if (WARN_ON_ONCE(ieee802154_netif_is_down(local)))
+		return -EHOSTDOWN;
+
 	ieee802154_sync_and_hold_queue(local);
 
 	ieee802154_tx(local, skb);
-- 
2.27.0

