Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3601C30B831
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhBBG6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhBBG4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66DE864EF2;
        Tue,  2 Feb 2021 06:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248923;
        bh=7I/pV+m4etHdswYEDoAmwjoQdtteTXqZGldance8j28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YIcF7gm024V/WEH2n+/sWkROCXpRZTJCCEjPHi63dn3g9IHXjshwByrDpj9VnrzUJ
         bmfEVgWu40MDhoGyroYjscq2zVDrhQgAi8m11+HWSPik86YiVESwPlpHpJ3Jalr0Ap
         ZwDacjceEAumfscptHngbMb8J168WaiNBqrntpGzWCYC6FPNwfptbBN0Ke058oOtHG
         mSO9Muz/jBsl/zITIwjdgCG2Eu31obmlGrGxxl6aUsHj92J9ovU7SyXP/wrTz+G0Vf
         JR3zANshhUljnXP8ey70sHlnIG6jfbgZ0YyldBtgwZaYl6Fol03iUNxQqN7dCMVfu0
         gzSA62pvB80xw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5: DR, Avoid unnecessary csum recalculation on supporting devices
Date:   Mon,  1 Feb 2021 22:54:57 -0800
Message-Id: <20210202065457.613312-15-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

If as part of the actions the TTL of the packet is modified, the packet's
checksum needs to be recalculated. Connect-X6DX can handle this csum
recalculation natively. Older devices require this additional recalculation.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 9 +++++----
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste.c    | 5 +++++
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h  | 2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 27c2b8416d02..28a7971cac6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -447,7 +447,8 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		case DR_ACTION_TYP_MODIFY_HDR:
 			attr.modify_index = action->rewrite.index;
 			attr.modify_actions = action->rewrite.num_of_actions;
-			recalc_cs_required = action->rewrite.modify_ttl;
+			recalc_cs_required = action->rewrite.modify_ttl &&
+					     !mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps);
 			break;
 		case DR_ACTION_TYP_L2_TO_TNL_L2:
 		case DR_ACTION_TYP_L2_TO_TNL_L3:
@@ -501,9 +502,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	*new_hw_ste_arr_sz = nic_matcher->num_of_builders;
 	last_ste = ste_arr + DR_STE_SIZE * (nic_matcher->num_of_builders - 1);
 
-	/* Due to a HW bug, modifying TTL on RX flows will cause an incorrect
-	 * checksum calculation. In this case we will use a FW table to
-	 * recalculate.
+	/* Due to a HW bug in some devices, modifying TTL on RX flows will
+	 * cause an incorrect checksum calculation. In this case we will
+	 * use a FW table to recalculate.
 	 */
 	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB &&
 	    rx_rule && recalc_cs_required && dest_action) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9cd5c50c5d42..f49abc7a4b9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -18,6 +18,11 @@ static u32 dr_ste_crc32_calc(const void *input_data, size_t length)
 	return (__force u32)htonl(crc);
 }
 
+bool mlx5dr_ste_supp_ttl_cs_recalc(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->sw_format_ver > MLX5_STEERING_FORMAT_CONNECTX_5;
+}
+
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 {
 	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a8b497cbb844..4af0e4e6a13c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1211,6 +1211,8 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 		       u32 group_id,
 		       struct mlx5dr_cmd_fte_info *fte);
 
+bool mlx5dr_ste_supp_ttl_cs_recalc(struct mlx5dr_cmd_caps *caps);
+
 struct mlx5dr_fw_recalc_cs_ft {
 	u64 rx_icm_addr;
 	u32 table_id;
-- 
2.29.2

