Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6C5ADA43
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiIEUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiIEUeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:31 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4F963C4;
        Mon,  5 Sep 2022 13:34:29 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D5137FF80E;
        Mon,  5 Sep 2022 20:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNNdmI66tnHE7JkGyA+dXRGyooXsRfbcjOPzeUejA5I=;
        b=h0cqncYmilzr5paY0ZE6NPApkSALeLXbc0w5jQ/rcEPWvcEifrnvjs3jWhGrxHnGWIkPzi
        FOGaqnDH/2cxjb2l3Tg1KtBxcJrwaShwZIZ6HCfPZ8yC/TcFazbVCfAP8kNtblcR8dsIFF
        7gysXOC5ZDOM087RUUNI3ZBa8KPTKA5wLHjsOVP2uqJnNGydKZKcm4Tqat6KlzH3Y5np0o
        u6iVTulB2Fsu8dPoNfcaCKkAUTMr/nNxlPIlGK4kIb6pGiFkoQ2Td9ayDZDRGbHyPeUXdm
        CFsJ0H4upvxUQa0F2ZfNUQsrWjENmJDJXyKeOoH6MIASFGE+pqTY1S3kY/zSWg==
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
Subject: [PATCH wpan/next v3 6/9] net: mac802154: Add promiscuous software filtering
Date:   Mon,  5 Sep 2022 22:34:09 +0200
Message-Id: <20220905203412.1322947-7-miquel.raynal@bootlin.com>
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

Currently, the promiscuous mode was not as open as it should. It was not
a big deal because until now promiscuous modes were only used on monitor
interfaces, which would never go this far in the filtering. But as we
might now use this promiscuous mode with NODEs or COORDs, it becomes
necessary to really forward the packets to the upper layers without
additional filtering when relevant. Let's add the necessary logic to
handle this situation.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index bd1a92fceef7..8a8c5a4a2f28 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -196,10 +196,31 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	int ret;
 	struct ieee802154_sub_if_data *sdata;
 	struct ieee802154_hdr hdr;
+	struct sk_buff *skb2;
 
+	/* Level 2 filtering: Avoid further processing in IEEE 802.15.4 promiscuous modes */
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee802154_sdata_running(sdata))
+			continue;
+
+		if (sdata->required_filtering < IEEE802154_FILTERING_1_FCS ||
+		    sdata->required_filtering > IEEE802154_FILTERING_2_PROMISCUOUS)
+			continue;
+
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		if (skb2) {
+			skb2->dev = sdata->dev;
+			ieee802154_deliver_skb(skb2);
+
+			sdata->dev->stats.rx_packets++;
+			sdata->dev->stats.rx_bytes += skb->len;
+		}
+	}
+
+	/* Common filtering between level 3 and 4: frame headers validity */
 	ret = ieee802154_parse_frame_start(skb, &hdr);
 	if (ret) {
-		pr_debug("got invalid frame\n");
+		dev_dbg(&sdata->dev->dev, "invalid frame headers\n");
 		kfree_skb(skb);
 		return;
 	}
@@ -208,7 +229,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 		if (!ieee802154_sdata_running(sdata))
 			continue;
 
-		if (sdata->required_filtering == IEEE802154_FILTERING_NONE)
+		if (sdata->required_filtering <= IEEE802154_FILTERING_2_PROMISCUOUS)
 			continue;
 
 		ieee802154_subif_frame(sdata, skb, &hdr);
-- 
2.34.1

