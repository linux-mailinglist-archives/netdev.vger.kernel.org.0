Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C37935FA3F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352224AbhDNSGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352037AbhDNSGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBAA061220;
        Wed, 14 Apr 2021 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423574;
        bh=fR0Ov1XxJ+iBicVQJwLSNovcfu+cDCusWup//waBNyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp5y7F/HQawQYDiqxt2U6t03l4kaY6c+Rq5gGEztq+5DtKmaCEkzhVwY1W4wS/lX9
         RgveF5aRkBnT9jD2/NdbVmaouI6ZvwSJ7W0lqGGcPJpi6+q1LE/fukQ1LYvYZquzBL
         QgPVaUq1+I74KKs+xTE53zalzVa5NoADVSLsjApfAGdagQQoRkzZXaXyf1Int0E8jy
         IY0Z+jXGyLfFFTti4PFayI9bDxoO6/x61gZkhknwhExmnI2HGnMXUcENyT9Wi5+wN9
         sCyXqxsNh6qEIPoUVVED/ujUdNe7kyxt0txyj+lw5Q/Nx7X1GAnIdU66N/xgS1gtlx
         O6Gu5ev6WAv3w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 04/16] net/mlx5: E-Switch Make cleanup sequence mirror of init
Date:   Wed, 14 Apr 2021 11:05:53 -0700
Message-Id: <20210414180605.111070-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
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

