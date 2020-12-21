Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE62E011C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLUThc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLUThb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:37:31 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v2 1/3] net: fix race conditions in xps by locking the maps and dev->tc_num
Date:   Mon, 21 Dec 2020 20:36:42 +0100
Message-Id: <20201221193644.1296933-2-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221193644.1296933-1-atenart@kernel.org>
References: <20201221193644.1296933-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two race conditions can be triggered in xps, resulting in various oops
and invalid memory accesses:

1. Calling netdev_set_num_tc while netif_set_xps_queue:

   - netdev_set_num_tc sets dev->tc_num.

   - netif_set_xps_queue uses dev->tc_num as one of the parameters to
     compute the size of new_dev_maps when allocating it. dev->tc_num is
     also used to access the map, and the compiler may generate code to
     retrieve this field multiple times in the function.

   If new_dev_maps is allocated using dev->tc_num and then dev->tc_num
   is set to a higher value through netdev_set_num_tc, later accesses to
   new_dev_maps in netif_set_xps_queue could lead to accessing memory
   outside of new_dev_maps; triggering an oops.

   One way of triggering this is to set an iface up (for which the
   driver uses netdev_set_num_tc in the open path, such as bnx2x) and
   writing to xps_cpus or xps_rxqs in a concurrent thread. With the
   right timing an oops is triggered.

2. Calling netif_set_xps_queue while netdev_set_num_tc is running:

   2.1. netdev_set_num_tc starts by resetting the xps queues,
        dev->tc_num isn't updated yet.

   2.2. netif_set_xps_queue is called, setting up the maps with the
        *old* dev->num_tc.

   2.3. dev->tc_num is updated.

   2.3. Later accesses to the map leads to out of bound accesses and
        oops.

   A similar issue can be found with netdev_reset_tc.

   The fix can't be to only link the size of the maps to them, as
   invalid configuration could still occur. The reset then set logic in
   both netdev_set_num_tc and netdev_reset_tc must be protected by a
   lock.

Both issues have the same fix: netif_set_xps_queue, netdev_set_num_tc
and netdev_reset_tc should be mutually exclusive.

This patch fixes those races by:

- Reworking netif_set_xps_queue by moving the xps_map_mutex up so the
  access of dev->num_tc is done under the lock.

- Using xps_map_mutex in both netdev_set_num_tc and netdev_reset_tc for
  the reset and set logic:

  + As xps_map_mutex was taken in the reset path, netif_reset_xps_queues
    had to be reworked to offer an unlocked version (as well as
    netdev_unbind_all_sb_channels which calls it).

  + cpus_read_lock was taken in the reset path as well, and is always
    taken before xps_map_mutex. It had to be moved out of the unlocked
    version as well.

  This is why the patch is a little bit longer, and moves
  netdev_unbind_sb_channel up in the file.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 122 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 81 insertions(+), 41 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..effdb7fee9df 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2527,8 +2527,8 @@ static void clean_xps_maps(struct net_device *dev, const unsigned long *mask,
 	}
 }
 
-static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
-				   u16 count)
+static void __netif_reset_xps_queues(struct net_device *dev, u16 offset,
+				     u16 count)
 {
 	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
@@ -2537,9 +2537,6 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 	if (!static_key_false(&xps_needed))
 		return;
 
-	cpus_read_lock();
-	mutex_lock(&xps_map_mutex);
-
 	if (static_key_false(&xps_rxqs_needed)) {
 		dev_maps = xmap_dereference(dev->xps_rxqs_map);
 		if (dev_maps) {
@@ -2551,15 +2548,23 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
 	dev_maps = xmap_dereference(dev->xps_cpus_map);
 	if (!dev_maps)
-		goto out_no_maps;
+		return;
 
 	if (num_possible_cpus() > 1)
 		possible_mask = cpumask_bits(cpu_possible_mask);
 	nr_ids = nr_cpu_ids;
 	clean_xps_maps(dev, possible_mask, dev_maps, nr_ids, offset, count,
 		       false);
+}
+
+static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
+				   u16 count)
+{
+	cpus_read_lock();
+	mutex_lock(&xps_map_mutex);
+
+	__netif_reset_xps_queues(dev, offset, count);
 
-out_no_maps:
 	mutex_unlock(&xps_map_mutex);
 	cpus_read_unlock();
 }
@@ -2615,27 +2620,32 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 {
 	const unsigned long *online_mask = NULL, *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
-	int i, j, tci, numa_node_id = -2;
+	int i, j, tci, numa_node_id = -2, ret = 0;
 	int maps_sz, num_tc = 1, tc = 0;
 	struct xps_map *map, *new_map;
 	bool active = false;
 	unsigned int nr_ids;
 
+	mutex_lock(&xps_map_mutex);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-		if (num_tc < 0)
-			return -EINVAL;
+		if (num_tc < 0) {
+			ret = -EINVAL;
+			goto unlock;
+		}
 
 		/* If queue belongs to subordinate dev use its map */
 		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
+		if (tc < 0) {
+			ret = -EINVAL;
+			goto unlock;
+		}
 	}
 
-	mutex_lock(&xps_map_mutex);
 	if (is_rxqs_map) {
 		maps_sz = XPS_RXQ_DEV_MAPS_SIZE(num_tc, dev->num_rx_queues);
 		dev_maps = xmap_dereference(dev->xps_rxqs_map);
@@ -2659,8 +2669,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		if (!new_dev_maps)
 			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
 		if (!new_dev_maps) {
-			mutex_unlock(&xps_map_mutex);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto unlock;
 		}
 
 		tci = j * num_tc + tc;
@@ -2765,7 +2775,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	}
 
 	if (!dev_maps)
-		goto out_no_maps;
+		goto unlock;
 
 	/* removes tx-queue from unused CPUs/rx-queues */
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
@@ -2783,10 +2793,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (!active)
 		reset_xps_maps(dev, dev_maps, is_rxqs_map);
 
-out_no_maps:
+unlock:
 	mutex_unlock(&xps_map_mutex);
 
-	return 0;
+	return ret;
 error:
 	/* remove any maps that we added */
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
@@ -2822,28 +2832,68 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 EXPORT_SYMBOL(netif_set_xps_queue);
 
 #endif
-static void netdev_unbind_all_sb_channels(struct net_device *dev)
+
+static void __netdev_unbind_sb_channel(struct net_device *dev,
+				       struct net_device *sb_dev)
+{
+	struct netdev_queue *txq = &dev->_tx[dev->num_tx_queues];
+
+#ifdef CONFIG_XPS
+	__netif_reset_xps_queues(sb_dev, 0, dev->num_tx_queues);
+#endif
+
+	memset(sb_dev->tc_to_txq, 0, sizeof(sb_dev->tc_to_txq));
+	memset(sb_dev->prio_tc_map, 0, sizeof(sb_dev->prio_tc_map));
+
+	while (txq-- != &dev->_tx[0]) {
+		if (txq->sb_dev == sb_dev)
+			txq->sb_dev = NULL;
+	}
+}
+
+void netdev_unbind_sb_channel(struct net_device *dev,
+			      struct net_device *sb_dev)
+{
+	cpus_read_lock();
+	mutex_lock(&xps_map_mutex);
+
+	__netdev_unbind_sb_channel(dev, sb_dev);
+
+	mutex_unlock(&xps_map_mutex);
+	cpus_read_unlock();
+}
+EXPORT_SYMBOL(netdev_unbind_sb_channel);
+
+static void __netdev_unbind_all_sb_channels(struct net_device *dev)
 {
 	struct netdev_queue *txq = &dev->_tx[dev->num_tx_queues];
 
 	/* Unbind any subordinate channels */
 	while (txq-- != &dev->_tx[0]) {
 		if (txq->sb_dev)
-			netdev_unbind_sb_channel(dev, txq->sb_dev);
+			__netdev_unbind_sb_channel(dev, txq->sb_dev);
 	}
 }
 
 void netdev_reset_tc(struct net_device *dev)
 {
 #ifdef CONFIG_XPS
-	netif_reset_xps_queues_gt(dev, 0);
+	cpus_read_lock();
+	mutex_lock(&xps_map_mutex);
+
+	__netif_reset_xps_queues(dev, 0, dev->num_tx_queues);
 #endif
-	netdev_unbind_all_sb_channels(dev);
+	__netdev_unbind_all_sb_channels(dev);
 
 	/* Reset TC configuration of device */
 	dev->num_tc = 0;
 	memset(dev->tc_to_txq, 0, sizeof(dev->tc_to_txq));
 	memset(dev->prio_tc_map, 0, sizeof(dev->prio_tc_map));
+
+#ifdef CONFIG_XPS
+	mutex_unlock(&xps_map_mutex);
+	cpus_read_unlock();
+#endif
 }
 EXPORT_SYMBOL(netdev_reset_tc);
 
@@ -2867,32 +2917,22 @@ int netdev_set_num_tc(struct net_device *dev, u8 num_tc)
 		return -EINVAL;
 
 #ifdef CONFIG_XPS
-	netif_reset_xps_queues_gt(dev, 0);
+	cpus_read_lock();
+	mutex_lock(&xps_map_mutex);
+
+	__netif_reset_xps_queues(dev, 0, dev->num_tx_queues);
 #endif
-	netdev_unbind_all_sb_channels(dev);
+	__netdev_unbind_all_sb_channels(dev);
 
 	dev->num_tc = num_tc;
-	return 0;
-}
-EXPORT_SYMBOL(netdev_set_num_tc);
-
-void netdev_unbind_sb_channel(struct net_device *dev,
-			      struct net_device *sb_dev)
-{
-	struct netdev_queue *txq = &dev->_tx[dev->num_tx_queues];
 
 #ifdef CONFIG_XPS
-	netif_reset_xps_queues_gt(sb_dev, 0);
+	mutex_unlock(&xps_map_mutex);
+	cpus_read_unlock();
 #endif
-	memset(sb_dev->tc_to_txq, 0, sizeof(sb_dev->tc_to_txq));
-	memset(sb_dev->prio_tc_map, 0, sizeof(sb_dev->prio_tc_map));
-
-	while (txq-- != &dev->_tx[0]) {
-		if (txq->sb_dev == sb_dev)
-			txq->sb_dev = NULL;
-	}
+	return 0;
 }
-EXPORT_SYMBOL(netdev_unbind_sb_channel);
+EXPORT_SYMBOL(netdev_set_num_tc);
 
 int netdev_bind_sb_channel_queue(struct net_device *dev,
 				 struct net_device *sb_dev,
-- 
2.29.2

