Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA1A307891
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhA1Os0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232266AbhA1OqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54A6464DEA;
        Thu, 28 Jan 2021 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845075;
        bh=GNswaViKwyujKTrV8gLmpv1zifrWZbj9jDY/O3FJqnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIYBPYKwqvKqAcfPXDpFUTTbcXYJAiA8olacctEIfV639HHmbJgyNaWJyxrTE+iAY
         VWuM8NB74/d/o7fbLm1ZTWRwgX0E7MQsNZULd5SOZrFcNUjw9KeDRGV7K9UtvLFgaA
         B8sjLc9mCnr/Q/Q2N7djjCvTjxChiTXnT2heAYY+ZlJZrYI7D9XeMW6HZnHLG+/Z/M
         DQjl85d1E1YA+ylBBtPpEEyw7R91L9jhe3TSBeKsn6bfBDEZORfxyCgssDKr8B9HfF
         hIj4BQienkqgINZ0TgOJVhcsbL+Vi2DGuw2c/ckNRA43iJnzHkkVNGDszbOgvwG3yT
         sf9lrKBUt0YTA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/11] net: remove the xps possible_mask
Date:   Thu, 28 Jan 2021 15:44:03 +0100
Message-Id: <20210128144405.4157244-10-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the xps possible_mask. It was an optimization but we can just
loop from 0 to nr_ids now that it is embedded in the xps dev_maps. That
simplifies the code a bit.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c       | 43 ++++++++++++++-----------------------------
 net/core/net-sysfs.c | 14 +++-----------
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c639761ddb5e..d487605d6992 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2504,33 +2504,27 @@ static void reset_xps_maps(struct net_device *dev,
 	kfree_rcu(dev_maps, rcu);
 }
 
-static void clean_xps_maps(struct net_device *dev, const unsigned long *mask,
+static void clean_xps_maps(struct net_device *dev,
 			   struct xps_dev_maps *dev_maps, u16 offset, u16 count,
 			   bool is_rxqs_map)
 {
-	unsigned int nr_ids = dev_maps->nr_ids;
 	bool active = false;
 	int i, j;
 
-	for (j = -1; j = netif_attrmask_next(j, mask, nr_ids), j < nr_ids;)
-		active |= remove_xps_queue_cpu(dev, dev_maps, j, offset,
-					       count);
+	for (j = 0; j < dev_maps->nr_ids; j++)
+		active |= remove_xps_queue_cpu(dev, dev_maps, j, offset, count);
 	if (!active)
 		reset_xps_maps(dev, dev_maps, is_rxqs_map);
 
-	if (!is_rxqs_map) {
-		for (i = offset + (count - 1); count--; i--) {
+	if (!is_rxqs_map)
+		for (i = offset + (count - 1); count--; i--)
 			netdev_queue_numa_node_write(
-				netdev_get_tx_queue(dev, i),
-				NUMA_NO_NODE);
-		}
-	}
+				netdev_get_tx_queue(dev, i), NUMA_NO_NODE);
 }
 
 static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 				   u16 count)
 {
-	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
 
 	if (!static_key_false(&xps_needed))
@@ -2542,17 +2536,14 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 	if (static_key_false(&xps_rxqs_needed)) {
 		dev_maps = xmap_dereference(dev->xps_rxqs_map);
 		if (dev_maps)
-			clean_xps_maps(dev, possible_mask, dev_maps, offset,
-				       count, true);
+			clean_xps_maps(dev, dev_maps, offset, count, true);
 	}
 
 	dev_maps = xmap_dereference(dev->xps_cpus_map);
 	if (!dev_maps)
 		goto out_no_maps;
 
-	if (num_possible_cpus() > 1)
-		possible_mask = cpumask_bits(cpu_possible_mask);
-	clean_xps_maps(dev, possible_mask, dev_maps, offset, count, false);
+	clean_xps_maps(dev, dev_maps, offset, count, false);
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
@@ -2627,8 +2618,8 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map)
 {
-	const unsigned long *online_mask = NULL, *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
+	const unsigned long *online_mask = NULL;
 	bool active = false, copy = false;
 	int i, j, tci, numa_node_id = -2;
 	int maps_sz, num_tc = 1, tc = 0;
@@ -2658,10 +2649,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		nr_ids = dev->num_rx_queues;
 	} else {
 		maps_sz = XPS_CPU_DEV_MAPS_SIZE(num_tc);
-		if (num_possible_cpus() > 1) {
+		if (num_possible_cpus() > 1)
 			online_mask = cpumask_bits(cpu_online_mask);
-			possible_mask = cpumask_bits(cpu_possible_mask);
-		}
 		dev_maps = xmap_dereference(dev->xps_cpus_map);
 		nr_ids = nr_cpu_ids;
 	}
@@ -2711,8 +2700,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			static_key_slow_inc_cpuslocked(&xps_rxqs_needed);
 	}
 
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		bool skip_tc = false;
 
 		tci = j * num_tc + tc;
@@ -2753,8 +2741,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (!dev_maps)
 		goto out_no_old_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
@@ -2788,8 +2775,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_maps;
 
 	/* removes tx-queue from unused CPUs/rx-queues */
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		tci = j * dev_maps->num_tc;
 
 		for (i = 0; i < dev_maps->num_tc; i++, tci++) {
@@ -2812,8 +2798,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	return 0;
 error:
 	/* remove any maps that we added */
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		for (i = num_tc, tci = j * num_tc; i--; tci++) {
 			new_map = xmap_dereference(new_dev_maps->attr_map[tci]);
 			map = copy ?
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 5b7123d3b66f..0c564f288460 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1318,10 +1318,8 @@ static const struct attribute_group dql_group = {
 static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 			  unsigned int index, bool is_rxqs_map)
 {
-	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
 	int j, tc = 0, ret = 0;
-	unsigned int nr_ids;
 
 	tc = netdev_txq_to_tc(dev, index);
 	if (tc < 0)
@@ -1329,20 +1327,14 @@ static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 
 	rcu_read_lock();
 
-	if (is_rxqs_map) {
+	if (is_rxqs_map)
 		dev_maps = rcu_dereference(dev->xps_rxqs_map);
-	} else {
+	else
 		dev_maps = rcu_dereference(dev->xps_cpus_map);
-		if (num_possible_cpus() > 1)
-			possible_mask = cpumask_bits(cpu_possible_mask);
-	}
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto rcu_unlock;
 
-	nr_ids = dev_maps->nr_ids;
-
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < dev_maps->nr_ids; j++) {
 		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
-- 
2.29.2

