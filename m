Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B9D284B4F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgJFMGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:06:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33146 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbgJFMG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:06:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 6 Oct 2020 15:06:24 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 096C6OXo014486;
        Tue, 6 Oct 2020 15:06:24 +0300
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH] workqueue: Add support for exposing singlethread workqueues in sysfs
Date:   Tue,  6 Oct 2020 15:06:07 +0300
Message-Id: <20201006120607.20310-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the workqueue API so that singlethread workqueues can be exposed
in sysfs. Guarantee max_active is 1 by turning it read-only.

This allows admins to control the cpumask of a workqueue, and apply
the desired system cpu separation/isolation policy.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  2 +-
 include/linux/workqueue.h                     |  4 ++++
 kernel/workqueue.c                            | 21 +++++++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 1d91a0d0ab1d..5106820a5cd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -2033,7 +2033,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	create_msg_cache(dev);
 
 	set_wqname(dev);
-	cmd->wq = create_singlethread_workqueue(cmd->wq_name);
+	cmd->wq = create_singlethread_sysfs_workqueue(cmd->wq_name);
 	if (!cmd->wq) {
 		mlx5_core_err(dev, "failed to create command workqueue\n");
 		err = -ENOMEM;
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 26de0cae2a0a..d4d4ca2b041a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -344,6 +344,7 @@ enum {
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */
 	__WQ_ORDERED_EXPLICIT	= 1 << 19, /* internal: alloc_ordered_workqueue() */
+	__WQ_MAX_ACTIVE_RO	= 1 << 20, /* internal: make max_active read-only */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -432,6 +433,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 			WQ_MEM_RECLAIM, 1, (name))
 #define create_singlethread_workqueue(name)				\
 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
+#define create_singlethread_sysfs_workqueue(name)			\
+	alloc_ordered_workqueue("%s", __WQ_MAX_ACTIVE_RO |		\
+				__WQ_LEGACY | WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c41c3c17b86a..a80d34726e68 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4258,6 +4258,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
 		flags |= WQ_UNBOUND;
 
+	if (flags & __WQ_MAX_ACTIVE_RO)
+		flags |= WQ_SYSFS;
+
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
 		tbl_size = nr_node_ids * sizeof(wq->numa_pwq_tbl[0]);
@@ -5401,9 +5404,11 @@ static ssize_t max_active_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(max_active);
 
+static struct device_attribute dev_attr_max_active_ro =
+	__ATTR(max_active, 0444, max_active_show, NULL);
+
 static struct attribute *wq_sysfs_attrs[] = {
 	&dev_attr_per_cpu.attr,
-	&dev_attr_max_active.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(wq_sysfs);
@@ -5642,6 +5647,7 @@ static void wq_device_release(struct device *dev)
  */
 int workqueue_sysfs_register(struct workqueue_struct *wq)
 {
+	const struct device_attribute *max_active_entry;
 	struct wq_device *wq_dev;
 	int ret;
 
@@ -5650,7 +5656,8 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 	 * attributes breaks ordering guarantee.  Disallow exposing ordered
 	 * workqueues.
 	 */
-	if (WARN_ON(wq->flags & __WQ_ORDERED_EXPLICIT))
+	if (WARN_ON(!(wq->flags & __WQ_MAX_ACTIVE_RO) &&
+		    wq->flags & __WQ_ORDERED_EXPLICIT))
 		return -EINVAL;
 
 	wq->wq_dev = wq_dev = kzalloc(sizeof(*wq_dev), GFP_KERNEL);
@@ -5675,6 +5682,16 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		return ret;
 	}
 
+	max_active_entry = wq->flags & __WQ_MAX_ACTIVE_RO ?
+		&dev_attr_max_active_ro : &dev_attr_max_active;
+
+	ret = device_create_file(&wq_dev->dev, max_active_entry);
+	if (ret) {
+		device_unregister(&wq_dev->dev);
+		wq->wq_dev = NULL;
+		return ret;
+	}
+
 	if (wq->flags & WQ_UNBOUND) {
 		struct device_attribute *attr;
 
-- 
2.21.0

