Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD694A862
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbfFRR10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfFRR1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:25 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5326221530;
        Tue, 18 Jun 2019 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878845;
        bh=k28jaqq5NQ7NOEtnzSnuOfrnvq+K4J2frxFl27m289M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbL3exPtjm10gBUDFAEy4DsvofkK8eR1GsBCreh3r7jzur49lekgcfov2fQC5FRXx
         DgjQhJe6Mn1SRb1p6tSxEMpMlFPmi2Hpsa7ViYIbGiOznfE6ro0xAUZVfKe5ti0ePT
         g7K2xgHed+gDMFTos+7bHllms5HEWUxyYDJFjs4M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 10/17] RDMA/nldev: Allow counter auto mode configration through RDMA netlink
Date:   Tue, 18 Jun 2019 20:26:18 +0300
Message-Id: <20190618172625.13432-11-leon@kernel.org>
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
index 39dd9b366629..9819dc718928 100644
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
@@ -1388,6 +1391,78 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -1438,6 +1513,9 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
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
index 56ddd4cd30a2..f33fe37b2f3e 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -279,6 +279,8 @@ enum rdma_nldev_command {

 	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */

+	RDMA_NLDEV_CMD_STAT_SET,
+
 	RDMA_NLDEV_NUM_OPS
 };

@@ -490,6 +492,12 @@ enum rdma_nldev_attr {
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

