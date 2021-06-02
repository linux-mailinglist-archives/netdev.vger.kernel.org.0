Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7FF397E23
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFBBj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhFBBjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41BBA613D7;
        Wed,  2 Jun 2021 01:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597855;
        bh=4dyeHy/2DW9l/TWaufevj+fq0VQOefLgRjHbeUInRLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5YxpTlKnO747DJGSyT1a04HOwotScq7Z5IaW0pbqwn/N5r8GwPatCxE739ZKj6oa
         qLdlxoMVUfh7nve8qs+DtzaBua29oA6qqvdD/K5dtHdXTVrJOKydUilVr6GfvkkyBE
         FfuURNYCgTOOIG7OMQzdqlzTCzJXOi9SfiH0u6EbxBt16Zct62CkoLe3rikosCHNWK
         AwN5+9H5cTVUtc1VdqE1SyyyzzQe0PWjO3Lx77VoI1jP/vJCAvtrUW++gWb2J4SWRQ
         qX/bLpBWtiXv7NIwoIpV0yde9Kre0ThH26meSCv6sj1o19qDT3HGP9pXuAsHBlmD/+
         RbU9p6D70ZDVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 8/8] net/mlx5: DR, Create multi-destination flow table with level less than 64
Date:   Tue,  1 Jun 2021 18:37:23 -0700
Message-Id: <20210602013723.1142650-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Flow table that contains flow pointing to multiple flow tables or multiple
TIRs must have a level lower than 64. In our case it applies to muli-
destination flow table.
Fix the level of the created table to comply with HW Spec definitions, and
still make sure that its level lower than SW-owned tables, so that it
would be possible to point from the multi-destination FW table to SW
tables.

Fixes: 34583beea4b7 ("net/mlx5: DR, Create multi-destination table for SW-steering use")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c | 3 ++-
 include/linux/mlx5/mlx5_ifc.h                            | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 1fbcd012bb85..7ccfd40586ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -112,7 +112,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	int ret;
 
 	ft_attr.table_type = MLX5_FLOW_TABLE_TYPE_FDB;
-	ft_attr.level = dmn->info.caps.max_ft_level - 2;
+	ft_attr.level = min_t(int, dmn->info.caps.max_ft_level - 2,
+			      MLX5_FT_MAX_MULTIPATH_LEVEL);
 	ft_attr.reformat_en = reformat_req;
 	ft_attr.decap_en = reformat_req;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6d16eed6850e..eb86e80e4643 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1289,6 +1289,8 @@ enum mlx5_fc_bulk_alloc_bitmask {
 
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum))
 
+#define MLX5_FT_MAX_MULTIPATH_LEVEL 63
+
 enum {
 	MLX5_STEERING_FORMAT_CONNECTX_5   = 0,
 	MLX5_STEERING_FORMAT_CONNECTX_6DX = 1,
-- 
2.31.1

