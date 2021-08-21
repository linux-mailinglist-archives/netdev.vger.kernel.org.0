Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3B03F3A7F
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 14:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhHUMF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 08:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHUMF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 08:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA3B61208;
        Sat, 21 Aug 2021 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629547517;
        bh=7b8O7wGi5gddQ9SPyLcbYSDrwXMperOFORvE41q0jOw=;
        h=From:To:Cc:Subject:Date:From;
        b=AX1vxqRyMYuxvcTYFBJbWccZmE7z23R2OHc3CrW75X1sY2554NF+BqbB2qh2+en1/
         m9YxRhLnxU5Rh0S0fRJJrMlxkWMYnPpA1TSyFzBg0YZicZNGObyWTcfUi44dSaak8D
         ofmYfR//s8OXlXXADonJ3WH9cKiZ+GYDADIqzVcJv55i8iAsqqPrky3lq0KHtWM9TD
         8ThnmRj+dYXVvZatbBPlYvABkwTrwKOD25NzumLGo1v2eQLNRv4gpjL2XvdOye9s+4
         dIdQdpsgex6JDeg+INd/jKVyjD542FzUvzj+D0HKt5JiYfhcBGWv0vz3KXrIEQ61Is
         fXqkIwAV9Nf3g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Subject: [PATCH net] net/mlx5: Remove all auxiliary devices at the unregister event
Date:   Sat, 21 Aug 2021 15:05:11 +0300
Message-Id: <10641ab4c3de708f61a968158cac7620cef27067.1629547326.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The call to mlx5_unregister_device() means that mlx5_core driver is
removed. In such scenario, we need to disregard all other flags like
attach/detach and forcibly remove all auxiliary devices.

Fixes: a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow")
Tested-and-Reported-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ff6b03dc7e32..e8093c4e09d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -450,7 +450,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
 	mutex_lock(&mlx5_intf_mutex);
-	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
 }
-- 
2.31.1

