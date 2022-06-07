Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B838853FDAD
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiFGLkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243054AbiFGLk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BAAAE261;
        Tue,  7 Jun 2022 04:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DCD1B81F6B;
        Tue,  7 Jun 2022 11:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5461BC385A5;
        Tue,  7 Jun 2022 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654602024;
        bh=owTKp5HdwCkHboE4CBFHSixdGlUvypf2vNvg9KodXkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHN/EPOkrmg61gXDa1BtLDegyB0V9Szo6jNqiAW2Om/Tk9rkEOxCPXjTTI4xQZV3I
         T3P/DDndGx0FswcmwDj6hfv2KI58ZYB0XJS6ZfdT7/Qq8LRpwgvMEGL/RB1qd2w8hr
         zXIu6II8WuCeq2jbs8F9voYVbk/hDIu9/w9SPGZZJwNs79SpUDuujKdn9aT/AR7H0b
         gruh3j/NS7tLFMzqjls1vlTUICuIEADpcf/xzkyAc9vbocEkgGaYyPq4zpvIoW2tcR
         1LfWbLOBNu3fVynWZeB9EDEqm6tKjuQmEK+q8M2OXMtnm9SnVDuxZSprGlybuZvUZg
         +/JMFn4pD6CYA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 2/5] RDMA/mlx5: Replace cache list with Xarray
Date:   Tue,  7 Jun 2022 14:40:12 +0300
Message-Id: <b743b4b025c5553a24a0642474583fb3de8bf0de.1654601897.git.leonro@nvidia.com>
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

The Xarray allows us to store the cached mkeys in memory efficient way.

Entries are reserved in the Xarray using xa_cmpxchg before calling to
the upcoming callbacks to avoid allocations in interrupt context.
The xa_cmpxchg can sleep when using GFP_KERNEL, so we call it in
a loop to ensure one reserved entry for each process trying to reserve.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  14 +-
 drivers/infiniband/hw/mlx5/mr.c      | 204 ++++++++++++++++++---------
 2 files changed, 143 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6c1ae23c68b6..500f1a231106 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -645,8 +645,6 @@ struct mlx5_ib_mr {
 		struct {
 			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
 			struct mlx5_async_work cb_work;
-			/* Cache list element */
-			struct list_head list;
 		};
 
 		/* Used only by kernel MRs (umem == NULL) */
@@ -738,7 +736,8 @@ struct umr_common {
 
 struct mlx5_cache_ent {
 	struct xarray		mkeys;
-	struct list_head	head;
+	unsigned long		stored;
+	unsigned long		reserved;
 
 	char                    name[4];
 	u32                     order;
@@ -750,18 +749,13 @@ struct mlx5_cache_ent {
 	u8 fill_to_high_water:1;
 
 	/*
-	 * - available_mrs is the length of list head, ie the number of MRs
-	 *   available for immediate allocation.
-	 * - total_mrs is available_mrs plus all in use MRs that could be
+	 * - total_mrs is stored mkeys plus all in use MRs that could be
 	 *   returned to the cache.
-	 * - limit is the low water mark for available_mrs, 2* limit is the
+	 * - limit is the low water mark for stored mkeys, 2* limit is the
 	 *   upper water mark.
-	 * - pending is the number of MRs currently being created
 	 */
 	u32 total_mrs;
-	u32 available_mrs;
 	u32 limit;
-	u32 pending;
 
 	/* Statistics */
 	u32                     miss;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 59187d0d7110..9cd34d6817b3 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -142,6 +142,95 @@ static void create_mkey_warn(struct mlx5_ib_dev *dev, int status, void *out)
 	mlx5_cmd_out_err(dev->mdev, MLX5_CMD_OP_CREATE_MKEY, 0, out);
 }
 
+static int push_reserve_mkey(struct mlx5_cache_ent *ent, bool limit_pendings)
+{
+	unsigned long to_reserve;
+	void *old;
+	int err;
+
+	xa_lock_irq(&ent->mkeys);
+	while (true) {
+		if (limit_pendings &&
+		    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR) {
+			err = -EAGAIN;
+			goto err;
+		}
+
+		to_reserve = ent->reserved;
+		old = __xa_cmpxchg(&ent->mkeys, to_reserve, NULL, XA_ZERO_ENTRY,
+				   GFP_KERNEL);
+
+		if (xa_is_err(old)) {
+			err = xa_err(old);
+			goto err;
+		}
+
+		/*
+		 * __xa_cmpxchg() might drop the lock, thus ent->reserved can
+		 * change.
+		 */
+		if (to_reserve != ent->reserved) {
+			if (to_reserve > ent->reserved)
+				__xa_erase(&ent->mkeys, to_reserve);
+			continue;
+		}
+
+		/*
+		 * If old != NULL to_reserve cannot be equal to ent->reserved.
+		 */
+		WARN_ON(old);
+
+		ent->reserved++;
+		break;
+	}
+	xa_unlock_irq(&ent->mkeys);
+	return 0;
+
+err:
+	xa_unlock_irq(&ent->mkeys);
+	return err;
+}
+
+static void undo_push_reserve_mkey(struct mlx5_cache_ent *ent)
+{
+	void *old;
+
+	ent->reserved--;
+	old = __xa_erase(&ent->mkeys, ent->reserved);
+	WARN_ON(old);
+}
+
+static void push_to_reserved(struct mlx5_cache_ent *ent, struct mlx5_ib_mr *mr)
+{
+	void *old;
+
+	old = __xa_store(&ent->mkeys, ent->stored, mr, 0);
+	WARN_ON(old);
+	ent->stored++;
+}
+
+static struct mlx5_ib_mr *pop_stored_mkey(struct mlx5_cache_ent *ent)
+{
+	struct mlx5_ib_mr *mr;
+	void *old;
+
+	ent->stored--;
+	ent->reserved--;
+
+	if (ent->stored == ent->reserved) {
+		mr = __xa_erase(&ent->mkeys, ent->stored);
+		WARN_ON(!mr);
+		return mr;
+	}
+
+	mr = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
+				GFP_KERNEL);
+	WARN_ON(!mr || xa_is_err(mr));
+	old = __xa_erase(&ent->mkeys, ent->reserved);
+	WARN_ON(old);
+	return mr;
+}
+
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
@@ -154,7 +243,7 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 		create_mkey_warn(dev, status, mr->out);
 		kfree(mr);
 		xa_lock_irqsave(&ent->mkeys, flags);
-		ent->pending--;
+		undo_push_reserve_mkey(ent);
 		WRITE_ONCE(dev->fill_delay, 1);
 		xa_unlock_irqrestore(&ent->mkeys, flags);
 		mod_timer(&dev->delay_timer, jiffies + HZ);
@@ -169,12 +258,10 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
 	xa_lock_irqsave(&ent->mkeys, flags);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
+	push_to_reserved(ent, mr);
 	ent->total_mrs++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
-	ent->pending--;
 	xa_unlock_irqrestore(&ent->mkeys, flags);
 }
 
@@ -237,31 +324,33 @@ static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 		mr = alloc_cache_mr(ent, mkc);
 		if (!mr) {
 			err = -ENOMEM;
-			break;
+			goto free_in;
 		}
-		xa_lock_irq(&ent->mkeys);
-		if (ent->pending >= MAX_PENDING_REG_MR) {
-			err = -EAGAIN;
-			xa_unlock_irq(&ent->mkeys);
-			kfree(mr);
-			break;
-		}
-		ent->pending++;
-		xa_unlock_irq(&ent->mkeys);
+
+		err = push_reserve_mkey(ent, true);
+		if (err)
+			goto free_mr;
+
 		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
 					     &ent->dev->async_ctx, in, inlen,
 					     mr->out, sizeof(mr->out),
 					     &mr->cb_work);
 		if (err) {
-			xa_lock_irq(&ent->mkeys);
-			ent->pending--;
-			xa_unlock_irq(&ent->mkeys);
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
-			kfree(mr);
-			break;
+			goto err_undo_reserve;
 		}
 	}
 
+	kfree(in);
+	return 0;
+
+err_undo_reserve:
+	xa_lock_irq(&ent->mkeys);
+	undo_push_reserve_mkey(ent);
+	xa_unlock_irq(&ent->mkeys);
+free_mr:
+	kfree(mr);
+free_in:
 	kfree(in);
 	return err;
 }
@@ -310,11 +399,9 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 	struct mlx5_ib_mr *mr;
 
 	lockdep_assert_held(&ent->mkeys.xa_lock);
-	if (list_empty(&ent->head))
+	if (!ent->stored)
 		return;
-	mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-	list_del(&mr->list);
-	ent->available_mrs--;
+	mr = pop_stored_mkey(ent);
 	ent->total_mrs--;
 	xa_unlock_irq(&ent->mkeys);
 	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
@@ -324,6 +411,7 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 
 static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 				bool limit_fill)
+	 __acquires(&ent->mkeys) __releases(&ent->mkeys)
 {
 	int err;
 
@@ -332,10 +420,10 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 	while (true) {
 		if (limit_fill)
 			target = ent->limit * 2;
-		if (target == ent->available_mrs + ent->pending)
+		if (target == ent->reserved)
 			return 0;
-		if (target > ent->available_mrs + ent->pending) {
-			u32 todo = target - (ent->available_mrs + ent->pending);
+		if (target > ent->reserved) {
+			u32 todo = target - ent->reserved;
 
 			xa_unlock_irq(&ent->mkeys);
 			err = add_keys(ent, todo);
@@ -366,15 +454,15 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 
 	/*
 	 * Target is the new value of total_mrs the user requests, however we
-	 * cannot free MRs that are in use. Compute the target value for
-	 * available_mrs.
+	 * cannot free MRs that are in use. Compute the target value for stored
+	 * mkeys.
 	 */
 	xa_lock_irq(&ent->mkeys);
-	if (target < ent->total_mrs - ent->available_mrs) {
+	if (target < ent->total_mrs - ent->stored) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	target = target - (ent->total_mrs - ent->available_mrs);
+	target = target - (ent->total_mrs - ent->stored);
 	if (target < ent->limit || target > ent->limit*2) {
 		err = -EINVAL;
 		goto err_unlock;
@@ -466,7 +554,7 @@ static bool someone_adding(struct mlx5_mr_cache *cache)
 		bool ret;
 
 		xa_lock_irq(&ent->mkeys);
-		ret = ent->available_mrs < ent->limit;
+		ret = ent->stored < ent->limit;
 		xa_unlock_irq(&ent->mkeys);
 		if (ret)
 			return true;
@@ -485,22 +573,22 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 
 	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
 		return;
-	if (ent->available_mrs < ent->limit) {
+	if (ent->stored < ent->limit) {
 		ent->fill_to_high_water = true;
 		mod_delayed_work(ent->dev->cache.wq, &ent->dwork, 0);
 	} else if (ent->fill_to_high_water &&
-		   ent->available_mrs + ent->pending < 2 * ent->limit) {
+		   ent->reserved < 2 * ent->limit) {
 		/*
 		 * Once we start populating due to hitting a low water mark
 		 * continue until we pass the high water mark.
 		 */
 		mod_delayed_work(ent->dev->cache.wq, &ent->dwork, 0);
-	} else if (ent->available_mrs == 2 * ent->limit) {
+	} else if (ent->stored == 2 * ent->limit) {
 		ent->fill_to_high_water = false;
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->stored > 2 * ent->limit) {
 		/* Queue deletion of excess entries */
 		ent->fill_to_high_water = false;
-		if (ent->pending)
+		if (ent->stored != ent->reserved)
 			queue_delayed_work(ent->dev->cache.wq, &ent->dwork,
 					   msecs_to_jiffies(1000));
 		else
@@ -518,8 +606,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 	if (ent->disabled)
 		goto out;
 
-	if (ent->fill_to_high_water &&
-	    ent->available_mrs + ent->pending < 2 * ent->limit &&
+	if (ent->fill_to_high_water && ent->reserved < 2 * ent->limit &&
 	    !READ_ONCE(dev->fill_delay)) {
 		xa_unlock_irq(&ent->mkeys);
 		err = add_keys(ent, 1);
@@ -528,8 +615,8 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 			goto out;
 		if (err) {
 			/*
-			 * EAGAIN only happens if pending is positive, so we
-			 * will be rescheduled from reg_mr_callback(). The only
+			 * EAGAIN only happens if there are pending MRs, so we
+			 * will be rescheduled when storing them. The only
 			 * failure path here is ENOMEM.
 			 */
 			if (err != -EAGAIN) {
@@ -541,7 +628,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 						   msecs_to_jiffies(1000));
 			}
 		}
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->stored > 2 * ent->limit) {
 		bool need_delay;
 
 		/*
@@ -593,7 +680,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	xa_lock_irq(&ent->mkeys);
-	if (list_empty(&ent->head)) {
+	if (!ent->stored) {
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
@@ -601,9 +688,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		if (IS_ERR(mr))
 			return mr;
 	} else {
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_del(&mr->list);
-		ent->available_mrs--;
+		mr = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
 		xa_unlock_irq(&ent->mkeys);
 
@@ -618,8 +703,7 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 	xa_lock_irq(&ent->mkeys);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
+	push_to_reserved(ent, mr);
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irq(&ent->mkeys);
 }
@@ -628,29 +712,19 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	struct mlx5_ib_mr *tmp_mr;
 	struct mlx5_ib_mr *mr;
-	LIST_HEAD(del_list);
 
 	cancel_delayed_work(&ent->dwork);
-	while (1) {
-		xa_lock_irq(&ent->mkeys);
-		if (list_empty(&ent->head)) {
-			xa_unlock_irq(&ent->mkeys);
-			break;
-		}
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_move(&mr->list, &del_list);
-		ent->available_mrs--;
+	xa_lock_irq(&ent->mkeys);
+	while (ent->stored) {
+		mr = pop_stored_mkey(ent);
 		ent->total_mrs--;
 		xa_unlock_irq(&ent->mkeys);
 		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
-	}
-
-	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
-		list_del(&mr->list);
 		kfree(mr);
+		xa_lock_irq(&ent->mkeys);
 	}
+	xa_unlock_irq(&ent->mkeys);
 }
 
 static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
@@ -680,7 +754,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 		dir = debugfs_create_dir(ent->name, cache->root);
 		debugfs_create_file("size", 0600, dir, ent, &size_fops);
 		debugfs_create_file("limit", 0600, dir, ent, &limit_fops);
-		debugfs_create_u32("cur", 0400, dir, &ent->available_mrs);
+		debugfs_create_ulong("cur", 0400, dir, &ent->stored);
 		debugfs_create_u32("miss", 0600, dir, &ent->miss);
 	}
 }
@@ -709,7 +783,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
-		INIT_LIST_HEAD(&ent->head);
 		xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 		ent->order = i + 2;
 		ent->dev = dev;
@@ -1570,7 +1643,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	/* Stop DMA */
 	if (mr->cache_ent) {
-		if (mlx5r_umr_revoke_mr(mr)) {
+		if (mlx5r_umr_revoke_mr(mr) ||
+		    push_reserve_mkey(mr->cache_ent, false)) {
 			xa_lock_irq(&mr->cache_ent->mkeys);
 			mr->cache_ent->total_mrs--;
 			xa_unlock_irq(&mr->cache_ent->mkeys);
-- 
2.36.1

