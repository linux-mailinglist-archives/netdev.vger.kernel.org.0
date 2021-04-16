Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B35362795
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbhDPSTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:19:34 -0400
Received: from pop31.abv.bg ([194.153.145.221]:53764 "EHLO pop31.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236112AbhDPSTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:19:34 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2021 14:19:33 EDT
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop31.abv.bg (Postfix) with ESMTP id 6B2ED1805913;
        Fri, 16 Apr 2021 21:13:44 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1618596824; bh=DFyGWRt2O/n2LfjlOnW/zpPJa0sAE+09jDo5uiYtOLU=;
        h=From:Subject:Date:Cc:To:From;
        b=B8qYhrcvPKG7LzA1pPv4Y3CDPe8q0m9e4trDm9TOJiqlB+HVEewZ3l5SxTQkARi/N
         dDrSHRjDpFQ2ccCshXjbKo7ucc3146tpfhciL3mIDFBur8D9NA/JrE7MhIGmHPe8Ua
         S2npeyDoFgSrOkHy1sDMiVTl0RnUE+oQ1IRbJGY4=
X-HELO: [192.168.192.3]
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-202.ip.btc-net.bg (HELO [192.168.192.3]) (212.39.89.202)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Fri, 16 Apr 2021 21:13:44 +0300
From:   Georgi Valkov <gvalkov@abv.bg>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: usbnet: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-Id: <833FE09E-2542-4F3F-87D6-DD03084C0FD5@abv.bg>
Date:   Fri, 16 Apr 2021 21:13:40 +0300
Cc:     oneukum@suse.com, matti.vuorela@bitfactor.fi
To:     corsac@corsac.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux kernel team,

Please accept the following important fix from me:
https://github.com/httpstorm/linux-kernel/tree/ipheth-fix-RX-EOVERFLOW

While commit f33d9e2b48a34e1558b67a473a1fc1d6e793f93c
is required for iOS 14, only the TX buffers should be reduced
to 1514 bytes. RX buffers should remain at 1516 bytes, because
their size is reduced later by IPHETH_IP_ALIGN (2 bytes).


=46rom dd109ded2b526636fff438d33433ab64ffd21583 Mon Sep 17 00:00:00 2001
From: Georgi Valkov <gvalkov@abv.bg>
Date: Fri, 16 Apr 2021 20:44:36 +0300
Subject: [PATCH] usbnet: ipheth: fix EOVERFLOW in =
ipheth_rcvbulk_callback

When rx_buf is allocated we need to account for IPHETH_IP_ALIGN,
which reduces the usable size by 2 bytes. Otherwise we have 1512
bytes usable instead of 1514, and if we receive more than 1512
bytes, ipheth_rcvbulk_callback is called with status -EOVERFLOW,
after which the driver malfunctiones and all communication stops.

Fixes: ipheth 2-1:4.2: ipheth_rcvbulk_callback: urb status: -75

Signed-off-by: Georgi Valkov <gvalkov@abv.bg>
---
 drivers/net/usb/ipheth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 207e59e74935..06d9f19ca142 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -121,7 +121,7 @@ static int ipheth_alloc_urbs(struct ipheth_device =
*iphone)
 	if (tx_buf =3D=3D NULL)
 		goto free_rx_urb;
=20
-	rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf =3D usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE + =
IPHETH_IP_ALIGN,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf =3D=3D NULL)
 		goto free_tx_buf;
@@ -146,7 +146,7 @@ static int ipheth_alloc_urbs(struct ipheth_device =
*iphone)
=20
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE + =
IPHETH_IP_ALIGN, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
 	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
@@ -317,7 +317,7 @@ static int ipheth_rx_submit(struct ipheth_device =
*dev, gfp_t mem_flags)
=20
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_BUF_SIZE + =
IPHETH_IP_ALIGN,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |=3D URB_NO_TRANSFER_DMA_MAP;
--=20
2.31.1


