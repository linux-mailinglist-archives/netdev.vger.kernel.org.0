Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00962313AD8
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhBHRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233840AbhBHRVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E39FE64EAC;
        Mon,  8 Feb 2021 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804777;
        bh=9IJaTAMOrlUn8+ekJVI+aCGFuDgrAQTnTE337yCpV/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLpgKAs+TEOT2VSGCRvpN7rj6Luc1XEoYwdcwMaTfHRAjEsoVm68O3NAiANigRHmP
         JXhlDGtkl/fGZEMInwxjK8O+IxYwsRij+PdWM5hlJGO7mnUUeVAaG8vNbczRKVA9A1
         LeFFWpSjHT/zr/8YDKW8FH8ZKcsrQIVwj80kTOArj2+KK9f1f/P1Tl+OSZsGW7kxTR
         YUrW6WVZlzcyIaGfkO7sMq/eEZnQRpCMJUHc4axjE1OJW/vOkar0oaTOzuiYRG//6T
         GyBhPtUk1DBqdZuElpQYTDF1g8rN0zEG3BeuNsnpW5BH6Qxy8xKsfyfrg78pPLzlaF
         csf23bQfxxNAw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 07/12] net: remove the xps possible_mask
Date:   Mon,  8 Feb 2021 18:19:12 +0100
Message-Id: <20210208171917.1088230-8-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
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
 net/core/net-sysfs.c |  4 ++--
 2 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index abbb2ae6b3ed..d0c07ccea2e5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2505,33 +2505,27 @@ static void reset_xps_maps(struct net_device *dev,
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
@@ -2543,17 +2537,14 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
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
@@ -2609,8 +2600,8 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map)
 {
-	const unsigned long *online_mask = NULL, *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
+	const unsigned long *online_mask = NULL;
 	bool active = false, copy = false;
 	int i, j, tci, numa_node_id = -2;
 	int maps_sz, num_tc = 1, tc = 0;
@@ -2640,10 +2631,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2693,8 +2682,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			static_key_slow_inc_cpuslocked(&xps_rxqs_needed);
 	}
 
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		/* copy maps belonging to foreign traffic classes */
 		for (i = tc, tci = j * num_tc; copy && i--; tci++) {
 			/* fill in the new device map from the old device map */
@@ -2749,8 +2737,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (!dev_maps)
 		goto out_no_old_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
@@ -2784,8 +2771,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_maps;
 
 	/* removes tx-queue from unused CPUs/rx-queues */
-	for (j = -1; j = netif_attrmask_next(j, possible_mask, dev_maps->nr_ids),
-	     j < dev_maps->nr_ids;) {
+	for (j = 0; j < dev_maps->nr_ids; j++) {
 		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
 			active |= remove_xps_queue(dev_maps, tci, index);
 		if (!netif_attr_test_mask(j, mask, dev_maps->nr_ids) ||
@@ -2805,8 +2791,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
index e544e5f2467c..6180c35d5108 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1353,7 +1353,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, NULL, nr_ids), j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
@@ -1457,7 +1457,7 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto out_no_maps;
 
-	for (j = -1; j = netif_attrmask_next(j, NULL, nr_ids), j < nr_ids;) {
+	for (j = 0; j < nr_ids; j++) {
 		int i, tci = j * dev_maps->num_tc + tc;
 		struct xps_map *map;
 
-- 
2.29.2

