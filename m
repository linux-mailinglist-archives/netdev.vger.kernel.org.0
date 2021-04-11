Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E441035B427
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhDKM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhDKM3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D1E610C8;
        Sun, 11 Apr 2021 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144173;
        bh=ryPSsBc8zChcyATljURiG55ushiGkwgPiPc5jB748y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZF0B0ni8dz3nUEjKXkhsh3FIH/BXdOlJc5EPuhTfBj/RyFKEDdi1AYCf94xcrWgyf
         03nLVYEdqHXMsZGKivQc/ZaBkVde86TrXaXAmoKVniQ1h6ZLKo6dHBVNBtD25cx78H
         2SFwIP11BTUaEX+f9sLYZpoIAbAgg3VfEuSbqUuTxbokNejStjEPwrJjpfBveG687D
         ILhVL6MliyH1WL5jnfO7ucjjEwbnGtNnxX+aMXnwBxLSztN98f4XjUlTxZxsIYYAsg
         UXgE8Xa4tZqMITlEwxrBT7bGWCCxD5KUiofNx6x4Ivmr0MRWL+POGDt7ZBXAPKhvqW
         JRJ4gESUzGRMw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH mlx5-next v1 1/7] net/mlx5: Add MEMIC operations related bits
Date:   Sun, 11 Apr 2021 15:29:18 +0300
Message-Id: <20210411122924.60230-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add the MEMIC operations bits and structures to the mlx5_ifc file.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 42 ++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index df5d91c8b2d4..0ec4ea0a9c92 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -133,6 +133,7 @@ enum {
 	MLX5_CMD_OP_PAGE_FAULT_RESUME             = 0x204,
 	MLX5_CMD_OP_ALLOC_MEMIC                   = 0x205,
 	MLX5_CMD_OP_DEALLOC_MEMIC                 = 0x206,
+	MLX5_CMD_OP_MODIFY_MEMIC                  = 0x207,
 	MLX5_CMD_OP_CREATE_EQ                     = 0x301,
 	MLX5_CMD_OP_DESTROY_EQ                    = 0x302,
 	MLX5_CMD_OP_QUERY_EQ                      = 0x303,
@@ -1015,7 +1016,11 @@ struct mlx5_ifc_device_mem_cap_bits {
 
 	u8         header_modify_sw_icm_start_address[0x40];
 
-	u8         reserved_at_180[0x680];
+	u8         reserved_at_180[0x80];
+
+	u8         memic_operations[0x20];
+
+	u8         reserved_at_220[0x5e0];
 };
 
 struct mlx5_ifc_device_event_cap_bits {
@@ -10399,6 +10404,41 @@ struct mlx5_ifc_destroy_vport_lag_in_bits {
 	u8         reserved_at_40[0x40];
 };
 
+enum {
+	MLX5_MODIFY_MEMIC_OP_MOD_ALLOC,
+	MLX5_MODIFY_MEMIC_OP_MOD_DEALLOC,
+};
+
+struct mlx5_ifc_modify_memic_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x18];
+	u8         memic_operation_type[0x8];
+
+	u8         memic_start_addr[0x40];
+
+	u8         reserved_at_c0[0x140];
+};
+
+struct mlx5_ifc_modify_memic_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+
+	u8         memic_operation_addr[0x40];
+
+	u8         reserved_at_c0[0x140];
+};
+
 struct mlx5_ifc_alloc_memic_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
-- 
2.30.2

