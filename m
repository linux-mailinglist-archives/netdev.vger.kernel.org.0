Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678704A846
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfFRR0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRR0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:26:39 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7F12084D;
        Tue, 18 Jun 2019 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878799;
        bh=FlXMLFK0+zHvFvTZjCaRF1CYrNw8Eu//ZekR79m44jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PM/VJGEIr4qtgJXylLPyCq1MkpzCfDDJ8KBtEkHILPf7ik90ThyFcoD4ql7mDUiVN
         5niLZWHjbSMXvTSmfy5UnvwMifBGpB6HaPJao5PqhMyWQuUNOvwBNtymkpcyomQtqf
         0BaITgU5QnNz/4jYGfjbMTq1CmVJGtx0vadN9kHA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v4 02/17] RDMA/restrack: Introduce statistic counter
Date:   Tue, 18 Jun 2019 20:26:10 +0300
Message-Id: <20190618172625.13432-3-leon@kernel.org>
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

Introduce statistic counter as a new resource. It allows a user
to monitor specific objects (e.g., QPs) by binding to a counter.

In some cases a user counter resource is created with task other then
"current", because its creation is done as part of rdmatool call.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/restrack.c | 22 +++++++++++++++++-----
 include/rdma/rdma_counter.h        | 18 ++++++++++++++++++
 include/rdma/restrack.h            |  4 ++++
 3 files changed, 39 insertions(+), 5 deletions(-)
 create mode 100644 include/rdma/rdma_counter.h

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 3b5ff2f7b5f8..95573f292aae 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -6,6 +6,7 @@
 #include <rdma/rdma_cm.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/restrack.h>
+#include <rdma/rdma_counter.h>
 #include <linux/mutex.h>
 #include <linux/sched/task.h>
 #include <linux/pid_namespace.h>
@@ -45,6 +46,7 @@ static const char *type2str(enum rdma_restrack_type type)
 		[RDMA_RESTRACK_CM_ID] = "CM_ID",
 		[RDMA_RESTRACK_MR] = "MR",
 		[RDMA_RESTRACK_CTX] = "CTX",
+		[RDMA_RESTRACK_COUNTER] = "COUNTER",
 	};

 	return names[type];
@@ -169,6 +171,8 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 		return container_of(res, struct ib_mr, res)->device;
 	case RDMA_RESTRACK_CTX:
 		return container_of(res, struct ib_ucontext, res)->device;
+	case RDMA_RESTRACK_COUNTER:
+		return container_of(res, struct rdma_counter, res)->device;
 	default:
 		WARN_ONCE(true, "Wrong resource tracking type %u\n", res->type);
 		return NULL;
@@ -203,15 +207,22 @@ static void rdma_restrack_add(struct rdma_restrack_entry *res)

 	kref_init(&res->kref);
 	init_completion(&res->comp);
-	if (res->type != RDMA_RESTRACK_QP)
-		ret = xa_alloc_cyclic(&rt->xa, &res->id, res, xa_limit_32b,
-				&rt->next_id, GFP_KERNEL);
-	else {
+	if (res->type == RDMA_RESTRACK_QP) {
 		/* Special case to ensure that LQPN points to right QP */
 		struct ib_qp *qp = container_of(res, struct ib_qp, res);

 		ret = xa_insert(&rt->xa, qp->qp_num, res, GFP_KERNEL);
 		res->id = ret ? 0 : qp->qp_num;
+	} else if (res->type == RDMA_RESTRACK_COUNTER) {
+		/* Special case to ensure that cntn points to right counter */
+		struct rdma_counter *counter;
+
+		counter = container_of(res, struct rdma_counter, res);
+		ret = xa_insert(&rt->xa, counter->id, res, GFP_KERNEL);
+		res->id = ret ? 0 : counter->id;
+	} else {
+		ret = xa_alloc_cyclic(&rt->xa, &res->id, res, xa_limit_32b,
+				      &rt->next_id, GFP_KERNEL);
 	}

 	if (!ret)
@@ -237,7 +248,8 @@ EXPORT_SYMBOL(rdma_restrack_kadd);
  */
 void rdma_restrack_uadd(struct rdma_restrack_entry *res)
 {
-	if (res->type != RDMA_RESTRACK_CM_ID)
+	if ((res->type != RDMA_RESTRACK_CM_ID) &&
+	    (res->type != RDMA_RESTRACK_COUNTER))
 		res->task = NULL;

 	if (!res->task)
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
new file mode 100644
index 000000000000..283ac1a0cdb7
--- /dev/null
+++ b/include/rdma/rdma_counter.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2019 Mellanox Technologies. All rights reserved.
+ */
+
+#ifndef _RDMA_COUNTER_H_
+#define _RDMA_COUNTER_H_
+
+#include <rdma/ib_verbs.h>
+#include <rdma/restrack.h>
+
+struct rdma_counter {
+	struct rdma_restrack_entry	res;
+	struct ib_device		*device;
+	uint32_t			id;
+	u8				port;
+};
+#endif /* _RDMA_COUNTER_H_ */
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
index ecf3c7702a4f..4041a4d96524 100644
--- a/include/rdma/restrack.h
+++ b/include/rdma/restrack.h
@@ -42,6 +42,10 @@ enum rdma_restrack_type {
 	 * @RDMA_RESTRACK_CTX: Verbs contexts (CTX)
 	 */
 	RDMA_RESTRACK_CTX,
+	/**
+	 * @RDMA_RESTRACK_COUNTER: Statistic Counter
+	 */
+	RDMA_RESTRACK_COUNTER,
 	/**
 	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
 	 */
--
2.20.1

