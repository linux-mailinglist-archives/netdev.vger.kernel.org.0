Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8093C41C933
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345780AbhI2QC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:26 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13843 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345498AbhI2P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWY07pkz8vWB;
        Wed, 29 Sep 2021 23:53:29 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 081/167] net: usb: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:08 +0800
Message-ID: <20210929155334.12454-82-shenjian15@huawei.com>
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
 drivers/net/usb/aqc111.c               | 42 +++++++++--------
 drivers/net/usb/ax88179_178a.c         | 26 ++++++-----
 drivers/net/usb/cdc-phonet.c           |  2 +-
 drivers/net/usb/cdc_mbim.c             |  4 +-
 drivers/net/usb/lan78xx.c              | 34 ++++++++------
 drivers/net/usb/r8152.c                | 64 ++++++++++++++++----------
 drivers/net/usb/smsc75xx.c             | 14 +++---
 drivers/net/usb/smsc95xx.c             | 19 +++++---
 drivers/usb/gadget/function/f_phonet.c |  2 +-
 9 files changed, 123 insertions(+), 84 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 73b97f4cc1ec..1363f64f4c86 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -567,27 +567,28 @@ static int aqc111_set_features(struct net_device *net,
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed;
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
-	if (changed & NETIF_F_IP_CSUM) {
+	netdev_feature_xor(&changed, net->features, features);
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCP | SFR_TXCOE_UDP;
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL,
 				 1, 1, &reg8);
 	}
 
-	if (changed & NETIF_F_IPV6_CSUM) {
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCPV6 | SFR_TXCOE_UDPV6;
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL,
 				 1, 1, &reg8);
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL, 1, 1, &reg8);
-		if (features & NETIF_F_RXCSUM) {
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 			aqc111_data->rx_checksum = 1;
 			reg8 &= ~(SFR_RXCOE_IP | SFR_RXCOE_TCP | SFR_RXCOE_UDP |
 				  SFR_RXCOE_TCPV6 | SFR_RXCOE_UDPV6);
@@ -600,8 +601,9 @@ static int aqc111_set_features(struct net_device *net,
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL,
 				 1, 1, &reg8);
 	}
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    features)) {
 			u16 i = 0;
 
 			for (i = 0; i < 256; i++) {
@@ -731,9 +733,10 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	dev->net->hw_features |= AQ_SUPPORT_HW_FEATURE;
-	dev->net->features |= AQ_SUPPORT_FEATURE;
-	dev->net->vlan_features |= AQ_SUPPORT_VLAN_FEATURE;
+	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, &dev->net->hw_features);
+	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, &dev->net->features);
+	netdev_feature_set_bits(AQ_SUPPORT_VLAN_FEATURE,
+				&dev->net->vlan_features);
 
 	netif_set_gso_max_size(dev->net, 65535);
 
@@ -881,17 +884,17 @@ static void aqc111_configure_csum_offload(struct usbnet *dev)
 {
 	u8 reg8 = 0;
 
-	if (dev->net->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->net->features)) {
 		reg8 |= SFR_RXCOE_IP | SFR_RXCOE_TCP | SFR_RXCOE_UDP |
 			SFR_RXCOE_TCPV6 | SFR_RXCOE_UDPV6;
 	}
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL, 1, 1, &reg8);
 
 	reg8 = 0;
-	if (dev->net->features & NETIF_F_IP_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, dev->net->features))
 		reg8 |= SFR_TXCOE_IP | SFR_TXCOE_TCP | SFR_TXCOE_UDP;
 
-	if (dev->net->features & NETIF_F_IPV6_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, dev->net->features))
 		reg8 |= SFR_TXCOE_TCPV6 | SFR_TXCOE_UDPV6;
 
 	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
@@ -908,7 +911,8 @@ static int aqc111_link_reset(struct usbnet *dev)
 
 		/* Vlan Tag Filter */
 		reg8 = SFR_VLAN_CONTROL_VSO;
-		if (dev->net->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    dev->net->features))
 			reg8 |= SFR_VLAN_CONTROL_VFE;
 
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_VLAN_ID_CONTROL,
@@ -996,9 +1000,10 @@ static int aqc111_reset(struct usbnet *dev)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	dev->net->hw_features |= AQ_SUPPORT_HW_FEATURE;
-	dev->net->features |= AQ_SUPPORT_FEATURE;
-	dev->net->vlan_features |= AQ_SUPPORT_VLAN_FEATURE;
+	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, &dev->net->hw_features);
+	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, &dev->net->features);
+	netdev_feature_set_bits(AQ_SUPPORT_VLAN_FEATURE,
+				&dev->net->vlan_features);
 
 	/* Power up ethernet PHY */
 	aqc111_data->phy_cfg = AQ_PHY_POWER_EN;
@@ -1209,7 +1214,8 @@ static struct sk_buff *aqc111_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 			   AQ_TX_DESC_VLAN_SHIFT;
 	}
 
-	if (!dev->can_dma_sg && (dev->net->features & NETIF_F_SG) &&
+	if (!dev->can_dma_sg &&
+	    netdev_feature_test_bit(NETIF_F_SG_BIT, dev->net->features) &&
 	    skb_linearize(skb))
 		return NULL;
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index f25448a08870..0099d55f9c90 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -952,21 +952,23 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 {
 	u8 tmp;
 	struct usbnet *dev = netdev_priv(net);
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed;
 
-	if (changed & NETIF_F_IP_CSUM) {
+	netdev_feature_xor(&changed, net->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
-	if (changed & NETIF_F_IPV6_CSUM) {
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
 		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 		       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
@@ -1377,11 +1379,11 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM, &dev->net->features);
 
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				 NETIF_F_RXCSUM, &dev->net->hw_features);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
@@ -1664,11 +1666,11 @@ static int ax88179_reset(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_HIGH,
 			  1, 1, tmp);
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM, &dev->net->features);
 
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				 NETIF_F_RXCSUM, &dev->net->hw_features);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index e1da9102a540..a65be627dc03 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -275,7 +275,7 @@ static const struct net_device_ops usbpn_ops = {
 
 static void usbpn_setup(struct net_device *dev)
 {
-	dev->features		= 0;
+	netdev_feature_zero(&dev->features);
 	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
 	dev->type		= ARPHRD_PHONET;
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 82bb5ed94c48..964e5260364a 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -184,7 +184,9 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->flags |= IFF_NOARP;
 
 	/* no need to put the VLAN tci in the packet headers */
-	dev->net->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_FILTER,
+				&dev->net->features);
 
 	/* monitor VLAN additions and removals */
 	dev->net->netdev_ops = &cdc_mbim_netdev_ops;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 7a60cc0f6aad..aad719ebf318 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2445,7 +2445,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_COE_ | RFE_CTL_IP_COE_;
 		pdata->rfe_ctl |= RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_;
 	} else {
@@ -2453,12 +2453,12 @@ static int lan78xx_set_features(struct net_device *netdev,
 		pdata->rfe_ctl &= ~(RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_);
 	}
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_STRIP_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_STRIP_;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_FILTER_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_FILTER_;
@@ -3250,24 +3250,28 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	INIT_WORK(&pdata->set_vlan, lan78xx_deferred_vlan_write);
 
-	dev->net->features = 0;
+	netdev_feature_zero(&dev->net->features);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
+				       &dev->net->features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
 
 	if (DEFAULT_TSO_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_SG;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_SG,
+					&dev->net->features);
 
 	if (DEFAULT_VLAN_RX_OFFLOAD)
-		dev->net->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				       &dev->net->features);
 
 	if (DEFAULT_VLAN_FILTER_ENABLE)
-		dev->net->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &dev->net->features);
 
-	dev->net->hw_features = dev->net->features;
+	netdev_feature_copy(&dev->net->hw_features, dev->net->features);
 
 	ret = lan78xx_setup_irq_domain(dev);
 	if (ret < 0) {
@@ -3334,10 +3338,11 @@ static void lan78xx_rx_csum_offload(struct lan78xx_net *dev,
 	/* HW Checksum offload appears to be flawed if used when not stripping
 	 * VLAN headers. Drop back to S/W checksums under these conditions.
 	 */
-	if (!(dev->net->features & NETIF_F_RXCSUM) ||
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->net->features) ||
 	    unlikely(rx_cmd_a & RX_CMD_A_ICSM_) ||
 	    ((rx_cmd_a & RX_CMD_A_FVTG_) &&
-	     !(dev->net->features & NETIF_F_HW_VLAN_CTAG_RX))) {
+	     !netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				      dev->net->features))) {
 		skb->ip_summed = CHECKSUM_NONE;
 	} else {
 		skb->csum = ntohs((u16)(rx_cmd_b >> RX_CMD_B_CSUM_SHIFT_));
@@ -3349,7 +3354,8 @@ static void lan78xx_rx_vlan_offload(struct lan78xx_net *dev,
 				    struct sk_buff *skb,
 				    u32 rx_cmd_a, u32 rx_cmd_b)
 {
-	if ((dev->net->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->net->features) &&
 	    (rx_cmd_a & RX_CMD_A_FVTG_))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       (rx_cmd_b & 0xffff));
@@ -3981,7 +3987,7 @@ static void lan78xx_features_check(struct sk_buff *skb,
 				   netdev_features_t *features)
 {
 	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 
 	vlan_features_check(skb, features);
 	vxlan_features_check(skb, features);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5bb327b8d8e0..31fb92ae23c2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2092,11 +2092,13 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 				  struct sk_buff_head *list)
 {
 	if (skb_shinfo(skb)->gso_size) {
-		netdev_features_t features = tp->netdev->features;
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
+		netdev_features_t features;
 
-		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
+		netdev_feature_copy(&features, tp->netdev->features);
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_IPV6_CSUM |
+					  NETIF_F_TSO6, &features);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;
@@ -2333,7 +2335,7 @@ static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
 	u8 checksum = CHECKSUM_NONE;
 	u32 opts2, opts3;
 
-	if (!(tp->netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, tp->netdev->features))
 		goto return_result;
 
 	opts2 = le32_to_cpu(rx_desc->opts2);
@@ -2749,9 +2751,10 @@ static void rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 	int offset = skb_transport_offset(skb);
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) && offset > max_offset)
-		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					  features);
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
-		*features &= ~NETIF_F_GSO_MASK;
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 }
 
 static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
@@ -3230,18 +3233,21 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
 	struct r8152 *tp = netdev_priv(dev);
+	netdev_features_t changed;
 	int ret;
 
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
 
+	netdev_feature_xor(&changed, dev->features, features);
+
 	mutex_lock(&tp->control);
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
-		if (features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    features))
 			rtl_rx_vlan_en(tp, true);
 		else
 			rtl_rx_vlan_en(tp, false);
@@ -5405,7 +5411,8 @@ static void r8152b_exit_oob(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_USB, USB_TX_DMA,
 			TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp, netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   tp->netdev->features));
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
@@ -5850,7 +5857,8 @@ static void r8153_first_init(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp, netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   tp->netdev->features));
 
 	rtl8153_change_mtu(tp);
 
@@ -6351,7 +6359,8 @@ static void rtl8153c_up(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp, netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   tp->netdev->features));
 
 	rtl8153c_change_mtu(tp);
 
@@ -6456,7 +6465,8 @@ static void rtl8156_up(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	rtl_rx_vlan_en(tp, netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   tp->netdev->features));
 
 	rtl8156_change_mtu(tp);
 
@@ -9569,21 +9579,27 @@ static int rtl8152_probe(struct usb_interface *intf,
 	netdev->netdev_ops = &rtl8152_netdev_ops;
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
 
-	netdev->features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
-			    NETIF_F_TSO | NETIF_F_FRAGLIST | NETIF_F_IPV6_CSUM |
-			    NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_FRAGLIST |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
-			      NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
+				NETIF_F_TSO | NETIF_F_FRAGLIST |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX, &netdev->features);
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
+				NETIF_F_TSO | NETIF_F_FRAGLIST |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_TX, &netdev->hw_features);
+	netdev_feature_zero(&netdev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
+				&netdev->vlan_features);
 
 	if (tp->version == RTL_VER_01) {
-		netdev->features &= ~NETIF_F_RXCSUM;
-		netdev->hw_features &= ~NETIF_F_RXCSUM;
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
+					 &netdev->hw_features);
 	}
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 76f7af161313..87ad30084d2b 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -942,7 +942,7 @@ static int smsc75xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM;
 	else
 		pdata->rfe_ctl &= ~(RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM);
@@ -1472,13 +1472,15 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&dev->net->features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_RXCSUM,
+				&dev->net->hw_features);
 
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
@@ -2167,7 +2169,7 @@ static int smsc75xx_resume(struct usb_interface *intf)
 static void smsc75xx_rx_csum_offload(struct usbnet *dev, struct sk_buff *skb,
 				     u32 rx_cmd_a, u32 rx_cmd_b)
 {
-	if (!(dev->net->features & NETIF_F_RXCSUM) ||
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->net->features) ||
 	    unlikely(rx_cmd_a & RX_CMD_A_LCSM)) {
 		skb->ip_summed = CHECKSUM_NONE;
 	} else {
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 7d953974eb9b..1bedb67af06f 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -615,12 +615,12 @@ static int smsc95xx_set_features(struct net_device *netdev,
 	if (ret < 0)
 		return ret;
 
-	if (features & NETIF_F_IP_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features))
 		read_buf |= Tx_COE_EN_;
 	else
 		read_buf &= ~Tx_COE_EN_;
 
-	if (features & NETIF_F_RXCSUM)
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		read_buf |= Rx_COE_EN_;
 	else
 		read_buf &= ~Rx_COE_EN_;
@@ -1080,11 +1080,14 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * for ipv4 packets.
 	 */
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_IP_CSUM;
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+				       &dev->net->features);
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	netdev_feature_zero(&dev->net->hw_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+				&dev->net->hw_features);
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
 	smsc95xx_init_mac_address(dev);
@@ -1824,7 +1827,8 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 			/* last frame in this batch */
 			if (skb->len == size) {
-				if (dev->net->features & NETIF_F_RXCSUM)
+				if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+							    dev->net->features))
 					smsc95xx_rx_csum_offload(skb);
 				skb_trim(skb, skb->len - 4); /* remove fcs */
 				skb->truesize = size + sizeof(struct sk_buff);
@@ -1842,7 +1846,8 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			ax_skb->data = packet;
 			skb_set_tail_pointer(ax_skb, size);
 
-			if (dev->net->features & NETIF_F_RXCSUM)
+			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+						    dev->net->features))
 				smsc95xx_rx_csum_offload(ax_skb);
 			skb_trim(ax_skb, ax_skb->len - 4); /* remove fcs */
 			ax_skb->truesize = size + sizeof(struct sk_buff);
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 0b468f5d55bc..1d63d28425e6 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -267,7 +267,7 @@ static const struct net_device_ops pn_netdev_ops = {
 
 static void pn_net_setup(struct net_device *dev)
 {
-	dev->features		= 0;
+	netdev_feature_zero(&dev->features);
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= PHONET_DEV_MTU;
-- 
2.33.0

