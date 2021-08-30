Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C373FB75D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhH3N4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:56:10 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbhH3Nz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 09:55:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GysDD6BxzzbfhH;
        Mon, 30 Aug 2021 21:51:08 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 21:55:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 21:55:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: refine function hns3_set_default_feature()
Date:   Mon, 30 Aug 2021 21:51:06 +0800
Message-ID: <1630331469-13707-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
References: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the driver sets default feature for netdev->features,
netdev->hw_features, netdev->vlan_features and
netdev->hw_enc_features separately. It's fussy, because most
of the feature bits are same. So refine it by copy value from
netdev->features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 62 +++++++------------------
 1 file changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0680d22485b9..18dd962444d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3126,11 +3126,6 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->hw_enc_features |= NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID | NETIF_F_FRAGLIST;
-
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
 	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
@@ -3140,62 +3135,37 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
-	netdev->vlan_features |= NETIF_F_RXCSUM |
-		NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO |
-		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
-
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
-
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->hw_features |= NETIF_F_GRO_HW;
 		netdev->features |= NETIF_F_GRO_HW;
 
-		if (!(h->flags & HNAE3_SUPPORT_VF)) {
-			netdev->hw_features |= NETIF_F_NTUPLE;
+		if (!(h->flags & HNAE3_SUPPORT_VF))
 			netdev->features |= NETIF_F_NTUPLE;
-		}
 	}
 
-	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_L4;
+	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_L4;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_L4;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_L4;
-	}
 
-	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_HW_CSUM;
+	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_HW_CSUM;
-		netdev->vlan_features |= NETIF_F_HW_CSUM;
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
-	} else {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	else
 		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		netdev->vlan_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	}
 
-	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	}
 
-	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps)) {
-		netdev->hw_features |= NETIF_F_HW_TC;
+	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
 		netdev->features |= NETIF_F_HW_TC;
-	}
 
-	if (test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->hw_features |= netdev->features;
+	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
+		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+
+	netdev->vlan_features |= netdev->features &
+		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
+		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
+		  NETIF_F_HW_TC);
+
+	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
-- 
2.8.1

