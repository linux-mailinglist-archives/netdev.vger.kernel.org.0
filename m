Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57A940BBFC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhINXJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236160AbhINXJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57BD660F46;
        Tue, 14 Sep 2021 23:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660886;
        bh=MF/dxjTtUffh8+OcPsREHYqy7izg2J5B+2RWPBjZjJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWzUffeCJyne/hInhBWlhWtiYPutSuU3Bh983vNngXKQttlMgUTgUihdfZrrUemYc
         b9WPpKpELBrvPehUDNeEUlew6/iDtKygmBroC5GfiEpu5ptgdcwJ6d3AzfH/u35qPk
         eSqsr2/pXcJkJJck248wqmgjE112Mb93wLsIYYMWSHlnJX8Fpz+M/SeccS6OWKf2Yt
         pFV5YkvX4sRiUKHEwiec78m18Kp4ad5K+ABMacncmp8z2AhYS0FBDVp5NbpzPMzmsZ
         zFRjTLeS7lZLd+AKwDIemdgxWSU37g0AZXI/Zey1njYWbBPeA+LTHD2m+OZveJScV8
         S6JVaINL/phPA==
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
Subject: [PATCH rdma-next v1 07/11] RDMA/nldev: Allow optional-counter status configuration through RDMA netlink
Date:   Wed, 15 Sep 2021 02:07:26 +0300
Message-Id: <ed88592c676c5926195a6f89926146acaa466641.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631660727.git.leonro@nvidia.com>
References: <cover.1631660727.git.leonro@nvidia.com>
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
 drivers/infiniband/core/nldev.c | 118 ++++++++++++++++++++++++--------
 1 file changed, 88 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index d9443983efdc..b00e4257823d 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1897,42 +1897,65 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
+	bool need_enable, disabled;
+	struct nlattr *entry_attr;
 
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
+	for (i = 0; i < stats->num_counters; i++) {
+		if (!(stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL))
+			continue;
 
-	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = ib_device_get_by_index(sock_net(skb->sk), index);
-	if (!device)
-		return -EINVAL;
+		need_enable = false;
+		disabled = test_bit(i, stats->is_disabled);
+		nla_for_each_nested(entry_attr,
+				    tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], rem) {
+			index = nla_get_u32(entry_attr);
+			if (index >= stats->num_counters)
+				return -EINVAL;
+			if (i == index) {
+				need_enable = true;
+				break;
+			}
+		}
 
-	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	if (!rdma_is_port_valid(device, port)) {
-		ret = -EINVAL;
-		goto err;
+		if (disabled && need_enable)
+			ret = rdma_counter_modify(device, port, i, true);
+		else if (!disabled && !need_enable)
+			ret = rdma_counter_modify(device, port, i, false);
+
+		if (ret)
+			break;
 	}
 
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
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!msg)
+		return -ENOMEM;
+
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
@@ -1947,8 +1970,10 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -1970,14 +1995,47 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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

