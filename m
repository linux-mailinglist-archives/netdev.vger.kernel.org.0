Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043A041C975
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345124AbhI2QFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12997 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345652AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbd0Z3WzWXfs;
        Wed, 29 Sep 2021 23:57:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 163/167] staging: qlge: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:30 +0800
Message-ID: <20210929155334.12454-164-shenjian15@huawei.com>
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
 drivers/staging/qlge/qlge_main.c | 59 ++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1dc849378a0f..efbeb0a1a601 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -386,7 +386,8 @@ static int qlge_set_mac_addr_reg(struct qlge_adapter *qdev, u8 *addr, u32 type,
 		cam_output = (CAM_OUT_ROUTE_NIC |
 			      (qdev->func << CAM_OUT_FUNC_SHIFT) |
 			      (0 << CAM_OUT_CQ_ID_SHIFT));
-		if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    qdev->ndev->features))
 			cam_output |= CAM_OUT_RV;
 		/* route to NIC core */
 		qlge_write32(qdev, MAC_ADDR_DATA, cam_output);
@@ -1399,7 +1400,8 @@ static void qlge_update_mac_hdr_len(struct qlge_adapter *qdev,
 {
 	u16 *tags;
 
-	if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    qdev->ndev->features))
 		return;
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) {
 		tags = (u16 *)page;
@@ -1514,7 +1516,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 	skb->protocol = eth_type_trans(skb, ndev);
 	skb_checksum_none_assert(skb);
 
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1621,7 +1623,7 @@ static void qlge_process_mac_rx_skb(struct qlge_adapter *qdev,
 	/* If rx checksum is on, and there are no
 	 * csum or frame errors.
 	 */
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1908,7 +1910,7 @@ static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
 	/* If rx checksum is on, and there are no
 	 * csum or frame errors.
 	 */
-	if ((ndev->features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features) &&
 	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
@@ -1947,7 +1949,8 @@ static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u16 vlan_id = ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) &&
-		       (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)) ?
+		       netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       qdev->ndev->features)) ?
 		((le16_to_cpu(ib_mac_rsp->vlan_id) &
 		  IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;
 
@@ -2227,7 +2230,7 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
-	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
 		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
 			     NIC_RCV_CFG_VLAN_MATCH_AND_NON);
 	} else {
@@ -2256,7 +2259,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 	}
 
 	/* update the features with resent change */
-	ndev->features = features;
+	netdev_feature_copy(&ndev->features, features);
 
 	if (need_restart) {
 		status = qlge_adapter_up(qdev);
@@ -2273,10 +2276,12 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 static int qlge_set_features(struct net_device *ndev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 	int err;
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	netdev_feature_xor(&changed, ndev->features, features);
+
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		/* Update the behavior of vlan accel in the adapter */
 		err = qlge_update_hw_vlan_features(ndev, features);
 		if (err)
@@ -3575,7 +3580,8 @@ static int qlge_adapter_initialize(struct qlge_adapter *qdev)
 	/* Set the default queue, and VLAN behavior. */
 	value = NIC_RCV_CFG_DFQ;
 	mask = NIC_RCV_CFG_DFQ_MASK;
-	if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    qdev->ndev->features)) {
 		value |= NIC_RCV_CFG_RV;
 		mask |= (NIC_RCV_CFG_RV << 16);
 	}
@@ -4571,23 +4577,26 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	ndev->hw_features = NETIF_F_SG |
-		NETIF_F_IP_CSUM |
-		NETIF_F_TSO |
-		NETIF_F_TSO_ECN |
-		NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_RXCSUM;
-	ndev->features = ndev->hw_features;
-	ndev->vlan_features = ndev->hw_features;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG |
+				NETIF_F_IP_CSUM |
+				NETIF_F_TSO |
+				NETIF_F_TSO_ECN |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_RXCSUM,
+				&ndev->hw_features);
+	netdev_feature_copy(&ndev->features, ndev->hw_features);
+	netdev_feature_copy(&ndev->vlan_features, ndev->hw_features);
 	/* vlan gets same features (except vlan filter) */
-	ndev->vlan_features &= ~(NETIF_F_HW_VLAN_CTAG_FILTER |
-				 NETIF_F_HW_VLAN_CTAG_TX |
-				 NETIF_F_HW_VLAN_CTAG_RX);
+	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				  NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX,
+				  &ndev->vlan_features);
 
 	if (test_bit(QL_DMA64, &qdev->flags))
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 
 	/*
 	 * Set up net_device structure.
-- 
2.33.0

