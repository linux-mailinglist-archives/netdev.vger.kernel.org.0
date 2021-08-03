Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00073DE466
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhHCC3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233776AbhHCC3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F27F361038;
        Tue,  3 Aug 2021 02:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957747;
        bh=qvcJqk2exn5eTqtpGAWWSkqkFkwKIzOO7a+8yFiIQHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MB0D/ve1tn6psTB9GossCymE1UwHxMz9fzBkKk6UqkzVTpPwhTr4TZ2TxvIj6puUI
         kxZTWXepmjyQO/LVPuDENgSkBwM4aJpVx7PgZ/3KipYEpS/bSVRbunVaZNEBK2rl97
         2xLb/TNlPYeTBwUyWhEsvGFwhGNV1a0iuTCT5I64E4e53bTQ2VqvzuBwfLOeaUnj//
         AboEiyjUCna5fqSiOPDknDtl59FocGGQ2o/0qJUfwwaAUPbSWMLo4Ej7BFu+LNLW+D
         pGLUduGCcEJLRyMozGIqc5rmK/4jBsT+Dug+At9O4XXCJPv79w/iyTbQdtVmZXKjxw
         B6Y3rOH5ZJ20A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()
Date:   Mon,  2 Aug 2021 19:28:53 -0700
Message-Id: <20210803022853.106973-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

The return value is missing in this code scenario, add the return value
'0' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 011e766e4f67..feecf44994a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3083,8 +3083,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
-		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
+		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE) {
+			err = 0;
 			goto out;
+		}
+
 		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
-- 
2.31.1

