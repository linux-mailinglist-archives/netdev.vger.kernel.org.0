Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016CADDF2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfD2Ifo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfD2Ifm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:42 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8044620578;
        Mon, 29 Apr 2019 08:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526941;
        bh=loAWShQcwXt66w6PKG4tHQpbMtKSyp31YDO7iqgJSDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gu6ddP1nHnrIhL+usvjuACHeShhVTXv5evN2nkqgT+zfrkMocNs9pJnILZbumM6ft
         fgKYpg3uJbykFRsm0GTXA3kHOSvRsKP5SV3QIGxHiGahGbiCrfQWSkw4ipzryyquQ0
         j9UVLrv4ufDtNBC8hEzAPKYljSXZJKWCNgEBViCI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all counters when perform a sysfs stat read
Date:   Mon, 29 Apr 2019 11:34:49 +0300
Message-Id: <20190429083453.16654-14-leon@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
References: <20190429083453.16654-1-leon@kernel.org>
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
 drivers/infiniband/core/counters.c | 99 +++++++++++++++++++++++++++++-
 drivers/infiniband/core/device.c   |  8 ++-
 drivers/infiniband/core/sysfs.c    | 10 ++-
 include/rdma/rdma_counter.h        |  5 +-
 4 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 36cd9eca1e46..f598b1cdb241 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -146,6 +146,20 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
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
 static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
 {
 	struct rdma_counter *counter = qp->counter;
@@ -285,8 +299,10 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
 		return ret;
 
 	rdma_restrack_put(&counter->res);
-	if (atomic_dec_and_test(&counter->usecnt))
+	if (atomic_dec_and_test(&counter->usecnt)) {
+		counter_history_stat_update(counter);
 		rdma_counter_dealloc(counter);
+	}
 
 	return 0;
 }
@@ -307,21 +323,98 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
 	return ret;
 }
 
-void rdma_counter_init(struct ib_device *dev)
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
+		counter = container_of(res, struct rdma_counter, res);
+		if ((counter->device != dev) || (counter->port != port))
+			goto next;
+
+		if (rdma_counter_query_stats(counter))
+			goto next;
+
+		sum += counter->stats->value[index];
+next:
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
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	port_counter = &dev->port_data[port].port_counter;
+	if (index >= port_counter->hstats->num_counters)
+		return -EINVAL;
+
+	sum = get_running_counters_hwstat_sum(dev, port, index);
+	sum += port_counter->hstats->value[index];
+
+	return sum;
+}
+
+int rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
 	u32 port;
 
 	if (!dev->ops.alloc_hw_stats)
-		return;
+		return 0;
 
 	rdma_for_each_port(dev, port) {
 		port_counter = &dev->port_data[port].port_counter;
 		port_counter->mode.mode = RDMA_COUNTER_MODE_NONE;
 		mutex_init(&port_counter->lock);
+
+		port_counter->hstats = dev->ops.alloc_hw_stats(dev, port);
+		if (!port_counter->hstats)
+			goto fail;
 	}
+
+	return 0;
+
+fail:
+	rdma_for_each_port(dev, port) {
+		port_counter = &dev->port_data[port].port_counter;
+		kfree(port_counter->hstats);
+	}
+
+	return -ENOMEM;
 }
 
 void rdma_counter_cleanup(struct ib_device *dev)
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
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c56ffc61ab1e..8ae4906a60e7 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1255,7 +1255,11 @@ int ib_register_device(struct ib_device *device, const char *name)
 		goto dev_cleanup;
 	}
 
-	rdma_counter_init(device);
+	ret = rdma_counter_init(device);
+	if (ret) {
+		dev_warn(&device->dev, "Couldn't initialize counter\n");
+		goto sysfs_cleanup;
+	}
 
 	ret = enable_device_and_get(device);
 	if (ret) {
@@ -1283,6 +1287,8 @@ int ib_register_device(struct ib_device *device, const char *name)
 
 	return 0;
 
+sysfs_cleanup:
+	ib_device_unregister_sysfs(device);
 dev_cleanup:
 	device_del(&device->dev);
 cg_cleanup:
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 2fe89754e592..8d1cf1bbb5f5 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -43,6 +43,7 @@
 #include <rdma/ib_mad.h>
 #include <rdma/ib_pma.h>
 #include <rdma/ib_cache.h>
+#include <rdma/rdma_counter.h>
 
 struct ib_port;
 
@@ -795,9 +796,12 @@ static int update_hw_stats(struct ib_device *dev, struct rdma_hw_stats *stats,
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
@@ -823,7 +827,7 @@ static ssize_t show_hw_stats(struct kobject *kobj, struct attribute *attr,
 	ret = update_hw_stats(dev, stats, hsa->port_num, hsa->index);
 	if (ret)
 		goto unlock;
-	ret = print_hw_stat(stats, hsa->index, buf);
+	ret = print_hw_stat(dev, hsa->port_num, stats, hsa->index, buf);
 unlock:
 	mutex_unlock(&stats->lock);
 
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 4bc62909a638..5ad86ae67cc5 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -27,6 +27,7 @@ struct rdma_counter_mode {
 
 struct rdma_port_counter {
 	struct rdma_counter_mode mode;
+	struct rdma_hw_stats *hstats;
 	struct mutex lock;
 };
 
@@ -41,13 +42,13 @@ struct rdma_counter {
 	u8				port;
 };
 
-void rdma_counter_init(struct ib_device *dev);
+int rdma_counter_init(struct ib_device *dev);
 void rdma_counter_cleanup(struct ib_device *dev);
 int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			       bool on, enum rdma_nl_counter_mask mask);
 int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
 int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);
-
 int rdma_counter_query_stats(struct rdma_counter *counter);
+u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index);
 
 #endif /* _RDMA_COUNTER_H_ */
-- 
2.20.1

