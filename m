Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8456A340462
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhCRLQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhCRLQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:16:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB6164F2A;
        Thu, 18 Mar 2021 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066165;
        bh=S8hZOUFcGCuQUCdKDUyOuiZcrCRczJtzyfMojtfu5pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H18XoSmcXxTQs5/kvdz874n3iT4eJpqV5meEde5hsv41KDQ7mZKeBbe3BNGma6DmH
         O/2W94bSM4txcG56nOZe8za7wJTOq8rRpFU0bDJRgRySFXqGQYaoOk253cusIG6WvT
         yOP7I4phr6GTkCl1CuYmrZAJ9erUTKNZZgDG+OTnMRxog9eilJ48JjIyUfO3hj0hBW
         mWqu5xWgs8tpKVu+jXym7HokUKZL7AkZ+N/MPpewoto1xk1rwYZ2sKUKbR2N4SmmK2
         A+QpyyFkVBpZoJ8H3OT7m5TFK2/ys1J5axeceERqg3Puw4731o2T6Rv0c74sVVLBLC
         UOwWuAYnJA/1A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH mlx5-next 1/7] net/mlx5: Add MEMIC operations related bits
Date:   Thu, 18 Mar 2021 13:15:42 +0200
Message-Id: <20210318111548.674749-2-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
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
index c0ce1c2e1e57..dd69cf1320ce 100644
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
@@ -10408,6 +10413,41 @@ struct mlx5_ifc_destroy_vport_lag_in_bits {
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

