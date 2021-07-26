Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF783D5D04
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbhGZOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbhGZOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:50:15 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A3C061760;
        Mon, 26 Jul 2021 08:30:44 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id b21so11724143ljo.13;
        Mon, 26 Jul 2021 08:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iea5qO2fdy0HoiQckUUb63itdyCRWHqDzn/tBtz3LPI=;
        b=pVAsW7BQ8LuEZ7HmlokQ76GqUDg6cqWPHk+XOFxeXzzGnYjSVfUa8y+NWOYlwl/3k/
         hbAcskWdmoSROwW9mttYnQRsTJTKKELKu3HVziS90pLqHY0KbIT9KHppsT9jnnbhc7nn
         jBp/s1epf8m65fdYluxB0wIwoxGIb9MDU6VEJW3qmoC35qpHY6PT2Jc8+pjn9hzdlaPH
         FhFhzZCSm6sylB70p9JmLY3frk2QOnFyBStBf3LiMEQd5l0pQJys1DhTEOzNE24pAxqb
         /ZKvWjhEXCi7rqo0HPkJMtm27KCbm9RG5eK2vUfVMxxij5pI52z0+9QQKXh3ZZAcNWUB
         8Gcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iea5qO2fdy0HoiQckUUb63itdyCRWHqDzn/tBtz3LPI=;
        b=KHKf+e2dAq9BB64WtG/afFkjo0UGDAP3pBDyALeSZ/eQnJj6gMCvz7/ORmsY0OQBJZ
         +ZAbz/U/7Ct62iOnZ1vjx2uJg8iNqx6wlcsTp2o/kkS52w1zJddctr4C5ZeqTStM7qJ0
         txMm+eVNqKOpimVI363kfTPPjdLcm+JM/gdYioQ6T64CUSdwB8BClm/7bgzgCywkzMtg
         r65IIUA5eSE8Slcu6dlYN2iVs9LhxIIUzhi1r5zUlOgjksdkhiIQcVnWuUXoCQIdqRPv
         UU7pg/uPgQGKzwlN/FBCfwjXyFrBx317qQBgd2KlxVCZb04yMxvfcxF02q2UTliP5RLs
         rbmA==
X-Gm-Message-State: AOAM530gMx5k7dSZ15QRZl9wAKoN1DfOPrk5VRE8IPHd9hCRvfTZ3aYr
        pj7qygfVv7fVv4w15Lnod0s=
X-Google-Smtp-Source: ABdhPJzg1QcDyIOIqACGVUmMfrd0Cl79fl5oQCQMP+Hv8VzC842YeH+1wvPyy3KBIES5TcFlsuqV5A==
X-Received: by 2002:a05:651c:246:: with SMTP id x6mr12245086ljn.452.1627313441061;
        Mon, 26 Jul 2021 08:30:41 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id u13sm30799lfq.142.2021.07.26.08.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:30:40 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        socketcan@hartkopp.net, mailhol.vincent@wanadoo.fr,
        haas@ems-wuensche.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/3] can: ems_usb: fix memory leak
Date:   Mon, 26 Jul 2021 18:30:36 +0300
Message-Id: <4e89570da4ce94bfbc18911a8bfa65b23f873e6e.1627311383.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627311383.git.paskripkin@gmail.com>
References: <cover.1627311383.git.paskripkin@gmail.com>
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

