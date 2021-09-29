Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D982F41C920
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbhI2QBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12990 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345479AbhI2P7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbK2vVZzWYQV;
        Wed, 29 Sep 2021 23:56:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 061/167] vxlan: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:48 +0800
Message-ID: <20210929155334.12454-62-shenjian15@huawei.com>
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
 drivers/net/vxlan.c | 21 ++++++++++++---------
 include/net/vxlan.h |  4 ++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 141635a35c28..1978dfc71056 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3294,15 +3294,18 @@ static void vxlan_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
-	dev->features	|= NETIF_F_LLTX;
-	dev->features	|= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features   |= NETIF_F_RXCSUM;
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
-
-	dev->vlan_features = dev->features;
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
+				&dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+
+	netdev_feature_copy(&dev->vlan_features, dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
+				&dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
+
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index a801e59e2313..dba14ed12c5d 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -322,8 +322,8 @@ static inline void vxlan_features_check(struct sk_buff *skb,
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
 	      !can_checksum_protocol(*features, inner_eth_hdr(skb)->h_proto))))
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 }
 
 /* IP header + UDP + VXLAN + Ethernet header */
-- 
2.33.0

