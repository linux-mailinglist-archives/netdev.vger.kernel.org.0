Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62243AFCE5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFVGLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:11:51 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:40369 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhFVGLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:11:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UdHolaH_1624342164;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UdHolaH_1624342164)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Jun 2021 14:09:30 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] net/mlx5: Fix missing error code in mlx5_init_fs()
Date:   Tue, 22 Jun 2021 14:09:21 +0800
Message-Id: <1624342161-84389-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-ENOMEM' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:2973 mlx5_init_fs()
warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering").
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  - For the follow advice: https://lore.kernel.org/patchwork/patch/1446816/

 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 2cd7aea..b861745 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2969,8 +2969,11 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 		return err;
 
 	steering = kzalloc(sizeof(*steering), GFP_KERNEL);
-	if (!steering)
+	if (!steering) {
+		err = -ENOMEM;
 		goto err;
+	}
+
 	steering->dev = dev;
 	dev->priv.steering = steering;
 
-- 
1.8.3.1

