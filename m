Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE85ADEE4
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiIFFWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiIFFV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE4F6D9D4
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89F17B81625
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12FC433D6;
        Tue,  6 Sep 2022 05:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441713;
        bh=0pUTPmA++gFwyfYlzqfF4H17BewtenNyrlHWaXzAB5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ro915F5+tRJrBroYWBCrIiG+ZudjrOeVfSv9JFr9++O9vJghFkMf3dD4mWavrTgcT
         OdDS7Iu4HprxCEJJv5K2KNi5GPLLAK/o2Bnc4lH3doFojeVmoZnipnFfAh7Hn7AQJI
         3PM0Z23hsmCQMj5Wnn8YrHKL0luIuEa3OAJILRSXX0VJc8dGjJQdd+aL2G7I+iyRj8
         KihIfyFRbMHM/zZPqxttqB3v49PDH0s/lkehl90UnD4gLcZiGcbMoTJnlnXGXltJG6
         KgjVHKSFYTAaEZfyjk0/NzPqLTlI2lJtLrFP/fnwtKvNbBdHepYn/Xt6ZlzPY5TNa9
         okBxbSmhN+ERA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 16/17] net/mlx5e: Add MACsec stats support for Rx/Tx flows
Date:   Mon,  5 Sep 2022 22:21:28 -0700
Message-Id: <20220906052129.104507-17-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Add the following statistics:
RX successfully decrypted MACsec packets:
macsec_rx_pkts : Number of packets decrypted successfully
macsec_rx_bytes : Number of bytes decrypted successfully

Rx dropped MACsec packets:
macsec_rx_pkts_drop : Number of MACsec packets dropped
macsec_rx_bytes_drop : Number of MACsec bytes dropped

TX successfully encrypted MACsec packets:
macsec_tx_pkts : Number of packets encrypted/authenticated successfully
macsec_tx_bytes : Number of bytes encrypted/authenticated successfully

Tx dropped MACsec packets:
macsec_tx_pkts_drop : Number of MACsec packets dropped
macsec_tx_bytes_drop : Number of MACsec bytes dropped

The above can be seen using:
ethtool -S <ifc> |grep macsec

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      | 18 ++++-
 .../mellanox/mlx5/core/en_accel/macsec.h      | 15 ++++
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   | 24 +++++++
 .../mellanox/mlx5/core/en_accel/macsec_fs.h   |  2 +
 .../mlx5/core/en_accel/macsec_stats.c         | 72 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  3 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
 8 files changed, 136 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 889128638763..a22c32aabf11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -92,7 +92,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_IPOIB) += ipoib/ipoib.o ipoib/ethtool.o ipoib/ipoib
 #
 mlx5_core-$(CONFIG_MLX5_FPGA) += fpga/cmd.o fpga/core.o fpga/conn.o fpga/sdk.o
 
-mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o en_accel/macsec_fs.o
+mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o en_accel/macsec_fs.o \
+				      en_accel/macsec_stats.o
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 90ce4fe618b3..4ff44bec8e03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -68,6 +68,9 @@ struct mlx5e_macsec {
 
 	unsigned char *dev_addr;
 	struct mlx5_core_dev *mdev;
+
+	/* Stats manage */
+	struct mlx5e_macsec_stats stats;
 };
 
 struct mlx5_macsec_obj_attrs {
@@ -990,7 +993,7 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
 	return 0;
 }
 
-static bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
+bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
 {
 	if (!(MLX5_CAP_GEN_64(mdev, general_obj_types) &
 	    MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD))
@@ -1021,6 +1024,19 @@ static bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev)
 	return true;
 }
 
+void mlx5e_macsec_get_stats_fill(struct mlx5e_macsec *macsec, void *macsec_stats)
+{
+	mlx5e_macsec_fs_get_stats_fill(macsec->macsec_fs, macsec_stats);
+}
+
+struct mlx5e_macsec_stats *mlx5e_macsec_get_stats(struct mlx5e_macsec *macsec)
+{
+	if (!macsec)
+		return NULL;
+
+	return &macsec->stats;
+}
+
 static const struct macsec_ops macsec_offload_ops = {
 	.mdo_add_txsa = mlx5e_macsec_add_txsa,
 	.mdo_upd_txsa = mlx5e_macsec_upd_txsa,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
index 548047d90315..ada557fc042d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -17,6 +17,17 @@
 struct mlx5e_priv;
 struct mlx5e_macsec;
 
+struct mlx5e_macsec_stats {
+	u64 macsec_rx_pkts;
+	u64 macsec_rx_bytes;
+	u64 macsec_rx_pkts_drop;
+	u64 macsec_rx_bytes_drop;
+	u64 macsec_tx_pkts;
+	u64 macsec_tx_bytes;
+	u64 macsec_tx_pkts_drop;
+	u64 macsec_tx_bytes_drop;
+};
+
 void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv);
 int mlx5e_macsec_init(struct mlx5e_priv *priv);
 void mlx5e_macsec_cleanup(struct mlx5e_priv *priv);
@@ -39,6 +50,9 @@ static inline bool mlx5e_macsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 
 void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 					struct mlx5_cqe64 *cqe);
+bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev);
+void mlx5e_macsec_get_stats_fill(struct mlx5e_macsec *macsec, void *macsec_stats);
+struct mlx5e_macsec_stats *mlx5e_macsec_get_stats(struct mlx5e_macsec *macsec);
 
 #else
 
@@ -51,6 +65,7 @@ static inline void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
 						      struct sk_buff *skb,
 						      struct mlx5_cqe64 *cqe)
 {}
+static inline bool mlx5e_is_macsec_device(const struct mlx5_core_dev *mdev) { return false; }
 
 #endif  /* CONFIG_MLX5_EN_MACSEC */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index d3d680216115..608fbbaa5a58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -1297,6 +1297,30 @@ static void macsec_fs_rx_cleanup(struct mlx5e_macsec_fs *macsec_fs)
 	macsec_fs->rx_fs = NULL;
 }
 
+void mlx5e_macsec_fs_get_stats_fill(struct mlx5e_macsec_fs *macsec_fs, void *macsec_stats)
+{
+	struct mlx5e_macsec_stats *stats = (struct mlx5e_macsec_stats *)macsec_stats;
+	struct mlx5e_macsec_tables *tx_tables = &macsec_fs->tx_fs->tables;
+	struct mlx5e_macsec_tables *rx_tables = &macsec_fs->rx_fs->tables;
+	struct mlx5_core_dev *mdev = macsec_fs->mdev;
+
+	if (tx_tables->check_rule_counter)
+		mlx5_fc_query(mdev, tx_tables->check_rule_counter,
+			      &stats->macsec_tx_pkts, &stats->macsec_tx_bytes);
+
+	if (tx_tables->check_miss_rule_counter)
+		mlx5_fc_query(mdev, tx_tables->check_miss_rule_counter,
+			      &stats->macsec_tx_pkts_drop, &stats->macsec_tx_bytes_drop);
+
+	if (rx_tables->check_rule_counter)
+		mlx5_fc_query(mdev, rx_tables->check_rule_counter,
+			      &stats->macsec_rx_pkts, &stats->macsec_rx_bytes);
+
+	if (rx_tables->check_miss_rule_counter)
+		mlx5_fc_query(mdev, rx_tables->check_miss_rule_counter,
+			      &stats->macsec_rx_pkts_drop, &stats->macsec_rx_bytes_drop);
+}
+
 union mlx5e_macsec_rule *
 mlx5e_macsec_fs_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 			 const struct macsec_context *macsec_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
index 203240a993b6..b429648d4ee7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
@@ -40,6 +40,8 @@ void mlx5e_macsec_fs_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 			      union mlx5e_macsec_rule *macsec_rule,
 			      int action);
 
+void mlx5e_macsec_fs_get_stats_fill(struct mlx5e_macsec_fs *macsec_fs, void *macsec_stats);
+
 #endif
 
 #endif /* __MLX5_MACSEC_STEERING_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c
new file mode 100644
index 000000000000..e50a2e3f3d18
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <linux/ethtool.h>
+#include <net/sock.h>
+
+#include "en.h"
+#include "en_accel/macsec.h"
+
+static const struct counter_desc mlx5e_macsec_hw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_rx_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_rx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_rx_pkts_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_rx_bytes_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_tx_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_tx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_tx_pkts_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_macsec_stats, macsec_tx_bytes_drop) },
+};
+
+#define NUM_MACSEC_HW_COUNTERS ARRAY_SIZE(mlx5e_macsec_hw_stats_desc)
+
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(macsec_hw)
+{
+	if (!priv->macsec)
+		return 0;
+
+	if (mlx5e_is_macsec_device(priv->mdev))
+		return NUM_MACSEC_HW_COUNTERS;
+
+	return 0;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(macsec_hw) {}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(macsec_hw)
+{
+	unsigned int i;
+
+	if (!priv->macsec)
+		return idx;
+
+	if (!mlx5e_is_macsec_device(priv->mdev))
+		return idx;
+
+	for (i = 0; i < NUM_MACSEC_HW_COUNTERS; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       mlx5e_macsec_hw_stats_desc[i].format);
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(macsec_hw)
+{
+	int i;
+
+	if (!priv->macsec)
+		return idx;
+
+	if (!mlx5e_is_macsec_device(priv->mdev))
+		return idx;
+
+	mlx5e_macsec_get_stats_fill(priv->macsec, mlx5e_macsec_get_stats(priv->macsec));
+	for (i = 0; i < NUM_MACSEC_HW_COUNTERS; i++)
+		data[idx++] = MLX5E_READ_CTR64_CPU(mlx5e_macsec_get_stats(priv->macsec),
+						   mlx5e_macsec_hw_stats_desc,
+						   i);
+
+	return idx;
+}
+
+MLX5E_DEFINE_STATS_GRP(macsec_hw, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 7409829d1201..575717186912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2451,6 +2451,9 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(per_port_buff_congest),
 	&MLX5E_STATS_GRP(ptp),
 	&MLX5E_STATS_GRP(qos),
+#ifdef CONFIG_MLX5_EN_MACSEC
+	&MLX5E_STATS_GRP(macsec_hw),
+#endif
 };
 
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index ed4fc940e4ef..99e321bfb744 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -486,5 +486,6 @@ extern MLX5E_DECLARE_STATS_GRP(channels);
 extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
 extern MLX5E_DECLARE_STATS_GRP(ipsec_sw);
 extern MLX5E_DECLARE_STATS_GRP(ptp);
+extern MLX5E_DECLARE_STATS_GRP(macsec_hw);
 
 #endif /* __MLX5_EN_STATS_H__ */
-- 
2.37.2

