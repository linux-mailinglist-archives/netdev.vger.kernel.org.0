Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B89313AD5
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhBHRYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234229AbhBHRVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017D064EA1;
        Mon,  8 Feb 2021 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804772;
        bh=cdjD5ssksvJj0QR7crr18OktaJcxSCWU27mG1I7k4fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAxauYgbwHDhr/Ke1UutFmUXuRj04Tu5ZtDFxkVcPqbMCQ9nTs2c0iRW7JAnOToKD
         Z+4SAl8lkQKQAQAUKhwMt9apZTM1hLYsGyslrTnAAXSfETSfFqx2N/PpFhzOxV+/60
         ZgehbcdBAvDYBDH8mIkQBfwasPMbMnyZ782B61ymj/2L32f6hltSejF88CU7iXAnCa
         nMoxL6VytZhELmXcKfKoTzuNR/nCBpNkn4l4f7CeF6cPSlnbTvalIZeHdZKSNax8vu
         MY++uxAKKLGpZGub3F1PPaUcRS/iUK2j2B2k9ixR2JdyjKQZ5qvyyrTI5QytcOCgAh
         IeK9ZrA2wKAIg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 05/12] net: embed nr_ids in the xps maps
Date:   Mon,  8 Feb 2021 18:19:10 +0100
Message-Id: <20210208171917.1088230-6-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
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
 net/core/dev.c            | 34 +++++++++++++++-------------------
 net/core/net-sysfs.c      | 38 ++++++++++++++++++++++----------------
 3 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d7d3c646d40d..40683b6eee54 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -780,6 +780,9 @@ struct xps_map {
 /*
  * This structure holds all XPS maps for device.  Maps are indexed by CPU.
  *
+ * We keep track of the number of cpus/rxqs used when the struct is allocated,
+ * in nr_ids. This will help not accessing out-of-bound memory.
+ *
  * We keep track of the number of traffic classes used when the struct is
  * allocated, in num_tc. This will be used to navigate the maps, to ensure we're
  * not crossing its upper bound, as the original dev->num_tc can be updated in
@@ -787,6 +790,7 @@ struct xps_map {
  */
 struct xps_dev_maps {
 	struct rcu_head rcu;
+	unsigned int nr_ids;
 	s16 num_tc;
 	struct xps_map __rcu *attr_map[]; /* Either CPUs map or RXQs map */
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index 7c5e2c614723..1f7df0bd415c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2506,14 +2506,14 @@ static void reset_xps_maps(struct net_device *dev,
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
@@ -2533,7 +2533,6 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 {
 	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
-	unsigned int nr_ids;
 
 	if (!static_key_false(&xps_needed))
 		return;
@@ -2543,11 +2542,9 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
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
@@ -2556,9 +2553,7 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
 	if (num_possible_cpus() > 1)
 		possible_mask = cpumask_bits(cpu_possible_mask);
-	nr_ids = nr_cpu_ids;
-	clean_xps_maps(dev, possible_mask, dev_maps, nr_ids, offset, count,
-		       false);
+	clean_xps_maps(dev, possible_mask, dev_maps, offset, count, false);
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
@@ -2672,6 +2667,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 				return -ENOMEM;
 			}
 
+			new_dev_maps->nr_ids = nr_ids;
 			new_dev_maps->num_tc = num_tc;
 		}
 
@@ -2786,12 +2782,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -3947,7 +3943,7 @@ static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 	struct xps_map *map;
 	int queue_index = -1;
 
-	if (tc >= dev_maps->num_tc)
+	if (tc >= dev_maps->num_tc || tci >= dev_maps->nr_ids)
 		return queue_index;
 
 	tci *= dev_maps->num_tc;
@@ -3986,7 +3982,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 	if (dev_maps) {
 		int tci = sk_rx_queue_get(sk);
 
-		if (tci >= 0 && tci < dev->num_rx_queues)
+		if (tci >= 0)
 			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
 							  tci);
 	}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c1d4d3e712a9..e544e5f2467c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1319,9 +1319,9 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 {
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	unsigned int index, nr_ids;
 	int j, len, ret, tc = 0;
 	unsigned long *mask;
-	unsigned int index;
 
 	if (!netif_is_multiqueue(dev))
 		return -ENOENT;
@@ -1340,19 +1340,20 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
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
 
@@ -1372,10 +1373,12 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
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
@@ -1426,9 +1429,9 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
+	unsigned int index, nr_ids;
 	int j, len, ret, tc = 0;
 	unsigned long *mask;
-	unsigned int index;
 
 	index = get_netdev_queue_index(queue);
 
@@ -1441,19 +1444,20 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
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
 
@@ -1473,11 +1477,13 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 
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
2.29.2

