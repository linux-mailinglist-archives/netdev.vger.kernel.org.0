Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E509A5BBD08
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIRJum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiIRJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E665614000
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjbJ09jdzMn02;
        Sun, 18 Sep 2022 17:45:16 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 49/55] net: adjust the prototype of can_checksum_protocol()
Date:   Sun, 18 Sep 2022 09:43:30 +0000
Message-ID: <20220918094336.28958-50-shenjian15@huawei.com>
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

The function can_checksum_protocol() using netdev_features_t
as parameters.

For the prototype of netdev_features_t will be extended to be
largerthan 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h | 10 +++++-----
 include/net/vxlan.h       |  2 +-
 net/core/dev.c            |  2 +-
 net/core/skbuff.c         |  2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f0fad437bdb7..4620af4591fc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4809,24 +4809,24 @@ struct sk_buff *skb_gso_segment(struct sk_buff *skb,
 }
 __be16 skb_network_protocol(struct sk_buff *skb, int *depth);
 
-static inline bool can_checksum_protocol(netdev_features_t features,
+static inline bool can_checksum_protocol(const netdev_features_t *features,
 					 __be16 protocol)
 {
 	if (protocol == htons(ETH_P_FCOE))
-		return netdev_feature_test(NETIF_F_FCOE_CRC_BIT, features);
+		return netdev_feature_test(NETIF_F_FCOE_CRC_BIT, *features);
 
 	/* Assume this is an IP checksum (not SCTP CRC) */
 
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features)) {
 		/* Can checksum everything */
 		return true;
 	}
 
 	switch (protocol) {
 	case htons(ETH_P_IP):
-		return netdev_feature_test(NETIF_F_IP_CSUM_BIT, features);
+		return netdev_feature_test(NETIF_F_IP_CSUM_BIT, *features);
 	case htons(ETH_P_IPV6):
-		return netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features);
+		return netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *features);
 	default:
 		return false;
 	}
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 25d2bc8015c7..b1a729c4edc1 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -372,7 +372,7 @@ static inline void vxlan_features_check(struct sk_buff *skb,
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
-	      !can_checksum_protocol(*features, inner_eth_hdr(skb)->h_proto)))) {
+	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto)))) {
 		netdev_features_clear(*features, netdev_csum_gso_features_mask);
 		return;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 54cb150d9db1..bed372ecef65 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3485,7 +3485,7 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 	net_mpls_features(skb, features, type);
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
-	    !can_checksum_protocol(*features, type)) {
+	    !can_checksum_protocol(features, type)) {
 		netdev_features_clear(*features,
 				      netdev_csum_gso_features_mask);
 	}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3e6935386637..ced731f87560 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4060,7 +4060,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		return ERR_PTR(-EINVAL);
 
 	sg = netdev_feature_test(NETIF_F_SG_BIT, features);
-	csum = !!can_checksum_protocol(features, proto);
+	csum = !!can_checksum_protocol(&features, proto);
 
 	if (sg && csum && (mss != GSO_BY_FRAGS))  {
 		if (!netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
-- 
2.33.0

