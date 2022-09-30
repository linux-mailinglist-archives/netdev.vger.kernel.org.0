Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5955F1005
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiI3Qaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiI3QaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:30:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C221CFC9
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DD4B82977
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B26C433C1;
        Fri, 30 Sep 2022 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555381;
        bh=V7LXggOMMiQHcR3mGp+CcY4VeeEl6lsuCxhqmpaNFgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axO9Yeh/ORirWUYmoClVyZ9tTmedUrQ6sxqy/7rK3Eh8DStr2akckSsLkxAGjkYd7
         kAtQv1E4QR2pLxrmXIeP2YF9/3EL5XQ74yzhGPZ+QI3PPlgeTNUcG71FJxwJR1pxQ8
         mmJyXOPYhwRZf3v4bzKFbtndCllUodP5AaFMDk8qFLV+fx53Lfeg0Yjis5I87EP8cW
         PoVmURnvGBkmWng1SH1W3h4RBc+bwxBR11/P94iywHQ4EMzuTwn7H3S8/BCqwmpsUX
         k+6PpDLr3Vr41f+CWeAUDnyjHO6azL1su2Yawwsa215wSo2e1amJynHLKeO3zSZMCb
         pysM4BlcQODig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 15/16] net/mlx5e: Introduce the mlx5e_flush_rq function
Date:   Fri, 30 Sep 2022 09:29:02 -0700
Message-Id: <20220930162903.62262-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Add a function to flush an RQ: clean up descriptors, release pages and
reset the RQ. This procedure is used by the recovery flow, and it will
also be used in a following commit to free some memory when switching a
channel to the XSK mode.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       | 23 +--------------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 28 ++++++++++++++++++-
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8e174a7f7c25..238307390400 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1097,7 +1097,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx);
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 2b946ae1d97f..5f6f95ad6888 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -134,34 +134,13 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 	return err;
 }
 
-static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
-{
-	struct net_device *dev = rq->netdev;
-	int err;
-
-	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
-		return err;
-	}
-	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
-	if (err) {
-		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
-		return err;
-	}
-
-	return 0;
-}
-
 static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 {
 	struct mlx5e_rq *rq = ctx;
 	int err;
 
 	mlx5e_deactivate_rq(rq);
-	mlx5e_free_rx_descs(rq);
-
-	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	err = mlx5e_flush_rq(rq, MLX5_RQC_STATE_ERR);
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6a0adda03463..129a0d678cce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -899,7 +899,7 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param)
 	return err;
 }
 
-int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
+static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
 
@@ -928,6 +928,32 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state)
 	return err;
 }
 
+static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+{
+	struct net_device *dev = rq->netdev;
+	int err;
+
+	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
+		return err;
+	}
+	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
+		return err;
+	}
+
+	return 0;
+}
+
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
+{
+	mlx5e_free_rx_descs(rq);
+
+	return mlx5e_rq_to_ready(rq, curr_state);
+}
+
 static int mlx5e_modify_rq_scatter_fcs(struct mlx5e_rq *rq, bool enable)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
-- 
2.37.3

