Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF841C90D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345884AbhI2QBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:06 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24138 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345459AbhI2P7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbH2WNBz1DHLx;
        Wed, 29 Sep 2021 23:56:43 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 043/167] net_failover: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:30 +0800
Message-ID: <20210929155334.12454-44-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/net_failover.c | 57 +++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 878cad216aaf..704e691530f7 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -379,23 +379,33 @@ static rx_handler_result_t net_failover_handle_frame(struct sk_buff **pskb)
 
 static void net_failover_compute_features(struct net_device *dev)
 {
-	netdev_features_t vlan_features = FAILOVER_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
-	netdev_features_t enc_features  = FAILOVER_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct net_device *primary_dev, *standby_dev;
+	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
+	netdev_features_t vlan_mask;
+	netdev_features_t enc_mask;
+
+	netdev_feature_zero(&vlan_features);
+	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
+				&vlan_features);
+	netdev_feature_zero(&enc_features);
+	netdev_feature_set_bits(FAILOVER_ENC_FEATURES, &enc_features);
+	netdev_feature_zero(&vlan_mask);
+	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES, &vlan_mask);
+	netdev_feature_copy(&enc_mask, enc_features);
 
 	primary_dev = rcu_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
 		netdev_increment_features(&vlan_features, vlan_features,
 					  primary_dev->vlan_features,
-					  FAILOVER_VLAN_FEATURES);
+					  vlan_mask);
 		netdev_increment_features(&enc_features, enc_features,
 					  primary_dev->hw_enc_features,
-					  FAILOVER_ENC_FEATURES);
+					  enc_features);
 
 		dst_release_flag &= primary_dev->priv_flags;
 		if (primary_dev->hard_header_len > max_hard_header_len)
@@ -406,18 +416,19 @@ static void net_failover_compute_features(struct net_device *dev)
 	if (standby_dev) {
 		netdev_increment_features(&vlan_features, vlan_features,
 					  standby_dev->vlan_features,
-					  FAILOVER_VLAN_FEATURES);
+					  vlan_mask);
 		netdev_increment_features(&enc_features, enc_features,
 					  standby_dev->hw_enc_features,
-					  FAILOVER_ENC_FEATURES);
+					  enc_features);
 
 		dst_release_flag &= standby_dev->priv_flags;
 		if (standby_dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = standby_dev->hard_header_len;
 	}
 
-	dev->vlan_features = vlan_features;
-	dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	netdev_feature_copy(&dev->vlan_features, vlan_features);
+	netdev_feature_copy(&dev->hw_enc_features, enc_features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->hw_enc_features);
 	dev->hard_header_len = max_hard_header_len;
 
 	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -481,7 +492,8 @@ static int net_failover_slave_pre_register(struct net_device *slave_dev,
 				  !dev_is_pci(slave_dev->dev.parent)))
 		return -EINVAL;
 
-	if (failover_dev->features & NETIF_F_VLAN_CHALLENGED &&
+	if (netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				    failover_dev->features) &&
 	    vlan_uses_dev(failover_dev)) {
 		netdev_err(failover_dev, "Device %s is VLAN challenged and failover device has VLAN set up\n",
 			   failover_dev->name);
@@ -731,18 +743,23 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 				       IFF_TX_SKB_SHARING);
 
 	/* don't acquire failover netdev's netif_tx_lock when transmitting */
-	failover_dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &failover_dev->features);
 
 	/* Don't allow failover devices to change network namespaces. */
-	failover_dev->features |= NETIF_F_NETNS_LOCAL;
-
-	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	failover_dev->features |= failover_dev->hw_features;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+			       &failover_dev->features);
+
+	netdev_feature_zero(&failover_dev->hw_features);
+	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&failover_dev->hw_features);
+
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL,
+				&failover_dev->hw_features);
+	netdev_feature_or(&failover_dev->features, failover_dev->features,
+			  failover_dev->hw_features);
 
 	memcpy(failover_dev->dev_addr, standby_dev->dev_addr,
 	       failover_dev->addr_len);
-- 
2.33.0

