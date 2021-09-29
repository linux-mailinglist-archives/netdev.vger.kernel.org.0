Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB641C914
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345933AbhI2QBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23325 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345485AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWt6MRTzR9dj;
        Wed, 29 Sep 2021 23:53:46 +0800 (CST)
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
Subject: [RFCv2 net-next 057/167] net: thunderbolt: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:44 +0800
Message-ID: <20210929155334.12454-58-shenjian15@huawei.com>
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
 drivers/net/thunderbolt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 9a6a8353e192..0fd4cd06fa6b 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1257,9 +1257,13 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 * we need to announce support for most of the offloading
 	 * features here.
 	 */
-	dev->hw_features = NETIF_F_SG | NETIF_F_ALL_TSO | NETIF_F_GRO |
-			   NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_ALL_TSO | NETIF_F_GRO |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
 	netif_napi_add(dev, &net->napi, tbnet_poll, NAPI_POLL_WEIGHT);
-- 
2.33.0

