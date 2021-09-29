Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CFC41C95B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbhI2QEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23334 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345633AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX30TdGzRC9y;
        Wed, 29 Sep 2021 23:53:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 111/167] net: mscc: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:38 +0800
Message-ID: <20210929155334.12454-112-shenjian15@huawei.com>
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
 drivers/net/ethernet/mscc/ocelot.c     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 559177e6ded4..3613a0a50972 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -852,7 +852,8 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 	/* Update the statistics if part of the FCS was read before */
 	len -= ETH_FCS_LEN - sz;
 
-	if (unlikely(dev->features & NETIF_F_RXFCS)) {
+	if (unlikely(netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+					     dev->features))) {
 		buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
 		*buf = val;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e54b9fb2a97a..844525fc558c 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -714,7 +714,7 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 
 	/* Filtering */
 	val = ocelot_read(ocelot, ANA_VLANMASK);
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		val |= BIT(port);
 	else
 		val &= ~BIT(port);
@@ -724,19 +724,22 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 static int ocelot_set_features(struct net_device *dev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
+	netdev_features_t changed;
 
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, dev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed))
 		ocelot_vlan_mode(ocelot, port, features);
 
 	return 0;
@@ -1700,9 +1703,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	dev->netdev_ops = &ocelot_port_netdev_ops;
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-		NETIF_F_HW_TC;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
+				NETIF_F_HW_TC, &dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC,
+				&dev->features);
 
 	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
 	dev->dev_addr[ETH_ALEN - 1] += port;
-- 
2.33.0

