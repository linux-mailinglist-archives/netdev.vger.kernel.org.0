Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4D235FA45
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352290AbhDNSHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352099AbhDNSGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8715461249;
        Wed, 14 Apr 2021 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423577;
        bh=dp728qMavUj8GhaemE8g8peaLJxCX9qoE/COyGJDofU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHYpxzPEQcE3srZOUONO3akOKqy0uvmGfMqt836i63BxYsSOVZqeu2o0oc/LjVsrh
         QFaExFrBXoxCm97lLJ2m0y/LXPEiCsS3RYEpkr+un8wkRbo6RLlnI8qYu1K9MXonHe
         gOdjdEf5eOYAY4/MjXq6QLyFzEm9iYbX0rl19dwvtCGON3KctkojAWCdbJ6CuPZUlR
         S9Zg/7fPb+TyC/r5uWLzyLfXvBby20zDfc3/IX2rmJqxp8MxohaPSQ6UZHbwHVj+Gs
         MQ6wVrjwWsmHN7GCIFc0JG6l6HFKMrEROzMYMRdZ7MPCExdYaMzV/o3QGuBS5IYPhA
         0FsV98fybRs5Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/16] net/mlx5: SF, Reuse stored hardware function id
Date:   Wed, 14 Apr 2021 11:05:58 -0700
Message-Id: <20210414180605.111070-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

SF's hardware function id is already stored in mlx5_sf. Reuse it,
instead of querying the hw table.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 60a6328a9ca0..52226d9b9a6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -270,15 +270,14 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf *sf;
-	u16 hw_fn_id;
 	int err;
 
 	sf = mlx5_sf_alloc(table, new_attr->sfnum, extack);
 	if (IS_ERR(sf))
 		return PTR_ERR(sf);
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sf->id);
-	err = mlx5_esw_offloads_sf_vport_enable(esw, &sf->dl_port, hw_fn_id, new_attr->sfnum);
+	err = mlx5_esw_offloads_sf_vport_enable(esw, &sf->dl_port, sf->hw_fn_id,
+						new_attr->sfnum);
 	if (err)
 		goto esw_err;
 	*new_port_index = sf->port_index;
-- 
2.30.2

