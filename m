Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D67058E54E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiHJDON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiHJDNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6129882F83
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgw23FQzjXjh;
        Wed, 10 Aug 2022 11:10:36 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 23/36] net: adjust the build check for net_gso_ok()
Date:   Wed, 10 Aug 2022 11:06:11 +0800
Message-ID: <20220810030624.34711-24-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_75_100
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce macro GSO_INDEX(x) to replace the NETIF_F_XXX
feature shift check, for all the macroes NETIF_F_XXX will
be remove later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h | 40 ++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1bd5dcbc884d..b01af2a3838d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4886,28 +4886,30 @@ netdev_features_t netif_skb_features(struct sk_buff *skb);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
+#define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)
+
 	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
 
 	/* check flags correspondence */
-	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_DODGY   != (NETIF_F_GSO_ROBUST >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCP_ECN != (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != (NETIF_F_TSO_MANGLEID >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCPV6   != (NETIF_F_TSO6 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_FCOE    != (NETIF_F_FSO >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_GRE     != (NETIF_F_GSO_GRE >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != (NETIF_F_GSO_GRE_CSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_IPXIP4  != (NETIF_F_GSO_IPXIP4 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_IPXIP6  != (NETIF_F_GSO_IPXIP6 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != (NETIF_F_GSO_UDP_TUNNEL >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != (NETIF_F_GSO_UDP_TUNNEL_CSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_PARTIAL != (NETIF_F_GSO_PARTIAL >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != (NETIF_F_GSO_TUNNEL_REMCSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_SCTP    != (NETIF_F_GSO_SCTP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_ESP != (NETIF_F_GSO_ESP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
+	BUILD_BUG_ON(SKB_GSO_DODGY   != GSO_INDEX(NETIF_F_GSO_ROBUST_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCP_ECN != GSO_INDEX(NETIF_F_TSO_ECN_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != GSO_INDEX(NETIF_F_TSO_MANGLEID_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCPV6   != GSO_INDEX(NETIF_F_TSO6_BIT));
+	BUILD_BUG_ON(SKB_GSO_FCOE    != GSO_INDEX(NETIF_F_FSO_BIT));
+	BUILD_BUG_ON(SKB_GSO_GRE     != GSO_INDEX(NETIF_F_GSO_GRE_BIT));
+	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != GSO_INDEX(NETIF_F_GSO_GRE_CSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_IPXIP4  != GSO_INDEX(NETIF_F_GSO_IPXIP4_BIT));
+	BUILD_BUG_ON(SKB_GSO_IPXIP6  != GSO_INDEX(NETIF_F_GSO_IPXIP6_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_PARTIAL != GSO_INDEX(NETIF_F_GSO_PARTIAL_BIT));
+	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != GSO_INDEX(NETIF_F_GSO_TUNNEL_REMCSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_SCTP    != GSO_INDEX(NETIF_F_GSO_SCTP_BIT));
+	BUILD_BUG_ON(SKB_GSO_ESP != GSO_INDEX(NETIF_F_GSO_ESP_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP != GSO_INDEX(NETIF_F_GSO_UDP_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
+	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
 
 	return (features & feature) == feature;
 }
-- 
2.33.0

