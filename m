Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB61752B2BB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiERGud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiERGuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CF622BF5
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59725B81E9A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10EAC385A5;
        Wed, 18 May 2022 06:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856594;
        bh=nxQEF5haUmobTA7ypDS7XBt816FxjZE7Ek6VyblsUdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGMJt+w8INbJm4ZBI3qy1AbbzxFqMwhLFbhf0BJuXGjkuM6Bneqwk7L3y2hYqhbBF
         3i8KBCHk2M59Px7//4V/6Fz5ql6BFF/DFmgfK+aQAFLPrSJFyenl+Y13uJQfa29cyY
         ZYOSmGfrtxWGLFtaMKhGFEEoqACtWhKaptvfYJvEL0cP9uNaFmrXAww12f5DeH7f2e
         8WDMwNMXqdy+GZAsQOVh1wqWTllbR5zarVTHjTQp0zgY3R6sXIwg3yIe+na5OyMdZx
         XQ3SVysUGOT0ftO3IUWDKMyq1Qvpo91kd6V4yk571U2CGelj7CKIHTXCmb+DSZrPZv
         bhnMID1C31bZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5e: Correct the calculation of max channels for rep
Date:   Tue, 17 May 2022 23:49:34 -0700
Message-Id: <20220518064938.128220-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Correct the calculation of maximum channels of rep to better utilize
the hardware resources and allow a larger scale of reps.

This will allow creation of all virtual ports configured.

Fixes: 473baf2e9e8c ("net/mlx5e: Allow profile-specific limitation on max num of channels")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 10 ++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b90902db7819..65d3c4865abf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1220,6 +1220,7 @@ mlx5e_tx_mpwqe_supported(struct mlx5_core_dev *mdev)
 		MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe);
 }
 
+int mlx5e_get_pf_num_tirs(struct mlx5_core_dev *mdev);
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    const struct mlx5e_profile *profile,
 		    struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 29e1e1f8f49e..6816a024db8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5221,6 +5221,15 @@ mlx5e_calc_max_nch(struct mlx5_core_dev *mdev, struct net_device *netdev,
 	return max_nch;
 }
 
+int mlx5e_get_pf_num_tirs(struct mlx5_core_dev *mdev)
+{
+	/* Indirect TIRS: 2 sets of TTCs (inner + outer steering)
+	 * and 1 set of direct TIRS
+	 */
+	return 2 * MLX5E_NUM_INDIR_TIRS
+		+ mlx5e_profile_max_num_channels(mdev, &mlx5e_nic_profile);
+}
+
 /* mlx5e generic netdev management API (move to en_common.c) */
 int mlx5e_priv_init(struct mlx5e_priv *priv,
 		    const struct mlx5e_profile *profile,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ce3b9e65c808..aa32b1062f7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -604,10 +604,16 @@ bool mlx5e_eswitch_vf_rep(const struct net_device *netdev)
 	return netdev->netdev_ops == &mlx5e_netdev_ops_rep;
 }
 
+/* One indirect TIR set for outer. Inner not supported in reps. */
+#define REP_NUM_INDIR_TIRS MLX5E_NUM_INDIR_TIRS
+
 static int mlx5e_rep_max_nch_limit(struct mlx5_core_dev *mdev)
 {
-	return (1 << MLX5_CAP_GEN(mdev, log_max_tir)) /
-		mlx5_eswitch_get_total_vports(mdev);
+	int max_tir_num = 1 << MLX5_CAP_GEN(mdev, log_max_tir);
+	int num_vports = mlx5_eswitch_get_total_vports(mdev);
+
+	return (max_tir_num - mlx5e_get_pf_num_tirs(mdev)
+		- (num_vports * REP_NUM_INDIR_TIRS)) / num_vports;
 }
 
 static void mlx5e_build_rep_params(struct net_device *netdev)
-- 
2.36.1

