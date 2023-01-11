Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82346653D0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbjAKFjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbjAKFiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A539C32
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3861361A1E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE38C433F0;
        Wed, 11 Jan 2023 05:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415054;
        bh=ku1Ww/Ek+f3xpdnY9ASCzuy/9VhUwVezH+hclS7WAdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjHT1YtFD8nI9LdsD2NkhoOFwt7X8VHpPhZhz+DbYoVrFEukk4a2lNFl2zNgEnZsF
         v4SOnPJyFBYQfbGTrEXVzCfBgAP9moj6M7a3NHu6y1ltT3Qnz8fXbMPu22hYyMYoRo
         WF+pCLVEIhvHX4Oz86xEshf23ZRchuC3hav0CXfIBVqpiuqwFOIQTOcIoDkKUVtOP6
         dItgRbGaac1OUDUt6cgDAadhv7F+B7KkgJraEbAsSwJizLZ0F68wobn7ioHMrXHnzH
         +/1qaGrTN+/qagNCmMaE1uG1AEFJX/aDP8kynE+ctLtnCZRcPUudKZrvY9WhtNfnPo
         kQ7IdvHjJ0JBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Add hairpin params structure
Date:   Tue, 10 Jan 2023 21:30:36 -0800
Message-Id: <20230111053045.413133-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

In preparation for downstream work to expose hairpin queues parameters,
introduce a hairpin parameters struct as part of the tc structure.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 52 +++++++++++++------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9af2aa2922f5..800442eaf9b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -71,6 +71,12 @@
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(18)
 
+struct mlx5e_hairpin_params {
+	struct mlx5_core_dev *mdev;
+	u32 num_queues;
+	u32 queue_size;
+};
+
 struct mlx5e_tc_table {
 	/* Protects the dynamic assignment of the t parameter
 	 * which is the nic tc root table.
@@ -93,6 +99,7 @@ struct mlx5e_tc_table {
 
 	struct mlx5_tc_ct_priv         *ct;
 	struct mapping_ctx             *mapping;
+	struct mlx5e_hairpin_params    hairpin_params;
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
@@ -1016,6 +1023,26 @@ static int mlx5e_hairpin_get_prio(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static void
+mlx5e_hairpin_params_init(struct mlx5e_hairpin_params *hairpin_params,
+			  struct mlx5_core_dev *mdev)
+{
+	u64 link_speed64;
+	u32 link_speed;
+
+	hairpin_params->mdev = mdev;
+	/* set hairpin pair per each 50Gbs share of the link */
+	mlx5e_port_max_linkspeed(mdev, &link_speed);
+	link_speed = max_t(u32, link_speed, 50000);
+	link_speed64 = link_speed;
+	do_div(link_speed64, 50000);
+	hairpin_params->num_queues = link_speed64;
+
+	hairpin_params->queue_size =
+		BIT(min_t(u32, 16 - MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(mdev),
+			  MLX5_CAP_GEN(mdev, log_max_hairpin_num_packets)));
+}
+
 static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow,
 				  struct mlx5e_tc_flow_parse_attr *parse_attr,
@@ -1027,8 +1054,6 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	struct mlx5_core_dev *peer_mdev;
 	struct mlx5e_hairpin_entry *hpe;
 	struct mlx5e_hairpin *hp;
-	u64 link_speed64;
-	u32 link_speed;
 	u8 match_prio;
 	u16 peer_id;
 	int err;
@@ -1081,21 +1106,16 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 		 hash_hairpin_info(peer_id, match_prio));
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
-	params.log_data_size = clamp_t(u8, 16,
-				       MLX5_CAP_GEN(priv->mdev, log_min_hairpin_wq_data_sz),
-				       MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
-	params.log_num_packets = params.log_data_size -
-				 MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(priv->mdev);
-	params.log_num_packets = min_t(u8, params.log_num_packets,
-				       MLX5_CAP_GEN(priv->mdev, log_max_hairpin_num_packets));
+	params.log_num_packets = ilog2(tc->hairpin_params.queue_size);
+	params.log_data_size =
+		clamp_t(u32,
+			params.log_num_packets +
+				MLX5_MPWRQ_MIN_LOG_STRIDE_SZ(priv->mdev),
+			MLX5_CAP_GEN(priv->mdev, log_min_hairpin_wq_data_sz),
+			MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
 
 	params.q_counter = priv->q_counter;
-	/* set hairpin pair per each 50Gbs share of the link */
-	mlx5e_port_max_linkspeed(priv->mdev, &link_speed);
-	link_speed = max_t(u32, link_speed, 50000);
-	link_speed64 = link_speed;
-	do_div(link_speed64, 50000);
-	params.num_channels = link_speed64;
+	params.num_channels = tc->hairpin_params.num_queues;
 
 	hp = mlx5e_hairpin_create(priv, &params, peer_ifindex);
 	hpe->hp = hp;
@@ -5217,6 +5237,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &tc->mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL, tc->post_act);
 
+	mlx5e_hairpin_params_init(&tc->hairpin_params, dev);
+
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
 						  &tc->netdevice_nb,
-- 
2.39.0

