Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4B5ECEB4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiI0UhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiI0Ugr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158974D274
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB63B81D42
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548A4C433C1;
        Tue, 27 Sep 2022 20:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311003;
        bh=SEDq/lcMeWsEwlGEUqjSg26Mtc0BH+hjU630I9XZrKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjhG+AE4nN77gIQDXt1LAW9DF8ycXANQjpbu/yOU8JU3kCgyqCqUnFGQYvJWWbdVt
         xla1tDoFmw8urlTHuyUgMQYCNOfniJQ6LHJI+InQHYSpRAgTHV1xLvpTsw0JcedSAw
         ILZ6bHhKVbOoaWMgtj5ZRKrS3oUZ4THOM+Urp6ljCAT/TGYSCKt5W9rHQO380e66qt
         gYHxnjAQmSEub6uwBjZx+BQThIofbL4fFWTevfBSbTdT1MpyL51iYg5aLbpHlc0TZp
         Rl6GpDy3tj/7uo8v258h/drzYsEPurHOljWqaz3KWRgs17DclNbKUfVZUSHEY2Hoqy
         7BZZ6fiNw0XrA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 05/16] net/mlx5e: Validate striding RQ before enabling XDP
Date:   Tue, 27 Sep 2022 13:36:00 -0700
Message-Id: <20220927203611.244301-6-saeed@kernel.org>
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

Currently, the driver can silently fall back to legacy RQ after enabling
XDP, even if striding RQ was active before. It happens when PAGE_SIZE is
bigger than the maximum supported stride size. This commit changes this
behavior to more straightforward: if an operation (enabling XDP) doesn't
support the current parameters (striding RQ mode), it fails.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 34 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en/params.h   |  4 ++-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 12 ++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 16 +++++++--
 5 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 8b54fec04fef..2be09cc3c437 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -320,22 +320,27 @@ bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
 		link_speed > MLX5E_SLOW_PCI_RATIO * pci_bw;
 }
 
-bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
-				struct mlx5e_params *params)
+int mlx5e_mpwrq_validate_regular(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
-		return false;
+		return -EOPNOTSUPP;
 
-	if (params->xdp_prog) {
-		/* XSK params are not considered here. If striding RQ is in use,
-		 * and an XSK is being opened, mlx5e_rx_mpwqe_is_linear_skb will
-		 * be called with the known XSK params.
-		 */
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-			return false;
-	}
+	if (params->xdp_prog && !mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
+		return -EINVAL;
+
+	return 0;
+}
 
-	return true;
+int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk)
+{
+	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
+		return -EOPNOTSUPP;
+
+	if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
+		return -EINVAL;
+
+	return 0;
 }
 
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
@@ -356,8 +361,7 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
-	params->rq_wq_type = mlx5e_striding_rq_possible(mdev, params) &&
-		MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
+	params->rq_wq_type = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
 		MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ :
 		MLX5_WQ_TYPE_CYCLIC;
 }
@@ -374,7 +378,7 @@ void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
 	 */
 	if ((!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS) ||
 	     MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index)) &&
-	    mlx5e_striding_rq_possible(mdev, params) &&
+	    !mlx5e_mpwrq_validate_regular(mdev, params) &&
 	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ||
 	     !mlx5e_rx_is_linear_skb(params, NULL)))
 		MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ, true);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 3cc1c6b16444..6e86cbfc7b58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -92,7 +92,9 @@ void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
 void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
 
 bool slow_pci_heuristic(struct mlx5_core_dev *mdev);
-bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+int mlx5e_mpwrq_validate_regular(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk);
 void mlx5e_build_rq_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 98ed9ef3a6bd..0b3c9f10b597 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -30,7 +30,7 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 	 */
 	switch (params->rq_wq_type) {
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk);
+		return !mlx5e_mpwrq_validate_xsk(mdev, params, xsk);
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		return mlx5e_rx_is_linear_skb(params, xsk);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 29ed20abc3da..8ae5cff3361e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1997,10 +1997,14 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 	struct mlx5e_params new_params;
 
 	if (enable) {
-		if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
-			return -EOPNOTSUPP;
-		if (!mlx5e_striding_rq_possible(mdev, &priv->channels.params))
-			return -EINVAL;
+		/* Checking the regular RQ here; mlx5e_validate_xsk_param called
+		 * from mlx5e_open_xsk will check for each XSK queue, and
+		 * mlx5e_safe_switch_params will be reverted if any check fails.
+		 */
+		int err = mlx5e_mpwrq_validate_regular(mdev, &priv->channels.params);
+
+		if (err)
+			return err;
 	} else if (priv->channels.params.packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
 		netdev_warn(netdev, "Can't set legacy RQ with HW-GRO/LRO, disable them first\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47d0bd6ab98e..73ebb7ff4b26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4582,8 +4582,20 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
 	new_params = priv->channels.params;
 	new_params.xdp_prog = prog;
-	if (reset)
-		mlx5e_set_rq_type(priv->mdev, &new_params);
+
+	/* XDP affects striding RQ parameters. Block XDP if striding RQ won't be
+	 * supported with the new parameters: if PAGE_SIZE is bigger than
+	 * MLX5_MPWQE_LOG_STRIDE_SZ_MAX, striding RQ can't be used, even though
+	 * the MTU is small enough for the linear mode, because XDP uses strides
+	 * of PAGE_SIZE on regular RQs.
+	 */
+	if (reset && MLX5E_GET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
+		/* Checking for regular RQs here; XSK RQs were checked on XSK bind. */
+		err = mlx5e_mpwrq_validate_regular(priv->mdev, &new_params);
+		if (err)
+			goto unlock;
+	}
+
 	old_prog = priv->channels.params.xdp_prog;
 
 	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
-- 
2.37.3

