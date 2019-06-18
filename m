Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773B54A864
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfFRR1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfFRR13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:29 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE4ED215EA;
        Tue, 18 Jun 2019 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878848;
        bh=pvHbOf4AjxbTLzK+AZlJR87E8bA8Ji6UprXQeA9nWRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qxg2uZr3aFbWdE9WRZ5JPacEq40poEydzpaf5YqXih6UAS68YDJeANkCoxCRmNNN3
         xO9b87urtbRd7HY6iLNcJI+8+vFGmSShokmAVowExT1FqYGTh1/+3iM03OAKCneF12
         eBzWwuZm+ghTFhHxT6xVSaA0zbLRoxbBTT8A+ixE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 17/17] RDMA/nldev: Allow get default counter statistics through RDMA netlink
Date:   Tue, 18 Jun 2019 20:26:25 +0300
Message-Id: <20190618172625.13432-18-leon@kernel.org>
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

This patch adds the ability to return the hwstats of per-port default
counters (which can also be queried through sysfs nodes).

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 98 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/core/sysfs.c |  6 ++
 include/rdma/ib_verbs.h         |  1 +
 3 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index ccbc85d692e1..a6502b94239f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1705,6 +1705,99 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }

+static int stat_get_doit_default_counter(struct sk_buff *skb,
+					 struct nlmsghdr *nlh,
+					 struct netlink_ext_ack *extack,
+					 struct nlattr *tb[])
+{
+	struct rdma_hw_stats *stats;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int ret, num_cnts, i;
+	struct sk_buff *msg;
+	u32 index, port;
+	u64 v;
+
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), index);
+	if (!device)
+		return -EINVAL;
+
+	if (!device->ops.alloc_hw_stats || !device->ops.get_hw_stats) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_GET),
+			0, 0);
+
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	stats = device->port_data ? device->port_data[port].hw_stats : NULL;
+	if (stats == NULL) {
+		ret = -EINVAL;
+		goto err_msg;
+	}
+	mutex_lock(&stats->lock);
+
+	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
+	if (num_cnts < 0) {
+		ret = -EINVAL;
+		goto err_stats;
+	}
+
+	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err_stats;
+	}
+	for (i = 0; i < num_cnts; i++) {
+		v = stats->value[i] +
+			rdma_counter_get_hwstat_value(device, port, i);
+		if (fill_stat_hwcounter_entry(msg, stats->names[i], v)) {
+			ret = -EMSGSIZE;
+			goto err_table;
+		}
+	}
+	nla_nest_end(msg, table_attr);
+
+	mutex_unlock(&stats->lock);
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_table:
+	nla_nest_cancel(msg, table_attr);
+err_stats:
+	mutex_unlock(&stats->lock);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static int stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct netlink_ext_ack *extack, struct nlattr *tb[])

@@ -1777,9 +1870,12 @@ static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,

 	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
 			  nldev_policy, extack);
-	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES])
+	if (ret)
 		return -EINVAL;

+	if (!tb[RDMA_NLDEV_ATTR_STAT_RES])
+		return stat_get_doit_default_counter(skb, nlh, extack, tb);
+
 	switch (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES])) {
 	case RDMA_NLDEV_ATTR_RES_QP:
 		ret = stat_get_doit_qp(skb, nlh, extack, tb);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c59b80e0a740..b477295a96c2 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1003,6 +1003,8 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 			goto err;
 		port->hw_stats_ag = hsag;
 		port->hw_stats = stats;
+		if (device->port_data)
+			device->port_data[port_num].hw_stats = stats;
 	} else {
 		struct kobject *kobj = &device->dev.kobj;
 		ret = sysfs_create_group(kobj, hsag);
@@ -1293,6 +1295,8 @@ const struct attribute_group ib_dev_attr_group = {

 void ib_free_port_attrs(struct ib_core_device *coredev)
 {
+	struct ib_device *device = rdma_device_to_ibdev(&coredev->dev);
+	bool is_full_dev = &device->coredev == coredev;
 	struct kobject *p, *t;

 	list_for_each_entry_safe(p, t, &coredev->port_list, entry) {
@@ -1302,6 +1306,8 @@ void ib_free_port_attrs(struct ib_core_device *coredev)
 		if (port->hw_stats_ag)
 			free_hsag(&port->kobj, port->hw_stats_ag);
 		kfree(port->hw_stats);
+		if (device->port_data && is_full_dev)
+			device->port_data[port->port_num].hw_stats = NULL;

 		if (port->pma_table)
 			sysfs_remove_group(p, port->pma_table);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ff1a312d3e79..d1401f2a25be 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2237,6 +2237,7 @@ struct ib_port_data {
 	struct net_device __rcu *netdev;
 	struct hlist_node ndev_hash_link;
 	struct rdma_port_counter port_counter;
+	struct rdma_hw_stats *hw_stats;
 };

 /* rdma netdev type - specifies protocol type */
--
2.20.1

