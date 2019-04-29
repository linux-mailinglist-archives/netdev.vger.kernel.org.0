Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E713DDDF6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfD2Ifv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfD2Ift (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:49 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3B020578;
        Mon, 29 Apr 2019 08:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526948;
        bh=uv3HR8Ubu5wEBiuHeZYY3V7Ar6+HNOLVzTKjzNKkPXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbuL1ZtaeLFk7xvQjkgR6oHsryPfmEDizrahb0z03FPzXreA/QPTTzTf3RD06qxKL
         hAp9qc7snz1g/e9cAakaIdz3QpW++Qo2CtwF8QMKn3uiPNrd09my7jIoPCQ8diWRu0
         gYdb+z8pMZK/s0q4Ft7+zBxSE56tuflWV6hMDOOY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 15/17] RDMA/nldev: Allow counter manual mode configration through RDMA netlink
Date:   Mon, 29 Apr 2019 11:34:51 +0300
Message-Id: <20190429083453.16654-16-leon@kernel.org>
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

Provide an option to allow users to manually bind a qp with a counter
through RDMA netlink. Limit it to users with ADMIN capability only.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c  | 111 +++++++++++++++++++++++++++----
 include/rdma/rdma_counter.h      |   3 +
 include/uapi/rdma/rdma_netlink.h |   2 +
 3 files changed, 103 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 1f7de88effad..6b7bc1a3d61d 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1559,8 +1559,8 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
+	u32 index, port, mode, mask = 0, qpn, cntn = 0;
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
-	u32 index, port, mode, mask = 0;
 	struct ib_device *device;
 	struct sk_buff *msg;
 	int ret;
@@ -1598,30 +1598,111 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			0, 0);
 
 	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
-	if (mode != RDMA_COUNTER_MODE_AUTO) {
-		ret = -EMSGSIZE;
-		goto err_msg;
+	if (mode == RDMA_COUNTER_MODE_AUTO) {
+		if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+			mask = nla_get_u32(
+				tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+
+		ret = rdma_counter_set_auto_mode(device, port,
+						 mask ? true : false, mask);
+		if (ret)
+			goto err_msg;
+	} else {
+		qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
+			cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+			ret = rdma_counter_bind_qpn(device, port, qpn, cntn);
+		} else {
+			ret = rdma_counter_bind_qpn_alloc(device, port,
+							  qpn, &cntn);
+		}
+		if (ret)
+			goto err_msg;
+
+		if (fill_nldev_handle(msg, device) ||
+		    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
+		    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
+		    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
+			ret = -EMSGSIZE;
+			goto err_fill;
+		}
+	}
+
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
+
+err_fill:
+	rdma_counter_unbind_qpn(device, port, qpn, cntn);
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
+static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index, port, qpn, cntn;
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_LQPN])
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
 	}
 
-	if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
-		mask = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 RDMA_NLDEV_CMD_STAT_SET),
+			0, 0);
 
-	ret = rdma_counter_set_auto_mode(device, port,
-					 mask ? true : false, mask);
+	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
+	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
 	if (ret)
-		goto err_msg;
+		goto err_unbind;
 
-	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_MODE, mode) ||
-	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask)) {
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
 		ret = -EMSGSIZE;
-		goto err_msg;
+		goto err_fill;
 	}
 
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
 
-err_msg:
+err_fill:
+	rdma_counter_bind_qpn(device, port, qpn, cntn);
+err_unbind:
 	nlmsg_free(msg);
 err:
 	ib_device_put(device);
@@ -1687,6 +1768,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_res_get_counter_doit,
 		.dump = nldev_res_get_counter_dumpit,
 	},
+	[RDMA_NLDEV_CMD_STAT_DEL] = {
+		.doit = nldev_stat_del_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index b79319abbdef..f485b86a318c 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -57,5 +57,8 @@ int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 				u32 qp_num, u32 *counter_id);
 int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
 			    u32 qp_num, u32 counter_id);
+int rdma_counter_get_mode(struct ib_device *dev, u8 port,
+			  enum rdma_nl_counter_mode *mode,
+			  enum rdma_nl_counter_mask *mask);
 
 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 5f4461286e28..aaeeb0a8aec6 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -271,6 +271,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_STAT_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
-- 
2.20.1

