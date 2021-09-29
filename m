Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC9841C91B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345968AbhI2QBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23247 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbr2JwMz8tVZ;
        Wed, 29 Sep 2021 23:57:12 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 059/167] net: vrf: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:46 +0800
Message-ID: <20210929155334.12454-60-shenjian15@huawei.com>
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
 drivers/net/vrf.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index bf2fac913942..aee9e0fa0842 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1653,21 +1653,23 @@ static void vrf_setup(struct net_device *dev)
 	eth_hw_addr_random(dev);
 
 	/* don't acquire vrf device's netif_tx_lock when transmitting */
-	dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
 
 	/* don't allow vrf devices to change network namespaces. */
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
 
 	/* does not make sense for a VLAN to be added to a vrf device */
-	dev->features   |= NETIF_F_VLAN_CHALLENGED;
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &dev->features);
 
 	/* enable offload features */
-	dev->features   |= NETIF_F_GSO_SOFTWARE;
-	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC;
-	dev->features   |= NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
-
-	dev->hw_features = dev->features;
-	dev->hw_enc_features = dev->features;
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC,
+				&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA,
+				&dev->features);
+
+	netdev_feature_copy(&dev->hw_features, dev->features);
+	netdev_feature_copy(&dev->hw_enc_features, dev->features);
 
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
-- 
2.33.0

