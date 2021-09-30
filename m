Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C541D514
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348967AbhI3IGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348968AbhI3IEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A49761882;
        Thu, 30 Sep 2021 08:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988985;
        bh=p0G+ZMI8fnswvgCj69jsiA9bjcNHmosMC4LmCgc3lw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rC1UyIfhLrHa473ZuVjuhx1y1ixZtKxj23747ssxPQwo+CBg9beoN3dGjAY3+xYfk
         VeD2pfnTwaqrJJYMLsaYjRy4hQzjwFJG8M4xLiBWHaJg2FOO7DY7gOgVwYY6jN0sXl
         C5LErRaeR3yZDMT1FD5s35z97HD97Zb50MswB6OmVGWgQ90k6oqA8TOaXvXT6YtEnN
         CSKaZzRMni5XzuilQIN3kzf0XIaatEo5/hKG0CBc1l1n/DcsCALlQAtn/hE86BPFZp
         cCKNg07diRoN/RRVE8TrcJ1paYRI9f63I/PFJSGkm1wXJEBwwm/Njlv1PeFRsXlNyD
         hHR5//FR7Z6ZA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 06/13] RDMA/counter: Add optional counter support
Date:   Thu, 30 Sep 2021 11:02:22 +0300
Message-Id: <f473f52f9ba462112df91866aa5cf08687008c58.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

An optional counter is a vendor-specific counter that may be dynamically
enabled/disabled.
This enhancement allows us to expose counters which are for example
mutual exclusive and cannot be enabled at the same time, counters that
might degrades performance, optional debug counters, etc.

Optional counters are marked with IB_STAT_FLAG_OPTIONAL flag. They are
not exported in sysfs, and must be at the end of all stats, otherwise
the attr->show() in sysfs would get wrong indexes for hwcounters that
are behind optional counters.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/counters.c | 30 +++++++++++++++++++++++++
 drivers/infiniband/core/device.c   |  1 +
 drivers/infiniband/core/sysfs.c    | 36 +++++++++++++++++++++---------
 include/rdma/ib_verbs.h            | 13 +++++++++++
 include/rdma/rdma_counter.h        |  2 ++
 5 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 331cd29f0d61..dac8f370ae3c 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -106,6 +106,36 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
 	return ret;
 }
 
+int rdma_counter_modify(struct ib_device *dev, u32 port,
+			unsigned int index, bool enable)
+{
+	struct rdma_hw_stats *stats;
+	int ret = 0;
+
+	if (!dev->ops.modify_hw_stat)
+		return -EOPNOTSUPP;
+
+	stats = ib_get_hw_stats_port(dev, port);
+	if (!stats || (index >= stats->num_counters) ||
+	    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL))
+		return -EINVAL;
+
+	mutex_lock(&stats->lock);
+
+	if (enable != test_bit(index, stats->is_disabled))
+		goto out;
+
+	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
+	if (ret)
+		goto out;
+
+	enable ? clear_bit(index, stats->is_disabled) :
+		set_bit(index, stats->is_disabled);
+out:
+	mutex_unlock(&stats->lock);
+	return ret;
+}
+
 static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 					   struct ib_qp *qp,
 					   enum rdma_nl_counter_mode mode)
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f4814bb7f082..22a4adda7981 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2676,6 +2676,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, modify_cq);
 	SET_DEVICE_OP(dev_ops, modify_device);
 	SET_DEVICE_OP(dev_ops, modify_flow_action_esp);
+	SET_DEVICE_OP(dev_ops, modify_hw_stat);
 	SET_DEVICE_OP(dev_ops, modify_port);
 	SET_DEVICE_OP(dev_ops, modify_qp);
 	SET_DEVICE_OP(dev_ops, modify_srq);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 8d831d4fd2ad..1bf3aea4b71e 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -934,7 +934,8 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 {
 	struct hw_stats_device_attribute *attr;
 	struct hw_stats_device_data *data;
-	int i, ret;
+	bool opstat_skipped = false;
+	int i, ret, pos = 0;
 
 	data = alloc_hw_stats_device(ibdev);
 	if (IS_ERR(data)) {
@@ -955,16 +956,23 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 	data->stats->timestamp = jiffies;
 
 	for (i = 0; i < data->stats->num_counters; i++) {
-		attr = &data->attrs[i];
+		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) {
+			opstat_skipped = true;
+			continue;
+		}
+
+		WARN_ON(opstat_skipped);
+		attr = &data->attrs[pos];
 		sysfs_attr_init(&attr->attr.attr);
 		attr->attr.attr.name = data->stats->descs[i].name;
 		attr->attr.attr.mode = 0444;
 		attr->attr.show = hw_stat_device_show;
 		attr->show = show_hw_stats;
-		data->group.attrs[i] = &attr->attr.attr;
+		data->group.attrs[pos] = &attr->attr.attr;
+		pos++;
 	}
 
-	attr = &data->attrs[i];
+	attr = &data->attrs[pos];
 	sysfs_attr_init(&attr->attr.attr);
 	attr->attr.attr.name = "lifespan";
 	attr->attr.attr.mode = 0644;
@@ -972,7 +980,7 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 	attr->show = show_stats_lifespan;
 	attr->attr.store = hw_stat_device_store;
 	attr->store = set_stats_lifespan;
-	data->group.attrs[i] = &attr->attr.attr;
+	data->group.attrs[pos] = &attr->attr.attr;
 	for (i = 0; i != ARRAY_SIZE(ibdev->groups); i++)
 		if (!ibdev->groups[i]) {
 			ibdev->groups[i] = &data->group;
@@ -1027,7 +1035,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 {
 	struct hw_stats_port_attribute *attr;
 	struct hw_stats_port_data *data;
-	int i, ret;
+	bool opstat_skipped = false;
+	int i, ret, pos = 0;
 
 	data = alloc_hw_stats_port(port, group);
 	if (IS_ERR(data))
@@ -1045,16 +1054,23 @@ static int setup_hw_port_stats(struct ib_port *port,
 	data->stats->timestamp = jiffies;
 
 	for (i = 0; i < data->stats->num_counters; i++) {
-		attr = &data->attrs[i];
+		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) {
+			opstat_skipped = true;
+			continue;
+		}
+
+		WARN_ON(opstat_skipped);
+		attr = &data->attrs[pos];
 		sysfs_attr_init(&attr->attr.attr);
 		attr->attr.attr.name = data->stats->descs[i].name;
 		attr->attr.attr.mode = 0444;
 		attr->attr.show = hw_stat_port_show;
 		attr->show = show_hw_stats;
-		group->attrs[i] = &attr->attr.attr;
+		group->attrs[pos] = &attr->attr.attr;
+		pos++;
 	}
 
-	attr = &data->attrs[i];
+	attr = &data->attrs[pos];
 	sysfs_attr_init(&attr->attr.attr);
 	attr->attr.attr.name = "lifespan";
 	attr->attr.attr.mode = 0644;
@@ -1062,7 +1078,7 @@ static int setup_hw_port_stats(struct ib_port *port,
 	attr->show = show_stats_lifespan;
 	attr->attr.store = hw_stat_port_store;
 	attr->store = set_stats_lifespan;
-	group->attrs[i] = &attr->attr.attr;
+	group->attrs[pos] = &attr->attr.attr;
 
 	port->hw_stats_data = data;
 	return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 30bbbf21d248..d3f41099faa4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -545,12 +545,18 @@ enum ib_port_speed {
 	IB_SPEED_NDR	= 128,
 };
 
+enum ib_stat_flag {
+	IB_STAT_FLAG_OPTIONAL = 1 << 0,
+};
+
 /**
  * struct rdma_stat_desc
  * @name - The name of the counter
+ * @flags - Flags of the counter; For example, IB_STAT_FLAG_OPTIONAL
  */
 struct rdma_stat_desc {
 	const char *name;
+	unsigned int flags;
 };
 
 /**
@@ -2571,6 +2577,13 @@ struct ib_device_ops {
 	int (*get_hw_stats)(struct ib_device *device,
 			    struct rdma_hw_stats *stats, u32 port, int index);
 
+	/**
+	 * modify_hw_stat - Modify the counter configuration
+	 * @enable: true/false when enable/disable a counter
+	 * Return codes - 0 on success or error code otherwise.
+	 */
+	int (*modify_hw_stat)(struct ib_device *device, u32 port,
+			      unsigned int counter_index, bool enable);
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
 	 */
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 0295b22cd1cd..45d5481a7846 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -63,4 +63,6 @@ int rdma_counter_get_mode(struct ib_device *dev, u32 port,
 			  enum rdma_nl_counter_mode *mode,
 			  enum rdma_nl_counter_mask *mask);
 
+int rdma_counter_modify(struct ib_device *dev, u32 port,
+			unsigned int index, bool enable);
 #endif /* _RDMA_COUNTER_H_ */
-- 
2.31.1

