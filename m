Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A769341C96B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346483AbhI2QE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24136 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345618AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbW69Fmz1DHN7;
        Wed, 29 Sep 2021 23:56:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:14 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 128/167] net: mana: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:55 +0800
Message-ID: <20210929155334.12454-129-shenjian15@huawei.com>
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
 drivers/net/ethernet/microsoft/mana/mana_en.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 1b21030308e5..859cf1b58051 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -940,12 +940,14 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	skb_checksum_none_assert(skb);
 	skb_record_rx_queue(skb, rxq_idx);
 
-	if ((ndev->features & NETIF_F_RXCSUM) && cqe->rx_iphdr_csum_succeed) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features) &&
+	    cqe->rx_iphdr_csum_succeed) {
 		if (cqe->rx_tcp_csum_succeed || cqe->rx_udp_csum_succeed)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	if (cqe->rx_hashtype != 0 && (ndev->features & NETIF_F_RXHASH)) {
+	if (cqe->rx_hashtype != 0 && netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+							     ndev->features)) {
 		hash_value = cqe->ppi[0].pkt_hash;
 
 		if (cqe->rx_hashtype & MANA_HASH_L4)
@@ -1801,12 +1803,14 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netdev_lockdep_set_classes(ndev);
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	ndev->hw_features |= NETIF_F_RXCSUM;
-	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
-	ndev->hw_features |= NETIF_F_RXHASH;
-	ndev->features = ndev->hw_features;
-	ndev->vlan_features = 0;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM, &ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6, &ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
+	netdev_feature_copy(&ndev->features, ndev->hw_features);
+	netdev_feature_zero(&ndev->vlan_features);
 
 	err = register_netdev(ndev);
 	if (err) {
-- 
2.33.0

