Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E935FA43
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352177AbhDNSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352094AbhDNSGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB5161177;
        Wed, 14 Apr 2021 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423576;
        bh=6ys1iXotX3jR+ial4+Pd66zwjd4yhmToN2dIGqC16+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWq2Wxioi+XSZUsIaIsnDXtAD4/I/ckRjY81IUpTIFvcmsSLdWe0HNXQm8PZuskLD
         xMelm1461HBdqsW6YeenYTYRiglO64t8+yX/RG0sKSwo062FWRLClioga/y0bMJglb
         MiXZR2dG05WUuGfxSK6V1TXEDQyVYyAs8hLbbvM8iOpApjULK0gzqQT61lbV551frN
         ooT8nwmSr/nmuwpcyi/U1SDgAvfBvZKyqT+asUWOEeBhbHfR0snYOwmtJjQRlsZHDz
         pefvIId9tjJZBgMSTUqMLOmHhfwq/XcN97efl+heO0//e8ay6DlRT+XSKR48roMQgE
         m+3CTmcpGd4SQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/16] net/mlx5: SF, Use device pointer directly
Date:   Wed, 14 Apr 2021 11:05:57 -0700
Message-Id: <20210414180605.111070-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

At many places in the code, device pointer is directly available. Make
use of it, instead of accessing it from the table.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index c9bddde04047..ec53c11c8344 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -67,8 +67,8 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 		goto exist_err;
 	}
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sw_id);
-	err = mlx5_cmd_alloc_sf(table->dev, hw_fn_id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, sw_id);
+	err = mlx5_cmd_alloc_sf(dev, hw_fn_id);
 	if (err)
 		goto err;
 
@@ -80,7 +80,7 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	return sw_id;
 
 vhca_err:
-	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 err:
 	table->sfs[i].allocated = false;
 exist_err:
@@ -93,8 +93,8 @@ static void _mlx5_sf_hw_id_free(struct mlx5_core_dev *dev, u16 id)
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
 
-	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, id);
-	mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
+	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 	table->sfs[id].allocated = false;
 	table->sfs[id].pending_delete = false;
 }
@@ -123,7 +123,7 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
 		goto err;
 	state = MLX5_GET(query_vhca_state_out, out, vhca_state_context.vhca_state);
 	if (state == MLX5_VHCA_STATE_ALLOCATED) {
-		mlx5_cmd_dealloc_sf(table->dev, hw_fn_id);
+		mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 		table->sfs[id].allocated = false;
 	} else {
 		table->sfs[id].pending_delete = true;
@@ -216,7 +216,7 @@ int mlx5_sf_hw_table_create(struct mlx5_core_dev *dev)
 		return 0;
 
 	table->vhca_nb.notifier_call = mlx5_sf_hw_vhca_event;
-	return mlx5_vhca_event_notifier_register(table->dev, &table->vhca_nb);
+	return mlx5_vhca_event_notifier_register(dev, &table->vhca_nb);
 }
 
 void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
@@ -226,7 +226,7 @@ void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
-	mlx5_vhca_event_notifier_unregister(table->dev, &table->vhca_nb);
+	mlx5_vhca_event_notifier_unregister(dev, &table->vhca_nb);
 	/* Dealloc SFs whose firmware event has been missed. */
 	mlx5_sf_hw_dealloc_all(table);
 }
-- 
2.30.2

