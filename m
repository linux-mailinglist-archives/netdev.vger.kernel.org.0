Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B75BBD26
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiIRJuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiIRJuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B517F11C31
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjbH4sGJzMmwB;
        Sun, 18 Sep 2022 17:45:15 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 47/55] net: adjust the prototype of skb_needs_linearize()
Date:   Sun, 18 Sep 2022 09:43:28 +0000
Message-ID: <20220918094336.28958-48-shenjian15@huawei.com>
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

The function skb_needs_linearize() using netdev_features_t
as parameters.

For the prototype of netdev_features_t will be extended to
be larger than 8 bytes, so change the prototype of the
function, change the prototype of input features to
'netdev_features_t *'.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/skbuff.h | 6 +++---
 net/core/dev.c         | 2 +-
 net/core/skbuff.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2f163b12c54d..122190c334cb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4035,11 +4035,11 @@ skb_header_pointer(const struct sk_buff *skb, int offset, int len, void *buffer)
  *	2. skb is fragmented and the device does not support SG.
  */
 static inline bool skb_needs_linearize(struct sk_buff *skb,
-				       netdev_features_t features)
+				       const netdev_features_t *features)
 {
 	return skb_is_nonlinear(skb) &&
-	       ((skb_has_frag_list(skb) && !(features & NETIF_F_FRAGLIST)) ||
-		(skb_shinfo(skb)->nr_frags && !(features & NETIF_F_SG)));
+	       ((skb_has_frag_list(skb) && !(*features & NETIF_F_FRAGLIST)) ||
+		(skb_shinfo(skb)->nr_frags && !(*features & NETIF_F_SG)));
 }
 
 static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 3436b640db67..b8bb83a65221 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3676,7 +3676,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 			skb = segs;
 		}
 	} else {
-		if (skb_needs_linearize(skb, features) &&
+		if (skb_needs_linearize(skb, &features) &&
 		    __skb_linearize(skb))
 			goto out_kfree_skb;
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 124de0e772fc..3e6935386637 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3973,7 +3973,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 						 nskb->data - tnl_hlen,
 						 offset + tnl_hlen);
 
-		if (skb_needs_linearize(nskb, *features) &&
+		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
 
@@ -3987,7 +3987,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb->prev = tail;
 
-	if (skb_needs_linearize(skb, *features) &&
+	if (skb_needs_linearize(skb, features) &&
 	    __skb_linearize(skb))
 		goto err_linearize;
 
-- 
2.33.0

