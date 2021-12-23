Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6293E47E91A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350354AbhLWVds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 16:33:48 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:51466 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350348AbhLWVds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 16:33:48 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 0VianGsLVbyf90VibnnW85; Thu, 23 Dec 2021 22:33:45 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 23 Dec 2021 22:33:45 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jiri@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] lib: objagg: Use the bitmap API when applicable
Date:   Thu, 23 Dec 2021 22:33:42 +0100
Message-Id: <f9541b085ec68e573004e1be200c11c9c901181a.1640295165.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'bitmap_zalloc()' to simplify code, improve the semantic and reduce
some open-coded arithmetic in allocator arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 lib/objagg.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/objagg.c b/lib/objagg.c
index 5e1676ccdadd..1e248629ed64 100644
--- a/lib/objagg.c
+++ b/lib/objagg.c
@@ -781,7 +781,6 @@ static struct objagg_tmp_graph *objagg_tmp_graph_create(struct objagg *objagg)
 	struct objagg_tmp_node *node;
 	struct objagg_tmp_node *pnode;
 	struct objagg_obj *objagg_obj;
-	size_t alloc_size;
 	int i, j;
 
 	graph = kzalloc(sizeof(*graph), GFP_KERNEL);
@@ -793,9 +792,7 @@ static struct objagg_tmp_graph *objagg_tmp_graph_create(struct objagg *objagg)
 		goto err_nodes_alloc;
 	graph->nodes_count = nodes_count;
 
-	alloc_size = BITS_TO_LONGS(nodes_count * nodes_count) *
-		     sizeof(unsigned long);
-	graph->edges = kzalloc(alloc_size, GFP_KERNEL);
+	graph->edges = bitmap_zalloc(nodes_count * nodes_count, GFP_KERNEL);
 	if (!graph->edges)
 		goto err_edges_alloc;
 
@@ -833,7 +830,7 @@ static struct objagg_tmp_graph *objagg_tmp_graph_create(struct objagg *objagg)
 
 static void objagg_tmp_graph_destroy(struct objagg_tmp_graph *graph)
 {
-	kfree(graph->edges);
+	bitmap_free(graph->edges);
 	kfree(graph->nodes);
 	kfree(graph);
 }
-- 
2.32.0

