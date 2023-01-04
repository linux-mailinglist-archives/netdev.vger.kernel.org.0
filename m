Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270C765CFD8
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjADJoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbjADJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:44:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7863E17E2D;
        Wed,  4 Jan 2023 01:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBC38B811A2;
        Wed,  4 Jan 2023 09:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B686C433EF;
        Wed,  4 Jan 2023 09:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672825431;
        bh=Op2JERKzmZzCPevSNgjIaXp8jj0NiWY8KOGd3KuVA+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bme/jEBfWTVAdo0e8Fhpb+vIfRmIPrXu3r2Cqkp2tfm7/5YB1QmgoY9CFOC9Yd3Jn
         3KeUW4hGWdXHGGIbGLghApp045XTgDriy6AeE7JJ6qCbgYZAYY9K51GESy7FNOnHF8
         gSjXAEHDLjZgWcQlfn9DDzgh6FtFFUiFFpyyYUtILPJ0II9FdvpTc1/kmXDodSLPEp
         yaKUzZqU49BhyXkUVf1q/78wEZvQDeXU/Ns/Qp3enAeWvz0K2CIjaehw4jUmiaoj+t
         9gTPTSRlqsYI0m3qk81bUGI4ftN5WF06kgVA4qat3GpFmRpg/70px9jbSm94W6owk/
         geRJ4QaTTtyOg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next v1 3/3] RDMA/mlx5: Print error syndrome in case of fatal QP errors
Date:   Wed,  4 Jan 2023 11:43:36 +0200
Message-Id: <edc794f622a33e4ee12d7f5d218d1a59aa7c6af5.1672821186.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672821186.git.leonro@nvidia.com>
References: <cover.1672821186.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

Print syndromes in case of fatal QP events. This is helpful for upper
level debugging, as there maybe no CQEs.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c  | 45 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/qp.h  |  2 +-
 drivers/infiniband/hw/mlx5/qpc.c |  4 ++-
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index b22d95b448ac..1bf15040d35a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -310,6 +310,44 @@ int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
 	return mlx5_ib_read_user_wqe_srq(srq, wqe_index, buffer, buflen, bc);
 }
 
+static void mlx5_ib_qp_err_syndrome(struct ib_qp *ibqp)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibqp->device);
+	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
+	struct mlx5_ib_qp *qp = to_mqp(ibqp);
+	void *pas_ext_union, *err_syn;
+	u32 *outb;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev->mdev, qpc_extension) ||
+	    !MLX5_CAP_GEN(dev->mdev, qp_error_syndrome))
+		return;
+
+	outb = kzalloc(outlen, GFP_KERNEL);
+	if (!outb)
+		return;
+
+	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
+				 true);
+	if (err)
+		goto out;
+
+	pas_ext_union =
+		MLX5_ADDR_OF(query_qp_out, outb, qp_pas_or_qpc_ext_and_pas);
+	err_syn = MLX5_ADDR_OF(qpc_extension_and_pas_list_in, pas_ext_union,
+			       qpc_data_extension.error_syndrome);
+
+	pr_err("%s/%d: QP %d error: %s (0x%x 0x%x 0x%x)\n",
+	       ibqp->device->name, ibqp->port, ibqp->qp_num,
+	       ib_wc_status_msg(
+		       MLX5_GET(cqe_error_syndrome, err_syn, syndrome)),
+	       MLX5_GET(cqe_error_syndrome, err_syn, vendor_error_syndrome),
+	       MLX5_GET(cqe_error_syndrome, err_syn, hw_syndrome_type),
+	       MLX5_GET(cqe_error_syndrome, err_syn, hw_error_syndrome));
+out:
+	kfree(outb);
+}
+
 static void mlx5_ib_handle_qp_event(struct work_struct *_work)
 {
 	struct mlx5_ib_qp_event_work *qpe_work =
@@ -350,6 +388,10 @@ static void mlx5_ib_handle_qp_event(struct work_struct *_work)
 		goto out;
 	}
 
+	if ((event.event == IB_EVENT_QP_FATAL) ||
+	    (event.event == IB_EVENT_QP_ACCESS_ERR))
+		mlx5_ib_qp_err_syndrome(ibqp);
+
 	ibqp->event_handler(&event, ibqp->qp_context);
 
 out:
@@ -4843,7 +4885,8 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!outb)
 		return -ENOMEM;
 
-	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen);
+	err = mlx5_core_qp_query(dev, &qp->trans_qp.base.mqp, outb, outlen,
+				 false);
 	if (err)
 		goto out;
 
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index fb2f4e030bb8..77f9b4a54816 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -20,7 +20,7 @@ int mlx5_core_qp_modify(struct mlx5_ib_dev *dev, u16 opcode, u32 opt_param_mask,
 int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp);
 int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct);
 int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
-		       u32 *out, int outlen);
+		       u32 *out, int outlen, bool qpc_ext);
 int mlx5_core_dct_query(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 			u32 *out, int outlen);
 
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 0d51b4c06c06..eeee18af36ed 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -507,12 +507,14 @@ void mlx5_cleanup_qp_table(struct mlx5_ib_dev *dev)
 }
 
 int mlx5_core_qp_query(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
-		       u32 *out, int outlen)
+		       u32 *out, int outlen, bool qpc_ext)
 {
 	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
 
 	MLX5_SET(query_qp_in, in, opcode, MLX5_CMD_OP_QUERY_QP);
 	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
+	MLX5_SET(query_qp_in, in, qpc_ext, qpc_ext);
+
 	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, outlen);
 }
 
-- 
2.38.1

