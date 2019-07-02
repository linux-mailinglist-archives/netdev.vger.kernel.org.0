Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10075CD46
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfGBKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfGBKDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 06:03:55 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E3B420665;
        Tue,  2 Jul 2019 10:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562061835;
        bh=Tpoe1nONBrcCNPzL2NZcHqTmxm6BrvIJ/SwPqxNH0Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrkrRveUa+jIkcIl+K0UGaeoutdnCmKlZHdOblyQ6StCIpKY9325BwfEcslhVSnmV
         S8MIswL7QTulkRgYUL5YzSFyGmhD/xzB01XV3lWyG2V96XOu7QGR/fTEHyA8H4KOZd
         wDLAW3snP7+bjo+Pw/TwNtdBziKmsLLZ4zhL8ujI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v5 16/17] RDMA/nldev: Allow get counter mode through RDMA netlink
Date:   Tue,  2 Jul 2019 13:02:45 +0300
Message-Id: <20190702100246.17382-17-leon@kernel.org>
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

Provide an option to get current counter mode through RDMA netlink.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 13 ++++++
 drivers/infiniband/core/nldev.c    | 66 +++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 6ac8bf1240de..e924e9f7956d 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -576,6 +576,19 @@ int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
 	return ret;
 }
 
+int rdma_counter_get_mode(struct ib_device *dev, u8 port,
+			  enum rdma_nl_counter_mode *mode,
+			  enum rdma_nl_counter_mask *mask)
+{
+	struct rdma_port_counter *port_counter;
+
+	port_counter = &dev->port_data[port].port_counter;
+	*mode = port_counter->mode.mode;
+	*mask = port_counter->mode.mask;
+
+	return 0;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 3d750eca53d5..4993f47b0731 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1799,6 +1799,70 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct netlink_ext_ack *extack, struct nlattr *tb[])
+
+{
+	static enum rdma_nl_counter_mode mode;
+	static enum rdma_nl_counter_mask mask;
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index, port;
+	int ret;
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+		return nldev_res_get_counter_doit(skb, nlh, extack);
+
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), index);
+	if (!device)
+		return -EINVAL;
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
+	ret = rdma_counter_get_mode(device, port, &mode, &mask);
+	if (ret)
+		goto err_msg;
+
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_MODE, mode))
+		goto err_msg;
+
+	if ((mode == RDMA_COUNTER_MODE_AUTO) &&
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask))
+		goto err_msg;
+
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
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
@@ -1812,7 +1876,7 @@ static int nldev_stat_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	switch (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES])) {
 	case RDMA_NLDEV_ATTR_RES_QP:
-		ret = nldev_res_get_counter_doit(skb, nlh, extack);
+		ret = stat_get_doit_qp(skb, nlh, extack, tb);
 		break;
 
 	default:
-- 
2.20.1

