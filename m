Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4EC52D6F2
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiESPG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiESPFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:43 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4125D3E0C9;
        Thu, 19 May 2022 08:05:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E50631BF21F;
        Thu, 19 May 2022 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+gGeYeGa/Nd/IDP/YTcG+HvGF3GhRyYLyPSikZabcPw=;
        b=Ik0HcHMiYZpyzWFeWH0ln2jJDUiY4h62rb4/y5MIMBaVn6RR5tk3daRkpnytBUJVNJh7pB
        oOsS3F7EELBWHCXA/wjlHrnPSk+pLzPQzmD363tDoOTYW/upr0kPaS3kQnAhhZ3rK+ZO7d
        RN8JFzKZSYPBsHP16uy5WBMsw0MccgIjJ/+1D65/sahnLsToCWzewZJcHMIYlQzqQuzlLe
        PwhXVNljtaTZ3yDFIXYD1iWhUB/6LDG1kW4kGdlHSlQpY30L7uU8mPN7P/lJxWi8vj5rOv
        L7hGNZ1HDm4mZggCNQfIb7bweBEX6IuiHYJr+e683QAupHuAk1c8EzAGEx5agg==
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
Subject: [PATCH wpan-next v4 11/11] net: mac802154: Add a warning in the slow path
Date:   Thu, 19 May 2022 17:05:16 +0200
Message-Id: <20220519150516.443078-12-miquel.raynal@bootlin.com>
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
 net/mac802154/tx.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 6188f42276e7..5b471e932271 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ret;
 }
 
+static bool ieee802154_netif_is_down(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool is_down = true;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		is_down = !netif_running(sdata->dev);
+		if (is_down)
+			break;
+	}
+	rcu_read_unlock();
+
+	return is_down;
+}
+
 int ieee802154_mlme_op_pre(struct ieee802154_local *local)
 {
 	return ieee802154_sync_and_hold_queue(local);
@@ -152,6 +171,14 @@ int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
 		return -ENETDOWN;
 	}
 
+	/* Warn if the ieee802154 core thinks MLME frames can be sent while the
+	 * net interface expects this cannot happen.
+	 */
+	if (WARN_ON_ONCE(ieee802154_netif_is_down(local))) {
+		rtnl_unlock();
+		return -ENETDOWN;
+	}
+
 	ieee802154_tx(local, skb);
 	ret = ieee802154_sync_queue(local);
 
-- 
2.34.1

