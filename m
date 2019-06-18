Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3EF4A848
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfFRR0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRR0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:26:43 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3495214AF;
        Tue, 18 Jun 2019 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878802;
        bh=IPkvDpk3Zt1F7O3X+3vJA5Wr97gYSFVt8E1eoEhd1hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPCjneSeLoOxR/EYrzhwzGzYQRfHNnbh8MNPE90XROu/WslCRniJBY9xIQwU3/5r2
         2hGeWmnQUQqPnQQixW6Avkg7gN/TZeZXkskFoJSyM5ohddr47umbNv/UbhmP+MZM0g
         naWlpfg3Sve/E/jfp1lh74/7vFAzYja8jdpZrZpE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 03/17] RDMA/restrack: Add an API to attach a task to a resource
Date:   Tue, 18 Jun 2019 20:26:11 +0300
Message-Id: <20190618172625.13432-4-leon@kernel.org>
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

Add rdma_restrack_attach_task() which is able to attach a task
other then "current" to a resource.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/restrack.c | 14 ++++++++++++++
 drivers/infiniband/core/restrack.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 95573f292aae..3714634ae296 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -194,6 +194,20 @@ void rdma_restrack_set_task(struct rdma_restrack_entry *res,
 }
 EXPORT_SYMBOL(rdma_restrack_set_task);

+/**
+ * rdma_restrack_attach_task() - attach the task onto this resource
+ * @res:  resource entry
+ * @task: the task to attach, the current task will be used if it is NULL.
+ */
+void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
+			       struct task_struct *task)
+{
+	if (res->task)
+		put_task_struct(res->task);
+	get_task_struct(task);
+	res->task = task;
+}
+
 static void rdma_restrack_add(struct rdma_restrack_entry *res)
 {
 	struct ib_device *dev = res_to_dev(res);
diff --git a/drivers/infiniband/core/restrack.h b/drivers/infiniband/core/restrack.h
index 09a1fbdf578e..d084e5f89849 100644
--- a/drivers/infiniband/core/restrack.h
+++ b/drivers/infiniband/core/restrack.h
@@ -25,4 +25,6 @@ struct rdma_restrack_root {

 int rdma_restrack_init(struct ib_device *dev);
 void rdma_restrack_clean(struct ib_device *dev);
+void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
+			       struct task_struct *task);
 #endif /* _RDMA_CORE_RESTRACK_H_ */
--
2.20.1

