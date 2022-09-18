Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F209C5BBD13
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiIRJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7112620
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc72Kk0zmVJH;
        Sun, 18 Sep 2022 17:45:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:50 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 23/55] net: adjust the build check for net_gso_ok()
Date:   Sun, 18 Sep 2022 09:43:04 +0000
Message-ID: <20220918094336.28958-24-shenjian15@huawei.com>
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
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far all gso feature bits are defined continuously, and can
be mapped to gso type bits with specified "NETIF_F_GSO_SHIFT".
But once new gso type bit being introduced, the new gso feature
bit can not using this "NETIF_F_GSO_SHIFT". Change the build
check conditions, checkint the gso type bit, instead of gso type.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdevice.h | 50 ++++++++++++++++++-------------
 include/linux/skbuff.h    | 63 +++++++++++++++++++++++++++------------
 2 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9bbab3856347..78e26b2e94b4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4917,28 +4917,38 @@ netdev_features_t netif_skb_features(struct sk_buff *skb);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
-	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+#define ASSERT_GSO_TYPE(fl, feat)	\
+		static_assert((fl) == (feat) - NETIF_F_GSO_SHIFT)
+
+	u64 classic_gso_type = gso_type & CLASSIC_GSO_FIELD;
+	u64 new_gso_type = gso_type & ~CLASSIC_GSO_FIELD;
+	netdev_features_t feature;
 
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
+	ASSERT_GSO_TYPE(SKB_GSO_TCPV4_BIT, NETIF_F_TSO_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_DODGY_BIT, NETIF_F_GSO_ROBUST_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_TCP_ECN_BIT, NETIF_F_TSO_ECN_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_TCP_FIXEDID_BIT, NETIF_F_TSO_MANGLEID_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_TCPV6_BIT, NETIF_F_TSO6_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_FCOE_BIT, NETIF_F_FSO_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_GRE_BIT, NETIF_F_GSO_GRE_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_GRE_CSUM_BIT, NETIF_F_GSO_GRE_CSUM_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_IPXIP4_BIT, NETIF_F_GSO_IPXIP4_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_IPXIP6_BIT, NETIF_F_GSO_IPXIP6_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_UDP_TUNNEL_BIT, NETIF_F_GSO_UDP_TUNNEL_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_UDP_TUNNEL_CSUM_BIT, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_TUNNEL_REMCSUM_BIT, NETIF_F_GSO_TUNNEL_REMCSUM_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_SCTP_BIT, NETIF_F_GSO_SCTP_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_ESP_BIT, NETIF_F_GSO_ESP_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_UDP_BIT, NETIF_F_GSO_UDP_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_UDP_L4_BIT, NETIF_F_GSO_UDP_L4_BIT);
+	ASSERT_GSO_TYPE(SKB_GSO_FRAGLIST_BIT, NETIF_F_GSO_FRAGLIST_BIT);
+
+	if (classic_gso_type)
+		feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+
+	if (new_gso_type) { /* placeholder for new gso type */
+	}
 
 	return (features & feature) == feature;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f15d5b62539b..8b030517f4d3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -626,46 +626,71 @@ enum {
 	SKB_FCLONE_CLONE,	/* companion fclone skb (from fclone_cache) */
 };
 
+#define CLASSIC_GSO_FIELD	0x7FF
+#define __SKB_GSO_FLAG(x)	(1ULL << (SKB_GSO_##x##_BIT))
+
+enum {
+	SKB_GSO_TCPV4_BIT = 0,
+	SKB_GSO_DODGY_BIT = 1,
+	SKB_GSO_TCP_ECN_BIT = 2,
+	SKB_GSO_TCP_FIXEDID_BIT = 3,
+	SKB_GSO_TCPV6_BIT = 4,
+	SKB_GSO_FCOE_BIT = 5,
+	SKB_GSO_GRE_BIT = 6,
+	SKB_GSO_GRE_CSUM_BIT = 7,
+	SKB_GSO_IPXIP4_BIT =  8,
+	SKB_GSO_IPXIP6_BIT = 9,
+	SKB_GSO_UDP_TUNNEL_BIT = 10,
+	SKB_GSO_UDP_TUNNEL_CSUM_BIT = 11,
+	SKB_GSO_PARTIAL_BIT = 12,
+	SKB_GSO_TUNNEL_REMCSUM_BIT = 13,
+	SKB_GSO_SCTP_BIT = 14,
+	SKB_GSO_ESP_BIT = 15,
+	SKB_GSO_UDP_BIT = 16,
+	SKB_GSO_UDP_L4_BIT = 17,
+	SKB_GSO_FRAGLIST_BIT = 18,
+};
+
 enum {
-	SKB_GSO_TCPV4 = 1 << 0,
+	SKB_GSO_TCPV4 = __SKB_GSO_FLAG(TCPV4),
 
 	/* This indicates the skb is from an untrusted source. */
-	SKB_GSO_DODGY = 1 << 1,
+	SKB_GSO_DODGY = __SKB_GSO_FLAG(DODGY),
 
 	/* This indicates the tcp segment has CWR set. */
-	SKB_GSO_TCP_ECN = 1 << 2,
+	SKB_GSO_TCP_ECN = __SKB_GSO_FLAG(TCP_ECN),
 
-	SKB_GSO_TCP_FIXEDID = 1 << 3,
+	SKB_GSO_TCP_FIXEDID = __SKB_GSO_FLAG(TCP_FIXEDID),
 
-	SKB_GSO_TCPV6 = 1 << 4,
+	SKB_GSO_TCPV6 = __SKB_GSO_FLAG(TCPV6),
 
-	SKB_GSO_FCOE = 1 << 5,
+	SKB_GSO_FCOE = __SKB_GSO_FLAG(FCOE),
 
-	SKB_GSO_GRE = 1 << 6,
+	SKB_GSO_GRE = __SKB_GSO_FLAG(GRE),
 
-	SKB_GSO_GRE_CSUM = 1 << 7,
+	SKB_GSO_GRE_CSUM = __SKB_GSO_FLAG(GRE_CSUM),
 
-	SKB_GSO_IPXIP4 = 1 << 8,
+	SKB_GSO_IPXIP4 = __SKB_GSO_FLAG(IPXIP4),
 
-	SKB_GSO_IPXIP6 = 1 << 9,
+	SKB_GSO_IPXIP6 = __SKB_GSO_FLAG(IPXIP6),
 
-	SKB_GSO_UDP_TUNNEL = 1 << 10,
+	SKB_GSO_UDP_TUNNEL = __SKB_GSO_FLAG(UDP_TUNNEL),
 
-	SKB_GSO_UDP_TUNNEL_CSUM = 1 << 11,
+	SKB_GSO_UDP_TUNNEL_CSUM = __SKB_GSO_FLAG(UDP_TUNNEL_CSUM),
 
-	SKB_GSO_PARTIAL = 1 << 12,
+	SKB_GSO_PARTIAL = __SKB_GSO_FLAG(PARTIAL),
 
-	SKB_GSO_TUNNEL_REMCSUM = 1 << 13,
+	SKB_GSO_TUNNEL_REMCSUM = __SKB_GSO_FLAG(TUNNEL_REMCSUM),
 
-	SKB_GSO_SCTP = 1 << 14,
+	SKB_GSO_SCTP = __SKB_GSO_FLAG(SCTP),
 
-	SKB_GSO_ESP = 1 << 15,
+	SKB_GSO_ESP = __SKB_GSO_FLAG(ESP),
 
-	SKB_GSO_UDP = 1 << 16,
+	SKB_GSO_UDP = __SKB_GSO_FLAG(UDP),
 
-	SKB_GSO_UDP_L4 = 1 << 17,
+	SKB_GSO_UDP_L4 = __SKB_GSO_FLAG(UDP_L4),
 
-	SKB_GSO_FRAGLIST = 1 << 18,
+	SKB_GSO_FRAGLIST = __SKB_GSO_FLAG(FRAGLIST),
 };
 
 #if BITS_PER_LONG > 32
-- 
2.33.0

