Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C635F2166
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJBFOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiJBFON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B4251A14
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F1AF60DF3
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63964C433D7;
        Sun,  2 Oct 2022 05:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687645;
        bh=PYgtbWgzEyKgZsa9miztgRty2qRP+ainQ9wggM91+5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO+riRdL/3NqiF65WRw3P1Iksj1e7wROzlHa/Mt7mbfzf4Yj/YsrPpSJ8aiv86+X7
         vV2znnPZUInlfVGoeytnBI8geU2dQMD/S1/G5K4XylTPn7z4A+AOR2UcZIrukoNzSE
         PjvdqAhS57GGOJ+svQ7rp63uzY7nSJCqs8Au8/Kl7/dQZAKvWZc/dwiIXb17f0qkX3
         dy4mZf6V/dIFQNfVQKmNd7eUM/2/Q9L0KCsjvUTjw/D9R06K9EvLjONImzlyI14UXp
         JxGFgpvLH6YzXzZX8L3aMt/14DHj1EWCM3MwBLEuKJn63bNuJxdSZ7GHzvbgKtg2CN
         VbOUn5cCjhTHg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 10/15] net/mlx5e: Expose rx_oversize_pkts_buffer counter
Date:   Sat,  1 Oct 2022 21:56:27 -0700
Message-Id: <20221002045632.291612-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
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
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 21 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  4 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  8 +++++--
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d4f03ff7b0e1..364f04309149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3699,7 +3699,8 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
 		PPORT_802_3_GET(pstats, a_out_of_range_length_field) +
-		PPORT_802_3_GET(pstats, a_frame_too_long_errors);
+		PPORT_802_3_GET(pstats, a_frame_too_long_errors) +
+		VNIC_ENV_GET(&priv->stats.vnic, eth_wqe_too_small);
 	stats->rx_crc_errors =
 		PPORT_802_3_GET(pstats, a_frame_check_sequence_errors);
 	stats->rx_frame_errors = PPORT_802_3_GET(pstats, a_alignment_errors);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 575717186912..03c1841970f1 100644
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
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 99e321bfb744..9f781085be47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -273,6 +273,10 @@ struct mlx5e_qcounter_stats {
 	u32 rx_if_down_packets;
 };
 
+#define VNIC_ENV_GET(vnic_env_stats, c) \
+	MLX5_GET(query_vnic_env_out, (vnic_env_stats)->query_vnic_env_out, \
+		 vport_env.c)
+
 struct mlx5e_vnic_env_stats {
 	__be64 query_vnic_env_out[MLX5_ST_SZ_QW(query_vnic_env_out)];
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1ad762e22d86..06574d430ff5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1491,7 +1491,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0x9];
+	u8         reserved_at_130[0x2];
+	u8         eth_wqe_too_small[0x1];
+	u8         reserved_at_133[0x6];
 	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
@@ -3537,7 +3539,9 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         cq_overrun[0x20];
 
-	u8         reserved_at_220[0xde0];
+	u8         eth_wqe_too_small[0x20];
+
+	u8         reserved_at_220[0xdc0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.37.3

