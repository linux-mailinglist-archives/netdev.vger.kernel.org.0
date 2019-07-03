Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5AA5CD35
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfGBKDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfGBKDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:03:31 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D1A02054F;
        Tue,  2 Jul 2019 10:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562061809;
        bh=+pRYU00xLmCSCIF4Y7gwGxtNZLk50enV9qOIpQCeG7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7ZSQaHwImtAlZQnirJBgqoijbRugYtfexwBJF28TQ691czEz3M+QvA/PX5OMlgh3
         UeAaGJlwO4LN4RpzgPBQpYG05o5fBv91Eis8S2wUubHkQqiVg0qHbtEOlgEdVjXeiH
         OtN0+FgrKZiqNxsOM+e628nT2p/hwD3lo/5BwXdw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v5 05/17] RDMA/counter: Add set/clear per-port auto mode support
Date:   Tue,  2 Jul 2019 13:02:34 +0300
Message-Id: <20190702100246.17382-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add an API to support set/clear per-port auto mode.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/Makefile   |  2 +-
 drivers/infiniband/core/counters.c | 74 ++++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c   |  5 ++
 include/rdma/ib_verbs.h            |  2 +
 include/rdma/rdma_counter.h        | 24 ++++++++++
 include/uapi/rdma/rdma_netlink.h   | 26 +++++++++++
 6 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/counters.c

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 42f1b2a4f746..09881bd5f12d 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -11,7 +11,7 @@ ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
 				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
 				multicast.o mad.o smi.o agent.o mad_rmpp.o \
-				nldev.o restrack.o
+				nldev.o restrack.o counters.o
 
 ib_core-$(CONFIG_SECURITY_INFINIBAND) += security.o
 ib_core-$(CONFIG_CGROUP_RDMA) += cgroup.o
diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
new file mode 100644
index 000000000000..6167914fba06
--- /dev/null
+++ b/drivers/infiniband/core/counters.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2019 Mellanox Technologies. All rights reserved.
+ */
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_counter.h>
+
+#include "core_priv.h"
+#include "restrack.h"
+
+#define ALL_AUTO_MODE_MASKS (RDMA_COUNTER_MASK_QP_TYPE)
+
+static int __counter_set_mode(struct rdma_counter_mode *curr,
+			      enum rdma_nl_counter_mode new_mode,
+			      enum rdma_nl_counter_mask new_mask)
+{
+	if ((new_mode == RDMA_COUNTER_MODE_AUTO) &&
+	    ((new_mask & (~ALL_AUTO_MODE_MASKS)) ||
+	     (curr->mode != RDMA_COUNTER_MODE_NONE)))
+		return -EINVAL;
+
+	curr->mode = new_mode;
+	curr->mask = new_mask;
+	return 0;
+}
+
+/**
+ * rdma_counter_set_auto_mode() - Turn on/off per-port auto mode
+ *
+ * When @on is true, the @mask must be set
+ */
+int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
+			       bool on, enum rdma_nl_counter_mask mask)
+{
+	struct rdma_port_counter *port_counter;
+	int ret;
+
+	port_counter = &dev->port_data[port].port_counter;
+	mutex_lock(&port_counter->lock);
+	if (on) {
+		ret = __counter_set_mode(&port_counter->mode,
+					 RDMA_COUNTER_MODE_AUTO, mask);
+	} else {
+		if (port_counter->mode.mode != RDMA_COUNTER_MODE_AUTO) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = __counter_set_mode(&port_counter->mode,
+					 RDMA_COUNTER_MODE_NONE, 0);
+	}
+
+out:
+	mutex_unlock(&port_counter->lock);
+	return ret;
+}
+
+void rdma_counter_init(struct ib_device *dev)
+{
+	struct rdma_port_counter *port_counter;
+	u32 port;
+
+	if (!dev->ops.alloc_hw_stats || !dev->port_data)
+		return;
+
+	rdma_for_each_port(dev, port) {
+		port_counter = &dev->port_data[port].port_counter;
+		port_counter->mode.mode = RDMA_COUNTER_MODE_NONE;
+		mutex_init(&port_counter->lock);
+	}
+}
+
+void rdma_counter_release(struct ib_device *dev)
+{
+}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 8a6ccb936dfe..6579865e4866 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -46,6 +46,7 @@
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
+#include <rdma/rdma_counter.h>
 
 #include "core_priv.h"
 #include "restrack.h"
@@ -492,10 +493,12 @@ static void ib_device_release(struct device *device)
 	if (dev->port_data) {
 		ib_cache_release_one(dev);
 		ib_security_release_port_pkey_list(dev);
+		rdma_counter_release(dev);
 		kfree_rcu(container_of(dev->port_data, struct ib_port_data_rcu,
 				       pdata[0]),
 			  rcu_head);
 	}
+
 	xa_destroy(&dev->compat_devs);
 	xa_destroy(&dev->client_data);
 	kfree_rcu(dev, rcu_head);
@@ -1316,6 +1319,8 @@ int ib_register_device(struct ib_device *device, const char *name)
 
 	ib_device_register_rdmacg(device);
 
+	rdma_counter_init(device);
+
 	/*
 	 * Ensure that ADD uevent is not fired because it
 	 * is too early amd device is not initialized yet.
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 26e9c2594913..3d19c056fbc0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -62,6 +62,7 @@
 #include <linux/irqflags.h>
 #include <linux/preempt.h>
 #include <uapi/rdma/ib_user_verbs.h>
+#include <rdma/rdma_counter.h>
 #include <rdma/restrack.h>
 #include <rdma/signature.h>
 #include <uapi/rdma/rdma_user_ioctl.h>
@@ -2119,6 +2120,7 @@ struct ib_port_data {
 	spinlock_t netdev_lock;
 	struct net_device __rcu *netdev;
 	struct hlist_node ndev_hash_link;
+	struct rdma_port_counter port_counter;
 };
 
 /* rdma netdev type - specifies protocol type */
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 283ac1a0cdb7..8dd2619c015d 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -6,8 +6,26 @@
 #ifndef _RDMA_COUNTER_H_
 #define _RDMA_COUNTER_H_
 
+#include <linux/mutex.h>
+
 #include <rdma/ib_verbs.h>
 #include <rdma/restrack.h>
+#include <rdma/rdma_netlink.h>
+
+struct auto_mode_param {
+	int qp_type;
+};
+
+struct rdma_counter_mode {
+	enum rdma_nl_counter_mode mode;
+	enum rdma_nl_counter_mask mask;
+	struct auto_mode_param param;
+};
+
+struct rdma_port_counter {
+	struct rdma_counter_mode mode;
+	struct mutex lock;
+};
 
 struct rdma_counter {
 	struct rdma_restrack_entry	res;
@@ -15,4 +33,10 @@ struct rdma_counter {
 	uint32_t			id;
 	u8				port;
 };
+
+void rdma_counter_init(struct ib_device *dev);
+void rdma_counter_release(struct ib_device *dev);
+int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
+			       bool on, enum rdma_nl_counter_mask mask);
+
 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 650cee8c4bf1..e3cd912e9cef 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -507,4 +507,30 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_MAX
 };
+
+/*
+ * Supported counter bind modes. All modes are mutual-exclusive.
+ */
+enum rdma_nl_counter_mode {
+	RDMA_COUNTER_MODE_NONE,
+
+	/*
+	 * A qp is bound with a counter automatically during initialization
+	 * based on the auto mode (e.g., qp type, ...)
+	 */
+	RDMA_COUNTER_MODE_AUTO,
+
+	/*
+	 * Always the end
+	 */
+	RDMA_COUNTER_MODE_MAX,
+};
+
+/*
+ * Supported criteria in counter auto mode.
+ * Currently only "qp type" is supported
+ */
+enum rdma_nl_counter_mask {
+	RDMA_COUNTER_MASK_QP_TYPE = 1,
+};
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.20.1

