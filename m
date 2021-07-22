Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9CC3D216E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbhGVJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:17:54 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:44919 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231282AbhGVJRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 05:17:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UgbPx.s_1626947902;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UgbPx.s_1626947902)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Jul 2021 17:58:27 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()
Date:   Thu, 22 Jul 2021 17:58:16 +0800
Message-Id: <1626947897-73558-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value is missing in this code scenario, add the return value
'0' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:3083
mlx5_devlink_eswitch_inline_mode_set() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -For the follow advice: https://lore.kernel.org/patchwork/patch/1461601/

 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7579f34..6b0b629 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3079,8 +3079,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
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
1.8.3.1

