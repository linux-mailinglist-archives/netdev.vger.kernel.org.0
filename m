Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A8141C901
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345786AbhI2QAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13836 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344206AbhI2P7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWP1lJnz8yqq;
        Wed, 29 Sep 2021 23:53:21 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 021/167] net: realtek: convert the prototype of rtl8168evl_fix_tso
Date:   Wed, 29 Sep 2021 23:51:08 +0800
Message-ID: <20210929155334.12454-22-shenjian15@huawei.com>
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

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
rtl8168evl_fix_tso for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8affae2b55a6..c876246cf8c1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4326,23 +4326,20 @@ static unsigned int rtl_last_frag_len(struct sk_buff *skb)
 }
 
 /* Workaround for hw issues with TSO on RTL8168evl */
-static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
-					    netdev_features_t features)
+static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t *features)
 {
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
 	    ip_hdrlen(skb) > sizeof(struct iphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		*features &= ~NETIF_F_ALL_TSO;
 
 	/* IPv4 TCP header has options field */
 	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
 		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		*features &= ~NETIF_F_ALL_TSO;
 
 	else if (rtl_last_frag_len(skb) <= 6)
-		features &= ~NETIF_F_ALL_TSO;
-
-	return features;
+		*features &= ~NETIF_F_ALL_TSO;
 }
 
 static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
@@ -4353,7 +4350,7 @@ static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
-			*features = rtl8168evl_fix_tso(skb, *features);
+			rtl8168evl_fix_tso(skb, features);
 
 		if (transport_offset > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-- 
2.33.0

