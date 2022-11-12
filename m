Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997C86268CF
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiKLKWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiKLKWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC1E21E14
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 174E260B91
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F23C433D6;
        Sat, 12 Nov 2022 10:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248520;
        bh=ufHGVLu8/XEhB1LMLk8OTZ64K922qkrBCvcE9sS45fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgplfyJxqRKVoANqKKHCAFmEtaohFU1AgkjaT5s0Xg+3dr5ogWNL81WUnVfDzBTky
         lDzE+RLXwSih4OHtLoCnpIEHdAOoCMZWODb9FJOetNtUW3gSi+XJZX9MNMAqa3paeQ
         nKQ8XjbXnnTK4qfKBMYGb5DL2iRmU4XO5UU8WK4bcSLprVqycacdyC4rgoge/i+7f5
         1Cw7EZduUPUscXoW0znHYv3lojmAsN8XUq2Nb9t3ZTa1t0HducXDmekRe3nCtAvs+h
         dQqoqKs5KWhiEwqucd1PkzF2Y4RnHvPyVCthxfUU4f7140xSTUH4of6xm0t+tK+WuY
         kkMz/GljmbPQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Move params kernel log print to probe function
Date:   Sat, 12 Nov 2022 02:21:40 -0800
Message-Id: <20221112102147.496378-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Params info print was meant to be printed on load.
With time, new calls to mlx5e_init_rq_type_params and
mlx5e_build_rq_params were added, mistakenly printing
the params once again.

Move the print to were it belongs, in mlx5e_probe.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 10 ----------
 .../net/ethernet/mellanox/mlx5/core/en/params.h    | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  1 +
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1a2de9bc6538..9ec9662d1d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -607,16 +607,6 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 	params->log_rq_mtu_frames = is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_RQ_SIZE :
 		MLX5E_PARAMS_DEFAULT_LOG_RQ_SIZE;
-
-	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d %s)\n",
-		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
-		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
-		       BIT(mlx5e_mpwqe_get_log_rq_size(mdev, params, NULL)) :
-		       BIT(params->log_rq_mtu_frames),
-		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
-		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS),
-		       MLX5_CAP_GEN(mdev, enhanced_cqe_compression) ?
-				       "enhanced" : "basic");
 }
 
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 034debd140bc..c9be6eb88012 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -154,4 +154,18 @@ int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 
+static inline void mlx5e_params_print_info(struct mlx5_core_dev *mdev,
+					   struct mlx5e_params *params)
+{
+	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d %s)\n",
+		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
+		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
+		       BIT(mlx5e_mpwqe_get_log_rq_size(mdev, params, NULL)) :
+		       BIT(params->log_rq_mtu_frames),
+		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
+		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS),
+		       MLX5_CAP_GEN(mdev, enhanced_cqe_compression) ?
+				       "enhanced" : "basic");
+};
+
 #endif /* __MLX5_EN_PARAMS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c462b76743b6..5df04e002589 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5955,6 +5955,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 
 	mlx5e_dcbnl_init_app(priv);
 	mlx5_uplink_netdev_set(mdev, netdev);
+	mlx5e_params_print_info(mdev, &priv->channels.params);
 	return 0;
 
 err_resume:
-- 
2.38.1

