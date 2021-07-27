Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45243D7B89
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhG0RAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhG0RAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:00:53 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E73BC061757;
        Tue, 27 Jul 2021 10:00:52 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a7so16798229ljq.11;
        Tue, 27 Jul 2021 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/XSno7xDkhJl7h1dC9M9HNfKcC/pY9lVoxnVJ+wRmsQ=;
        b=oXCOkiHc3nI+0iNZigrxDC9pKWA3g/2bnqUhd7BQr0su28RVzShszZHa4B0ZxJV0zE
         b2QP+paUcAvqob/SRuAN7af+Usp2AknEC176kAN6H5x8DL8rMNUaXDGj56rxI2C94yeN
         /g94PaeCK4U3KqcBuLDysRk1vIzktrnwQFp7D5lYjQn58hAPTGNsA59Tc6iZtinaaRlU
         SnYXH3iHQedc6FMteKlhKO5G+RAWnhnLuSeHfHMCfiMIOf4I1/zIYldMU3TB5CRhWLbd
         GqylGIoWbqKLrV092MHZPXUUv+6Igav0so73yDwAeee89ITL1u++EVySs3jdWncsVUaH
         C99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/XSno7xDkhJl7h1dC9M9HNfKcC/pY9lVoxnVJ+wRmsQ=;
        b=Sh8uCSIRTzOfyUSB7RCZZK0Z3wHLq7Ur4tPjHkO2QIyDrc3a5PJhK0UDpRLjN+d9ZN
         DXIPhZdhsFyNltKGZmRMWGDmX7dy+7etygizIhutdM8JDvb54kcCEcKFE7MZ+V0FW/H+
         9bkaSurC9X5+6Pr5IaBV4/oPAZxXVUQRP1ZVuYwWGW9k0A0iYCsE7suioNVxmUuyodvy
         FT/ZtofleLzfIyXRp1SrLWz4X+rD8dhIHtAoNwGUVVfrysIhOxj4d454zotJKYIBs6rK
         UkFswUVXXt5cw6hlF5JgSKdMvCJMm+8f9zxzx1b0jJr3lkCtvuC/lURq36eY+TpqiyGa
         Xjzw==
X-Gm-Message-State: AOAM533Nk44TAcpq2J8xWk+brb2cgfMRj8o9S8wfZn7ec+DcI9KMg3Zs
        5F28SBxmiS2hoOtzFx2Kooc=
X-Google-Smtp-Source: ABdhPJwbFzoqQHMsxKvNBcw/NZG+zZBq+uvXJ0D0ZvrQuxYBS7wigq7jHvP5mPHtSGj5gGZ3uG6LIA==
X-Received: by 2002:a2e:8812:: with SMTP id x18mr15723789ljh.441.1627405250266;
        Tue, 27 Jul 2021 10:00:50 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id q10sm339595ljp.108.2021.07.27.10.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:00:49 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, Stefan.Maetje@esd.eu
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 3/3] can: esd_usb2: fix memory leak
Date:   Tue, 27 Jul 2021 20:00:46 +0300
Message-Id: <b31b096926dcb35998ad0271aac4b51770ca7cc8.1627404470.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627404470.git.paskripkin@gmail.com>
References: <cover.1627404470.git.paskripkin@gmail.com>
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
2.32.0

