Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B07A2E011D
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgLUThe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLUThe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:37:34 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v2 2/3] net: move the xps cpus retrieval out of net-sysfs
Date:   Mon, 21 Dec 2020 20:36:43 +0100
Message-Id: <20201221193644.1296933-3-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221193644.1296933-1-atenart@kernel.org>
References: <20201221193644.1296933-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accesses to dev->xps_cpus_map (when using dev->num_tc) should be
protected by the xps_map mutex, to avoid possible race conditions when
dev->num_tc is updated while the map is accessed. This patch moves the
logic accessing dev->xps_cpu_map and dev->num_tc to net/core/dev.c,
where the xps_map mutex is defined and used.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h |  8 ++++++
 net/core/dev.c            | 59 +++++++++++++++++++++++++++++++++++++++
 net/core/net-sysfs.c      | 54 ++++++++---------------------------
 3 files changed, 79 insertions(+), 42 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 259be67644e3..bfd6cfa3ea90 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3671,6 +3671,8 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 			u16 index);
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map);
+int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
+			 u16 index);
 
 /**
  *	netif_attr_test_mask - Test a CPU or Rx queue set in a mask
@@ -3769,6 +3771,12 @@ static inline int __netif_set_xps_queue(struct net_device *dev,
 {
 	return 0;
 }
+
+static inline int netif_show_xps_queue(struct net_device *dev,
+				       unsigned long **mask, u16 index)
+{
+	return 0;
+}
 #endif
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index effdb7fee9df..a0257da4160a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2831,6 +2831,65 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 }
 EXPORT_SYMBOL(netif_set_xps_queue);
 
+int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
+			 u16 index)
+{
+	const unsigned long *possible_mask = NULL;
+	int j, num_tc = 1, tc = 0, ret = 0;
+	struct xps_dev_maps *dev_maps;
+	unsigned int nr_ids;
+
+	rcu_read_lock();
+	mutex_lock(&xps_map_mutex);
+
+	if (dev->num_tc) {
+		num_tc = dev->num_tc;
+		if (num_tc < 0) {
+			ret = -EINVAL;
+			goto out_no_map;
+		}
+
+		/* If queue belongs to subordinate dev use its map */
+		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
+
+		tc = netdev_txq_to_tc(dev, index);
+		if (tc < 0) {
+			ret = -EINVAL;
+			goto out_no_map;
+		}
+	}
+
+	dev_maps = rcu_dereference(dev->xps_cpus_map);
+	if (!dev_maps)
+		goto out_no_map;
+	nr_ids = nr_cpu_ids;
+	if (num_possible_cpus() > 1)
+		possible_mask = cpumask_bits(cpu_possible_mask);
+
+	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
+	     j < nr_ids;) {
+		int i, tci = j * num_tc + tc;
+		struct xps_map *map;
+
+		map = rcu_dereference(dev_maps->attr_map[tci]);
+		if (!map)
+			continue;
+
+		for (i = map->len; i--;) {
+			if (map->queues[i] == index) {
+				set_bit(j, *mask);
+				break;
+			}
+		}
+	}
+
+out_no_map:
+	mutex_unlock(&xps_map_mutex);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(netif_show_xps_queue);
 #endif
 
 static void __netdev_unbind_sb_channel(struct net_device *dev,
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 999b70c59761..29ee69b67972 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1314,60 +1314,30 @@ static const struct attribute_group dql_group = {
 #endif /* CONFIG_BQL */
 
 #ifdef CONFIG_XPS
-static ssize_t xps_cpus_show(struct netdev_queue *queue,
-			     char *buf)
+static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
 {
 	struct net_device *dev = queue->dev;
-	int cpu, len, num_tc = 1, tc = 0;
-	struct xps_dev_maps *dev_maps;
-	cpumask_var_t mask;
-	unsigned long index;
+	unsigned long *mask, index;
+	int len, ret;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
 
 	index = get_netdev_queue_index(queue);
 
-	if (dev->num_tc) {
-		/* Do not allow XPS on subordinate device directly */
-		num_tc = dev->num_tc;
-		if (num_tc < 0)
-			return -EINVAL;
-
-		/* If queue belongs to subordinate dev use its map */
-		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
-
-		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
-	}
-
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
+	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
+	if (!mask)
 		return -ENOMEM;
 
-	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_cpus_map);
-	if (dev_maps) {
-		for_each_possible_cpu(cpu) {
-			int i, tci = cpu * num_tc + tc;
-			struct xps_map *map;
-
-			map = rcu_dereference(dev_maps->attr_map[tci]);
-			if (!map)
-				continue;
-
-			for (i = map->len; i--;) {
-				if (map->queues[i] == index) {
-					cpumask_set_cpu(cpu, mask);
-					break;
-				}
-			}
-		}
+	ret = netif_show_xps_queue(dev, &mask, index);
+	if (ret) {
+		bitmap_free(mask);
+		return ret;
 	}
-	rcu_read_unlock();
 
-	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
-	free_cpumask_var(mask);
+	len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
+	bitmap_free(mask);
+
 	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
-- 
2.29.2

