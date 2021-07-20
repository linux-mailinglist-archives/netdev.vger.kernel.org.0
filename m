Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9013CF71D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbhGTJEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:04:22 -0400
Received: from pop36.abv.bg ([194.153.145.227]:33928 "EHLO pop36.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234806AbhGTJEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:04:21 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 05:04:19 EDT
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop36.abv.bg (Postfix) with ESMTP id 16953180AA90;
        Tue, 20 Jul 2021 12:37:48 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1626773868; bh=mPlI6hgEp7grsSif9s2vkTZdz6gtzjPUEOp/oqiK5UI=;
        h=From:Subject:Date:Cc:To:From;
        b=svJWeBryW3FrNGb9165p1tCW8zASIGZ97zrAJc8f3I+/ASFCZU5ZzLQbsRsVazTcb
         RY2FG8Sr0Zq32szO8+1FjFgeWYFs4QgMgOyhvjHQ37maKKqyqPQBrB0do+CESvWiwh
         jkAAoUlXynzSByzMxYu1yufo+WH4WsEP1S6t5x2Y=
X-HELO: smtpclient.apple
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-148.ip.btc-net.bg (HELO smtpclient.apple) (212.39.89.148)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Tue, 20 Jul 2021 12:37:48 +0300
From:   Georgi Valkov <gvalkov@abv.bg>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-Id: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
Date:   Tue, 20 Jul 2021 12:37:43 +0300
Cc:     =?utf-8?B?0JPQtdC+0YDQs9C4INCT0LXQvtGA0LPQuNC10LIg0JLRitC70LrQvtCy?= 
        <gvalkov@abv.bg>, corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org
To:     davem@davemloft.net, kuba@kernel.org, mhabets@solarflare.com,
        luc.vanoostenryck@gmail.com, snelson@pensando.io, mst@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
https://github.com/openwrt/openwrt/pull/4084


=46rom dd109ded2b526636fff438d33433ab64ffd21583 Mon Sep 17 00:00:00 2001
From: Georgi Valkov <gvalkov@abv.bg>
Date: Fri, 16 Apr 2021 20:44:36 +0300
Subject: [PATCH] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

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


