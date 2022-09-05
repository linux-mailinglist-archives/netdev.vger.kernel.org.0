Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65CE5ADA40
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiIEUej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiIEUe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:28 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C85AE50;
        Mon,  5 Sep 2022 13:34:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5A978FF80C;
        Mon,  5 Sep 2022 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOwEBqWSFv6kqHl05QgPEGEPciYgTjI5729Ojch0GuU=;
        b=QB6eeuRDk0sSZfz7s8136xKWV7pJvOIif/bw71LWA1nJaqPx3GWttL+Zhmp1LJ3FbPWJwq
        1KsxtYa18fuS6ZMqIpmYIJimjs6dv4lSky4hKBO2yf+4EYIf0rhPZ8Pb0lXia2ORxXo5jT
        89+sTSgL1PFVQG5yOt59j5kDD2dXohpHrIjOiD37z03k2O3tBwHcoVk5XOxr/VPOcpVDgE
        c3thoffn2j8YR1xcCjgEJsocnnNYcXr2UH5ZfjwWbh4A9lPqfO0sml2gVL+IYb/y0UGt7L
        YzpREsMxli5tvqoUl1SHi343dPfQcqDN29z8axMx/uwnZmSQsnkY/hlIbKziVA==
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next v3 4/9] net: mac802154: Don't limit the FILTER_NONE level to monitors
Date:   Mon,  5 Sep 2022 22:34:07 +0200
Message-Id: <20220905203412.1322947-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
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

Historically, only monitors were using promiscuous mode and this
promiscuous mode was not the one from the spec but actually implied no
filtering at all (sniffers). Now that we have a more fine grained
approach, we can ensure all interfaces which would be expecting no
filter at all could get it without being a monitor interface.

Having this in place will allow us to clarify the additional software
checks compared to the hardware capabilities.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index 369ffd800abf..26df79911f3e 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -205,10 +205,10 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
+		if (!ieee802154_sdata_running(sdata))
 			continue;
 
-		if (!ieee802154_sdata_running(sdata))
+		if (sdata->required_filtering == IEEE802154_FILTERING_NONE)
 			continue;
 
 		ieee802154_subif_frame(sdata, skb, &hdr);
@@ -231,10 +231,10 @@ ieee802154_monitors_rx(struct ieee802154_local *local, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IEEE802154);
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
+		if (!ieee802154_sdata_running(sdata))
 			continue;
 
-		if (!ieee802154_sdata_running(sdata))
+		if (sdata->required_filtering > IEEE802154_FILTERING_NONE)
 			continue;
 
 		skb2 = skb_clone(skb, GFP_ATOMIC);
-- 
2.34.1

