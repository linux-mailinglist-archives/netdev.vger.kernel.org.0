Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0592716582D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgBTHIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:24 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38855 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgBTHIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:23 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 68BF121ACE;
        Thu, 20 Feb 2020 02:08:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/h0m9wBXnUPpEpwbkj6pletj3bXXmYwZYypB09fp4NM=; b=UvCeAZGh
        +Fxz9Zagw95mYZ2SnkjKI4PnvfttAA5hzFoicrUvIFwpWoTqUTw6K6ZHXKXHe4TN
        sh2GPb+jFVw3jqeodDM3k/jzNG6Lvy4gqAbZYN0FYNW0FhOKzpuclVUyKb8ChNmt
        lfN5mdNoNYu33wbKgGKx401D0fwmJYtf2rnEzbO/zMxy/VIyPQFFkICY0GcfPBk+
        Ub3iVvnaN5O3t2Sx3TryY/NoBlv6BI27wSGOBNJExu/hvNCU8kbpTRAPBBfmay5A
        Pw3b6/4c6efHJgWD92xEFW8dQu3Sa7x5mlks/P/yJW3/A9p/ptyZNXGkNx5Z4tw2
        z+PSgVv2MiyGkw==
X-ME-Sender: <xms:ZjBOXuHE9BS5PffjvM7OL_r5mdXGSoHgxWPqRoU4vehRZFCks2EHAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:ZjBOXoBH9eTuRBYCEm4vl45JKL-o97VZqwDU_AqIDj2eyqbro89Ffg>
    <xmx:ZjBOXoEGMrhm3IDukgNiPxuUIX0aYm3cvmU6Pr0z8h7rNJdtrjSjFw>
    <xmx:ZjBOXkmjcgn2_RFlKncpmFHTBeaU98l906b_802FfKE9Z-SYFrp4ow>
    <xmx:ZjBOXm6YSky-dX6wMyNAPZi7v7JHw3xRE9LC41IQWgvrPdJLvoD7xQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F57F3060C28;
        Thu, 20 Feb 2020 02:08:21 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/15] mlxsw: spectrum: Protect counter pool with a lock
Date:   Thu, 20 Feb 2020 09:07:47 +0200
Message-Id: <20200220070800.364235-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The counter pool is a shared resource. It is used by both the ACL code
to allocate counters for actions and by the routing code to allocate
counters for adjacency entries (for example).

Currently, all allocations are protected by RTNL, but this is going to
change with the removal of RTNL from the routing code.

Therefore, protect counter allocations with a spin lock.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 25 +++++++++++++++----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 83c2e1e5f216..6a02ef9ec00e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 
 #include "spectrum_cnt.h"
 
@@ -18,6 +19,7 @@ struct mlxsw_sp_counter_sub_pool {
 struct mlxsw_sp_counter_pool {
 	unsigned int pool_size;
 	unsigned long *usage; /* Usage bitmap */
+	spinlock_t counter_pool_lock; /* Protects counter pool allocations */
 	struct mlxsw_sp_counter_sub_pool *sub_pools;
 };
 
@@ -87,6 +89,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return -ENOMEM;
+	spin_lock_init(&pool->counter_pool_lock);
 
 	pool->pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
 	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
@@ -139,25 +142,35 @@ int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	unsigned int entry_index;
 	unsigned int stop_index;
-	int i;
+	int i, err;
 
 	sub_pool = &mlxsw_sp_counter_sub_pools[sub_pool_id];
 	stop_index = sub_pool->base_index + sub_pool->size;
 	entry_index = sub_pool->base_index;
 
+	spin_lock(&pool->counter_pool_lock);
 	entry_index = find_next_zero_bit(pool->usage, stop_index, entry_index);
-	if (entry_index == stop_index)
-		return -ENOBUFS;
+	if (entry_index == stop_index) {
+		err = -ENOBUFS;
+		goto err_alloc;
+	}
 	/* The sub-pools can contain non-integer number of entries
 	 * so we must check for overflow
 	 */
-	if (entry_index + sub_pool->entry_size > stop_index)
-		return -ENOBUFS;
+	if (entry_index + sub_pool->entry_size > stop_index) {
+		err = -ENOBUFS;
+		goto err_alloc;
+	}
 	for (i = 0; i < sub_pool->entry_size; i++)
 		__set_bit(entry_index + i, pool->usage);
+	spin_unlock(&pool->counter_pool_lock);
 
 	*p_counter_index = entry_index;
 	return 0;
+
+err_alloc:
+	spin_unlock(&pool->counter_pool_lock);
+	return err;
 }
 
 void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
@@ -171,6 +184,8 @@ void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
 	if (WARN_ON(counter_index >= pool->pool_size))
 		return;
 	sub_pool = &mlxsw_sp_counter_sub_pools[sub_pool_id];
+	spin_lock(&pool->counter_pool_lock);
 	for (i = 0; i < sub_pool->entry_size; i++)
 		__clear_bit(counter_index + i, pool->usage);
+	spin_unlock(&pool->counter_pool_lock);
 }
-- 
2.24.1

