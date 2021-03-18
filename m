Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A2340D43
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhCRSig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCRSiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 14:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9AB6023B;
        Thu, 18 Mar 2021 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092698;
        bh=EAxRa5L5Mua4Pp1KFSsOwuMpGCRCXqfhwjLcwjd1VvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcWttwDhWl5PivLeyFacoXEZuHcmPrBrwHMpcvRn4Ai0MrRNdIUhyizS3nrforxr/
         0SXDtYem1iyTAo+1b97qasEfhvsxL0ssoQDRBaZE/vZoeT2VZBgL3cfK0I8M70w58D
         t56hIb1LXoSKzbMsshVsbg+4lcjQxYsBzMij6MouDZDeO3CK+4iRfZTQSNmnjVBH4C
         kcGIKy3oiLotz1zDRs8RCtb4cdAcEqVsmcM7n8PV5mkaY0fnndNZVqIz9qIZTxkF+M
         cOSOhrJQVGDAzwFIk/z2OxUEEo/YtiwzdlchILDBN5TVPABulso7CMPiFA4E+0mYWc
         GAK+dK3nsLZmQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v4 08/13] net: add an helper to copy xps maps to the new dev_maps
Date:   Thu, 18 Mar 2021 19:37:47 +0100
Message-Id: <20210318183752.2612563-9-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
References: <20210318183752.2612563-1-atenart@kernel.org>
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
index af57e32bb543..00f6b41e11d8 100644
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
 /* Must be called under cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, enum xps_map_type type)
@@ -2694,23 +2713,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2725,18 +2737,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
2.30.2

