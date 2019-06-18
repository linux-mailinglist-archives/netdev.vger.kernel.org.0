Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7794A860
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfFRR1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfFRR1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:22 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D666C214AF;
        Tue, 18 Jun 2019 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878841;
        bh=S990mUF0lyeOYV4CgkUV9DmUqINVlw6KHfw8kUvFry8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzTs1NKCNW/SF0c5ulaKB0BHE9O9daruF8jvqFQrRrk7Ah/NX8hoA6C+4KOUCV4hw
         kmHHFkdLhZeXdQRzYZwEH0tIFnf2EWnEbI3jMzm6YeYQIr3n7MKrCNNndEsAJ9Sk2Q
         OVLkMqZ1fvzsRCf2bWEAjTj6c66mzrMf6DlcnOL8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 15/17] RDMA/nldev: Allow counter manual mode configration through RDMA netlink
Date:   Tue, 18 Jun 2019 20:26:23 +0300
Message-Id: <20190618172625.13432-16-leon@kernel.org>
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
index 03a5d2bbe4b3..9ee6c0c77f2f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1555,8 +1555,8 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
+	u32 index, port, mode, mask = 0, qpn, cntn = 0;
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
-	u32 index, port, mode, mask = 0;
 	struct ib_device *device;
 	struct sk_buff *msg;
 	int ret;
@@ -1594,30 +1594,111 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -1731,6 +1812,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_stat_get_doit,
 		.dump = nldev_stat_get_dumpit,
 	},
+	[RDMA_NLDEV_CMD_STAT_DEL] = {
+		.doit = nldev_stat_del_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 };

 void __init nldev_init(void)
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 6603e10eb352..68827700ba95 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -58,5 +58,8 @@ int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
 				u32 qp_num, u32 *counter_id);
 int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
 			    u32 qp_num, u32 counter_id);
+int rdma_counter_get_mode(struct ib_device *dev, u8 port,
+			  enum rdma_nl_counter_mode *mode,
+			  enum rdma_nl_counter_mask *mask);

 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 31e2c9536f0f..27ed524125ec 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -283,6 +283,8 @@ enum rdma_nldev_command {

 	RDMA_NLDEV_CMD_STAT_GET, /* can dump */

+	RDMA_NLDEV_CMD_STAT_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };

--
2.20.1

