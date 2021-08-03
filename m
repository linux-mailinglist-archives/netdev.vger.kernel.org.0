Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5DB3DF862
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhHCXUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233463AbhHCXUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93BB560F70;
        Tue,  3 Aug 2021 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032820;
        bh=f12FcFKLWYfl3Yl2SCUybd/Sw3WOdJzqfECFxbR9zeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6qbRpM9WTJ+hPaArrou5phSH+QR9tF3VISWqrTLKa5dq9CZLKaXSiT/Vlz56B95r
         QDW7pn3KVKxUQgXR7vq5SQYA0fjz25nlw3M0pAiDqo4TqhI25+MkJWCXzuu7mWPWAD
         doLubOAb5zbxDqx8Pb/NaLh59YTOBFTVPuiPFrgGDw+VDw8hqSJoBSSi7PpRPsEnTr
         RxRrxGe3nHngni+sm7bhlx5hb5MbjhcVEcy/DNr5nGwLW/I7DoycM4J2aiQaPNP4bW
         8RZrJ357qduzZHhLC3jqqEfjEPEJzsGdgAHzqrveHTBRtmBqR+1Ty8OHHcBupY1JMh
         9A3TUrjImKi9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH mlx5-next 07/14] net/mlx5e: Add an option to create a shared mapping
Date:   Tue,  3 Aug 2021 16:19:52 -0700
Message-Id: <20210803231959.26513-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The shared mapping is identified by an id and type.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/mapping.c  | 45 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/mapping.h  |  5 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
index ea321e528749..4e72ca8070e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
@@ -5,11 +5,15 @@
 #include <linux/slab.h>
 #include <linux/xarray.h>
 #include <linux/hashtable.h>
+#include <linux/refcount.h>
 
 #include "mapping.h"
 
 #define MAPPING_GRACE_PERIOD 2000
 
+static LIST_HEAD(shared_ctx_list);
+static DEFINE_MUTEX(shared_ctx_lock);
+
 struct mapping_ctx {
 	struct xarray xarray;
 	DECLARE_HASHTABLE(ht, 8);
@@ -20,6 +24,10 @@ struct mapping_ctx {
 	struct delayed_work dwork;
 	struct list_head pending_list;
 	spinlock_t pending_list_lock; /* Guards pending list */
+	u64 id;
+	u8 type;
+	struct list_head list;
+	refcount_t refcount;
 };
 
 struct mapping_item {
@@ -205,11 +213,48 @@ mapping_create(size_t data_size, u32 max_id, bool delayed_removal)
 	mutex_init(&ctx->lock);
 	xa_init_flags(&ctx->xarray, XA_FLAGS_ALLOC1);
 
+	refcount_set(&ctx->refcount, 1);
+	INIT_LIST_HEAD(&ctx->list);
+
+	return ctx;
+}
+
+struct mapping_ctx *
+mapping_create_for_id(u64 id, u8 type, size_t data_size, u32 max_id, bool delayed_removal)
+{
+	struct mapping_ctx *ctx;
+
+	mutex_lock(&shared_ctx_lock);
+	list_for_each_entry(ctx, &shared_ctx_list, list) {
+		if (ctx->id == id && ctx->type == type) {
+			if (refcount_inc_not_zero(&ctx->refcount))
+				goto unlock;
+			break;
+		}
+	}
+
+	ctx = mapping_create(data_size, max_id, delayed_removal);
+	if (IS_ERR(ctx))
+		goto unlock;
+
+	ctx->id = id;
+	ctx->type = type;
+	list_add(&ctx->list, &shared_ctx_list);
+
+unlock:
+	mutex_unlock(&shared_ctx_lock);
 	return ctx;
 }
 
 void mapping_destroy(struct mapping_ctx *ctx)
 {
+	if (!refcount_dec_and_test(&ctx->refcount))
+		return;
+
+	mutex_lock(&shared_ctx_lock);
+	list_del(&ctx->list);
+	mutex_unlock(&shared_ctx_lock);
+
 	mapping_flush_work(ctx);
 	xa_destroy(&ctx->xarray);
 	mutex_destroy(&ctx->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
index 285525cc5470..4e2119f0f4c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h
@@ -24,4 +24,9 @@ struct mapping_ctx *mapping_create(size_t data_size, u32 max_id,
 				   bool delayed_removal);
 void mapping_destroy(struct mapping_ctx *ctx);
 
+/* adds mapping with an id or get an existing mapping with the same id
+ */
+struct mapping_ctx *
+mapping_create_for_id(u64 id, u8 type, size_t data_size, u32 max_id, bool delayed_removal);
+
 #endif /* __MLX5_MAPPING_H__ */
-- 
2.31.1

