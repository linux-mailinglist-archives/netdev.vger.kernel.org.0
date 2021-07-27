Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A72E3D7B86
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhG0RAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhG0RAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:00:38 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A42AC061757;
        Tue, 27 Jul 2021 10:00:37 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id f12so16818429ljn.1;
        Tue, 27 Jul 2021 10:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iea5qO2fdy0HoiQckUUb63itdyCRWHqDzn/tBtz3LPI=;
        b=ikx+EkaxmQPKic+ZYbqVI31C19KJGwcKqcci1GiDPmra0M5dhUicEVZaaUPM07IwxY
         MMHY0To6iHgGpj0xRhW3f4UjTw49a8f1civ/IAw10d0v5haHkOs/9dDMG6sFkRqqivku
         0XJ68+pTppyzTqfzt0VPYM87QWFKzQmYX/pYYCftuG+3gvpxVg2Auzx4MEMIXZTvcjIJ
         NwxPr2iE9VJ3jOBWt+x86xXoxfG9/j3uZiKlrpdvLbSGQa4UIA4CutIhGvzIRqmezf4/
         g251BKhV0+g5+ISrvcDDHdYOgeGyZXVPDkWthemwPhlUfmAyMRhvFeuETSq42HPxd4eV
         9UwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iea5qO2fdy0HoiQckUUb63itdyCRWHqDzn/tBtz3LPI=;
        b=auodyEq6ZZ1+dnVCHAhuQUPMjL8TY9GH3hh9WS4VghOl9JgM22i0VHR9jUQUDkYrLV
         R5ko+biYxr8D9sSgrmCtAwKG8K3latzgkHga7U7zcSsQK5xdpGt/+oAH+mB4pRBBJjS1
         jDme55ZVVTrU+H3mclfZIFpWGKK/ZV4DfwMqJRDB6zy8Pvu8HI/Byv40J3M4eLXPDlTv
         oSj3RBs1o1cZ1F6YSUKdaS6YPmNfMkvCYHUOoYE75GAbZdUJzB+6cLvVZMSj/1wdnifZ
         tzheCAZMhVfV/gM+Ruo/4wlaB+B6s9k3gTxTXrOL8f6EKjlG9VXI+feBy/gYkwfPXQuJ
         RbUg==
X-Gm-Message-State: AOAM531eeNq1xTv1xtftRIefzKZSxnKOfnXgFUOZQmkapZj0Qet8OXXl
        VyrUVDaDk8PiZgy3dU02A28=
X-Google-Smtp-Source: ABdhPJwr0xpBUdfhotYvfAxDVuJ/+K0+BbI59nJA5HRweEhXPXvNtAICp2RMVOy9yFAqbkuWyRzGoQ==
X-Received: by 2002:a05:651c:110:: with SMTP id a16mr15390468ljb.241.1627405235915;
        Tue, 27 Jul 2021 10:00:35 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id t24sm323896ljj.97.2021.07.27.10.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:00:35 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, haas@ems-wuensche.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 2/3] can: ems_usb: fix memory leak
Date:   Tue, 27 Jul 2021 20:00:33 +0300
Message-Id: <59aa9fbc9a8cbf9af2bbd2f61a659c480b415800.1627404470.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627404470.git.paskripkin@gmail.com>
References: <cover.1627404470.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ems_usb_start() MAX_RX_URBS coherent buffers are allocated and there
is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see ems_usb_start) and this flag cannot be used with
   coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers.
The same patch was applied to mcba_usb driver and it works nice
with real hardware. There is no change in functionality, only clean-up
code for coherent buffers

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/ems_usb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 0a37af4a3fa4..2b5302e72435 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -255,6 +255,8 @@ struct ems_usb {
 	unsigned int free_slots; /* remember number of available slots */
 
 	struct ems_cpc_msg active_params; /* active controller parameters */
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 static void ems_usb_read_interrupt_callback(struct urb *urb)
@@ -587,6 +589,7 @@ static int ems_usb_start(struct ems_usb *dev)
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -596,7 +599,7 @@ static int ems_usb_start(struct ems_usb *dev)
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -604,6 +607,8 @@ static int ems_usb_start(struct ems_usb *dev)
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 2),
 				  buf, RX_BUFFER_SIZE,
 				  ems_usb_read_bulk_callback, dev);
@@ -619,6 +624,9 @@ static int ems_usb_start(struct ems_usb *dev)
 			break;
 		}
 
+		dev->rxbuf[i] = buf;
+		dev->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -684,6 +692,10 @@ static void unlink_all_urbs(struct ems_usb *dev)
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+				  dev->rxbuf[i], dev->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&dev->tx_submitted);
 	atomic_set(&dev->active_tx_urbs, 0);
 
-- 
2.32.0

