Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7E3100188
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfKRJl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:41:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41385 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726461AbfKRJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:41:28 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 18 Nov 2019 11:41:25 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAI9fO1k031576;
        Mon, 18 Nov 2019 11:41:24 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net] net/mlx4_en: Fix wrong limitation for number of TX rings
Date:   Mon, 18 Nov 2019 11:41:04 +0200
Message-Id: <20191118094104.9477-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_TX rings should not be limited by max_num_tx_rings_p_up.
To make sure total number of TX rings never exceed MAX_TX_RINGS,
add similar check in mlx4_en_alloc_tx_queue_per_tc(), where
a new value is assigned for num_up.

Fixes: 7e1dc5e926d5 ("net/mlx4_en: Limit the number of TX rings")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  | 9 +++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

Please queue to -stable >= v4.15.

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index c12da02c2d1b..a1202e53710c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1812,6 +1812,7 @@ static int mlx4_en_set_channels(struct net_device *dev,
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_en_port_profile new_prof;
 	struct mlx4_en_priv *tmp;
+	int total_tx_count;
 	int port_up = 0;
 	int xdp_count;
 	int err = 0;
@@ -1826,13 +1827,12 @@ static int mlx4_en_set_channels(struct net_device *dev,
 
 	mutex_lock(&mdev->state_lock);
 	xdp_count = priv->tx_ring_num[TX_XDP] ? channel->rx_count : 0;
-	if (channel->tx_count * priv->prof->num_up + xdp_count >
-	    priv->mdev->profile.max_num_tx_rings_p_up * priv->prof->num_up) {
+	total_tx_count = channel->tx_count * priv->prof->num_up + xdp_count;
+	if (total_tx_count > MAX_TX_RINGS) {
 		err = -EINVAL;
 		en_err(priv,
 		       "Total number of TX and XDP rings (%d) exceeds the maximum supported (%d)\n",
-		       channel->tx_count * priv->prof->num_up  + xdp_count,
-		       MAX_TX_RINGS);
+		       total_tx_count, MAX_TX_RINGS);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 40ec5acf79c0..70fd246840e2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -91,6 +91,7 @@ int mlx4_en_alloc_tx_queue_per_tc(struct net_device *dev, u8 tc)
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_en_port_profile new_prof;
 	struct mlx4_en_priv *tmp;
+	int total_count;
 	int port_up = 0;
 	int err = 0;
 
@@ -104,6 +105,14 @@ int mlx4_en_alloc_tx_queue_per_tc(struct net_device *dev, u8 tc)
 				      MLX4_EN_NUM_UP_HIGH;
 	new_prof.tx_ring_num[TX] = new_prof.num_tx_rings_p_up *
 				   new_prof.num_up;
+	total_count = new_prof.tx_ring_num[TX] + new_prof.tx_ring_num[TX_XDP];
+	if (total_count > MAX_TX_RINGS) {
+		err = -EINVAL;
+		en_err(priv,
+		       "Total number of TX and XDP rings (%d) exceeds the maximum supported (%d)\n",
+		       total_count, MAX_TX_RINGS);
+		goto out;
+	}
 	err = mlx4_en_try_alloc_resources(priv, tmp, &new_prof, true);
 	if (err)
 		goto out;
-- 
2.21.0

