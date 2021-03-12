Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FEC3390BB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhCLPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232119AbhCLPFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD2F64F80;
        Fri, 12 Mar 2021 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561523;
        bh=OtJELyvwxwbcqivCTKnOesWBm51y5qBsGR0qwAtSA/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/zvwTXlLVqfIa8sQNbIBjRKKH3+9r7E0q3KEoDT+L9PBNaqfyNhqydDtdqwZXNxC
         0xzwFiXt62tOptdVzNBjAlsthEqf/tYzq7pn8u8jQmd2Q+51QD+vSjzsjtgJHjhCq/
         2woB6fZ78uzfIzp2vrq9wvF+9RYlnEvQE1JcYqZaJN1GNi2cDJfVUtEDNanaLflk3c
         ylKKuKGngaDwU3zyVpaNzVXSlmhcRveMTuQ/7jlr8Vs0eyp9FeWs7oqZQDLrjB8ofZ
         1y2CFCnmPuCAj3IHHfb8mCOl/qyAZhD2Nk2quKdYz54AhqvcO3obE92swbOIjAW5J/
         rGtYUThlK4Xuw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 13/16] net: fix use after free in xps
Date:   Fri, 12 Mar 2021 16:04:41 +0100
Message-Id: <20210312150444.355207-14-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up an new dev_maps in __netif_set_xps_queue, we remove and
free maps from unused CPUs/rx-queues near the end of the function; by
calling remove_xps_queue. However it's possible those maps are also part
of the old not-freed-yet dev_maps, which might be used concurrently.
When that happens, a map can be freed while its corresponding entry in
the old dev_maps table isn't NULLed, leading to:

  BUG: KASAN: use-after-free in xps_queue_show+0x469/0x480

This fixes the map freeing logic for unused CPUs/rx-queues, to also NULL
the map entries from the old dev_maps table.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 052797ca65f6..748e377c7fe3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2460,7 +2460,7 @@ static DEFINE_MUTEX(xps_map_mutex);
 	rcu_dereference_protected((P), lockdep_is_held(&xps_map_mutex))
 
 static bool remove_xps_queue(struct xps_dev_maps *dev_maps,
-			     int tci, u16 index)
+			     struct xps_dev_maps *old_maps, int tci, u16 index)
 {
 	struct xps_map *map = NULL;
 	int pos;
@@ -2479,6 +2479,8 @@ static bool remove_xps_queue(struct xps_dev_maps *dev_maps,
 			break;
 		}
 
+		if (old_maps)
+			RCU_INIT_POINTER(old_maps->attr_map[tci], NULL);
 		RCU_INIT_POINTER(dev_maps->attr_map[tci], NULL);
 		kfree_rcu(map, rcu);
 		return false;
@@ -2499,7 +2501,7 @@ static bool remove_xps_queue_cpu(struct net_device *dev,
 		int i, j;
 
 		for (i = count, j = offset; i--; j++) {
-			if (!remove_xps_queue(dev_maps, tci, j))
+			if (!remove_xps_queue(dev_maps, NULL, tci, j))
 				break;
 		}
 
@@ -2631,7 +2633,7 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, enum xps_map_type type)
 {
-	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL;
+	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL, *old_dev_maps = NULL;
 	const unsigned long *online_mask = NULL;
 	bool active = false, copy = false;
 	int i, j, tci, numa_node_id = -2;
@@ -2768,7 +2770,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		}
 	}
 
-	kfree_rcu(dev_maps, rcu);
+	old_dev_maps = copy ? dev_maps : NULL;
 
 out_no_old_maps:
 	dev_maps = new_dev_maps;
@@ -2794,10 +2796,14 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			    netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
 				continue;
 
-			active |= remove_xps_queue(dev_maps, tci, index);
+			active |= remove_xps_queue(dev_maps, old_dev_maps, tci,
+						   index);
 		}
 	}
 
+	if (old_dev_maps)
+		kfree_rcu(old_dev_maps, rcu);
+
 	/* free map if not active */
 	if (!active)
 		reset_xps_maps(dev, dev_maps, type);
-- 
2.29.2

