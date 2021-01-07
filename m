Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE452EE6E3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbhAGUaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbhAGUaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D8E4235F9;
        Thu,  7 Jan 2021 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051355;
        bh=NfKa1wMbyb58EvcEb0Q9WgJXKi0qy4FU85Obw7NJcS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K/OdNlcrEuTWCk+Ge7xtQtlwNw/HqLhOxDuWBS5pedH8h2bx5Ex3dVxZMgAlQI87c
         4HlGsiXZHORtOK2BHia4WUssEJ3D5YgCR/JjT9U7oEeidrPrRe1JQ46k/rpMK2UMpC
         GFg/S+jLPvKo707IFA83MbQgu4SestEoSUTjl5rmDuaNliXUsJpj1dFOjL48GmSYKf
         H0lzLej2MaM1XhIgPd/cIvvohrnkwJOsMqRrcw5mT4TXpqvo/ile1Onc5i7JKp7O5s
         GxcDX3SW98dMZViKD1OJ/dKzTbP15Mbb/7SxsZOgG7ORO8DNqiwwhraFKNIRi7qGoo
         MsW4VulVdcKdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/11] net/mlx5: Release devlink object if adev fails
Date:   Thu,  7 Jan 2021 12:28:43 -0800
Message-Id: <20210107202845.470205-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Add missed freeing previously allocated devlink object.

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c08315b51fd3..ca6f2fc39ea0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1368,8 +1368,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			 MLX5_COREDEV_VF : MLX5_COREDEV_PF;
 
 	dev->priv.adev_idx = mlx5_adev_idx_alloc();
-	if (dev->priv.adev_idx < 0)
-		return dev->priv.adev_idx;
+	if (dev->priv.adev_idx < 0) {
+		err = dev->priv.adev_idx;
+		goto adev_init_err;
+	}
 
 	err = mlx5_mdev_init(dev, prof_sel);
 	if (err)
@@ -1403,6 +1405,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlx5_mdev_uninit(dev);
 mdev_init_err:
 	mlx5_adev_idx_free(dev->priv.adev_idx);
+adev_init_err:
 	mlx5_devlink_free(devlink);
 
 	return err;
-- 
2.26.2

