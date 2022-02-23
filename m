Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD894C2006
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244900AbiBWXkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245020AbiBWXkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA425C670;
        Wed, 23 Feb 2022 15:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D869C61A24;
        Wed, 23 Feb 2022 23:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B8C340F0;
        Wed, 23 Feb 2022 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659587;
        bh=8JnJOJwa0xLZJUZvZcQG78N7nZi1RKV+eoshHR+5zyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeEPMC1l6XNAC6MbMcu8NSs4LnOb4OkrcQOUnbtBryBPbqQmsL4IXVzq5XL4K7CTq
         WS/CUeLk+e3NtWZxGO3PDxrQaV8NbMZBm2yqRIafNe32HmWeJzmjfuPHl4P8VRcEAr
         BO/xHaJyHUM1MD6vtMh3lI5+loMmrtWB3XmqMi4Uf3Nua48R9qmVPUHd7+nA1qOFE5
         HbOZZPHpI2STBgRTjBiNJWZgbLfpA1gdMTyvAAQrrAB976he5Ws6Rw514VEYC1eB+N
         yuVn539te+fX1Zv3E6BNpqJGlXdF1xHCcSr7Z3rGmnJYn2g7h6p287RuGz4bnq1tDs
         K3+7uV2GSoGyQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 15/17] RDMA/mlx5: Use new command interface API
Date:   Wed, 23 Feb 2022 15:39:28 -0800
Message-Id: <20220223233930.319301-16-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

DEVX can now use mlx5_cmd_do() which will not intercept the command
execution status and will provide full information of the return code.

DEVX can now propagate the error code safely to upper layers, to
indicate to the callers if the command was actually executed and the
error code indicates the command execution status availability in
the command outbox buffer.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 55 ++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 1f62c0ede048..fc036b4794fd 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1055,7 +1055,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	int cmd_out_len = uverbs_attr_get_len(attrs,
 					MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT);
 	void *cmd_out;
-	int err;
+	int err, err2;
 	int uid;
 
 	c = devx_ufile2uctx(attrs);
@@ -1076,14 +1076,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_exec(dev->mdev, cmd_in,
-			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
-			    cmd_out, cmd_out_len);
-	if (err)
+	err = mlx5_cmd_do(dev->mdev, cmd_in,
+			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
+			  cmd_out, cmd_out_len);
+	if (err && err != -EREMOTEIO)
 		return err;
 
-	return uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT, cmd_out,
+	err2 = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT, cmd_out,
 			      cmd_out_len);
+
+	return err2 ?: err;
 }
 
 static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
@@ -1457,7 +1459,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct devx_obj *obj;
 	u16 obj_type = 0;
-	int err;
+	int err, err2 = 0;
 	int uid;
 	u32 obj_id;
 	u16 opcode;
@@ -1501,11 +1503,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 				     cmd_in, cmd_in_len, cmd_out,
 				     cmd_out_len);
 	} else {
-		err = mlx5_cmd_exec(dev->mdev, cmd_in,
-				    cmd_in_len,
-				    cmd_out, cmd_out_len);
+		err = mlx5_cmd_do(dev->mdev, cmd_in, cmd_in_len,
+				  cmd_out, cmd_out_len);
 	}
 
+	if (err == -EREMOTEIO)
+		err2 = uverbs_copy_to(attrs,
+				      MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT,
+				      cmd_out, cmd_out_len);
 	if (err)
 		goto obj_free;
 
@@ -1548,7 +1553,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 			      sizeof(out));
 obj_free:
 	kfree(obj);
-	return err;
+	return err2 ?: err;
 }
 
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
@@ -1563,7 +1568,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
 	void *cmd_out;
-	int err;
+	int err, err2;
 	int uid;
 
 	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
@@ -1586,14 +1591,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
-	err = mlx5_cmd_exec(mdev->mdev, cmd_in,
-			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
-			    cmd_out, cmd_out_len);
-	if (err)
+	err = mlx5_cmd_do(mdev->mdev, cmd_in,
+			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
+			  cmd_out, cmd_out_len);
+	if (err && err != -EREMOTEIO)
 		return err;
 
-	return uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_OUT,
+	err2 = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_OUT,
 			      cmd_out, cmd_out_len);
+
+	return err2 ?: err;
 }
 
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
@@ -1607,7 +1614,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	void *cmd_out;
-	int err;
+	int err, err2;
 	int uid;
 	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
 
@@ -1629,14 +1636,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_exec(mdev->mdev, cmd_in,
-			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
-			    cmd_out, cmd_out_len);
-	if (err)
+	err = mlx5_cmd_do(mdev->mdev, cmd_in,
+			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
+			  cmd_out, cmd_out_len);
+	if (err && err != -EREMOTEIO)
 		return err;
 
-	return uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_OUT,
+	err2 = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_OUT,
 			      cmd_out, cmd_out_len);
+
+	return err2 ?: err;
 }
 
 struct devx_async_event_queue {
-- 
2.35.1

