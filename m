Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0435BBCF9
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiIRJvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiIRJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7419117A83
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjc020cWzlVwH;
        Sun, 18 Sep 2022 17:45:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 51/55] net: mlx4: adjust the prototype of check_csum() and mlx4_en_update_loopback_state()
Date:   Sun, 18 Sep 2022 09:43:32 +0000
Message-ID: <20220918094336.28958-52-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function check_csum() and mlx4_en_update_loopback_state()
using netdev_features_t as parameters.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c     | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c       |  6 +++---
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h     |  2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index bc4b88cc81e3..347e98657321 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -100,11 +100,11 @@ void en_print(const char *level, const struct mlx4_en_priv *priv,
 }
 
 void mlx4_en_update_loopback_state(struct net_device *dev,
-				   netdev_features_t features)
+				   const netdev_features_t *features)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
-	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features))
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features))
 		priv->ctrl_flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
 	else
 		priv->ctrl_flags &= cpu_to_be32(~MLX4_WQE_CTRL_FORCE_LOOPBACK);
@@ -116,7 +116,8 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	 * and not performing the selftest or flb disabled
 	 */
 	if (mlx4_is_mfunc(priv->mdev->dev) &&
-	    !netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) && !priv->validate_loopback)
+	    !netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features) &&
+	    !priv->validate_loopback)
 		priv->flags |= MLX4_EN_FLAG_RX_FILTER_NEEDED;
 
 	/* Set dmac in Tx WQE if we are in SRIOV mode or if loopback selftest
@@ -131,7 +132,8 @@ void mlx4_en_update_loopback_state(struct net_device *dev,
 	    priv->rss_map.indir_qp && priv->rss_map.indir_qp->qpn) {
 		int i;
 		int err = 0;
-		int loopback = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
+		int loopback = netdev_feature_test(NETIF_F_LOOPBACK_BIT,
+						   *features);
 
 		for (i = 0; i < priv->rx_ring_num; i++) {
 			int ret;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index a93cd318d19d..5c4570c3878e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2554,7 +2554,7 @@ static int mlx4_en_set_features(struct net_device *netdev,
 	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_LOOPBACK_BIT)) {
 		en_info(priv, "Turn %s loopback\n",
 			netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features) ? "ON" : "OFF");
-		mlx4_en_update_loopback_state(netdev, *features);
+		mlx4_en_update_loopback_state(netdev, features);
 	}
 
 	if (reset) {
@@ -3434,7 +3434,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	en_warn(priv, "Using %d TX rings\n", prof->tx_ring_num[TX]);
 	en_warn(priv, "Using %d RX rings\n", prof->rx_ring_num);
 
-	mlx4_en_update_loopback_state(priv->dev, priv->dev->features);
+	mlx4_en_update_loopback_state(priv->dev, &priv->dev->features);
 
 	/* Configure port */
 	mlx4_en_calc_rx_buf(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 266f119a93c4..6087264fc01c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -623,7 +623,7 @@ static int get_fixed_ipv6_csum(__wsum hw_checksum, struct sk_buff *skb,
  * the (IPv4 | IPv6) bits are set in cqe->status.
  */
 static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
-		      netdev_features_t dev_features)
+		      const netdev_features_t *dev_features)
 {
 	__wsum hw_checksum = 0;
 	void *hdr;
@@ -643,7 +643,7 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
 	hw_checksum = csum_unfold((__force __sum16)cqe->checksum);
 
 	if (cqe->vlan_my_qpn & cpu_to_be32(MLX4_CQE_CVLAN_PRESENT_MASK) &&
-	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, dev_features)) {
+	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *dev_features)) {
 		hw_checksum = get_fixed_vlan_csum(hw_checksum, hdr);
 		hdr += sizeof(struct vlan_hdr);
 	}
@@ -862,7 +862,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				if (!(priv->flags & MLX4_EN_FLAG_RX_CSUM_NON_TCP_UDP &&
 				      (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IP_ANY))))
 					goto csum_none;
-				if (check_csum(cqe, skb, va, dev->features))
+				if (check_csum(cqe, skb, va, &dev->features))
 					goto csum_none;
 				ip_summed = CHECKSUM_COMPLETE;
 				hash_type = PKT_HASH_TYPE_L3;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_selftest.c b/drivers/net/ethernet/mellanox/mlx4/en_selftest.c
index 946d9db7c8c2..79547273f00a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_selftest.c
@@ -85,7 +85,7 @@ static int mlx4_en_test_loopback(struct mlx4_en_priv *priv)
         priv->loopback_ok = 0;
 	priv->validate_loopback = 1;
 
-	mlx4_en_update_loopback_state(priv->dev, priv->dev->features);
+	mlx4_en_update_loopback_state(priv->dev, &priv->dev->features);
 
 	/* xmit */
 	if (mlx4_en_test_loopback_xmit(priv)) {
@@ -108,7 +108,7 @@ static int mlx4_en_test_loopback(struct mlx4_en_priv *priv)
 
 	priv->validate_loopback = 0;
 
-	mlx4_en_update_loopback_state(priv->dev, priv->dev->features);
+	mlx4_en_update_loopback_state(priv->dev, &priv->dev->features);
 	return !loopback_ok;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index c514fb785e62..ec828c0f1d79 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -656,7 +656,7 @@ static inline struct mlx4_cqe *mlx4_en_get_cqe(void *buf, int idx, int cqe_sz)
 
 void mlx4_en_init_ptys2ethtool_map(void);
 void mlx4_en_update_loopback_state(struct net_device *dev,
-				   netdev_features_t features);
+				   const netdev_features_t *features);
 
 void mlx4_en_destroy_netdev(struct net_device *dev);
 int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
-- 
2.33.0

