Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64741C994
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbhI2QGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23328 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344494AbhI2QBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:01:20 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX94TWgzRdPB;
        Wed, 29 Sep 2021 23:54:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:18 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 154/167] net: xfrm: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:21 +0800
Message-ID: <20210929155334.12454-155-shenjian15@huawei.com>
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
 net/xfrm/xfrm_device.c    | 31 ++++++++++++++++++++-----------
 net/xfrm/xfrm_interface.c |  6 +++---
 net/xfrm/xfrm_output.c    |  4 +++-
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e843b0d9e2a6..7c167060d959 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -104,16 +104,21 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	struct xfrm_state *x;
 	struct softnet_data *sd;
 	struct sk_buff *skb2, *nskb, *pskb = NULL;
-	netdev_features_t esp_features = features;
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct net_device *dev = skb->dev;
+	netdev_features_t esp_features;
 	struct sec_path *sp;
 
 	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
-	if (!(features & NETIF_F_HW_ESP))
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+	netdev_feature_copy(&esp_features, features);
+
+	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features)) {
+		netdev_feature_copy(&esp_features, features);
+		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK,
+					  &esp_features);
+	}
 
 	sp = skb_sec_path(skb);
 	x = sp->xvec[sp->len - 1];
@@ -138,7 +143,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
-		esp_features = esp_features & ~(NETIF_F_HW_ESP | NETIF_F_GSO_ESP);
+		netdev_feature_clear_bits(NETIF_F_HW_ESP | NETIF_F_GSO_ESP,
+					  &esp_features);
 
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
@@ -152,7 +158,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	if (!skb->next) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_feature_or(&esp_features, esp_features,
+				  skb->dev->gso_partial_features);
 		xfrm_outer_mode_prep(x, skb);
 
 		xo->flags |= XFRM_DEV_RESUME;
@@ -173,7 +180,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	skb_list_walk_safe(skb, skb2, nskb) {
-		esp_features |= skb->dev->gso_partial_features;
+		netdev_feature_or(&esp_features, esp_features,
+				  skb->dev->gso_partial_features);
 		skb_mark_not_on_list(skb2);
 
 		xo = xfrm_offload(skb2);
@@ -362,17 +370,18 @@ void xfrm_dev_backlog(struct softnet_data *sd)
 static int xfrm_api_check(struct net_device *dev)
 {
 #ifdef CONFIG_XFRM_OFFLOAD
-	if ((dev->features & NETIF_F_HW_ESP_TX_CSUM) &&
-	    !(dev->features & NETIF_F_HW_ESP))
+	if (netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, dev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, dev->features))
 		return NOTIFY_BAD;
 
-	if ((dev->features & NETIF_F_HW_ESP) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, dev->features) &&
 	    (!(dev->xfrmdev_ops &&
 	       dev->xfrmdev_ops->xdo_dev_state_add &&
 	       dev->xfrmdev_ops->xdo_dev_state_delete)))
 		return NOTIFY_BAD;
 #else
-	if (dev->features & (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM))
+	if (netdev_feature_test_bits(NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM,
+				     dev->features))
 		return NOTIFY_BAD;
 #endif
 
@@ -391,7 +400,7 @@ static int xfrm_dev_feat_change(struct net_device *dev)
 
 static int xfrm_dev_down(struct net_device *dev)
 {
-	if (dev->features & NETIF_F_HW_ESP)
+	if (netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, dev->features))
 		xfrm_dev_state_flush(dev_net(dev), dev, true);
 
 	return NOTIFY_DONE;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 41de46b5ffa9..e14068d45b19 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -590,9 +590,9 @@ static int xfrmi_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	dev->features |= NETIF_F_LLTX;
-	dev->features |= XFRMI_FEATURES;
-	dev->hw_features |= XFRMI_FEATURES;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bits(XFRMI_FEATURES, &dev->features);
+	netdev_feature_set_bits(XFRMI_FEATURES, &dev->hw_features);
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 229544bc70c2..184f1c17631e 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -724,7 +724,9 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			goto out;
 		}
 
-		if (x->xso.dev && x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM)
+		if (x->xso.dev &&
+		    netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
+					    x->xso.dev->features))
 			goto out;
 	} else {
 		if (skb_is_gso(skb))
-- 
2.33.0

