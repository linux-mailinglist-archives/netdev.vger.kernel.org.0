Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9260DDDE7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfD2If0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbfD2IfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:24 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9F820578;
        Mon, 29 Apr 2019 08:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526924;
        bh=b9BLP3nkyRd9hAhpF+jey9d/bl9V/yuJ63PdOvpc2DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLh9DOrUGF++8+NcPy6pIv2ZZSTAbVLi2GfD1Z4tc/bu+qsGArujtM5dqQnquEDQ3
         AkfZIziaNv5F/cTTzMyIJH1I66zCWdkOJVIbPjaltTShjwg1TkmxKxV284zIG/+ugb
         DmYlZgRUnAR7P1iGWd/qBeBXvOMjvFH/N4ZFr2Yk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 03/17] RDMA/restrack: Add an API to attach a task to a resource
Date:   Mon, 29 Apr 2019 11:34:39 +0300
Message-Id: <20190429083453.16654-4-leon@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429083453.16654-1-leon@kernel.org>
References: <20190429083453.16654-1-leon@kernel.org>
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

