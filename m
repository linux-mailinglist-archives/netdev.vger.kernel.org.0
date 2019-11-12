Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764A5F8F44
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfKLMIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:10 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58212 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbfKLMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACC87Ue029866;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xACC87pJ004240;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xACC87Tr004239;
        Tue, 12 Nov 2019 14:08:07 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next 2/4] net/mlx5: Dump of fw_fatal use updated devlink binary interface
Date:   Tue, 12 Nov 2019 14:07:50 +0200
Message-Id: <1573560472-4187-3-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
References: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant code from fw_fatal reporter's dump callback. Use
updated devlink interface of binary fmsg pair which breaks the output
into chunks internally.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index e718170a80c3..d9f4e8c59c1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -555,7 +555,6 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 	return mlx5_health_try_recover(dev);
 }
 
-#define MLX5_CR_DUMP_CHUNK_SIZE 256
 static int
 mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 			    struct devlink_fmsg *fmsg, void *priv_ctx,
@@ -564,8 +563,6 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
 	u32 crdump_size = dev->priv.health.crdump_size;
 	u32 *cr_data;
-	u32 data_size;
-	u32 offset;
 	int err;
 
 	if (!mlx5_core_is_pf(dev))
@@ -586,20 +583,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 			goto free_data;
 	}
 
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, "crdump_data");
-	if (err)
-		goto free_data;
-	for (offset = 0; offset < crdump_size; offset += data_size) {
-		if (crdump_size - offset < MLX5_CR_DUMP_CHUNK_SIZE)
-			data_size = crdump_size - offset;
-		else
-			data_size = MLX5_CR_DUMP_CHUNK_SIZE;
-		err = devlink_fmsg_binary_put(fmsg, (char *)cr_data + offset,
-					      data_size);
-		if (err)
-			goto free_data;
-	}
-	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	err = devlink_fmsg_binary_pair_put(fmsg, "crdump_data", cr_data, crdump_size);
 
 free_data:
 	kvfree(cr_data);
-- 
2.14.1

