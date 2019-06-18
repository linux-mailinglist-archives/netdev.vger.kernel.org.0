Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723E64A855
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfFRR1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfFRR1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:27:04 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1430C2084D;
        Tue, 18 Jun 2019 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878823;
        bh=0xfFvIisr6VzDugEWQHKWpQqHTZWS+pSnPXRdvaNH1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp6cTXdpwSerUX2aS64Kxrl8/daq/FOKpndOuvDzpMeKKkd924n7CF+ZhaDuG5ivJ
         xNRriTJvPrSj3/y23QXOhXePuYtqZ+YipAOEwC4nW069lnHKVhIwNAgayTuMY/G0M9
         JDRw6xtKnGSfOyVkL9fFShfzHm/Fc/PeFBy+MTPc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 04/17] RDMA/restrack: Make is_visible_in_pid_ns() as an API
Date:   Tue, 18 Jun 2019 20:26:12 +0300
Message-Id: <20190618172625.13432-5-leon@kernel.org>
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

Remove is_visible_in_pid_ns() from nldev.c and make it as a restrack API,
so that it can be taken advantage by other parts like counter.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c    | 15 ++-------------
 drivers/infiniband/core/restrack.c | 13 +++++++++++++
 drivers/infiniband/core/restrack.h |  1 +
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 69188cbbd99b..39dd9b366629 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -992,17 +992,6 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 	},
 };

-static bool is_visible_in_pid_ns(struct rdma_restrack_entry *res)
-{
-	/*
-	 * 1. Kern resources should be visible in init name space only
-	 * 2. Present only resources visible in the current namespace
-	 */
-	if (rdma_is_kernel_res(res))
-		return task_active_pid_ns(current) == &init_pid_ns;
-	return task_active_pid_ns(current) == task_active_pid_ns(res->task);
-}
-
 static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack,
 			       enum rdma_restrack_type res_type)
@@ -1047,7 +1036,7 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err;
 	}

-	if (!is_visible_in_pid_ns(res)) {
+	if (!rdma_is_visible_in_pid_ns(res)) {
 		ret = -ENOENT;
 		goto err_get;
 	}
@@ -1159,7 +1148,7 @@ static int res_get_common_dumpit(struct sk_buff *skb,
 	 * objects.
 	 */
 	xa_for_each(&rt->xa, id, res) {
-		if (!is_visible_in_pid_ns(res))
+		if (!rdma_is_visible_in_pid_ns(res))
 			continue;

 		if (idx < start || !rdma_restrack_get(res))
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 3714634ae296..bddff426ee0f 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -349,3 +349,16 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	}
 }
 EXPORT_SYMBOL(rdma_restrack_del);
+
+bool rdma_is_visible_in_pid_ns(struct rdma_restrack_entry *res)
+{
+	/*
+	 * 1. Kern resources should be visible in init
+	 *    namespace only
+	 * 2. Present only resources visible in the current
+	 *     namespace
+	 */
+	if (rdma_is_kernel_res(res))
+		return task_active_pid_ns(current) == &init_pid_ns;
+	return task_active_pid_ns(current) == task_active_pid_ns(res->task);
+}
diff --git a/drivers/infiniband/core/restrack.h b/drivers/infiniband/core/restrack.h
index d084e5f89849..7bd177cc0a61 100644
--- a/drivers/infiniband/core/restrack.h
+++ b/drivers/infiniband/core/restrack.h
@@ -27,4 +27,5 @@ int rdma_restrack_init(struct ib_device *dev);
 void rdma_restrack_clean(struct ib_device *dev);
 void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
 			       struct task_struct *task);
+bool rdma_is_visible_in_pid_ns(struct rdma_restrack_entry *res);
 #endif /* _RDMA_CORE_RESTRACK_H_ */
--
2.20.1

