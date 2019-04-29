Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905F1DDEB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfD2Ife (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfD2Ifc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:32 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5585F20578;
        Mon, 29 Apr 2019 08:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526931;
        bh=TKteFsVYD8MRftzjRBlAa1O1BlntNG0k0xRPkgT/CFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hhfbs7SOOM/Nwev3K35Vzq8qE85TVZ3bxMVwx7qoRQMODjjLpHeigxUNmcOb7fch3
         ikz91L5n+5z/AbSX8irV9Y8x7jhAce75Y2DF0lc4QMxg/GB/ViEOJDygeXl/ZwBiYv
         uDA1BncVQeWHgAjJW99gHt2jEs+MREcDfgvh2a7k=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 10/17] RDMA/nldev: Allow counter auto mode configration through RDMA netlink
Date:   Mon, 29 Apr 2019 11:34:46 +0300
Message-Id: <20190429083453.16654-11-leon@kernel.org>
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

Provide an option to enable/disable per-port counter auto mode through
RDMA netlink. Limit it to users with ADMIN capability only.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c  | 78 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  8 ++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4fb6d4285970..b46992ed3553 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -120,6 +120,9 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DEV_PROTOCOL]		= { .type = NLA_NUL_STRING,
 				    .len = RDMA_NLDEV_ATTR_ENTRY_STRLEN },
 	[RDMA_NLDEV_NET_NS_FD]			= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_MODE]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_RES]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]	= { .type = NLA_U32 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -1384,6 +1387,78 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	u32 index, port, mode, mask = 0;
+	struct ib_device *device;
+	struct sk_buff *msg;
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	/* Currently only counter for QP is supported */
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		return -EINVAL;
+
+	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
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
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_SET),
+			0, 0);
+
+	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+	if (mode != RDMA_COUNTER_MODE_AUTO) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+		mask = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+
+	ret = rdma_counter_set_auto_mode(device, port,
+					 mask ? true : false, mask);
+	if (ret)
+		goto err_msg;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_MODE, mode) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask)) {
+		ret = -EMSGSIZE;
+		goto err_msg;
+	}
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
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -1434,6 +1509,9 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	},
 	[RDMA_NLDEV_CMD_SYS_SET] = {
 		.doit = nldev_set_sys_set_doit,
+	},
+	[RDMA_NLDEV_CMD_STAT_SET] = {
+		.doit = nldev_stat_set_doit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
 };
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index cd3cace46b27..673fdf9ba10f 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -267,6 +267,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_SET,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -478,6 +480,12 @@ enum rdma_nldev_attr {
 	 * File descriptor handle of the net namespace object
 	 */
 	RDMA_NLDEV_NET_NS_FD,			/* u32 */
+	/*
+	 * Counter-specific attributes.
+	 */
+	RDMA_NLDEV_ATTR_STAT_MODE,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_RES,		/* u32 */
+	RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK,	/* u32 */
 
 	/*
 	 * Always the end
-- 
2.20.1

