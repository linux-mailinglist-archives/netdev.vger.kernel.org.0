Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B4541C8FA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345748AbhI2QAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12983 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344331AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF5QMWzWNSn;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 032/167] net: tap: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:19 +0800
Message-ID: <20210929155334.12454-33-shenjian15@huawei.com>
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
 drivers/net/tap.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..03158fa9476c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -321,7 +321,10 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct net_device *dev = skb->dev;
 	struct tap_dev *tap;
 	struct tap_queue *q;
-	netdev_features_t features = TAP_FEATURES;
+	netdev_features_t features;
+
+	netdev_feature_zero(&features);
+	netdev_feature_set_bits(TAP_FEATURES, &features);
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -338,7 +341,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	 * enabled.
 	 */
 	if (q->flags & IFF_VNET_HDR)
-		features |= tap->tap_features;
+		netdev_feature_or(&features, features, tap->tap_features);
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
@@ -368,7 +371,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		 *	  check, we either support them all or none.
 		 */
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
-		    !(features & NETIF_F_CSUM_MASK) &&
+		    !netdev_feature_test_bits(NETIF_F_CSUM_MASK, features) &&
 		    skb_checksum_help(skb))
 			goto drop;
 		if (ptr_ring_produce(&q->ring, skb))
@@ -536,7 +539,8 @@ static int tap_open(struct inode *inode, struct file *file)
 	 * The macvlan supports zerocopy iff the lower device supports zero
 	 * copy so we don't have to look at the lower device directly.
 	 */
-	if ((tap->dev->features & NETIF_F_HIGHDMA) && (tap->dev->features & NETIF_F_SG))
+	if (netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT, tap->dev->features) &&
+	    netdev_feature_test_bit(NETIF_F_SG_BIT, tap->dev->features))
 		sock_set_flag(&q->sk, SOCK_ZEROCOPY);
 
 	err = tap_set_queue(tap, file, q);
@@ -921,24 +925,28 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 {
 	struct tap_dev *tap;
 	netdev_features_t features;
-	netdev_features_t feature_mask = 0;
+	netdev_features_t feature_mask;
 
 	tap = rtnl_dereference(q->tap);
 	if (!tap)
 		return -ENOLINK;
 
-	features = tap->dev->features;
+	netdev_feature_zero(&feature_mask);
+	netdev_feature_copy(&features, tap->dev->features);
 
 	if (arg & TUN_F_CSUM) {
-		feature_mask = NETIF_F_HW_CSUM;
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &feature_mask);
 
 		if (arg & (TUN_F_TSO4 | TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN)
-				feature_mask |= NETIF_F_TSO_ECN;
+				netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
+						       &feature_mask);
 			if (arg & TUN_F_TSO4)
-				feature_mask |= NETIF_F_TSO;
+				netdev_feature_set_bit(NETIF_F_TSO_BIT,
+						       &feature_mask);
 			if (arg & TUN_F_TSO6)
-				feature_mask |= NETIF_F_TSO6;
+				netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+						       &feature_mask);
 		}
 	}
 
@@ -950,15 +958,15 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
-		features |= RX_OFFLOADS;
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6, feature_mask))
+		netdev_feature_set_bits(RX_OFFLOADS, &features);
 	else
-		features &= ~RX_OFFLOADS;
+		netdev_feature_clear_bits(RX_OFFLOADS, &features);
 
 	/* tap_features are the same as features on tun/tap and
 	 * reflect user expectations.
 	 */
-	tap->tap_features = feature_mask;
+	netdev_feature_copy(&tap->tap_features, feature_mask);
 	if (tap->update_features)
 		tap->update_features(tap, features);
 
-- 
2.33.0

