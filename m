Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640345BBD22
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIRJuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6010E12A99
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjbz6F45z14QW9;
        Sun, 18 Sep 2022 17:45:51 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 46/55] net: adjust the prototype of netif_needs_gso() and relative functions
Date:   Sun, 18 Sep 2022 09:43:27 +0000
Message-ID: <20220918094336.28958-47-shenjian15@huawei.com>
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

The functions netif_needs_gso(), net_gso_ok(), and skb_gso_ok()
using netdev_features_t as parameters.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of these functions,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/tap.c                 |  2 +-
 drivers/net/xen-netfront.c        |  2 +-
 drivers/s390/net/qeth_core_main.c |  4 ++--
 include/linux/netdevice.h         | 11 ++++++-----
 include/net/sock.h                |  2 +-
 net/core/dev.c                    |  4 ++--
 net/core/skbuff.c                 |  2 +-
 net/ipv4/tcp_offload.c            |  2 +-
 net/sctp/offload.c                |  2 +-
 9 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index dfbfd8dfcf67..e3045a7badd8 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -341,7 +341,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	 */
 	if (q->flags & IFF_VNET_HDR)
 		netdev_features_set(features, tap->tap_features);
-	if (netif_needs_gso(skb, features)) {
+	if (netif_needs_gso(skb, &features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, &features, false);
 		struct sk_buff *next;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 654f805f4522..a7887060feb3 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -777,7 +777,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	netif_skb_features(skb, &features);
 	if (unlikely(!netif_carrier_ok(dev) ||
 		     (slots > 1 && !xennet_can_sg(dev)) ||
-		     netif_needs_gso(skb, features))) {
+		     netif_needs_gso(skb, &features))) {
 		spin_unlock_irqrestore(&queue->tx_lock, flags);
 		goto drop;
 	}
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b3ca79930c42..6695f8dda8f4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6882,7 +6882,7 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 		netdev_features_t restricted;
 
 		netdev_features_zero(restricted);
-		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
+		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
 			netdev_features_set(restricted, NETIF_F_ALL_TSO);
 
 		switch (vlan_get_protocol(skb)) {
@@ -6914,7 +6914,7 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * additional buffer element. This reduces buffer utilization, and
 	 * hurts throughput. So compress small segments into one element.
 	 */
-	if (netif_needs_gso(skb, *features)) {
+	if (netif_needs_gso(skb, features)) {
 		/* match skb_segment(): */
 		unsigned int doffset = skb->data - skb_mac_header(skb);
 		unsigned int hsize = skb_shinfo(skb)->gso_size;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fb1f85274e3b..f0fad437bdb7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4917,7 +4917,7 @@ void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
 			     netdev_features_t *features);
 void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
-static inline bool net_gso_ok(netdev_features_t features, int gso_type)
+static inline bool net_gso_ok(const netdev_features_t *features, int gso_type)
 {
 #define ASSERT_GSO_TYPE(fl, feat)	\
 		static_assert((fl) == (feat) - NETIF_F_GSO_SHIFT)
@@ -4952,17 +4952,18 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	if (new_gso_type) { /* placeholder for new gso type */
 	}
 
-	return (features & feature) == feature;
+	return (*features & feature) == feature;
 }
 
-static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
+static inline bool skb_gso_ok(struct sk_buff *skb,
+			      const netdev_features_t *features)
 {
 	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
-	       (!skb_has_frag_list(skb) || netdev_feature_test(NETIF_F_FRAGLIST_BIT, features));
+	       (!skb_has_frag_list(skb) || netdev_feature_test(NETIF_F_FRAGLIST_BIT, *features));
 }
 
 static inline bool netif_needs_gso(struct sk_buff *skb,
-				   netdev_features_t features)
+				   const netdev_features_t *features)
 {
 	return skb_is_gso(skb) && (!skb_gso_ok(skb, features) ||
 		unlikely((skb->ip_summed != CHECKSUM_PARTIAL) &&
diff --git a/include/net/sock.h b/include/net/sock.h
index 35404aedf51c..acdef93d0657 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2237,7 +2237,7 @@ bool sk_mc_loop(struct sock *sk);
 
 static inline bool sk_can_gso(const struct sock *sk)
 {
-	return net_gso_ok(sk->sk_route_caps, sk->sk_gso_type);
+	return net_gso_ok(&sk->sk_route_caps, sk->sk_gso_type);
 }
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
diff --git a/net/core/dev.c b/net/core/dev.c
index 21ef38eeb38a..3436b640db67 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3404,7 +3404,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				    dev->gso_partial_features);
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, partial_features);
 		netdev_features_set(partial_features, features);
-		if (!skb_gso_ok(skb, partial_features))
+		if (!skb_gso_ok(skb, &partial_features))
 			netdev_feature_del(NETIF_F_GSO_PARTIAL_BIT, features);
 	}
 
@@ -3665,7 +3665,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (unlikely(!skb))
 		goto out_null;
 
-	if (netif_needs_gso(skb, features)) {
+	if (netif_needs_gso(skb, &features)) {
 		struct sk_buff *segs;
 
 		segs = skb_gso_segment(skb, &features);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b5916c98128b..124de0e772fc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4068,7 +4068,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			unsigned int frag_len;
 
 			if (!list_skb ||
-			    !net_gso_ok(features, skb_shinfo(head_skb)->gso_type))
+			    !net_gso_ok(&features, skb_shinfo(head_skb)->gso_type))
 				goto normal;
 
 			/* If we get here then all the required
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 930dfb9557ed..b6c3c3b419a5 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -85,7 +85,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 
 	netdev_features_copy(features, *feats);
 	netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, features);
-	if (skb_gso_ok(skb, features)) {
+	if (skb_gso_ok(skb, &features)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
 		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(skb->len, mss);
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index d4e1f70e32b8..413642ef1221 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -52,7 +52,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 	__skb_pull(skb, sizeof(*sh));
 
 	netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, tmp);
-	if (skb_gso_ok(skb, tmp)) {
+	if (skb_gso_ok(skb, &tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
 		struct sk_buff *frag_iter;
-- 
2.33.0

