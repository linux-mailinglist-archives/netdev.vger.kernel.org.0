Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D79658684
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiL1Tny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiL1Tnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036160EE
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D1AAB818B9
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F18C433D2;
        Wed, 28 Dec 2022 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256623;
        bh=6blQ9y4lYqxgoEH1xu/cZK1KjaCZPpzmp6+ybHFxMzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDks3FTiFxoQ7l5fECZZm6FgG3LyrfxgVk+xkaNKGu8C8e0Ot7XXap6G78wgI656N
         pZTVS9Xr4hmJrcFUfEXalULPlw5gcgQDyD1cFaKOynaVbtBlckFQdJhLvULSd35G+j
         /fNTOlodKQca6+Pshk+gY/bO4kaPpEVvFT5r2TqFDwE9yq+FP3XAIKJG4NePmpBv8E
         GooPgxpSxkQ+ATJSA2YSzNEmmvnjXExZXf2gKAfAV0267rG3EUm57eWOHZq/sAllFW
         7cF3dTj6GE6gPVf3qRbKm5uLNoHabkvCfiUvAqMrzHH3GlJLecEeg0+5Lt8kcZU4iI
         0B3q+1fajBkeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 05/12] net/mlx5: Fix RoCE setting at HCA level
Date:   Wed, 28 Dec 2022 11:43:24 -0800
Message-Id: <20221228194331.70419-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

mlx5 PF can disable RoCE for its VFs and SFs. In such case RoCE is
marked as unsupported on those VFs/SFs.
The cited patch added an option for disable (and enable) RoCE at HCA
level. However, that commit didn't check whether RoCE is supported on
the HCA and enabled user to try and set RoCE to on.
Fix it by checking whether the HCA supports RoCE.

Fixes: fbfa97b4d79f ("net/mlx5: Disable roce at HCA level")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index be59bb35d795..5bd83c0275f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -468,7 +468,7 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 	bool new_state = val.vbool;
 
 	if (new_state && !MLX5_CAP_GEN(dev, roce) &&
-	    !MLX5_CAP_GEN(dev, roce_rw_supported)) {
+	    !(MLX5_CAP_GEN(dev, roce_rw_supported) && MLX5_CAP_GEN_MAX(dev, roce))) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ec5652f31dda..df134f6d32dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -613,7 +613,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
 			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
 
-	if (MLX5_CAP_GEN(dev, roce_rw_supported))
+	if (MLX5_CAP_GEN(dev, roce_rw_supported) && MLX5_CAP_GEN_MAX(dev, roce))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
 			 mlx5_is_roce_on(dev));
 
-- 
2.38.1

