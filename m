Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1553FDB6
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiFGLk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241960AbiFGLkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC0FB0A61;
        Tue,  7 Jun 2022 04:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C2CB81F68;
        Tue,  7 Jun 2022 11:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A66C385A5;
        Tue,  7 Jun 2022 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654602040;
        bh=NfhPe9oMQKlg8Y9gwx3WwiaEVXLLL3MZavLTXMIpJAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLxb73JtenHXGgrm4bowZlC9UDSW78Rwb8M0GUxeVS24c525j2uEhwjocIcmrrtOt
         m7ucglTm5PmAITX80fdc3BaG8jXv25x0nJ61qWH0Tqi8SppwB2QGrY6qiH3B5cx8x3
         8TpI5+4EZQ7ISZploPi/QC7x+xuDi5GmCqEIUJ1tzcBpng1jSWWm5HmISE0P/IYDqZ
         kNZ7tF0VpbMQ0TgDElR0B7rNi0wpETpj0ZG1nNWxXzc/3x+go47a4OJBP6XHj9Fbnw
         gZ9o+vbEZV5zTMJDy5LSLcIzgtYXyflBcNCeYWE1wCyJyODomaY2I41YOhnvlMgC18
         grH9h6q42TG4A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 4/5] RDMA/mlx5: Store in the cache mkeys instead of mrs
Date:   Tue,  7 Jun 2022 14:40:14 +0300
Message-Id: <1cb9aaec2995a26468f3ebfe719ff9a6baa97cf9.1654601897.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654601897.git.leonro@nvidia.com>
References: <cover.1654601897.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Currently, the driver stores mlx5_ib_mr struct in the cache entries,
although the only use of the cached MR is the mkey. Store only the mkey
in the cache.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  26 ++--
 drivers/infiniband/hw/mlx5/mr.c      | 205 ++++++++++++---------------
 2 files changed, 99 insertions(+), 132 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 47515dc27b51..de0375a46b36 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -613,6 +613,7 @@ struct mlx5_ib_mkey {
 	unsigned int ndescs;
 	struct wait_queue_head wait;
 	refcount_t usecount;
+	struct mlx5_cache_ent *cache_ent;
 };
 
 #define MLX5_IB_MTT_PRESENT (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE)
@@ -635,18 +636,9 @@ struct mlx5_ib_mr {
 	struct ib_mr ibmr;
 	struct mlx5_ib_mkey mmkey;
 
-	/* User MR data */
-	struct mlx5_cache_ent *cache_ent;
-	/* Everything after cache_ent is zero'd when MR allocated */
 	struct ib_umem *umem;
 
 	union {
-		/* Used only while the MR is in the cache */
-		struct {
-			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
-			struct mlx5_async_work cb_work;
-		};
-
 		/* Used only by kernel MRs (umem == NULL) */
 		struct {
 			void *descs;
@@ -686,12 +678,6 @@ struct mlx5_ib_mr {
 	};
 };
 
-/* Zero the fields in the mr that are variant depending on usage */
-static inline void mlx5_clear_mr(struct mlx5_ib_mr *mr)
-{
-	memset_after(mr, 0, cache_ent);
-}
-
 static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
 {
 	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
@@ -762,6 +748,16 @@ struct mlx5_cache_ent {
 	struct delayed_work	dwork;
 };
 
+struct mlx5r_async_create_mkey {
+	union {
+		u32 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
+		u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
+	};
+	struct mlx5_async_work cb_work;
+	struct mlx5_cache_ent *ent;
+	u32 mkey;
+};
+
 struct mlx5_mr_cache {
 	struct workqueue_struct *wq;
 	struct mlx5_cache_ent	ent[MAX_MR_CACHE_ENTRIES];
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 80672d275d77..9ffe308c2bdf 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -82,15 +82,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
 }
 
-static void assign_mkey_variant(struct mlx5_ib_dev *dev,
-				struct mlx5_ib_mkey *mkey, u32 *in)
+static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 {
 	u8 key = atomic_inc_return(&dev->mkey_var);
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, mkey_7_0, key);
-	mkey->key = key;
+	*mkey = key;
 }
 
 static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
@@ -98,7 +97,7 @@ static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
 {
 	int ret;
 
-	assign_mkey_variant(dev, mkey, in);
+	assign_mkey_variant(dev, &mkey->key, in);
 	ret = mlx5_core_create_mkey(dev->mdev, &mkey->key, in, inlen);
 	if (!ret)
 		init_waitqueue_head(&mkey->wait);
@@ -106,17 +105,18 @@ static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int
-mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
-		       struct mlx5_ib_mkey *mkey,
-		       struct mlx5_async_ctx *async_ctx,
-		       u32 *in, int inlen, u32 *out, int outlen,
-		       struct mlx5_async_work *context)
+static int mlx5_ib_create_mkey_cb(struct mlx5r_async_create_mkey *async_create)
 {
-	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
-	assign_mkey_variant(dev, mkey, in);
-	return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
-				create_mkey_callback, context);
+	struct mlx5_ib_dev *dev = async_create->ent->dev;
+	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	size_t outlen = MLX5_ST_SZ_BYTES(create_mkey_out);
+
+	MLX5_SET(create_mkey_in, async_create->in, opcode,
+		 MLX5_CMD_OP_CREATE_MKEY);
+	assign_mkey_variant(dev, &async_create->mkey, async_create->in);
+	return mlx5_cmd_exec_cb(&dev->async_ctx, async_create->in, inlen,
+				async_create->out, outlen, create_mkey_callback,
+				&async_create->cb_work);
 }
 
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
@@ -200,48 +200,47 @@ static void undo_push_reserve_mkey(struct mlx5_cache_ent *ent)
 	WARN_ON(old);
 }
 
-static void push_to_reserved(struct mlx5_cache_ent *ent, struct mlx5_ib_mr *mr)
+static void push_to_reserved(struct mlx5_cache_ent *ent, u32 mkey)
 {
 	void *old;
 
-	old = __xa_store(&ent->mkeys, ent->stored, mr, 0);
+	old = __xa_store(&ent->mkeys, ent->stored, xa_mk_value(mkey), 0);
 	WARN_ON(old);
 	ent->stored++;
 }
 
-static struct mlx5_ib_mr *pop_stored_mkey(struct mlx5_cache_ent *ent)
+static u32 pop_stored_mkey(struct mlx5_cache_ent *ent)
 {
-	struct mlx5_ib_mr *mr;
-	void *old;
+	void *old, *xa_mkey;
 
 	ent->stored--;
 	ent->reserved--;
 
 	if (ent->stored == ent->reserved) {
-		mr = __xa_erase(&ent->mkeys, ent->stored);
-		WARN_ON(!mr);
-		return mr;
+		xa_mkey = __xa_erase(&ent->mkeys, ent->stored);
+		WARN_ON(!xa_mkey);
+		return (u32)xa_to_value(xa_mkey);
 	}
 
-	mr = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
-				GFP_KERNEL);
-	WARN_ON(!mr || xa_is_err(mr));
+	xa_mkey = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
+			     GFP_KERNEL);
+	WARN_ON(!xa_mkey || xa_is_err(xa_mkey));
 	old = __xa_erase(&ent->mkeys, ent->reserved);
 	WARN_ON(old);
-	return mr;
+	return (u32)xa_to_value(xa_mkey);
 }
 
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
-	struct mlx5_ib_mr *mr =
-		container_of(context, struct mlx5_ib_mr, cb_work);
-	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5r_async_create_mkey *mkey_out =
+		container_of(context, struct mlx5r_async_create_mkey, cb_work);
+	struct mlx5_cache_ent *ent = mkey_out->ent;
 	struct mlx5_ib_dev *dev = ent->dev;
 	unsigned long flags;
 
 	if (status) {
-		create_mkey_warn(dev, status, mr->out);
-		kfree(mr);
+		create_mkey_warn(dev, status, mkey_out->out);
+		kfree(mkey_out);
 		xa_lock_irqsave(&ent->mkeys, flags);
 		undo_push_reserve_mkey(ent);
 		WRITE_ONCE(dev->fill_delay, 1);
@@ -250,18 +249,16 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 		return;
 	}
 
-	mr->mmkey.type = MLX5_MKEY_MR;
-	mr->mmkey.key |= mlx5_idx_to_mkey(
-		MLX5_GET(create_mkey_out, mr->out, mkey_index));
-	init_waitqueue_head(&mr->mmkey.wait);
-
+	mkey_out->mkey |= mlx5_idx_to_mkey(
+		MLX5_GET(create_mkey_out, mkey_out->out, mkey_index));
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
 	xa_lock_irqsave(&ent->mkeys, flags);
-	push_to_reserved(ent, mr);
+	push_to_reserved(ent, mkey_out->mkey);
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irqrestore(&ent->mkeys, flags);
+	kfree(mkey_out);
 }
 
 static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
@@ -283,15 +280,8 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 	return ret;
 }
 
-static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
+static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 {
-	struct mlx5_ib_mr *mr;
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return NULL;
-	mr->cache_ent = ent;
-
 	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
@@ -301,106 +291,82 @@ static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->access_mode, ent->ndescs));
 	MLX5_SET(mkc, mkc, log_page_size, ent->page);
-	return mr;
 }
 
 /* Asynchronously schedule new MRs to be populated in the cache. */
 static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 {
-	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
+	struct mlx5r_async_create_mkey *async_create;
 	void *mkc;
-	u32 *in;
 	int err = 0;
 	int i;
 
-	in = kzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	for (i = 0; i < num; i++) {
-		mr = alloc_cache_mr(ent, mkc);
-		if (!mr) {
-			err = -ENOMEM;
-			goto free_in;
-		}
+		async_create = kzalloc(sizeof(struct mlx5r_async_create_mkey),
+				       GFP_KERNEL);
+		if (!async_create)
+			return -ENOMEM;
+		mkc = MLX5_ADDR_OF(create_mkey_in, async_create->in,
+				   memory_key_mkey_entry);
+		set_cache_mkc(ent, mkc);
+		async_create->ent = ent;
 
 		err = push_reserve_mkey(ent, true);
 		if (err)
-			goto free_mr;
+			goto free_async_create;
 
-		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
-					     &ent->dev->async_ctx, in, inlen,
-					     mr->out, sizeof(mr->out),
-					     &mr->cb_work);
+		err = mlx5_ib_create_mkey_cb(async_create);
 		if (err) {
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
 			goto err_undo_reserve;
 		}
 	}
 
-	kfree(in);
 	return 0;
 
 err_undo_reserve:
 	xa_lock_irq(&ent->mkeys);
 	undo_push_reserve_mkey(ent);
 	xa_unlock_irq(&ent->mkeys);
-free_mr:
-	kfree(mr);
-free_in:
-	kfree(in);
+free_async_create:
+	kfree(async_create);
 	return err;
 }
 
 /* Synchronously create a MR in the cache */
-static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
+static int create_cache_mkey(struct mlx5_cache_ent *ent, u32 *mkey)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
 	void *mkc;
 	u32 *in;
 	int err;
 
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	set_cache_mkc(ent, mkc);
 
-	mr = alloc_cache_mr(ent, mkc);
-	if (!mr) {
-		err = -ENOMEM;
-		goto free_in;
-	}
-
-	err = mlx5_core_create_mkey(ent->dev->mdev, &mr->mmkey.key, in, inlen);
+	err = mlx5_core_create_mkey(ent->dev->mdev, mkey, in, inlen);
 	if (err)
-		goto free_mr;
+		goto free_in;
 
-	init_waitqueue_head(&mr->mmkey.wait);
-	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
-	kfree(in);
-	return mr;
-free_mr:
-	kfree(mr);
 free_in:
 	kfree(in);
-	return ERR_PTR(err);
+	return err;
 }
 
 static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 {
-	struct mlx5_ib_mr *mr;
+	u32 mkey;
 
 	lockdep_assert_held(&ent->mkeys.xa_lock);
 	if (!ent->stored)
 		return;
-	mr = pop_stored_mkey(ent);
+	mkey = pop_stored_mkey(ent);
 	xa_unlock_irq(&ent->mkeys);
-	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
-	kfree(mr);
+	mlx5_core_destroy_mkey(ent->dev->mdev, mkey);
 	xa_lock_irq(&ent->mkeys);
 }
 
@@ -669,11 +635,15 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 				       int access_flags)
 {
 	struct mlx5_ib_mr *mr;
+	int err;
 
-	/* Matches access in alloc_cache_mr() */
 	if (!mlx5r_umr_can_reconfig(dev, 0, access_flags))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
 	xa_lock_irq(&ent->mkeys);
 	ent->in_use++;
 
@@ -681,30 +651,32 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
-		mr = create_cache_mr(ent);
-		if (IS_ERR(mr)) {
+		err = create_cache_mkey(ent, &mr->mmkey.key);
+		if (err) {
 			xa_lock_irq(&ent->mkeys);
 			ent->in_use--;
 			xa_unlock_irq(&ent->mkeys);
-			return mr;
+			kfree(mr);
+			return ERR_PTR(err);
 		}
 	} else {
-		mr = pop_stored_mkey(ent);
+		mr->mmkey.key = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
 		xa_unlock_irq(&ent->mkeys);
-
-		mlx5_clear_mr(mr);
 	}
+	mr->mmkey.cache_ent = ent;
+	mr->mmkey.type = MLX5_MKEY_MR;
+	init_waitqueue_head(&mr->mmkey.wait);
 	return mr;
 }
 
 static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
-	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5_cache_ent *ent = mr->mmkey.cache_ent;
 
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 	xa_lock_irq(&ent->mkeys);
-	push_to_reserved(ent, mr);
+	push_to_reserved(ent, mr->mmkey.key);
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irq(&ent->mkeys);
 }
@@ -713,15 +685,14 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	struct mlx5_ib_mr *mr;
+	u32 mkey;
 
 	cancel_delayed_work(&ent->dwork);
 	xa_lock_irq(&ent->mkeys);
 	while (ent->stored) {
-		mr = pop_stored_mkey(ent);
+		mkey = pop_stored_mkey(ent);
 		xa_unlock_irq(&ent->mkeys);
-		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
-		kfree(mr);
+		mlx5_core_destroy_mkey(dev->mdev, mkey);
 		xa_lock_irq(&ent->mkeys);
 	}
 	xa_unlock_irq(&ent->mkeys);
@@ -1392,7 +1363,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 
 	/* We only track the allocated sizes of MRs from the cache */
-	if (!mr->cache_ent)
+	if (!mr->mmkey.cache_ent)
 		return false;
 	if (!mlx5r_umr_can_load_pas(dev, new_umem->length))
 		return false;
@@ -1401,7 +1372,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 		mlx5_umem_find_best_pgsz(new_umem, mkc, log_page_size, 0, iova);
 	if (WARN_ON(!*page_size))
 		return false;
-	return (1ULL << mr->cache_ent->order) >=
+	return (1ULL << mr->mmkey.cache_ent->order) >=
 	       ib_umem_num_dma_blocks(new_umem, *page_size);
 }
 
@@ -1642,16 +1613,16 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	/* Stop DMA */
-	if (mr->cache_ent) {
-		xa_lock_irq(&mr->cache_ent->mkeys);
-		mr->cache_ent->in_use--;
-		xa_unlock_irq(&mr->cache_ent->mkeys);
+	if (mr->mmkey.cache_ent) {
+		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
+		mr->mmkey.cache_ent->in_use--;
+		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
 
 		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_reserve_mkey(mr->cache_ent, false))
-			mr->cache_ent = NULL;
+		    push_reserve_mkey(mr->mmkey.cache_ent, false))
+			mr->mmkey.cache_ent = NULL;
 	}
-	if (!mr->cache_ent) {
+	if (!mr->mmkey.cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
 		if (rc)
 			return rc;
@@ -1668,12 +1639,12 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 			mlx5_ib_free_odp_mr(mr);
 	}
 
-	if (mr->cache_ent) {
+	if (mr->mmkey.cache_ent)
 		mlx5_mr_cache_free(dev, mr);
-	} else {
+	else
 		mlx5_free_priv_descs(mr);
-		kfree(mr);
-	}
+
+	kfree(mr);
 	return 0;
 }
 
-- 
2.36.1

