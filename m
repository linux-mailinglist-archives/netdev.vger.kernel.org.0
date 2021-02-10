Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68431316CF7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhBJRi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhBJRhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:37:09 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB1EC061788;
        Wed, 10 Feb 2021 09:35:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id nm1so1507092pjb.3;
        Wed, 10 Feb 2021 09:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXiWXS+ItGfo45/5tHO26C3RlXyNypOLSac5INY45I=;
        b=u53EBIGpvxNsrbvvNljPgLTSlplNxHyMG9jF80LzjhnHVJflgqqlOg+CUhtYTh+lzf
         zOQrP1EJoJQ5f5hdFuES3Hfnhs/2SHyi6/wGVjgvPgSWjqza+xC61xhb9o+mbvel3tb5
         C4pXFbtwmpsfEct+H+ndkf6KtBZ/XGJyJgHxTJkzN+tsyPbehAGcRSfcSP2cwYj1JXN8
         10H+K0wl8cnjjez5THzXIbQpLu3Q7s/dnQrCN7PZ5LIfchm9T7WiTLqta3z2MhbZmtP1
         deRtaRf3ZhWNl3c/ckg9aunMZs34fJiGzymsFiSI9kgwTgM5SOOeIYhlUL9kOAjz8ZlT
         O1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXiWXS+ItGfo45/5tHO26C3RlXyNypOLSac5INY45I=;
        b=XkmkZ9k61Xu6nyG93329fObuhpJ9DD3Z8GFtaA2xIsBfh3tGhcIDy5hWPaByYJXQXX
         z4ccxONTRCNIrYd8GEcEsveLwiM1MUxum86/oFrcOoQvId1f0zQjJJfZIhMDkoMoei3C
         CYOUpGeUK2tTlpCdgU9UA067RMCL9cffdl8yWMw92zMntZJuN6eW4EcnbZ29/9e54UWY
         DPVrhnSnf9etupdFn8Oh8LkJT2amOD1C/2QhBLA/3o2EKINlkdyAbhzt8kzWi9OrkWVz
         GOotk5jLAWSm61x8Nsl6kKhXsK7txVFpHFOKyVk4QfrlKR9lnkAbRA9NF5NYjv6Bw/qr
         9RJg==
X-Gm-Message-State: AOAM532Yx0XpAaRkyXGJ9y1Ck28eWxudk+7AB2Xk02fehYbHC61GxPTA
        CmDO03vWJ39arRGy1mqYx5I=
X-Google-Smtp-Source: ABdhPJzynwql63LfUWTwIyIvZQX98AgIn2YoRE18JzOg0kx1gVXMa9N4h+4MafoK4FXbLnn4vlbEEg==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr8153pjb.118.1612978537532;
        Wed, 10 Feb 2021 09:35:37 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:7081:cb2d:3ff7:9803])
        by smtp.gmail.com with ESMTPSA id lw4sm2678040pjb.16.2021.02.10.09.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 09:35:37 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next RFC v2] net: hdlc_x25: Queue outgoing LAPB frames
Date:   Wed, 10 Feb 2021 09:35:32 -0800
Message-Id: <20210210173532.370914-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending packets, we will first hand over the (L3) packets to the
LAPB module, then the LAPB module will hand over the corresponding LAPB
(L2) frames back to us for us to transmit.

The LAPB module can also emit LAPB (L2) frames at any time without an
(L3) packet currently being sent, when it is trying to send (L3) packets
queued up in its internal queue, or when it decides to send some (L2)
control frame.

This means we need have a queue for these outgoing LAPB (L2) frames to
avoid congestion. This queue needs to be controlled by the hardware
drivers' netif_stop_queue and netif_wake_queue calls. So we need to use
a qdisc TX queue for this purpose.

On the other hand, the outgoing (L3) packets don't need to be queued,
because the LAPB module already has an internal queue for them.

However, currently the outgoing LAPB (L2) frames are not queued. This
can cause frames to be dropped by hardware drivers when they are busy.
At the same time the (L3) packets are being queued and controlled by
hardware drivers' netif_stop_queue and netif_wake_queue calls. This is
unnecessary and meaningless.

To solve this problem, we can split the HDLC device into two devices:
a virtual X.25 device and an actual HDLC device, using the virtual
X.25 device to send (L3) packets and using the actual HDLC device to
queue LAPB (L2) frames. The outgoing LAPB queue will be controlled by
hardware drivers' netif_stop_queue and netif_wake_queue calls, while
outgoing (L3) packets will not be affected by these calls.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---

Change from RFC v1:
Properly initialize state(hdlc)->x25_dev and state(hdlc)->x25_dev_lock.

---
 drivers/net/wan/hdlc_x25.c | 158 ++++++++++++++++++++++++++++++-------
 1 file changed, 129 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index bb164805804e..2a7b3c3d0c05 100644
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
 
 
@@ -163,17 +170,18 @@ static int x25_open(struct net_device *dev)
 		.data_indication = x25_data_indication,
 		.data_transmit = x25_data_transmit,
 	};
-	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct net_device *hdlc_dev = dev_to_x25(dev)->hdlc_dev;
+	hdlc_device *hdlc = dev_to_hdlc(hdlc_dev);
 	struct lapb_parms_struct params;
 	int result;
 
 	result = lapb_register(dev, &cb);
 	if (result != LAPB_OK)
-		return result;
+		return -ENOMEM;
 
 	result = lapb_getparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	if (state(hdlc)->settings.dce)
 		params.mode = params.mode | LAPB_DCE;
@@ -188,16 +196,104 @@ static int x25_open(struct net_device *dev)
 
 	result = lapb_setparms(dev, &params);
 	if (result != LAPB_OK)
-		return result;
+		return -EINVAL;
 
 	return 0;
 }
 
 
 
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
+	/* When transmitting data:
+	 * first we'll remove a pseudo header of 1 byte,
+	 * then the LAPB module will prepend an LAPB header of at most 3 bytes.
+	 */
+	x25_dev->needed_headroom = 3 - 1;
+	x25_dev->mtu = dev->mtu - (3 - 1);
+	dev_to_x25(x25_dev)->hdlc_dev = dev;
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
 
 
@@ -205,27 +301,38 @@ static void x25_close(struct net_device *dev)
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
 
@@ -298,16 +405,9 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
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

