Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8536753FDAE
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbiFGLkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243058AbiFGLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31DAB0A6D;
        Tue,  7 Jun 2022 04:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62FCE61697;
        Tue,  7 Jun 2022 11:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521EBC34114;
        Tue,  7 Jun 2022 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654602028;
        bh=U6D8Ucu8kDnddwbGDSZm0KBnTSJizpH9wT2hsWgEl5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qufRsdmvXtYH/141fvc78dxn1LeGARjJq8O8QIGCZmN/h52LBsyZ4IvGhXI1tKLFV
         bL8WEmXDpQhdc4AwDTaUo+QfGgtyIEx6lR9Ifh0LGjV+DwmP4Oe1NjtxnJG6bTsCTc
         6wCkhIcngUME4vZw1NpLvEAE6isOScuDDWybFETFsHhPtfTGc+W80JFdG0wNk2Bycb
         SFaYFS9GG0dJW8Uucin0JiY9zucEgqudB95o6ytl7Li7tw7X0k8uOvo5e/7Vb7UMQ+
         LLA39ctvae9RKVST2uaEbqm2Xv81VdpPOuv5gONWBezfKZTB6NhLbRUuZNV89yj38U
         JnYuEQ4zCFYew==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 3/5] RDMA/mlx5: Store the number of in_use cache mkeys instead of total_mrs
Date:   Tue,  7 Jun 2022 14:40:13 +0300
Message-Id: <8db24ef3234a6d67a12bbf3137e763cd817df5c8.1654601897.git.leonro@nvidia.com>
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

total_mrs is used only to calculate the number of mkeys currently in
use. To simplify things, replace it with a new member called "in_use"
and directly store the number of mkeys currently in use.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +---
 drivers/infiniband/hw/mlx5/mr.c      | 30 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 500f1a231106..47515dc27b51 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -749,12 +749,10 @@ struct mlx5_cache_ent {
 	u8 fill_to_high_water:1;
 
 	/*
-	 * - total_mrs is stored mkeys plus all in use MRs that could be
-	 *   returned to the cache.
 	 * - limit is the low water mark for stored mkeys, 2* limit is the
 	 *   upper water mark.
 	 */
-	u32 total_mrs;
+	u32 in_use;
 	u32 limit;
 
 	/* Statistics */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9cd34d6817b3..80672d275d77 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -259,7 +259,6 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 
 	xa_lock_irqsave(&ent->mkeys, flags);
 	push_to_reserved(ent, mr);
-	ent->total_mrs++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irqrestore(&ent->mkeys, flags);
@@ -382,9 +381,6 @@ static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
 	init_waitqueue_head(&mr->mmkey.wait);
 	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
-	xa_lock_irq(&ent->mkeys);
-	ent->total_mrs++;
-	xa_unlock_irq(&ent->mkeys);
 	kfree(in);
 	return mr;
 free_mr:
@@ -402,7 +398,6 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 	if (!ent->stored)
 		return;
 	mr = pop_stored_mkey(ent);
-	ent->total_mrs--;
 	xa_unlock_irq(&ent->mkeys);
 	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
 	kfree(mr);
@@ -458,11 +453,11 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 	 * mkeys.
 	 */
 	xa_lock_irq(&ent->mkeys);
-	if (target < ent->total_mrs - ent->stored) {
+	if (target < ent->in_use) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	target = target - (ent->total_mrs - ent->stored);
+	target = target - ent->in_use;
 	if (target < ent->limit || target > ent->limit*2) {
 		err = -EINVAL;
 		goto err_unlock;
@@ -486,7 +481,7 @@ static ssize_t size_read(struct file *filp, char __user *buf, size_t count,
 	char lbuf[20];
 	int err;
 
-	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->total_mrs);
+	err = snprintf(lbuf, sizeof(lbuf), "%ld\n", ent->stored + ent->in_use);
 	if (err < 0)
 		return err;
 
@@ -680,13 +675,19 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	xa_lock_irq(&ent->mkeys);
+	ent->in_use++;
+
 	if (!ent->stored) {
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
 		mr = create_cache_mr(ent);
-		if (IS_ERR(mr))
+		if (IS_ERR(mr)) {
+			xa_lock_irq(&ent->mkeys);
+			ent->in_use--;
+			xa_unlock_irq(&ent->mkeys);
 			return mr;
+		}
 	} else {
 		mr = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
@@ -718,7 +719,6 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	xa_lock_irq(&ent->mkeys);
 	while (ent->stored) {
 		mr = pop_stored_mkey(ent);
-		ent->total_mrs--;
 		xa_unlock_irq(&ent->mkeys);
 		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 		kfree(mr);
@@ -1643,13 +1643,13 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	/* Stop DMA */
 	if (mr->cache_ent) {
+		xa_lock_irq(&mr->cache_ent->mkeys);
+		mr->cache_ent->in_use--;
+		xa_unlock_irq(&mr->cache_ent->mkeys);
+
 		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_reserve_mkey(mr->cache_ent, false)) {
-			xa_lock_irq(&mr->cache_ent->mkeys);
-			mr->cache_ent->total_mrs--;
-			xa_unlock_irq(&mr->cache_ent->mkeys);
+		    push_reserve_mkey(mr->cache_ent, false))
 			mr->cache_ent = NULL;
-		}
 	}
 	if (!mr->cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
-- 
2.36.1

