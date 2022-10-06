Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152D35F5858
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJEQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJEQdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:33:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1259A7D783;
        Wed,  5 Oct 2022 09:33:11 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="303182113"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="303182113"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 09:33:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="619518107"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="619518107"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2022 09:33:08 -0700
From:   yanjun.zhu@linux.dev
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, yanjun.zhu@linux.dev,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCHv2 3/6] RDMA/nldev: Add dellink function pointer
Date:   Thu,  6 Oct 2022 04:59:18 -0400
Message-Id: <20221006085921.1323148-4-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
References: <20221006085921.1323148-1-yanjun.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

The newlink function pointer is added. And the sock listening on port 4791
is added in the newlink function. So the dellink function is needed to
remove the sock.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/core/nldev.c | 6 ++++++
 include/rdma/rdma_netlink.h     | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index b92358f606d0..ae0db4aced34 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1744,6 +1744,12 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
+	if (device->link_ops) {
+		err = device->link_ops->dellink(device);
+		if (err)
+			return err;
+	}
+
 	ib_unregister_device_and_put(device);
 	return 0;
 }
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index c2a79aeee113..bf9df004061f 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -5,6 +5,7 @@
 
 #include <linux/netlink.h>
 #include <uapi/rdma/rdma_netlink.h>
+#include <rdma/ib_verbs.h>
 
 enum {
 	RDMA_NLDEV_ATTR_EMPTY_STRING = 1,
@@ -114,6 +115,7 @@ struct rdma_link_ops {
 	struct list_head list;
 	const char *type;
 	int (*newlink)(const char *ibdev_name, struct net_device *ndev);
+	int (*dellink)(struct ib_device *dev);
 };
 
 void rdma_link_register(struct rdma_link_ops *ops);
-- 
2.27.0

