Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D216B2E011E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLUThh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLUThh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:37:37 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net v2 3/3] net: move the xps rxqs retrieval out of net-sysfs
Date:   Mon, 21 Dec 2020 20:36:44 +0100
Message-Id: <20201221193644.1296933-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221193644.1296933-1-atenart@kernel.org>
References: <20201221193644.1296933-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accesses to dev->xps_rxqs_map (when using dev->num_tc) should be
protected by the xps_map mutex, to avoid possible race conditions when
dev->num_tc is updated while the map is accessed. Make use of the now
available netif_show_xps_queue helper which does just that.

This also helps to keep xps_cpus_show and xps_rxqs_show synced as their
logic is the same (as in __netif_set_xps_queue, the function allocating
and setting them up).

Fixes: 8af2c06ff4b1 ("net-sysfs: Add interface for Rx queue(s) map per Tx queue")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/netdevice.h |  5 +++--
 net/core/dev.c            | 15 ++++++++++-----
 net/core/net-sysfs.c      | 37 ++++++-------------------------------
 3 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bfd6cfa3ea90..5c3e16464c3f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3672,7 +3672,7 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map);
 int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
-			 u16 index);
+			 u16 index, bool is_rxqs_map);
 
 /**
  *	netif_attr_test_mask - Test a CPU or Rx queue set in a mask
@@ -3773,7 +3773,8 @@ static inline int __netif_set_xps_queue(struct net_device *dev,
 }
 
 static inline int netif_show_xps_queue(struct net_device *dev,
-				       unsigned long **mask, u16 index)
+				       unsigned long **mask, u16 index,
+				       bool is_rxqs_map)
 {
 	return 0;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index a0257da4160a..e5cc2939e4d9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2832,7 +2832,7 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
 EXPORT_SYMBOL(netif_set_xps_queue);
 
 int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
-			 u16 index)
+			 u16 index, bool is_rxqs_map)
 {
 	const unsigned long *possible_mask = NULL;
 	int j, num_tc = 1, tc = 0, ret = 0;
@@ -2859,12 +2859,17 @@ int netif_show_xps_queue(struct net_device *dev, unsigned long **mask,
 		}
 	}
 
-	dev_maps = rcu_dereference(dev->xps_cpus_map);
+	if (is_rxqs_map) {
+		dev_maps = rcu_dereference(dev->xps_rxqs_map);
+		nr_ids = dev->num_rx_queues;
+	} else {
+		dev_maps = rcu_dereference(dev->xps_cpus_map);
+		nr_ids = nr_cpu_ids;
+		if (num_possible_cpus() > 1)
+			possible_mask = cpumask_bits(cpu_possible_mask);
+	}
 	if (!dev_maps)
 		goto out_no_map;
-	nr_ids = nr_cpu_ids;
-	if (num_possible_cpus() > 1)
-		possible_mask = cpumask_bits(cpu_possible_mask);
 
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 29ee69b67972..4f58b38dfc7d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1329,7 +1329,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
 	if (!mask)
 		return -ENOMEM;
 
-	ret = netif_show_xps_queue(dev, &mask, index);
+	ret = netif_show_xps_queue(dev, &mask, index, false);
 	if (ret) {
 		bitmap_free(mask);
 		return ret;
@@ -1379,45 +1379,20 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
 	struct net_device *dev = queue->dev;
-	struct xps_dev_maps *dev_maps;
 	unsigned long *mask, index;
-	int j, len, num_tc = 1, tc = 0;
+	int len, ret;
 
 	index = get_netdev_queue_index(queue);
 
-	if (dev->num_tc) {
-		num_tc = dev->num_tc;
-		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
-	}
 	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
 	if (!mask)
 		return -ENOMEM;
 
-	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_rxqs_map);
-	if (!dev_maps)
-		goto out_no_maps;
-
-	for (j = -1; j = netif_attrmask_next(j, NULL, dev->num_rx_queues),
-	     j < dev->num_rx_queues;) {
-		int i, tci = j * num_tc + tc;
-		struct xps_map *map;
-
-		map = rcu_dereference(dev_maps->attr_map[tci]);
-		if (!map)
-			continue;
-
-		for (i = map->len; i--;) {
-			if (map->queues[i] == index) {
-				set_bit(j, mask);
-				break;
-			}
-		}
+	ret = netif_show_xps_queue(dev, &mask, index, true);
+	if (ret) {
+		bitmap_free(mask);
+		return ret;
 	}
-out_no_maps:
-	rcu_read_unlock();
 
 	len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
 	bitmap_free(mask);
-- 
2.29.2

