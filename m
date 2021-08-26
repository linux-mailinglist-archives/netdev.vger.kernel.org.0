Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA83F9099
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbhHZWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 18:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhHZWTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 18:19:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054DF61027;
        Thu, 26 Aug 2021 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630016293;
        bh=ahVR2up8sG8kT1iNl6eLBHNWGGm+IFUfanQMjb8fZ2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdcmlM7TIX/9kvMcoOCo8ySxXbMvHCa+MHg8kTTfmIwhuxIgnpYWUasSPNSGZr0Cc
         01a3Ufv5hL4Cw0muzT/fSKWKjyAxejIXBj2fMc2nmHuz40ez9GkAiLntNsvCDsp5lo
         RJxl2rf5ioZgOhMS7VxHzSX5+0D9iH7cXXMBbj5XcqV4Xi5FL1yNmqvF9cfIbfC451
         XUXPTfYrYn60GN6E+UAAKkfG952uPKne9b64BPOpE2OaN93J7tfojgI1FRXuVI1gJE
         akPxj1oNB8uDRDlWmwrh06eMCxNL9qKLrXtrpJzXBEq3n6tcn/cEpcsxqSjVNOw3YA
         VhTlWavpfNB5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/6] net/mlx5: Remove all auxiliary devices at the unregister event
Date:   Thu, 26 Aug 2021 15:18:06 -0700
Message-Id: <20210826221810.215968-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826221810.215968-1-saeed@kernel.org>
References: <20210826221810.215968-1-saeed@kernel.org>
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index def2156e50ee..20bb37266254 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -397,7 +397,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
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

