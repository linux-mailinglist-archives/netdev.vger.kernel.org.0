Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BB57A848
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiGSUfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbiGSUfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9661D42AED
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AA0E61999
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCBC341C6;
        Tue, 19 Jul 2022 20:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262936;
        bh=ynYev6bk8VduQUxFTQKhJ1SItkon99frjqPAoHn8uGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=he5EaQBOWKgjFVp/d2HSZrCz5j+3OaDikrvs8ZdzmRXq0UvYmYOzUqt0sqGAdWxfq
         3OdoDmhh1RHy/T8rNEquy5gmrdePmzMexfNc6b600mayna1MZDConUxvgJTBjKw2dk
         EEF1eTLELWIJp9PNufKqWJzVBuHK3OHvESj6dxahuxCFoP47e2EZ1poUS8QZ7Es91q
         ItnvzMYx6i6neAM9NrqzFV1KvRJm+ttlOruLMsJ0uP+rAtRspmsFsgEiaRM+JuYngL
         LTeyZm+oHi4TYBGhJiTe/n2dGVyrvS95pkZJdWbg0/HAZjmPmchqmWsGpM7u40VX5j
         yoEtOxWPrjBDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Moshe Tal <moshet@nvidia.com>
Subject: [net-next V2 02/13] net/mlx5e: Fix mqprio_rl handling on devlink reload
Date:   Tue, 19 Jul 2022 13:35:18 -0700
Message-Id: <20220719203529.51151-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Keep mqprio_rl data to params and restore the configuration in case of
devlink reload.
Change the location of mqprio_rl resources cleanup so it will be done
also in reload flow.

Also, remove the rl pointer from the params, since this is dynamic object
and saved to priv.

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 144 +++++++++++++-----
 2 files changed, 106 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index da10061d0c03..5c88c3896b96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -321,7 +321,8 @@ struct mlx5e_params {
 		u8 num_tc;
 		struct netdev_tc_txq tc_to_txq[TC_MAX_QUEUE];
 		struct {
-			struct mlx5e_mqprio_rl *rl;
+			u64 max_rate[TC_MAX_QUEUE];
+			u32 hw_id[TC_MAX_QUEUE];
 		} channel;
 	} mqprio;
 	bool rx_cqe_compress_def;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cac4022ba7f3..fe07180a957a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1912,8 +1912,7 @@ static int mlx5e_txq_get_qos_node_hw_id(struct mlx5e_params *params, int txq_ix,
 {
 	int tc;
 
-	if (params->mqprio.mode != TC_MQPRIO_MODE_CHANNEL ||
-	    !params->mqprio.channel.rl) {
+	if (params->mqprio.mode != TC_MQPRIO_MODE_CHANNEL) {
 		*hw_id = 0;
 		return 0;
 	}
@@ -1922,7 +1921,14 @@ static int mlx5e_txq_get_qos_node_hw_id(struct mlx5e_params *params, int txq_ix,
 	if (tc < 0)
 		return tc;
 
-	return mlx5e_mqprio_rl_get_node_hw_id(params->mqprio.channel.rl, tc, hw_id);
+	if (tc >= params->mqprio.num_tc) {
+		WARN(1, "Unexpected TCs configuration. tc %d is out of range of %u",
+		     tc, params->mqprio.num_tc);
+		return -EINVAL;
+	}
+
+	*hw_id = params->mqprio.channel.hw_id[tc];
+	return 0;
 }
 
 static int mlx5e_open_sqs(struct mlx5e_channel *c,
@@ -2615,13 +2621,6 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 		netdev_warn(netdev, "netif_set_real_num_rx_queues failed, %d\n", err);
 		goto err_txqs;
 	}
-	if (priv->mqprio_rl != priv->channels.params.mqprio.channel.rl) {
-		if (priv->mqprio_rl) {
-			mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
-			mlx5e_mqprio_rl_free(priv->mqprio_rl);
-		}
-		priv->mqprio_rl = priv->channels.params.mqprio.channel.rl;
-	}
 
 	return 0;
 
@@ -3135,6 +3134,11 @@ int mlx5e_create_tises(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 {
+	if (priv->mqprio_rl) {
+		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+		mlx5e_mqprio_rl_free(priv->mqprio_rl);
+		priv->mqprio_rl = NULL;
+	}
 	mlx5e_destroy_tises(priv);
 }
 
@@ -3203,19 +3207,38 @@ static void mlx5e_params_mqprio_dcb_set(struct mlx5e_params *params, u8 num_tc)
 {
 	params->mqprio.mode = TC_MQPRIO_MODE_DCB;
 	params->mqprio.num_tc = num_tc;
-	params->mqprio.channel.rl = NULL;
 	mlx5e_mqprio_build_default_tc_to_txq(params->mqprio.tc_to_txq, num_tc,
 					     params->num_channels);
 }
 
+static void mlx5e_mqprio_rl_update_params(struct mlx5e_params *params,
+					  struct mlx5e_mqprio_rl *rl)
+{
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+		u32 hw_id = 0;
+
+		if (rl)
+			mlx5e_mqprio_rl_get_node_hw_id(rl, tc, &hw_id);
+		params->mqprio.channel.hw_id[tc] = hw_id;
+	}
+}
+
 static void mlx5e_params_mqprio_channel_set(struct mlx5e_params *params,
-					    struct tc_mqprio_qopt *qopt,
+					    struct tc_mqprio_qopt_offload *mqprio,
 					    struct mlx5e_mqprio_rl *rl)
 {
+	int tc;
+
 	params->mqprio.mode = TC_MQPRIO_MODE_CHANNEL;
-	params->mqprio.num_tc = qopt->num_tc;
-	params->mqprio.channel.rl = rl;
-	mlx5e_mqprio_build_tc_to_txq(params->mqprio.tc_to_txq, qopt);
+	params->mqprio.num_tc = mqprio->qopt.num_tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		params->mqprio.channel.max_rate[tc] = mqprio->max_rate[tc];
+
+	mlx5e_mqprio_rl_update_params(params, rl);
+	mlx5e_mqprio_build_tc_to_txq(params->mqprio.tc_to_txq, &mqprio->qopt);
 }
 
 static void mlx5e_params_mqprio_reset(struct mlx5e_params *params)
@@ -3241,6 +3264,12 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
 	err = mlx5e_safe_switch_params(priv, &new_params,
 				       mlx5e_num_channels_changed_ctx, NULL, true);
 
+	if (!err && priv->mqprio_rl) {
+		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+		mlx5e_mqprio_rl_free(priv->mqprio_rl);
+		priv->mqprio_rl = NULL;
+	}
+
 	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
 				    mlx5e_get_dcb_num_tc(&priv->channels.params));
 	return err;
@@ -3299,16 +3328,38 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static bool mlx5e_mqprio_rate_limit(struct tc_mqprio_qopt_offload *mqprio)
+static bool mlx5e_mqprio_rate_limit(u8 num_tc, u64 max_rate[])
 {
 	int tc;
 
-	for (tc = 0; tc < mqprio->qopt.num_tc; tc++)
-		if (mqprio->max_rate[tc])
+	for (tc = 0; tc < num_tc; tc++)
+		if (max_rate[tc])
 			return true;
 	return false;
 }
 
+static struct mlx5e_mqprio_rl *mlx5e_mqprio_rl_create(struct mlx5_core_dev *mdev,
+						      u8 num_tc, u64 max_rate[])
+{
+	struct mlx5e_mqprio_rl *rl;
+	int err;
+
+	if (!mlx5e_mqprio_rate_limit(num_tc, max_rate))
+		return NULL;
+
+	rl = mlx5e_mqprio_rl_alloc();
+	if (!rl)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5e_mqprio_rl_init(rl, mdev, num_tc, max_rate);
+	if (err) {
+		mlx5e_mqprio_rl_free(rl);
+		return ERR_PTR(err);
+	}
+
+	return rl;
+}
+
 static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 					 struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -3322,32 +3373,32 @@ static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	rl = NULL;
-	if (mlx5e_mqprio_rate_limit(mqprio)) {
-		rl = mlx5e_mqprio_rl_alloc();
-		if (!rl)
-			return -ENOMEM;
-		err = mlx5e_mqprio_rl_init(rl, priv->mdev, mqprio->qopt.num_tc,
-					   mqprio->max_rate);
-		if (err) {
-			mlx5e_mqprio_rl_free(rl);
-			return err;
-		}
-	}
+	rl = mlx5e_mqprio_rl_create(priv->mdev, mqprio->qopt.num_tc, mqprio->max_rate);
+	if (IS_ERR(rl))
+		return PTR_ERR(rl);
 
 	new_params = priv->channels.params;
-	mlx5e_params_mqprio_channel_set(&new_params, &mqprio->qopt, rl);
+	mlx5e_params_mqprio_channel_set(&new_params, mqprio, rl);
 
 	nch_changed = mlx5e_get_dcb_num_tc(&priv->channels.params) > 1;
 	preactivate = nch_changed ? mlx5e_num_channels_changed_ctx :
 		mlx5e_update_netdev_queues_ctx;
 	err = mlx5e_safe_switch_params(priv, &new_params, preactivate, NULL, true);
-	if (err && rl) {
-		mlx5e_mqprio_rl_cleanup(rl);
-		mlx5e_mqprio_rl_free(rl);
+	if (err) {
+		if (rl) {
+			mlx5e_mqprio_rl_cleanup(rl);
+			mlx5e_mqprio_rl_free(rl);
+		}
+		return err;
 	}
 
-	return err;
+	if (priv->mqprio_rl) {
+		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+		mlx5e_mqprio_rl_free(priv->mqprio_rl);
+	}
+	priv->mqprio_rl = rl;
+
+	return 0;
 }
 
 static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
@@ -5102,6 +5153,23 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	priv->rx_res = NULL;
 }
 
+static void mlx5e_set_mqprio_rl(struct mlx5e_priv *priv)
+{
+	struct mlx5e_params *params;
+	struct mlx5e_mqprio_rl *rl;
+
+	params = &priv->channels.params;
+	if (params->mqprio.mode != TC_MQPRIO_MODE_CHANNEL)
+		return;
+
+	rl = mlx5e_mqprio_rl_create(priv->mdev, params->mqprio.num_tc,
+				    params->mqprio.channel.max_rate);
+	if (IS_ERR(rl))
+		rl = NULL;
+	priv->mqprio_rl = rl;
+	mlx5e_mqprio_rl_update_params(params, rl);
+}
+
 static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 {
 	int err;
@@ -5112,6 +5180,7 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
+	mlx5e_set_mqprio_rl(priv);
 	mlx5e_dcbnl_initialize(priv);
 	return 0;
 }
@@ -5346,11 +5415,6 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		kfree(priv->htb.qos_sq_stats[i]);
 	kvfree(priv->htb.qos_sq_stats);
 
-	if (priv->mqprio_rl) {
-		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
-		mlx5e_mqprio_rl_free(priv->mqprio_rl);
-	}
-
 	memset(priv, 0, sizeof(*priv));
 }
 
-- 
2.36.1

