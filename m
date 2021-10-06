Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31005423AFF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhJFJyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238165AbhJFJyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3938461058;
        Wed,  6 Oct 2021 09:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513966;
        bh=c/Hp1N0fXhCQLZcsxZq3xVU0V8NBCDaxYzuDs/sA90w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+K9PRGDpNMZVcj3TJl/zSc26hDLqLpGgoEjptLbqug6zlf8/17B7W9zXlq0swn/x
         9eP1keUiP+8rn44D8G07OOrSUNC4kCRoVJuZ1g+GxtYXYqISO4hCeZxx6BpYn86IKx
         vooKmLk7qKLiabDaO7nERjvkZz5LfQOcMFWZiGkAuDNoYmm+Yj4auMcRJc0cD5U8s/
         TVDPtG26RdYWwXvMp8oXqDHkuFEQ7tMJs/rI8GN3DDHT7rkL1tBx7ZgbC8AkHrNIE2
         fYbaWgBghqKCS0RZc8ZSHM3x/VOnj3UNhIsXDrxXtT1KG+2HhZUm+lplmjmkVHI248
         1/Jd3aSASbFVQ==
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
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v3 08/13] RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
Date:   Wed,  6 Oct 2021 12:52:11 +0300
Message-Id: <626a54dc0d9a11ab0bdb59ea18c1e0ed9479d538.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633513239.git.leonro@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

In order to allow expansion of the set command with more set options,
take the set mode out of the main set function.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 74 ++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 210057fef7bd..bbe3dfca3d98 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1897,42 +1897,23 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-			       struct netlink_ext_ack *extack)
+static int nldev_stat_set_mode_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+				    struct netlink_ext_ack *extack,
+				    struct nlattr *tb[],
+				    struct ib_device *device, u32 port)
 {
-	u32 index, port, mode, mask = 0, qpn, cntn = 0;
-	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
-	struct ib_device *device;
+	u32 mode, mask = 0, qpn, cntn = 0;
 	struct sk_buff *msg;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
 	/* Currently only counter for QP is supported */
-	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
-		return -EINVAL;
-
 	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
 		return -EINVAL;
 
-	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
-	device = ib_device_get_by_index(sock_net(skb->sk), index);
-	if (!device)
-		return -EINVAL;
-
-	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	if (!rdma_is_port_valid(device, port)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
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
@@ -1947,8 +1928,10 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -1970,14 +1953,45 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
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
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = nldev_stat_set_mode_doit(skb, nlh, extack, tb, device, port);
+end:
 	ib_device_put(device);
 	return ret;
 }
-- 
2.31.1

