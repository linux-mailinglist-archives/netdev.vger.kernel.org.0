Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426BE3F909B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbhHZWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243740AbhHZWTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E971360FDC;
        Thu, 26 Aug 2021 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016294;
        bh=BXDBQ5Xmh0h89MtDRS1zimlogZqjs2z3uEhtQOOZQf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOjZGaCiqrwAS+R+74Trb0JZqcqqbv/ZdyM0ML/DsfmUt73u57UmBkBwCq3ekruEd
         Et9+O0bM9epiv74s55EvEe5+7D3Gd6U3dS3PcSz1G+LKSEs0UH3rlq8vzGsj6dA05I
         gX+oJaKLYldbisPPw7BxhqVNgH6N2Elt0KmYTzMm8c+udVFu0YczG0PrCVNPnm8ma1
         DLuPUOjZjdKGx1AKQMlCV4wFVtVr7ajsTreVILy0Stf1diCHyXR7IgLoopJsGbPD09
         TEAa8jpVgau3t/4gebRHf/soRJH6X5rfZMti4hNC17vbyQH0t5iDup8aJZZmMhIHl/
         q5a5fnE6l5SnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/6] net/mlx5: E-Switch, Set vhca id valid flag when creating indir fwd group
Date:   Thu, 26 Aug 2021 15:18:08 -0700
Message-Id: <20210826221810.215968-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

When indirect forward group is created, flow is added with vhca id but
without setting vhca id valid flag which violates the PRM.

Fix by setting the missing flag, vhca id valid.

Fixes: 34ca65352ddf ("net/mlx5: E-Switch, Indirect table infrastructure")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 3da7becc1069..425c91814b34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -364,6 +364,7 @@ static int mlx5_create_indir_fwd_group(struct mlx5_eswitch *esw,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	dest.vport.num = e->vport;
 	dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	e->fwd_rule = mlx5_add_flow_rules(e->ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(e->fwd_rule)) {
 		mlx5_destroy_flow_group(e->fwd_grp);
-- 
2.31.1

