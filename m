Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192864A857
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfFRR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfFRR1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:08 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972F1205F4;
        Tue, 18 Jun 2019 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878827;
        bh=DJ00UJ6C6uJzg0n6n4A8MofNZRaozpz6shTxEozL1TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwTEU/gXE5+gQDsz+VGWig/w/HmHVcHxw5F3+ScJZ9xJPrmtz9J/Wkl/y7TN8K2wq
         RJ85jgz2zBHKrrs7IXzZRCYtGnf9fOZHFCPE56QESrFbCZK5d1x5lsxeCKfnLMEjPW
         AqYm7g2TkBAS8Lr1ucnMexHG5WLnyJ4Bsj4WTqEQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 11/17] RDMA/netlink: Implement counter dumpit calback
Date:   Tue, 18 Jun 2019 20:26:19 +0300
Message-Id: <20190618172625.13432-12-leon@kernel.org>
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

This patch adds the ability to return all available counters
together with their properties and hwstats.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c |  26 +++-
 drivers/infiniband/core/device.c   |   2 +
 drivers/infiniband/core/nldev.c    | 213 +++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h            |  10 ++
 include/rdma/rdma_counter.h        |   3 +
 include/uapi/rdma/rdma_netlink.h   |  10 +-
 6 files changed, 262 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 554ad1a51b53..1c34b9e8407d 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -59,7 +59,7 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 {
 	struct rdma_counter *counter;

-	if (!dev->ops.counter_dealloc)
+	if (!dev->ops.counter_dealloc || !dev->ops.counter_alloc_stats)
 		return NULL;

 	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
@@ -69,16 +69,25 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 	counter->device    = dev;
 	counter->port      = port;
 	counter->res.type  = RDMA_RESTRACK_COUNTER;
+	counter->stats     = dev->ops.counter_alloc_stats(counter);
+	if (!counter->stats)
+		goto err_stats;
+
 	counter->mode.mode = mode;
 	kref_init(&counter->kref);
 	mutex_init(&counter->lock);

 	return counter;
+
+err_stats:
+	kfree(counter);
+	return NULL;
 }

 static void rdma_counter_free(struct rdma_counter *counter)
 {
 	rdma_restrack_del(&counter->res);
+	kfree(counter->stats);
 	kfree(counter);
 }

@@ -302,6 +311,21 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
 	return 0;
 }

+int rdma_counter_query_stats(struct rdma_counter *counter)
+{
+	struct ib_device *dev = counter->device;
+	int ret;
+
+	if (!dev->ops.counter_update_stats)
+		return -EINVAL;
+
+	mutex_lock(&counter->lock);
+	ret = dev->ops.counter_update_stats(counter);
+	mutex_unlock(&counter->lock);
+
+	return ret;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c976367231b1..2ccd340ce130 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2365,9 +2365,11 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, alloc_xrcd);
 	SET_DEVICE_OP(dev_ops, attach_mcast);
 	SET_DEVICE_OP(dev_ops, check_mr_status);
+	SET_DEVICE_OP(dev_ops, counter_alloc_stats);
 	SET_DEVICE_OP(dev_ops, counter_bind_qp);
 	SET_DEVICE_OP(dev_ops, counter_dealloc);
 	SET_DEVICE_OP(dev_ops, counter_unbind_qp);
+	SET_DEVICE_OP(dev_ops, counter_update_stats);
 	SET_DEVICE_OP(dev_ops, create_ah);
 	SET_DEVICE_OP(dev_ops, create_counters);
 	SET_DEVICE_OP(dev_ops, create_cq);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 9819dc718928..03a5d2bbe4b3 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -123,6 +123,13 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_MODE]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_STAT_RES]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_COUNTER]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY]	= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]       = { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]       = { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY]  = { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] = { .type = NLA_NUL_STRING },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = { .type = NLA_U64 },
 };

 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -626,6 +633,152 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 err:	return -EMSGSIZE;
 }

+static int fill_stat_counter_mode(struct sk_buff *msg,
+				  struct rdma_counter *counter)
+{
+	struct rdma_counter_mode *m = &counter->mode;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_MODE, m->mode))
+		return -EMSGSIZE;
+
+	if (m->mode == RDMA_COUNTER_MODE_AUTO)
+		if ((m->mask & RDMA_COUNTER_MASK_QP_TYPE) &&
+		    nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TYPE, m->param.qp_type))
+			return -EMSGSIZE;
+
+	return 0;
+}
+
+static int fill_stat_counter_qp_entry(struct sk_buff *msg, u32 qpn)
+{
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP_ENTRY);
+	if (!entry_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn))
+		goto err;
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+	return -EMSGSIZE;
+}
+
+static int fill_stat_counter_qps(struct sk_buff *msg,
+				 struct rdma_counter *counter)
+{
+	struct rdma_restrack_entry *res;
+	struct rdma_restrack_root *rt;
+	struct nlattr *table_attr;
+	struct ib_qp *qp = NULL;
+	unsigned long id = 0;
+	int ret = 0;
+
+	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP);
+
+	rt = &counter->device->res[RDMA_RESTRACK_QP];
+	xa_lock(&rt->xa);
+	xa_for_each(&rt->xa, id, res) {
+		if (!rdma_is_visible_in_pid_ns(res))
+			continue;
+
+		qp = container_of(res, struct ib_qp, res);
+		if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+			continue;
+
+		if (!qp->counter || (qp->counter->id != counter->id))
+			continue;
+
+		ret = fill_stat_counter_qp_entry(msg, qp->qp_num);
+		if (ret)
+			goto err;
+	}
+
+	xa_unlock(&rt->xa);
+	nla_nest_end(msg, table_attr);
+	return 0;
+
+err:
+	xa_unlock(&rt->xa);
+	nla_nest_cancel(msg, table_attr);
+	return ret;
+}
+
+static int fill_stat_hwcounter_entry(struct sk_buff *msg,
+				     const char *name, u64 value)
+{
+	struct nlattr *entry_attr;
+
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY);
+	if (!entry_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_string(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,
+			   name))
+		goto err;
+	if (nla_put_u64_64bit(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE,
+			      value, RDMA_NLDEV_ATTR_PAD))
+		goto err;
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+	return -EMSGSIZE;
+}
+
+static int fill_stat_counter_hwcounters(struct sk_buff *msg,
+					struct rdma_counter *counter)
+{
+	struct rdma_hw_stats *st = counter->stats;
+	struct nlattr *table_attr;
+	int i;
+
+	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!table_attr)
+		return -EMSGSIZE;
+
+	for (i = 0; i < st->num_counters; i++)
+		if (fill_stat_hwcounter_entry(msg, st->names[i], st->value[i]))
+			goto err;
+
+	nla_nest_end(msg, table_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, table_attr);
+	return -EMSGSIZE;
+}
+
+static int fill_res_counter_entry(struct sk_buff *msg, bool has_cap_net_admin,
+				  struct rdma_restrack_entry *res,
+				  uint32_t port)
+{
+	struct rdma_counter *counter =
+		container_of(res, struct rdma_counter, res);
+
+	if (port && port != counter->port)
+		return 0;
+
+	/* Dump it even query failed */
+	rdma_counter_query_stats(counter);
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, counter->port) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, counter->id) ||
+	    fill_res_name_pid(msg, &counter->res) ||
+	    fill_stat_counter_mode(msg, counter) ||
+	    fill_stat_counter_qps(msg, counter) ||
+	    fill_stat_counter_hwcounters(msg, counter))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
 static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
@@ -993,6 +1146,13 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 		.entry = RDMA_NLDEV_ATTR_RES_PD_ENTRY,
 		.id = RDMA_NLDEV_ATTR_RES_PDN,
 	},
+	[RDMA_RESTRACK_COUNTER] = {
+		.fill_res_func = fill_res_counter_entry,
+		.nldev_cmd = RDMA_NLDEV_CMD_STAT_GET,
+		.nldev_attr = RDMA_NLDEV_ATTR_STAT_COUNTER,
+		.entry = RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY,
+		.id = RDMA_NLDEV_ATTR_STAT_COUNTER_ID,
+	},
 };

 static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -1229,6 +1389,7 @@ RES_GET_FUNCS(cm_id, RDMA_RESTRACK_CM_ID);
 RES_GET_FUNCS(cq, RDMA_RESTRACK_CQ);
 RES_GET_FUNCS(pd, RDMA_RESTRACK_PD);
 RES_GET_FUNCS(mr, RDMA_RESTRACK_MR);
+RES_GET_FUNCS(counter, RDMA_RESTRACK_COUNTER);

 static LIST_HEAD(link_ops);
 static DECLARE_RWSEM(link_ops_rwsem);
@@ -1463,6 +1624,54 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }

+static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES])) {
+	case RDMA_NLDEV_ATTR_RES_QP:
+		ret = nldev_res_get_counter_doit(skb, nlh, extack);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int nldev_stat_get_dumpit(struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	int ret;
+
+	ret = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, NULL);
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES])) {
+	case RDMA_NLDEV_ATTR_RES_QP:
+		ret = nldev_res_get_counter_dumpit(skb, cb);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -1518,6 +1727,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_stat_set_doit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
+	[RDMA_NLDEV_CMD_STAT_GET] = {
+		.doit = nldev_stat_get_doit,
+		.dump = nldev_stat_get_dumpit,
+	},
 };

 void __init nldev_init(void)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0fe2a29939f6..ff1a312d3e79 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2607,6 +2607,16 @@ struct ib_device_ops {
 	 * counter_dealloc -De-allocate the hw counter
 	 */
 	int (*counter_dealloc)(struct rdma_counter *counter);
+	/**
+	 * counter_alloc_stats - Allocate a struct rdma_hw_stats and fill in
+	 * the driver initialized data.
+	 */
+	struct rdma_hw_stats *(*counter_alloc_stats)(
+		struct rdma_counter *counter);
+	/**
+	 * counter_update_stats - Query the stats value of this counter
+	 */
+	int (*counter_update_stats)(struct rdma_counter *counter);

 	DECLARE_RDMA_OBJ_SIZE(ib_ah);
 	DECLARE_RDMA_OBJ_SIZE(ib_cq);
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 9f93a2403c9c..f2a5c8efc404 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -37,6 +37,7 @@ struct rdma_counter {
 	struct kref			kref;
 	struct rdma_counter_mode	mode;
 	struct mutex			lock;
+	struct rdma_hw_stats		*stats;
 	u8				port;
 };

@@ -47,4 +48,6 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port);
 int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);

+int rdma_counter_query_stats(struct rdma_counter *counter);
+
 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index f33fe37b2f3e..66f354a360a5 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -281,6 +281,8 @@ enum rdma_nldev_command {

 	RDMA_NLDEV_CMD_STAT_SET,

+	RDMA_NLDEV_CMD_STAT_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };

@@ -498,7 +500,13 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
 	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
 	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
-
+	RDMA_NLDEV_ATTR_STAT_COUNTER,		/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_COUNTER_ID,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTERS,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE,	/* u64 */
 	/*
 	 * Always the end
 	 */
--
2.20.1

