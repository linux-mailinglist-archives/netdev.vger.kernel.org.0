Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B0E2685EC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgINHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgINHao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E5CC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so11874326pfd.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XXizVLnnCAMpy1Y8Am6LnTqq0mhfOY4oFtTo6V5UAYw=;
        b=sY/uTEm8nhjmKgziCOyquMPM7ziNYZKzc2Diq57bTr1dqRKkNXXG2hv0XV/5djtXco
         385VAVuiYz5mJCXDE/qjoF8nKzIT4XueIA4/d4UJdhzgVi/CgXlGOnK3PJio/+GCBtj1
         X4lpClGsYqXt129jjr1+aenu8ND3T9dVNEIeY0ChNCcG2DS+G5QWX6rXMP0l50xn9scq
         G+8te4tF9q0NGUd3glcygFhwXlHiNVdnweHtXkvdYlex1L1tqKBaT9FSEdG2gXSw3w6a
         63vyouR3Rfaof5zgEO95hy4kFHo7tmoT9T1zg5pDcUt2JarMQULj5CnQO2K20XrJ8WKj
         btPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXizVLnnCAMpy1Y8Am6LnTqq0mhfOY4oFtTo6V5UAYw=;
        b=cgWTiBB3+q1iAKOG7h3kU6reHoti7u7t7n3D+HDCphbKCvgQKvYs7l84014x0mgMnS
         YNit5gHwzHFH6/4mTJa1hkNLeJjkYtle1Z9eeWRYBfkeAfK3SXnIgc9Z+fOfIXYk8Ynz
         ZfQ4ZD032ICq1qA6Wz4R176C4mjwjEKtYXfscaH1xenc9GSgtRkCNaYP4fcxRofHYhbH
         Rj/XCh78oGEiDf8FOja4SqpybKFP1/yLVaD6L6ZRkvGT4PqgE5EHCo/L5uIWv4MwXz5F
         cWc92rNvBV3EO6t2xOYJHH+RDVoR3L3whjLM2u3A01YUxJZyvj1HYCOFouPHO0NLGnoN
         Ta3A==
X-Gm-Message-State: AOAM533ohJzgAXVueUD9vKepe7P93VUvqLkPdplWzj3I1hNc2YPegH2q
        dOAjdIkf438cohzfeCgJIb8=
X-Google-Smtp-Source: ABdhPJz7ZzIRpt/hYc6Xx3veUyLGVLKOKK7l01+dClmbCMwZNKU77vcRspsbM1G0wVmXvcGCIxGp1A==
X-Received: by 2002:a17:902:522:b029:d1:9bc8:15df with SMTP id 31-20020a1709020522b02900d19bc815dfmr13736513plf.25.1600068643356;
        Mon, 14 Sep 2020 00:30:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:42 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 13/20] net: mlx: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:32 +0530
Message-Id: <20200914072939.803280-14-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c             |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/eq.c             |  3 +--
 drivers/net/ethernet/mellanox/mlx4/mlx4.h           |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c        |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c        |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c |  7 +++----
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c           | 12 ++++++------
 8 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 65f8a4b6ed0c..3b8576b9c2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -55,11 +55,11 @@
 #define TASKLET_MAX_TIME 2
 #define TASKLET_MAX_TIME_JIFFIES msecs_to_jiffies(TASKLET_MAX_TIME)
 
-void mlx4_cq_tasklet_cb(unsigned long data)
+void mlx4_cq_tasklet_cb(struct tasklet_struct *t)
 {
 	unsigned long flags;
 	unsigned long end = jiffies + TASKLET_MAX_TIME_JIFFIES;
-	struct mlx4_eq_tasklet *ctx = (struct mlx4_eq_tasklet *)data;
+	struct mlx4_eq_tasklet *ctx = from_tasklet(ctx, t, task);
 	struct mlx4_cq *mcq, *temp;
 
 	spin_lock_irqsave(&ctx->lock, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index ae305c2e9225..9e48509ed3b2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -1057,8 +1057,7 @@ static int mlx4_create_eq(struct mlx4_dev *dev, int nent,
 	INIT_LIST_HEAD(&eq->tasklet_ctx.list);
 	INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
 	spin_lock_init(&eq->tasklet_ctx.lock);
-	tasklet_init(&eq->tasklet_ctx.task, mlx4_cq_tasklet_cb,
-		     (unsigned long)&eq->tasklet_ctx);
+	tasklet_setup(&eq->tasklet_ctx.task, mlx4_cq_tasklet_cb);
 
 	return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 527b52e48276..64bed7ac3836 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1217,7 +1217,7 @@ void mlx4_cmd_use_polling(struct mlx4_dev *dev);
 int mlx4_comm_cmd(struct mlx4_dev *dev, u8 cmd, u16 param,
 		  u16 op, unsigned long timeout);
 
-void mlx4_cq_tasklet_cb(unsigned long data);
+void mlx4_cq_tasklet_cb(struct tasklet_struct *t);
 void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn);
 void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 8379b24cb838..df3e4938ecdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -42,11 +42,11 @@
 #define TASKLET_MAX_TIME 2
 #define TASKLET_MAX_TIME_JIFFIES msecs_to_jiffies(TASKLET_MAX_TIME)
 
-void mlx5_cq_tasklet_cb(unsigned long data)
+void mlx5_cq_tasklet_cb(struct tasklet_struct *t)
 {
 	unsigned long flags;
 	unsigned long end = jiffies + TASKLET_MAX_TIME_JIFFIES;
-	struct mlx5_eq_tasklet *ctx = (struct mlx5_eq_tasklet *)data;
+	struct mlx5_eq_tasklet *ctx = from_tasklet(ctx, t, task);
 	struct mlx5_core_cq *mcq;
 	struct mlx5_core_cq *temp;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 31ef9f8420c8..ec38405d467f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -788,8 +788,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		INIT_LIST_HEAD(&eq->tasklet_ctx.list);
 		INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
 		spin_lock_init(&eq->tasklet_ctx.lock);
-		tasklet_init(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb,
-			     (unsigned long)&eq->tasklet_ctx);
+		tasklet_setup(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb);
 
 		eq->irq_nb.notifier_call = mlx5_eq_comp_int;
 		param = (struct mlx5_eq_param) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 831d2c39e153..9f6d97eae0ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -388,9 +388,9 @@ static inline void mlx5_fpga_conn_cqes(struct mlx5_fpga_conn *conn,
 	mlx5_fpga_conn_arm_cq(conn);
 }
 
-static void mlx5_fpga_conn_cq_tasklet(unsigned long data)
+static void mlx5_fpga_conn_cq_tasklet(struct tasklet_struct *t)
 {
-	struct mlx5_fpga_conn *conn = (void *)data;
+	struct mlx5_fpga_conn *conn = from_tasklet(conn, t, cq.tasklet);
 
 	if (unlikely(!conn->qp.active))
 		return;
@@ -478,8 +478,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
 	conn->cq.mcq.irqn       = irqn;
 	conn->cq.mcq.uar        = fdev->conn_res.uar;
-	tasklet_init(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet,
-		     (unsigned long)conn);
+	tasklet_setup(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet);
 
 	mlx5_fpga_dbg(fdev, "Created CQ #0x%x\n", conn->cq.mcq.cqn);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4aaca7400fb2..078a7cc29bf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -77,7 +77,7 @@ int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn);
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
-void mlx5_cq_tasklet_cb(unsigned long data);
+void mlx5_cq_tasklet_cb(struct tasklet_struct *t);
 struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
 
 u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 1c64b03ff48e..641cdd81882b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -620,9 +620,9 @@ static char *mlxsw_pci_cq_sw_cqe_get(struct mlxsw_pci_queue *q)
 	return elem;
 }
 
-static void mlxsw_pci_cq_tasklet(unsigned long data)
+static void mlxsw_pci_cq_tasklet(struct tasklet_struct *t)
 {
-	struct mlxsw_pci_queue *q = (struct mlxsw_pci_queue *) data;
+	struct mlxsw_pci_queue *q = from_tasklet(q, t, tasklet);
 	struct mlxsw_pci *mlxsw_pci = q->pci;
 	char *cqe;
 	int items = 0;
@@ -733,9 +733,9 @@ static char *mlxsw_pci_eq_sw_eqe_get(struct mlxsw_pci_queue *q)
 	return elem;
 }
 
-static void mlxsw_pci_eq_tasklet(unsigned long data)
+static void mlxsw_pci_eq_tasklet(struct tasklet_struct *t)
 {
-	struct mlxsw_pci_queue *q = (struct mlxsw_pci_queue *) data;
+	struct mlxsw_pci_queue *q = from_tasklet(q, t, tasklet);
 	struct mlxsw_pci *mlxsw_pci = q->pci;
 	u8 cq_count = mlxsw_pci_cq_count(mlxsw_pci);
 	unsigned long active_cqns[BITS_TO_LONGS(MLXSW_PCI_CQS_MAX)];
@@ -792,7 +792,7 @@ struct mlxsw_pci_queue_ops {
 		    struct mlxsw_pci_queue *q);
 	void (*fini)(struct mlxsw_pci *mlxsw_pci,
 		     struct mlxsw_pci_queue *q);
-	void (*tasklet)(unsigned long data);
+	void (*tasklet)(struct tasklet_struct *t);
 	u16 (*elem_count_f)(const struct mlxsw_pci_queue *q);
 	u8 (*elem_size_f)(const struct mlxsw_pci_queue *q);
 	u16 elem_count;
@@ -855,7 +855,7 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	q->pci = mlxsw_pci;
 
 	if (q_ops->tasklet)
-		tasklet_init(&q->tasklet, q_ops->tasklet, (unsigned long) q);
+		tasklet_setup(&q->tasklet, q_ops->tasklet);
 
 	mem_item->size = MLXSW_PCI_AQ_SIZE;
 	mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
-- 
2.25.1

