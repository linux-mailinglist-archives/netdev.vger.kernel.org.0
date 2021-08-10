Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBE3E51B1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhHJEAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhHJEAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97CC561051;
        Tue, 10 Aug 2021 03:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567985;
        bh=nfsLYVKii38KA1BX1DoKYDnd+mnbX1oLvbkjiAb5AVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hsgk1txF2UDFhIfNHQ+Mvqd01XXZAxYtyGnjkc0f1gVP7YNNYTAy1LqA+Pc5cHoKP
         9Z8DHerqrnAIfG4WliCn7AQVnauUBoZSm0QcLlwto20WYlp2ziIueVczOAq+Zld56Z
         d8zaMm7hFQyppn7Y8K9j6OHd6dLOXG6VZ5//WHLapTenSHiCTc/MZ1bAxcslvOigNI
         5XM9lU2XJZAK1kAWolz4UQY2mVas/0t8p6l90N4ZQ55B8Ekx6o6f4wNBYfvYs/HQNi
         +TbSid9yx/uCdiTpKO0fYv/MTNXynYczu4Zf4POo6NJrlueJtituo1eObmgwXF7bQL
         wgVGuWz99VTrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/12] net/mlx5e: TC, Fix error handling memory leak
Date:   Mon,  9 Aug 2021 20:59:21 -0700
Message-Id: <20210810035923.345745-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Free the offload sample action on error.

Fixes: f94d6389f6a8 ("net/mlx5e: TC, Add support to offload sample action")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 794012c5c476..d3ad78aa9d45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -501,6 +501,7 @@ mlx5_esw_sample_offload(struct mlx5_esw_psample *esw_psample,
 err_offload_rule:
 	mlx5_esw_vporttbl_put(esw, &per_vport_tbl_attr);
 err_default_tbl:
+	kfree(sample_flow);
 	return ERR_PTR(err);
 }
 
-- 
2.31.1

