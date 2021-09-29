Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD4741C902
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345797AbhI2QAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12985 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344343AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbG6HN3zWXw5;
        Wed, 29 Sep 2021 23:56:42 +0800 (CST)
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
Subject: [RFCv2 net-next 041/167] team: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:28 +0800
Message-ID: <20210929155334.12454-42-shenjian15@huawei.com>
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
 drivers/net/team/team.c | 69 +++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index fa96ee62c91a..207771e0d1c8 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -985,21 +985,30 @@ static void team_port_disable(struct team *team,
 static void __team_compute_features(struct team *team)
 {
 	struct team_port *port;
-	netdev_features_t vlan_features = TEAM_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
-	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
+	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
+	netdev_features_t mask_vlan;
+	netdev_features_t mask_enc;
+
+	netdev_feature_zero(&vlan_features);
+	netdev_feature_set_bits(TEAM_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
+				&vlan_features);
+	netdev_feature_zero(&enc_features);
+	netdev_feature_set_bits(TEAM_ENC_FEATURES, &enc_features);
+	netdev_feature_zero(&mask_vlan);
+	netdev_feature_set_bits(TEAM_VLAN_FEATURES, &mask_vlan);
+	netdev_feature_zero(&mask_enc);
+	netdev_feature_set_bits(TEAM_ENC_FEATURES, &mask_enc);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
 		netdev_increment_features(&vlan_features, vlan_features,
-					  port->dev->vlan_features,
-					  TEAM_VLAN_FEATURES);
+					  port->dev->vlan_features, mask_vlan);
 		netdev_increment_features(&enc_features, enc_features,
-					  port->dev->hw_enc_features,
-					  TEAM_ENC_FEATURES);
+					  port->dev->hw_enc_features, mask_enc);
 
 		dst_release_flag &= port->dev->priv_flags;
 		if (port->dev->hard_header_len > max_hard_header_len)
@@ -1007,10 +1016,12 @@ static void __team_compute_features(struct team *team)
 	}
 	rcu_read_unlock();
 
-	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				     NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_STAG_TX;
+	netdev_feature_copy(&team->dev->vlan_features, vlan_features);
+	netdev_feature_copy(&team->dev->hw_enc_features, enc_features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&team->dev->hw_enc_features);
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -1161,7 +1172,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		return -EBUSY;
 	}
 
-	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
+	if (netdev_feature_test_bit(NETIF_F_VLAN_CHALLENGED_BIT,
+				    port_dev->features) &&
 	    vlan_uses_dev(dev)) {
 		NL_SET_ERR_MSG(extack, "Device is VLAN challenged and team device has VLAN set up");
 		netdev_err(dev, "Device %s is VLAN challenged and team device has VLAN set up\n",
@@ -1226,7 +1238,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		goto err_enable_netpoll;
 	}
 
-	if (!(dev->features & NETIF_F_LRO))
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features))
 		dev_disable_lro(port_dev);
 
 	err = netdev_rx_handler_register(port_dev, team_handle_frame,
@@ -2000,9 +2012,9 @@ static void team_fix_features(struct net_device *dev,
 	struct team *team = netdev_priv(dev);
 	netdev_features_t mask;
 
-	mask = *features;
-	*features &= ~NETIF_F_ONE_FOR_ALL;
-	*features |= NETIF_F_ALL_FOR_ALL;
+	netdev_feature_copy(&mask, *features);
+	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
+	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
@@ -2160,19 +2172,22 @@ static void team_setup(struct net_device *dev)
 	 */
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
 
-	dev->features |= NETIF_F_LLTX;
-	dev->features |= NETIF_F_GRO;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, &dev->features);
 
 	/* Don't allow team devices to change network namespaces. */
-	dev->features |= NETIF_F_NETNS_LOCAL;
-
-	dev->hw_features = TEAM_VLAN_FEATURES |
-			   NETIF_F_HW_VLAN_CTAG_RX |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+
+	netdev_feature_set_bits(TEAM_VLAN_FEATURES |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&dev->hw_features);
+
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&dev->features);
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
-- 
2.33.0

