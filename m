Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5632E4D11EA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344912AbiCHIRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344558AbiCHIRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:17:18 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71D03ED04;
        Tue,  8 Mar 2022 00:16:22 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id r22so8402015ljd.4;
        Tue, 08 Mar 2022 00:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ld28ux2ZpyPXul2JbF1rF3MAatMoHvHkJTziLOlu7ew=;
        b=DcUXTZhRvbq4y/+nQ3/Xo/aqkr3jvDQWmjfvRZlFw8ljfnHn1YAaqH28pec1NkG8Ig
         JxE8c4FIC4HZjM8ucHP/PgIUzxmoVf115c25PmbbbSJZzlnGrW4AKQ0wk6L+2koS/6MD
         4iiCllhgMAn2iXIBXQ6PJ73GXn4ytXzw4UDOdeS0twOWilp1DFDwQnuSh48P3NS7feig
         /WE2Mqno8yji6A3XoFGAIXsknTomYKUTWUF76v95VMvrnyurHZzi2OgWG2M5X8wwWDGu
         eWwz+8XT2VBKWWYj1I2Ea5jZnG10PMfGQVd9cNhu9sAB0s+jmEcMOeT3x1j13OPZQVVa
         H45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ld28ux2ZpyPXul2JbF1rF3MAatMoHvHkJTziLOlu7ew=;
        b=R445zQHxo5ofyNETZvn9BLSzHkvx/IoA22U3nlakRW8CuznHwg8hduNVfMYTifOTmA
         e1iG8A7+OQoRm41oMWodM7EtFIKkb4RQ1PHGxuDWvzVPUh0cFVsQWZqBlsArX5gpt/Cq
         u2atGgyfowBQjvg5e5I0wndKTw+FNxH1Qa7Dn2RkGqzJnMl6drK7C/I3sAOKPael0hER
         +cOuNHfi/c0jnCCKZLyiEYBXb1A/pIJw+rmu37c0kHJCpPUbxvFrQqY0sPpxMyeg/9ik
         nAZjjnwkWOsURuB6xgv6bNB6aDRng+gcwEqq7bEMaZ5ztx5VkVLNVtB09sLo/TtK5BfK
         EB9Q==
X-Gm-Message-State: AOAM532bESwoXLH+quvlGmYL6sFJliqSb6zE6uB3pkpssV83MhJv6UNF
        O5wPuKXh3b9c/m1Wcw6BhKo=
X-Google-Smtp-Source: ABdhPJzPnmr2bo5NasP3Fja7nDt5zKsTE2PjSo/TdkduO9na5Ke0ocy7z2ndaqyr/CmuSHVfY0O1iQ==
X-Received: by 2002:a05:651c:1030:b0:247:e127:5e01 with SMTP id w16-20020a05651c103000b00247e1275e01mr7481798ljm.87.1646727380424;
        Tue, 08 Mar 2022 00:16:20 -0800 (PST)
Received: from localhost.localdomain ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id q21-20020a0565123a9500b00443c55e9f22sm3329851lfu.264.2022.03.08.00.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:16:20 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Subject: [PATCH v2] can: mcba_usb: properly check endpoint type
Date:   Tue,  8 Mar 2022 11:16:08 +0300
Message-Id: <20220308081608.3243-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
References: <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
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
---

Changes from RFT(RFC):
	- Add missing out pipe check
	- Use found pipes instead of making pipes in place
	- Do not hide usb_find_common_endpoints() error

---
 drivers/net/can/usb/mcba_usb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 77bddff86252..91e79a2d5ae5 100644
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
@@ -269,7 +267,7 @@ static netdev_tx_t mcba_usb_xmit(struct mcba_priv *priv,
 	memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
+			  priv->tx_pipe, buf,
 			  MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
 			  ctx);
 
@@ -608,7 +606,7 @@ static void mcba_usb_read_bulk_callback(struct urb *urb)
 resubmit_urb:
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
+			  priv->rx_pipe,
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
@@ -653,7 +651,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		urb->transfer_dma = buf_dma;
 
 		usb_fill_bulk_urb(urb, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
+				  priv->rx_pipe,
 				  buf, MCBA_USB_RX_BUFF_SIZE,
 				  mcba_usb_read_bulk_callback, priv);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -807,6 +805,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
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
@@ -852,6 +857,9 @@ static int mcba_usb_probe(struct usb_interface *intf,
 		goto cleanup_free_candev;
 	}
 
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
+
 	devm_can_led_init(netdev);
 
 	/* Start USB dev only if we have successfully registered CAN device */
-- 
2.35.1

