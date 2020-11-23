Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F172C0E6B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389343AbgKWPF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:05:28 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41666 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729602AbgKWPF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:05:28 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 23 Nov 2020 17:05:24 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0ANF5NUE014263;
        Mon, 23 Nov 2020 17:05:24 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0ANF5Nhh025369;
        Mon, 23 Nov 2020 23:05:23 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 0ANF5Hpt025364;
        Mon, 23 Nov 2020 23:05:17 +0800
From:   Zhu Yanjun <yanjunz@nvidia.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
Date:   Mon, 23 Nov 2020 23:05:15 +0800
Message-Id: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

The function xsk_map_inc is a simple wrapper of bpf_map_inc and
always returns zero. As such, replacing this function with bpf_map_inc
and removing the test code.

Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 net/xdp/xsk.c    |  2 +-
 net/xdp/xsk.h    |  1 -
 net/xdp/xskmap.c | 13 +------------
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cfbec3989a76..a3c1f07d77d8 100644
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
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index b9e896cee5bb..0aad25c0e223 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
-int xsk_map_inc(struct xsk_map *map);
 void xsk_map_put(struct xsk_map *map);
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
 int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 49da2b8ace8b..6b7e9a72b101 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -11,12 +11,6 @@
 
 #include "xsk.h"
 
-int xsk_map_inc(struct xsk_map *map)
-{
-	bpf_map_inc(&map->map);
-	return 0;
-}
-
 void xsk_map_put(struct xsk_map *map)
 {
 	bpf_map_put(&map->map);
@@ -26,17 +20,12 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
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
-- 
2.25.1

