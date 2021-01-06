Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10452EC2F4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAFSFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:05:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbhAFSFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:05:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A0B2312E;
        Wed,  6 Jan 2021 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609956281;
        bh=pLx1XznkaVjYaQOKMNx9wnZaulskH2iom1amrmS2WF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px3YSOMndu5u6+BNyDoZ7HV2YUzQUcy6ggnfTln9J5u4LmTWe6q8inWyOSpXbR35N
         sYj650Q2Dy964FK88Y7u2rTth4hq/w+GWSjTHSoHfH/7N/+3xymLFfJb/V7Tu0DKog
         6xR6ATM6YbZmFWtMHfmb4jtYjNBLccZQkOMvRiz45PKkLJGJ8Aw6CSkiBJQVJj1b15
         bZpHSwmHFEKxebZZUIEAdbmTG1MP17Z4776VJMfPT2eT3XmC7xiNcagJcG2v3oQpIP
         Yc5NR659EzRKjGSWkYh4IGuc9Y/sC0RMW+F+zb2Rye00PjqUpvyiLahPmCn7nAonTo
         souJsIaDkC6Yw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
Date:   Wed,  6 Jan 2021 19:04:28 +0100
Message-Id: <20210106180428.722521-4-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106180428.722521-1-atenart@kernel.org>
References: <20210106180428.722521-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the xps_cpus_show and xps_rxqs_show functions share the same
logic. Having it in two different functions does not help maintenance
and we can already see small implementation differences. This should not
be the case and this patch moves their common logic into a new function,
xps_queue_show, to improve maintenance.

While the rtnl lock could be held in the new xps_queue_show, it is still
held in xps_cpus_show and xps_rxqs_show as this is an important
information when looking at those two functions. This does not add
complexity.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 168 ++++++++++++++++++++-----------------------
 1 file changed, 79 insertions(+), 89 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5a39e9b38e5f..6e6bc05181f6 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1314,77 +1314,98 @@ static const struct attribute_group dql_group = {
 #endif /* CONFIG_BQL */
 
 #ifdef CONFIG_XPS
-static ssize_t xps_cpus_show(struct netdev_queue *queue,
-			     char *buf)
+/* Should be called with the rtnl lock held. */
+static int xps_queue_show(struct net_device *dev, unsigned long **mask,
+			  unsigned int index, bool is_rxqs_map)
 {
-	int cpu, len, ret, num_tc = 1, tc = 0;
-	struct net_device *dev = queue->dev;
+	const unsigned long *possible_mask = NULL;
+	int j, num_tc = 0, tc = 0, ret = 0;
 	struct xps_dev_maps *dev_maps;
-	unsigned long *mask;
-	unsigned int index;
-
-	if (!netif_is_multiqueue(dev))
-		return -ENOENT;
-
-	index = get_netdev_queue_index(queue);
-
-	if (!rtnl_trylock())
-		return restart_syscall();
+	unsigned int nr_ids;
 
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-		if (num_tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
+		if (num_tc < 0)
+			return -EINVAL;
 
 		/* If queue belongs to subordinate dev use its map */
 		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
+		if (tc < 0)
+			return -EINVAL;
 	}
 
-	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
-	if (!mask) {
-		ret = -ENOMEM;
-		goto err_rtnl_unlock;
+	rcu_read_lock();
+
+	if (is_rxqs_map) {
+		dev_maps = rcu_dereference(dev->xps_rxqs_map);
+		nr_ids = dev->num_rx_queues;
+	} else {
+		dev_maps = rcu_dereference(dev->xps_cpus_map);
+		nr_ids = nr_cpu_ids;
+		if (num_possible_cpus() > 1)
+			possible_mask = cpumask_bits(cpu_possible_mask);
 	}
+	if (!dev_maps)
+		goto rcu_unlock;
 
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
-					set_bit(cpu, mask);
-					break;
-				}
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
 			}
 		}
 	}
+
+rcu_unlock:
 	rcu_read_unlock();
 
+	return ret;
+}
+
+static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
+{
+	struct net_device *dev = queue->dev;
+	unsigned long *mask;
+	unsigned int index;
+	int len, ret;
+
+	if (!netif_is_multiqueue(dev))
+		return -ENOENT;
+
+	index = get_netdev_queue_index(queue);
+
+	mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
+	if (!mask)
+		return -ENOMEM;
+
+	if (!rtnl_trylock()) {
+		bitmap_free(mask);
+		return restart_syscall();
+	}
+
+	ret = xps_queue_show(dev, &mask, index, false);
 	rtnl_unlock();
 
+	if (ret) {
+		bitmap_free(mask);
+		return ret;
+	}
+
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_cpu_ids);
 	bitmap_free(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
-
-err_rtnl_unlock:
-	rtnl_unlock();
-	return ret;
 }
 
 static ssize_t xps_cpus_store(struct netdev_queue *queue,
@@ -1430,65 +1451,34 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
 
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
-	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
-	struct xps_dev_maps *dev_maps;
 	unsigned long *mask;
 	unsigned int index;
+	int len, ret;
 
 	index = get_netdev_queue_index(queue);
 
-	if (!rtnl_trylock())
-		return restart_syscall();
-
-	if (dev->num_tc) {
-		num_tc = dev->num_tc;
-		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0) {
-			ret = -EINVAL;
-			goto err_rtnl_unlock;
-		}
-	}
 	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
-	if (!mask) {
-		ret = -ENOMEM;
-		goto err_rtnl_unlock;
-	}
-
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
+	if (!mask)
+		return -ENOMEM;
 
-		for (i = map->len; i--;) {
-			if (map->queues[i] == index) {
-				set_bit(j, mask);
-				break;
-			}
-		}
+	if (!rtnl_trylock()) {
+		bitmap_free(mask);
+		return restart_syscall();
 	}
-out_no_maps:
-	rcu_read_unlock();
 
+	ret = xps_queue_show(dev, &mask, index, true);
 	rtnl_unlock();
 
+	if (ret) {
+		bitmap_free(mask);
+		return ret;
+	}
+
 	len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
 	bitmap_free(mask);
 
 	return len < PAGE_SIZE ? len : -EINVAL;
-
-err_rtnl_unlock:
-	rtnl_unlock();
-	return ret;
 }
 
 static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
-- 
2.29.2

