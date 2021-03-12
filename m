Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208723390B6
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhCLPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231861AbhCLPFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AFF464F77;
        Fri, 12 Mar 2021 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561509;
        bh=q7O3DGm7YSwdgyPAPW4Ree6m04AlcNdO4tkr4bEDEFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfyj/3/Ls0AOcXw1eKoViL19vg7KMSxKshpfftLmXAA07o2FEcGV8zJJIxqe8Gh98
         mw80zxXDaFD+/HtS2Ow/VTut+VIgs7gaH20p/aHScyWfUrwaIXTxfn4PPBkshs5jK+
         lg5uFmuMGnX9TZZ32P9REEC1KE7XVl49Kul46Au65Dh8dprfZXtl3igsETsvMSRCh5
         joucEBwf4lCIajdnOC4MsP+5TLFe07AYxYE0lYi/FrRmDm8UV1lQ+pB1V2BaJ71usC
         4RJvhRhdHKmca1Aw182L6/QyaIgeeC15taYc5BPLX03zqLp1B4Br3hxpkUlbKkWJiD
         tslSPY1TeWoCw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 08/16] net: move the xps maps to an array
Date:   Fri, 12 Mar 2021 16:04:36 +0100
Message-Id: <20210312150444.355207-9-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the xps maps (xps_cpus_map and xps_rxqs_map) to an array in
net_device. That will simplify a lot the code removing the need for lots
of if/else conditionals as the correct map will be available using its
offset in the array.

This should not modify the xps maps behaviour in any way.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/virtio_net.c  |  2 +-
 include/linux/netdevice.h | 17 +++++----
 net/core/dev.c            | 73 +++++++++++++++++----------------------
 net/core/net-sysfs.c      |  6 ++--
 4 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e97288dd6e5a..dde9bbcc5ff0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2015,7 +2015,7 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
 		}
 		virtqueue_set_affinity(vi->rq[i].vq, mask);
 		virtqueue_set_affinity(vi->sq[i].vq, mask);
-		__netif_set_xps_queue(vi->dev, cpumask_bits(mask), i, false);
+		__netif_set_xps_queue(vi->dev, cpumask_bits(mask), i, XPS_CPUS);
 		cpumask_clear(mask);
 	}
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5c9e056a0e2d..bcd15a2d3ddc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -754,6 +754,13 @@ struct rx_queue_attribute {
 			 const char *buf, size_t len);
 };
 
+/* XPS map type and offset of the xps map within net_device->xps_maps[]. */
+enum xps_map_type {
+	XPS_CPUS = 0,
+	XPS_RXQS,
+	XPS_MAPS_MAX,
+};
+
 #ifdef CONFIG_XPS
 /*
  * This structure holds an XPS map which can be of variable length.  The
@@ -1773,8 +1780,7 @@ enum netdev_ml_priv_type {
  *	@tx_queue_len:		Max frames per queue allowed
  *	@tx_global_lock: 	XXX: need comments on this one
  *	@xdp_bulkq:		XDP device bulk queue
- *	@xps_cpus_map:		all CPUs map for XPS device
- *	@xps_rxqs_map:		all RXQs map for XPS device
+ *	@xps_maps:		all CPUs/RXQs maps for XPS device
  *
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
@@ -2070,8 +2076,7 @@ struct net_device {
 	struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
 
 #ifdef CONFIG_XPS
-	struct xps_dev_maps __rcu *xps_cpus_map;
-	struct xps_dev_maps __rcu *xps_rxqs_map;
+	struct xps_dev_maps __rcu *xps_maps[XPS_MAPS_MAX];
 #endif
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
@@ -3701,7 +3706,7 @@ static inline void netif_wake_subqueue(struct net_device *dev, u16 queue_index)
 int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 			u16 index);
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
-			  u16 index, bool is_rxqs_map);
+			  u16 index, enum xps_map_type type);
 
 /**
  *	netif_attr_test_mask - Test a CPU or Rx queue set in a mask
@@ -3796,7 +3801,7 @@ static inline int netif_set_xps_queue(struct net_device *dev,
 
 static inline int __netif_set_xps_queue(struct net_device *dev,
 					const unsigned long *mask,
-					u16 index, bool is_rxqs_map)
+					u16 index, enum xps_map_type type)
 {
 	return 0;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 241f440b306a..dfdd476a6d67 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2511,31 +2511,34 @@ static bool remove_xps_queue_cpu(struct net_device *dev,
 
 static void reset_xps_maps(struct net_device *dev,
 			   struct xps_dev_maps *dev_maps,
-			   bool is_rxqs_map)
+			   enum xps_map_type type)
 {
-	if (is_rxqs_map) {
-		static_key_slow_dec_cpuslocked(&xps_rxqs_needed);
-		RCU_INIT_POINTER(dev->xps_rxqs_map, NULL);
-	} else {
-		RCU_INIT_POINTER(dev->xps_cpus_map, NULL);
-	}
 	static_key_slow_dec_cpuslocked(&xps_needed);
+	if (type == XPS_RXQS)
+		static_key_slow_dec_cpuslocked(&xps_rxqs_needed);
+
+	RCU_INIT_POINTER(dev->xps_maps[type], NULL);
+
 	kfree_rcu(dev_maps, rcu);
 }
 
-static void clean_xps_maps(struct net_device *dev,
-			   struct xps_dev_maps *dev_maps, u16 offset, u16 count,
-			   bool is_rxqs_map)
+static void clean_xps_maps(struct net_device *dev, enum xps_map_type type,
+			   u16 offset, u16 count)
 {
+	struct xps_dev_maps *dev_maps;
 	bool active = false;
 	int i, j;
 
+	dev_maps = xmap_dereference(dev->xps_maps[type]);
+	if (!dev_maps)
+		return;
+
 	for (j = 0; j < dev_maps->nr_ids; j++)
 		active |= remove_xps_queue_cpu(dev, dev_maps, j, offset, count);
 	if (!active)
-		reset_xps_maps(dev, dev_maps, is_rxqs_map);
+		reset_xps_maps(dev, dev_maps, type);
 
-	if (!is_rxqs_map) {
+	if (type == XPS_CPUS) {
 		for (i = offset + (count - 1); count--; i--)
 			netdev_queue_numa_node_write(
 				netdev_get_tx_queue(dev, i), NUMA_NO_NODE);
@@ -2545,27 +2548,17 @@ static void clean_xps_maps(struct net_device *dev,
 static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 				   u16 count)
 {
-	struct xps_dev_maps *dev_maps;
-
 	if (!static_key_false(&xps_needed))
 		return;
 
 	cpus_read_lock();
 	mutex_lock(&xps_map_mutex);
 
-	if (static_key_false(&xps_rxqs_needed)) {
-		dev_maps = xmap_dereference(dev->xps_rxqs_map);
-		if (dev_maps)
-			clean_xps_maps(dev, dev_maps, offset, count, true);
-	}
-
-	dev_maps = xmap_dereference(dev->xps_cpus_map);
-	if (!dev_maps)
-		goto out_no_maps;
+	if (static_key_false(&xps_rxqs_needed))
+		clean_xps_maps(dev, XPS_RXQS, offset, count);
 
-	clean_xps_maps(dev, dev_maps, offset, count, false);
+	clean_xps_maps(dev, XPS_CPUS, offset, count);
 
-out_no_maps:
 	mutex_unlock(&xps_map_mutex);
 	cpus_read_unlock();
 }
@@ -2617,7 +2610,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 
 /* Must be called under rtnl_lock and cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
-			  u16 index, bool is_rxqs_map)
+			  u16 index, enum xps_map_type type)
 {
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
 	const unsigned long *online_mask = NULL;
@@ -2644,15 +2637,15 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	}
 
 	mutex_lock(&xps_map_mutex);
-	if (is_rxqs_map) {
+
+	dev_maps = xmap_dereference(dev->xps_maps[type]);
+	if (type == XPS_RXQS) {
 		maps_sz = XPS_RXQ_DEV_MAPS_SIZE(num_tc, dev->num_rx_queues);
-		dev_maps = xmap_dereference(dev->xps_rxqs_map);
 		nr_ids = dev->num_rx_queues;
 	} else {
 		maps_sz = XPS_CPU_DEV_MAPS_SIZE(num_tc);
 		if (num_possible_cpus() > 1)
 			online_mask = cpumask_bits(cpu_online_mask);
-		dev_maps = xmap_dereference(dev->xps_cpus_map);
 		nr_ids = nr_cpu_ids;
 	}
 
@@ -2685,7 +2678,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		tci = j * num_tc + tc;
 		map = copy ? xmap_dereference(dev_maps->attr_map[tci]) : NULL;
 
-		map = expand_xps_map(map, j, index, is_rxqs_map);
+		map = expand_xps_map(map, j, index, type == XPS_RXQS);
 		if (!map)
 			goto error;
 
@@ -2698,7 +2691,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (!dev_maps) {
 		/* Increment static keys at most once per type */
 		static_key_slow_inc_cpuslocked(&xps_needed);
-		if (is_rxqs_map)
+		if (type == XPS_RXQS)
 			static_key_slow_inc_cpuslocked(&xps_rxqs_needed);
 	}
 
@@ -2727,7 +2720,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			if (pos == map->len)
 				map->queues[map->len++] = index;
 #ifdef CONFIG_NUMA
-			if (!is_rxqs_map) {
+			if (type == XPS_CPUS) {
 				if (numa_node_id == -2)
 					numa_node_id = cpu_to_node(j);
 				else if (numa_node_id != cpu_to_node(j))
@@ -2748,10 +2741,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		}
 	}
 
-	if (is_rxqs_map)
-		rcu_assign_pointer(dev->xps_rxqs_map, new_dev_maps);
-	else
-		rcu_assign_pointer(dev->xps_cpus_map, new_dev_maps);
+	rcu_assign_pointer(dev->xps_maps[type], new_dev_maps);
 
 	/* Cleanup old maps */
 	if (!dev_maps)
@@ -2780,12 +2770,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	active = true;
 
 out_no_new_maps:
-	if (!is_rxqs_map) {
+	if (type == XPS_CPUS)
 		/* update Tx queue numa node */
 		netdev_queue_numa_node_write(netdev_get_tx_queue(dev, index),
 					     (numa_node_id >= 0) ?
 					     numa_node_id : NUMA_NO_NODE);
-	}
 
 	if (!dev_maps)
 		goto out_no_maps;
@@ -2803,7 +2792,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	/* free map if not active */
 	if (!active)
-		reset_xps_maps(dev, dev_maps, is_rxqs_map);
+		reset_xps_maps(dev, dev_maps, type);
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
@@ -2835,7 +2824,7 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 	int ret;
 
 	cpus_read_lock();
-	ret =  __netif_set_xps_queue(dev, cpumask_bits(mask), index, false);
+	ret =  __netif_set_xps_queue(dev, cpumask_bits(mask), index, XPS_CPUS);
 	cpus_read_unlock();
 
 	return ret;
@@ -3985,7 +3974,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 	if (!static_key_false(&xps_rxqs_needed))
 		goto get_cpus_map;
 
-	dev_maps = rcu_dereference(sb_dev->xps_rxqs_map);
+	dev_maps = rcu_dereference(sb_dev->xps_maps[XPS_RXQS]);
 	if (dev_maps) {
 		int tci = sk_rx_queue_get(sk);
 
@@ -3996,7 +3985,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 
 get_cpus_map:
 	if (queue_index < 0) {
-		dev_maps = rcu_dereference(sb_dev->xps_cpus_map);
+		dev_maps = rcu_dereference(sb_dev->xps_maps[XPS_CPUS]);
 		if (dev_maps) {
 			unsigned int tci = skb->sender_cpu - 1;
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c762c435ff76..ca1f3b63cfad 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1388,7 +1388,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	}
 
 	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_cpus_map);
+	dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);
 	nr_ids = dev_maps ? dev_maps->nr_ids : nr_cpu_ids;
 
 	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
@@ -1492,7 +1492,7 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	}
 
 	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_rxqs_map);
+	dev_maps = rcu_dereference(dev->xps_maps[XPS_RXQS]);
 	nr_ids = dev_maps ? dev_maps->nr_ids : dev->num_rx_queues;
 
 	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
@@ -1566,7 +1566,7 @@ static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
 	}
 
 	cpus_read_lock();
-	err = __netif_set_xps_queue(dev, mask, index, true);
+	err = __netif_set_xps_queue(dev, mask, index, XPS_RXQS);
 	cpus_read_unlock();
 
 	rtnl_unlock();
-- 
2.29.2

