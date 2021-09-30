Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B141D523
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348980AbhI3IGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348976AbhI3IFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09150617E5;
        Thu, 30 Sep 2021 08:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988998;
        bh=t/AsPHEMF54UA1pivQhB1Pn10/GqZeXwfh1mJ1DtMMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoGnF6Xthlv02jt+j3j4T0gWAQ62ebzAQ6buxHIMFNFUhByjt3HtD8Fm67axLj/gU
         MBaURha78AiHSvRNYzzakN4r7ZdA2mWAs7p6UtLmjlcdH2tGWB4oxMZjxOq/OQyAx2
         xusVTONVKDnOzx3fUdNiVWbbQdKStHmLDUPDnTn66lZLOstMCeDa7w12ZNeOu31yaU
         Y+NpDnWAvhsYYnKdW4DD9lWSvYZ7QQHK5eMJIPXmyiCgiJI2fY7UfrHrkFjKIHGWaN
         DSweJXcUqZqj5XtgU/0qBv3NIf02KLos2soUvPy0KU8CoES2FIE61BqhllePMnUskD
         Ka0rr0foVX/4Q==
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
Subject: [PATCH rdma-next v2 13/13] RDMA/nldev: Add support to get status of all counters
Date:   Thu, 30 Sep 2021 11:02:29 +0300
Message-Id: <e4f07e8ff4c79eabc12fd8cd859deb7b3c6391f0.1632988543.git.leonro@nvidia.com>
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
 drivers/infiniband/core/nldev.c | 152 ++++++++++++++++++++++++--------
 1 file changed, 116 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 2cf3e85470c4..adbddb07b08e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2109,49 +2109,90 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -2161,7 +2202,8 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 
 	mutex_lock(&stats->lock);
 
-	num_cnts = device->ops.get_hw_stats(device, stats, port, 0);
+	num_cnts = device->ops.get_hw_stats(device, stats, port,
+					    stats->num_counters);
 	if (num_cnts < 0) {
 		ret = -EINVAL;
 		goto err_stats;
@@ -2188,7 +2230,6 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 
 	mutex_unlock(&stats->lock);
 	nlmsg_end(msg, nlh);
-	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
 err_table:
@@ -2197,7 +2238,46 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
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
-- 
2.31.1

