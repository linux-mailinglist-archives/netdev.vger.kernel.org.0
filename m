Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6565F4D742C
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiCMKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiCMKKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:10:16 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27C9443E8;
        Sun, 13 Mar 2022 03:09:08 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 17so15781420lji.1;
        Sun, 13 Mar 2022 03:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fd0VGVh1yj5AN4F8NiTyn+VKl2kfTnNA+6r2LMy4rtY=;
        b=Q50fqIy/o/HSFEQB5SKpFP3x4adW3J8lLWJ/ftdb3OuIgBDbeWvigPGTbFz3DExMJO
         h9zmb24kJtdOViOF8nZEQhwx5DM1XM2BS6OltJOwZcpXFAdcDEb36xOXasS0Btt79eed
         yVsX4z39dmRaIv2og0jEAQwSOyL4zua5g+o2c7qqEG0vgVEwMsxo9fX+PXBPuNEWPlpd
         ddQh1Ak+pBP74OAuo036ryfZPEF0nw6M86KERD7nrY9vPft3pKaPM5uyrRSvwMFMsEkR
         biCcuqknzPDBPGjUGJPD6HNB7m4Sluer2JrS3VZuJw5iPyfzbJ2AwRahGP2vzQLvvJfF
         EkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fd0VGVh1yj5AN4F8NiTyn+VKl2kfTnNA+6r2LMy4rtY=;
        b=INA9OvC0BfXmdJ8GriO7TVGjc16lMJEvQPQI5U/aOKrDenoq14ycHFcjUfd+BdCepg
         2QihR6HnyRME4qCqKKdzq1M8ayoW4VMz3430ZLs9SAbCfvGEfApKtJbxvuErpjV6OdKS
         +WUz5eEaUu+NQWFLgoJhesylddaQazKhFm0JzhEOJnt1IiifPlskxrX8wh1WW7iHwL2g
         ZcAkqn7AVvwMBAd0p5pICnHkh9eIY0+FdG+fMdG0OS32GPpHaTPX+8n2+cBL7d61nvTF
         Y67Qb0sIwkN0kMrrOOLuwSZgiCvvl1HXeHY+XZOQH1bjbCxHLTablUlWwFsSBwl43bJS
         0VSw==
X-Gm-Message-State: AOAM532Mq8TSDbhpRAYHEP2BSKkvY0JeaNLYzHYtxTi/jLkydNa/XQxn
        Ojovddvv5yEEwh28CYknF1YtE9pgHlk=
X-Google-Smtp-Source: ABdhPJxvwB0tDQr74ngpANQQzKF2dw9A46j1dvm0JWEOUX7dw2TM2vKgmIGceYbAUxOSa+GjADWReA==
X-Received: by 2002:a2e:1618:0:b0:247:eb53:6d5b with SMTP id w24-20020a2e1618000000b00247eb536d5bmr11062348ljd.312.1647166146549;
        Sun, 13 Mar 2022 03:09:06 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id u17-20020a056512095100b0044381f00805sm2646118lft.139.2022.03.13.03.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 03:09:06 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Subject: [PATCH v3] can: mcba_usb: properly check endpoint type
Date:   Sun, 13 Mar 2022 13:09:03 +0300
Message-Id: <20220313100903.10868-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAMZ6RqKn4E9wstZF1xbefBaR3AbcORq60KXvxUTCSH8dZ+Cxag@mail.gmail.com>
References: <CAMZ6RqKn4E9wstZF1xbefBaR3AbcORq60KXvxUTCSH8dZ+Cxag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported warning in usb_submit_urb() which is caused by wrong
endpoint type. We should check that in endpoint is actually present to
prevent this warning

Found pipes are now saved to struct mcba_priv and code uses them directly
instead of making pipes in place.

Fail log:

usb 5-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 1 PID: 49 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 1 PID: 49 Comm: kworker/1:2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
...
Call Trace:
 <TASK>
 mcba_usb_start drivers/net/can/usb/mcba_usb.c:662 [inline]
 mcba_usb_probe+0x8a3/0xc50 drivers/net/can/usb/mcba_usb.c:858
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:517 [inline]

Reported-and-tested-by: syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

Changes from v2:
	- Coding style error fixed

Changes from RFT(RFC):
	- Add missing out pipe check
	- Use found pipes instead of making pipes in place
	- Do not hide usb_find_common_endpoints() error

---
 drivers/net/can/usb/mcba_usb.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 77bddff86252..56770a5a782a 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -33,10 +33,6 @@
 #define MCBA_USB_RX_BUFF_SIZE 64
 #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
 
-/* MCBA endpoint numbers */
-#define MCBA_USB_EP_IN 1
-#define MCBA_USB_EP_OUT 1
-
 /* Microchip command id */
 #define MBCA_CMD_RECEIVE_MESSAGE 0xE3
 #define MBCA_CMD_I_AM_ALIVE_FROM_CAN 0xF5
@@ -83,6 +79,8 @@ struct mcba_priv {
 	atomic_t free_ctx_cnt;
 	void *rxbuf[MCBA_MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
+	int rx_pipe;
+	int tx_pipe;
 };
 
 /* CAN frame */
@@ -268,10 +266,8 @@ static netdev_tx_t mcba_usb_xmit(struct mcba_priv *priv,
 
 	memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
 
-	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
-			  MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
-			  ctx);
+	usb_fill_bulk_urb(urb, priv->udev, priv->tx_pipe, buf, MCBA_USB_TX_BUFF_SIZE,
+			  mcba_usb_write_bulk_callback, ctx);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &priv->tx_submitted);
@@ -608,7 +604,7 @@ static void mcba_usb_read_bulk_callback(struct urb *urb)
 resubmit_urb:
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
+			  priv->rx_pipe,
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
@@ -653,7 +649,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		urb->transfer_dma = buf_dma;
 
 		usb_fill_bulk_urb(urb, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
+				  priv->rx_pipe,
 				  buf, MCBA_USB_RX_BUFF_SIZE,
 				  mcba_usb_read_bulk_callback, priv);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -807,6 +803,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
 	struct mcba_priv *priv;
 	int err;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *in, *out;
+
+	err = usb_find_common_endpoints(intf->cur_altsetting, &in, &out, NULL, NULL);
+	if (err) {
+		dev_err(&intf->dev, "Can't find endpoints\n");
+		return err;
+	}
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
 	if (!netdev) {
@@ -852,6 +855,9 @@ static int mcba_usb_probe(struct usb_interface *intf,
 		goto cleanup_free_candev;
 	}
 
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
+
 	devm_can_led_init(netdev);
 
 	/* Start USB dev only if we have successfully registered CAN device */
-- 
2.35.1

