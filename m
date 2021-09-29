Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508BE41C940
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346077AbhI2QDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12993 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345553AbhI2P76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbW3YgZzWYb4;
        Wed, 29 Sep 2021 23:56:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 127/167] net: sun: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:54 +0800
Message-ID: <20210929155334.12454-128-shenjian15@huawei.com>
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
 drivers/net/ethernet/sun/cassini.c        |  5 +++--
 drivers/net/ethernet/sun/ldmvsw.c         |  5 +++--
 drivers/net/ethernet/sun/niu.c            | 11 +++++++----
 drivers/net/ethernet/sun/sungem.c         | 11 +++++++----
 drivers/net/ethernet/sun/sunhme.c         | 14 ++++++++++----
 drivers/net/ethernet/sun/sunvnet.c        |  8 +++++---
 drivers/net/ethernet/sun/sunvnet_common.c |  5 ++++-
 7 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 287ae4c538aa..785e11f0bd34 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5084,10 +5084,11 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Cassini features. */
 	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0)
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
+					&dev->features);
 
 	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	/* MTU range: 60 - varies or 9000 */
 	dev->min_mtu = CAS_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 50bd4e3b0af9..2a01557f71e0 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -249,8 +249,9 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->ethtool_ops = &vsw_ethtool_ops;
 	dev->watchdog_timeo = VSW_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_HW_CSUM | NETIF_F_SG;
-	dev->features = dev->hw_features;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG, &dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index a68a01d1b2b1..bcbf23c2ac06 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3472,7 +3472,7 @@ static int niu_process_rx_pkt(struct napi_struct *napi, struct niu *np,
 	__pskb_pull_tail(skb, len);
 
 	rh = (struct rx_pkt_hdr1 *) skb->data;
-	if (np->dev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, np->dev->features))
 		skb_set_hash(skb,
 			     ((u32)rh->hashval2_0 << 24 |
 			      (u32)rh->hashval2_1 << 16 |
@@ -9711,8 +9711,11 @@ static void niu_device_announce(struct niu *np)
 
 static void niu_set_basic_features(struct net_device *dev)
 {
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXHASH;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXHASH,
+				&dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
 }
 
 static int niu_pci_init_one(struct pci_dev *pdev,
@@ -9778,7 +9781,7 @@ static int niu_pci_init_one(struct pci_dev *pdev,
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 	if (!err)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 	if (err) {
 		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index d72018a60c0f..79b243520e68 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -843,7 +843,8 @@ static int gem_rx(struct gem *gp, int work_to_do)
 			skb = copy_skb;
 		}
 
-		if (likely(dev->features & NETIF_F_RXCSUM)) {
+		if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						   dev->features))) {
 			__sum16 csum;
 
 			csum = (__force __sum16)htons((status & RXDCTRL_TCPCSUM) ^ 0xffff);
@@ -2987,10 +2988,12 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 
 	/* We can do scatter/gather and HW checksum */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
-	dev->features = dev->hw_features;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
 
 	/* MTU range: 68 - 1500 (Jumbo mode is broken) */
 	dev->min_mtu = GEM_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 62f81b0d14ed..26ef236949be 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2801,8 +2801,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
+				&dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
 
 	hp->irq = op->archdata.irqs[0];
 
@@ -3116,8 +3119,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
+				&dev->hw_features);
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/descriptor accessors. */
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 58ee89223951..1c5c85885a0a 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -312,9 +312,11 @@ static struct vnet *vnet_new(const u64 *local_mac,
 	dev->ethtool_ops = &vnet_ethtool_ops;
 	dev->watchdog_timeo = VNET_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_TSO | NETIF_F_GSO | NETIF_F_ALL_TSO |
-			   NETIF_F_HW_CSUM | NETIF_F_SG;
-	dev->features = dev->hw_features;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_ALL_TSO |
+				NETIF_F_HW_CSUM | NETIF_F_SG,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 80fde5f06fce..44f4bffb5f24 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1224,6 +1224,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	struct net_device *dev = VNET_PORT_TO_NET_DEVICE(port);
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_TX_RING];
 	struct sk_buff *segs, *curr, *next;
+	netdev_features_t tmp;
 	int maclen, datalen;
 	int status;
 	int gso_size, gso_type, gso_segs;
@@ -1274,7 +1275,9 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
+	netdev_feature_copy(&tmp, dev->features);
+	netdev_feature_clear_bit(NETIF_F_TSO_BIT, &tmp);
+	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out_dropped;
 
-- 
2.33.0

