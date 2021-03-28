Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52D234BD93
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhC1R1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhC1R1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:27:02 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B789EC061756;
        Sun, 28 Mar 2021 10:27:01 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id y12so718085qtx.11;
        Sun, 28 Mar 2021 10:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FQX/gcJriWUwtViUDE6a7G+1n/p69e58iSq2bIyX1xQ=;
        b=meG7Yrn8vVfd+VkQjxIsi4PUs5ZF8eTRpNn6FWK8slwKBPOgPAXeG1YxMl8/80++/9
         YRWbsUx/tS1R58SDaX5uYJKJx5kOWgqCYvowVH5vqUhTAGnUUC8PXLPLO61TZyQEcgJ4
         I2H4ICHpv/IaAW8T3SgIMU8vuilLsgD6us3yMP+9l5oXcen0pyYCAFOI6JUemcvyLbtW
         AAalZpn1zl4dIzdIxV8YhCsbfn1Bor285w8MJYDZPzGj+ze0GJXTEiQsohejE/FfR5H8
         8mPZw7jOPNLh3obOBDJIShP0goTjr2qMvaqsdC8Xsi8zH57yw+R+kpHEGikQneFlib1u
         aNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FQX/gcJriWUwtViUDE6a7G+1n/p69e58iSq2bIyX1xQ=;
        b=bKMtHlgEO73r0EnFUxe+Lo8TlJRx+jI+jIcXLoKm9n2eQj3jPp4nE7WbrlSKlUCFn+
         eQg3i3Q3tvcZxKRgT6V9pozAIZG8dp7XRsNtOTrc8yswe3IhDt6NvBtd4HRU7kh75nGg
         KGs6hgcMpJFTnIC/La2eMj+JKUSQooANhN+tNzd/+b0FEZ2wyGOGCNi5KL2FUceHpA2N
         zRUHKOXwkIiIEpeuRY5J6+IqJzHUBx8MMPJfjleUidFGPUAA4t8VS+Zwytj28it6PggV
         AxuwUbOA5kJ3m+RgTJu6d3DlCDi1pYWeL28cKRBFgI6/2Zpr1gWAIpZSB4A8TM/NwFyJ
         0eVA==
X-Gm-Message-State: AOAM530glausqOmHDD/p27cSXzoJKyW4BdqyuoO83yypKLPDkQNMNCfF
        PmxS2Yu12ezJnisxb0iYz7s=
X-Google-Smtp-Source: ABdhPJxQKOUNf03PjPe7G9P1QRl7mUUSkzOvAt50/qJZIw/yExWwJmnCTln0VPRP5B5N1FVNxYgZJQ==
X-Received: by 2002:aed:2010:: with SMTP id 16mr3888105qta.256.1616952420845;
        Sun, 28 Mar 2021 10:27:00 -0700 (PDT)
Received: from shane-XPS-13-9380.attlocal.net ([2600:1700:4ca1:ade0:d373:7d57:15e2:e5f6])
        by smtp.gmail.com with ESMTPSA id c1sm1309338qth.3.2021.03.28.10.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:27:00 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v3] net: x25: Queue received packets in the drivers instead of per-CPU queues
Date:   Sun, 28 Mar 2021 10:26:53 -0700
Message-Id: <20210328172654.625055-1-xie.he.0141@gmail.com>
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

Change from v2:
No need to print out-of-memory errors when receiving data packets,
because the LAPB module is able to handle this situation.
(We still need to print the errors when generating control packets.)

Change from v1:
Drop all PFMEMALLOC skbs because we cannot handle them.

Change from RFC (March 5, 2021):
Rebased onto the latest net-next.

Martin Schiller has acked the RFC version.

---
 Documentation/networking/x25-iface.rst | 65 ++++----------------------
 drivers/net/wan/hdlc_x25.c             | 36 +++++++++++++-
 drivers/net/wan/lapbether.c            | 58 +++++++++++++++++++++--
 3 files changed, 98 insertions(+), 61 deletions(-)

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
index 5a6a945f6c81..df3cad58030b 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -25,6 +25,8 @@ struct x25_state {
 	x25_hdlc_proto settings;
 	bool up;
 	spinlock_t up_lock; /* Protects "up" */
+	struct sk_buff_head rx_queue;
+	struct tasklet_struct rx_tasklet;
 };
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
@@ -34,10 +36,22 @@ static struct x25_state *state(hdlc_device *hdlc)
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
 
@@ -45,12 +59,19 @@ static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
 		netdev_err(dev, "out of memory\n");
 		return;
 	}
+	if (skb_pfmemalloc(skb)) {
+		netdev_err(dev, "out of memory\n");
+		kfree_skb(skb);
+		return;
+	}
 
 	ptr = skb_put(skb, 1);
 	*ptr = code;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	netif_rx(skb);
+
+	skb_queue_tail(&x25st->rx_queue, skb);
+	tasklet_schedule(&x25st->rx_tasklet);
 }
 
 
@@ -71,12 +92,17 @@ static void x25_disconnected(struct net_device *dev, int reason)
 
 static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct x25_state *x25st = state(dev_to_hdlc(dev));
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	if (skb_pfmemalloc(skb)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 
@@ -84,7 +110,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&x25st->rx_queue, skb);
+	tasklet_schedule(&x25st->rx_tasklet);
+	return NET_RX_SUCCESS;
 }
 
 
@@ -223,6 +252,7 @@ static void x25_close(struct net_device *dev)
 	spin_unlock_bh(&x25st->up_lock);
 
 	lapb_unregister(dev);
+	tasklet_kill(&x25st->rx_tasklet);
 }
 
 
@@ -338,6 +368,8 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		state(hdlc)->up = false;
 		spin_lock_init(&state(hdlc)->up_lock);
+		skb_queue_head_init(&state(hdlc)->rx_queue);
+		tasklet_setup(&state(hdlc)->rx_tasklet, x25_rx_queue_kick);
 
 		/* There's no header_ops so hard_header_len should be 0. */
 		dev->hard_header_len = 0;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 45d74285265a..d72724411b8b 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -53,6 +53,8 @@ struct lapbethdev {
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
 	bool			up;
 	spinlock_t		up_lock;	/* Protects "up" */
+	struct sk_buff_head	rx_queue;
+	struct napi_struct	napi;
 };
 
 static LIST_HEAD(lapbeth_devices);
@@ -83,6 +85,25 @@ static __inline__ int dev_is_ethdev(struct net_device *dev)
 
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
@@ -135,12 +156,17 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 
 static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	if (skb_pfmemalloc(skb)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 
@@ -148,7 +174,10 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
+	return NET_RX_SUCCESS;
 }
 
 /*
@@ -233,6 +262,7 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 static void lapbeth_connected(struct net_device *dev, int reason)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 	struct sk_buff *skb = dev_alloc_skb(1);
 
@@ -240,16 +270,24 @@ static void lapbeth_connected(struct net_device *dev, int reason)
 		pr_err("out of memory\n");
 		return;
 	}
+	if (skb_pfmemalloc(skb)) {
+		pr_err("out of memory\n");
+		kfree_skb(skb);
+		return;
+	}
 
 	ptr  = skb_put(skb, 1);
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
 
@@ -257,12 +295,19 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
 		pr_err("out of memory\n");
 		return;
 	}
+	if (skb_pfmemalloc(skb)) {
+		pr_err("out of memory\n");
+		kfree_skb(skb);
+		return;
+	}
 
 	ptr  = skb_put(skb, 1);
 	*ptr = X25_IFACE_DISCONNECT;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
 }
 
 /*
@@ -293,6 +338,8 @@ static int lapbeth_open(struct net_device *dev)
 	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
+	napi_enable(&lapbeth->napi);
+
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
@@ -317,6 +364,8 @@ static int lapbeth_close(struct net_device *dev)
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
+	napi_disable(&lapbeth->napi);
+
 	return 0;
 }
 
@@ -374,6 +423,9 @@ static int lapbeth_new_device(struct net_device *dev)
 	lapbeth->up = false;
 	spin_lock_init(&lapbeth->up_lock);
 
+	skb_queue_head_init(&lapbeth->rx_queue);
+	netif_napi_add(ndev, &lapbeth->napi, lapbeth_napi_poll, 16);
+
 	rc = -EIO;
 	if (register_netdevice(ndev))
 		goto fail;
-- 
2.27.0

