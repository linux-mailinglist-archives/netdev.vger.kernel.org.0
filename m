Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889273D4EAD
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhGYPbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:31:39 -0400
Received: from smtp-34-i2.italiaonline.it ([213.209.12.34]:49449 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230261AbhGYPbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 11:31:32 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([79.45.45.231])
        by smtp-34.iol.local with ESMTPA
        id 7gjJmU9oJLCum7gjQmo2ay; Sun, 25 Jul 2021 18:12:01 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627229521; bh=aipa+Z7keBjj+2EjLI43y9cbq8bUs5mFT1fgia6YCVA=;
        h=From;
        b=PvTfF9O4pQvzTe/7xgPFFOHWAqMqnpqBE2LV4M/fa4Hoej4zOaEzkGprJThOihOP7
         LeWmMSeHpg9+NvI1hYOHVoRtd0Q4iAUV5dMlg3ZUXcs0m+LYzfSyZ5UvwH2X6kcNgV
         OA/3mrw3SSHj3JwOok/UbdD/QNLSszs62n/rJfi69UUbyr0VwLkvAQ3mP+tZpWF+Vn
         aDFqL5xlWn2BqfAui/7WJ4i+V5g+maxZXociRtftR3hVtbUoG2ofIY0OJmEkxnGMsl
         KUNsYE/24tVWV/IiOp1J3ynqmGvsqB56iY3ObpF1jywU+0rB3YDgN8OCzTXo15IiBy
         DbiVhFwz/h1NA==
X-CNFS-Analysis: v=2.4 cv=a8D1SWeF c=1 sm=1 tr=0 ts=60fd8d51 cx=a_exe
 a=TX8r+oJM0yLPAmPh5WrBoQ==:117 a=TX8r+oJM0yLPAmPh5WrBoQ==:17
 a=0RFnQWo-as75lT-uasUA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RESEND PATCH 2/4] can: c_can: exit c_can_do_tx() early if no frames have been sent
Date:   Sun, 25 Jul 2021 18:11:48 +0200
Message-Id: <20210725161150.11801-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210725161150.11801-1-dariobin@libero.it>
References: <20210725161150.11801-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfNA4QVyiaiFewOl+nU41eANhJeeO/BmmBM3xrAsuJNLHzhEpIjPTsVS1RaaOwvRwhsAWm2kuFXTzHAtkjweyAAr4+lyAsE+pgMd2Rv0SOeKwx3UOlPq+
 oSbBplIAsJJmE85TQT29nszBLFYKpQ7RiLmIQNf6tceSbqmoPFWIFiNAnXpjcplK+e39xstj7Fs3pYrnzy2UtVKGBlvctCYVbAFHnZQzF6wGP6N4gq/3phVM
 +sQ3XUCHdegVjvKChbQIYyPBb4F3wAp5OkhMzCvGC+0gGTfaBTZFjDBKCL7SR7888+vX3ThmnmuWT9VWC6ZNxO65CMW+nN7Cg6h/1AZPmtBs6zbnSl8tECMz
 u06JEFGLz4gtruHA6HBUJy0nGdLOf7cJwy/8rmUGKf5uqyDXFDDVQfLtGFuKET34PYctg2FIrU7WmUet3+vWaZ0yAs8RAHqf0Cfc7LxOmGcCjJGnno1rUGKy
 VbQ0B9eYnslSMmeQWq6ZDxb6nJnPmeAVUA3nKJUAQaEJskDeVWUksWjork/PCA88VXewRIz6Ybj6bGyueEatvjPoQTtETMbTRFYIcQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The c_can_poll() handles RX/TX events unconditionally. It may therefore
happen that c_can_do_tx() is called unnecessarily because the interrupt
was triggered by the reception of a frame. In these cases, we avoid to
execute unnecessary statements and exit immediately.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 7588f70ca0fe..fec0e3416970 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -720,17 +720,18 @@ static void c_can_do_tx(struct net_device *dev)
 		pkts++;
 	}
 
+	if (!pkts)
+		return;
+
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
 	if (clr & BIT(priv->msg_obj_tx_num - 1))
 		netif_wake_queue(dev);
 
-	if (pkts) {
-		stats->tx_bytes += bytes;
-		stats->tx_packets += pkts;
-		can_led_event(dev, CAN_LED_EVENT_TX);
-	}
+	stats->tx_bytes += bytes;
+	stats->tx_packets += pkts;
+	can_led_event(dev, CAN_LED_EVENT_TX);
 }
 
 /* If we have a gap in the pending bits, that means we either
-- 
2.17.1

