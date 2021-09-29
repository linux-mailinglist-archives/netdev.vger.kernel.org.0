Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B0141C90F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbhI2QBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:13 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24136 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345474AbhI2P7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF658Sz1DHL3;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 031/167] net: tun: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:18 +0800
Message-ID: <20210929155334.12454-32-shenjian15@huawei.com>
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
 drivers/net/tun.c | 48 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d89a9874eb37..9e9cbafc870b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1083,9 +1083,11 @@ static void tun_net_fix_features(struct net_device *dev,
 				 netdev_features_t *features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	netdev_features_t tmp;
 
-	*features = (*features & tun->set_features) |
-			(*features & ~TUN_USER_FEATURES);
+	netdev_feature_and(&tmp, *features, tun->set_features);
+	netdev_feature_clear_bits(TUN_USER_FEATURES, features);
+	netdev_feature_or(features, *features, tmp);
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
@@ -2727,13 +2729,18 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun_net_init(dev);
 		tun_flow_init(tun);
 
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
+		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
+					TUN_USER_FEATURES |
+					NETIF_F_HW_VLAN_CTAG_TX |
+					NETIF_F_HW_VLAN_STAG_TX,
+					&dev->hw_features);
+		netdev_feature_copy(&dev->features, dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+		netdev_feature_copy(&dev->vlan_features, dev->features);
+		netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					  NETIF_F_HW_VLAN_STAG_TX,
+					  &dev->vlan_features);
 
 		tun->flags = (tun->flags & ~TUN_FEATURES) |
 			      (ifr->ifr_flags & TUN_FEATURES);
@@ -2795,21 +2802,26 @@ static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
  * privs required. */
 static int set_offload(struct tun_struct *tun, unsigned long arg)
 {
-	netdev_features_t features = 0;
+	netdev_features_t features;
+
+	netdev_feature_zero(&features);
 
 	if (arg & TUN_F_CSUM) {
-		features |= NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
 		arg &= ~TUN_F_CSUM;
 
 		if (arg & (TUN_F_TSO4|TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN) {
-				features |= NETIF_F_TSO_ECN;
+				netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
+						       &features);
 				arg &= ~TUN_F_TSO_ECN;
 			}
 			if (arg & TUN_F_TSO4)
-				features |= NETIF_F_TSO;
+				netdev_feature_set_bit(NETIF_F_TSO_BIT,
+						       &features);
 			if (arg & TUN_F_TSO6)
-				features |= NETIF_F_TSO6;
+				netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+						       &features);
 			arg &= ~(TUN_F_TSO4|TUN_F_TSO6);
 		}
 
@@ -2821,9 +2833,11 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 	if (arg)
 		return -EINVAL;
 
-	tun->set_features = features;
-	tun->dev->wanted_features &= ~TUN_USER_FEATURES;
-	tun->dev->wanted_features |= features;
+	netdev_feature_copy(&tun->set_features, features);
+	netdev_feature_clear_bits(TUN_USER_FEATURES,
+				  &tun->dev->wanted_features);
+	netdev_feature_or(&tun->dev->wanted_features,
+			  tun->dev->wanted_features, features);
 	netdev_update_features(tun->dev);
 
 	return 0;
-- 
2.33.0

