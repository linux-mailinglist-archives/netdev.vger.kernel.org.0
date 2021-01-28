Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF74307885
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhA1OqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhA1OpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:45:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB61264DE6;
        Thu, 28 Jan 2021 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845060;
        bh=PUEhSX7z6zPjji/GrVsr2le+Z18R4MLuVfRPLwfKX1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhSTCoW2zKLZxlt824xPYs8y20qYwHM+RAkrsjAa0blSEClYvC3OHjH9/t46IM1p6
         JYqr7ZRVhx/hSuz5Th/UO2g/hKtwb1L2MFkOo8mlFLKNAPAcSUOtIGYYXD/8B8d0dw
         ZpERwpIeDW/jYSZ7ThXKJ80uX2ynjrqWQBwl/cE//5Wx8NRsp7zNkoIO0eG+jDAOms
         GPrBUEz43kKuOlYlj133oJqatlwrdhySNJHoe2lpxBP13Ym/d9Bxzn3IYfHjnYSzIC
         H7+/wJhPaQTsbXBykFlrHuG0pYL/yeWk+Aky0bQp/AkXEyCV/xG02kA6xI90l3b+Je
         WWi7rfpsq8A2w==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/11] net: embed num_tc in the xps maps
Date:   Thu, 28 Jan 2021 15:43:58 +0100
Message-Id: <20210128144405.4157244-5-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
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
 net/core/net-sysfs.c      | 25 ++++++----------
 3 files changed, 56 insertions(+), 38 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9e8572533d8e..481307de6983 100644
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
index 6df3f1bcdc68..f43281a7367c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2472,7 +2472,7 @@ static bool remove_xps_queue_cpu(struct net_device *dev,
 				 struct xps_dev_maps *dev_maps,
 				 int cpu, u16 offset, u16 count)
 {
-	int num_tc = dev->num_tc ? : 1;
+	int num_tc = dev_maps->num_tc;
 	bool active = false;
 	int tci;
 
@@ -2615,10 +2615,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2653,19 +2653,29 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2687,7 +2697,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
 		/* copy maps belonging to foreign traffic classes */
-		for (i = tc, tci = j * num_tc; dev_maps && i--; tci++) {
+		for (i = tc, tci = j * num_tc; copy && i--; tci++) {
 			/* fill in the new device map from the old device map */
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
@@ -2717,14 +2727,14 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2742,11 +2752,18 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
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
 
@@ -2770,12 +2787,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
 
@@ -2793,7 +2810,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	     j < nr_ids;) {
 		for (i = num_tc, tci = j * num_tc; i--; tci++) {
 			new_map = xmap_dereference(new_dev_maps->attr_map[tci]);
-			map = dev_maps ?
+			map = copy ?
 			      xmap_dereference(dev_maps->attr_map[tci]) :
 			      NULL;
 			if (new_map && new_map != map)
@@ -3914,13 +3931,15 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
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
index 6e6bc05181f6..f606f3556ad7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1319,23 +1319,13 @@ static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 			  unsigned int index, bool is_rxqs_map)
 {
 	const unsigned long *possible_mask = NULL;
-	int j, num_tc = 0, tc = 0, ret = 0;
 	struct xps_dev_maps *dev_maps;
+	int j, tc = 0, ret = 0;
 	unsigned int nr_ids;
 
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
+	tc = netdev_txq_to_tc(dev, index);
+	if (tc < 0)
+		return -EINVAL;
 
 	rcu_read_lock();
 
@@ -1348,12 +1338,12 @@ static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 		if (num_possible_cpus() > 1)
 			possible_mask = cpumask_bits(cpu_possible_mask);
 	}
-	if (!dev_maps)
+	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto rcu_unlock;
 
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
-		int i, tci = j * num_tc + tc;
+		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
 		map = rcu_dereference(dev_maps->attr_map[tci]);
@@ -1386,6 +1376,9 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
 
 	index = get_netdev_queue_index(queue);
 
+	/* If queue belongs to subordinate dev use its map */
+	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
+
 	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
 	if (!mask)
 		return -ENOMEM;
-- 
2.29.2

