Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F16B96C66
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbfHTWeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/EbgvB20GJcDqvoWugcIThkwN3eefHXUKk3FhXLdQ6Y=; b=OCs+Fev6qUsIKaWypkeOyeMZah
        Kbajg2IpVNUHm2M1ZDwAF4Gvwy9AcLznKJuG1+U/3/kSap91Gmm7N97eii9lS7avEcVqD514MN7iV
        SUWxJA4aUy0xNnWIx64PsFvvXtavl/SXqcKs5iBkDKZ4tNJanCK9it9gjrO8jkD7OaRDPRxP6bZtW
        xxXJWajYhK05U7GrqYcFAJM5gQvL6y6ckw3b6joaEB1AH0aPvXWH9zY89c6NfDHqC7A028Gvmr4fO
        y1pspQoTqNbf8t41dXKsfLo51+KuoYRieZJz9NJlEvd2ey/RwgmcePdfeQ4TZ/vdwePX0zOpWdjkA
        Rb5AB0YA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgX-0005q3-Vr; Tue, 20 Aug 2019 22:33:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 06/38] mlx5: Convert counters_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:27 -0700
Message-Id: <20190820223259.22348-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This IDR wasn't using the allocation functionality, so convert it to a
plain XArray.  I also suspect it could be used to replace the list_head
'counters', but I'm not willing to do that work right now.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 31 +++++--------------
 include/linux/mlx5/driver.h                   |  3 +-
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 1804cf3c3814..5ee20d285c5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -108,18 +108,14 @@ static struct list_head *mlx5_fc_counters_lookup_next(struct mlx5_core_dev *dev,
 						      u32 id)
 {
 	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
-	unsigned long next_id = (unsigned long)id + 1;
 	struct mlx5_fc *counter;
-	unsigned long tmp;
+	unsigned long next_id;
 
-	rcu_read_lock();
-	/* skip counters that are in idr, but not yet in counters list */
-	idr_for_each_entry_continue_ul(&fc_stats->counters_idr,
-				       counter, tmp, next_id) {
+	/* skip counters that are not yet in counters list */
+	xa_for_each_start(&fc_stats->counters_xa, next_id, counter, id + 1) {
 		if (!list_empty(&counter->list))
 			break;
 	}
-	rcu_read_unlock();
 
 	return counter ? &counter->list : &fc_stats->counters;
 }
@@ -139,9 +135,7 @@ static void mlx5_fc_stats_remove(struct mlx5_core_dev *dev,
 
 	list_del(&counter->list);
 
-	spin_lock(&fc_stats->counters_idr_lock);
-	WARN_ON(!idr_remove(&fc_stats->counters_idr, counter->id));
-	spin_unlock(&fc_stats->counters_idr_lock);
+	WARN_ON(!xa_erase(&fc_stats->counters_xa, counter->id));
 }
 
 static int get_max_bulk_query_len(struct mlx5_core_dev *dev)
@@ -309,20 +303,12 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
 	counter->aging = aging;
 
 	if (aging) {
-		u32 id = counter->id;
-
 		counter->cache.lastuse = jiffies;
 		counter->lastbytes = counter->cache.bytes;
 		counter->lastpackets = counter->cache.packets;
 
-		idr_preload(GFP_KERNEL);
-		spin_lock(&fc_stats->counters_idr_lock);
-
-		err = idr_alloc_u32(&fc_stats->counters_idr, counter, &id, id,
-				    GFP_NOWAIT);
-
-		spin_unlock(&fc_stats->counters_idr_lock);
-		idr_preload_end();
+		err = xa_insert(&fc_stats->counters_xa, counter->id, counter,
+				GFP_KERNEL);
 		if (err)
 			goto err_out_alloc;
 
@@ -368,8 +354,7 @@ int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 	int max_bulk_len;
 	int max_out_len;
 
-	spin_lock_init(&fc_stats->counters_idr_lock);
-	idr_init(&fc_stats->counters_idr);
+	xa_init(&fc_stats->counters_xa);
 	INIT_LIST_HEAD(&fc_stats->counters);
 	init_llist_head(&fc_stats->addlist);
 	init_llist_head(&fc_stats->dellist);
@@ -409,7 +394,7 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 
 	kfree(fc_stats->bulk_query_out);
 
-	idr_destroy(&fc_stats->counters_idr);
+	xa_destroy(&fc_stats->counters_xa);
 
 	tmplist = llist_del_all(&fc_stats->addlist);
 	llist_for_each_entry_safe(counter, tmp, tmplist, addlist)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ba8f59b11920..b8b66cdb8357 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -477,8 +477,7 @@ struct mlx5_fc_pool {
 };
 
 struct mlx5_fc_stats {
-	spinlock_t counters_idr_lock; /* protects counters_idr */
-	struct idr counters_idr;
+	struct xarray counters_xa;
 	struct list_head counters;
 	struct llist_head addlist;
 	struct llist_head dellist;
-- 
2.23.0.rc1

