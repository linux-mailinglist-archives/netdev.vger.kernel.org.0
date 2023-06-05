Return-Path: <netdev+bounces-7951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BF7722325
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DDE91C20B77
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC05156EE;
	Mon,  5 Jun 2023 10:14:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377C4168A2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0B0C4339C;
	Mon,  5 Jun 2023 10:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685960055;
	bh=qm6MedU5NkwL9B9WtLNrnQbOBGPrlm1J4Z/H1eepMzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAOLb4xoT3cDCwlstfGfNQU0u1f2bveN1LLHsfojbHcZx7EIVxk9jg0fnHzvZ6Gst
	 aApjbDwFuyepTarS3Unh/oaUFf3Iv3tHAhTckOjpsrunP0Iy2RH/FXarG/xrCy5zbo
	 ghKVDxy1MjKnKUMyR4RPFBYYk4YGXfcRdONx+zOv1YvALNwxrBX68su6W71++35RZY
	 8ad6A/axoGaM/twiOjuxzZKJxoFyLmWST9rGeuj9KBYwVkJADiRd9x+qfD+fZM6HYI
	 QHq7EyEpc8EE4jw0zt6jS1k00ckyuCo5oicU/YG54jZplOR5CPGSTFVnv1UwWEQGCy
	 m2QUdASVX8Lew==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v2 2/4] RDMA/mlx5: Reduce QP table exposure
Date: Mon,  5 Jun 2023 13:14:05 +0300
Message-Id: <bec0dc1158e795813b135d1143147977f26bf668.1685953497.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685953497.git.leon@kernel.org>
References: <cover.1685953497.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

driver.h is common header to whole mlx5 code base, but struct
mlx5_qp_table is used in mlx5_ib driver only. So move that struct
to be under sole responsibility of mlx5_ib.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.h      | 11 ++++++++++-
 include/linux/mlx5/driver.h          |  9 ---------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index fe5e23a06735..1eefefdaa009 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -25,6 +25,7 @@
 #include <rdma/mlx5_user_ioctl_verbs.h>
 
 #include "srq.h"
+#include "qp.h"
 
 #define mlx5_ib_dbg(_dev, format, arg...)                                      \
 	dev_dbg(&(_dev)->ib_dev.dev, "%s:%d:(pid %d): " format, __func__,      \
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index 77f9b4a54816..f5130873dd52 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -6,7 +6,16 @@
 #ifndef _MLX5_IB_QP_H
 #define _MLX5_IB_QP_H
 
-#include "mlx5_ib.h"
+struct mlx5_ib_dev;
+
+struct mlx5_qp_table {
+	struct notifier_block nb;
+
+	/* protect radix tree
+	 */
+	spinlock_t lock;
+	struct radix_tree_root tree;
+};
 
 int mlx5_init_qp_table(struct mlx5_ib_dev *dev);
 void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a4c4f737f9c1..e3b616388b18 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -443,15 +443,6 @@ struct mlx5_core_health {
 	struct delayed_work		update_fw_log_ts_work;
 };
 
-struct mlx5_qp_table {
-	struct notifier_block   nb;
-
-	/* protect radix tree
-	 */
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
-};
-
 enum {
 	MLX5_PF_NOTIFY_DISABLE_VF,
 	MLX5_PF_NOTIFY_ENABLE_VF,
-- 
2.40.1


