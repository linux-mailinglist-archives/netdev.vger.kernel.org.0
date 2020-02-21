Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45D1685A5
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgBURyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43339 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729096AbgBURys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D12202208A;
        Fri, 21 Feb 2020 12:54:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=TVgG+c4XxPTmmWC5EbeqRblWbhOKfLkAKRandS3P6so=; b=0N1lPcjv
        0oLca+ouOuHA07eUjZ9M8JjwQYU0Rt9OOTCVGv2umA/Zo9MMhZV2vxXiXYHROwDA
        2YSqSsN3JEIjIlPU9gS7EK8cPGTtEpEDhV2z7dIxWpm3AfD5fIwYM3Rh4X1QPwOX
        +bbHpRRIkA0rAZFpvkR/WnbEYmZBnZMOvCtdkaC8HzLSUDauv9MHtJ3u+eE83oma
        /Grq7Y98E7IXuXAX5wpBsZjmrcBflE/407kVQDKpaGh++kYm1C4ulCB1FNwdJU2L
        QZjFR+ilDFSxTdUbVSXCEum4dPeQkJZaZYtEpOX1hzJ5aYvTP4aAakoFG6WGWGtJ
        TC9FNCPjR2dyfA==
X-ME-Sender: <xms:ZhlQXr-6TJ57Iao2IJJDgYoMGRRj5lUrn7Jw5HwHEkOMKfXo5uYT0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ZhlQXr8SrMF-VAnC5pm5xPresGx4cfvvu_8YU33c6mIm1bL4xTV1kA>
    <xmx:ZhlQXkCC2rpIquH02BCDRg3-oqAnJQn1qTCfq0s5vYHhWwWq60jVnA>
    <xmx:ZhlQXrz-DYJ6ADz-U95ygY3FT1uRysFXjFl5P7jHcMQX3uSKuhXgPA>
    <xmx:ZhlQXvu7-OcdxVlzBFnXyGmfPFGqY6KcctGIvvwEfLZuLNlkAa-3Mw>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 395963060BD1;
        Fri, 21 Feb 2020 12:54:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/12] mlxsw: spectrum_mr: Protect multicast route list with a lock
Date:   Fri, 21 Feb 2020 19:54:06 +0200
Message-Id: <20200221175415.390884-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Protect the per-table multicast route list with a lock and remove RTNL
from the delayed work that periodically updates the kernel about packets
and bytes statistics from each multicast route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 0d64d8c4038b..085d9676e34b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -68,6 +68,7 @@ struct mlxsw_sp_mr_table {
 	u32 vr_id;
 	struct mlxsw_sp_mr_vif vifs[MAXVIFS];
 	struct list_head route_list;
+	struct mutex route_list_lock; /* Protects route_list */
 	struct rhashtable route_ht;
 	const struct mlxsw_sp_mr_table_ops *ops;
 	char catchall_route_priv[];
@@ -372,6 +373,8 @@ static void mlxsw_sp_mr_mfc_offload_update(struct mlxsw_sp_mr_route *mr_route)
 static void __mlxsw_sp_mr_route_del(struct mlxsw_sp_mr_table *mr_table,
 				    struct mlxsw_sp_mr_route *mr_route)
 {
+	WARN_ON_ONCE(!mutex_is_locked(&mr_table->route_list_lock));
+
 	mlxsw_sp_mr_mfc_offload_set(mr_route, false);
 	rhashtable_remove_fast(&mr_table->route_ht, &mr_route->ht_node,
 			       mlxsw_sp_mr_route_ht_params);
@@ -423,7 +426,9 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 		goto err_mr_route_write;
 
 	/* Put it in the table data-structures */
+	mutex_lock(&mr_table->route_list_lock);
 	list_add_tail(&mr_route->node, &mr_table->route_list);
+	mutex_unlock(&mr_table->route_list_lock);
 	err = rhashtable_insert_fast(&mr_table->route_ht,
 				     &mr_route->ht_node,
 				     mlxsw_sp_mr_route_ht_params);
@@ -443,7 +448,9 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 	return 0;
 
 err_rhashtable_insert:
+	mutex_lock(&mr_table->route_list_lock);
 	list_del(&mr_route->node);
+	mutex_unlock(&mr_table->route_list_lock);
 	mlxsw_sp_mr_route_erase(mr_table, mr_route);
 err_mr_route_write:
 err_no_orig_route:
@@ -461,8 +468,11 @@ void mlxsw_sp_mr_route_del(struct mlxsw_sp_mr_table *mr_table,
 	mr_table->ops->key_create(mr_table, &key, mfc);
 	mr_route = rhashtable_lookup_fast(&mr_table->route_ht, &key,
 					  mlxsw_sp_mr_route_ht_params);
-	if (mr_route)
+	if (mr_route) {
+		mutex_lock(&mr_table->route_list_lock);
 		__mlxsw_sp_mr_route_del(mr_table, mr_route);
+		mutex_unlock(&mr_table->route_list_lock);
+	}
 }
 
 /* Should be called after the VIF struct is updated */
@@ -911,6 +921,7 @@ struct mlxsw_sp_mr_table *mlxsw_sp_mr_table_create(struct mlxsw_sp *mlxsw_sp,
 	mr_table->proto = proto;
 	mr_table->ops = &mlxsw_sp_mr_table_ops_arr[proto];
 	INIT_LIST_HEAD(&mr_table->route_list);
+	mutex_init(&mr_table->route_list_lock);
 
 	err = rhashtable_init(&mr_table->route_ht,
 			      &mlxsw_sp_mr_route_ht_params);
@@ -936,6 +947,7 @@ struct mlxsw_sp_mr_table *mlxsw_sp_mr_table_create(struct mlxsw_sp *mlxsw_sp,
 err_ops_route_create:
 	rhashtable_destroy(&mr_table->route_ht);
 err_route_rhashtable_init:
+	mutex_destroy(&mr_table->route_list_lock);
 	kfree(mr_table);
 	return ERR_PTR(err);
 }
@@ -952,6 +964,7 @@ void mlxsw_sp_mr_table_destroy(struct mlxsw_sp_mr_table *mr_table)
 	mr->mr_ops->route_destroy(mlxsw_sp, mr->priv,
 				  &mr_table->catchall_route_priv);
 	rhashtable_destroy(&mr_table->route_ht);
+	mutex_destroy(&mr_table->route_list_lock);
 	kfree(mr_table);
 }
 
@@ -960,8 +973,10 @@ void mlxsw_sp_mr_table_flush(struct mlxsw_sp_mr_table *mr_table)
 	struct mlxsw_sp_mr_route *mr_route, *tmp;
 	int i;
 
+	mutex_lock(&mr_table->route_list_lock);
 	list_for_each_entry_safe(mr_route, tmp, &mr_table->route_list, node)
 		__mlxsw_sp_mr_route_del(mr_table, mr_route);
+	mutex_unlock(&mr_table->route_list_lock);
 
 	for (i = 0; i < MAXVIFS; i++) {
 		mr_table->vifs[i].dev = NULL;
@@ -1005,14 +1020,15 @@ static void mlxsw_sp_mr_stats_update(struct work_struct *work)
 	struct mlxsw_sp_mr_route *mr_route;
 	unsigned long interval;
 
-	rtnl_lock();
 	mutex_lock(&mr->table_list_lock);
-	list_for_each_entry(mr_table, &mr->table_list, node)
+	list_for_each_entry(mr_table, &mr->table_list, node) {
+		mutex_lock(&mr_table->route_list_lock);
 		list_for_each_entry(mr_route, &mr_table->route_list, node)
 			mlxsw_sp_mr_route_stats_update(mr_table->mlxsw_sp,
 						       mr_route);
+		mutex_unlock(&mr_table->route_list_lock);
+	}
 	mutex_unlock(&mr->table_list_lock);
-	rtnl_unlock();
 
 	interval = msecs_to_jiffies(MLXSW_SP_MR_ROUTES_COUNTER_UPDATE_INTERVAL);
 	mlxsw_core_schedule_dw(&mr->stats_update_dw, interval);
-- 
2.24.1

