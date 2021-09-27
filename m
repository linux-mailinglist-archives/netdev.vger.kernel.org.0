Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D1419778
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhI0POf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Sep 2021 11:14:35 -0400
Received: from molly.corsac.net ([82.66.73.9]:38764 "EHLO mail.corsac.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhI0POd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 11:14:33 -0400
Received: from scapa.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id 1C7F09B
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:51:14 +0200 (CEST)
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a01c9
        by scapa.corsac.net (DragonFly Mail Agent v0.13);
        Mon, 27 Sep 2021 16:51:13 +0200
Message-ID: <eaccc3f66f4c616f3eecfc01c359ac03a5d92028.camel@corsac.net>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     Sam Bingner <sam@bingner.com>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 27 Sep 2021 16:51:13 +0200
In-Reply-To: <79d05aaa5052408897aeb8039c6a1582@bingner.com>
References: <370902e520c44890a44cb5dd0cb1595f@bingner.com>
         <d61ad9565e29a07086e52bc984e8e629285ff8cf.camel@suse.com>
         <79d05aaa5052408897aeb8039c6a1582@bingner.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-22 at 20:11 +0000, Sam Bingner wrote:
> Sorry I didn't have time to research this further to prove it was a
> regression - but there is now somebody else who has done so and created a
> patch.  I thought it might be good to give a link to it to you guys.  It
> caused problems on all iOS versions AFAIK.  The patch and discussion is
> available at:
> 
> https://github.com/openwrt/openwrt/pull/4084

Hi Sam, sorry for the delay.

I've read the thread above and the patch. Unfortunately we don't have
documentation on how the driver is supposed to work and how the iPhone part
behave, everything was reverse engineered at the time and the people who did
it seem long gone.

As far as I understand it, when we experienced the “first” bug, it was noted
that reducing the (TX) buffer size by 2 helped, and thus the patch changing
IPHETH_BUF_SIZE to 1514 was committed, reducing both RX and TX buffer size.

During my testings I never experienced the subsequent bug (the
ipheth_rcvbulk_callback: urb status: -75) but maybe I never received 1500b
packets (it's a bit strange but maybe).

Maybe the right fix would be to split IPHETH_BUF_SIZE to
IPHETH_{RX,TX}_BUF_SIZE? Something like:

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 57d94b18ef33..005d2e31d97c 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -60,7 +60,9 @@
 #define IPHETH_USBINTF_PROTO    1
 
 #define IPHETH_BUF_SIZE         1514
-#define IPHETH_IP_ALIGN		2	/* padding at front of URB */
+#define IPHETH_IP_ALIGN		2	/* padding at front of URB on
RX path */
+#define IPHETH_TX_BUF_SIZE      IPHETH_BUF_SIZE
+#define IPHETH_RX_BUF_SIZE      IPHETH_BUF_SIZE + IPHETH_IP_ALIGN
 #define IPHETH_TX_TIMEOUT       (5 * HZ)
 
 #define IPHETH_INTFNUM          2
@@ -116,12 +118,12 @@ static int ipheth_alloc_urbs(struct ipheth_device
*iphone)
 	if (rx_urb == NULL)
 		goto free_tx_urb;
 
-	tx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	tx_buf = usb_alloc_coherent(iphone->udev, IPHETH_TX_BUF_SIZE,
 				    GFP_KERNEL, &tx_urb->transfer_dma);
 	if (tx_buf == NULL)
 		goto free_rx_urb;
 
-	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_BUF_SIZE,
+	rx_buf = usb_alloc_coherent(iphone->udev, IPHETH_RX_BUF_SIZE,
 				    GFP_KERNEL, &rx_urb->transfer_dma);
 	if (rx_buf == NULL)
 		goto free_tx_buf;
@@ -134,7 +136,7 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 	return 0;
 
 free_tx_buf:
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, tx_buf,
 			  tx_urb->transfer_dma);
 free_rx_urb:
 	usb_free_urb(rx_urb);
@@ -146,9 +148,9 @@ static int ipheth_alloc_urbs(struct ipheth_device *iphone)
 
 static void ipheth_free_urbs(struct ipheth_device *iphone)
 {
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_RX_BUF_SIZE, iphone->rx_buf,
 			  iphone->rx_urb->transfer_dma);
-	usb_free_coherent(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
+	usb_free_coherent(iphone->udev, IPHETH_TX_BUF_SIZE, iphone->tx_buf,
 			  iphone->tx_urb->transfer_dma);
 	usb_free_urb(iphone->rx_urb);
 	usb_free_urb(iphone->tx_urb);
@@ -317,7 +319,7 @@ static int ipheth_rx_submit(struct ipheth_device *dev,
gfp_t mem_flags)
 
 	usb_fill_bulk_urb(dev->rx_urb, udev,
 			  usb_rcvbulkpipe(udev, dev->bulk_in),
-			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  dev->rx_buf, IPHETH_RX_BUF_SIZE,
 			  ipheth_rcvbulk_callback,
 			  dev);
 	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -381,7 +383,7 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct
net_device *net)
 	int retval;
 
 	/* Paranoid */
-	if (skb->len > IPHETH_BUF_SIZE) {
+	if (skb->len > IPHETH_TX_BUF_SIZE) {
 		WARN(1, "%s: skb too large: %d bytes\n", __func__, skb->len);
 		dev->net->stats.tx_dropped++;
 		dev_kfree_skb_any(skb);
@@ -389,12 +391,12 @@ static netdev_tx_t ipheth_tx(struct sk_buff *skb, struct
net_device *net)
 	}
 
 	memcpy(dev->tx_buf, skb->data, skb->len);
-	if (skb->len < IPHETH_BUF_SIZE)
-		memset(dev->tx_buf + skb->len, 0, IPHETH_BUF_SIZE - skb-
>len);
+	if (skb->len < IPHETH_TX_BUF_SIZE)
+		memset(dev->tx_buf + skb->len, 0, IPHETH_TX_BUF_SIZE - skb-
>len);
 
 	usb_fill_bulk_urb(dev->tx_urb, udev,
 			  usb_sndbulkpipe(udev, dev->bulk_out),
-			  dev->tx_buf, IPHETH_BUF_SIZE,
+			  dev->tx_buf, IPHETH_TX_BUF_SIZE,
 			  ipheth_sndbulk_callback,
 			  dev);
 	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

-- 
Yves-Alexis
