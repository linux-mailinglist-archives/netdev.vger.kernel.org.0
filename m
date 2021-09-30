Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD2541E4BC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350434AbhI3XXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350114AbhI3XWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F44B619F5;
        Thu, 30 Sep 2021 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044060;
        bh=lbtYy4D/Z7ghQyt1dGb8FX0R8ytwu+GbDbdOE4DVoxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cyl0blsJ+tvBM7g/bu0Y4zXf6PMWxrrdRRvS/sEfrtv/AsGSJDRJowQEwVJEx1atw
         ozUyGLWs1i89A3QHSuTfFFTn3g9BBpioO2+AmnpRSs0OzPG4TapHpVVO4ZR7Uw67R4
         7R1epK2n1b6zlg0iG6OtLDMyVI6D4wQ0oG/nIm5VzEWYwtPghidNGVSVQGB/3AWxBy
         YdOIhPheU7twsxHzgehJ2Tu9wKhdtbVIU9wkSarHyXsb3XZmRuwgdGh0O5j+wY1PDA
         fPxCUOMnRLPr/axnLfGwy22WVetuJecvcGkwPuLamdCfIF5apDNfZGXIncWU5hTq5U
         KKjAuNEFGh76g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Use kvcalloc() instead of kvzalloc()
Date:   Thu, 30 Sep 2021 16:20:48 -0700
Message-Id: <20210930232050.41779-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Use 2-factor argument form kvcalloc() instead of kvzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.31.1

