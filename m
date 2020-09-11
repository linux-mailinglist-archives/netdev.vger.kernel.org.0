Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB59266938
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgIKTxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgIKTxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:12 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCECE2222A;
        Fri, 11 Sep 2020 19:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853991;
        bh=FdKgQLdJKKwErcpXA5rsvoYNVox3WfoC+aifdEwlq+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXInh15SCd4xox8CKaqMkGIe2G3nyTEDqTzGVgjON6GHFc2vHn9oSTAKIwzyn+Zbm
         moI2rVkEQy7yw3MlMUTHfloYA/PqAzEwA4Wqu3in4CS+kvsk/dlP8l59WnYA5DkjvD
         J/WfPpRP4sZziykFMQALEVa8z6MbZtq7pR2yw0u0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 8/8] mlx4: add pause frame stats
Date:   Fri, 11 Sep 2020 12:52:58 -0700
Message-Id: <20200911195258.1048468-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911195258.1048468-1-kuba@kernel.org>
References: <20200911195258.1048468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if the pause stats are reported by HW by checking the bitmap.
Calculation is based on the order of strings in main_strings from
ethtool -S. Hopefully the semantics of these stats match the standard..

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   | 19 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx4/mlx4_stats.h   | 12 ++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index b816154bc79a..23849f2b9c25 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1106,6 +1106,24 @@ static int mlx4_en_set_pauseparam(struct net_device *dev,
 	return err;
 }
 
+static void mlx4_en_get_pause_stats(struct net_device *dev,
+				    struct ethtool_pause_stats *stats)
+{
+	struct mlx4_en_priv *priv = netdev_priv(dev);
+	struct bitmap_iterator it;
+
+	bitmap_iterator_init(&it, priv->stats_bitmap.bitmap, NUM_ALL_STATS);
+
+	spin_lock_bh(&priv->stats_lock);
+	if (test_bit(FLOW_PRIORITY_STATS_IDX_TX_FRAMES,
+		     priv->stats_bitmap.bitmap))
+		stats->tx_pause_frames = priv->tx_flowstats.tx_pause;
+	if (test_bit(FLOW_PRIORITY_STATS_IDX_RX_FRAMES,
+		     priv->stats_bitmap.bitmap))
+		stats->rx_pause_frames = priv->rx_flowstats.rx_pause;
+	spin_unlock_bh(&priv->stats_lock);
+}
+
 static void mlx4_en_get_pauseparam(struct net_device *dev,
 				 struct ethtool_pauseparam *pause)
 {
@@ -2138,6 +2156,7 @@ const struct ethtool_ops mlx4_en_ethtool_ops = {
 	.set_msglevel = mlx4_en_set_msglevel,
 	.get_coalesce = mlx4_en_get_coalesce,
 	.set_coalesce = mlx4_en_set_coalesce,
+	.get_pause_stats = mlx4_en_get_pause_stats,
 	.get_pauseparam = mlx4_en_get_pauseparam,
 	.set_pauseparam = mlx4_en_set_pauseparam,
 	.get_ringparam = mlx4_en_get_ringparam,
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
index 86b6051da8ec..51d4eaab6a2f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
@@ -84,6 +84,11 @@ struct mlx4_en_flow_stats_rx {
 					 MLX4_NUM_PRIORITIES)
 };
 
+#define FLOW_PRIORITY_STATS_IDX_RX_FRAMES	(NUM_MAIN_STATS +	\
+						 NUM_PORT_STATS +	\
+						 NUM_PF_STATS +		\
+						 NUM_FLOW_PRIORITY_STATS_RX)
+
 struct mlx4_en_flow_stats_tx {
 	u64 tx_pause;
 	u64 tx_pause_duration;
@@ -93,6 +98,13 @@ struct mlx4_en_flow_stats_tx {
 					 MLX4_NUM_PRIORITIES)
 };
 
+#define FLOW_PRIORITY_STATS_IDX_TX_FRAMES	(NUM_MAIN_STATS +	\
+						 NUM_PORT_STATS +	\
+						 NUM_PF_STATS +		\
+						 NUM_FLOW_PRIORITY_STATS_RX + \
+						 NUM_FLOW_STATS_RX +	\
+						 NUM_FLOW_PRIORITY_STATS_TX)
+
 #define NUM_FLOW_STATS (NUM_FLOW_STATS_RX + NUM_FLOW_STATS_TX + \
 			NUM_FLOW_PRIORITY_STATS_TX + \
 			NUM_FLOW_PRIORITY_STATS_RX)
-- 
2.26.2

