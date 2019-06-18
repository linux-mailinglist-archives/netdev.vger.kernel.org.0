Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A614A85B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfFRR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730109AbfFRR1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:16 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC0942084D;
        Tue, 18 Jun 2019 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878834;
        bh=iktmnmxqHz4JhHHiQcr+TpFcRtFXBBBH/2jWVfHogPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhAf8YGlqclaWEjpDXLQ7lyGQQauAh44i0QBb3oZynQNJR80PFo8vZiNq/ah3vFI4
         UTCdFppJCGpbuUpqU3pH+jEZ1YJycEUOIw9I5HZXe/SN85xYFp0VkOuioTLHu+yqLU
         qnnWqrmUV9vpyQCx7HggcffoCHOgwSTIuvGTH2R4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 13/17] RDMA/core: Get sum value of all counters when perform a sysfs stat read
Date:   Tue, 18 Jun 2019 20:26:21 +0300
Message-Id: <20190618172625.13432-14-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618172625.13432-1-leon@kernel.org>
References: <20190618172625.13432-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Since a QP can only be bound to one counter, then if it is bound to a
separate counter, for backward compatibility purpose, the statistic
value must be:
* stat of default counter
+ stat of all running allocated counters
+ stat of all deallocated counters (history stats)

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 89 ++++++++++++++++++++++++++++++
 drivers/infiniband/core/sysfs.c    | 10 +++-
 include/rdma/rdma_counter.h        |  2 +
 3 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 1c34b9e8407d..0d0a07d2ef58 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -174,6 +174,20 @@ static int __rdma_counter_unbind_qp(struct ib_qp *qp)
 	return ret;
 }

+static void counter_history_stat_update(const struct rdma_counter *counter)
+{
+	struct ib_device *dev = counter->device;
+	struct rdma_port_counter *port_counter;
+	int i;
+
+	port_counter = &dev->port_data[counter->port].port_counter;
+	if (!port_counter->hstats)
+		return;
+
+	for (i = 0; i < counter->stats->num_counters; i++)
+		port_counter->hstats->value[i] += counter->stats->value[i];
+}
+
 /**
  * rdma_get_counter_auto_mode - Find the counter that @qp should be bound
  *     with in auto mode
@@ -285,6 +299,7 @@ static void counter_release(struct kref *kref)
 	struct rdma_counter *counter;

 	counter = container_of(kref, struct rdma_counter, kref);
+	counter_history_stat_update(counter);
 	rdma_counter_dealloc(counter);
 }

@@ -326,6 +341,55 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
 	return ret;
 }

+static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
+					   u8 port, u32 index)
+{
+	struct rdma_restrack_entry *res;
+	struct rdma_restrack_root *rt;
+	struct rdma_counter *counter;
+	unsigned long id = 0;
+	u64 sum = 0;
+
+	rt = &dev->res[RDMA_RESTRACK_COUNTER];
+	xa_lock(&rt->xa);
+	xa_for_each(&rt->xa, id, res) {
+		if (!rdma_restrack_get(res))
+			continue;
+
+		xa_unlock(&rt->xa);
+
+		counter = container_of(res, struct rdma_counter, res);
+		if ((counter->device != dev) || (counter->port != port) ||
+		    rdma_counter_query_stats(counter))
+			goto next;
+
+		sum += counter->stats->value[index];
+
+next:
+		xa_lock(&rt->xa);
+		rdma_restrack_put(res);
+	}
+
+	xa_unlock(&rt->xa);
+	return sum;
+}
+
+/**
+ * rdma_counter_get_hwstat_value() - Get the sum value of all counters on a
+ *   specific port, including the running ones and history data
+ */
+u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index)
+{
+	struct rdma_port_counter *port_counter;
+	u64 sum;
+
+	port_counter = &dev->port_data[port].port_counter;
+	sum = get_running_counters_hwstat_sum(dev, port, index);
+	sum += port_counter->hstats->value[index];
+
+	return sum;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
@@ -338,9 +402,34 @@ void rdma_counter_init(struct ib_device *dev)
 		port_counter = &dev->port_data[port].port_counter;
 		port_counter->mode.mode = RDMA_COUNTER_MODE_NONE;
 		mutex_init(&port_counter->lock);
+
+		port_counter->hstats = dev->ops.alloc_hw_stats(dev, port);
+		if (!port_counter->hstats)
+			goto fail;
 	}
+
+	return;
+
+fail:
+	rdma_for_each_port(dev, port) {
+		port_counter = &dev->port_data[port].port_counter;
+		kfree(port_counter->hstats);
+		port_counter->hstats = NULL;
+	}
+
+	return;
 }

 void rdma_counter_release(struct ib_device *dev)
 {
+	struct rdma_port_counter *port_counter;
+	u32 port;
+
+	if (!dev->ops.alloc_hw_stats)
+		return;
+
+	rdma_for_each_port(dev, port) {
+		port_counter = &dev->port_data[port].port_counter;
+		kfree(port_counter->hstats);
+	}
 }
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c78d0c9646ae..c59b80e0a740 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -43,6 +43,7 @@
 #include <rdma/ib_mad.h>
 #include <rdma/ib_pma.h>
 #include <rdma/ib_cache.h>
+#include <rdma/rdma_counter.h>

 struct ib_port;

@@ -800,9 +801,12 @@ static int update_hw_stats(struct ib_device *dev, struct rdma_hw_stats *stats,
 	return 0;
 }

-static ssize_t print_hw_stat(struct rdma_hw_stats *stats, int index, char *buf)
+static ssize_t print_hw_stat(struct ib_device *dev, int port_num,
+			     struct rdma_hw_stats *stats, int index, char *buf)
 {
-	return sprintf(buf, "%llu\n", stats->value[index]);
+	u64 v = rdma_counter_get_hwstat_value(dev, port_num, index);
+
+	return sprintf(buf, "%llu\n", stats->value[index] + v);
 }

 static ssize_t show_hw_stats(struct kobject *kobj, struct attribute *attr,
@@ -828,7 +832,7 @@ static ssize_t show_hw_stats(struct kobject *kobj, struct attribute *attr,
 	ret = update_hw_stats(dev, stats, hsa->port_num, hsa->index);
 	if (ret)
 		goto unlock;
-	ret = print_hw_stat(stats, hsa->index, buf);
+	ret = print_hw_stat(dev, hsa->port_num, stats, hsa->index, buf);
 unlock:
 	mutex_unlock(&stats->lock);

diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index f2a5c8efc404..bf2c3578768f 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -27,6 +27,7 @@ struct rdma_counter_mode {

 struct rdma_port_counter {
 	struct rdma_counter_mode mode;
+	struct rdma_hw_stats *hstats;
 	struct mutex lock;
 };

@@ -49,5 +50,6 @@ int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
 int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);

 int rdma_counter_query_stats(struct rdma_counter *counter);
+u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index);

 #endif /* _RDMA_COUNTER_H_ */
--
2.20.1

