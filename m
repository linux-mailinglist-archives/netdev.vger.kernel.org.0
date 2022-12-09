Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5328C647A9A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLIAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiLIAOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D2E8E590
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EE6AB826BB
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908C5C433F0;
        Fri,  9 Dec 2022 00:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544879;
        bh=f4oKY2I0pM+6L8FJB6uSuv8YUbs6kwtjgH42BKAjdlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/LjN223Z/7kNI5z0aSUigGihqWLCsmLDRZkNUowsUJzUNeRFNEzLCtRXxMU9PLd9
         zAwMcJmlXABUecHO1DRZ2X9PA9s4HDZcJ1AtPtC3KajoHweVEp6cy605nl8+QjtSuJ
         pR6SbcU1n3M5OajYqsCIMJ6U7m9CpV3E10LUJHAgWEodiYz7hFeFLSRAULI70dN4rW
         7sKfZvj95vQhGLJIoNxbPBbLeNnmhhbI33//X7rZSmdsHPPGvFIZI6LGNbsc+quD2b
         wZNppSdeoXX21GFYdxsFLhKpjJXRifmK1ghrRGA11mSKbB03wF8S5HxCH4zCBuIvYP
         nxjiNfBwK80rQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Add function that tells if STE miss addr has been initialized
Date:   Thu,  8 Dec 2022 16:14:13 -0800
Message-Id: <20221209001420.142794-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Up until now miss address in all the STEs was used to connect miss lists
and to link the last STE in the list to end anchor.
Match range STE will require special handling because its miss address is
part of the 'action'. That is, range action has hit and miss addresses.
Since the range action is always the last action, need to make sure that
its miss address isn't overwritten by the end anchor.

Adding new function mlx5dr_ste_is_miss_addr_set() to answer the question
whether the STE's miss address has already been set as part of STE
initialization. Use a callback that always returns false right now. Once
match range is added, a different callback will be used for that STE type.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_rule.c |  3 +++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 10 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste.h  |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c   |  6 ++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h   |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c   |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h    |  1 +
 7 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 3351b2a1ba18..74cbe53ee9db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -42,6 +42,9 @@ static void dr_rule_set_last_ste_miss_addr(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_ste_ctx *ste_ctx = matcher->tbl->dmn->ste_ctx;
 	u64 icm_addr;
 
+	if (mlx5dr_ste_is_miss_addr_set(ste_ctx, hw_ste))
+		return;
+
 	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste, icm_addr);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9e19a8dc9022..1e15f605df6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -90,6 +90,16 @@ static void dr_ste_set_always_miss(struct dr_hw_ste_format *hw_ste)
 	hw_ste->mask[0] = 0;
 }
 
+bool mlx5dr_ste_is_miss_addr_set(struct mlx5dr_ste_ctx *ste_ctx,
+				 u8 *hw_ste_p)
+{
+	if (!ste_ctx->is_miss_addr_set)
+		return false;
+
+	/* check if miss address is already set for this type of STE */
+	return ste_ctx->is_miss_addr_set(hw_ste_p);
+}
+
 void mlx5dr_ste_set_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
 			      u8 *hw_ste_p, u64 miss_addr)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 17513baff9b0..7075142bcfb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -151,6 +151,7 @@ struct mlx5dr_ste_ctx {
 			 bool is_rx, u16 gvmi);
 	void (*set_next_lu_type)(u8 *hw_ste_p, u16 lu_type);
 	u16  (*get_next_lu_type)(u8 *hw_ste_p);
+	bool (*is_miss_addr_set)(u8 *hw_ste_p);
 	void (*set_miss_addr)(u8 *hw_ste_p, u64 miss_addr);
 	u64  (*get_miss_addr)(u8 *hw_ste_p);
 	void (*set_hit_addr)(u8 *hw_ste_p, u64 icm_addr, u32 ht_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index ee677a5c76be..87c29118c51b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -267,6 +267,11 @@ static void dr_ste_v1_set_entry_type(u8 *hw_ste_p, u8 entry_type)
 	MLX5_SET(ste_match_bwc_v1, hw_ste_p, entry_format, entry_type);
 }
 
+bool dr_ste_v1_is_miss_addr_set(u8 *hw_ste_p)
+{
+	return false;
+}
+
 void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 {
 	u64 index = miss_addr >> 6;
@@ -2144,6 +2149,7 @@ static struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.ste_init			= &dr_ste_v1_init,
 	.set_next_lu_type		= &dr_ste_v1_set_next_lu_type,
 	.get_next_lu_type		= &dr_ste_v1_get_next_lu_type,
+	.is_miss_addr_set		= &dr_ste_v1_is_miss_addr_set,
 	.set_miss_addr			= &dr_ste_v1_set_miss_addr,
 	.get_miss_addr			= &dr_ste_v1_get_miss_addr,
 	.set_hit_addr			= &dr_ste_v1_set_hit_addr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
index 8a1d49790c6e..b5c0f0f8392f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
@@ -7,6 +7,7 @@
 #include "dr_types.h"
 #include "dr_ste.h"
 
+bool dr_ste_v1_is_miss_addr_set(u8 *hw_ste_p);
 void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr);
 u64 dr_ste_v1_get_miss_addr(u8 *hw_ste_p);
 void dr_ste_v1_set_byte_mask(u8 *hw_ste_p, u16 byte_mask);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
index c60fddd125d2..cf1a3c9a1cf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
@@ -202,6 +202,7 @@ static struct mlx5dr_ste_ctx ste_ctx_v2 = {
 	.ste_init			= &dr_ste_v1_init,
 	.set_next_lu_type		= &dr_ste_v1_set_next_lu_type,
 	.get_next_lu_type		= &dr_ste_v1_get_next_lu_type,
+	.is_miss_addr_set		= &dr_ste_v1_is_miss_addr_set,
 	.set_miss_addr			= &dr_ste_v1_set_miss_addr,
 	.get_miss_addr			= &dr_ste_v1_get_miss_addr,
 	.set_hit_addr			= &dr_ste_v1_set_hit_addr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 94093c3b55a5..a3e8ce415563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -238,6 +238,7 @@ static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 
 /* STE utils */
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl);
+bool mlx5dr_ste_is_miss_addr_set(struct mlx5dr_ste_ctx *ste_ctx, u8 *hw_ste_p);
 void mlx5dr_ste_set_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
 			      u8 *hw_ste, u64 miss_addr);
 void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
-- 
2.38.1

