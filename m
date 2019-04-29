Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00953DDFA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfD2If6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfD2If4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:56 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD0D214AE;
        Mon, 29 Apr 2019 08:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526955;
        bh=DVwUCiWkka9qSQ5iT3UBevW65T70pQ15TVQej26pceY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThieOPg1DHoX4ACBAAueVhqOF5vn8dcxIoZMl9bY9NXNdJycii1ez+Q1zi7jj661w
         VEj1r53JW2dl1qTgmzXR9GkfVB1Kr/LeghSY7EMWP5Zp+p8ExnWN1M9rQY182MaFQy
         Yx32SSJjUBmGS5pytfx0x6YYONpWxGiMCmJRUUIs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 17/17] RDMA/nldev: Allow get default counter statistics through RDMA netlink
Date:   Mon, 29 Apr 2019 11:34:53 +0300
Message-Id: <20190429083453.16654-18-leon@kernel.org>
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

This patch adds the ability to return the hwstats of per-port default
counters (which can also be queried through sysfs nodes).

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c | 101 +++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 53c1d2d82a06..cb2dd38f49f1 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1709,6 +1709,98 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int nldev_res_get_default_counter_doit(struct sk_buff *skb,
+					      struct nlmsghdr *nlh,
+					      struct netlink_ext_ack *extack,
+					      struct nlattr *tb[])
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
+	stats = device->ops.alloc_hw_stats(device, port);
+	if (!stats) {
+		ret = -ENOMEM;
+		goto err_msg;
+	}
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
+	kfree(stats);
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_table:
+	nla_nest_cancel(msg, table_attr);
+err_stats:
+	kfree(stats);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
 static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
@@ -1725,8 +1817,13 @@ static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ret)
 		return -EINVAL;
 
-	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE])
-		return nldev_res_get_counter_doit(skb, nlh, extack);
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		if (!tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+			return nldev_res_get_default_counter_doit(skb, nlh,
+								  extack, tb);
+		else
+			return nldev_res_get_counter_doit(skb, nlh, extack);
+	}
 
 	if (!tb[RDMA_NLDEV_ATTR_STAT_RES] || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
 	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
-- 
2.20.1

