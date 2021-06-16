Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8DE3AA6B7
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhFPWmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhFPWmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10075613FE;
        Wed, 16 Jun 2021 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883228;
        bh=d6Nvp8CFbtJlZVKyUDorqHMbcgYl6GLqU1KYxPIyaoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4rf70ewoc7ww+S1botaOEC/NVeQLpM0CtBd2W/MNzF1vRlzJj+UWIKz3SqjsIXa7
         97ReFDqvRof3asZ6o7irGrOyxjKQcSoG2nfqvlh9oOq281VBJuJRUOWvZO2MA2zW/A
         ekoMb0QHAX4Yyg5pGL8iZ8Rq10T7clTpy5KonzVqFcGcYmc+/kbnosOmUuUBJOpzoM
         nWSyL3BTTZ2OnE5cWpOZ7cmbmV5eP7gIbFz0oVnH4466aS4qOqNKmbffxA+ZZAd5QW
         /fWJm4V8Az39NGuhkjuzm06wjCvMXyijTeUwoeEmPZ3LItg30Q+m52bOP0YNcbuaR9
         VdSPyy0sBpAsA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/8] net/mlx5: E-Switch, Allow setting GUID for host PF vport
Date:   Wed, 16 Jun 2021 15:40:11 -0700
Message-Id: <20210616224015.14393-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

E-switch should be able to set the GUID of host PF vport.
Currently it returns an error. This results in below error
when user attempts to configure MAC address of the PF of an
external controller.

$ devlink port function set pci/0000:03:00.0/196608 \
   hw_addr 00:00:00:11:22:33

mlx5_core 0000:03:00.0: mlx5_esw_set_vport_mac_locked:1876:(pid 6715):\
"Failed to set vport 0 node guid, err = -22.
RDMA_CM will not function properly for this VF."

Check for zero vport is no longer needed.

Fixes: 330077d14de1 ("net/mlx5: E-switch, Supporting setting devlink port function mac address")
Signed-off-by: Yuval Avnery <yuvalav@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 457ad42eaa2a..4c1440a95ad7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -465,8 +465,6 @@ int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
 	void *in;
 	int err;
 
-	if (!vport)
-		return -EINVAL;
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager))
 		return -EACCES;
 
-- 
2.31.1

