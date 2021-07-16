Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF813CBAC9
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGPRAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:00:10 -0400
Received: from smtp-33-i2.italiaonline.it ([213.209.12.33]:46235 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230088AbhGPQ7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 12:59:55 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it ([79.54.92.92])
        by smtp-33.iol.local with ESMTPA
        id 4R8tmKNNmS6GM4R90mO7bT; Fri, 16 Jul 2021 18:56:58 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1626454618; bh=aipa+Z7keBjj+2EjLI43y9cbq8bUs5mFT1fgia6YCVA=;
        h=From;
        b=TOINo3DuxcZVbmN6AyVOVV7HrJ46uzp6zlcShoAtcF305J3+4PE1CX6X9rJHPR82d
         pBFsy05IUlbKgXkFKQhJfkZosCKYeyyA1vAHGhzN9bLFhIy56inHqEH7jRgwvK6BdG
         6f8eLwsLSAwN5tdS89+9MyVgprDuQZzKZPFK04ap5P7OfDaBZpaglutyGV1bws7uAE
         niR9THYk2QDVofzIMYrRLnw+KUz2+N/PPuoP+tUdc+J01Ss8omHXphW9BsABIYEJvK
         t8PmOeG5fxrnFMmUcJtat9yzq4YSeIvUyrygmP5s6iH/5dYNi7H5zNjYUDUXlgMewI
         3d9f8d1+l/54w==
X-CNFS-Analysis: v=2.4 cv=AcF0o1bG c=1 sm=1 tr=0 ts=60f1ba5a cx=a_exe
 a=eKwsI+FXzXP/Nc4oRbpalQ==:117 a=eKwsI+FXzXP/Nc4oRbpalQ==:17
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
Subject: [PATCH 2/4] can: c_can: exit c_can_do_tx() early if no frames have been sent
Date:   Fri, 16 Jul 2021 18:56:21 +0200
Message-Id: <20210716165623.19677-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716165623.19677-1-dariobin@libero.it>
References: <20210716165623.19677-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfLH9hcar4n2Z0lDfTRw6KsDOa/8RUbDd3uxDk+x6+jx+2/mqp6ypsPo8YZHLpIWU9dbXqEKenWUeixgw0FphysQXlC+rw8+nSjVW1UJdJgPNSwc6veNg
 5sUZzzTTYd26HNcbs9fulOr5URgYfAQVDVmq1igHEyR94YHpY25DsrxO6tm4Bs1Rsgq86eGg5ML+J3GRWDinCqRCkTevqu7VDp4qiCMf05hsuRqURjmEhvmD
 NAuQgvp7L3LaSjK2en2BSeewHz8qkYQX1fAg2mLQJqKzBbM/Re5wUCO6NUXy4QCWcSycxMieUVoT0CUvTHjP6C+kD85uimoXA9c1Yy54DK1Q1/bXQApL8SQ3
 fjTgrIF/INX//+rUtfSa82/0yx56TZ5LZhJ8gxVYqRD1E6ZsVdxwjcoJV/xFTcb8/UZN3qwr/vRTI4uhkX5lDmiZHhALPib7PB4Dnsn9AZOtTG+FjTfyN0TA
 Ksppf9d6Qj4nCfWRgEIqU/aWHDKIvHD84byTdd9vaGYcAebc+FBqj461CkfA6cftBmUidka8yjY9WXDQuChdoPMuQBny38Eaa8V8uQ==
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

