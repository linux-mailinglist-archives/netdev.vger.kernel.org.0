Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED95488C8D
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiAIVdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiAIVdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:33:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DD9C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA9660C98
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 21:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1D0C36AE5;
        Sun,  9 Jan 2022 21:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641764003;
        bh=bK68YMgo5nFAakTan/u9ASzwgD0PCP2vsJaQuRN5P6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVCYYypz+a0KqqBnFIf534+c9+ajdl/piUZGID5zThOtAM8/is+D1fU9pkuEALn1e
         kh8ewm7WL8gXd4B2I9LtAlmrUQW4c/TXrzVdnU/sZmyDzgNYywgsLX6ZgFvhTPArUJ
         6tt0auxNNGfw999syuZjxZwoYzs4FnjGNE+5xW1fG5N0w4B72JuTIT8A4GlxOAAcOY
         0LG6gfSxq7v1tEEYmcAYsbIx6Kw1lo8/j+M+pfXfyyR9C+xT12dgHD8Dhp7alUYw1z
         T0jq8lR2o+0hoO4RIDX7B0PByDjdtEwsonPPUGwfO2r4yYRGU4bgpq+2NKtq0ASPgs
         /VJaia+k0c2og==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, leonro@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next] net/mlx5e: Fix build error in fec_set_block_stats()
Date:   Sun,  9 Jan 2022 13:33:21 -0800
Message-Id: <20220109213321.2292830-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YdqsUj3UNmESqvOw@unreal>
References: <YdqsUj3UNmESqvOw@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot reports:

drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
    1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
         |                                                ^~~~
         |                                                out

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 7e7c0c1019f6..26e326fe503c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1232,7 +1232,7 @@ static void fec_set_block_stats(struct mlx5e_priv *priv,
 
 	MLX5_SET(ppcnt_reg, in, local_port, 1);
 	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
-	if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
+	if (mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0))
 		return;
 
 	switch (mode) {
-- 
2.31.1

