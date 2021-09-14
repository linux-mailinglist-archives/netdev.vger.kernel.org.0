Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FBE40BBEE
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhINXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235815AbhINXJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5423061165;
        Tue, 14 Sep 2021 23:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660872;
        bh=w57x6VI0rlFv5QDaLwnjQhamrQH2n6KvGcjw2NrsCsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrgBN0Up1jmzPdKw+H/NzFzXIaApuu4aQrg5NzwpFHzj/rTiUAm70wbZcJ7NRPtZJ
         gkNlA2+LTXtqRSkcm2eaoH7r+PeYoKbXzkzm9Iffhi0DWwfCen61gvSE4pIKImPalL
         +1swTKlaORy+/FzM/TdtAO5hPD7WghjSAcJpEAFny7w5Ae7ZEG+iJKGF3pp0k9tAA7
         ZdK2TKq3DntFs8ANNT1xFtg0bvgoh3spzNqn+Bs5tIXgmprTiBUUsmSUCkg5O0NVE7
         RzBNj3ma6Ioma+lPGmmK/HoyVEeeoK8WXxj1peVW5cea+hClcnQYaAbIrHGwIW8Ge2
         mzWXsknJOhSaA==
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
Subject: [PATCH rdma-next v1 06/11] RDMA/nldev: Add support to get status of all counters
Date:   Wed, 15 Sep 2021 02:07:25 +0300
Message-Id: <86b8a508d7e782b003d60acb06536681f0d4c721.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660727.git.leonro@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
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
 drivers/infiniband/core/nldev.c  | 154 +++++++++++++++++++++++--------
 include/uapi/rdma/rdma_netlink.h |   3 +
 2 files changed, 121 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 67519730b1ac..d9443983efdc 100644
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
@@ -2046,49 +2048,90 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
-static int stat_get_doit_default_counter(struct sk_buff *skb,
-					 struct nlmsghdr *nlh,
-					 struct netlink_ext_ack *extack,
-					 struct nlattr *tb[])
+static int stat_get_doit_stats_list(struct sk_buff *skb,
+				    struct nlmsghdr *nlh,
+				    struct netlink_ext_ack *extack,
+				    struct nlattr *tb[],
+				    struct ib_device *device, u32 port,
+				    struct rdma_hw_stats *stats)
 {
-	struct rdma_hw_stats *stats;
-	struct nlattr *table_attr;
-	struct ib_device *device;
-	int ret, num_cnts, i;
+	struct nlattr *table, *entry;
 	struct sk_buff *msg;
-	u32 index, port;
-	u64 v;
+	int i;
 
-	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
-		return -EINVAL;
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
 
-	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = ib_device_get_by_index(sock_net(skb->sk), index);
-	if (!device)
-		return -EINVAL;
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_GET), 0, 0);
 
-	if (!device->ops.alloc_hw_port_stats || !device->ops.get_hw_stats) {
-		ret = -EINVAL;
-		goto err;
-	}
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port))
+		goto err_msg;
 
-	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	stats = ib_get_hw_stats_port(device, port);
-	if (!stats) {
-		ret = -EINVAL;
-		goto err;
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
 	}
+	mutex_unlock(&stats->lock);
+
+	nla_nest_end(msg, table);
+	nlmsg_end(msg, nlh);
+	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
+
+err_msg_entry:
+	nla_nest_cancel(msg, entry);
+err_msg_table:
+	mutex_unlock(&stats->lock);
+	nla_nest_cancel(msg, table);
+err_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+static int stat_get_doit_stats_values(struct sk_buff *skb, struct nlmsghdr *nlh,
+				      struct netlink_ext_ack *extack,
+				      struct nlattr *tb[],
+				      struct ib_device *device, u32 port,
+				      struct rdma_hw_stats *stats)
+{
+	struct nlattr *table_attr;
+	int ret, num_cnts, i;
+	struct sk_buff *msg;
+	u64 v;
+
+	if (!device->ops.alloc_hw_port_stats || !device->ops.get_hw_stats)
+		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!msg)
+		return -ENOMEM;
 
-	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
-					 RDMA_NLDEV_CMD_STAT_GET),
-			0, 0);
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_GET), 0, 0);
 
 	if (fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
@@ -2098,7 +2141,8 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 
 	mutex_lock(&stats->lock);
 
-	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
+	num_cnts = device->ops.get_hw_stats(device, stats, port,
+					    stats->num_counters);
 	if (num_cnts < 0) {
 		ret = -EINVAL;
 		goto err_stats;
@@ -2125,7 +2169,6 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 
 	mutex_unlock(&stats->lock);
 	nlmsg_end(msg, nlh);
-	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
 err_table:
@@ -2134,7 +2177,46 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 	mutex_unlock(&stats->lock);
 err_msg:
 	nlmsg_free(msg);
-err:
+	return ret;
+}
+
+static int stat_get_doit_default_counter(struct sk_buff *skb,
+					 struct nlmsghdr *nlh,
+					 struct netlink_ext_ack *extack,
+					 struct nlattr *tb[])
+{
+	struct rdma_hw_stats *stats;
+	struct ib_device *device;
+	u32 index, port;
+	int ret;
+
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
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
+		goto end;
+	}
+
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
+		ret = stat_get_doit_stats_list(skb, nlh, extack, tb,
+					       device, port, stats);
+	else
+		ret = stat_get_doit_stats_values(skb, nlh, extack, tb, device,
+						 port, stats);
+end:
 	ib_device_put(device);
 	return ret;
 }
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 75a1ae2311d8..2017970279ed 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -549,6 +549,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.31.1

