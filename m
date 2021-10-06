Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB94423B03
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbhJFJy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238129AbhJFJyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF536109F;
        Wed,  6 Oct 2021 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513969;
        bh=QwYA4dmXzXGa9cqAEDIYKY/cjIy+e05/TPJB2IWC2z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKOdAkU0ijJZViYzGQVqIzvWDdisyFOkYouOIJLkak7JXeGcJkxmhPMB4I2oXRRbI
         e1eg5cYx/mLuREhgQTTEKFZv6lQuEPeO+qI50bJYh1t/mC+lQk2z0YLqvZvtNTzvMQ
         ugZXwH5MZorUQopdtZUhqemigfnw/6vMkzLCXIRZr4Pmk/mvun59SOsgVZ2VHe8bnl
         urRch8D6uwcgvIfwPzK/Qf9ZfaNNeC46hbDwWl1YZKBj3qUP0nBVTSK/MyUkxgwXtE
         lq9IrvaKeAmAN0HCFAEsYKhdkm4rN8CudFyF+MPnSnB5ILdcWvT/5DmO5eHyK48UkW
         BQS4y6RNQml9g==
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
Subject: [PATCH rdma-next v3 09/13] RDMA/nldev: Allow optional-counter status configuration through RDMA netlink
Date:   Wed,  6 Oct 2021 12:52:12 +0300
Message-Id: <aa5ae4340e68f1dab351a2b397d777396aff04a9.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633513239.git.leonro@nvidia.com>
References: <cover.1633513239.git.leonro@nvidia.com>
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
 drivers/infiniband/core/nldev.c | 54 ++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index bbe3dfca3d98..7bd4e08268a6 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1962,6 +1962,50 @@ static int nldev_stat_set_mode_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
+					       struct ib_device *device,
+					       u32 port)
+{
+	struct rdma_hw_stats *stats;
+	int rem, i, index, ret = 0;
+	struct nlattr *entry_attr;
+	unsigned long *target;
+
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats)
+		return -EINVAL;
+
+	target = kcalloc(BITS_TO_LONGS(stats->num_counters),
+			 sizeof(*stats->is_disabled), GFP_KERNEL);
+	if (!target)
+		return -ENOMEM;
+
+	nla_for_each_nested(entry_attr, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS],
+			    rem) {
+		index = nla_get_u32(entry_attr);
+		if ((index >= stats->num_counters) ||
+		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		set_bit(index, target);
+	}
+
+	for (i = 0; i < stats->num_counters; i++) {
+		if (!(stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL))
+			continue;
+
+		ret = rdma_counter_modify(device, port, i, test_bit(i, target));
+		if (ret)
+			goto out;
+	}
+
+out:
+	kfree(target);
+	return ret;
+}
+
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
@@ -1986,11 +2030,13 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto end;
 	}
 
-	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+	if (tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		ret = nldev_stat_set_mode_doit(skb, nlh, extack, tb, device,
+					       port);
+	else if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC])
+		ret = nldev_stat_set_counter_dynamic_doit(tb, device, port);
+	else
 		ret = -EINVAL;
-		goto end;
-	}
-	ret = nldev_stat_set_mode_doit(skb, nlh, extack, tb, device, port);
 end:
 	ib_device_put(device);
 	return ret;
-- 
2.31.1

