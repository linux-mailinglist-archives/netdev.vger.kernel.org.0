Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CFA313ADC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhBHR0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhBHRVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9063264EA6;
        Mon,  8 Feb 2021 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804770;
        bh=TgEThL7y6epujVZk2PxTb0v4ijoBX6s69wh8m+atxBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMd1LLAgeRf0TqK5ZBUgmOgDu5GoeW48L+hYHePlGt/LLaIYlMrtxkQMfUOH9Anyi
         xJNbMcT0k3KM6IH0TZlFpyfnDvsUWCNLI/UazpkydvAorUllgGuGc388h8Hujg/mLH
         SvzNQ3tGtEBaSZHf2jVU+XH8aVZh65Dfho9vIrHYfJJpZ04IXe1kmxdhatGpdj1glS
         fO1mRhHA4VyLAxaJtPCgefPqI+vtoDgwY5Z89tpJ4R2ILOue+IH9mTvCTNC/hgiZv2
         VdmFZOjej6fe7xMFwwXgo6qPMzdGtWefKkahNv63/YdEmN2hf2+n/jqXxfm69E+OtC
         TZiriaJKD3gZQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 04/12] net: embed num_tc in the xps maps
Date:   Mon,  8 Feb 2021 18:19:09 +0100
Message-Id: <20210208171917.1088230-5-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xps cpus/rxqs map is accessed using dev->num_tc, which is used when
allocating the map. But later updates of dev->num_tc can lead to having
a mismatch between the maps and how they're accessed. In such cases the
map values do not make any sense and out of bound accesses can occur
(that can be easily seen using KASAN).

This patch aims at fixing this by embedding num_tc into the maps, using
the value at the time the map is created. This brings two improvements:
- The maps can be accessed using the embedded num_tc, so we know for
  sure we won't have out of bound accesses.
- Checks can be made before accessing the maps so we know the values
  retrieved will make sense.

We also update __netif_set_xps_queue to conditionally copy old maps from
dev_maps in the new one only if the number of traffic classes from both
maps match.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h |  6 ++++
 net/core/dev.c            | 63 +++++++++++++++++++++++++--------------
 net/core/net-sysfs.c      | 45 +++++++++++-----------------
 3 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e9e7ada07ea1..d7d3c646d40d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -779,9 +779,15 @@ struct xps_map {
 
 /*
  * This structure holds all XPS maps for device.  Maps are indexed by CPU.
+ *
+ * We keep track of the number of traffic classes used when the struct is
+ * allocated, in num_tc. This will be used to navigate the maps, to ensure we're
+ * not crossing its upper bound, as the original dev->num_tc can be updated in
+ * the meantime.
  */
 struct xps_dev_maps {
 	struct rcu_head rcu;
+	s16 num_tc;
 	struct xps_map __rcu *attr_map[]; /* Either CPUs map or RXQs map */
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 21d74d30f5d7..7c5e2c614723 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2473,7 +2473,7 @@ static bool remove_xps_queue_cpu(struct net_device *dev,
 				 struct xps_dev_maps *dev_maps,
 				 int cpu, u16 offset, u16 count)
 {
-	int num_tc = dev->num_tc ? : 1;
+	int num_tc = dev_maps->num_tc;
 	bool active = false;
 	int tci;
 
@@ -2616,10 +2616,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 {
 	const unsigned long *online_mask = NULL, *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
+	bool active = false, copy = false;
 	int i, j, tci, numa_node_id = -2;
 	int maps_sz, num_tc = 1, tc = 0;
 	struct xps_map *map, *new_map;
-	bool active = false;
 	unsigned int nr_ids;
 
 	if (dev->num_tc) {
@@ -2654,19 +2654,29 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (maps_sz < L1_CACHE_BYTES)
 		maps_sz = L1_CACHE_BYTES;
 
+	/* The old dev_maps could be larger or smaller than the one we're
+	 * setting up now, as dev->num_tc could have been updated in between. We
+	 * could try to be smart, but let's be safe instead and only copy
+	 * foreign traffic classes if the two map sizes match.
+	 */
+	if (dev_maps && dev_maps->num_tc == num_tc)
+		copy = true;
+
 	/* allocate memory for queue storage */
 	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
 	     j < nr_ids;) {
-		if (!new_dev_maps)
-			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
 		if (!new_dev_maps) {
-			mutex_unlock(&xps_map_mutex);
-			return -ENOMEM;
+			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
+			if (!new_dev_maps) {
+				mutex_unlock(&xps_map_mutex);
+				return -ENOMEM;
+			}
+
+			new_dev_maps->num_tc = num_tc;
 		}
 
 		tci = j * num_tc + tc;
-		map = dev_maps ? xmap_dereference(dev_maps->attr_map[tci]) :
-				 NULL;
+		map = copy ? xmap_dereference(dev_maps->attr_map[tci]) : NULL;
 
 		map = expand_xps_map(map, j, index, is_rxqs_map);
 		if (!map)
@@ -2688,7 +2698,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
 		/* copy maps belonging to foreign traffic classes */
-		for (i = tc, tci = j * num_tc; dev_maps && i--; tci++) {
+		for (i = tc, tci = j * num_tc; copy && i--; tci++) {
 			/* fill in the new device map from the old device map */
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
@@ -2718,14 +2728,14 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 					numa_node_id = -1;
 			}
 #endif
-		} else if (dev_maps) {
+		} else if (copy) {
 			/* fill in the new device map from the old device map */
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
 		}
 
 		/* copy maps belonging to foreign traffic classes */
-		for (i = num_tc - tc, tci++; dev_maps && --i; tci++) {
+		for (i = num_tc - tc, tci++; copy && --i; tci++) {
 			/* fill in the new device map from the old device map */
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
@@ -2743,11 +2753,18 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
-		for (i = num_tc, tci = j * num_tc; i--; tci++) {
-			new_map = xmap_dereference(new_dev_maps->attr_map[tci]);
+		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
-			if (map && map != new_map)
-				kfree_rcu(map, rcu);
+			if (!map)
+				continue;
+
+			if (copy) {
+				new_map = xmap_dereference(new_dev_maps->attr_map[tci]);
+				if (map == new_map)
+					continue;
+			}
+
+			kfree_rcu(map, rcu);
 		}
 	}
 
@@ -2771,12 +2788,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	/* removes tx-queue from unused CPUs/rx-queues */
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
-		for (i = tc, tci = j * num_tc; i--; tci++)
+		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
 			active |= remove_xps_queue(dev_maps, tci, index);
 		if (!netif_attr_test_mask(j, mask, nr_ids) ||
 		    !netif_attr_test_online(j, online_mask, nr_ids))
 			active |= remove_xps_queue(dev_maps, tci, index);
-		for (i = num_tc - tc, tci++; --i; tci++)
+		for (i = dev_maps->num_tc - tc, tci++; --i; tci++)
 			active |= remove_xps_queue(dev_maps, tci, index);
 	}
 
@@ -2794,7 +2811,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	     j < nr_ids;) {
 		for (i = num_tc, tci = j * num_tc; i--; tci++) {
 			new_map = xmap_dereference(new_dev_maps->attr_map[tci]);
-			map = dev_maps ?
+			map = copy ?
 			      xmap_dereference(dev_maps->attr_map[tci]) :
 			      NULL;
 			if (new_map && new_map != map)
@@ -3926,13 +3943,15 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 			       struct xps_dev_maps *dev_maps, unsigned int tci)
 {
+	int tc = netdev_get_prio_tc_map(dev, skb->priority);
 	struct xps_map *map;
 	int queue_index = -1;
 
-	if (dev->num_tc) {
-		tci *= dev->num_tc;
-		tci += netdev_get_prio_tc_map(dev, skb->priority);
-	}
+	if (tc >= dev_maps->num_tc)
+		return queue_index;
+
+	tci *= dev_maps->num_tc;
+	tci += tc;
 
 	map = rcu_dereference(dev_maps->attr_map[tci]);
 	if (map) {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 3915b1826814..c1d4d3e712a9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1317,9 +1317,9 @@ static const struct attribute_group dql_group = {
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
-	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	int j, len, ret, tc = 0;
 	unsigned long *mask;
 	unsigned int index;
 
@@ -1331,22 +1331,13 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (dev->num_tc) {
-		/* Do not allow XPS on subordinate device directly */
-		num_tc = dev->num_tc;
-		if (num_tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
-
-		/* If queue belongs to subordinate dev use its map */
-		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
+	/* If queue belongs to subordinate dev use its map */
+	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
-		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
+	tc = netdev_txq_to_tc(dev, index);
+	if (tc < 0) {
+		ret = -EINVAL;
+		goto err_rtnl_unlock;
 	}
 
 	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
@@ -1357,12 +1348,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_cpus_map);
-	if (!dev_maps)
+	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
 	for (j = -1; j = netif_attrmask_next(j, NULL, nr_cpu_ids),
 	     j < nr_cpu_ids;) {
-		int i, tci = j * num_tc + tc;
+		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
 		map = rcu_dereference(dev_maps->attr_map[tci]);
@@ -1433,9 +1424,9 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
 
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
-	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	int j, len, ret, tc = 0;
 	unsigned long *mask;
 	unsigned int index;
 
@@ -1444,14 +1435,12 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (dev->num_tc) {
-		num_tc = dev->num_tc;
-		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
+	tc = netdev_txq_to_tc(dev, index);
+	if (tc < 0) {
+		ret = -EINVAL;
+		goto err_rtnl_unlock;
 	}
+
 	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
 	if (!mask) {
 		ret = -ENOMEM;
@@ -1460,12 +1449,12 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_rxqs_map);
-	if (!dev_maps)
+	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
 	for (j = -1; j = netif_attrmask_next(j, NULL, dev->num_rx_queues),
 	     j < dev->num_rx_queues;) {
-		int i, tci = j * num_tc + tc;
+		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
 		map = rcu_dereference(dev_maps->attr_map[tci]);
-- 
2.29.2

