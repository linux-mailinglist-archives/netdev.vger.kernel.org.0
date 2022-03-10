Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797CD4D4A8A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbiCJOco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344013AbiCJObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5703FEB306
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJn8-0006Fn-Iw
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:22 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D5CF047E0D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1A80047DF8;
        Thu, 10 Mar 2022 14:29:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 55593c6e;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peter Fink <pfink@christ-es.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/29] can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame
Date:   Thu, 10 Mar 2022 15:28:56 +0100
Message-Id: <20220310142903.341658-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Fink <pfink@christ-es.de>

Modify struct gs_host_frame to make use of a union and
DECLARE_FLEX_ARRAY to be able to store different data (lengths), which
will be added in later commits.

Store the gs_host_frame length in TX direction (host -> device) in
struct gs_can::hf_size_tx and RX direction (device -> host) in struct
gs_usb::hf_size_rx so it must be calculated only once.

Link: https://lore.kernel.org/all/20220309124132.291861-15-mkl@pengutronix.de
Signed-off-by: Peter Fink <pfink@christ-es.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 37 +++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 4bc10264005b..1fe9d9f08c17 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -146,6 +146,10 @@ struct gs_device_bt_const {
 
 #define GS_CAN_FLAG_OVERFLOW BIT(0)
 
+struct classic_can {
+	u8 data[8];
+} __packed;
+
 struct gs_host_frame {
 	u32 echo_id;
 	__le32 can_id;
@@ -155,7 +159,9 @@ struct gs_host_frame {
 	u8 flags;
 	u8 reserved;
 
-	u8 data[8];
+	union {
+		DECLARE_FLEX_ARRAY(struct classic_can, classic_can);
+	};
 } __packed;
 /* The GS USB devices make use of the same flags and masks as in
  * linux/can.h and linux/can/error.h, and no additional mapping is necessary.
@@ -187,6 +193,8 @@ struct gs_can {
 	struct can_bittiming_const bt_const;
 	unsigned int channel;	/* channel number */
 
+	unsigned int hf_size_tx;
+
 	/* This lock prevents a race condition between xmit and receive. */
 	spinlock_t tx_ctx_lock;
 	struct gs_tx_context tx_context[GS_MAX_TX_URBS];
@@ -200,6 +208,7 @@ struct gs_usb {
 	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
 	struct usb_device *udev;
+	unsigned int hf_size_rx;
 	u8 active_channels;
 };
 
@@ -343,7 +352,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		cf->can_id = le32_to_cpu(hf->can_id);
 
 		can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);
-		memcpy(cf->data, hf->data, 8);
+		memcpy(cf->data, hf->classic_can->data, 8);
 
 		/* ERROR frames tell us information about the controller */
 		if (le32_to_cpu(hf->can_id) & CAN_ERR_FLAG)
@@ -398,7 +407,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
  resubmit_urb:
 	usb_fill_bulk_urb(urb, usbcan->udev,
 			  usb_rcvbulkpipe(usbcan->udev, GSUSB_ENDPOINT_IN),
-			  hf, sizeof(struct gs_host_frame),
+			  hf, dev->parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, usbcan);
 
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
@@ -485,7 +494,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	if (!urb)
 		goto nomem_urb;
 
-	hf = usb_alloc_coherent(dev->udev, sizeof(*hf), GFP_ATOMIC,
+	hf = usb_alloc_coherent(dev->udev, dev->hf_size_tx, GFP_ATOMIC,
 				&urb->transfer_dma);
 	if (!hf) {
 		netdev_err(netdev, "No memory left for USB buffer\n");
@@ -509,11 +518,11 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	hf->can_id = cpu_to_le32(cf->can_id);
 	hf->can_dlc = can_get_cc_dlc(cf, dev->can.ctrlmode);
 
-	memcpy(hf->data, cf->data, cf->len);
+	memcpy(hf->classic_can->data, cf->data, cf->len);
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
-			  hf, sizeof(*hf),
+			  hf, dev->hf_size_tx,
 			  gs_usb_xmit_callback, txc);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -531,8 +540,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 		gs_free_tx_context(txc);
 
 		usb_unanchor_urb(urb);
-		usb_free_coherent(dev->udev,
-				  sizeof(*hf), hf, urb->transfer_dma);
+		usb_free_coherent(dev->udev, urb->transfer_buffer_length,
+				  urb->transfer_buffer, urb->transfer_dma);
 
 		if (rc == -ENODEV) {
 			netif_device_detach(netdev);
@@ -552,7 +561,8 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
  badidx:
-	usb_free_coherent(dev->udev, sizeof(*hf), hf, urb->transfer_dma);
+	usb_free_coherent(dev->udev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
  nomem_hf:
 	usb_free_urb(urb);
 
@@ -569,6 +579,7 @@ static int gs_can_open(struct net_device *netdev)
 	struct gs_usb *parent = dev->parent;
 	int rc, i;
 	struct gs_device_mode *dm;
+	struct gs_host_frame *hf;
 	u32 ctrlmode;
 	u32 flags = 0;
 
@@ -576,6 +587,8 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc)
 		return rc;
 
+	dev->hf_size_tx = struct_size(hf, classic_can, 1);
+
 	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
@@ -588,7 +601,7 @@ static int gs_can_open(struct net_device *netdev)
 
 			/* alloc rx buffer */
 			buf = usb_alloc_coherent(dev->udev,
-						 sizeof(struct gs_host_frame),
+						 dev->parent->hf_size_rx,
 						 GFP_KERNEL,
 						 &urb->transfer_dma);
 			if (!buf) {
@@ -604,7 +617,7 @@ static int gs_can_open(struct net_device *netdev)
 					  usb_rcvbulkpipe(dev->udev,
 							  GSUSB_ENDPOINT_IN),
 					  buf,
-					  sizeof(struct gs_host_frame),
+					  dev->parent->hf_size_rx,
 					  gs_usb_receive_bulk_callback, parent);
 			urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -886,6 +899,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
+	struct gs_host_frame *hf;
 	struct gs_usb *dev;
 	int rc = -ENOMEM;
 	unsigned int icount, i;
@@ -947,6 +961,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	}
 
 	init_usb_anchor(&dev->rx_submitted);
+	dev->hf_size_rx = struct_size(hf, classic_can, 1);
 
 	usb_set_intfdata(intf, dev);
 	dev->udev = udev;
-- 
2.35.1


