Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90ACE6B9D70
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCNRuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCNRtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C219F214
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED65AB81ACE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E3BC4339B;
        Tue, 14 Mar 2023 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816189;
        bh=c+HaQL51oJQvghVeleuw0yeB5QuswoB+7i0XylQ3c5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNZSfMRYlb9C8NXrVUzN7nt2mNzhPGn6wj+2dnKQnQOsovKh0fFQLbISUqGS5yABz
         3YzTVI0B8KY0jHBD90OpHD6hamHK1nJ2DhQXWQqvrTw8UnR0ckbG4Dm80cXisPrf9P
         h4Js8spcgKlYdSqtBseDY9AjRtefdfzC5GI5AmgC9rfgj8xD4sXYPOCF4v1u1gItIc
         KG08q1A56AhlYwcrpvFhmSJyvSlIhib336TihjoQCQ3MfE2kQQCZwwSS8djniv4zHP
         60zhk9Kjc3+tB5Ka0sBcvmGZTwCLVLA+2DHwDEA85anf5ZETSFZp9tsxTEMM0xIdlC
         43+MSXkjEoyQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: [net 02/14] net/mlx5e: Don't cache tunnel offloads capability
Date:   Tue, 14 Mar 2023 10:49:28 -0700
Message-Id: <20230314174940.62221-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

From: Parav Pandit <parav@nvidia.com>

When mlx5e attaches again after device health recovery, the device
capabilities might have changed by the eswitch manager.

For example in one flow when ECPF changes the eswitch mode between
legacy and switchdev, it updates the flow table tunnel capability.

The cached value is only used in one place, so just check the capability
there instead.

Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h          | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 1 -
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4276c6eb6820..4a19ef4a9811 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -313,7 +313,6 @@ struct mlx5e_params {
 		} channel;
 	} mqprio;
 	bool rx_cqe_compress_def;
-	bool tunneled_offload_en;
 	struct dim_cq_moder rx_cq_moderation;
 	struct dim_cq_moder tx_cq_moderation;
 	struct mlx5e_packet_merge_param packet_merge;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 51b5f3cca504..56fc2aebb9ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4979,8 +4979,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* TX inline */
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 
-	params->tunneled_offload_en = mlx5_tunnel_inner_ft_supported(mdev);
-
 	/* AF_XDP */
 	params->xsk = xsk;
 
@@ -5285,7 +5283,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	}
 
 	features = MLX5E_RX_RES_FEATURE_PTP;
-	if (priv->channels.params.tunneled_offload_en)
+	if (mlx5_tunnel_inner_ft_supported(mdev))
 		features |= MLX5E_RX_RES_FEATURE_INNER_FT;
 	err = mlx5e_rx_res_init(priv->rx_res, priv->mdev, features,
 				priv->max_nch, priv->drop_rq.rqn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 43fd12fb87b8..8ff654b4e9e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -755,7 +755,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
 
 	params->mqprio.num_tc       = 1;
-	params->tunneled_offload_en = false;
 	if (rep->vport != MLX5_VPORT_UPLINK)
 		params->vlan_strip_disable = true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index c2a4f86bc890..baa7ef812313 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -70,7 +70,6 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
-	params->tunneled_offload_en = false;
 
 	/* CQE compression is not supported for IPoIB */
 	params->rx_cqe_compress_def = false;
-- 
2.39.2

