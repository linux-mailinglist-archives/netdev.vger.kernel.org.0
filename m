Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED657785A
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiGQVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiGQVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1747D10554
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6178C60A20
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B167AC341C0;
        Sun, 17 Jul 2022 21:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093743;
        bh=EvmDQES2sHGxw+De/DMZuHf1tF9sA/OvHBoI/DdrB6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhKll676gBNQUXb67c3EX58PAhi1ylxF5FSzRYzYmtSJh+qHW/m4qctrvMTwBK6cs
         RI1iQcEq8D51AhJhdgdu4zPJP2QTLFya4XeKuMIafnr00y74sZb80sEKeUBqY2/dss
         wx73ut9/E5b0IspfR85xYq/N8ggNrWXyF+yW0JJPK106bzdx2CR0n1n6TFwLxWu3Vv
         Ivmv7DqX7Tf7SS6bnaWgeVb9MXVbYItfq4h34105uqFsQaMd4lQhGNUOzJfWre4w1X
         JkCFKpwgZMmpiHfNFvlvwxOxv3JdR0z0UKlmvOcLBSm/i2kqXljKbKKlkd1jUavnGn
         qgaDm7JpA5OZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer counter
Date:   Sun, 17 Jul 2022 14:33:41 -0700
Message-Id: <20220717213352.89838-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Add the rx_oversize_pkts_buffer counter to ethtool statistics.
This counter exposes the number of dropped received packets due to
length which arrived to RQ and exceed software buffer size allocated by
the device for incoming traffic. It might imply that the device MTU is
larger than the software buffers size.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 21 ++++++++++++++++++-
 include/linux/mlx5/mlx5_ifc.h                 |  8 +++++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1e87bb2b7541..f3e1145a2bcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -641,17 +641,26 @@ static const struct counter_desc vnic_env_stats_dev_oob_desc[] = {
 		VNIC_ENV_OFF(vport_env.internal_rq_out_of_buffer) },
 };
 
+static const struct counter_desc vnic_env_stats_drop_desc[] = {
+	{ "rx_oversize_pkts_buffer",
+		VNIC_ENV_OFF(vport_env.eth_wqe_too_small) },
+};
+
 #define NUM_VNIC_ENV_STEER_COUNTERS(dev) \
 	(MLX5_CAP_GEN(dev, nic_receive_steering_discard) ? \
 	 ARRAY_SIZE(vnic_env_stats_steer_desc) : 0)
 #define NUM_VNIC_ENV_DEV_OOB_COUNTERS(dev) \
 	(MLX5_CAP_GEN(dev, vnic_env_int_rq_oob) ? \
 	 ARRAY_SIZE(vnic_env_stats_dev_oob_desc) : 0)
+#define NUM_VNIC_ENV_DROP_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, eth_wqe_too_small) ? \
+	 ARRAY_SIZE(vnic_env_stats_drop_desc) : 0)
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(vnic_env)
 {
 	return NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev) +
-		NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev);
+	       NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev) +
+	       NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
@@ -665,6 +674,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(vnic_env)
 	for (i = 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
 		       vnic_env_stats_dev_oob_desc[i].format);
+
+	for (i = 0; i < NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev); i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       vnic_env_stats_drop_desc[i].format);
+
 	return idx;
 }
 
@@ -679,6 +693,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vnic_env)
 	for (i = 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		data[idx++] = MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
 						  vnic_env_stats_dev_oob_desc, i);
+
+	for (i = 0; i < NUM_VNIC_ENV_DROP_COUNTERS(priv->mdev); i++)
+		data[idx++] = MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
+						  vnic_env_stats_drop_desc, i);
+
 	return idx;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 254cc22f5eec..8e571acc9ed8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1441,7 +1441,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0x9];
+	u8         reserved_at_130[0x2];
+	u8         eth_wqe_too_small[0x1];
+	u8         reserved_at_133[0x6];
 	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
@@ -3469,7 +3471,9 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         cq_overrun[0x20];
 
-	u8         reserved_at_220[0xde0];
+	u8         eth_wqe_too_small[0x20];
+
+	u8         reserved_at_220[0xdc0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.36.1

