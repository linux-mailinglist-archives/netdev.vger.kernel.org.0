Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492335C50E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGAVi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:38:57 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40277 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:38:57 -0400
Received: by mail-pl1-f201.google.com with SMTP id 91so7876331pla.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Nyh8E1HY6vj9p85/o0XGEaEVkuOIdVvLnsWWM9nvnG0=;
        b=oL9Fv6Z1qscU/HjXtwNvCYTcmBw3AyEBjCR2WdQMAuP4/LKPY/VtMoU7KIJZBRK6N5
         gX8cy69wZbnKzhkS4oVfn3bzmQaCObsVhYRMBCkExl9wEIT8ASJbgNacel9dA7wifzhq
         y2wUgxNkQiaCX1iMoiCFDYV35USo0zQc5+KrYVnRs2mB0riTcpvesUXZmDpROiZkPPy6
         C+BJjj7QeIqmBRUUmCkjkBL4l3q9zKTtd+hYifoMCqAfIARhPfHKZGiCiKsIbjUvASCg
         +MrNDcKNj9WfXGoiKSeRmmrmJyqJKAEPi6SjO2p7Z3NXzOhQe9MHWZVSn0shZ3SlXs1G
         +nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Nyh8E1HY6vj9p85/o0XGEaEVkuOIdVvLnsWWM9nvnG0=;
        b=XTP+BG0Y93hO1rCLYaEeAZ0OqNid7/sL2OcD+GZXov6OdrK8hF4uv/HakN1gaGbJ93
         qUWyWJzPF5C9Rla6xH2wKuO8lq2feF6nk3uBDwjRxox11J3hdiiCr++UplKVAxj5FtPQ
         mB+CpB5KUNepl5ZGdZVprKIef4FJ1je5zKzhvnbkbBVDrG8SvMXp5NZ5Bd3MdJ9Vet//
         shGBl6kNVIrLT0pY5e76diY+C3Ds4q8AAdQ75B6e5L+S3P8tFsKJ4KVYf4/Ddir30Q++
         f5xItTNALZSZ8ijF0T2HJlaNhJxr6ugdH9sqshZl4ecaWXoyLJ0CROWPaM1ZMJg+QXhb
         yvPA==
X-Gm-Message-State: APjAAAWFODCSQERwPaN1/Wc0RTizRY1T9D7fdFvVf2V97JYkQq8yvSzG
        J+vp8tLcrFMAoMSuRabZ67nJB2n7pGOzXdKUcBfVP/hyRnRahB6CBtC73y/TjntxWF1RjqW0SyR
        j9PfjQN48xi59qHfTNv4pJjsUKHlUrUCzPrnY8YdhpDFybU7TJwNdW0kSGZiRwGRU
X-Google-Smtp-Source: APXvYqzKI5XfiIUj6rSIGpSkl0jCDLKLg8peZ5bBmxq0i8oxDwbaDxoBNeUi/7yEk9rWwgIP2Jc2yw39T29x
X-Received: by 2002:a63:62c5:: with SMTP id w188mr15326770pgb.129.1562017135982;
 Mon, 01 Jul 2019 14:38:55 -0700 (PDT)
Date:   Mon,  1 Jul 2019 14:38:49 -0700
Message-Id: <20190701213849.102759-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv3 next 1/3] loopback: create blackhole net device similar to loopack.
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
v1->v2->v3
  no change

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

