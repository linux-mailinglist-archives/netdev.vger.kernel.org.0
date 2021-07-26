Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB443D5D01
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhGZOt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhGZOt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:49:57 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB679C061757;
        Mon, 26 Jul 2021 08:30:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bp1so16230573lfb.3;
        Mon, 26 Jul 2021 08:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6QF1tp2oEexOjNTXdUF+9gO2IJD1K9qh4FZF8+8zOk=;
        b=M2ahqcsAPFIMPPM8R3AQtSCIcD8xQ691fWWGwSBZe0clTrURhNfpXwhLzpDfgiHwiT
         AlI/aw7DmFApa7WrksFcwRgsjO7LYLPMyBBTyXfDYGZYj/LBhHbeiCTkG8sUtezRf6fs
         /1l/z5a9DNfCOJ8s8/rufOn+Fcs1A8/F0L3paIgLQPbAKhdHItLKbwbR/fv7xz7LgKWr
         ewvBtV65q+5O53rHaD5Gaww6+wGfCBsVSF2AvMnsiT0lxQUlNQT94AEU8mViX+yrfPvI
         NSnN/zhv6B52sLRRxPOnca3gja7QApIqlGtcinZgrS8zwKaV14eESRy36lyvQ3LwFujo
         hafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6QF1tp2oEexOjNTXdUF+9gO2IJD1K9qh4FZF8+8zOk=;
        b=K1twJY19XpDz3kR/PAXv0pJ9HOqUDm4CnKgcFxoD8AGTprH4E1+S0MIzfAU2eUtlUK
         iSWLah9Tl++9VsSkAtwJ/8Dq6Kb7VYP0aFRI3xvwHOfNhj5ZvSKOdi7NdhoCqSqVu04t
         8h8w51XhL+SFLhI58KmJQ1H57O8Lj1xGr7RrlcyQswJnMWH2YBvzGlbC48TWLxxYuMK0
         v0l6gY4zTEqDqYGdTDvmwtI6WiGLNOU0G7IKUOcLGFhVSmxN6SqJ+2BsF2idosIeWKmz
         crDF3NuLTobI1awB5Y4OeNEjepu6OCNa61gBdjlKtFpfXfJVHhJ4PGcLo5/9DYXgAXb0
         Z2ZQ==
X-Gm-Message-State: AOAM5337q7xcCEyR7vSnJ8B3/g8iVLYAARiduTUDwaSupUuRcIxtseLW
        MVku0J7Rb2q7lP+9yJMQEMM=
X-Google-Smtp-Source: ABdhPJwUEKtnIPwRGnHBP1N66CPbwnE0w6NqQ4CT37se67Ch93WGWuqy3wQmIMbFdCQQhx/8Ir+Q4g==
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr13961981lfu.292.1627313424007;
        Mon, 26 Jul 2021 08:30:24 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id f10sm31408lfk.84.2021.07.26.08.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:30:23 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        socketcan@hartkopp.net, mailhol.vincent@wanadoo.fr,
        b.krumboeck@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 1/3] can: usb_8dev: fix memory leak
Date:   Mon, 26 Jul 2021 18:30:18 +0300
Message-Id: <57ea53a8ba4687fd75045edb89489ca2a8ba4d60.1627311383.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627311383.git.paskripkin@gmail.com>
References: <cover.1627311383.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In usb_8dev_start() MAX_RX_URBS coherent buffers are allocated and there
is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see usb_8dev_start) and this flag cannot be used with
   coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers.
The same patch was applied to mcba_usb driver and it works nice
with real hardware. There is no change in functionality, only clean-up
code for coherent buffers

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/usb_8dev.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index b6e7ef0d5bc6..d1b83bd1b3cb 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -137,7 +137,8 @@ struct usb_8dev_priv {
 	u8 *cmd_msg_buffer;
 
 	struct mutex usb_8dev_cmd_lock;
-
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 /* tx frame */
@@ -733,6 +734,7 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -742,7 +744,7 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
 		}
 
 		buf = usb_alloc_coherent(priv->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -750,6 +752,8 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, priv->udev,
 				  usb_rcvbulkpipe(priv->udev,
 						  USB_8DEV_ENDP_DATA_RX),
@@ -767,6 +771,9 @@ static int usb_8dev_start(struct usb_8dev_priv *priv)
 			break;
 		}
 
+		priv->rxbuf[i] = buf;
+		priv->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -836,6 +843,10 @@ static void unlink_all_urbs(struct usb_8dev_priv *priv)
 
 	usb_kill_anchored_urbs(&priv->rx_submitted);
 
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(priv->udev, RX_BUFFER_SIZE,
+				  priv->rxbuf[i], priv->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	atomic_set(&priv->active_tx_urbs, 0);
 
-- 
2.32.0

