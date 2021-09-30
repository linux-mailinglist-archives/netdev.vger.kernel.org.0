Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF03141D51E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbhI3IGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348958AbhI3IEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EB0617E5;
        Thu, 30 Sep 2021 08:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988965;
        bh=24wwi3oPYA6tMzXj4qJw0LbfSdxtFidWRfUNN7Jjl2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN5STzfR4I9D49fZISdC9vrsjJ/9iJE1LNYK5x4YcRGrH9RBhW0EudpcuFyFt7Gql
         Ons1pZQnMKBV/r5pp4MnzwG5HrjIgTgDyhM1Xolqk12zrIeO23GcH92hBGgos2Qw14
         qwMk35wRiCZYq0H89uZA4e9CG7sab5XJ61JNRmCz2F9OgZJp9g4q3UFe0xeeT4+aqt
         gHZ8r4HR5fW/yPOC2m4dpK38Gz6+pSH4jved1lq3PxDR6iZ3MCU9GwaL2nHwQlFXUA
         UQNfnooux1XPuqkTMoJlEy6pGWNf01uynKaZtb4OEo2mqmZsFxRHuqMzD/SxFZ+UXT
         ILvsxG8Sp7jsg==
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
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 04/13] RDMA/core: Add a helper API rdma_free_hw_stats_struct
Date:   Thu, 30 Sep 2021 11:02:20 +0300
Message-Id: <905b8defafbd7996949f95f7232ce4bd07713d7c.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Add a new API rdma_free_hw_stats_struct to pair with
rdma_alloc_hw_stats_struct (which is also de-inlined).  This will be
useful when there are more alloc/free works in following patches.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/counters.c |  8 ++++----
 drivers/infiniband/core/sysfs.c    |  8 ++++----
 drivers/infiniband/core/verbs.c    | 24 ++++++++++++++++++++++++
 include/rdma/ib_verbs.h            | 24 +++++++-----------------
 4 files changed, 39 insertions(+), 25 deletions(-)

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
index 89a2b21976d6..71ece4b00234 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2976,3 +2976,27 @@ bool __rdma_block_iter_next(struct ib_block_iter *biter)
 	return true;
 }
 EXPORT_SYMBOL(__rdma_block_iter_next);
+
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
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
+{
+	kfree(stats);
+}
+EXPORT_SYMBOL(rdma_free_hw_stats_struct);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index aa1e1029b736..5e8a5ed47e9a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -589,24 +589,14 @@ struct rdma_hw_stats {
  * @num_counters - How many elements in array
  * @lifespan - How many milliseconds between updates
  */
-static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
-		const struct rdma_stat_desc *descs, int num_counters,
-		unsigned long lifespan)
-{
-	struct rdma_hw_stats *stats;
-
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
 
+/**
+ * rdma_free_hw_stats_struct - Helper function to release rdma_hw_stats
+ */
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 
 /* Define bits for the various functionality this port needs to be supported by
  * the core.
-- 
2.31.1

