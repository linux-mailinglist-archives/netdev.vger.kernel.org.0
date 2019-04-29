Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAC2DDED
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfD2Iff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfD2IfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:19 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAE6214AE;
        Mon, 29 Apr 2019 08:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526917;
        bh=4yCzKoLBl2QnOcfL2Hx2VqsBywtFlbAqcEbWNCW8GB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngN5/eaK/pso+PXmKhj9WZ7ynnPfI9V1CuALryjVq/QHA+6FUMD0VxVV6pkMysGJ0
         Vim4oY57bmN2BSlm85d2RK+CgJDN7vJ2bhJEc9qLgQBzKeNxzOe+AepBC4RZZ06TED
         Fi7HYlF++EjxiQ8OpzxNecTQySM28uwQ60/WyXJI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 06/17] RDMA/counter: Add "auto" configuration mode support
Date:   Mon, 29 Apr 2019 11:34:42 +0300
Message-Id: <20190429083453.16654-7-leon@kernel.org>
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

In auto mode all QPs belong to one category are bind automatically to
a single counter set. Currently only "qp type" is supported.

In this mode the qp counter is set in RST2INIT modification, and when
a qp is destroyed the counter is unbound.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 222 +++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c   |   2 +
 drivers/infiniband/core/verbs.c    |   9 ++
 include/rdma/ib_verbs.h            |  18 +++
 include/rdma/rdma_counter.h        |   8 ++
 5 files changed, 259 insertions(+)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index bda8d945a758..665e0d43c21b 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -57,6 +57,228 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 	return ret;
 }
 
+static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
+					       enum rdma_nl_counter_mode mode)
+{
+	struct rdma_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter)
+		return NULL;
+
+	counter->device    = dev;
+	counter->port      = port;
+	counter->res.type  = RDMA_RESTRACK_COUNTER;
+	counter->mode.mode = mode;
+	atomic_set(&counter->usecnt, 0);
+	mutex_init(&counter->lock);
+
+	return counter;
+}
+
+static void rdma_counter_dealloc(struct rdma_counter *counter)
+{
+	rdma_restrack_del(&counter->res);
+	kfree(counter);
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
+static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
+{
+	struct rdma_counter *counter = qp->counter;
+	int ret;
+
+	if (!qp->device->ops.counter_unbind_qp)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&counter->lock);
+	ret = qp->device->ops.counter_unbind_qp(qp, force);
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
+		if (!rdma_restrack_get(res))
+			continue;
+
+		counter = container_of(res, struct rdma_counter, res);
+		if ((counter->device != qp->device) || (counter->port != port))
+			goto next;
+
+		if (auto_mode_match(qp, counter, port_counter->mode.mask))
+			break;
+next:
+		rdma_restrack_put(res);
+		counter = NULL;
+	}
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
+	atomic_inc(&counter->usecnt);
+	return 0;
+
+err_get:
+	__rdma_counter_unbind_qp(qp, false);
+err_bind:
+	rdma_counter_dealloc(counter);
+	return ret;
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
+	ret = __rdma_counter_unbind_qp(qp, force);
+	if (ret && !force)
+		return ret;
+
+	rdma_restrack_put(&counter->res);
+	if (atomic_dec_and_test(&counter->usecnt))
+		rdma_counter_dealloc(counter);
+
+	return 0;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 9204b4251fc8..dfaa57de871f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2349,6 +2349,8 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, set_vf_guid);
 	SET_DEVICE_OP(dev_ops, set_vf_link_state);
 	SET_DEVICE_OP(dev_ops, unmap_fmr);
+	SET_DEVICE_OP(dev_ops, counter_bind_qp);
+	SET_DEVICE_OP(dev_ops, counter_unbind_qp);
 
 	SET_OBJ_SIZE(dev_ops, ib_ah);
 	SET_OBJ_SIZE(dev_ops, ib_pd);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7313edc9f091..060d2f071ea7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1682,6 +1682,14 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
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
@@ -1877,6 +1885,7 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);
 
+	rdma_counter_unbind_qp(qp, true);
 	rdma_restrack_del(&qp->res);
 	ret = qp->device->ops.destroy_qp(qp, udata);
 	if (!ret) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 003d7b49ea54..06c77b3e42cd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1791,6 +1791,9 @@ struct ib_qp {
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
 	struct rdma_restrack_entry     res;
+
+	/* The counter the qp is bind to */
+	struct rdma_counter    *counter;
 };
 
 struct ib_dm {
@@ -2553,6 +2556,21 @@ struct ib_device_ops {
 	 */
 	void (*dealloc_driver)(struct ib_device *dev);
 
+	/**
+	 * counter_bind_qp - Bind a QP to a counter.
+	 * @counter - The counter to be bound. If counter->id is zero then
+	 *   the driver needs to allocate a new counter and set counter->id
+	 */
+	int (*counter_bind_qp)(struct rdma_counter *counter, struct ib_qp *qp);
+	/**
+	 * counter_unbind_qp - Unbind the qp from the dynamically-allocated
+	 *   counter and bind it onto the default one. If this is the last
+	 *   bound qp, then this counter will be deallocated.
+	 * @force - If it is true then free the counter in case of any error.
+	 *   used in cases like qp destroy.
+	 */
+	int (*counter_unbind_qp)(struct ib_qp *qp, bool force);
+
 	DECLARE_RDMA_OBJ_SIZE(ib_ah);
 	DECLARE_RDMA_OBJ_SIZE(ib_pd);
 	DECLARE_RDMA_OBJ_SIZE(ib_srq);
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index a8a7c1627800..159b8ba3487e 100644
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
+	atomic_t			usecnt;
+	struct rdma_counter_mode	mode;
+	struct mutex			lock;
 	u8				port;
 };
 
@@ -38,5 +44,7 @@ void rdma_counter_init(struct ib_device *dev);
 void rdma_counter_cleanup(struct ib_device *dev);
 int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			       bool on, enum rdma_nl_counter_mask mask);
+int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
+int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);
 
 #endif /* _RDMA_COUNTER_H_ */
-- 
2.20.1

