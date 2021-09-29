Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57EF41C986
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345938AbhI2QGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:14 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24135 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345690AbhI2QAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbc6hLyz1DHJj;
        Wed, 29 Sep 2021 23:57:00 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:19 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 161/167] net: openvswitch: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:28 +0800
Message-ID: <20210929155334.12454-162-shenjian15@huawei.com>
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
 net/openvswitch/datapath.c           |  5 ++++-
 net/openvswitch/vport-internal_dev.c | 24 +++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886..dfb69428c6b2 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -320,10 +320,13 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	unsigned int gso_type = skb_shinfo(skb)->gso_type;
 	struct sw_flow_key later_key;
 	struct sk_buff *segs, *nskb;
+	netdev_features_t feature;
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
+	netdev_feature_zero(&feature);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &feature);
+	segs = __skb_gso_segment(skb, feature, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
 	if (segs == NULL)
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 5b2ee9c1c00b..27b7322be008 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -108,14 +108,19 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev->features = NETIF_F_LLTX | NETIF_F_SG | NETIF_F_FRAGLIST |
-			   NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			   NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
-
-	netdev->vlan_features = netdev->features;
-	netdev->hw_enc_features = netdev->features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
-	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
+	netdev_feature_zero(&netdev->features);
+	netdev_feature_set_bits(NETIF_F_LLTX | NETIF_F_SG | NETIF_F_FRAGLIST |
+				NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+				NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL,
+				&netdev->features);
+
+	netdev_feature_copy(&netdev->vlan_features, netdev->features);
+	netdev_feature_copy(&netdev->hw_enc_features, netdev->features);
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_STAG_TX,
+				&netdev->features);
+	netdev_feature_copy(&netdev->hw_features, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_LLTX_BIT, &netdev->hw_features);
 
 	eth_hw_addr_random(netdev);
 }
@@ -152,7 +157,8 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 	/* Restrict bridge port to current netns. */
 	if (vport->port_no == OVSP_LOCAL)
-		vport->dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+				       &vport->dev->features);
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
-- 
2.33.0

