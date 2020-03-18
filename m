Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79809189D4D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgCRNtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43577 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgCRNtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6142B5C019D;
        Wed, 18 Mar 2020 09:49:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=draDYSIacNwzLUFJmjs/1fpZpKxcl/1JMzltwL37bsE=; b=Qo28T4Su
        n/IYlbeVVjRrWFjMHNAc9vHHZV5ybbydT/OoehhkO/pzQWN4DO1wc7uqU0lngXqy
        axOFYSyPMndE/fYfRVsRHGrhtfMeZSMHNGLaJVxH/dhEiYY7SR4mso3EjId8uY3a
        9Di73U+7dGDKkzJaKOYZyQMOWMavHGaZ55gSnw8jARU8QU8jaDVALfukfZ0Wa1rR
        bp8w/2fFZokqm060GWKK8yHEsG9H1Muxf3fH8kuwSLRqo2fz61SMoAA8GfT2rWAe
        r0c153lL8IGxFBJwE0VZodb12DUgHV92UO9uvNwrwbnhp160O2keE3P/nmQkIzJK
        6brL6M/xCAbdvg==
X-ME-Sender: <xms:-SZyXjI1YwQVm9cBYSBRYU9Fg3NgKMp17BTcS7VS0m9fYDHP8grM0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:-SZyXloai4Um1wv2HhIJlbrxNCQ3jRVq4mq_-c-a6nZNyKD4pwZoVA>
    <xmx:-SZyXnNT_cr9D2T_J9bz-AUjUUNzHxQ7zAArNFPoPJL42XCjE5TSgw>
    <xmx:-SZyXmhtVZFW3XZAf8fnXjZTmuqMWyq-7ea7-ZUhAzAxikKw4kINkA>
    <xmx:-SZyXsKpP8NQ__a3EV8yFx6xWCbNZ2C5LUICl_6ct5rBLbpcplsBuQ>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19C2230618C1;
        Wed, 18 Mar 2020 09:49:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_cnt: Move sub_pools under per-instance pool struct
Date:   Wed, 18 Mar 2020 15:48:51 +0200
Message-Id: <20200318134857.1003018-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, the global static array of subpools is used. Make it
per-instance as multiple instances of the mlxsw driver can have
different values.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 45 +++++++++++--------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 37811181586a..4cdabde47dd0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -18,10 +18,11 @@ struct mlxsw_sp_counter_pool {
 	unsigned int pool_size;
 	unsigned long *usage; /* Usage bitmap */
 	spinlock_t counter_pool_lock; /* Protects counter pool allocations */
-	struct mlxsw_sp_counter_sub_pool *sub_pools;
+	unsigned int sub_pools_count;
+	struct mlxsw_sp_counter_sub_pool sub_pools[];
 };
 
-static struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
+static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	[MLXSW_SP_COUNTER_SUB_POOL_FLOW] = {
 		.bank_count = 6,
 	},
@@ -32,6 +33,7 @@ static struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 
 static int mlxsw_sp_counter_pool_validate(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
 	unsigned int total_bank_config = 0;
 	unsigned int pool_size;
 	unsigned int bank_size;
@@ -40,8 +42,8 @@ static int mlxsw_sp_counter_pool_validate(struct mlxsw_sp *mlxsw_sp)
 	pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
 	bank_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_BANK_SIZE);
 	/* Check config is valid, no bank over subscription */
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++)
-		total_bank_config += mlxsw_sp_counter_sub_pools[i].bank_count;
+	for (i = 0; i < pool->sub_pools_count; i++)
+		total_bank_config += pool->sub_pools[i].bank_count;
 	if (total_bank_config > pool_size / bank_size + 1)
 		return -EINVAL;
 	return 0;
@@ -49,16 +51,17 @@ static int mlxsw_sp_counter_pool_validate(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 
 	/* Prepare generic flow pool*/
-	sub_pool = &mlxsw_sp_counter_sub_pools[MLXSW_SP_COUNTER_SUB_POOL_FLOW];
+	sub_pool = &pool->sub_pools[MLXSW_SP_COUNTER_SUB_POOL_FLOW];
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_SIZE_PACKETS_BYTES))
 		return -EIO;
 	sub_pool->entry_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
 						  COUNTER_SIZE_PACKETS_BYTES);
 	/* Prepare erif pool*/
-	sub_pool = &mlxsw_sp_counter_sub_pools[MLXSW_SP_COUNTER_SUB_POOL_RIF];
+	sub_pool = &pool->sub_pools[MLXSW_SP_COUNTER_SUB_POOL_RIF];
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_SIZE_ROUTER_BASIC))
 		return -EIO;
 	sub_pool->entry_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
@@ -68,6 +71,7 @@ static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 
 int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 {
+	unsigned int sub_pools_count = ARRAY_SIZE(mlxsw_sp_counter_sub_pools);
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	struct mlxsw_sp_counter_pool *pool;
 	unsigned int base_index;
@@ -80,18 +84,23 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	    !MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_BANK_SIZE))
 		return -EIO;
 
+	pool = kzalloc(struct_size(pool, sub_pools, sub_pools_count),
+		       GFP_KERNEL);
+	if (!pool)
+		return -ENOMEM;
+	mlxsw_sp->counter_pool = pool;
+	memcpy(pool->sub_pools, mlxsw_sp_counter_sub_pools,
+	       sub_pools_count * sizeof(*sub_pool));
+	pool->sub_pools_count = sub_pools_count;
+	spin_lock_init(&pool->counter_pool_lock);
+
 	err = mlxsw_sp_counter_pool_validate(mlxsw_sp);
 	if (err)
-		return err;
+		goto err_pool_validate;
 
 	err = mlxsw_sp_counter_sub_pools_prepare(mlxsw_sp);
 	if (err)
-		return err;
-
-	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool)
-		return -ENOMEM;
-	spin_lock_init(&pool->counter_pool_lock);
+		goto err_sub_pools_prepare;
 
 	pool->pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
 	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
@@ -104,12 +113,11 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_usage_alloc;
 	}
 
-	pool->sub_pools = mlxsw_sp_counter_sub_pools;
 	/* Allocation is based on bank count which should be
 	 * specified for each sub pool statically.
 	 */
 	base_index = 0;
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++) {
+	for (i = 0; i < pool->sub_pools_count; i++) {
 		sub_pool = &pool->sub_pools[i];
 		sub_pool->size = sub_pool->bank_count * bank_size;
 		sub_pool->base_index = base_index;
@@ -119,10 +127,11 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 			sub_pool->size = pool->pool_size - sub_pool->base_index;
 	}
 
-	mlxsw_sp->counter_pool = pool;
 	return 0;
 
 err_usage_alloc:
+err_sub_pools_prepare:
+err_pool_validate:
 	kfree(pool);
 	return err;
 }
@@ -147,7 +156,7 @@ int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 	unsigned int stop_index;
 	int i, err;
 
-	sub_pool = &mlxsw_sp_counter_sub_pools[sub_pool_id];
+	sub_pool = &pool->sub_pools[sub_pool_id];
 	stop_index = sub_pool->base_index + sub_pool->size;
 	entry_index = sub_pool->base_index;
 
@@ -186,7 +195,7 @@ void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
 
 	if (WARN_ON(counter_index >= pool->pool_size))
 		return;
-	sub_pool = &mlxsw_sp_counter_sub_pools[sub_pool_id];
+	sub_pool = &pool->sub_pools[sub_pool_id];
 	spin_lock(&pool->counter_pool_lock);
 	for (i = 0; i < sub_pool->entry_size; i++)
 		__clear_bit(counter_index + i, pool->usage);
-- 
2.24.1

