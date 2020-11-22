Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B612BC497
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 10:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgKVJFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 04:05:16 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58717 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbgKVJFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 04:05:15 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 22 Nov 2020 11:05:08 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AM9574e029162;
        Sun, 22 Nov 2020 11:05:08 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AM95759007355;
        Sun, 22 Nov 2020 17:05:07 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 0AM94wGu006843;
        Sun, 22 Nov 2020 17:04:58 +0800
From:   Zhu Yanjun <yanjunz@nvidia.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>, Zhu Yanjun <yanjunz@nvidia.com>
Subject: [PATCH 1/1] xdp: compact the function xsk_map_inc
Date:   Sun, 22 Nov 2020 17:04:51 +0800
Message-Id: <1606035891-6797-1-git-send-email-yanjunz@nvidia.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

The function xsk_map_inc always returns zero. As such, changing the
return type to void and removing the test code.

Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
---
 net/xdp/xsk.c    |    1 -
 net/xdp/xsk.h    |    2 +-
 net/xdp/xskmap.c |   10 ++--------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cfbec39..c1b8a88 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -548,7 +548,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 	node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
 					node);
 	if (node) {
-		WARN_ON(xsk_map_inc(node->map));
 		map = node->map;
 		*map_entry = node->map_entry;
 	}
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index b9e896c..766b9e2 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -41,7 +41,7 @@ struct xsk_map_node {
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
-int xsk_map_inc(struct xsk_map *map);
+void xsk_map_inc(struct xsk_map *map);
 void xsk_map_put(struct xsk_map *map);
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
 int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 49da2b8..c7dd94a 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -11,10 +11,9 @@
 
 #include "xsk.h"
 
-int xsk_map_inc(struct xsk_map *map)
+void xsk_map_inc(struct xsk_map *map)
 {
 	bpf_map_inc(&map->map);
-	return 0;
 }
 
 void xsk_map_put(struct xsk_map *map)
@@ -26,17 +25,12 @@ void xsk_map_put(struct xsk_map *map)
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
+	xsk_map_inc(map);
 
 	node->map = map;
 	node->map_entry = map_entry;
-- 
1.7.1

