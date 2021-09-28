Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828E141B9C3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242999AbhI1WC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242626AbhI1WCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 18:02:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D5B6136F;
        Tue, 28 Sep 2021 22:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632866445;
        bh=CaN2PnlNMh9LsZR0N5tYAAay0l8HEHjBKEMkhUPznzQ=;
        h=Date:From:To:Cc:Subject:From;
        b=BKHBD8FnQdKH6wMU5ofemXpNnD0H52CNuPBjV2gTMiso9N74ACN+SEFCrslu3BQ6D
         c4Jx/ukbxWtFH5B8DKhJfeIAzcRkQAjJ8MQBVcTroeBKrifr0hITH00zum3dgqlri3
         XLtF6+y+2vcD6JFodrCWNXfaBJ0HBw14rTuArkbEn3+3l/Vol1WAk93HXdzvxrwWAP
         yRLfllZTK9Ixf6zOhuihp1ByRfRyhz/tchHuyexzSPCd5Z7HkonZg4ppaAvTm/b4aa
         yndxb8YIlc3Q5FIXUGmHbZGcVHWh3sy4eI5gQUR8BVID+StpFno958qgOJJrZ8aXiD
         tvLzGaJfZNPyg==
Date:   Tue, 28 Sep 2021 17:04:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] net/mlx5: Use kvcalloc() instead of kvzalloc()
Message-ID: <20210928220447.GA276861@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c              | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index db5dfff585c9..4dc3a822907a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -2058,7 +2058,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		return -EINVAL;
 	}
 
-	cmd->stats = kvzalloc(MLX5_CMD_OP_MAX * sizeof(*cmd->stats), GFP_KERNEL);
+	cmd->stats = kvcalloc(MLX5_CMD_OP_MAX, sizeof(*cmd->stats), GFP_KERNEL);
 	if (!cmd->stats)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0d461e38add3..4e1628f25265 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1009,7 +1009,7 @@ mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 	u16 vport_num;
 
 	num_vfs = esw->esw_funcs.num_vfs;
-	flows = kvzalloc(num_vfs * sizeof(*flows), GFP_KERNEL);
+	flows = kvcalloc(num_vfs, sizeof(*flows), GFP_KERNEL);
 	if (!flows)
 		return -ENOMEM;
 
@@ -1188,7 +1188,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 
 	peer_miss_rules_setup(esw, peer_dev, spec, &dest);
 
-	flows = kvzalloc(nvports * sizeof(*flows), GFP_KERNEL);
+	flows = kvcalloc(nvports, sizeof(*flows), GFP_KERNEL);
 	if (!flows) {
 		err = -ENOMEM;
 		goto alloc_flows_err;
-- 
2.27.0

