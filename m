Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C425D32E1C0
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 06:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCEFnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 00:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhCEFnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 00:43:24 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECD5C061574;
        Thu,  4 Mar 2021 21:43:24 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q204so1222437pfq.10;
        Thu, 04 Mar 2021 21:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruVrfuVnPxBfe9jZ6kyV5vDYQuPMqlsZoXtnB9sKvqk=;
        b=mYzuE6SHUtOZ4iQ0y2GD/MpAHSa/TFSB2wKtxKkLdYwpX2TwhJaTJmACKhxoCg95Ym
         rVD34Wogwwe7CnvFmABTllD6QztvS7R8BSaCTZxMN5cKU/VRVvpHONF850pB5RIoOO+S
         kt8sr5VuG113izzatrn8nZw0ZgFVIo8ZuUUCURYpWwfOf90FpnlETdBciQaNhd7IyZ7x
         +gzHhvkOfU5/OXFJy0LPAsLxdYCPbwaMrPa5oue0RyTy+/96sf++fRRzhG8tV5xVpa60
         6eHfeaZS9F0eoZ76nU+GW9A9cAhVhFxgK456/iWYw1vTRiYvo+qm4407hVsOdvaEbp/e
         wyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ruVrfuVnPxBfe9jZ6kyV5vDYQuPMqlsZoXtnB9sKvqk=;
        b=QPEcL0Vpxmhxnq9JSrpOCx20J7fJfHY+YGzWyYVqIC6VGMWIM5+72gw7o5VCEGhlOp
         CP+J0h1WmIh3K6M5Fp8OyAPnqciEkDwIflPzyfHlGvx7BiE+c8FvOi0NWN15GTnifpjQ
         JXQlxDvnvK0raHUnG/qOb5OQWJY4kdXuPWDshXkMwSyQeUg7DsbfPbQ3Zf7SH2JPsEEJ
         vu95EmKyb7Mm74gQYGnvCjJsMrIb01lwK4rZhKpQuBpUBBFDGB7I4bgqEsEdIFE84ajZ
         qkK5h553AigBZrQVltD7bbOOFwQKZ6Qqd9OT7XYMY0tzsZDgG+XaBuXw+gfTh2r/enFt
         Irjw==
X-Gm-Message-State: AOAM531mgxBT3JL/LkabJ5uMkUVLjXA9Hi2E2un3p7cXlpGMVTMzJDZz
        Kw8VT3KifHXWyx5qM8Kt98A=
X-Google-Smtp-Source: ABdhPJynUqaHFHr9YldsYx2tgVZsPvc9/TFiF8Rab+m+ihGF1HuaVpfq+nf+dmbVbiUNtHxNJQxCOw==
X-Received: by 2002:a63:db02:: with SMTP id e2mr6942747pgg.18.1614923003646;
        Thu, 04 Mar 2021 21:43:23 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:6378:655:4fad:20f6])
        by smtp.gmail.com with ESMTPSA id n184sm1145177pfd.205.2021.03.04.21.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 21:43:22 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next RFC] net: x25: Queue received packets in the drivers instead of per-CPU queues
Date:   Thu,  4 Mar 2021 21:43:12 -0800
Message-Id: <20210305054312.254922-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

X.25 Layer 3 (the Packet Layer) expects layer 2 to provide a reliable
datalink service such that no packets are reordered or dropped. And
X.25 Layer 2 (the LAPB layer) is indeed designed to provide such service.

However, this reliability is not preserved when a driver calls "netif_rx"
to deliver the received packets to layer 3, because "netif_rx" will put
the packets into per-CPU queues before they are delivered to layer 3.
If there are multiple CPUs, the order of the packets may not be preserved.
The per-CPU queues may also drop packets if there are too many.

Therefore, we should not call "netif_rx" to let it queue the packets.
Instead, we should use our own queue that won't reorder or drop packets.

This patch changes all X.25 drivers to use their own queues instead of
calling "netif_rx". The patch also documents this requirement in the
"x25-iface" documentation.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/networking/x25-iface.rst | 65 ++++----------------------
 drivers/net/wan/hdlc_x25.c             | 29 +++++++++++-
 drivers/net/wan/lapbether.c            | 46 ++++++++++++++++--
 3 files changed, 79 insertions(+), 61 deletions(-)

diff --git a/Documentation/networking/x25-iface.rst b/Documentation/networking/x25-iface.rst
index df401891dce6..f34e9ec64937 100644
--- a/Documentation/networking/x25-iface.rst
+++ b/Documentation/networking/x25-iface.rst
@@ -70,60 +70,13 @@ First Byte = 0x03 (X25_IFACE_PARAMS)
 LAPB parameters. To be defined.
 
 
+Requirements for the device driver
+----------------------------------
 
-Possible Problems
-=================
-
-(Henner Eisen, 2000-10-28)
-
-The X.25 packet layer protocol depends on a reliable datalink service.
-The LAPB protocol provides such reliable service. But this reliability
-is not preserved by the Linux network device driver interface:
-
-- With Linux 2.4.x (and above) SMP kernels, packet ordering is not
-  preserved. Even if a device driver calls netif_rx(skb1) and later
-  netif_rx(skb2), skb2 might be delivered to the network layer
-  earlier that skb1.
-- Data passed upstream by means of netif_rx() might be dropped by the
-  kernel if the backlog queue is congested.
-
-The X.25 packet layer protocol will detect this and reset the virtual
-call in question. But many upper layer protocols are not designed to
-handle such N-Reset events gracefully. And frequent N-Reset events
-will always degrade performance.
-
-Thus, driver authors should make netif_rx() as reliable as possible:
-
-SMP re-ordering will not occur if the driver's interrupt handler is
-always executed on the same CPU. Thus,
-
-- Driver authors should use irq affinity for the interrupt handler.
-
-The probability of packet loss due to backlog congestion can be
-reduced by the following measures or a combination thereof:
-
-(1) Drivers for kernel versions 2.4.x and above should always check the
-    return value of netif_rx(). If it returns NET_RX_DROP, the
-    driver's LAPB protocol must not confirm reception of the frame
-    to the peer.
-    This will reliably suppress packet loss. The LAPB protocol will
-    automatically cause the peer to re-transmit the dropped packet
-    later.
-    The lapb module interface was modified to support this. Its
-    data_indication() method should now transparently pass the
-    netif_rx() return value to the (lapb module) caller.
-(2) Drivers for kernel versions 2.2.x should always check the global
-    variable netdev_dropping when a new frame is received. The driver
-    should only call netif_rx() if netdev_dropping is zero. Otherwise
-    the driver should not confirm delivery of the frame and drop it.
-    Alternatively, the driver can queue the frame internally and call
-    netif_rx() later when netif_dropping is 0 again. In that case, delivery
-    confirmation should also be deferred such that the internal queue
-    cannot grow to much.
-    This will not reliably avoid packet loss, but the probability
-    of packet loss in netif_rx() path will be significantly reduced.
-(3) Additionally, driver authors might consider to support
-    CONFIG_NET_HW_FLOWCONTROL. This allows the driver to be woken up
-    when a previously congested backlog queue becomes empty again.
-    The driver could uses this for flow-controlling the peer by means
-    of the LAPB protocol's flow-control service.
+Packets should not be reordered or dropped when delivering between the
+Packet Layer and the device driver.
+
+To avoid packets from being reordered or dropped when delivering from
+the device driver to the Packet Layer, the device driver should not
+call "netif_rx" to deliver the received packets. Instead, it should
+call "netif_receive_skb_core" from softirq context to deliver them.
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 4aaa6388b9ee..28e9cb2c5f1e 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -23,6 +23,8 @@
 
 struct x25_state {
 	x25_hdlc_proto settings;
+	struct sk_buff_head rx_queue;
+	struct tasklet_struct rx_tasklet;
 };
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
@@ -32,10 +34,22 @@ static struct x25_state *state(hdlc_device *hdlc)
 	return hdlc->state;
 }
 
+static void x25_rx_queue_kick(struct tasklet_struct *t)
+{
+	struct x25_state *x25st = from_tasklet(x25st, t, rx_tasklet);
+	struct sk_buff *skb = skb_dequeue(&x25st->rx_queue);
+
+	while (skb) {
+		netif_receive_skb_core(skb);
+		skb = skb_dequeue(&x25st->rx_queue);
+	}
+}
+
 /* These functions are callbacks called by LAPB layer */
 
 static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
 {
+	struct x25_state *x25st = state(dev_to_hdlc(dev));
 	struct sk_buff *skb;
 	unsigned char *ptr;
 
@@ -48,7 +62,9 @@ static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
 	*ptr = code;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	netif_rx(skb);
+
+	skb_queue_tail(&x25st->rx_queue, skb);
+	tasklet_schedule(&x25st->rx_tasklet);
 }
 
 
@@ -69,6 +85,7 @@ static void x25_disconnected(struct net_device *dev, int reason)
 
 static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct x25_state *x25st = state(dev_to_hdlc(dev));
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
@@ -82,7 +99,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&x25st->rx_queue, skb);
+	tasklet_schedule(&x25st->rx_tasklet);
+	return NET_RX_SUCCESS;
 }
 
 
@@ -197,7 +217,10 @@ static int x25_open(struct net_device *dev)
 
 static void x25_close(struct net_device *dev)
 {
+	struct x25_state *x25st = state(dev_to_hdlc(dev));
+
 	lapb_unregister(dev);
+	tasklet_kill(&x25st->rx_tasklet);
 }
 
 
@@ -298,6 +321,8 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		skb_queue_head_init(&state(hdlc)->rx_queue);
+		tasklet_setup(&state(hdlc)->rx_tasklet, x25_rx_queue_kick);
 
 		/* There's no header_ops so hard_header_len should be 0. */
 		dev->hard_header_len = 0;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 605fe555e157..c85b2a1c8067 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -51,6 +51,8 @@ struct lapbethdev {
 	struct list_head	node;
 	struct net_device	*ethdev;	/* link to ethernet device */
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
+	struct sk_buff_head	rx_queue;
+	struct napi_struct	napi;
 };
 
 static LIST_HEAD(lapbeth_devices);
@@ -81,6 +83,25 @@ static __inline__ int dev_is_ethdev(struct net_device *dev)
 
 /* ------------------------------------------------------------------------ */
 
+static int lapbeth_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct lapbethdev *lapbeth = container_of(napi, struct lapbethdev, napi);
+	struct sk_buff *skb;
+	int processed = 0;
+
+	for (; processed < budget; ++processed) {
+		skb = skb_dequeue(&lapbeth->rx_queue);
+		if (!skb)
+			break;
+		netif_receive_skb_core(skb);
+	}
+
+	if (processed < budget)
+		napi_complete(napi);
+
+	return processed;
+}
+
 /*
  *	Receive a LAPB frame via an ethernet interface.
  */
@@ -129,6 +150,7 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 
 static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
@@ -142,7 +164,10 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
+	return NET_RX_SUCCESS;
 }
 
 /*
@@ -228,6 +253,7 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 static void lapbeth_connected(struct net_device *dev, int reason)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 	struct sk_buff *skb = dev_alloc_skb(1);
 
@@ -240,11 +266,14 @@ static void lapbeth_connected(struct net_device *dev, int reason)
 	*ptr = X25_IFACE_CONNECT;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
 }
 
 static void lapbeth_disconnected(struct net_device *dev, int reason)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 	struct sk_buff *skb = dev_alloc_skb(1);
 
@@ -257,7 +286,9 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
 	*ptr = X25_IFACE_DISCONNECT;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
 }
 
 /*
@@ -285,8 +316,11 @@ static const struct lapb_register_struct lapbeth_callbacks = {
  */
 static int lapbeth_open(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
+	napi_enable(&lapbeth->napi);
+
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
@@ -298,6 +332,7 @@ static int lapbeth_open(struct net_device *dev)
 
 static int lapbeth_close(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
 	netif_stop_queue(dev);
@@ -305,6 +340,8 @@ static int lapbeth_close(struct net_device *dev)
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
+	napi_disable(&lapbeth->napi);
+
 	return 0;
 }
 
@@ -359,6 +396,9 @@ static int lapbeth_new_device(struct net_device *dev)
 	dev_hold(dev);
 	lapbeth->ethdev = dev;
 
+	skb_queue_head_init(&lapbeth->rx_queue);
+	netif_napi_add(ndev, &lapbeth->napi, lapbeth_napi_poll, 16);
+
 	rc = -EIO;
 	if (register_netdevice(ndev))
 		goto fail;
-- 
2.27.0

