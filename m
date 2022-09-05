Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE45ADA46
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiIEUer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiIEUei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:38 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC74912D37;
        Mon,  5 Sep 2022 13:34:34 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BFDDBFF809;
        Mon,  5 Sep 2022 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZKlFR7u8gogbm+qAE1RDrSenefC4AOY9IMlFnB/ekA=;
        b=QttuPNS7Ri3mqoAhBpR6UahSQorD5vkevf/N0yUG/5WwdbSfOOnDxNfWH4X1voGQt3Jbqi
        aWqDQ+j6CmjplxvjqhsHZ8Qqu9unU6/Iqo3iCyi4RKn4lZcyL8uQ3uyvZsIZR6gzvRhc07
        z5cm6HOdGMH0Z3N5x2XXv8JLQnJqEvUjTQZujvJaaNtkAW3gmAMPCFy4fI3/Lzz22tGCVs
        wbYU+RdkQ9fk6LeyuCD61gXBYOJEv16JR73uFuqGL5C68k7dQi9O4J00Re6N9CdRgOV0tA
        1snt8bauGROyxVLorKgVoN0uY2PMsDrlm8R+G3TQU5FzHpoNRwkrJ86SU77HZg==
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
        Alexander Aring <aahringo@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next v3 9/9] ieee802154: atusb: add support for trac feature
Date:   Mon,  5 Sep 2022 22:34:12 +0200
Message-Id: <20220905203412.1322947-10-miquel.raynal@bootlin.com>
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

From: Alexander Aring <aahringo@redhat.com>

This patch adds support for reading the trac register if atusb firmware
reports tx done. There is currently a feature to compare a sequence
number, if the payload is 1 it tells the driver only the sequence number
is available if it's two there is additional the trac status register as
payload.

Currently the atusb_in_good() function determines if it's a tx done or
rx done if according the payload length. This patch is doing the same
and assumes this behaviour.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/atusb.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 2c338783893d..95a4a3cdc8a4 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -191,7 +191,7 @@ static void atusb_work_urbs(struct work_struct *work)
 
 /* ----- Asynchronous USB -------------------------------------------------- */
 
-static void atusb_tx_done(struct atusb *atusb, u8 seq)
+static void atusb_tx_done(struct atusb *atusb, u8 seq, int reason)
 {
 	struct usb_device *usb_dev = atusb->usb_dev;
 	u8 expect = atusb->tx_ack_seq;
@@ -199,7 +199,10 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
 	dev_dbg(&usb_dev->dev, "%s (0x%02x/0x%02x)\n", __func__, seq, expect);
 	if (seq == expect) {
 		/* TODO check for ifs handling in firmware */
-		ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
+		if (reason == IEEE802154_SUCCESS)
+			ieee802154_xmit_complete(atusb->hw, atusb->tx_skb, false);
+		else
+			ieee802154_xmit_error(atusb->hw, atusb->tx_skb, reason);
 	} else {
 		/* TODO I experience this case when atusb has a tx complete
 		 * irq before probing, we should fix the firmware it's an
@@ -215,7 +218,8 @@ static void atusb_in_good(struct urb *urb)
 	struct usb_device *usb_dev = urb->dev;
 	struct sk_buff *skb = urb->context;
 	struct atusb *atusb = SKB_ATUSB(skb);
-	u8 len, lqi;
+	int result = IEEE802154_SUCCESS;
+	u8 len, lqi, trac;
 
 	if (!urb->actual_length) {
 		dev_dbg(&usb_dev->dev, "atusb_in: zero-sized URB ?\n");
@@ -224,8 +228,27 @@ static void atusb_in_good(struct urb *urb)
 
 	len = *skb->data;
 
-	if (urb->actual_length == 1) {
-		atusb_tx_done(atusb, len);
+	switch (urb->actual_length) {
+	case 2:
+		trac = TRAC_MASK(*(skb->data + 1));
+		switch (trac) {
+		case TRAC_SUCCESS:
+		case TRAC_SUCCESS_DATA_PENDING:
+			/* already IEEE802154_SUCCESS */
+			break;
+		case TRAC_CHANNEL_ACCESS_FAILURE:
+			result = IEEE802154_CHANNEL_ACCESS_FAILURE;
+			break;
+		case TRAC_NO_ACK:
+			result = IEEE802154_NO_ACK;
+			break;
+		default:
+			result = IEEE802154_SYSTEM_ERROR;
+		}
+
+		fallthrough;
+	case 1:
+		atusb_tx_done(atusb, len, result);
 		return;
 	}
 
-- 
2.34.1

