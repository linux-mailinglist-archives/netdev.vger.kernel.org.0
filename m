Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D285BBD28
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIRJv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C270186D9
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:59 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjcC5nRnzmVHQ;
        Sun, 18 Sep 2022 17:46:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 48/55] net: adjust the prototype of validate_xmit_xfrm() and relative functions
Date:   Sun, 18 Sep 2022 09:43:29 +0000
Message-ID: <20220918094336.28958-49-shenjian15@huawei.com>
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

The functions validate_xmit_xfrm() and xfrm_type_offload.xmit()
using netdev_features_t as parameters.

For the prototype of netdev_features_t will be extended to be
larger than 8 bytes, so change the prototype of the function,
change the prototype of input features to 'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/net/xfrm.h      | 11 ++++++++---
 net/core/dev.c          |  2 +-
 net/ipv4/esp4_offload.c |  5 +++--
 net/ipv6/esp6_offload.c |  5 +++--
 net/xfrm/xfrm_device.c  | 15 +++++++++------
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e8fa98f786f..0646a47d8b18 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -415,7 +415,8 @@ struct xfrm_type_offload {
 	u8		proto;
 	void		(*encap)(struct xfrm_state *, struct sk_buff *pskb);
 	int		(*input_tail)(struct xfrm_state *x, struct sk_buff *skb);
-	int		(*xmit)(struct xfrm_state *, struct sk_buff *pskb, netdev_features_t features);
+	int		(*xmit)(struct xfrm_state *, struct sk_buff *pskb,
+				const netdev_features_t *features);
 };
 
 int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned short family);
@@ -1877,7 +1878,9 @@ void __init xfrm_dev_init(void);
 #ifdef CONFIG_XFRM_OFFLOAD
 void xfrm_dev_resume(struct sk_buff *skb);
 void xfrm_dev_backlog(struct softnet_data *sd);
-struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again);
+struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb,
+				   const netdev_features_t *features,
+				   bool *again);
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		       struct xfrm_user_offload *xuo);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
@@ -1937,7 +1940,9 @@ static inline void xfrm_dev_backlog(struct softnet_data *sd)
 {
 }
 
-static inline struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
+static inline struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb,
+						 const netdev_features_t *features,
+						 bool *again)
 {
 	return skb;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index b8bb83a65221..54cb150d9db1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3696,7 +3696,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 		}
 	}
 
-	skb = validate_xmit_xfrm(skb, features, again);
+	skb = validate_xmit_xfrm(skb, &features, again);
 
 	return skb;
 
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 36d76cff3075..b72ec9e3447e 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -250,7 +250,8 @@ static int esp_input_tail(struct xfrm_state *x, struct sk_buff *skb)
 	return esp_input_done2(skb, 0);
 }
 
-static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_t features)
+static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,
+		    const netdev_features_t *features)
 {
 	int err;
 	int alen;
@@ -269,7 +270,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	if (!xo)
 		return -EINVAL;
 
-	if ((!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) &&
+	if ((!netdev_feature_test(NETIF_F_HW_ESP_BIT, *features) &&
 	     !netdev_gso_partial_feature_test(skb->dev, NETIF_F_HW_ESP_BIT)) ||
 	    x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 4956a83d409a..ce7d02b5e184 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -287,7 +287,8 @@ static int esp6_input_tail(struct xfrm_state *x, struct sk_buff *skb)
 	return esp6_input_done2(skb, 0);
 }
 
-static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_t features)
+static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,
+		     const netdev_features_t *features)
 {
 	int len;
 	int err;
@@ -306,7 +307,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	if (!xo)
 		return -EINVAL;
 
-	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features) || x->xso.dev != skb->dev) {
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, *features) || x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
 		hw_offload = false;
 	}
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index b53f142b02de..3a8f11aec189 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -97,23 +97,26 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 	}
 }
 
-struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
+struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb,
+				   const netdev_features_t *features,
+				   bool *again)
 {
 	int err;
 	unsigned long flags;
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
 
-	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, features)) {
-		esp_features = features;
+	netdev_features_copy(esp_features, *features);
+	if (!netdev_feature_test(NETIF_F_HW_ESP_BIT, *features)) {
+		netdev_features_copy(esp_features, *features);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_features_clear(esp_features, NETIF_F_CSUM_MASK);
 	}
@@ -162,7 +165,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 		xo->flags |= XFRM_DEV_RESUME;
 
-		err = x->type_offload->xmit(x, skb, esp_features);
+		err = x->type_offload->xmit(x, skb, &esp_features);
 		if (err) {
 			if (err == -EINPROGRESS)
 				return NULL;
@@ -187,7 +190,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 		xfrm_outer_mode_prep(x, skb2);
 
-		err = x->type_offload->xmit(x, skb2, esp_features);
+		err = x->type_offload->xmit(x, skb2, &esp_features);
 		if (!err) {
 			skb2->next = nskb;
 		} else if (err != -EINPROGRESS) {
-- 
2.33.0

