Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1B04F2DD
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 02:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFVApf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 20:45:35 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:51615 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVApe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 20:45:34 -0400
Received: by mail-qk1-f201.google.com with SMTP id s25so9417464qkj.18
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sTDk3S9JzZt0ASSy5OGsWTZeBwZz9FXjYYt9px6OwsA=;
        b=In2BiNBn0kkUH3/cIsIxlIUSCoQS4wGJcOnpCTsp+/CxpQuTBB1LBMjOo9aDNa2dQR
         Ezfk3QR+b6qiSkmCXtcKTeNZ/HHXknTEk6surqMjsJKPkkkAVTKU5ZS6WNGQ/sf4KbGt
         QjLiuVs46xwYsx2Nu9pBmkXBfkc79532/ld0oVuEO2zmGhCAIm/jvfGiKwzkyA1geJUJ
         mG+BQYJxmcCdewZSGHwjrrMXM68JhCNbTmBT+a3mBZciluGvcuG1z+FrXmJvXPuVY0jI
         wIRtqLFo32B3xZuCpOCJUHqaaEBx8rZV+JLSgNJrTIu4B61RW1ezTbDnfRgMPV3oPMek
         4WEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sTDk3S9JzZt0ASSy5OGsWTZeBwZz9FXjYYt9px6OwsA=;
        b=k3ppavTsMIDEt31YIdEGc0SIRQnSv/tPYGRrAiK7cpOtZRteUmqS8hfHrqeF9l6Zj1
         ggCuQ04DsRi9Tkv+R7v4+gV9kUtI8H8sZSeafRD6EeQQ6Xg9+SsFUXz14pTnwnqLnF6E
         xvu1IN2sqymKnm+Gk7lFHmq094KCaVOqiTWQvaWhxNwGukOggSRMjXj3qujALWszvI08
         GIwRuevYSurEVbQtkbnk7WrBpL4raljk6wuIsi1e/1QAkOq1KKKSwIFgQ00EosB0b+kf
         bqXPy1w9uFaNaG4mD4XLnuHgTSqdcaZjELLfsw8PophOhA5OrTaKJvqBqNo4UBs7bkgl
         NYkw==
X-Gm-Message-State: APjAAAUsty9wJrd1BcjoKLJ7/ffizTgdJqmPKH9qdhj3bQPzmXJtctZL
        dG1nfClY5XCaMY4mNT7hWMbnakC3YAnE4AWxO9ea7jRumChbU6ujBm+Ygkjerr2vSlmqgGlS6l6
        gCfMYa4zfS7l6mKjPkAapMuXa6Px/bJ9umXiTl3IBOoGJxLlt/HL6IXyDF0yvmAk3
X-Google-Smtp-Source: APXvYqzKs4gL37RTdNM2W5KQoaFNTr0P4J9IsIwDa/jE7PcCZRweNuy1FGVIwWq9viZ3O+Oj3GF9DgEc1JxG
X-Received: by 2002:a37:9cf:: with SMTP id 198mr93231559qkj.351.1561164333335;
 Fri, 21 Jun 2019 17:45:33 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:45:25 -0700
Message-Id: <20190622004525.90270-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH next 1/3] loopback: create blackhole net device similar to loopack.
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a blackhole net device that can be used for "dead"
dst entries instead of loopback device. This blackhole device differs
from loopback in few aspects: (a) It's not per-ns. (b)  MTU on this
device is ETH_MIN_MTU (c) The xmit function is essentially kfree_skb().
and (d) since it's not registered it won't have ifindex.

Lower MTU effectively make the device not pass the MTU check during
the route check when a dst associated with the skb is dead.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/loopback.c    | 76 ++++++++++++++++++++++++++++++++++-----
 include/linux/netdevice.h |  2 ++
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 87d361666cdd..3b39def5471e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -55,6 +55,13 @@
 #include <net/net_namespace.h>
 #include <linux/u64_stats_sync.h>
 
+/* blackhole_netdev - a device used for dsts that are marked expired!
+ * This is global device (instead of per-net-ns) since it's not needed
+ * to be per-ns and gets initialized at boot time.
+ */
+struct net_device *blackhole_netdev;
+EXPORT_SYMBOL(blackhole_netdev);
+
 /* The higher levels take care of making this non-reentrant (it's
  * called with bh's disabled).
  */
@@ -150,12 +157,14 @@ static const struct net_device_ops loopback_ops = {
 	.ndo_set_mac_address = eth_mac_addr,
 };
 
-/* The loopback device is special. There is only one instance
- * per network namespace.
- */
-static void loopback_setup(struct net_device *dev)
+static void gen_lo_setup(struct net_device *dev,
+			 unsigned int mtu,
+			 const struct ethtool_ops *eth_ops,
+			 const struct header_ops *hdr_ops,
+			 const struct net_device_ops *dev_ops,
+			 void (*dev_destructor)(struct net_device *dev))
 {
-	dev->mtu		= 64 * 1024;
+	dev->mtu		= mtu;
 	dev->hard_header_len	= ETH_HLEN;	/* 14	*/
 	dev->min_header_len	= ETH_HLEN;	/* 14	*/
 	dev->addr_len		= ETH_ALEN;	/* 6	*/
@@ -174,11 +183,20 @@ static void loopback_setup(struct net_device *dev)
 		| NETIF_F_NETNS_LOCAL
 		| NETIF_F_VLAN_CHALLENGED
 		| NETIF_F_LOOPBACK;
-	dev->ethtool_ops	= &loopback_ethtool_ops;
-	dev->header_ops		= &eth_header_ops;
-	dev->netdev_ops		= &loopback_ops;
+	dev->ethtool_ops	= eth_ops;
+	dev->header_ops		= hdr_ops;
+	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
-	dev->priv_destructor	= loopback_dev_free;
+	dev->priv_destructor	= dev_destructor;
+}
+
+/* The loopback device is special. There is only one instance
+ * per network namespace.
+ */
+static void loopback_setup(struct net_device *dev)
+{
+	gen_lo_setup(dev, (64 * 1024), &loopback_ethtool_ops, &eth_header_ops,
+		     &loopback_ops, loopback_dev_free);
 }
 
 /* Setup and register the loopback device. */
@@ -213,3 +231,43 @@ static __net_init int loopback_net_init(struct net *net)
 struct pernet_operations __net_initdata loopback_net_ops = {
 	.init = loopback_net_init,
 };
+
+/* blackhole netdevice */
+static netdev_tx_t blackhole_netdev_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	kfree_skb(skb);
+	net_warn_ratelimited("%s(): Dropping skb.\n", __func__);
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops blackhole_netdev_ops = {
+	.ndo_start_xmit = blackhole_netdev_xmit,
+};
+
+/* This is a dst-dummy device used specifically for invalidated
+ * DSTs and unlike loopback, this is not per-ns.
+ */
+static void blackhole_netdev_setup(struct net_device *dev)
+{
+	gen_lo_setup(dev, ETH_MIN_MTU, NULL, NULL, &blackhole_netdev_ops, NULL);
+}
+
+/* Setup and register the blackhole_netdev. */
+static int __init blackhole_netdev_init(void)
+{
+	blackhole_netdev = alloc_netdev(0, "blackhole_dev", NET_NAME_UNKNOWN,
+					blackhole_netdev_setup);
+	if (!blackhole_netdev)
+		return -ENOMEM;
+
+	dev_init_scheduler(blackhole_netdev);
+	dev_activate(blackhole_netdev);
+
+	blackhole_netdev->flags |= IFF_UP | IFF_RUNNING;
+	dev_net_set(blackhole_netdev, &init_net);
+
+	return 0;
+}
+
+device_initcall(blackhole_netdev_init);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eeacebd7debb..88292953aa6f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4870,4 +4870,6 @@ do {								\
 #define PTYPE_HASH_SIZE	(16)
 #define PTYPE_HASH_MASK	(PTYPE_HASH_SIZE - 1)
 
+extern struct net_device *blackhole_netdev;
+
 #endif	/* _LINUX_NETDEVICE_H */
-- 
2.22.0.410.gd8fdbe21b5-goog

