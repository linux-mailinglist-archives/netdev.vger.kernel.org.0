Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F03A989F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhFPLEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 07:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhFPLE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 07:04:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0BCC0611DD
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 04:02:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltTJ4-0007qW-1q
        for netdev@vger.kernel.org; Wed, 16 Jun 2021 13:02:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0AACE63D2B8
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 11:02:00 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3563363D293;
        Wed, 16 Jun 2021 11:01:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a3baff8f;
        Wed, 16 Jun 2021 11:01:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Skripkin <paskripkin@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 4/4] can: mcba_usb: fix memory leak in mcba_usb
Date:   Wed, 16 Jun 2021 13:01:52 +0200
Message-Id: <20210616110152.2456765-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616110152.2456765-1-mkl@pengutronix.de>
References: <20210616110152.2456765-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

Syzbot reported memory leak in SocketCAN driver for Microchip CAN BUS
Analyzer Tool. The problem was in unfreed usb_coherent.

In mcba_usb_start() 20 coherent buffers are allocated and there is
nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see mcba_usb_start) and this flag cannot be used with
   coherent buffers.

Fail log:
| [ 1354.053291][ T8413] mcba_usb 1-1:0.0 can0: device disconnected
| [ 1367.059384][ T8420] kmemleak: 20 new suspected memory leaks (see /sys/kernel/debug/kmem)

So, all allocated buffers should be freed with usb_free_coherent()
explicitly

NOTE:
The same pattern for allocating and freeing coherent buffers
is used in drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Link: https://lore.kernel.org/r/20210609215833.30393-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/mcba_usb.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 029e77dfa773..a45865bd7254 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -82,6 +82,8 @@ struct mcba_priv {
 	bool can_ka_first_pass;
 	bool can_speed_check;
 	atomic_t free_ctx_cnt;
+	void *rxbuf[MCBA_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
 };
 
 /* CAN frame */
@@ -633,6 +635,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 	for (i = 0; i < MCBA_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -642,7 +645,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		}
 
 		buf = usb_alloc_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					 GFP_KERNEL, &urb->transfer_dma);
+					 GFP_KERNEL, &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -661,11 +664,14 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		if (err) {
 			usb_unanchor_urb(urb);
 			usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					  buf, urb->transfer_dma);
+					  buf, buf_dma);
 			usb_free_urb(urb);
 			break;
 		}
 
+		priv->rxbuf[i] = buf;
+		priv->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -708,7 +714,14 @@ static int mcba_usb_open(struct net_device *netdev)
 
 static void mcba_urb_unlink(struct mcba_priv *priv)
 {
+	int i;
+
 	usb_kill_anchored_urbs(&priv->rx_submitted);
+
+	for (i = 0; i < MCBA_MAX_RX_URBS; ++i)
+		usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
+				  priv->rxbuf[i], priv->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 }
 
-- 
2.30.2


