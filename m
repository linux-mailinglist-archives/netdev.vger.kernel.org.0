Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3FA3D5D07
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhGZOui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhGZOuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:50:37 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF15BC061764;
        Mon, 26 Jul 2021 08:31:05 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l4so11769082ljq.4;
        Mon, 26 Jul 2021 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/A0BOjIm3z4R6uvHm/L/KPzVr+aE6zy1njqB67lKvI=;
        b=matyVmWB9x6rQG2ibSGAIqTE9ZYLQxC9cofwJ/WSe5eMlOYJwApNSHUmN7ob/QmYzZ
         Zf4L+DLxYLSi9IP1/fTFN4Fvq9Dj3oA+q0TtLk/nLV0AvbVnB+mAGIy+OHxU54Slrx+5
         4ZYOazlPl8hjBfZssrtpKqBcCapV1xll7BQc1wop35z2WespNpYdz9TluRWJJjWzotWa
         NGIj6PaQmywdRyZjC+FlH/VG49fqnXPxXBbRCqH01kHT06NBAA/wjodIybcv8agXZ1ZM
         O0y9Nk6YQFO7ZlALrVxDcq5jw/mpNKc0h+VJCrVEMf6uPp4Piex61RFZDLuNp9x/EZGI
         6T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/A0BOjIm3z4R6uvHm/L/KPzVr+aE6zy1njqB67lKvI=;
        b=RzY4rOqShocaHMvYtEVKBgL7k+B6EgODFGYHQetzfBnT3FxXXn6fNNDCSl3cP1TCGn
         S+n6ygPrt9LP2myW6ehVBFlmiWVWdCMBgsBPQ4yLscuC4KPfYDrQsw4lgSYlS69xohRP
         8i9tJbZpIOdmgaNi+Vii4AhLx98MqS0KAc4o3jKGPm3kxCPwkVKHjS5/joJd9iDc6Zcd
         mv/EaIzta3AHXuGOxhRCyI8Bvc0jFfqdM4MbOIUFliAYAMwt/GTkBpgWf51hhZeIiL9R
         GrdeD8S3Ew0oO3o2FAbMOH+gK+67KXTdYupLjzGvl454DYxkytfG7JIoXHwQZ1ngYKhC
         PXHg==
X-Gm-Message-State: AOAM5326vR7PTbyHVnbswpTvF7I65qJEbICIcZCm80pqsRB6WMqlmBf6
        Orn5ZizhakEoNhtcGYBY93c=
X-Google-Smtp-Source: ABdhPJwda2EQ55vKJ2lD86vBnBC1lEUgq1+UiH+MLlPORmQWoyKNNldrmwI2osCgdCO8uvMd8rCIGQ==
X-Received: by 2002:a2e:a90b:: with SMTP id j11mr12663613ljq.338.1627313464111;
        Mon, 26 Jul 2021 08:31:04 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id m11sm2623lji.8.2021.07.26.08.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:31:03 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        socketcan@hartkopp.net, mailhol.vincent@wanadoo.fr,
        Stefan.Maetje@esd.eu, matthias.fuchs@esd.eu
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 3/3] can: esd_usb2: fix memory leak
Date:   Mon, 26 Jul 2021 18:31:01 +0300
Message-Id: <a6ccf6adbcfeaad8c4ed24e94c50b2dd3db57c15.1627311383.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627311383.git.paskripkin@gmail.com>
References: <cover.1627311383.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In esd_usb2_setup_rx_urbs() MAX_RX_URBS coherent buffers are
allocated and there is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see esd_usb2_setup_rx_urbs) and this flag cannot be used
   with coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers.
The same patch was applied to mcba_usb driver and it works nice
with real hardware. There is no change in functionality, only clean-up
code for coherent buffers

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 65b58f8fc328..303560abe2b0 100644
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
+			goto freeusrb;
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
2.32.0

