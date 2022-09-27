Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F635ECEBE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiI0Uhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiI0Ug5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A1360694
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED1D5B81D5B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D60FC433D6;
        Tue, 27 Sep 2022 20:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311012;
        bh=bZrdONlVEeUYsU4QBAMR8MBNaEC73xr0n/mgbE3mDsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMeiawyo29etBbfwVOv6YLcREsRKOZ685CzD3An1h++bAotz24faXyx6f8ss3sVT4
         Md8ooohZrppylYozpD6PxU2388+iFTjbECAZW8NSq6lluUEBOhmsJHoAG4PfJ/mZEA
         kgisnjEY34LlkMcWOb3Rtpe639YCqfMDF6wRoat8ALXRMygBSA1NOvCIsDXP/hwruf
         J9BAG9d1+M0DtWLe/YThm+LfPojuKGSoIh+eWSNQ+H8IBx+nr7Td2XbqQvmhwM1YMm
         UCg1kQgogp+5VA/hUNRIQ1oWcQNQK6t4GWVnqIwks7atGi6GI0Ny4+JHK9fqRMpuHu
         RP7MHJESQcXvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 14/16] net/mlx5e: Improve the MTU change shortcut
Date:   Tue, 27 Sep 2022 13:36:09 -0700
Message-Id: <20220927203611.244301-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
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

Normally, the MTU change requires reopening the channels, but it can be
skipped if the new MTU doesn't change any of the queue parameters and if
MTU is not used in the data path.

The shortcut is applicable to the non-linear mode of striding RQ,
because the only thing affected by MTU is the queue length. As ethtool
sets the queue length in packets, but striding RQ length is defined in
strides or bytes, we estimate the RQ length to be at least as big as the
requested number of MTU-sized packets, that's why it depends on MTU.

Improve the shortcut by actually checking whether the RQ length stayed
the same, instead of an intermediate step in the calculation.

As MTU also affects the SHAMPO parameters, skip the shortcut if SHAMPO
is in use.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 10 ++++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5dd3567d02d8..9a58f8f978b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -57,8 +57,8 @@ static u32 mlx5e_rx_get_linear_stride_sz(struct mlx5e_params *params,
 	return roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params, false));
 }
 
-u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
-				struct mlx5e_xsk_param *xsk)
+static u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
+				       struct mlx5e_xsk_param *xsk)
 {
 	u32 linear_stride_sz = mlx5e_rx_get_linear_stride_sz(params, xsk);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 3e148a00fa73..f2c1a23dca61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -101,8 +101,6 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *
 
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
-u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
-				struct mlx5e_xsk_param *xsk);
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk);
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f8d45360a643..a38f0c6f06d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4080,19 +4080,21 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	if (params->packet_merge.type == MLX5E_PACKET_MERGE_LRO)
 		reset = false;
 
-	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
+	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ &&
+	    params->packet_merge.type != MLX5E_PACKET_MERGE_SHAMPO) {
 		bool is_linear_old = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev, params, NULL);
 		bool is_linear_new = mlx5e_rx_mpwqe_is_linear_skb(priv->mdev,
 								  &new_params, NULL);
-		u8 ppw_old = mlx5e_mpwqe_log_pkts_per_wqe(params, NULL);
-		u8 ppw_new = mlx5e_mpwqe_log_pkts_per_wqe(&new_params, NULL);
+		u8 sz_old = mlx5e_mpwqe_get_log_rq_size(params, NULL);
+		u8 sz_new = mlx5e_mpwqe_get_log_rq_size(&new_params, NULL);
 
 		/* Always reset in linear mode - hw_mtu is used in data path.
 		 * Check that the mode was non-linear and didn't change.
 		 * If XSK is active, XSK RQs are linear.
+		 * Reset if the RQ size changed, even if it's non-linear.
 		 */
 		if (!is_linear_old && !is_linear_new && !priv->xsk.refcnt &&
-		    ppw_old == ppw_new)
+		    sz_old == sz_new)
 			reset = false;
 	}
 
-- 
2.37.3

