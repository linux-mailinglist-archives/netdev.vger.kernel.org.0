Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FC25A2986
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiHZOag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344523AbiHZOaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:30:12 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89769753AD;
        Fri, 26 Aug 2022 07:30:00 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 43AF0240006;
        Fri, 26 Aug 2022 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aQD20Brwv2E/xJ6AX9y2GLXP1qUIHPs5gmP90CzDfM4=;
        b=QNn0W7jtgNYuxzSQ6EnXSsvFbxAJaM9M1my9vexOBTmwLCvGT8Z8G5Awm4+j4d6O2bEFP1
        JzhDB4jOvR6zxZNolZz6OsHMbNA1ZrV+qo6b+L4ZXbY8CHEVyerPUKG4NbRE2qffZpCar8
        f1hxTrc7TvE9m7gM99jKe7Q0+fGAS6c3X26SGWPk34TSxRUg4q/rLylTApb4Hjhc34JpIk
        8oEYLSko9eJetFiajo9jtCZr4jyjLh3THIT+hmjzbz4l+0V2TfzgHq08ad9EnpoqB3U3zq
        6PQMyqk0yBbfdL+s4KYU+lG7M7x9/AOhTpzK2I0W616YY9/GQsh35coJrjRrUQ==
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH] net: mac802154: Fix a condition in the receive path
Date:   Fri, 26 Aug 2022 16:29:54 +0200
Message-Id: <20220826142954.254853-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

Upon reception, a packet must be categorized, either it's destination is
the host, or it is another host. A packet with no destination addressing
fields may be valid in two situations:
- the packet has no source field: only ACKs are built like that, we
  consider the host as the destination.
- the packet has a valid source field: it is directed to the PAN
  coordinator, as for know we don't have this information we consider we
  are not the PAN coordinator.

There was likely a copy/paste error made during a previous cleanup
because the if clause is now containing exactly the same condition as in
the switch case, which can never be true. In the past the destination
address was used in the switch and the source address was used in the
if, which matches what the spec says.

Cc: stable@vger.kernel.org
Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b8ce84618a55..c439125ef2b9 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 
 	switch (mac_cb(skb)->dest.mode) {
 	case IEEE802154_ADDR_NONE:
-		if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
+		if (hdr->source.mode != IEEE802154_ADDR_NONE)
 			/* FIXME: check if we are PAN coordinator */
 			skb->pkt_type = PACKET_OTHERHOST;
 		else
-- 
2.34.1

