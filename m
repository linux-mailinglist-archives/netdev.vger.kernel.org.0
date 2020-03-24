Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2819056F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCXGCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCXGCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 02:02:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B529F2073E;
        Tue, 24 Mar 2020 06:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585029730;
        bh=jV9uB3rOUHRNtxDqdExIzn+8r9drvMyPyIpgIIN4sOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTpWo3GAWgd0GlIEY/11l8Z+Iad2oYF1g/qNZ0zVKXcJQASt7AwT6yX4Nn+X4q00S
         DHgvYIDbrYL26LiRF29SVq+qUk0Ko7JyJj/tRJfCqQ5nbP6AVcP7sH/FcB9SZUGnC6
         l8AH9UwZJwh/LFqNAv44eLXo4pB194nVqoFWpoaA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v1 4/5] IB/mlx5: Limit the scope of struct mlx5_bfreg_info to mlx5_ib
Date:   Tue, 24 Mar 2020 08:01:42 +0200
Message-Id: <20200324060143.1569116-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324060143.1569116-1-leon@kernel.org>
References: <20200324060143.1569116-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

struct mlx5_bfreg_info is used by mlx5_ib only but is exposed to both
RDMA and netdev parts of mlx5 driver. Move that struct to mlx5_ib
namespace, clean vertical space alignment and convert lib_uar_4k
from bool to bitfield.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 17 +++++++++++++++++
 include/linux/mlx5/driver.h          | 17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 370b03db366b..e26ba6c390ad 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -128,6 +128,23 @@ enum mlx5_ib_mmap_type {
 	MLX5_IB_MMAP_TYPE_UAR_NC = 4,
 };
 
+struct mlx5_bfreg_info {
+	u32 *sys_pages;
+	int num_low_latency_bfregs;
+	unsigned int *count;
+
+	/*
+	 * protect bfreg allocation data structs
+	 */
+	struct mutex lock;
+	u32 ver;
+	u8 lib_uar_4k : 1;
+	u32 num_sys_pages;
+	u32 num_static_sys_pages;
+	u32 total_num_bfregs;
+	u32 num_dyn_bfregs;
+};
+
 struct mlx5_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct list_head	db_page_list;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3f10a9633012..6ef3e4368550 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -213,23 +213,6 @@ enum mlx5_port_status {
 	MLX5_PORT_DOWN      = 2,
 };
 
-struct mlx5_bfreg_info {
-	u32		       *sys_pages;
-	int			num_low_latency_bfregs;
-	unsigned int	       *count;
-
-	/*
-	 * protect bfreg allocation data structs
-	 */
-	struct mutex		lock;
-	u32			ver;
-	bool			lib_uar_4k;
-	u32			num_sys_pages;
-	u32			num_static_sys_pages;
-	u32			total_num_bfregs;
-	u32			num_dyn_bfregs;
-};
-
 struct mlx5_cmd_first {
 	__be32		data[4];
 };
-- 
2.24.1

