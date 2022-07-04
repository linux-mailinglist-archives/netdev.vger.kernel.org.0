Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B5D565612
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiGDMw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbiGDMwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89E10FD1
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LYx-00015K-KS
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 62ED6A7992
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C7839A7929;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6cad4fc0;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Rhett Aultman <rhett.aultman@samsara.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 04/15] can: gs_usb: gs_usb_open/close(): fix memory leak
Date:   Mon,  4 Jul 2022 14:26:02 +0200
Message-Id: <20220704122613.1551119-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rhett Aultman <rhett.aultman@samsara.com>

The gs_usb driver appears to suffer from a malady common to many USB
CAN adapter drivers in that it performs usb_alloc_coherent() to
allocate a number of USB request blocks (URBs) for RX, and then later
relies on usb_kill_anchored_urbs() to free them, but this doesn't
actually free them. As a result, this may be leaking DMA memory that's
been used by the driver.

This commit is an adaptation of the techniques found in the esd_usb2
driver where a similar design pattern led to a memory leak. It
explicitly frees the RX URBs and their DMA memory via a call to
usb_free_coherent(). Since the RX URBs were allocated in the
gs_can_open(), we remove them in gs_can_close() rather than in the
disconnect function as was done in esd_usb2.

For more information, see the 928150fad41b ("can: esd_usb2: fix memory
leak").

Link: https://lore.kernel.org/all/alpine.DEB.2.22.394.2206031547001.1630869@thelappy
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Signed-off-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index b29ba9138866..d3a658b444b5 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -268,6 +268,8 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
+	void *rxbuf[GS_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -742,6 +744,7 @@ static int gs_can_open(struct net_device *netdev)
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
+			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -752,7 +755,7 @@ static int gs_can_open(struct net_device *netdev)
 			buf = usb_alloc_coherent(dev->udev,
 						 dev->parent->hf_size_rx,
 						 GFP_KERNEL,
-						 &urb->transfer_dma);
+						 &buf_dma);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -760,6 +763,8 @@ static int gs_can_open(struct net_device *netdev)
 				return -ENOMEM;
 			}
 
+			urb->transfer_dma = buf_dma;
+
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -781,10 +786,17 @@ static int gs_can_open(struct net_device *netdev)
 					   "usb_submit failed (err=%d)\n", rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_coherent(dev->udev,
+						  sizeof(struct gs_host_frame),
+						  buf,
+						  buf_dma);
 				usb_free_urb(urb);
 				break;
 			}
 
+			dev->rxbuf[i] = buf;
+			dev->rxbuf_dma[i] = buf_dma;
+
 			/* Drop reference,
 			 * USB core will take care of freeing it
 			 */
@@ -842,13 +854,20 @@ static int gs_can_close(struct net_device *netdev)
 	int rc;
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
+	unsigned int i;
 
 	netif_stop_queue(netdev);
 
 	/* Stop polling */
 	parent->active_channels--;
-	if (!parent->active_channels)
+	if (!parent->active_channels) {
 		usb_kill_anchored_urbs(&parent->rx_submitted);
+		for (i = 0; i < GS_MAX_RX_URBS; i++)
+			usb_free_coherent(dev->udev,
+					  sizeof(struct gs_host_frame),
+					  dev->rxbuf[i],
+					  dev->rxbuf_dma[i]);
+	}
 
 	/* Stop sending URBs */
 	usb_kill_anchored_urbs(&dev->tx_submitted);
-- 
2.35.1


