Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC73E35E716
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348065AbhDMTbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345962AbhDMTaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B670613CE;
        Tue, 13 Apr 2021 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342232;
        bh=dp728qMavUj8GhaemE8g8peaLJxCX9qoE/COyGJDofU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXbmpaE0gqo9LgdGI3SdR4U8OLwZOYoVs6U5nhr3/ffo41U2OzTpxM+lvn5xYiFJB
         Dn7DyfGV/ZvGNziao3qSAeeIUTh6dITmbgzSdtu8iWBQakdnAvTodLNgpoL2lFdQxF
         FkZeFBIPF7Bd8ieNM/8tqXfLfEr9mVzKfYTaXJQ6wBmGWEi+CsANl8Xo2cvValsatz
         q3NkqUyk96vVPSzgxmg4Kfjq6mV+xSdd3+b01lLCM4XbyKfuePzo8hqdXiTh/uLs59
         YmFwGp9zLoqY0Jm5fMeOR8f7dI7muqm4QOIsTcrhN48AFrcqnkQsIigSqg6TTvmvp6
         KBkrNqm9/qBOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5: SF, Reuse stored hardware function id
Date:   Tue, 13 Apr 2021 12:29:59 -0700
Message-Id: <20210413193006.21650-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
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

