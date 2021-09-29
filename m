Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14C341C977
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345583AbhI2QFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23249 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345658AbhI2QAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc21Nntz8tY7;
        Wed, 29 Sep 2021 23:57:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 124/167] net: enic: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:51 +0800
Message-ID: <20210929155334.12454-125-shenjian15@huawei.com>
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
 drivers/net/ethernet/cisco/enic/enic_main.c | 63 +++++++++++++--------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 5bc075331343..fde5078c9132 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -293,7 +293,8 @@ static void enic_features_check(struct sk_buff *skb, struct net_device *dev,
 	return;
 
 out:
-	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+				  features);
 }
 
 int enic_is_dynamic(struct enic *enic)
@@ -1357,8 +1358,9 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 		skb_put(skb, bytes_written);
 		skb->protocol = eth_type_trans(skb, netdev);
 		skb_record_rx_queue(skb, q_number);
-		if ((netdev->features & NETIF_F_RXHASH) && rss_hash &&
-		    (type == 3)) {
+		if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+					    netdev->features) &&
+		    rss_hash && (type == 3)) {
 			switch (rss_type) {
 			case CQ_ENET_RQ_DESC_RSS_TYPE_TCP_IPv4:
 			case CQ_ENET_RQ_DESC_RSS_TYPE_TCP_IPv6:
@@ -1400,7 +1402,9 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 		 * inner csum_ok. outer_csum_ok is set by hw when outer udp
 		 * csum is correct or is zero.
 		 */
-		if ((netdev->features & NETIF_F_RXCSUM) && !csum_not_calc &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					    netdev->features) &&
+		    !csum_not_calc &&
 		    tcp_udp_csum_ok && outer_csum_ok &&
 		    (ipv4_csum_ok || ipv6)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1411,7 +1415,8 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
 
 		skb_mark_napi_id(skb, &enic->napi[rq->index]);
-		if (!(netdev->features & NETIF_F_GRO))
+		if (!netdev_feature_test_bit(NETIF_F_GRO_BIT,
+					     netdev->features))
 			netif_receive_skb(skb);
 		else
 			napi_gro_receive(&enic->napi[q_number], skb);
@@ -2895,34 +2900,42 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 2 * HZ;
 	enic_set_ethtool_ops(netdev);
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
 	if (ENIC_SETTING(enic, LOOP)) {
-		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					 &netdev->features);
 		enic->loop_enable = 1;
 		enic->loop_tag = enic->config.loop_tag;
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
 	}
 	if (ENIC_SETTING(enic, TXCSUM))
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
+					&netdev->hw_features);
 	if (ENIC_SETTING(enic, TSO))
-		netdev->hw_features |= NETIF_F_TSO |
-			NETIF_F_TSO6 | NETIF_F_TSO_ECN;
+		netdev_feature_set_bits(NETIF_F_TSO |
+					NETIF_F_TSO6 | NETIF_F_TSO_ECN,
+					&netdev->hw_features);
 	if (ENIC_SETTING(enic, RSS))
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
+				       &netdev->hw_features);
 	if (ENIC_SETTING(enic, RXCSUM))
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_features);
 	if (ENIC_SETTING(enic, VXLAN)) {
 		u64 patch_level;
 		u64 a1 = 0;
 
-		netdev->hw_enc_features |= NETIF_F_RXCSUM		|
-					   NETIF_F_TSO			|
-					   NETIF_F_TSO6			|
-					   NETIF_F_TSO_ECN		|
-					   NETIF_F_GSO_UDP_TUNNEL	|
-					   NETIF_F_HW_CSUM		|
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_features |= netdev->hw_enc_features;
+		netdev_feature_set_bits(NETIF_F_RXCSUM		|
+					NETIF_F_TSO		|
+					NETIF_F_TSO6		|
+					NETIF_F_TSO_ECN		|
+					NETIF_F_GSO_UDP_TUNNEL	|
+					NETIF_F_HW_CSUM		|
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&netdev->hw_enc_features);
+		netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+				  netdev->hw_enc_features);
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
 		 *	    fcoe bit = encap
@@ -2955,15 +2968,17 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->features);
 
 #ifdef CONFIG_RFS_ACCEL
-	netdev->hw_features |= NETIF_F_NTUPLE;
+	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
 #endif
 
 	if (using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-- 
2.33.0

