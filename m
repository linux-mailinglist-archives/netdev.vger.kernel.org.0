Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F1A34BD40
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhC1Qao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhC1Qaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 12:30:39 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59846C061756;
        Sun, 28 Mar 2021 09:30:39 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id j7so7758618qtx.5;
        Sun, 28 Mar 2021 09:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fflf44PBhll8Lp+gQ+hj9EJ05dwi+4skqTSj/7exmuA=;
        b=oyjwO6bZf2rxohsoCvLa8Gq6kwlM/at46UrRoXCFinGaKO8va+OtOHSkzQfayE5r14
         vY+7ANH4Cq5gImHu21Ct58SgZAZ2QfFwxilyj+ny5E4vSpTJwhzxEmA2PQGHRJvAohBj
         +LKs/KA/6ts77rAlg9ImeEKuaDfV1XQmBsrIyoA35W9btVv/0V1Dswrrv28COy8c1iVx
         Ht89HHIUaFUK5KzRl8/LsXr6PBzG02wvWGuCCV6FIxyTzv+fq8/hh2iXq5LyekO42AuZ
         IhIZ8B8CCm4c8+JKUlcPoGUUU8qavMlHOVYZUjk850oChxKfh9NtnthURZdsJMykknxY
         G3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fflf44PBhll8Lp+gQ+hj9EJ05dwi+4skqTSj/7exmuA=;
        b=ReoAAt2SjTWQjXYuZcA4zOlvPXocjC6G043eQsO0dmXnEkjFWpnGTPYCJdmsSkQYxC
         8KCEc2RBCEcX5HOyawuoD6y6OFWHk5GpAgbLZduolufVUvqCbHQzWDUkKaBU7iNK6hiG
         GMzKBdkIEI1VrutWxLCJoGqmjUXFrhfC+ed25cOIafCqP94Pkv4+sMHxnBvar8PeJvxC
         WsEWwTR/rkyPS54FoJMKFjNbfsS5v3zjmT0e9SavrIysEmwJU/Yc+4g66jaaS4dmx40S
         mjRBW7jacqTfmwiU0GlCFG1nMGp+VprHrbZKV759OUndTmCsyhjt8FU7DaTkd8K9PaQx
         LNKg==
X-Gm-Message-State: AOAM530OldSDGW4/DfxcrMhHtzjPGrbtjdklzXzYkq9MwtxQnMcN9APs
        8tVJ2fAQN2L2YtEhretNL9ScGnGKwjQ=
X-Google-Smtp-Source: ABdhPJzahu7dK8CXZkrET96cxCqxy1w1IMAjcM/NOYJ2blVcwCnQar8eRw00EHreXFTYa6+ruT/BfQ==
X-Received: by 2002:ac8:7485:: with SMTP id v5mr19534471qtq.31.1616949038442;
        Sun, 28 Mar 2021 09:30:38 -0700 (PDT)
Received: from shane-XPS-13-9380.attlocal.net ([2600:1700:4ca1:ade0:d373:7d57:15e2:e5f6])
        by smtp.gmail.com with ESMTPSA id 124sm11242265qkn.121.2021.03.28.09.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 09:30:37 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v2] net: x25: Queue received packets in the drivers instead of per-CPU queues
Date:   Sun, 28 Mar 2021 09:30:30 -0700
Message-Id: <20210328163030.604227-1-xie.he.0141@gmail.com>
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

Change from v1:
Drop all PFMEMALLOC skbs because we cannot handle them.

Change from RFC (March 5, 2021):
Rebased onto the latest net-next.

Martin Schiller has acked the RFC version.

---
 Documentation/networking/x25-iface.rst | 65 ++++----------------------
 drivers/net/wan/hdlc_x25.c             | 37 ++++++++++++++-
 drivers/net/wan/lapbether.c            | 59 +++++++++++++++++++++--
 3 files changed, 100 insertions(+), 61 deletions(-)

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
index 5a6a945f6c81..849e71f6466f 100644
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
 
 
@@ -71,12 +92,18 @@ static void x25_disconnected(struct net_device *dev, int reason)
 
 static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct x25_state *x25st = state(dev_to_hdlc(dev));
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	if (skb_pfmemalloc(skb)) {
+		netdev_err(dev, "out of memory\n");
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 
@@ -84,7 +111,10 @@ static int x25_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&x25st->rx_queue, skb);
+	tasklet_schedule(&x25st->rx_tasklet);
+	return NET_RX_SUCCESS;
 }
 
 
@@ -223,6 +253,7 @@ static void x25_close(struct net_device *dev)
 	spin_unlock_bh(&x25st->up_lock);
 
 	lapb_unregister(dev);
+	tasklet_kill(&x25st->rx_tasklet);
 }
 
 
@@ -338,6 +369,8 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		state(hdlc)->up = false;
 		spin_lock_init(&state(hdlc)->up_lock);
+		skb_queue_head_init(&state(hdlc)->rx_queue);
+		tasklet_setup(&state(hdlc)->rx_tasklet, x25_rx_queue_kick);
 
 		/* There's no header_ops so hard_header_len should be 0. */
 		dev->hard_header_len = 0;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 45d74285265a..e2cb1cb568da 100644
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
@@ -135,12 +156,18 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 
 static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 
 	if (skb_cow(skb, 1)) {
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	if (skb_pfmemalloc(skb)) {
+		pr_err("out of memory\n");
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb_push(skb, 1);
 
@@ -148,7 +175,10 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 	*ptr = X25_IFACE_DATA;
 
 	skb->protocol = x25_type_trans(skb, dev);
-	return netif_rx(skb);
+
+	skb_queue_tail(&lapbeth->rx_queue, skb);
+	napi_schedule(&lapbeth->napi);
+	return NET_RX_SUCCESS;
 }
 
 /*
@@ -233,6 +263,7 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 static void lapbeth_connected(struct net_device *dev, int reason)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	unsigned char *ptr;
 	struct sk_buff *skb = dev_alloc_skb(1);
 
@@ -240,16 +271,24 @@ static void lapbeth_connected(struct net_device *dev, int reason)
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
 
@@ -257,12 +296,19 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
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
@@ -293,6 +339,8 @@ static int lapbeth_open(struct net_device *dev)
 	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
+	napi_enable(&lapbeth->napi);
+
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
@@ -317,6 +365,8 @@ static int lapbeth_close(struct net_device *dev)
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
+	napi_disable(&lapbeth->napi);
+
 	return 0;
 }
 
@@ -374,6 +424,9 @@ static int lapbeth_new_device(struct net_device *dev)
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

