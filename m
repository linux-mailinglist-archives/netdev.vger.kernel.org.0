Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99045E7A5E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiIWMSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiIWMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7CD13E7C7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUV-0007Mr-HG
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BB622EB164
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 99C3FEB149;
        Fri, 23 Sep 2022 12:09:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fa20be1e;
        Fri, 23 Sep 2022 12:09:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Rhett Aultman <rhett.aultman@samsara.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/11] can: gs_usb: remove dma allocations
Date:   Fri, 23 Sep 2022 14:08:58 +0200
Message-Id: <20220923120859.740577-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220923120859.740577-1-mkl@pengutronix.de>
References: <20220923120859.740577-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>

DMA allocated buffers are a precious resource. If there is no need for
DMA allocations, then it might be worth to use non-dma allocated
buffers.

After testing the gs_usb driver with and without DMA allocation, there
does not seem to be a significant change in latency or CPU utilization
either way. Therefore, DMA allocation is not necessary and removed.

Internal buffers used within urbs were managed and freed manually.
These buffers are no longer needed to be managed by the driver. The
URB_FREE_BUFFER flag, allows for the buffers in question to be
automatically freed.

Co-developed-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>
Link: https://lore.kernel.org/all/20220920154724.861093-2-rhett.aultman@samsara.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 39 ++++++------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index fbe9db46a41a..f0065d40eb24 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -314,8 +314,6 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
-	void *rxbuf[GS_MAX_RX_URBS];
-	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -710,9 +708,6 @@ static void gs_usb_xmit_callback(struct urb *urb)
 
 	if (urb->status)
 		netdev_info(netdev, "usb xmit fail %u\n", txc->echo_id);
-
-	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
-			  urb->transfer_buffer, urb->transfer_dma);
 }
 
 static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
@@ -741,8 +736,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	if (!urb)
 		goto nomem_urb;
 
-	hf = usb_alloc_coherent(dev->udev, dev->hf_size_tx, GFP_ATOMIC,
-				&urb->transfer_dma);
+	hf = kmalloc(dev->hf_size_tx, GFP_ATOMIC);
 	if (!hf) {
 		netdev_err(netdev, "No memory left for USB buffer\n");
 		goto nomem_hf;
@@ -786,7 +780,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 			  hf, dev->hf_size_tx,
 			  gs_usb_xmit_callback, txc);
 
-	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	urb->transfer_flags |= URB_FREE_BUFFER;
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
 	can_put_echo_skb(skb, netdev, idx, 0);
@@ -801,8 +795,6 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 		gs_free_tx_context(txc);
 
 		usb_unanchor_urb(urb);
-		usb_free_coherent(dev->udev, urb->transfer_buffer_length,
-				  urb->transfer_buffer, urb->transfer_dma);
 
 		if (rc == -ENODEV) {
 			netif_device_detach(netdev);
@@ -822,8 +814,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
  badidx:
-	usb_free_coherent(dev->udev, urb->transfer_buffer_length,
-			  urb->transfer_buffer, urb->transfer_dma);
+	kfree(hf);
  nomem_hf:
 	usb_free_urb(urb);
 
@@ -869,7 +860,6 @@ static int gs_can_open(struct net_device *netdev)
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
-			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -877,10 +867,8 @@ static int gs_can_open(struct net_device *netdev)
 				return -ENOMEM;
 
 			/* alloc rx buffer */
-			buf = usb_alloc_coherent(dev->udev,
-						 dev->parent->hf_size_rx,
-						 GFP_KERNEL,
-						 &buf_dma);
+			buf = kmalloc(dev->parent->hf_size_rx,
+				      GFP_KERNEL);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -888,8 +876,6 @@ static int gs_can_open(struct net_device *netdev)
 				return -ENOMEM;
 			}
 
-			urb->transfer_dma = buf_dma;
-
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -898,7 +884,7 @@ static int gs_can_open(struct net_device *netdev)
 					  buf,
 					  dev->parent->hf_size_rx,
 					  gs_usb_receive_bulk_callback, parent);
-			urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+			urb->transfer_flags |= URB_FREE_BUFFER;
 
 			usb_anchor_urb(urb, &parent->rx_submitted);
 
@@ -911,17 +897,10 @@ static int gs_can_open(struct net_device *netdev)
 					   "usb_submit failed (err=%d)\n", rc);
 
 				usb_unanchor_urb(urb);
-				usb_free_coherent(dev->udev,
-						  sizeof(struct gs_host_frame),
-						  buf,
-						  buf_dma);
 				usb_free_urb(urb);
 				break;
 			}
 
-			dev->rxbuf[i] = buf;
-			dev->rxbuf_dma[i] = buf_dma;
-
 			/* Drop reference,
 			 * USB core will take care of freeing it
 			 */
@@ -980,7 +959,6 @@ static int gs_can_close(struct net_device *netdev)
 	int rc;
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
-	unsigned int i;
 
 	netif_stop_queue(netdev);
 
@@ -992,11 +970,6 @@ static int gs_can_close(struct net_device *netdev)
 	parent->active_channels--;
 	if (!parent->active_channels) {
 		usb_kill_anchored_urbs(&parent->rx_submitted);
-		for (i = 0; i < GS_MAX_RX_URBS; i++)
-			usb_free_coherent(dev->udev,
-					  sizeof(struct gs_host_frame),
-					  dev->rxbuf[i],
-					  dev->rxbuf_dma[i]);
 	}
 
 	/* Stop sending URBs */
-- 
2.35.1


