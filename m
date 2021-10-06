Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809D9423AFC
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhJFJyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238045AbhJFJye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032B461139;
        Wed,  6 Oct 2021 09:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513962;
        bh=xzttZi/5poOy9K5iTOgUl8xLkGgYhWnKTEjW93RLZt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVtP1Zr0coed+XFwGz6Bln/zdS46ifZ3ImNoqmtlYREKWBnmViQhoC/Ikpuqmx06r
         mIrbBH4ejJlkk5doboD66msYYp7AGvunA/gVBcTXaEoPHHi67rO6BRMeE7FjPRIKT2
         b085h7LT7nP2HtiMyCbwCKCG5B18HFkeO0/MxaQKlwRaDnbewQEbAPSAVOVPFSb8Lp
         cSTs8tDi+xGzzzAQibCFQvYlQCdXkq61OsJRLfKsZyht3PcQWboVryIxMEX4wzJHmO
         rniZ/W2X4sp3l1AJ2y6/LkAJatJ7vKfShR9MDhni2j4IPmiVd8WwUtbB93SFuzobVM
         Lk+gVL9crglag==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Zhang <markzhang@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v3 04/13] RDMA/core: Add a helper API rdma_free_hw_stats_struct
Date:   Wed,  6 Oct 2021 12:52:07 +0300
Message-Id: <8402b0fc2e7502545463ac21fde61f097ee7091f.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633513239.git.leonro@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Add a new API rdma_free_hw_stats_struct to pair with
rdma_alloc_hw_stats_struct (which is also de-inlined).

This will be useful when there are more alloc/free works
in following patches.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/counters.c |  8 +++----
 drivers/infiniband/core/sysfs.c    |  8 +++----
 drivers/infiniband/core/verbs.c    | 35 ++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h            | 27 ++++-------------------
 4 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index df9e6c5e4ddf..331cd29f0d61 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -165,7 +165,7 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 	return counter;
 
 err_mode:
-	kfree(counter->stats);
+	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
 	rdma_restrack_put(&counter->res);
 	kfree(counter);
@@ -186,7 +186,7 @@ static void rdma_counter_free(struct rdma_counter *counter)
 	mutex_unlock(&port_counter->lock);
 
 	rdma_restrack_del(&counter->res);
-	kfree(counter->stats);
+	rdma_free_hw_stats_struct(counter->stats);
 	kfree(counter);
 }
 
@@ -618,7 +618,7 @@ void rdma_counter_init(struct ib_device *dev)
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
 		port_counter = &dev->port_data[port].port_counter;
-		kfree(port_counter->hstats);
+		rdma_free_hw_stats_struct(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
 	}
@@ -631,7 +631,7 @@ void rdma_counter_release(struct ib_device *dev)
 
 	rdma_for_each_port(dev, port) {
 		port_counter = &dev->port_data[port].port_counter;
-		kfree(port_counter->hstats);
+		rdma_free_hw_stats_struct(port_counter->hstats);
 		mutex_destroy(&port_counter->lock);
 	}
 }
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c3663cfdcd52..8d831d4fd2ad 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -755,7 +755,7 @@ static void ib_port_release(struct kobject *kobj)
 	for (i = 0; i != ARRAY_SIZE(port->groups); i++)
 		kfree(port->groups[i].attrs);
 	if (port->hw_stats_data)
-		kfree(port->hw_stats_data->stats);
+		rdma_free_hw_stats_struct(port->hw_stats_data->stats);
 	kfree(port->hw_stats_data);
 	kfree(port);
 }
@@ -919,14 +919,14 @@ alloc_hw_stats_device(struct ib_device *ibdev)
 err_free_data:
 	kfree(data);
 err_free_stats:
-	kfree(stats);
+	rdma_free_hw_stats_struct(stats);
 	return ERR_PTR(-ENOMEM);
 }
 
 void ib_device_release_hw_stats(struct hw_stats_device_data *data)
 {
 	kfree(data->group.attrs);
-	kfree(data->stats);
+	rdma_free_hw_stats_struct(data->stats);
 	kfree(data);
 }
 
@@ -1018,7 +1018,7 @@ alloc_hw_stats_port(struct ib_port *port, struct attribute_group *group)
 err_free_data:
 	kfree(data);
 err_free_stats:
-	kfree(stats);
+	rdma_free_hw_stats_struct(stats);
 	return ERR_PTR(-ENOMEM);
 }
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 89a2b21976d6..c3319a7584a2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2976,3 +2976,38 @@ bool __rdma_block_iter_next(struct ib_block_iter *biter)
 	return true;
 }
 EXPORT_SYMBOL(__rdma_block_iter_next);
+
+/**
+ * rdma_alloc_hw_stats_struct - Helper function to allocate dynamic struct
+ *   for the drivers.
+ * @descs: array of static descriptors
+ * @num_counters: number of elments in array
+ * @lifespan: milliseconds between updates
+ */
+struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
+	const struct rdma_stat_desc *descs, int num_counters,
+	unsigned long lifespan)
+{
+	struct rdma_hw_stats *stats;
+
+	stats = kzalloc(struct_size(stats, value, num_counters), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+
+	stats->descs = descs;
+	stats->num_counters = num_counters;
+	stats->lifespan = msecs_to_jiffies(lifespan);
+
+	return stats;
+}
+EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
+
+/**
+ * rdma_free_hw_stats_struct - Helper function to release rdma_hw_stats
+ * @stats: statistics to release
+ */
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
+{
+	kfree(stats);
+}
+EXPORT_SYMBOL(rdma_free_hw_stats_struct);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index aa1e1029b736..938c0c0a1c19 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -582,31 +582,12 @@ struct rdma_hw_stats {
 };
 
 #define RDMA_HW_STATS_DEFAULT_LIFESPAN 10
-/**
- * rdma_alloc_hw_stats_struct - Helper function to allocate dynamic struct
- *   for drivers.
- * @descs - Array of static descriptors
- * @num_counters - How many elements in array
- * @lifespan - How many milliseconds between updates
- */
-static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
-		const struct rdma_stat_desc *descs, int num_counters,
-		unsigned long lifespan)
-{
-	struct rdma_hw_stats *stats;
 
-	stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
-			GFP_KERNEL);
-	if (!stats)
-		return NULL;
-
-	stats->descs = descs;
-	stats->num_counters = num_counters;
-	stats->lifespan = msecs_to_jiffies(lifespan);
-
-	return stats;
-}
+struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
+	const struct rdma_stat_desc *descs, int num_counters,
+	unsigned long lifespan);
 
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 
 /* Define bits for the various functionality this port needs to be supported by
  * the core.
-- 
2.31.1

