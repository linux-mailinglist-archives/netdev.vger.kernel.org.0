Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4D3DB43E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbhG3HFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237819AbhG3HFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:05:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6171C061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 00:05:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MaP-000673-6D
        for netdev@vger.kernel.org; Fri, 30 Jul 2021 09:05:37 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4D65365B7C9
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:05:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 908F465B79C;
        Fri, 30 Jul 2021 07:05:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a61cec51;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Skripkin <paskripkin@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 6/6] can: esd_usb2: fix memory leak
Date:   Fri, 30 Jul 2021 09:05:26 +0200
Message-Id: <20210730070526.1699867-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730070526.1699867-1-mkl@pengutronix.de>
References: <20210730070526.1699867-1-mkl@pengutronix.de>
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

In esd_usb2_setup_rx_urbs() MAX_RX_URBS coherent buffers are allocated
and there is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see esd_usb2_setup_rx_urbs) and this flag cannot be used
   with coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers. The
same patch was applied to mcba_usb driver and it works nice with real
hardware. There is no change in functionality, only clean-up code for
coherent buffers.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Link: https://lore.kernel.org/r/b31b096926dcb35998ad0271aac4b51770ca7cc8.1627404470.git.paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 65b58f8fc328..66fa8b07c2e6 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -195,6 +195,8 @@ struct esd_usb2 {
 	int net_count;
 	u32 version;
 	int rxinitdone;
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 struct esd_usb2_net_priv {
@@ -545,6 +547,7 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -554,7 +557,7 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
 				 "No memory left for USB buffer\n");
@@ -562,6 +565,8 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 			goto freeurb;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
@@ -574,8 +579,12 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 			usb_unanchor_urb(urb);
 			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
+			goto freeurb;
 		}
 
+		dev->rxbuf[i] = buf;
+		dev->rxbuf_dma[i] = buf_dma;
+
 freeurb:
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
@@ -663,6 +672,11 @@ static void unlink_all_urbs(struct esd_usb2 *dev)
 	int i, j;
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
+
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+				  dev->rxbuf[i], dev->rxbuf_dma[i]);
+
 	for (i = 0; i < dev->net_count; i++) {
 		priv = dev->nets[i];
 		if (priv) {
-- 
2.30.2


