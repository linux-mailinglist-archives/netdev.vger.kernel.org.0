Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F5313AE0
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhBHR1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhBHRV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5338864EB7;
        Mon,  8 Feb 2021 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804784;
        bh=PGkHdnBKM6xlNhxMD9DKJ3OCKrckAm6EHFx6qL0K8SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8GqRFYgA+UuI2YEMjozbVYZsYkWHu3A+m6DEd6UpwOHg3IdRdcppM8sfwnz10pBy
         b4eV7by3s29eZ8CI8yMgsUl+chLWqJaxZKAv+m38VCECPOeUMZ+FP5K3lIfS9ElMyn
         sJD8D6oy+7Lf7onAXaHw1D7icW9fYuS8k6qg7Mxuyuf1VyaGYo/DZNHUgJCGfxVuzC
         +hACPABo3M2FwhGGBftcuxplKETJNIv9Vij9yfmTBVMvMUphV5F6FS+hq0t2jVXW8T
         gx35qBr4aUIBoz/GSBBGxY+O7574NipkIEpBPgyx9rlbx/8JUppKbyAtchyMy3rTHy
         TXpKoLRmlHsnw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 10/12] net: add an helper to copy xps maps to the new dev_maps
Date:   Mon,  8 Feb 2021 18:19:15 +0100
Message-Id: <20210208171917.1088230-11-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
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
index 6a2f827beca1..9b91e0d0895c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2589,6 +2589,25 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
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
@@ -2676,23 +2695,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2707,18 +2719,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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

