Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29BD41C8F9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345524AbhI2QA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13838 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344284AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWR3dcFz8yrS;
        Wed, 29 Sep 2021 23:53:23 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 039/167] dsa: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:26 +0800
Message-ID: <20210929155334.12454-40-shenjian15@huawei.com>
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
 drivers/net/dsa/xrs700x/xrs700x.c |  6 ++++--
 net/dsa/slave.c                   | 24 +++++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 469420941054..f5b5807b2313 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -639,7 +639,8 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features |= XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_feature_set_bits(XRS7000X_SUPPORTED_HSR_FEATURES,
+					&slave->features);
 	}
 
 	return 0;
@@ -693,7 +694,8 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
-		slave->features &= ~XRS7000X_SUPPORTED_HSR_FEATURES;
+		netdev_feature_clear_bits(XRS7000X_SUPPORTED_HSR_FEATURES,
+					  &slave->features);
 	}
 
 	return 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a2bf2d8ac65b..dbd53653b5f0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1460,12 +1460,14 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 	int err;
 
 	if (vlan_filtering) {
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &slave->features);
 
 		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
 		if (err) {
 			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
-			slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						 &slave->features);
 			return err;
 		}
 	} else {
@@ -1473,7 +1475,8 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 		if (err)
 			return err;
 
-		slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &slave->features);
 	}
 
 	return 0;
@@ -1883,13 +1886,16 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	slave->features = master->vlan_features | NETIF_F_HW_TC;
-	slave->hw_features |= NETIF_F_HW_TC;
-	slave->features |= NETIF_F_LLTX;
+	netdev_feature_copy(&slave->features, master->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &slave->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &slave->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &slave->features);
 	if (slave->needed_tailroom)
-		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_FRAGLIST,
+					  &slave->features);
 	if (ds->needs_standalone_vlan_filtering)
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &slave->features);
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
@@ -1968,7 +1974,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
-	slave_dev->vlan_features = master->vlan_features;
+	netdev_feature_copy(&slave_dev->vlan_features, master->vlan_features);
 
 	p = netdev_priv(slave_dev);
 	slave_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-- 
2.33.0

