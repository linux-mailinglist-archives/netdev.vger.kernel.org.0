Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7C341D520
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349153AbhI3IGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348967AbhI3IEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95D2261880;
        Thu, 30 Sep 2021 08:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988975;
        bh=/cPEeBrJZTDJoVzYEQsj4dCWMKPjXSdrl2nFCOX7KwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtQFobgSUcwlsSWHNaEGKV/glhKejC8sQgybBJwLmBDuowmJ0OHt4QL/VTCmjfdmk
         RvkvZg99pI3fkvQ13qYs4RtXm+KiTcjYIsY4mbRnfeQ98WzLar+cJtF1HRBeKZstgx
         GoIBvQj8H7eRPvuIhPEYNZDolohTW3ZjzdyUIe+fyQKqPq4DN9s6CsjnWFmTEkuP7v
         3/lwyyiIdDfCZ/Q0YxowtSHgtoXNVbJ1gZRPIe4gugnDladFCHXDyt3j1tnb8cPb3C
         vOutP8ho5VSFgnwBwuF1mVi9SJ0YKgR5AncxjuKq1h89dgUKb+72Vk6W2duEjqKlCQ
         vPSbmy9UyKisw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 07/13] RDMA/nldev: Add support to get status of all counters
Date:   Thu, 30 Sep 2021 11:02:23 +0300
Message-Id: <fde0ee20aa0e914ef4112522640bb4fb77bb0331.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

This patch adds the ability to get the name, index and status of all
counters for each link through RDMA netlink. This can be used for
user-space to get the current optional-counter mode.

Examples:
$ rdma statistic mode
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts

$ rdma statistic mode supported
link rocep8s0f0/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts
link rocep8s0f1/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/nldev.c  | 98 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  5 ++
 2 files changed, 103 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 67519730b1ac..210057fef7bd 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -154,6 +154,8 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_NET_NS_FD]			= { .type = NLA_U32 },
 	[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX]	= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC] = { .type = NLA_U8 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -2264,6 +2266,99 @@ static int nldev_stat_get_dumpit(struct sk_buff *skb,
 	return ret;
 }
 
+static int nldev_stat_get_counter_status_doit(struct sk_buff *skb,
+					      struct nlmsghdr *nlh,
+					      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX], *table, *entry;
+	struct rdma_hw_stats *stats;
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 devid, port;
+	int ret, i;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	devid = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), devid);
+	if (!device)
+		return -EINVAL;
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats) {
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
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_GET_STATUS),
+		0, 0);
+
+	ret = -EMSGSIZE;
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
+		goto err_msg;
+
+	table = nla_nest_start(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTERS);
+	if (!table)
+		goto err_msg;
+
+	mutex_lock(&stats->lock);
+	for (i = 0; i < stats->num_counters; i++) {
+		entry = nla_nest_start(msg,
+				       RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY);
+		if (!entry)
+			goto err_msg_table;
+
+		if (nla_put_string(msg,
+				   RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME,
+				   stats->descs[i].name) ||
+		    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX, i))
+			goto err_msg_entry;
+
+		if ((stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) &&
+		    (nla_put_u8(msg, RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC,
+				!test_bit(i, stats->is_disabled))))
+			goto err_msg_entry;
+
+		nla_nest_end(msg, entry);
+	}
+	mutex_unlock(&stats->lock);
+
+	nla_nest_end(msg, table);
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
+
+err_msg_entry:
+	nla_nest_cancel(msg, entry);
+err_msg_table:
+	mutex_unlock(&stats->lock);
+	nla_nest_cancel(msg, table);
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
@@ -2353,6 +2448,9 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.dump = nldev_res_get_mr_raw_dumpit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
+	[RDMA_NLDEV_CMD_STAT_GET_STATUS] = {
+		.doit = nldev_stat_get_counter_status_doit,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 75a1ae2311d8..e50c357367db 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -297,6 +297,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_GET_STATUS,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -549,6 +551,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.31.1

