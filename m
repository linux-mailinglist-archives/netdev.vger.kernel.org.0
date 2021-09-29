Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4060C41C95E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbhI2QEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24146 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345629AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbX07zCz1DHNG;
        Wed, 29 Sep 2021 23:56:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 129/167] net: myricom: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:56 +0800
Message-ID: <20210929155334.12454-130-shenjian15@huawei.com>
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
 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c1a75b08ced7..542cb42f7ea5 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1281,8 +1281,8 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 	va = addr;
 	va += MXGEFW_PAD;
 	veh = (struct vlan_ethhdr *)va;
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) ==
-	    NETIF_F_HW_VLAN_CTAG_RX &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->features) &&
 	    veh->h_vlan_proto == htons(ETH_P_8021Q)) {
 		/* fixup csum if needed */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -1360,7 +1360,7 @@ myri10ge_rx_done(struct myri10ge_slice_state *ss, int len, __wsum csum)
 	skb->len = len;
 	skb->data_len = len;
 	skb->truesize += len;
-	if (dev->features & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, dev->features)) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum;
 	}
@@ -2889,9 +2889,12 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
 	struct myri10ge_slice_state *ss;
+	netdev_features_t tmp;
 	netdev_tx_t status;
 
-	segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO6);
+	netdev_feature_copy(&tmp, dev->features);
+	netdev_feature_clear_bit(NETIF_F_TSO6_BIT, &tmp);
+	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto drop;
 
@@ -3868,21 +3871,27 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mtu = myri10ge_initial_mtu;
 
 	netdev->netdev_ops = &myri10ge_netdev_ops;
-	netdev->hw_features = mgp->features | NETIF_F_RXCSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(mgp->features | NETIF_F_RXCSUM,
+				&netdev->hw_features);
 
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			       &netdev->hw_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
 
 	if (dac_enabled)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+
+	netdev_feature_set_bits(mgp->features, &netdev->vlan_features);
 
-	netdev->vlan_features |= mgp->features;
 	if (mgp->fw_ver_tiny < 37)
-		netdev->vlan_features &= ~NETIF_F_TSO6;
+		netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+					 &netdev->vlan_features);
 	if (mgp->fw_ver_tiny < 32)
-		netdev->vlan_features &= ~NETIF_F_TSO;
+		netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+					 &netdev->vlan_features);
 
 	/* make sure we can get an irq, and that MSI can be
 	 * setup (if available). */
-- 
2.33.0

