Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B54B41C949
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346233AbhI2QDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23328 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbhI2QAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:02 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX05jsGzQv3x;
        Wed, 29 Sep 2021 23:53:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 096/167] net: nvidia: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:23 +0800
Message-ID: <20210929155334.12454-97-shenjian15@huawei.com>
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
 drivers/net/ethernet/nvidia/forcedeth.c | 60 +++++++++++++++----------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index e1f16988cb75..48b253e54888 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3052,7 +3052,8 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 			 * here. Even if vlan rx accel is disabled,
 			 * NV_RX3_VLAN_TAG_PRESENT is pseudo randomly set.
 			 */
-			if (dev->features & NETIF_F_HW_VLAN_CTAG_RX &&
+			if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						    dev->features) &&
 			    vlanflags & NV_RX3_VLAN_TAG_PRESENT) {
 				u16 vid = vlanflags & NV_RX3_VLAN_TAG_MASK;
 
@@ -4874,7 +4875,7 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 
 	spin_lock_irqsave(&np->lock, flags);
 	miicontrol = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
-	if (features & NETIF_F_LOOPBACK) {
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features)) {
 		if (miicontrol & BMCR_LOOPBACK) {
 			spin_unlock_irqrestore(&np->lock, flags);
 			netdev_info(dev, "Loopback already enabled\n");
@@ -4924,8 +4925,9 @@ static void nv_fix_features(struct net_device *dev,
 			    netdev_features_t *features)
 {
 	/* vlan is dependent on rx checksum offload */
-	if (*features & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX))
-		*features |= NETIF_F_RXCSUM;
+	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				     NETIF_F_HW_VLAN_CTAG_RX, *features))
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, features);
 }
 
 static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
@@ -4934,12 +4936,12 @@ static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 	spin_lock_irq(&np->lock);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANSTRIP;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANSTRIP;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANINS;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANINS;
@@ -4953,19 +4955,22 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 	int retval;
 
-	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev)) {
+	netdev_feature_xor(&changed, dev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
+	    netif_running(dev)) {
 		retval = nv_set_loopback(dev, features);
 		if (retval != 0)
 			return retval;
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		spin_lock_irq(&np->lock);
 
-		if (features & NETIF_F_RXCSUM)
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 			np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
 		else
 			np->txrxctl_bits &= ~NVREG_TXRXCTL_RXCHECK;
@@ -4976,7 +4981,8 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 		spin_unlock_irq(&np->lock);
 	}
 
-	if (changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX))
+	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				     NETIF_F_HW_VLAN_CTAG_RX, changed))
 		nv_vlan_mode(dev, features);
 
 	return 0;
@@ -5607,7 +5613,7 @@ static int nv_open(struct net_device *dev)
 	/* If the loopback feature was set while the device was down, make sure
 	 * that it's set correctly now.
 	 */
-	if (dev->features & NETIF_F_LOOPBACK)
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, dev->features))
 		nv_set_loopback(dev, dev->features);
 
 	return 0;
@@ -5784,7 +5790,8 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 				dev_info(&pci_dev->dev,
 					 "64-bit DMA failed, using 32-bit addressing\n");
 			else
-				dev->features |= NETIF_F_HIGHDMA;
+				netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+						       &dev->features);
 		}
 	} else if (id->driver_data & DEV_HAS_LARGEDESC) {
 		/* packet format 2: supports jumbo frames */
@@ -5802,21 +5809,23 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-			NETIF_F_TSO | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
+					NETIF_F_TSO | NETIF_F_RXCSUM,
+					&dev->hw_features);
 	}
 
 	np->vlanctl_bits = 0;
 	if (id->driver_data & DEV_HAS_VLAN) {
 		np->vlanctl_bits = NVREG_VLANCONTROL_ENABLE;
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
+					NETIF_F_HW_VLAN_CTAG_TX,
+					&dev->hw_features);
 	}
 
-	dev->features |= dev->hw_features;
+	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
 
 	/* Add loopback capability to the device. */
-	dev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &dev->hw_features);
 
 	/* MTU range: 64 - 1500 or 9100 */
 	dev->min_mtu = ETH_ZLEN + ETH_FCS_LEN;
@@ -6107,13 +6116,16 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		 dev->name, np->phy_oui, np->phyaddr, dev->dev_addr);
 
 	dev_info(&pci_dev->dev, "%s%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
-		 dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		 dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
+		 netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT, dev->features) ?
+			"highdma " : "",
+		 netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
+					  dev->features) ?
 			"csum " : "",
-		 dev->features & (NETIF_F_HW_VLAN_CTAG_RX |
-				  NETIF_F_HW_VLAN_CTAG_TX) ?
+		 netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_RX |
+					  NETIF_F_HW_VLAN_CTAG_TX,
+					  dev->features) ?
 			"vlan " : "",
-		 dev->features & (NETIF_F_LOOPBACK) ?
+		 netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, dev->features) ?
 			"loopback " : "",
 		 id->driver_data & DEV_HAS_POWER_CNTRL ? "pwrctl " : "",
 		 id->driver_data & DEV_HAS_MGMT_UNIT ? "mgmt " : "",
-- 
2.33.0

