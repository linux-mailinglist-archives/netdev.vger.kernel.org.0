Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C002D3AA6B8
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhFPWmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234014AbhFPWmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3981F613F3;
        Wed, 16 Jun 2021 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883229;
        bh=O0L5sCOMXfzNLK9NdmYJQZfRuLu8/+mkfyJ1f7xy/Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXPLaZTb7ZWs6bJNoR1lLzUwLcGYKdGpcflx0G/kS6cMOrejADoBPrmstiqwqNL4F
         l7VZBR4BIqCJxJUd8qnQ3vzKHja82ryAaFhj9IsrY56pbcDIrJd4UF+IAWcBBId26d
         8jo3JrRPnLGiU8ULGvt/y0hXvCDCKLvYuoE1BdL1ys6OVHj5IABRIb7DKJ1oIDDRqv
         FtDB+GkjXRotjWmsi8pKpbqkSJJEMlUEhVxnNAFNzWDOv/XH2nsvM/I+PGzyER8CsW
         zk18YThUZzMbAezZFc1ZyO36RaE0H8N81E5uydT06kCk96DCsgAfaoMUiMWxWiu68c
         J9AiRz6HAgKkg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/8] net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding
Date:   Wed, 16 Jun 2021 15:40:13 -0700
Message-Id: <20210616224015.14393-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@nvidia.com>

Decapsulation L3 on small inner packets which are less than
64 Bytes was done incorrectly. In small packets there is an
extra padding added in L2 which should not be included in L3
length. The issue was that after decapL3 the extra L2 padding
caused an update on the L3 length.

To avoid this issue the new header is pushed to the beginning
of the packet (offset 0) which should not cause a HW reparse
and update the L3 length.

Fixes: c349b4137cfd ("net/mlx5: DR, Add STEv1 modify header logic")
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 054c2e2b6554..7466f016375c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -694,7 +694,11 @@ static int dr_ste_v1_set_action_decap_l3_list(void *data,
 	if (hw_action_sz / DR_STE_ACTION_DOUBLE_SZ < DR_STE_DECAP_L3_ACTION_NUM)
 		return -EINVAL;
 
-	memcpy(padded_data, data, data_sz);
+	inline_data_sz =
+		MLX5_FLD_SZ_BYTES(ste_double_action_insert_with_inline_v1, inline_data);
+
+	/* Add an alignment padding  */
+	memcpy(padded_data + data_sz % inline_data_sz, data, data_sz);
 
 	/* Remove L2L3 outer headers */
 	MLX5_SET(ste_single_action_remove_header_v1, hw_action, action_id,
@@ -706,32 +710,34 @@ static int dr_ste_v1_set_action_decap_l3_list(void *data,
 	hw_action += DR_STE_ACTION_DOUBLE_SZ;
 	used_actions++; /* Remove and NOP are a single double action */
 
-	inline_data_sz =
-		MLX5_FLD_SZ_BYTES(ste_double_action_insert_with_inline_v1, inline_data);
+	/* Point to the last dword of the header */
+	data_ptr += (data_sz / inline_data_sz) * inline_data_sz;
 
-	/* Add the new header inline + 2 extra bytes */
+	/* Add the new header using inline action 4Byte at a time, the header
+	 * is added in reversed order to the beginning of the packet to avoid
+	 * incorrect parsing by the HW. Since header is 14B or 18B an extra
+	 * two bytes are padded and later removed.
+	 */
 	for (i = 0; i < data_sz / inline_data_sz + 1; i++) {
 		void *addr_inline;
 
 		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, action_id,
 			 DR_STE_V1_ACTION_ID_INSERT_INLINE);
 		/* The hardware expects here offset to words (2 bytes) */
-		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, start_offset,
-			 i * 2);
+		MLX5_SET(ste_double_action_insert_with_inline_v1, hw_action, start_offset, 0);
 
 		/* Copy bytes one by one to avoid endianness problem */
 		addr_inline = MLX5_ADDR_OF(ste_double_action_insert_with_inline_v1,
 					   hw_action, inline_data);
-		memcpy(addr_inline, data_ptr, inline_data_sz);
+		memcpy(addr_inline, data_ptr - i * inline_data_sz, inline_data_sz);
 		hw_action += DR_STE_ACTION_DOUBLE_SZ;
-		data_ptr += inline_data_sz;
 		used_actions++;
 	}
 
-	/* Remove 2 extra bytes */
+	/* Remove first 2 extra bytes */
 	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, action_id,
 		 DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
-	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, start_offset, data_sz / 2);
+	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, start_offset, 0);
 	/* The hardware expects here size in words (2 bytes) */
 	MLX5_SET(ste_single_action_remove_header_size_v1, hw_action, remove_size, 1);
 	used_actions++;
-- 
2.31.1

