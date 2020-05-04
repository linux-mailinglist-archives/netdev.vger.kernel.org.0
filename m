Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8B1C3495
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEDIhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:37:05 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48533 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726796AbgEDIhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:37:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 May 2020 11:36:59 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0448axR7020198;
        Mon, 4 May 2020 11:36:59 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH net] net/mlx4_core: Fix use of ENOSPC around mlx4_counter_alloc()
Date:   Mon,  4 May 2020 11:36:02 +0300
Message-Id: <20200504083602.19947-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ENOSPC is set the idx is still valid and gets set to the global
MLX4_SINK_COUNTER_INDEX.  However gcc's static analysis cannot tell that
ENOSPC is impossible from mlx4_cmd_imm() and gives this warning:

drivers/net/ethernet/mellanox/mlx4/main.c:2552:28: warning: 'idx' may be
used uninitialized in this function [-Wmaybe-uninitialized]
 2552 |    priv->def_counter[port] = idx;

Also, when ENOSPC is returned mlx4_allocate_default_counters should not
fail.

Fixes: 6de5f7f6a1fa ("net/mlx4_core: Allocate default counter per port")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 5716c3d2bb86..c72c4e1ea383 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2550,6 +2550,7 @@ static int mlx4_allocate_default_counters(struct mlx4_dev *dev)
 
 		if (!err || err == -ENOSPC) {
 			priv->def_counter[port] = idx;
+			err = 0;
 		} else if (err == -ENOENT) {
 			err = 0;
 			continue;
@@ -2600,7 +2601,8 @@ int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx, u8 usage)
 				   MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
 		if (!err)
 			*idx = get_param_l(&out_param);
-
+		if (WARN_ON(err == -ENOSPC))
+			err = -EINVAL;
 		return err;
 	}
 	return __mlx4_counter_alloc(dev, idx);
-- 
2.21.0

