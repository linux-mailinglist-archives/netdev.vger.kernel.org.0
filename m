Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51A33D7B81
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhG0RAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG0RAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:00:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AA9C061757;
        Tue, 27 Jul 2021 10:00:07 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f18so22833233lfu.10;
        Tue, 27 Jul 2021 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6QF1tp2oEexOjNTXdUF+9gO2IJD1K9qh4FZF8+8zOk=;
        b=LnAFTJSZxgZ6CkbIhBYWJcq7DZWBPIYCiJ3JjUgJufHLT0UMZfK9UhEw8f6gHra2gh
         o2KWX8Nd65nRW4jEA2QxjLLp4CqlPMGffXvTs4HBPeBYUNUbvuDw7yWSEzxreAAvrOqY
         78di+SvO6Nnwb6pKTcpvpuMB3KejaZLBXPOY2scMLiebPrYmkuhAMuxEwqWpdelytI1R
         xhDqqzbY2qN2boHkx2aPN/1tqrs8dvmxdwQPo8v5YHkcXk95H4InYBNGFCyU/NVLZSp5
         /dmuG0K77ds3gzqIy/3bZLfW/1h07nP9lp+dB9o2ijSWNGmM9r1ZcA5o8Y7vnby/nrZV
         tVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6QF1tp2oEexOjNTXdUF+9gO2IJD1K9qh4FZF8+8zOk=;
        b=bjWJQhfFm/31PWsij1vTivOWdKesYGib501yNgvibOcAZaS+/Rb9HLU+bZZAzqRgzw
         VGcEonPOZqHwK86EII1xkmU4u8LvUDYTN7GlwO5Ody294p261aYBKROM7hFNXNMWXHLC
         hn9mviPZPjILN3zYtVz0/Up/6acSxbwYzhMDBw7BrFI0HwamOaKbt5EoPl9ECGjWqF5I
         vU5tn6dzFN89XTSgkT/okpHfYjmKCfscBnwstrIjt8bO3AlRFA9gyMty+3uRRTes9y/H
         No9lmpJTUswy+YzI4Wn5kjP3h23q/HGiPA4RXByqhD1Y4gmADYUs37r7s2xGZTDvizr2
         DfOg==
X-Gm-Message-State: AOAM532pqakgKnLX8xt3vDGvxjfGwjHdgpXN7AbNbT07rkNLeDj0K5Wi
        5TjFGNJygH+ExnCMiLi9x04=
X-Google-Smtp-Source: ABdhPJwMSlhTafv0V0AAiRft7/oOQ7TQGi7do9NszuwPhKzU1VHmd8MciOx/9v+pyPW5z4MWIX5gLQ==
X-Received: by 2002:a05:6512:714:: with SMTP id b20mr16909046lfs.488.1627405206120;
        Tue, 27 Jul 2021 10:00:06 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id d17sm341950lfl.174.2021.07.27.10.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:00:05 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, b.krumboeck@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 1/3] can: usb_8dev: fix memory leak
Date:   Tue, 27 Jul 2021 19:59:57 +0300
Message-Id: <d39b458cd425a1cf7f512f340224e6e9563b07bd.1627404470.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627404470.git.paskripkin@gmail.com>
References: <cover.1627404470.git.paskripkin@gmail.com>
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

