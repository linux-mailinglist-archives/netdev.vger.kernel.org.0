Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB64E666B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351449AbiCXP4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351429AbiCXP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB27AC93A
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPV9m5VzgzCrH2;
        Thu, 24 Mar 2022 23:53:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 10/20] net: use netdev_features_xor helpers
Date:   Thu, 24 Mar 2022 23:49:22 +0800
Message-ID: <20220324154932.17557-11-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the '^' operations of features by
netdev_features_xor helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/sfc/efx_common.c           | 2 +-
 drivers/net/ethernet/sfc/falcon/efx.c           | 2 +-
 include/linux/netdevice.h                       | 2 +-
 net/core/dev.c                                  | 2 +-
 net/ethtool/ioctl.c                             | 4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 38ab3692f073..bdb430ba15de 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2400,7 +2400,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	bool enable;
 	int ret;
 
-	changed = netdev->active_features ^ features;
+	changed = netdev_active_features_xor(netdev, features);
 
 	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f9600306813b..771319da0cd4 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -226,7 +226,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	tmp = net_dev->active_features ^ data;
+	tmp = netdev_active_features_xor(net_dev, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
 	    tmp & NETIF_F_RXFCS) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index ce558c1a1cbb..9f745263766d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2202,7 +2202,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	tmp = net_dev->active_features ^ data;
+	tmp = netdev_active_features_xor(net_dev, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c5b06798641c..f1b6cfe87166 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5418,7 +5418,7 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 {
 	netdev_features_t tmp;
 
-	tmp = f1 ^ f2;
+	tmp = netdev_features_xor(f1, f2);
 	if (tmp & NETIF_F_HW_CSUM) {
 		if (f1 & NETIF_F_HW_CSUM)
 			netdev_features_direct_or(&f1, netdev_ip_csum_features);
diff --git a/net/core/dev.c b/net/core/dev.c
index a387618f589d..af09e138475a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9625,7 +9625,7 @@ int __netdev_update_features(struct net_device *dev)
 	if (!err) {
 		netdev_features_t diff;
 
-		diff = features ^ dev->active_features;
+		diff = netdev_active_features_xor(dev, features);
 
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6943f97fad0e..ef2cde3594ad 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -163,7 +163,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_wanted_features_direct_or(dev, tmp);
 	__netdev_update_features(dev);
 
-	tmp = dev->wanted_features ^ dev->active_features;
+	tmp = netdev_wanted_features_xor(dev, dev->active_features);
 	if (tmp & valid)
 		ret |= ETHTOOL_F_WISH;
 
@@ -366,7 +366,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 				  &eth_all_features);
 
 	/* allow changing only bits set in hw_features */
-	changed = dev->active_features ^ features;
+	changed = netdev_active_features_xor(dev, features);
 	changed &= eth_all_features;
 	tmp = changed & ~dev->hw_features;
 	if (tmp)
-- 
2.33.0

