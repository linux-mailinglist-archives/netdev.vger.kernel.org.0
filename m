Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5102F41D511
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349126AbhI3IGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348964AbhI3IEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0845061881;
        Thu, 30 Sep 2021 08:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988978;
        bh=/RsiXDMQCw0J53DuZDPfUktxOsC5bY57rDIlwWJLA8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9JscHnrEHhTpeSqLR6VmBC/lSKwg8AJKrTyWbJ/BgIqnAdfuQI4SeHU8ig4HKnpN
         0p3WOM7fEYZDPGRvxPQCIZcTuCQ20epdbD+AXorEn1Pi4Pztf031PaKjzlxHNZJxQK
         A7rha+FYnhQIaNEUPjRjY5Yd+XTNUk9+sbML5fvmTFfnKFWabjgesSwldQbLAQtC/W
         bAkchTb9b3mXvpL44m37zq2qZfLCK7Sn+HyZq6l2FNTKUOr56y0SUSkJMdVYngr/eb
         aB7KTw9iAvJ3ayFucUrI3uiU6aDByD3GTEHoHby5H3mEGADo4HnKIBEL5vQLxUICRl
         8e7sk1CZgukMg==
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
Subject: [PATCH rdma-next v2 08/13] RDMA/nldev: Allow optional-counter status configuration through RDMA netlink
Date:   Thu, 30 Sep 2021 11:02:24 +0300
Message-Id: <7adfe2abf1f5403c54036ca1b0d9478f4e39ed6c.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Provide an option to allow users to enable/disable optional counters
through RDMA netlink. Limiting it to users with ADMIN capability only.

Examples:
1. Enable optional counters cc_rx_ce_pkts and cc_rx_cnp_pkts (and
   disable all others):
$ sudo rdma statistic set link rocep8s0f0/1 optional-counters \
    cc_rx_ce_pkts,cc_rx_cnp_pkts

2. Remove all optional counters:
$ sudo rdma statistic unset link rocep8s0f0/1 optional-counters

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 121 ++++++++++++++++++++++++--------
 1 file changed, 91 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 210057fef7bd..2cf3e85470c4 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1897,42 +1897,68 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-			       struct netlink_ext_ack *extack)
+static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
+					       struct ib_device *device,
+					       u32 port)
 {
-	u32 index, port, mode, mask = 0, qpn, cntn = 0;
-	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
-	struct ib_device *device;
-	struct sk_buff *msg;
-	int ret;
+	struct rdma_hw_stats *stats;
+	int rem, i, index, ret = 0;
+	struct nlattr *entry_attr;
+	unsigned long *target;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
-	/* Currently only counter for QP is supported */
-	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats)
 		return -EINVAL;
 
-	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
-		return -EINVAL;
+	target = kcalloc(BITS_TO_LONGS(stats->num_counters),
+		       sizeof(long), GFP_KERNEL);
+	if (!target)
+		return -ENOMEM;
 
-	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = ib_device_get_by_index(sock_net(skb->sk), index);
-	if (!device)
-		return -EINVAL;
+	nla_for_each_nested(entry_attr,
+			    tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], rem) {
+		index = nla_get_u32(entry_attr);
+		if ((index >= stats->num_counters) ||
+		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	if (!rdma_is_port_valid(device, port)) {
-		ret = -EINVAL;
-		goto err;
+		set_bit(index, target);
 	}
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		ret = -ENOMEM;
-		goto err;
+	for (i = 0; i < stats->num_counters; i++) {
+		if (!(stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL))
+			continue;
+
+		ret = rdma_counter_modify(device, port, i,
+					  test_bit(i, target));
+		if (ret)
+			goto out;
 	}
+
+out:
+	kfree(target);
+	return ret;
+}
+
+static int nldev_stat_set_mode_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+				    struct netlink_ext_ack *extack,
+				    struct nlattr *tb[],
+				    struct ib_device *device, u32 port)
+{
+	u32 mode, mask = 0, qpn, cntn = 0;
+	struct sk_buff *msg;
+	int ret;
+
+	/* Currently only counter for QP is supported */
+	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
@@ -1947,8 +1973,10 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (ret)
 			goto err_msg;
 	} else {
-		if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
+		if (!tb[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			ret = -EINVAL;
 			goto err_msg;
+		}
 		qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
 		if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
 			cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
@@ -1970,14 +1998,47 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nlmsg_end(msg, nlh);
-	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
 err_fill:
 	rdma_counter_unbind_qpn(device, port, qpn, cntn);
 err_msg:
 	nlmsg_free(msg);
-err:
+	return ret;
+}
+
+static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	u32 index, port;
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
+			  extack);
+	if (ret)
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
+	if (tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		ret = nldev_stat_set_mode_doit(skb, nlh, extack, tb, device,
+					       port);
+	else if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
+		ret = nldev_stat_set_counter_dynamic_doit(tb, device, port);
+	else
+		ret = -EINVAL;
+end:
 	ib_device_put(device);
 	return ret;
 }
-- 
2.31.1

