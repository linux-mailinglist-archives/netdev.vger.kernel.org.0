Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581846062EF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJTOZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiJTOZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:25:42 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D313D59A;
        Thu, 20 Oct 2022 07:25:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8D6631C0006;
        Thu, 20 Oct 2022 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666275938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J1TSo5A9BKJBN3Vfi6H/wX54KkCMqGLkgKDQXkFQJDY=;
        b=oNBKurHthyBQ3RhCGm2gpiKsxm7IBSHqTiDx0BqLzDI8dSg6eISvXQFda2m+ChwU4Gz53J
        WILdJ6h6+69VhcPKmpaCYrY1wdwUrpcEu6CD0OK6ytC2eiUcpSOmp1FqsmS9f89ut8Saph
        3A8yeMHVDyqJOtkMl+GIFEdDtC6cNIDkwDzC1h417GaezXRA41fcl3ifcKOTVWU6qa+C9t
        b3OWaxfsNf8l1DMiF0wq7fz2IvSC0/t8WfKOiHFvovB10w3gG1fe9frJ+oLbb70pATy+mJ
        kjMWmhYNjhs7gVarFFbuzSUsYfec2hdg0IprzBG8ZqgmgFQn3+ezze8iRCV1Pg==
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH wpan] mac802154: Fix LQI recording
Date:   Thu, 20 Oct 2022 16:25:35 +0200
Message-Id: <20221020142535.1038885-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

Back in 2014, the LQI was saved in the skb control buffer (skb->cb, or
mac_cb(skb)) without any actual reset of this area prior to its use.

As part of a useful rework of the use of this region, 32edc40ae65c
("ieee802154: change _cb handling slightly") introduced mac_cb_init() to
basically memset the cb field to 0. In particular, this new function got
called at the beginning of mac802154_parse_frame_start(), right before
the location where the buffer got actually filled.

What went through unnoticed however, is the fact that the very first
helper called by device drivers in the receive path already used this
area to save the LQI value for later extraction. Resetting the cb field
"so late" led to systematically zeroing the LQI.

If we consider the reset of the cb field needed, we can make it as soon
as we get an skb from a device driver, right before storing the LQI,
as is the very first time we need to write something there.

Cc: stable@vger.kernel.org
Fixes: 32edc40ae65c ("ieee802154: change _cb handling slightly")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---

Hello,

I am surprised the LQI was gone for all those years and nobody
noticed it, so perhaps I did misinterpret slightly the situation, but I
am pretty sure the cb area reset was erasing the LQI.

About the backports, they will likely fail on the older kernels because
of some function/file moves, but I don't think we really care.

Cheers,
Miquèl

 net/mac802154/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index d1f7b8df41fe..a4733a62911f 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -134,7 +134,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -305,8 +305,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
-- 
2.34.1

