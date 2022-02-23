Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED2E4C201B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbiBWXkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbiBWXkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09A35BD29;
        Wed, 23 Feb 2022 15:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 775B6619EB;
        Wed, 23 Feb 2022 23:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DF7C340EB;
        Wed, 23 Feb 2022 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659585;
        bh=dgX7kW2GHWK/0UfO2HQA2udHDYinSiV9Dx2tlyfbrWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pbcx6MDa4VQRx/TlYBJ1mVEwIZf/CKuC/8bZW/TBglmbRC8U7LyOjGx9NtkxgWeEc
         Lc7B7kqzSpblbEVht4JUYMkBMhcK3Lzd5M9oQCp55IG3DrHe0qMrEHHLvvlrPimm1n
         O9PKkrqDK/L5tECTjpFoUXSOcSoFQP6iNePv0nBoBhvJbLNhb2AMa/xKDZcT88D0lT
         32ZLCZhB/GTVRn+N4fMXTs8AhO03pJ+LijAN8uDxps1Kc7SEiOtSNUzqhTpUKifsB4
         BUZir2w0p0s+/gF7893aMXzyg3WH6irMDeCUvfICmC4RtTDPv0XmofjzxAwGpMDF+D
         dc8guaaLJyDGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 13/17] net/mlx5: Use mlx5_cmd_do() in core create_{cq,dct}
Date:   Wed, 23 Feb 2022 15:39:26 -0800
Message-Id: <20220223233930.319301-14-saeed@kernel.org>
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

mlx5_core_create_{cq/dct} functions are non-trivial mlx5 commands
functions. They check command execution status themselves and hide
valuable FW failure information.

For mlx5_core/eth kernel user this is what we actually want, but for a
devx/rdma user the hidden information is essential and should be propagated
up to the caller, thus we convert these commands to use mlx5_cmd_do
to return the FW/driver and command outbox status as is, and let the caller
decide what to do with it.

For kernel callers of mlx5_core_create_{cq/dct} or those who only care about
the binary status (FAIL/SUCCESS) they must check status themselves via
mlx5_cmd_check() to restore the current behavior.

err = mlx5_create_cq(in, out)
err = mlx5_cmd_check(err, in, out)
if (err)
    // handle err

For DEVX users and those who care about full visibility, They will just
propagate the error to user space, and app can check if err == -EREMOTEIO,
then outbox.{status,syndrome} are valid.

API Note:
mlx5_cmd_check() must be used by kernel users since it allows the driver
to intercept the command execution status and return a driver simulated
status in case of driver induced error handling or reset/recovery flows.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c            |  6 +++---
 drivers/infiniband/hw/mlx5/qp.c              |  1 +
 drivers/infiniband/hw/mlx5/qpc.c             |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c | 17 ++++++++++++++---
 include/linux/mlx5/cq.h                      |  2 ++
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 08b7f6bc56c3..1f62c0ede048 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1497,9 +1497,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		   !is_apu_cq(dev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
-		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
-					  cmd_in, cmd_in_len, cmd_out,
-					  cmd_out_len);
+		err = mlx5_create_cq(dev->mdev, &obj->core_cq,
+				     cmd_in, cmd_in_len, cmd_out,
+				     cmd_out_len);
 	} else {
 		err = mlx5_cmd_exec(dev->mdev, cmd_in,
 				    cmd_in_len,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 29475cf8c7c3..b7fe47107d76 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4465,6 +4465,7 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		err = mlx5_core_create_dct(dev, &qp->dct.mdct, qp->dct.in,
 					   MLX5_ST_SZ_BYTES(create_dct_in), out,
 					   sizeof(out));
+		err = mlx5_cmd_check(dev->mdev, err, qp->dct.in, out);
 		if (err)
 			return err;
 		resp.dctn = qp->dct.mdct.mqp.qpn;
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 8844eacf2380..542e4c63a8de 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -220,7 +220,7 @@ int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 	init_completion(&dct->drained);
 	MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
 
-	err = mlx5_cmd_exec(dev->mdev, in, inlen, out, outlen);
+	err = mlx5_cmd_do(dev->mdev, in, inlen, out, outlen);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 5371ad0a12eb..15a74966be7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -86,8 +86,9 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
 	spin_unlock_irqrestore(&tasklet_ctx->lock, flags);
 }
 
-int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-			u32 *in, int inlen, u32 *out, int outlen)
+/* Callers must verify outbox status in case of err */
+int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
+		   u32 *in, int inlen, u32 *out, int outlen)
 {
 	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
 			   c_eqn_or_apu_element);
@@ -101,7 +102,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 
 	memset(out, 0, outlen);
 	MLX5_SET(create_cq_in, in, opcode, MLX5_CMD_OP_CREATE_CQ);
-	err = mlx5_cmd_exec(dev, in, inlen, out, outlen);
+	err = mlx5_cmd_do(dev, in, inlen, out, outlen);
 	if (err)
 		return err;
 
@@ -148,6 +149,16 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	mlx5_cmd_exec_in(dev, destroy_cq, din);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_create_cq);
+
+/* oubox is checked and err val is normalized */
+int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
+			u32 *in, int inlen, u32 *out, int outlen)
+{
+	int err = mlx5_create_cq(dev, cq, in, inlen, out, outlen);
+
+	return mlx5_cmd_check(dev, err, in, out);
+}
 EXPORT_SYMBOL(mlx5_core_create_cq);
 
 int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 7bfb67363434..cb15308b5cb0 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -183,6 +183,8 @@ static inline void mlx5_cq_put(struct mlx5_core_cq *cq)
 		complete(&cq->free);
 }
 
+int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
+		   u32 *in, int inlen, u32 *out, int outlen);
 int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 			u32 *in, int inlen, u32 *out, int outlen);
 int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq);
-- 
2.35.1

