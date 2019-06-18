Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3121B4A84C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfFRR0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRR0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:26:50 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF17221530;
        Tue, 18 Jun 2019 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878809;
        bh=JppNuoufUsBHzNsD88HBQJfAXUgzlwM5tqr0O6pDtRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y27UrQ/8k+QOsJPq3qAghFevfK843MxtkZ9y/tyTMRWUbklxYJeRrUzrxP4GQpu9F
         XbbBQ/eISDtecpP491w1aEtqUbKWT61DX5kjYGYkNAeXHSVFCGh7jBkSAwf9UQrJxj
         XDThD04Jt1inOi/8xJc+az8rIsiKbhWbaMUXdppw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto" configuration mode support
Date:   Tue, 18 Jun 2019 20:26:14 +0300
Message-Id: <20190618172625.13432-7-leon@kernel.org>
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

In auto mode all QPs belong to one category are bind automatically to
a single counter set. Currently only "qp type" is supported.

In this mode the qp counter is set in RST2INIT modification, and when
a qp is destroyed the counter is unbound.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 248 +++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c   |   3 +
 drivers/infiniband/core/verbs.c    |   9 ++
 include/rdma/ib_verbs.h            |  18 +++
 include/rdma/rdma_counter.h        |   8 +
 5 files changed, 286 insertions(+)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 6167914fba06..554ad1a51b53 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -54,6 +54,254 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 	return ret;
 }

+static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
+					       enum rdma_nl_counter_mode mode)
+{
+	struct rdma_counter *counter;
+
+	if (!dev->ops.counter_dealloc)
+		return NULL;
+
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter)
+		return NULL;
+
+	counter->device    = dev;
+	counter->port      = port;
+	counter->res.type  = RDMA_RESTRACK_COUNTER;
+	counter->mode.mode = mode;
+	kref_init(&counter->kref);
+	mutex_init(&counter->lock);
+
+	return counter;
+}
+
+static void rdma_counter_free(struct rdma_counter *counter)
+{
+	rdma_restrack_del(&counter->res);
+	kfree(counter);
+}
+
+static void __rdma_counter_dealloc(struct rdma_counter *counter)
+{
+	mutex_lock(&counter->lock);
+	counter->device->ops.counter_dealloc(counter);
+	mutex_unlock(&counter->lock);
+}
+
+static void rdma_counter_dealloc(struct rdma_counter *counter)
+{
+	if (!counter)
+		return;
+
+	__rdma_counter_dealloc(counter);
+	rdma_counter_free(counter);
+}
+
+static void auto_mode_init_counter(struct rdma_counter *counter,
+				   const struct ib_qp *qp,
+				   enum rdma_nl_counter_mask new_mask)
+{
+	struct auto_mode_param *param = &counter->mode.param;
+
+	counter->mode.mode = RDMA_COUNTER_MODE_AUTO;
+	counter->mode.mask = new_mask;
+
+	if (new_mask & RDMA_COUNTER_MASK_QP_TYPE)
+		param->qp_type = qp->qp_type;
+}
+
+static bool auto_mode_match(struct ib_qp *qp, struct rdma_counter *counter,
+			    enum rdma_nl_counter_mask auto_mask)
+{
+	struct auto_mode_param *param = &counter->mode.param;
+	bool match = true;
+
+	if (rdma_is_kernel_res(&counter->res) != rdma_is_kernel_res(&qp->res))
+		return false;
+
+	/* Ensure that counter belong to right PID */
+	if (!rdma_is_kernel_res(&counter->res) &&
+	    !rdma_is_kernel_res(&qp->res) &&
+	    (task_pid_vnr(counter->res.task) != current->pid))
+		return false;
+
+	if (auto_mask & RDMA_COUNTER_MASK_QP_TYPE)
+		match &= (param->qp_type == qp->qp_type);
+
+	return match;
+}
+
+static int __rdma_counter_bind_qp(struct rdma_counter *counter,
+				  struct ib_qp *qp)
+{
+	int ret;
+
+	if (qp->counter)
+		return -EINVAL;
+
+	if (!qp->device->ops.counter_bind_qp)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&counter->lock);
+	ret = qp->device->ops.counter_bind_qp(counter, qp);
+	mutex_unlock(&counter->lock);
+
+	return ret;
+}
+
+static int __rdma_counter_unbind_qp(struct ib_qp *qp)
+{
+	struct rdma_counter *counter = qp->counter;
+	int ret;
+
+	if (!qp->device->ops.counter_unbind_qp)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&counter->lock);
+	ret = qp->device->ops.counter_unbind_qp(qp);
+	mutex_unlock(&counter->lock);
+
+	return ret;
+}
+
+/**
+ * rdma_get_counter_auto_mode - Find the counter that @qp should be bound
+ *     with in auto mode
+ *
+ * Return: The counter (with ref-count increased) if found
+ */
+static struct rdma_counter *rdma_get_counter_auto_mode(struct ib_qp *qp,
+						       u8 port)
+{
+	struct rdma_port_counter *port_counter;
+	struct rdma_counter *counter = NULL;
+	struct ib_device *dev = qp->device;
+	struct rdma_restrack_entry *res;
+	struct rdma_restrack_root *rt;
+	unsigned long id = 0;
+
+	port_counter = &dev->port_data[port].port_counter;
+	rt = &dev->res[RDMA_RESTRACK_COUNTER];
+	xa_lock(&rt->xa);
+	xa_for_each(&rt->xa, id, res) {
+		if (!rdma_is_visible_in_pid_ns(res))
+			continue;
+
+		counter = container_of(res, struct rdma_counter, res);
+		if ((counter->device != qp->device) || (counter->port != port))
+			goto next;
+
+		if (auto_mode_match(qp, counter, port_counter->mode.mask))
+			break;
+next:
+		counter = NULL;
+	}
+
+	if (counter && !rdma_restrack_get(&counter->res))
+		counter = NULL;
+
+	xa_unlock(&rt->xa);
+	return counter;
+}
+
+static void rdma_counter_res_add(struct rdma_counter *counter,
+				 struct ib_qp *qp)
+{
+	if (rdma_is_kernel_res(&qp->res)) {
+		rdma_restrack_set_task(&counter->res, qp->res.kern_name);
+		rdma_restrack_kadd(&counter->res);
+	} else {
+		rdma_restrack_attach_task(&counter->res, qp->res.task);
+		rdma_restrack_uadd(&counter->res);
+	}
+}
+
+/**
+ * rdma_counter_bind_qp_auto - Check and bind the QP to a counter base on
+ *   the auto-mode rule
+ */
+int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
+{
+	struct rdma_port_counter *port_counter;
+	struct ib_device *dev = qp->device;
+	struct rdma_counter *counter;
+	int ret;
+
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	port_counter = &dev->port_data[port].port_counter;
+	if (port_counter->mode.mode != RDMA_COUNTER_MODE_AUTO)
+		return 0;
+
+	counter = rdma_get_counter_auto_mode(qp, port);
+	if (counter) {
+		ret = __rdma_counter_bind_qp(counter, qp);
+		if (ret) {
+			rdma_restrack_put(&counter->res);
+			return ret;
+		}
+		kref_get(&counter->kref);
+	} else {
+		counter = rdma_counter_alloc(dev, port, RDMA_COUNTER_MODE_AUTO);
+		if (!counter)
+			return -ENOMEM;
+
+		auto_mode_init_counter(counter, qp, port_counter->mode.mask);
+
+		ret = __rdma_counter_bind_qp(counter, qp);
+		if (ret)
+			goto err_bind;
+
+		rdma_counter_res_add(counter, qp);
+		if (!rdma_restrack_get(&counter->res)) {
+			ret = -EINVAL;
+			goto err_get;
+		}
+	}
+
+	return 0;
+
+err_get:
+	 __rdma_counter_unbind_qp(qp);
+	__rdma_counter_dealloc(counter);
+err_bind:
+	rdma_counter_free(counter);
+	return ret;
+}
+
+static void counter_release(struct kref *kref)
+{
+	struct rdma_counter *counter;
+
+	counter = container_of(kref, struct rdma_counter, kref);
+	rdma_counter_dealloc(counter);
+}
+
+/**
+ * rdma_counter_unbind_qp - Unbind a qp from a counter
+ * @force:
+ *   true - Decrease the counter ref-count anyway (e.g., qp destroy)
+ */
+int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
+{
+	struct rdma_counter *counter = qp->counter;
+	int ret;
+
+	if (!counter)
+		return -EINVAL;
+
+	ret = __rdma_counter_unbind_qp(qp);
+	if (ret && !force)
+		return ret;
+
+	rdma_restrack_put(&counter->res);
+	kref_put(&counter->kref, counter_release);
+
+	return 0;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 32f20bd8069d..c976367231b1 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2365,6 +2365,9 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, alloc_xrcd);
 	SET_DEVICE_OP(dev_ops, attach_mcast);
 	SET_DEVICE_OP(dev_ops, check_mr_status);
+	SET_DEVICE_OP(dev_ops, counter_bind_qp);
+	SET_DEVICE_OP(dev_ops, counter_dealloc);
+	SET_DEVICE_OP(dev_ops, counter_unbind_qp);
 	SET_DEVICE_OP(dev_ops, create_ah);
 	SET_DEVICE_OP(dev_ops, create_counters);
 	SET_DEVICE_OP(dev_ops, create_cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 588f1d195fd2..9cb31a5945b0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1683,6 +1683,14 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 		}
 	}

+	/*
+	 * Bind this qp to a counter automatically based on the rdma counter
+	 * rules. This only set in RST2INIT with port specified
+	 */
+	if (!qp->counter && (attr_mask & IB_QP_PORT) &&
+	    ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_INIT))
+		rdma_counter_bind_qp_auto(qp, attr->port_num);
+
 	ret = ib_security_modify_qp(qp, attr, attr_mask, udata);
 	if (ret)
 		goto out;
@@ -1878,6 +1886,7 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);

+	rdma_counter_unbind_qp(qp, true);
 	rdma_restrack_del(&qp->res);
 	ret = qp->device->ops.destroy_qp(qp, udata);
 	if (!ret) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c69b183e72d2..0fe2a29939f6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1812,6 +1812,9 @@ struct ib_qp {
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
 	struct rdma_restrack_entry     res;
+
+	/* The counter the qp is bind to */
+	struct rdma_counter    *counter;
 };

 struct ib_dm {
@@ -2589,6 +2592,21 @@ struct ib_device_ops {
 			 u8 pdata_len);
 	int (*iw_create_listen)(struct iw_cm_id *cm_id, int backlog);
 	int (*iw_destroy_listen)(struct iw_cm_id *cm_id);
+	/**
+	 * counter_bind_qp - Bind a QP to a counter.
+	 * @counter - The counter to be bound. If counter->id is zero then
+	 *   the driver needs to allocate a new counter and set counter->id
+	 */
+	int (*counter_bind_qp)(struct rdma_counter *counter, struct ib_qp *qp);
+	/**
+	 * counter_unbind_qp - Unbind the qp from the dynamically-allocated
+	 *   counter and bind it onto the default one
+	 */
+	int (*counter_unbind_qp)(struct ib_qp *qp);
+	/**
+	 * counter_dealloc -De-allocate the hw counter
+	 */
+	int (*counter_dealloc)(struct rdma_counter *counter);

 	DECLARE_RDMA_OBJ_SIZE(ib_ah);
 	DECLARE_RDMA_OBJ_SIZE(ib_cq);
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 8dd2619c015d..9f93a2403c9c 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -7,11 +7,14 @@
 #define _RDMA_COUNTER_H_

 #include <linux/mutex.h>
+#include <linux/pid_namespace.h>

 #include <rdma/ib_verbs.h>
 #include <rdma/restrack.h>
 #include <rdma/rdma_netlink.h>

+struct ib_qp;
+
 struct auto_mode_param {
 	int qp_type;
 };
@@ -31,6 +34,9 @@ struct rdma_counter {
 	struct rdma_restrack_entry	res;
 	struct ib_device		*device;
 	uint32_t			id;
+	struct kref			kref;
+	struct rdma_counter_mode	mode;
+	struct mutex			lock;
 	u8				port;
 };

@@ -38,5 +44,7 @@ void rdma_counter_init(struct ib_device *dev);
 void rdma_counter_release(struct ib_device *dev);
 int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			       bool on, enum rdma_nl_counter_mask mask);
+int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
+int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);

 #endif /* _RDMA_COUNTER_H_ */
--
2.20.1

