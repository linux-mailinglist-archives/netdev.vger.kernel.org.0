Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3217230789D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhA1OtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232242AbhA1OqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ADAD64DE7;
        Thu, 28 Jan 2021 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845063;
        bh=guh8Y3D5WpBxBXIW36Sv2E+rYAoUFJg7h/uMzWpFCe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw/xqM8VYA+49LNcocD/GfQlEeNCKU91ZeGNVtYbzSsA3nKRpZuPMnx2rC1JcH8el
         xQVrssrEGBeEjvmt0EtJVJqOIN0adZGeRa85bjtbtxk0M3XlFjWclQJ0ZE2l1rnXZI
         CJ/OuYM4dcelh6aXuJ4oy1QBp60dpO14AiXcVFgs/cSfOB9Jzx4Liesw8XkfUde8F1
         b3u0V7FI/2HN8daM2lF95p0sKbm3efiHdA2yiQPkMDaA0xHtM2wu8yNG81L2pZ1aBL
         pzCJVHNecHu3CZsBxON0lJSoUo95hGIP9WFUWh9+zmc3wXdAxWDL4J1xxMzAMMlGR3
         rWnhjVxEIerew==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 05/11] net: add an helper to copy xps maps to the new dev_maps
Date:   Thu, 28 Jan 2021 15:43:59 +0100
Message-Id: <20210128144405.4157244-6-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an helper, xps_copy_dev_maps, to copy maps from dev_maps
to new_dev_maps at a given index. The logic should be the same, with an
improved code readability and maintenance.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f43281a7367c..7e5b1a4ae4a5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2609,6 +2609,25 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 	return new_map;
 }
 
+/* Copy xps maps at a given index */
+static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
+			      struct xps_dev_maps *new_dev_maps, int index,
+			      int tc, bool skip_tc)
+{
+	int i, tci = index * dev_maps->num_tc;
+	struct xps_map *map;
+
+	/* copy maps belonging to foreign traffic classes */
+	for (i = 0; i < dev_maps->num_tc; i++, tci++) {
+		if (i == tc && skip_tc)
+			continue;
+
+		/* fill in the new device map from the old device map */
+		map = xmap_dereference(dev_maps->attr_map[tci]);
+		RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
+	}
+}
+
 /* Must be called under cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map)
@@ -2696,23 +2715,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
-		/* copy maps belonging to foreign traffic classes */
-		for (i = tc, tci = j * num_tc; copy && i--; tci++) {
-			/* fill in the new device map from the old device map */
-			map = xmap_dereference(dev_maps->attr_map[tci]);
-			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
-		}
+		bool skip_tc = false;
 
-		/* We need to explicitly update tci as prevous loop
-		 * could break out early if dev_maps is NULL.
-		 */
 		tci = j * num_tc + tc;
-
 		if (netif_attr_test_mask(j, mask, nr_ids) &&
 		    netif_attr_test_online(j, online_mask, nr_ids)) {
 			/* add tx-queue to CPU/rx-queue maps */
 			int pos = 0;
 
+			skip_tc = true;
+
 			map = xmap_dereference(new_dev_maps->attr_map[tci]);
 			while ((pos < map->len) && (map->queues[pos] != index))
 				pos++;
@@ -2727,18 +2739,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 					numa_node_id = -1;
 			}
 #endif
-		} else if (copy) {
-			/* fill in the new device map from the old device map */
-			map = xmap_dereference(dev_maps->attr_map[tci]);
-			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
 		}
 
-		/* copy maps belonging to foreign traffic classes */
-		for (i = num_tc - tc, tci++; copy && --i; tci++) {
-			/* fill in the new device map from the old device map */
-			map = xmap_dereference(dev_maps->attr_map[tci]);
-			RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);
-		}
+		if (copy)
+			xps_copy_dev_maps(dev_maps, new_dev_maps, j, tc,
+					  skip_tc);
 	}
 
 	if (is_rxqs_map)
-- 
2.29.2

