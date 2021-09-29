Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183BB41C95D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345599AbhI2QEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:47 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24148 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345637AbhI2QAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbb2bcCz1DHNh;
        Wed, 29 Sep 2021 23:56:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 151/167] um: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:18 +0800
Message-ID: <20210929155334.12454-152-shenjian15@huawei.com>
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
 arch/um/drivers/vector_kern.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 88cc24a58742..2c32794a87b1 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1345,7 +1345,8 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static void vector_fix_features(struct net_device *dev,
 				netdev_features_t *features)
 {
-	*features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+	netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				  &features);
 }
 
 static int vector_set_features(struct net_device *dev,
@@ -1356,7 +1357,7 @@ static int vector_set_features(struct net_device *dev,
 	 * no way to negotiate it on raw sockets, so we can change
 	 * only our side.
 	 */
-	if (features & NETIF_F_GRO)
+	if (netdev_feature_test_bit(NETIF_F_GRO_BIT, features))
 		/* All new frame buffers will be GRO-sized */
 		vp->req_size = 65536;
 	else
@@ -1630,7 +1631,10 @@ static void vector_eth_configure(
 		.bpf			= NULL
 	});
 
-	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST,
+				&dev->hw_features);
+	netdev_feature_copy(&dev->features, dev->hw_features);
 	tasklet_setup(&vp->tx_poll, vector_tx_poll);
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
-- 
2.33.0

