Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB44C1961
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbiBWRFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243159AbiBWRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F3E53B6C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66342B82115
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA16C36AE3;
        Wed, 23 Feb 2022 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635885;
        bh=uBU5IRJiHSNhzaQz/uOHAkPGRc5LpheNcZXPw3O1shI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NePOsxXYr6ZqtJad339HNJr5vk4Khs2GcCUYBcVZLykaRQ2VsexiPtlyvggERhxD8
         o6ut/fUyTTaOVBGfpDEeGr+Fjpqhikz0CyWw8WlekGOh30bvr4fnTkH/c3xEoYee67
         2Oe4B8LD9YwUvR7wX3+UowtbpuHbjSNW7zuo+dI73kImyJyJeuSssgADNKm6n+es9R
         dfxI4rFVgLrB9jtw3faqN2Fr2eUId9WcnOBM/Iy+2nQPw97EOpT0J+bZVmQWq3Tq6W
         fVNm0Ra6ELT2qqHDAZGdvc0oZSfLAtjDD/UPKrPCXOt69pJAPb6JB7Qw/GBiT4qdQ9
         1sZbhBGfufhqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/19] net/mlx5e: Add feature check for set fec counters
Date:   Wed, 23 Feb 2022 09:04:26 -0800
Message-Id: <20220223170430.295595-16-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Fec counters support is checked via the PCAM feature_cap_mask,
bit 0: PPCNT_counter_group_Phy_statistical_counter_group.
Add feature check to avoid faulty behavior.

Fixes: 0a1498ebfa55 ("net/mlx5e: Expose FEC counters via ethtool")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 26e326fe503c..00f1d16db456 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1254,9 +1254,6 @@ static void fec_set_corrected_bits_total(struct mlx5e_priv *priv,
 	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
 
-	if (!MLX5_CAP_PCAM_FEATURE(mdev, ppcnt_statistical_group))
-		return;
-
 	MLX5_SET(ppcnt_reg, in, local_port, 1);
 	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_STATISTICAL_GROUP);
 	if (mlx5_core_access_reg(mdev, in, sz, ppcnt_phy_statistical,
@@ -1272,6 +1269,9 @@ static void fec_set_corrected_bits_total(struct mlx5e_priv *priv,
 void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 			 struct ethtool_fec_stats *fec_stats)
 {
+	if (!MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
+		return;
+
 	fec_set_corrected_bits_total(priv, fec_stats);
 	fec_set_block_stats(priv, fec_stats);
 }
-- 
2.35.1

