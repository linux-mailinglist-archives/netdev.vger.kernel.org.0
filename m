Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74F83078A4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhA1OvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232243AbhA1OqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77EB864DE8;
        Thu, 28 Jan 2021 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845069;
        bh=LYclJsgU7zLfnHvgaNEw4T/k0RU1A2lux24BYUCkn3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBqDLW5IEEMm339OWJeZU+u53MIzqEmN7VrU8YgGxLsuEPZDZvxvgIRKBP3sW6NPr
         Uy0WgVccnrcYbA/KnR/nnN0JgAYKbn5B+zZ5xfL//n75hBo/Y9JAM6zd4GgksX8RcT
         tGUVZAouBzKa7dDfzHW4C3wlsEeeby9G3kIUEMkTWnXLEPMHQaU2ih341VMtXdtAgy
         eK53Djlgp6FUDDi8UNzA3/+vXixPcJ90+6OvMAhBEkgc76v23lRhScfikYpErvCFOl
         hcY8Psz1pf4ASWKSSaRdjwFmbLoefdAr4X6Eop+KBV5NkBWYDSvNrgNqG1G//eElbI
         id3q9hyRugyIg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 07/11] net: xps: embed nr_ids in dev_maps
Date:   Thu, 28 Jan 2021 15:44:01 +0100
Message-Id: <20210128144405.4157244-8-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
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
 net/core/dev.c            | 26 +++++++++++---------------
 net/core/net-sysfs.c      |  4 ++--
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 481307de6983..f923eb97c446 100644
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
index 118cc0985ff1..2a0a777390c6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2505,14 +2505,14 @@ static void reset_xps_maps(struct net_device *dev,
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
@@ -2532,7 +2532,6 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 {
 	const unsigned long *possible_mask = NULL;
 	struct xps_dev_maps *dev_maps;
-	unsigned int nr_ids;
 
 	if (!static_key_false(&xps_needed))
 		return;
@@ -2542,11 +2541,9 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
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
@@ -2555,9 +2552,7 @@ static void netif_reset_xps_queues(struct net_device *dev, u16 offset,
 
 	if (num_possible_cpus() > 1)
 		possible_mask = cpumask_bits(cpu_possible_mask);
-	nr_ids = nr_cpu_ids;
-	clean_xps_maps(dev, possible_mask, dev_maps, nr_ids, offset, count,
-		       false);
+	clean_xps_maps(dev, possible_mask, dev_maps, offset, count, false);
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
@@ -2690,6 +2685,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 				return -ENOMEM;
 			}
 
+			new_dev_maps->nr_ids = nr_ids;
 			new_dev_maps->num_tc = num_tc;
 		}
 
@@ -3943,7 +3939,7 @@ static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 	struct xps_map *map;
 	int queue_index = -1;
 
-	if (tc >= dev_maps->num_tc)
+	if (tc >= dev_maps->num_tc || tci >= dev_maps->nr_ids)
 		return queue_index;
 
 	tci *= dev_maps->num_tc;
@@ -3982,7 +3978,7 @@ static int get_xps_queue(struct net_device *dev, struct net_device *sb_dev,
 	if (dev_maps) {
 		int tci = sk_rx_queue_get(sk);
 
-		if (tci >= 0 && tci < dev->num_rx_queues)
+		if (tci >= 0)
 			queue_index = __get_xps_queue_idx(dev, skb, dev_maps,
 							  tci);
 	}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f606f3556ad7..5b7123d3b66f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1331,16 +1331,16 @@ static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 
 	if (is_rxqs_map) {
 		dev_maps = rcu_dereference(dev->xps_rxqs_map);
-		nr_ids = dev->num_rx_queues;
 	} else {
 		dev_maps = rcu_dereference(dev->xps_cpus_map);
-		nr_ids = nr_cpu_ids;
 		if (num_possible_cpus() > 1)
 			possible_mask = cpumask_bits(cpu_possible_mask);
 	}
 	if (!dev_maps || tc >= dev_maps->num_tc)
 		goto rcu_unlock;
 
+	nr_ids = dev_maps->nr_ids;
+
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
 		int i, tci = j * dev_maps->num_tc + tc;
-- 
2.29.2

