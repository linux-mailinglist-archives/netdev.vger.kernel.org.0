Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203EC56D6D8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 09:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiGKHbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 03:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiGKHbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 03:31:13 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9471A39F;
        Mon, 11 Jul 2022 00:31:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LhFsN4xVVzFpyY;
        Mon, 11 Jul 2022 15:30:16 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Jul
 2022 15:31:09 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH] net: change the type of ip_route_input_rcu to static
Date:   Mon, 11 Jul 2022 15:35:49 +0800
Message-ID: <20220711073549.8947-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of ip_route_input_rcu should be static.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/route.h |  4 ----
 net/ipv4/route.c    | 34 +++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index b6743ff88e30..4929a710c24b 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -201,10 +201,6 @@ int ip_mc_validate_source(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 			  struct in_device *in_dev, u32 *itag);
 int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
 			 u8 tos, struct net_device *devin);
-int ip_route_input_rcu(struct sk_buff *skb, __be32 dst, __be32 src,
-		       u8 tos, struct net_device *devin,
-		       struct fib_result *res);
-
 int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
 		      u8 tos, struct net_device *devin,
 		      const struct sk_buff *hint);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index bd351fab46e6..328beff85a1e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2432,24 +2432,9 @@ out:	return err;
 	goto out;
 }
 
-int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
-			 u8 tos, struct net_device *dev)
-{
-	struct fib_result res;
-	int err;
-
-	tos &= IPTOS_RT_MASK;
-	rcu_read_lock();
-	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
-	rcu_read_unlock();
-
-	return err;
-}
-EXPORT_SYMBOL(ip_route_input_noref);
-
 /* called with rcu_read_lock held */
-int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
-		       u8 tos, struct net_device *dev, struct fib_result *res)
+static int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
+			      u8 tos, struct net_device *dev, struct fib_result *res)
 {
 	/* Multicast recognition logic is moved from route cache to here.
 	 * The problem was that too many Ethernet cards have broken/missing
@@ -2498,6 +2483,21 @@ int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	return ip_route_input_slow(skb, daddr, saddr, tos, dev, res);
 }
 
+int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
+			 u8 tos, struct net_device *dev)
+{
+	struct fib_result res;
+	int err;
+
+	tos &= IPTOS_RT_MASK;
+	rcu_read_lock();
+	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
+	rcu_read_unlock();
+
+	return err;
+}
+EXPORT_SYMBOL(ip_route_input_noref);
+
 /* called with rcu_read_lock() */
 static struct rtable *__mkroute_output(const struct fib_result *res,
 				       const struct flowi4 *fl4, int orig_oif,
-- 
2.17.1

