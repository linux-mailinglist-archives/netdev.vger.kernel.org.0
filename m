Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685EB340D41
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhCRSib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232671AbhCRSiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72D5C64F1B;
        Thu, 18 Mar 2021 18:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092690;
        bh=yQUVwOpkiph5wccZcfYbX3J5ID9EbhE5EUUiTUovx3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqtOCmxcI+xwC3KolV9Z5M7aSJZEAOi3SMlcxQyqPC5mTFz2ZIo04fEgDsBxQsAmG
         cp/RZL7EdMdseGvhE44Vjw2y6WqzCqVL00G7fDQrtvxum+2dLqV+EbUoWSGtAZ/UGK
         jVKSb3BpAJd8W7csQGEecH2Nszs4aFhkR+9HX/J1tWTtEEuve2oIGmPP9ekTd68ai7
         Kf+DuHZ6MbLlikVMnjemtet3rxKsB7n2mq8NHd0FiuVkl7WTjnT6+oFw3MKXJ2e4DM
         1sbjv5SLy+60GUMeyf4cNz5M/PpSqIwDF0fEPzwP05M+LhcTuWC5ouddZSFSOKx6SA
         kFP8rXIYfolrw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 05/13] net: embed nr_ids in the xps maps
Date:   Thu, 18 Mar 2021 19:37:44 +0100
Message-Id: <20210318183752.2612563-6-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Embed nr_ids (the number of cpu for the xps cpus map, and the number of
rxqs for the xps cpus map) in dev_maps. That will help not accessing out
of bound memory if those values change after dev_maps was allocated.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h |  4 ++++
 net/core/dev.c            | 45 ++++++++++++++++++---------------------
 net/core/net-sysfs.c      | 38 +++++++++++++++++++--------------
 3 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c38534c55ea1..09e73f5a8c78 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -772,6 +772,9 @@ struct xps_map {
 /*
  * This structure holds all XPS maps for device.  Maps are indexed by CPU.
  *
+ * We keep track of the number of cpus/rxqs used when the struct is allocated,
+ * in nr_ids. This will help not accessing out-of-bound memory.
+ *
  * We keep track of the number of traffic classes used when the struct is
  * allocated, in num_tc. This will be used to navigate the maps, to ensure we're
  * not crossing its upper bound, as the original dev->num_tc can be updated in
@@ -779,6 +782,7 @@ struct xps_map {
  */
 struct xps_dev_maps {
 	struct rcu_head rcu;
+	unsigned int nr_ids;
 	s16 num_tc;
 	struct xps_map __rcu *attr_map[]; /* Either CPUs map or RXQs map */
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 4e29d1994fdd..7530c95970a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2524,14 +2524,14 @@ static void reset_xps_maps(struct net_device *dev,
 }
 
 static void clean_xps_maps(struct net_device *dev, const unsigned long *mask,
-			   struct xps_dev_maps *dev_maps, unsigned int nr_ids,
-			   u16 offset, u16 count, bool is_rxqs_map)
+			   struct xps_dev_maps *dev_maps, u16 offset, u16 count,
+			   bool is_rxqs_map)
 {
+	unsigned int nr_ids = dev_maps->nr_ids;
 	bool active = false;
 	int i, j;
 
-	for (j = -1; j = netif_attrmask_next(j, mask, nr_ids),
-	     j < nr_ids;)
+	for (j = -1; j = netif_attrmask_next(j, mask, nr_ids), j < nr_ids;)
 		active |= remove_xps_queue_cpu(dev, dev_maps, j, offset,
 					       count);
 	if (!active)
@@ -2551,7 +2551,6 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 {
 	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
-	unsigned int nr_ids;
 
 	if (!static_key_false(&xps_needed))
 		return;
@@ -2561,11 +2560,9 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
 	if (static_key_false(&xps_rxqs_needed)) {
 		dev_maps = xmap_dereference(dev->xps_rxqs_map);
-		if (dev_maps) {
-			nr_ids = dev->num_rx_queues;
-			clean_xps_maps(dev, possible_mask, dev_maps, nr_ids,
-				       offset, count, true);
-		}
+		if (dev_maps)
+			clean_xps_maps(dev, possible_mask, dev_maps, offset,
+				       count, true);
 	}
 
 	dev_maps = xmap_dereference(dev->xps_cpus_map);
@@ -2574,9 +2571,7 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
 	if (num_possible_cpus() > 1)
 		possible_mask = cpumask_bits(cpu_possible_mask);
-	nr_ids = nr_cpu_ids;
-	clean_xps_maps(dev, possible_mask, dev_maps, nr_ids, offset, count,
-		       false);
+	clean_xps_maps(dev, possible_mask, dev_maps, offset, count, false);
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
@@ -2673,11 +2668,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		maps_sz = L1_CACHE_BYTES;
 
 	/* The old dev_maps could be larger or smaller than the one we're
-	 * setting up now, as dev->num_tc could have been updated in between. We
-	 * could try to be smart, but let's be safe instead and only copy
-	 * foreign traffic classes if the two map sizes match.
+	 * setting up now, as dev->num_tc or nr_ids could have been updated in
+	 * between. We could try to be smart, but let's be safe instead and only
+	 * copy foreign traffic classes if the two map sizes match.
 	 */
-	if (dev_maps && dev_maps->num_tc == num_tc)
+	if (dev_maps &&
+	    dev_maps->num_tc == num_tc && dev_maps->nr_ids == nr_ids)
 		copy = true;
 
 	/* allocate memory for queue storage */
@@ -2690,6 +2686,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 				return -ENOMEM;
 			}
 
+			new_dev_maps->nr_ids = nr_ids;
 			new_dev_maps->num_tc = num_tc;
 		}
 
@@ -2770,7 +2767,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	     j < dev_maps->nr_ids;) {
 		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
@@ -2804,12 +2801,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_maps;
 
 	/* removes tx-queue from unused CPUs/rx-queues */
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = -1; j = netif_attrmask_next(j, possible_mask, dev_maps->nr_ids),
+	     j < dev_maps->nr_ids;) {
 		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
 			active |= remove_xps_queue(dev_maps, tci, index);
-		if (!netif_attr_test_mask(j, mask, nr_ids) ||
-		    !netif_attr_test_online(j, online_mask, nr_ids))
+		if (!netif_attr_test_mask(j, mask, dev_maps->nr_ids) ||
+		    !netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
 			active |= remove_xps_queue(dev_maps, tci, index);
 		for (i = dev_maps->num_tc - tc, tci++; --i; tci++)
 			active |= remove_xps_queue(dev_maps, tci, index);
@@ -3965,7 +3962,7 @@ static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 	struct xps_map *map;
 	int queue_index = -1;
 
-	if (tc >= dev_maps->num_tc)
+	if (tc >= dev_maps->num_tc || tci >= dev_maps->nr_ids)
 		return queue_index;
 
 	tci *= dev_maps->num_tc;
@@ -4004,7 +4001,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 	if (dev_maps) {
 		int tci = sk_rx_queue_get(sk);
 
-		if (tci >= 0 && tci < dev->num_rx_queues)
+		if (tci >= 0)
 			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
 							  tci);
 	}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 1364d0f39cb0..bb08bdc88fa9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1366,9 +1366,9 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 {
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	unsigned int index, nr_ids;
 	int j, len, ret, tc = 0;
 	unsigned long *mask;
-	unsigned int index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1387,19 +1387,20 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 		goto err_rtnl_unlock;
 	}
 
-	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
+	rcu_read_lock();
+	dev_maps = rcu_dereference(dev->xps_cpus_map);
+	nr_ids = dev_maps ? dev_maps->nr_ids : nr_cpu_ids;
+
+	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
 	if (!mask) {
 		ret = -ENOMEM;
-		goto err_rtnl_unlock;
+		goto err_rcu_unlock;
 	}
 
-	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_cpus_map);
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, NULL, nr_cpu_ids),
-	     j < nr_cpu_ids;) {
+	for (j = -1; j = netif_attrmask_next(j, NULL, nr_ids), j < nr_ids;) {
 		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
@@ -1419,10 +1420,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	rtnl_unlock();
 
-	len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
+	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
 
+err_rcu_unlock:
+	rcu_read_unlock();
 err_rtnl_unlock:
 	rtnl_unlock();
 	return ret;
@@ -1473,9 +1476,9 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	unsigned int index, nr_ids;
 	int j, len, ret, tc = 0;
 	unsigned long *mask;
-	unsigned int index;
 
 	index = get_netdev_queue_index(queue);
 
@@ -1488,19 +1491,20 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 		goto err_rtnl_unlock;
 	}
 
-	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
+	rcu_read_lock();
+	dev_maps = rcu_dereference(dev->xps_rxqs_map);
+	nr_ids = dev_maps ? dev_maps->nr_ids : dev->num_rx_queues;
+
+	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
 	if (!mask) {
 		ret = -ENOMEM;
-		goto err_rtnl_unlock;
+		goto err_rcu_unlock;
 	}
 
-	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_rxqs_map);
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, NULL, dev->num_rx_queues),
-	     j < dev->num_rx_queues;) {
+	for (j = -1; j = netif_attrmask_next(j, NULL, nr_ids), j < nr_ids;) {
 		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
@@ -1520,11 +1524,13 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 	rtnl_unlock();
 
-	len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
+	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
 
 	return len < PAGE_SIZE ? len : -EINVAL;
 
+err_rcu_unlock:
+	rcu_read_unlock();
 err_rtnl_unlock:
 	rtnl_unlock();
 	return ret;
-- 
2.30.2

