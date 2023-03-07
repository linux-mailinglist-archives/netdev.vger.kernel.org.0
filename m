Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA156AE3CF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCGPDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8269B81CEC;
        Tue,  7 Mar 2023 06:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E04160FD1;
        Tue,  7 Mar 2023 14:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31349C433D2;
        Tue,  7 Mar 2023 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200892;
        bh=0PZadUYB/E5SeTOy1fSopIrJfLVBsjfZqdiGiCj87h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvqZrDKP9sx65FG7Jalv+yIWY+NaYQkU+r4G3KAM4gc8QhmitGOErWVn/Y4bBm3me
         S6XYGpt83j7eKRzniqKEpp86IY2znvIFA0rDFMk7daS30b6Q+idHSc5LftQukIrGTO
         Xd6jZ18NyM0fLhshMhGUCYSboLQUo0JQxtY8urjRi7wQEZMqZbMQqGpv286BXEt4wP
         XRWDIP6KowlbJEnoyB58hQXgnfRU9F4z/9tfYyIMDd9WeG8bn5qPNxXfcRQLDsfRp1
         BTdS+ZNRS/NIGQSieVhWDmtZDD9d8wUTufCnnJcFdynV/fEoz27CQsJinEtsqkc19L
         m3CRoW5PKWjkA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 7/8] net/mlx5e: take into account device reconfiguration for xdp_features flag
Date:   Tue,  7 Mar 2023 15:54:04 +0100
Message-Id: <8857cb8138b33c8938782e2154a56b095d611d18.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
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

Take into account LRO and GRO configuration setting device xdp_features
flag. Moreover consider channel rq_wq_type enabling rx scatter-gatter
support in xdp_features flag.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
 4 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 88460b7796e5..4276c6eb6820 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1243,6 +1243,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
+void mlx5e_set_xdp_feature(struct net_device *netdev);
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 				       struct net_device *netdev,
 				       netdev_features_t features);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7708acc9b2ab..79fd21ecb9cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1985,6 +1985,7 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_params new_params;
+	int err;
 
 	if (enable) {
 		/* Checking the regular RQ here; mlx5e_validate_xsk_param called
@@ -2005,7 +2006,14 @@ static int set_pflag_rx_striding_rq(struct net_device *netdev, bool enable)
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ, enable);
 	mlx5e_set_rq_type(mdev, &new_params);
 
-	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);
+	if (err)
+		return err;
+
+	/* update XDP supported features */
+	mlx5e_set_xdp_feature(netdev);
+
+	return 0;
 }
 
 static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 76a9c5194a70..1b68dd2be2c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4004,6 +4004,30 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 	return 0;
 }
 
+void mlx5e_set_xdp_feature(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	bool ndo_xmit = test_bit(MLX5E_STATE_XDP_ACTIVE, &priv->state);
+	struct mlx5e_params *params = &priv->channels.params;
+	xdp_features_t val;
+
+	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
+		xdp_clear_features_flag(netdev);
+		return;
+	}
+
+	val = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+	      NETDEV_XDP_ACT_XSK_ZEROCOPY;
+	if (ndo_xmit)
+		val |= NETDEV_XDP_ACT_NDO_XMIT;
+	if (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) {
+		val |= NETDEV_XDP_ACT_RX_SG;
+		if (ndo_xmit)
+			val |= NETDEV_XDP_ACT_NDO_XMIT_SG;
+	}
+	xdp_set_features_flag(netdev, val);
+}
+
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	netdev_features_t oper_features = features;
@@ -4030,6 +4054,9 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 		return -EINVAL;
 	}
 
+	/* update XDP supported features */
+	mlx5e_set_xdp_feature(netdev);
+
 	return 0;
 }
 
@@ -4762,10 +4789,14 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 		bpf_prog_put(old_prog);
 
 	if (reset) {
-		if (prog)
-			xdp_features_set_redirect_target(netdev, true);
-		else
+		if (prog) {
+			bool xmit_sg;
+
+			xmit_sg = new_params.rq_wq_type == MLX5_WQ_TYPE_CYCLIC;
+			xdp_features_set_redirect_target(netdev, xmit_sg);
+		} else {
 			xdp_features_clear_redirect_target(netdev);
+		}
 	}
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state) || reset)
@@ -5163,13 +5194,10 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
 
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
-			       NETDEV_XDP_ACT_RX_SG;
-
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
 	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
+	mlx5e_set_xdp_feature(netdev);
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_macsec_build_netdev(priv);
 	mlx5e_ipsec_build_netdev(priv);
@@ -5241,6 +5269,9 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 
 	mlx5e_health_create_reporters(priv);
+	/* update XDP supported features */
+	mlx5e_set_xdp_feature(netdev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9b9203443085..43fd12fb87b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -747,6 +747,9 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
+	/* update XDP supported features */
+	mlx5e_set_xdp_feature(netdev);
+
 	/* CQ moderation params */
 	params->rx_dim_enabled = MLX5_CAP_GEN(mdev, cq_moderation);
 	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
-- 
2.39.2

