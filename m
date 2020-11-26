Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F742C57CB
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391235AbgKZPDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:03:35 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55721 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391163AbgKZPDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:03:35 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 26 Nov 2020 17:03:31 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AQF3Vm0023036;
        Thu, 26 Nov 2020 17:03:31 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AQF3UFP012597;
        Thu, 26 Nov 2020 23:03:30 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 0AQF3N1o012591;
        Thu, 26 Nov 2020 23:03:23 +0800
From:   Zhu Yanjun <yanjunz@nvidia.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH v5 1/1] xdp: remove the functions xsk_map_inc and xsk_map_put
Date:   Thu, 26 Nov 2020 23:03:18 +0800
Message-Id: <1606402998-12562-1-git-send-email-yanjunz@nvidia.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

The functions xsk_map_put and xsk_map_inc are simple wrappers.
As such, replacing these functions with the functions bpf_map_inc
and bpf_map_put and removing some test codes.

Fixes: d20a1676df7e ("xsk: Move xskmap.c to net/xdp/")
Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 net/xdp/xsk.c    |  4 ++--
 net/xdp/xsk.h    |  2 --
 net/xdp/xskmap.c | 20 ++------------------
 3 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cfbec3989a76..4f0250f5d676 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
 	node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
 					node);
 	if (node) {
-		WARN_ON(xsk_map_inc(node->map));
+		bpf_map_inc(&node->map->map);
 		map = node->map;
 		*map_entry = node->map_entry;
 	}
@@ -578,7 +578,7 @@ static void xsk_delete_from_maps(struct xdp_sock *xs)
 
 	while ((map = xsk_get_map_list_entry(xs, &map_entry))) {
 		xsk_map_try_sock_delete(map, xs, map_entry);
-		xsk_map_put(map);
+		bpf_map_put(&map->map);
 	}
 }
 
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index b9e896cee5bb..edcf249ad1f1 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -41,8 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
-int xsk_map_inc(struct xsk_map *map);
-void xsk_map_put(struct xsk_map *map);
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
 int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
 			u16 queue_id);
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 49da2b8ace8b..66231ba6c348 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -11,32 +11,16 @@
 
 #include "xsk.h"
 
-int xsk_map_inc(struct xsk_map *map)
-{
-	bpf_map_inc(&map->map);
-	return 0;
-}
-
-void xsk_map_put(struct xsk_map *map)
-{
-	bpf_map_put(&map->map);
-}
-
 static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
 					       struct xdp_sock **map_entry)
 {
 	struct xsk_map_node *node;
-	int err;
 
 	node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 
-	err = xsk_map_inc(map);
-	if (err) {
-		kfree(node);
-		return ERR_PTR(err);
-	}
+	bpf_map_inc(&map->map);
 
 	node->map = map;
 	node->map_entry = map_entry;
@@ -45,7 +29,7 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
 
 static void xsk_map_node_free(struct xsk_map_node *node)
 {
-	xsk_map_put(node->map);
+	bpf_map_put(&node->map->map);
 	kfree(node);
 }
 
-- 
2.25.1

