Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4D81A67F9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbgDMOXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgDMOXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6A720774;
        Mon, 13 Apr 2020 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787796;
        bh=6/8Giw7vwlpu0qHxdCH2Uw70MOy7QP71wZz64SFdEY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlqmrCwqaN/J1NUdniJULSUexKS2n7wNVl6jkwXrKZh+nnoS/GdoiXXb+qaCxmT/3
         NKQdV2oSxIP3mzqni158jh8Ikgn61H5rqLcvFpuN9u6BpXhcYE2aerUZT8UWJAAhBB
         +1KEzItp6Xf/p03CKfSfIYt/9/ip1hVVmXwGGJ30=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/13] net/mlx5: Provide simplified command interfaces
Date:   Mon, 13 Apr 2020 17:22:56 +0300
Message-Id: <20200413142308.936946-2-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Many mlx5_cmd_exec() callers are not interested in the output from that
command or have standard in/out structures. Those callers simply allocate
those structure on the stack and use sizeof() to provide in/out arguments.

In this naive approach provide simplified versions of mlx5_cmd_exec().

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/driver.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7b81b512d116..0e44e889577a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -903,6 +903,19 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size);
+
+#define mlx5_cmd_exec_inout(dev, ifc_cmd, in, out)                             \
+	({                                                                     \
+		mlx5_cmd_exec(dev, in, MLX5_ST_SZ_BYTES(ifc_cmd##_in), out,    \
+			      MLX5_ST_SZ_BYTES(ifc_cmd##_out));                \
+	})
+
+#define mlx5_cmd_exec_in(dev, ifc_cmd, in)                                     \
+	({                                                                     \
+		u32 _out[MLX5_ST_SZ_DW(ifc_cmd##_out)] = {};                   \
+		mlx5_cmd_exec_inout(dev, ifc_cmd, in, _out);                   \
+	})
+
 int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome);
-- 
2.25.2

