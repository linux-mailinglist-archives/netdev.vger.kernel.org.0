Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01EC1D0E94
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732963AbgEMJut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387554AbgEMJus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 05:50:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAE020575;
        Wed, 13 May 2020 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363447;
        bh=ZcvPiY6rInQxm8MdEFotpjAJ0VBH7aHR9Rho09RNyIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRzq4ArUXK8Pt5ad5UHVNosiVxrglBb0pYnakTo18g7f6O7o/5z/Tpvhn/yh7GPgl
         WlGHgL+DfVimNhlmQwXbyXRaYfv8trkdacrxVsmVDYtgkYyfeYJNN5alXtdtJ3oick
         wTrs3eVzzwGlU5zpdGk2Dr5Vh9CE7t0ApCxSXMX8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/14] net/mlx5: Export resource dump interface
Date:   Wed, 13 May 2020 12:50:21 +0300
Message-Id: <20200513095034.208385-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513095034.208385-1-leon@kernel.org>
References: <20200513095034.208385-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Export some of the resource dump API, so it could be
used by the mlx5_ib driver as well.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../mellanox/mlx5/core/diag/rsc_dump.c        |  3 ++
 .../mellanox/mlx5/core/diag/rsc_dump.h        | 33 +------------------
 .../diag => include/linux/mlx5}/rsc_dump.h    | 22 ++++---------
 3 files changed, 10 insertions(+), 48 deletions(-)
 copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 17ab7efe693d..10218c2324cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -130,11 +130,13 @@ struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *dev,
 	cmd->mem_size = key->size;
 	return cmd;
 }
+EXPORT_SYMBOL(mlx5_rsc_dump_cmd_create);
 
 void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd)
 {
 	kfree(cmd);
 }
+EXPORT_SYMBOL(mlx5_rsc_dump_cmd_destroy);
 
 int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
 		       struct page *page, int *size)
@@ -155,6 +157,7 @@ int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
 
 	return more_dump;
 }
+EXPORT_SYMBOL(mlx5_rsc_dump_next);
 
 #define MLX5_RSC_DUMP_MENU_SEGMENT 0xffff
 static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
index 148270073e71..64c4956db6d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
@@ -4,41 +4,10 @@
 #ifndef __MLX5_RSC_DUMP_H
 #define __MLX5_RSC_DUMP_H
 
+#include <linux/mlx5/rsc_dump.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
 
-enum mlx5_sgmt_type {
-	MLX5_SGMT_TYPE_HW_CQPC,
-	MLX5_SGMT_TYPE_HW_SQPC,
-	MLX5_SGMT_TYPE_HW_RQPC,
-	MLX5_SGMT_TYPE_FULL_SRQC,
-	MLX5_SGMT_TYPE_FULL_CQC,
-	MLX5_SGMT_TYPE_FULL_EQC,
-	MLX5_SGMT_TYPE_FULL_QPC,
-	MLX5_SGMT_TYPE_SND_BUFF,
-	MLX5_SGMT_TYPE_RCV_BUFF,
-	MLX5_SGMT_TYPE_SRQ_BUFF,
-	MLX5_SGMT_TYPE_CQ_BUFF,
-	MLX5_SGMT_TYPE_EQ_BUFF,
-	MLX5_SGMT_TYPE_SX_SLICE,
-	MLX5_SGMT_TYPE_SX_SLICE_ALL,
-	MLX5_SGMT_TYPE_RDB,
-	MLX5_SGMT_TYPE_RX_SLICE_ALL,
-	MLX5_SGMT_TYPE_MENU,
-	MLX5_SGMT_TYPE_TERMINATE,
-
-	MLX5_SGMT_TYPE_NUM, /* Keep last */
-};
-
-struct mlx5_rsc_key {
-	enum mlx5_sgmt_type rsc;
-	int index1;
-	int index2;
-	int num_of_obj1;
-	int num_of_obj2;
-	int size;
-};
-
 #define MLX5_RSC_DUMP_ALL 0xFFFF
 struct mlx5_rsc_dump_cmd;
 struct mlx5_rsc_dump;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h b/include/linux/mlx5/rsc_dump.h
similarity index 68%
copy from drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
copy to include/linux/mlx5/rsc_dump.h
index 148270073e71..87415fa754fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
+++ b/include/linux/mlx5/rsc_dump.h
@@ -1,11 +1,10 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-#ifndef __MLX5_RSC_DUMP_H
-#define __MLX5_RSC_DUMP_H
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies inc. */
 
 #include <linux/mlx5/driver.h>
-#include "mlx5_core.h"
+
+#ifndef __MLX5_RSC_DUMP
+#define __MLX5_RSC_DUMP
 
 enum mlx5_sgmt_type {
 	MLX5_SGMT_TYPE_HW_CQPC,
@@ -39,20 +38,11 @@ struct mlx5_rsc_key {
 	int size;
 };
 
-#define MLX5_RSC_DUMP_ALL 0xFFFF
 struct mlx5_rsc_dump_cmd;
-struct mlx5_rsc_dump;
-
-struct mlx5_rsc_dump *mlx5_rsc_dump_create(struct mlx5_core_dev *dev);
-void mlx5_rsc_dump_destroy(struct mlx5_core_dev *dev);
-
-int mlx5_rsc_dump_init(struct mlx5_core_dev *dev);
-void mlx5_rsc_dump_cleanup(struct mlx5_core_dev *dev);
 
 struct mlx5_rsc_dump_cmd *mlx5_rsc_dump_cmd_create(struct mlx5_core_dev *dev,
 						   struct mlx5_rsc_key *key);
 void mlx5_rsc_dump_cmd_destroy(struct mlx5_rsc_dump_cmd *cmd);
-
 int mlx5_rsc_dump_next(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
 		       struct page *page, int *size);
-#endif
+#endif /* __MLX5_RSC_DUMP */
-- 
2.26.2

