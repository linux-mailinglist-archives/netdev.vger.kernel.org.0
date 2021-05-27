Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6730B3935B9
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhE0S6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236171AbhE0S6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1169E610CE;
        Thu, 27 May 2021 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141801;
        bh=lKTulkTziS+NkGD49gosC0fNNCWb++ScrOK49DGw3Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlV477/CoePFSf68yum2BWoQsc0k22hfILXtGXIjKzyXuJD/OmVYBIHbfKsXCZQ9A
         byBfGjpeetR0WGXskBqLGfqM+8jsdkTxtNgWuvkxQStpEGhqKfuEh4TgOkVFXXCy8+
         77wrKmEb4lTGJqQZ+GHUQmfTjK4G491+LGjlKcGHpj/BE3cNs2aNug9uwM53zjvBgp
         chhXJ5vdVVgnO/L0A3WdsebaiNTZxKjMtT9hu8zGtvkbWJ4kCE/VvXi3unwNIjc51v
         IFVqj7GoKm3b1JOL5LMMOQgaP00cH9bjr/vstLXoY/ni0suE8tw7c+a41ty3XcVKSI
         pYrvJB4axovWw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 14/15] net/mlx5: Use boolean arithmetic to evaluate roce_lag
Date:   Thu, 27 May 2021 11:56:23 -0700
Message-Id: <20210527185624.694304-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Avoid mixing boolean and bit arithmetic when evaluating validity of
roce_lag.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index c9c00163d918..e52e2144ab12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -289,8 +289,9 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 			   !mlx5_sriov_is_enabled(dev1);
 
 #ifdef CONFIG_MLX5_ESWITCH
-		roce_lag &= dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
-			    dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE;
+		roce_lag = roce_lag &&
+			   dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
+			   dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE;
 #endif
 
 		if (roce_lag)
-- 
2.31.1

