Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964815BBCFE
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiIRJur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C35511C01
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfD19fczHnnb;
        Sun, 18 Sep 2022 17:47:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 45/55] net: vlan: adjust the prototype of vlan functions
Date:   Sun, 18 Sep 2022 09:43:26 +0000
Message-ID: <20220918094336.28958-46-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some functions of vlan driver using netdev_features_t
as parameters or return netdev_features_t directly or both.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *',
and return the features pointer as output parameter.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/if_vlan.h |  6 +++---
 net/8021q/vlan.c        |  4 ++--
 net/8021q/vlan.h        | 26 ++++++++++++--------------
 net/8021q/vlan_dev.c    |  4 ++--
 net/core/dev.c          |  4 ++--
 net/core/netpoll.c      |  2 +-
 6 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 4fef74864267..3179db99ebc2 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -316,14 +316,14 @@ static inline bool eth_type_vlan(__be16 ethertype)
 	}
 }
 
-static inline bool vlan_hw_offload_capable(netdev_features_t features,
+static inline bool vlan_hw_offload_capable(const netdev_features_t *features,
 					   __be16 proto)
 {
 	if (proto == htons(ETH_P_8021Q) &&
-	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features))
 		return true;
 	if (proto == htons(ETH_P_8021AD) &&
-	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, features))
+	    netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, *features))
 		return true;
 	return false;
 }
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index aec2e74ccfd9..f366f4048e3d 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -321,7 +321,7 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	netif_inherit_tso_max(vlandev, dev);
 
-	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
+	if (vlan_hw_offload_capable(&dev->features, vlan->vlan_proto))
 		vlandev->hard_header_len = dev->hard_header_len;
 	else
 		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
@@ -332,7 +332,7 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlandev->hw_enc_features = vlan_tnl_features(vlan->real_dev);
+	vlan_tnl_features(vlan->real_dev, &vlandev->hw_enc_features);
 
 	netdev_update_features(vlandev);
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 2acb89660ab5..c72413f438e2 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -104,22 +104,20 @@ static inline struct net_device *vlan_find_dev(struct net_device *real_dev,
 	return NULL;
 }
 
-static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
+static inline void vlan_tnl_features(struct net_device *real_dev,
+				     netdev_features_t *features)
 {
-	netdev_features_t ret;
-
-	netdev_features_or(ret, NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
-	netdev_features_set(ret, NETIF_F_GSO_ENCAP_ALL);
-	netdev_features_mask(ret, real_dev->hw_enc_features);
-
-	if (netdev_features_intersects(ret, NETIF_F_GSO_ENCAP_ALL) &&
-	    netdev_features_intersects(ret, NETIF_F_CSUM_MASK)) {
-		netdev_features_clear(ret, NETIF_F_CSUM_MASK);
-		netdev_feature_add(NETIF_F_HW_CSUM_BIT, ret);
-		return ret;
+	netdev_features_or(*features, NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
+	netdev_features_set(*features, NETIF_F_GSO_ENCAP_ALL);
+	netdev_features_mask(*features, real_dev->hw_enc_features);
+
+	if (netdev_features_intersects(*features, NETIF_F_GSO_ENCAP_ALL) &&
+	    netdev_features_intersects(*features, NETIF_F_CSUM_MASK)) {
+		netdev_features_clear(*features, NETIF_F_CSUM_MASK);
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, *features);
+		return;
 	}
-	netdev_features_zero(ret);
-	return ret;
+	netdev_features_zero(*features);
 }
 
 #define vlan_group_for_each_dev(grp, i, dev) \
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 2fa0b4ea260b..321adf534177 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -583,7 +583,7 @@ static int vlan_dev_init(struct net_device *dev)
 
 	netdev_vlan_features_andnot(dev, real_dev->vlan_features,
 				    NETIF_F_ALL_FCOE);
-	dev->hw_enc_features = vlan_tnl_features(real_dev);
+	vlan_tnl_features(real_dev, &dev->hw_enc_features);
 	dev->mpls_features = real_dev->mpls_features;
 
 	/* ipv6 shared card related stuff */
@@ -601,7 +601,7 @@ static int vlan_dev_init(struct net_device *dev)
 #endif
 
 	dev->needed_headroom = real_dev->needed_headroom;
-	if (vlan_hw_offload_capable(real_dev->features, vlan->vlan_proto)) {
+	if (vlan_hw_offload_capable(&real_dev->features, vlan->vlan_proto)) {
 		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {
diff --git a/net/core/dev.c b/net/core/dev.c
index ad6202d2543e..21ef38eeb38a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3622,7 +3622,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *first, struct net_device *de
 }
 
 static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
-					  netdev_features_t features)
+					  const netdev_features_t *features)
 {
 	if (skb_vlan_tag_present(skb) &&
 	    !vlan_hw_offload_capable(features, skb->vlan_proto))
@@ -3657,7 +3657,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	netdev_features_t features;
 
 	netif_skb_features(skb, &features);
-	skb = validate_xmit_vlan(skb, features);
+	skb = validate_xmit_vlan(skb, &features);
 	if (unlikely(!skb))
 		goto out_null;
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 94dd11aa1b83..17af85316407 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -80,7 +80,7 @@ static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
 	netif_skb_features(skb, &features);
 
 	if (skb_vlan_tag_present(skb) &&
-	    !vlan_hw_offload_capable(features, skb->vlan_proto)) {
+	    !vlan_hw_offload_capable(&features, skb->vlan_proto)) {
 		skb = __vlan_hwaccel_push_inside(skb);
 		if (unlikely(!skb)) {
 			/* This is actually a packet drop, but we
-- 
2.33.0

