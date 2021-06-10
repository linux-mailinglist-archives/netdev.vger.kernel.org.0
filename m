Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC3B3A2155
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFJAY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFJAYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA93C613F5;
        Thu, 10 Jun 2021 00:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284539;
        bh=rdjNzbif5TyCCuqDASB7F2yFD1l77p1HHWBud8AUpHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuZjcKttUfCbR3l4cYS3KKLGC3D2LiQC8Gdi+oS9AIAW06YzkdWT/pB0hWXzHihC6
         rN4MVNzfshmWNY3/b1dIEQX9rkv8QcVmR8pbYHYIa54L2UOHIo2nP/Ox/ksBPc/SGM
         gXnKWtgm1rx2Th5gT+TRKBSXPibJURlkIaIbsZHvr22V7BtVhJ8QI3vbcHsESw9/Gw
         yT8lvtEgz0TSByXL8ZrGZrRk8biyE0iuRmOK1nfPu7gAQ76piB2dyWqUXi6MOyQunq
         YiauQKnlBO5ZZww6w4elb5wNDhBiYEbVG7U4OekVYxcVjucJng2h6PyMtdUQSTJUJJ
         HFy5r1tYIpmOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/12] net/mlx5: Consider RoCE cap before init RDMA resources
Date:   Wed,  9 Jun 2021 17:21:48 -0700
Message-Id: <20210610002155.196735-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Check if RoCE is supported by the device before enable it in
the vport context and create all the RDMA steering objects.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 441b5453acae..540cf05f6373 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -156,6 +156,9 @@ void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
 {
 	int err;
 
+	if (!MLX5_CAP_GEN(dev, roce))
+		return;
+
 	err = mlx5_nic_vport_enable_roce(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to enable RoCE: %d\n", err);
-- 
2.31.1

