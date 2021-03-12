Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2821B3390B4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhCLPFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhCLPFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD6E364F78;
        Fri, 12 Mar 2021 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561512;
        bh=abzu7yjRwHt6cpL0vf0+1d43bsI36Val4Dxh/GZy/HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crw/51TS/5KfJVVa8fCC3KlwU3LG4q7dPE3KinbHU5gn0XEAIAzwb2Uk0Bxf1bPNi
         yalcNagwBIOEL1fUqKQhBpbVHAmSVTIPScKsUgWigFqQTSdmdy5PSmAk3+tnMWZQAG
         sd4VdUBMWoq555DpfCL07Cw6/O5thz4ElHUGt0TXCqkl1mgBwdSK5+2shJyGYOdUiC
         AZCyV60AQHhBpz91O0UOeKGG00hvhg04QxIFH1kgXWFyr9qbWyDqh+n9dtI6T9afAv
         HK05LiHw63xKfUmvZWlLUyG7APoD0w+qof1CAU/HheZ9iwQ8SqGO46s78JGp9an7Ty
         iAlKUpA1C3Xbg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 09/16] net: add an helper to copy xps maps to the new dev_maps
Date:   Fri, 12 Mar 2021 16:04:37 +0100
Message-Id: <20210312150444.355207-10-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
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
index dfdd476a6d67..4d39938417c4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2608,6 +2608,25 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
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
 /* Must be called under rtnl_lock and cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, enum xps_map_type type)
@@ -2696,23 +2715,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	}
 
 	for (j = 0; j < nr_ids; j++) {
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
 
 	rcu_assign_pointer(dev->xps_maps[type], new_dev_maps);
-- 
2.29.2

