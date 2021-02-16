Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E4831D177
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBPUTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhBPUTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:19:06 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C54C061574;
        Tue, 16 Feb 2021 12:18:26 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id my11so319547pjb.1;
        Tue, 16 Feb 2021 12:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sw3Xj2DTYhteZ+AfUavTEkrGfD2bGGbjZ7Fu3XOlC1o=;
        b=bYxqjpb1IzrHGTXF3/YVisqyGnOa5ir60g4VTYFA5gtqfHoBE6UdmYl4h50AS7nwA6
         NxwuhTQ/wiRP9LRebJm3GXkSsx87YOp4KXFrPBPGha24J6dhEFMri5e7uLNDcqw2BojO
         wvNeR0OwN27LjD9rwuQ601NWk4etixUFws75xWeBQsGJzYlqYj753112hJq2bLIzPwXv
         wI7U7PF9ZUwLc5/OTJ0qvAb2EizSqe+MjGIDTOfqtbtRlN7qBxGCp4VSYo4Rfj2yo6z4
         TeQZsalRsI5E+pJfE5fpCdU4ZzB30JJTlGqk9y90vroj3ydpxCo0HQsWKuChaL4jDitb
         DxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sw3Xj2DTYhteZ+AfUavTEkrGfD2bGGbjZ7Fu3XOlC1o=;
        b=D29BhOzHG8LAS1a4owrH6nIXpsBe0pw2yLWfTQRhdJlojzLPteKFAgk2OxqYKlXJlC
         gtHrY549GTQMsnEGHeFjbrYN0i9CPy7T8ZvvOtGTmDuAr7Mp2n7fNlE8sRFuC2EVbPh9
         wVu+PoPbrjZCl6L+/f4hSWxQPUCsOaUbnXIMctWnA1DR9qXDsQtXtX3nxboQfxrv5bJx
         fH1EGqvJMNiDOKkCp4JjIwtsMqXu72I0mWzh+cL1ePRlEdQYmCyAByu3c7X8i5VD5oRs
         7BDn/TYjeWJ7cWlbQeIXnUz0Rv6wM3ZtBEyD1GV40QwkpvBCx7LTijF93RQnUV6FmRu6
         E2Rg==
X-Gm-Message-State: AOAM533TEabZCF5maSCT5ywQ6QR2YmIFLOOo82D0AFOl3FzJXymVcDbf
        yxubuerMT6/OV+4nTkoDq7lMxelWYKY=
X-Google-Smtp-Source: ABdhPJywzIWQJLi9mvEQKW4Fk+OZ3WbyFCGg0+p4JgAsSVpf2CjctJi8QBdzLP18Dr/F1HRNDED9hA==
X-Received: by 2002:a17:902:9009:b029:dc:52a6:575 with SMTP id a9-20020a1709029009b02900dc52a60575mr20617651plp.57.1613506705969;
        Tue, 16 Feb 2021 12:18:25 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:423b:9598:9909:5513])
        by smtp.gmail.com with ESMTPSA id f25sm23695717pfk.184.2021.02.16.12.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 12:18:25 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Date:   Tue, 16 Feb 2021 12:18:13 -0800
Message-Id: <20210216201813.60394-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending packets, we will first hand over the (L3) packets to the
LAPB module. The LAPB module will then hand over the corresponding LAPB
(L2) frames back to us for us to transmit.

The LAPB module can also emit LAPB (L2) frames at any time, even without
an (L3) packet currently being sent on the device. This happens when the
LAPB module tries to send (L3) packets queued up in its internal queue,
or when the LAPB module decides to send some (L2) control frame.

This means we need to have a queue for these outgoing LAPB (L2) frames,
otherwise frames can be dropped if sent when the hardware driver is
already busy in transmitting. The queue needs to be controlled by
the hardware driver's netif_stop_queue and netif_wake_queue calls.
Therefore, we need to use the device's qdisc TX queue for this purpose.
However, currently outgoing LAPB (L2) frames are not queued.

On the other hand, outgoing (L3) packets (before they are handed over
to the LAPB module) don't need to be queued, because the LAPB module
already has an internal queue for them, and is able to queue new outgoing
(L3) packets at any time. However, currently outgoing (L3) packets are
being queued in the device's qdisc TX queue, which is controlled by
the hardware driver's netif_stop_queue and netif_wake_queue calls.
This is unnecessary and meaningless.

To fix these issues, we can split the HDLC device into two devices -
a virtual X.25 device and the actual HDLC device, use the virtual X.25
device to send (L3) packets and then use the actual HDLC device to
queue LAPB (L2) frames. The outgoing (L2) LAPB queue will be controlled
by the hardware driver's netif_stop_queue and netif_wake_queue calls,
while outgoing (L3) packets will not be affected by these calls.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from RFC v3:
Call netif_carrier_off in x25_hdlc_open before calling register_netdevice.

Change from RFC v2:
Simplified the commit message.
Dropped the x25_open fix which is already merged into net-next now.
Use HDLC_MAX_MTU as the mtu of the X.25 virtual device.
Add an explanation to the documentation about the X.25 virtual device.

Change from RFC v1:
Properly initialize state(hdlc)->x25_dev and state(hdlc)->x25_dev_lock.

---
 Documentation/networking/generic-hdlc.rst |   3 +
 drivers/net/wan/hdlc_x25.c                | 156 ++++++++++++++++++----
 2 files changed, 133 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/generic-hdlc.rst b/Documentation/networking/generic-hdlc.rst
index 1c3bb5cb98d4..55f6b0ab45be 100644
--- a/Documentation/networking/generic-hdlc.rst
+++ b/Documentation/networking/generic-hdlc.rst
@@ -59,6 +59,9 @@ or::
 In Frame Relay mode, ifconfig master hdlc device up (without assigning
 any IP address to it) before using pvc devices.
 
+In X.25 mode, ifconfig the hdlc device up, then a virtual X.25 device
+would appear for use.
+
 
 Setting interface:
 
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 4aaa6388b9ee..b7744065900f 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -23,6 +23,13 @@
 
 struct x25_state {
 	x25_hdlc_proto settings;
+	struct net_device *x25_dev;
+	spinlock_t x25_dev_lock; /* Protects the x25_dev pointer */
+};
+
+/* Pointed to by netdev_priv(x25_dev) */
+struct x25_device {
+	struct net_device *hdlc_dev;
 };
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
@@ -32,6 +39,11 @@ static struct x25_state *state(hdlc_device *hdlc)
 	return hdlc->state;
 }
 
+static struct x25_device *dev_to_x25(struct net_device *dev)
+{
+	return netdev_priv(dev);
+}
+
 /* These functions are callbacks called by LAPB layer */
 
 static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
@@ -89,15 +101,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 
 static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 {
-	hdlc_device *hdlc = dev_to_hdlc(dev);
-
+	skb->dev = dev_to_x25(dev)->hdlc_dev;
+	skb->protocol = htons(ETH_P_HDLC);
 	skb_reset_network_header(skb);
-	skb->protocol = hdlc_type_trans(skb, dev);
-
-	if (dev_nit_active(dev))
-		dev_queue_xmit_nit(skb, dev);
-
-	hdlc->xmit(skb, dev); /* Ignore return value :-( */
+	dev_queue_xmit(skb);
 }
 
 
@@ -163,7 +170,8 @@ static int x25_open(struct net_device *dev)
 		.data_indication = x25_data_indication,
 		.data_transmit = x25_data_transmit,
 	};
-	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *hdlc_dev = dev_to_x25(dev)->hdlc_dev;
+	hdlc_device *hdlc = dev_to_hdlc(hdlc_dev);
 	struct lapb_parms_struct params;
 	int result;
 
@@ -195,9 +203,101 @@ static int x25_open(struct net_device *dev)
 
 
 
-static void x25_close(struct net_device *dev)
+static int x25_close(struct net_device *dev)
 {
 	lapb_unregister(dev);
+	return 0;
+}
+
+static const struct net_device_ops hdlc_x25_netdev_ops = {
+	.ndo_open       = x25_open,
+	.ndo_stop       = x25_close,
+	.ndo_start_xmit = x25_xmit,
+};
+
+static void x25_setup_virtual_dev(struct net_device *dev)
+{
+	dev->netdev_ops	     = &hdlc_x25_netdev_ops;
+	dev->type            = ARPHRD_X25;
+	dev->addr_len        = 0;
+	dev->hard_header_len = 0;
+	dev->mtu             = HDLC_MAX_MTU;
+
+	/* When transmitting data:
+	 * first we'll remove a pseudo header of 1 byte,
+	 * then the LAPB module will prepend an LAPB header of at most 3 bytes.
+	 */
+	dev->needed_headroom = 3 - 1;
+}
+
+static int x25_hdlc_open(struct net_device *dev)
+{
+	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *x25_dev;
+	char x25_dev_name[sizeof(x25_dev->name)];
+	int result;
+
+	if (strlen(dev->name) + 4 >= sizeof(x25_dev_name))
+		return -EINVAL;
+
+	strcpy(x25_dev_name, dev->name);
+	strcat(x25_dev_name, "_x25");
+
+	x25_dev = alloc_netdev(sizeof(struct x25_device), x25_dev_name,
+			       NET_NAME_PREDICTABLE, x25_setup_virtual_dev);
+	if (!x25_dev)
+		return -ENOMEM;
+
+	dev_to_x25(x25_dev)->hdlc_dev = dev;
+
+	/* netif_carrier_on will be called later by x25_hdlc_start */
+	netif_carrier_off(x25_dev);
+
+	result = register_netdevice(x25_dev);
+	if (result) {
+		free_netdev(x25_dev);
+		return result;
+	}
+
+	spin_lock_bh(&state(hdlc)->x25_dev_lock);
+	state(hdlc)->x25_dev = x25_dev;
+	spin_unlock_bh(&state(hdlc)->x25_dev_lock);
+
+	return 0;
+}
+
+static void x25_hdlc_close(struct net_device *dev)
+{
+	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *x25_dev = state(hdlc)->x25_dev;
+
+	if (x25_dev->flags & IFF_UP)
+		dev_close(x25_dev);
+
+	spin_lock_bh(&state(hdlc)->x25_dev_lock);
+	state(hdlc)->x25_dev = NULL;
+	spin_unlock_bh(&state(hdlc)->x25_dev_lock);
+
+	unregister_netdevice(x25_dev);
+	free_netdev(x25_dev);
+}
+
+static void x25_hdlc_start(struct net_device *dev)
+{
+	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *x25_dev = state(hdlc)->x25_dev;
+
+	/* hdlc.c guarantees no racing so we're sure x25_dev is valid */
+	netif_carrier_on(x25_dev);
+}
+
+static void x25_hdlc_stop(struct net_device *dev)
+{
+	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *x25_dev = state(hdlc)->x25_dev;
+
+	/* hdlc.c guarantees no racing so we're sure x25_dev is valid */
+	netif_carrier_off(x25_dev);
 }
 
 
@@ -205,27 +305,38 @@ static void x25_close(struct net_device *dev)
 static int x25_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *x25_dev;
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
 		dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
-	if (lapb_data_received(dev, skb) == LAPB_OK)
-		return NET_RX_SUCCESS;
-
-	dev->stats.rx_errors++;
+	spin_lock_bh(&state(hdlc)->x25_dev_lock);
+	x25_dev = state(hdlc)->x25_dev;
+	if (!x25_dev)
+		goto drop;
+	if (lapb_data_received(x25_dev, skb) != LAPB_OK)
+		goto drop;
+	spin_unlock_bh(&state(hdlc)->x25_dev_lock);
+	return NET_RX_SUCCESS;
+
+drop:
+	spin_unlock_bh(&state(hdlc)->x25_dev_lock);
+	dev->stats.rx_dropped++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
 }
 
 
 static struct hdlc_proto proto = {
-	.open		= x25_open,
-	.close		= x25_close,
+	.open		= x25_hdlc_open,
+	.close		= x25_hdlc_close,
+	.start		= x25_hdlc_start,
+	.stop		= x25_hdlc_stop,
 	.ioctl		= x25_ioctl,
 	.netif_rx	= x25_rx,
-	.xmit		= x25_xmit,
 	.module		= THIS_MODULE,
 };
 
@@ -298,16 +409,9 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		state(hdlc)->x25_dev = NULL;
+		spin_lock_init(&state(hdlc)->x25_dev_lock);
 
-		/* There's no header_ops so hard_header_len should be 0. */
-		dev->hard_header_len = 0;
-		/* When transmitting data:
-		 * first we'll remove a pseudo header of 1 byte,
-		 * then we'll prepend an LAPB header of at most 3 bytes.
-		 */
-		dev->needed_headroom = 3 - 1;
-
-		dev->type = ARPHRD_X25;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
 		return 0;
-- 
2.27.0

