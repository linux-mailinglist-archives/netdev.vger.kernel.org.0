Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50BB35E710
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346477AbhDMTa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345572AbhDMTau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B4A9613D0;
        Tue, 13 Apr 2021 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342230;
        bh=fR0Ov1XxJ+iBicVQJwLSNovcfu+cDCusWup//waBNyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBXN/iAC3vKLTLzAyFA8RXTV+pPCoC49oo4y8d9F8/zHD7X5nDjLtFRdfV0Ia2AsV
         Rdmy1OrmYeb8P8v/DZs2YJjXQr2ydGKwMLzwXlTGezW95hDBXdR49imDOkK4tWMufD
         PTvYbC84Q58xcSfo0uv2RFfKvEs231niQo9EbdSjbVb+fXs49ToIhzS7Vw0QdMRYaL
         987djhMC7ngYwvK4zSYDryRrgD2sfbolTzcEkvDwrOYdAmyJAYDY2ktWnHXJWuXc4H
         ZL31ZTN5syLcNvC3nKNuaNNOc1j8+UPdfhjmX8CeXzshdsSZv8NhqCAi5xjepBj3CP
         lKcqiQd5k7OcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: E-Switch Make cleanup sequence mirror of init
Date:   Tue, 13 Apr 2021 12:29:54 -0700
Message-Id: <20210413193006.21650-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Make cleanup sequence mirror of init sequence for cleaning up reps
and freeing vports.

Also when reps initialization fails, there is no need to perform reps
cleanup.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b3bc82e419b6..9009574372fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1856,7 +1856,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 abort:
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
-	esw_offloads_cleanup_reps(esw);
 	kfree(esw->vports);
 	kfree(esw);
 	return err;
@@ -1871,7 +1870,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
-	esw_offloads_cleanup_reps(esw);
 	mutex_destroy(&esw->state_lock);
 	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
 	xa_destroy(&esw->offloads.vhca_map);
@@ -1879,6 +1877,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mlx5e_mod_hdr_tbl_destroy(&esw->offloads.mod_hdr);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
+	esw_offloads_cleanup_reps(esw);
 	kfree(esw->vports);
 	kfree(esw);
 }
-- 
2.30.2

