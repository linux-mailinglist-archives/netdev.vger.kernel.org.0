Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252233380AA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCKWht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCKWhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5896764F91;
        Thu, 11 Mar 2021 22:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502254;
        bh=8a3ZdWGqqALcxVk8rer+NLI6bK7iVpFE2HMbYaMi5ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPbjSJ4uLTwzgx+WiO+ytI1LQLlmHNVWKcYdLcDavZ0GyM5m3fFOcRCyxqrihk8bp
         90+WfiDxeGpVYG3+v1befPdMH4adcTW3eh/boHu0ea/+ZfH+fUb0Mg4vlLqP8IZl0/
         scxWKzn8HWPFM1nLzpxN1PWLjpv5zgZFOCFPNGEazl7yIx8Ko3e2fRLs4IxuAL6eqx
         ETidXDcpnYahXhwaVeMyMu1KNrT7bwxNhPWTNSGkxPjC7Kru9JSx+Hz4nOdj69zLcV
         V8QLEvDncc4kn1Ll/+h2YSQ+jPxoxy/5vUT5dFdvhzADgpln3XBi9X1WXpFD4EDyZ9
         zIeI8Dx8O8wtg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Remove impossible checks of interface state
Date:   Thu, 11 Mar 2021 14:37:10 -0800
Message-Id: <20210311223723.361301-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The interface state is constant at this stage and checked
before calling to the register/unregister reserved GIDs.

There is no need to double check it.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
index a68738c8f4bc..97324d9d4f2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
@@ -55,10 +55,6 @@ void mlx5_cleanup_reserved_gids(struct mlx5_core_dev *dev)
 
 int mlx5_core_reserve_gids(struct mlx5_core_dev *dev, unsigned int count)
 {
-	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-		mlx5_core_err(dev, "Cannot reserve GIDs when interfaces are up\n");
-		return -EPERM;
-	}
 	if (dev->roce.reserved_gids.start < count) {
 		mlx5_core_warn(dev, "GID table exhausted attempting to reserve %d more GIDs\n",
 			       count);
@@ -79,7 +75,6 @@ int mlx5_core_reserve_gids(struct mlx5_core_dev *dev, unsigned int count)
 
 void mlx5_core_unreserve_gids(struct mlx5_core_dev *dev, unsigned int count)
 {
-	WARN(test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state), "Unreserving GIDs when interfaces are up");
 	WARN(count > dev->roce.reserved_gids.count, "Unreserving %u GIDs when only %u reserved",
 	     count, dev->roce.reserved_gids.count);
 
-- 
2.29.2

