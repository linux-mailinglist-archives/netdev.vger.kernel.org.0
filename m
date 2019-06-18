Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03E94A85E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfFRR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfFRR1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:19 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC5D205F4;
        Tue, 18 Jun 2019 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878838;
        bh=C5or1/EgFxz72GP17HIx6FQt3Ufpt4oXYJnmbvlcD+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPr9MCUg5MwxQsYkxHcvBFXBgTpEmU8H/I4TewuMqSQC4d2sUgbn6oyBiKJAfHDR9
         eDPUNbm1QJhStdmfgg84MppVPLzcG2L72hnKQz3KV67e08nKId0dxL2wN9DcZLAnkA
         9x4KTLJ0p8xewee/9QPCsrlvUyM/njj/5ds0QJxA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 14/17] RDMA/counter: Allow manual mode configuration support
Date:   Tue, 18 Jun 2019 20:26:22 +0300
Message-Id: <20190618172625.13432-15-leon@kernel.org>
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

In manual mode a QP is bound to a counter manually. If counter is not
specified then a new one will be allocated.
Manually mode is enabled when user binds a QP, and disabled when the
last manually bound QP is unbound.
When auto-mode is turned off and there are counters left, manual mode
is enabled so that the user is able to access these counters.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 221 ++++++++++++++++++++++++++++-
 include/rdma/rdma_counter.h        |   7 +
 include/uapi/rdma/rdma_netlink.h   |   6 +
 3 files changed, 231 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 0d0a07d2ef58..15f94d96e23b 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -27,7 +27,9 @@ static int __counter_set_mode(struct rdma_counter_mode *curr,
 /**
  * rdma_counter_set_auto_mode() - Turn on/off per-port auto mode
  *
- * When @on is true, the @mask must be set
+ * When @on is true, the @mask must be set; When @on is false, it goes
+ * into manual mode if there's any counter, so that the user is able to
+ * manually access them.
  */
 int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			       bool on, enum rdma_nl_counter_mask mask)
@@ -45,8 +47,13 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			ret = -EINVAL;
 			goto out;
 		}
-		ret = __counter_set_mode(&port_counter->mode,
-					 RDMA_COUNTER_MODE_NONE, 0);
+
+		if (port_counter->num_counters)
+			ret = __counter_set_mode(&port_counter->mode,
+						 RDMA_COUNTER_MODE_MANUAL, 0);
+		else
+			ret = __counter_set_mode(&port_counter->mode,
+						 RDMA_COUNTER_MODE_NONE, 0);
 	}

 out:
@@ -57,7 +64,9 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 					       enum rdma_nl_counter_mode mode)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
+	int ret;

 	if (!dev->ops.counter_dealloc || !dev->ops.counter_alloc_stats)
 		return NULL;
@@ -73,12 +82,27 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 	if (!counter->stats)
 		goto err_stats;

+	port_counter = &dev->port_data[port].port_counter;
+	mutex_lock(&port_counter->lock);
+	if (mode == RDMA_COUNTER_MODE_MANUAL) {
+		ret = __counter_set_mode(&port_counter->mode,
+					 RDMA_COUNTER_MODE_MANUAL, 0);
+		if (ret)
+			goto err_mode;
+	}
+
+	port_counter->num_counters++;
+	mutex_unlock(&port_counter->lock);
+
 	counter->mode.mode = mode;
 	kref_init(&counter->kref);
 	mutex_init(&counter->lock);

 	return counter;

+err_mode:
+	mutex_unlock(&port_counter->lock);
+	kfree(counter->stats);
 err_stats:
 	kfree(counter);
 	return NULL;
@@ -86,6 +110,18 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,

 static void rdma_counter_free(struct rdma_counter *counter)
 {
+	struct rdma_port_counter *port_counter;
+
+	port_counter = &counter->device->port_data[counter->port].port_counter;
+	mutex_lock(&port_counter->lock);
+	port_counter->num_counters--;
+	if (!port_counter->num_counters &&
+	    (port_counter->mode.mode == RDMA_COUNTER_MODE_MANUAL))
+		__counter_set_mode(&port_counter->mode, RDMA_COUNTER_MODE_NONE,
+				   0);
+
+	mutex_unlock(&port_counter->lock);
+
 	rdma_restrack_del(&counter->res);
 	kfree(counter->stats);
 	kfree(counter);
@@ -390,6 +426,185 @@ u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index)
 	return sum;
 }

+static struct ib_qp *rdma_counter_get_qp(struct ib_device *dev, u32 qp_num)
+{
+	struct rdma_restrack_entry *res = NULL;
+	struct ib_qp *qp = NULL;
+
+	res = rdma_restrack_get_byid(dev, RDMA_RESTRACK_QP, qp_num);
+	if (IS_ERR(res))
+		return NULL;
+
+	if (!rdma_is_visible_in_pid_ns(res))
+		goto err;
+
+	qp = container_of(res, struct ib_qp, res);
+	if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+		goto err;
+
+	return qp;
+
+err:
+	rdma_restrack_put(&qp->res);
+	return NULL;
+}
+
+static int rdma_counter_bind_qp_manual(struct rdma_counter *counter,
+				       struct ib_qp *qp)
+{
+	if ((counter->device != qp->device) || (counter->port != qp->port))
+		return -EINVAL;
+
+	return __rdma_counter_bind_qp(counter, qp);
+}
+
+static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
+						   u32 counter_id)
+{
+	struct rdma_restrack_entry *res;
+
+	res = rdma_restrack_get_byid(dev, RDMA_RESTRACK_COUNTER, counter_id);
+	if (IS_ERR(res))
+		return NULL;
+
+	if (!rdma_is_visible_in_pid_ns(res)) {
+		rdma_restrack_put(res);
+		return NULL;
+	}
+
+	return container_of(res, struct rdma_counter, res);
+}
+
+/**
+ * rdma_counter_bind_qpn() - Bind QP @qp_num to counter @counter_id
+ */
+int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+			  u32 qp_num, u32 counter_id)
+{
+	struct rdma_counter *counter;
+	struct ib_qp *qp;
+	int ret;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	counter = rdma_get_counter_by_id(dev, counter_id);
+	if (!counter) {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	if (counter->res.task != qp->res.task) {
+		ret = -EINVAL;
+		goto err_task;
+	}
+
+	ret = rdma_counter_bind_qp_manual(counter, qp);
+	if (ret)
+		goto err_task;
+
+	kref_get(&counter->kref);
+
+	rdma_restrack_put(&qp->res);
+	return 0;
+
+err_task:
+	rdma_restrack_put(&counter->res);
+err:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
+/**
+ * rdma_counter_bind_qpn_alloc() - Alloc a counter and bind QP @qp_num to it
+ *   The id of new counter is returned in @counter_id
+ */
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+				u32 qp_num, u32 *counter_id)
+{
+	struct rdma_counter *counter;
+	struct ib_qp *qp;
+	int ret;
+
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	if (rdma_is_port_valid(dev, qp->port) && (qp->port != port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	counter = rdma_counter_alloc(dev, port, RDMA_COUNTER_MODE_MANUAL);
+	if (!counter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = rdma_counter_bind_qp_manual(counter, qp);
+	if (ret)
+		goto err_bind;
+
+	if (counter_id)
+		*counter_id = counter->id;
+
+	rdma_counter_res_add(counter, qp);
+
+	if (!rdma_restrack_get(&counter->res)) {
+		rdma_counter_unbind_qp(qp, false);
+		ret = -EINVAL;
+	}
+
+	rdma_restrack_put(&qp->res);
+	return ret;
+
+err_bind:
+	rdma_counter_free(counter);
+err:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
+/**
+ * rdma_counter_unbind_qpn() - Unbind QP @qp_num from a counter
+ */
+int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+			    u32 qp_num, u32 counter_id)
+{
+	struct rdma_port_counter *port_counter;
+	struct ib_qp *qp;
+	int ret;
+
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	if (rdma_is_port_valid(dev, qp->port) && (qp->port != port)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	port_counter = &dev->port_data[port].port_counter;
+	if (!qp->counter || qp->counter->id != counter_id ||
+	    port_counter->mode.mode != RDMA_COUNTER_MODE_MANUAL) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rdma_counter_unbind_qp(qp, false);
+
+out:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index bf2c3578768f..6603e10eb352 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -28,6 +28,7 @@ struct rdma_counter_mode {
 struct rdma_port_counter {
 	struct rdma_counter_mode mode;
 	struct rdma_hw_stats *hstats;
+	unsigned int num_counters;
 	struct mutex lock;
 };

@@ -51,5 +52,11 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);

 int rdma_counter_query_stats(struct rdma_counter *counter);
 u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index);
+int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+			  u32 qp_num, u32 counter_id);
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+				u32 qp_num, u32 *counter_id);
+int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+			    u32 qp_num, u32 counter_id);

 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 66f354a360a5..31e2c9536f0f 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -525,6 +525,12 @@ enum rdma_nl_counter_mode {
 	 */
 	RDMA_COUNTER_MODE_AUTO,

+	/*
+	 * Which qp are bound with which counter is explicitly specified
+	 * by the user
+	 */
+	RDMA_COUNTER_MODE_MANUAL,
+
 	/*
 	 * Always the end
 	 */
--
2.20.1

