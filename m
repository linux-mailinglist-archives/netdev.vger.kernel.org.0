Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75387392683
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhE0Eik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhE0EiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83E3613DA;
        Thu, 27 May 2021 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090202;
        bh=x6GWP+bCxtyYU4G42DLgVy0+Yk4kbPZnes/g9UwoVyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoH+flZUtT5xgA03YF/COoJ2xoQhtPwGHXEj75VP1z46iTFTj++XdztoDgAqL/Wja
         tVsvdCgjIGl08ON5xPCdEHDc4dt/uimIiaBn8xnIsNMyUhOD/jcV75Vj334S2Mzp4e
         XWiXkqybYXUbxcd8nbwraJsbk5VoVldP8GUl6CWQP3il3iMsCPhwaR5wAcIhxyIq+x
         JQcLhK4znY2b3cVfuLwVxFqcLdzBxWE4UDxeysPXsne5MjMt2NzvfyUuJRgzO9xHBl
         8lN3AYb5hWMTBvhPCyMdouqtRMPd0EYqqrYSJoouU2i/kuvdfhwruEwkCOYivSDidS
         53IFHD9oIgPtQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/17] net/mlx5: Ensure SF BAR size is at least PAGE_SIZE
Date:   Wed, 26 May 2021 21:36:08 -0700
Message-Id: <20210527043609.654854-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Make sure the allocated SF BAR size is at least PAGE_SIZE so that when
mapping it userspace, the mapped page will not cover other SFs.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 6a0c6f965ad1..9f9728324731 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -227,7 +227,8 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 		max_sfs = MLX5_CAP_GEN(dev, max_num_sf);
 	else
 		max_sfs = 1 << MLX5_CAP_GEN(dev, log_max_sf);
-	table->sf_bar_length = 1 << (MLX5_CAP_GEN(dev, log_min_sf_size) + 12);
+	table->sf_bar_length = 1 << (max_t(u8, MLX5_CAP_GEN(dev, log_min_sf_size) + 12,
+					   PAGE_SHIFT));
 	table->base_address = pci_resource_start(dev->pdev, 2);
 	table->max_sfs = max_sfs;
 	xa_init(&table->devices);
-- 
2.31.1

