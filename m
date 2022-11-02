Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8219561576A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 03:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiKBCPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 22:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBCPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 22:15:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8504F658D;
        Tue,  1 Nov 2022 19:15:16 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N29TC38zzzmVVp;
        Wed,  2 Nov 2022 10:15:11 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 10:15:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 10:15:14 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ipvlan: minor optimization for ipvlan outbound process
Date:   Wed, 2 Nov 2022 10:15:49 +0800
Message-ID: <20221102021549.12213-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid some local variable initialization and remove some
redundant assignment in ipvlan outbound process.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 56 +++++++++++++++-----------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index bb1c298c1e78..2b715035380b 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -417,7 +417,7 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	struct net *net = dev_net(dev);
 	struct rtable *rt;
-	int err, ret = NET_XMIT_DROP;
+	int err;
 	struct flowi4 fl4 = {
 		.flowi4_oif = dev->ifindex,
 		.flowi4_tos = RT_TOS(ip4h->tos),
@@ -438,15 +438,14 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 	skb_dst_set(skb, &rt->dst);
 	err = ip_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
-	else
-		ret = NET_XMIT_SUCCESS;
-	goto out;
+		goto tx_errors_inc;
+
+	return NET_XMIT_SUCCESS;
 err:
-	dev->stats.tx_errors++;
 	kfree_skb(skb);
-out:
-	return ret;
+tx_errors_inc:
+	dev->stats.tx_errors++;
+	return NET_XMIT_DROP;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -456,7 +455,7 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	struct net *net = dev_net(dev);
 	struct dst_entry *dst;
-	int err, ret = NET_XMIT_DROP;
+	int err;
 	struct flowi6 fl6 = {
 		.flowi6_oif = dev->ifindex,
 		.daddr = ip6h->daddr,
@@ -469,22 +468,23 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst->error) {
-		ret = dst->error;
+		err = dst->error;
 		dst_release(dst);
 		goto err;
 	}
 	skb_dst_set(skb, dst);
 	err = ip6_local_out(net, skb->sk, skb);
-	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
-	else
-		ret = NET_XMIT_SUCCESS;
-	goto out;
+	if (unlikely(net_xmit_eval(err))) {
+		err = NET_XMIT_DROP;
+		goto tx_errors_inc;
+	}
+
+	return NET_XMIT_SUCCESS;
 err:
-	dev->stats.tx_errors++;
 	kfree_skb(skb);
-out:
-	return ret;
+tx_errors_inc:
+	dev->stats.tx_errors++;
+	return err;
 }
 #else
 static int ipvlan_process_v6_outbound(struct sk_buff *skb)
@@ -495,8 +495,6 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 
 static int ipvlan_process_outbound(struct sk_buff *skb)
 {
-	int ret = NET_XMIT_DROP;
-
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
 	 * will have L2; which need to discarded and processed further
 	 * in the net-ns of the main-device.
@@ -511,7 +509,7 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 				"Dropped {multi|broad}cast of type=[%x]\n",
 				ntohs(skb->protocol));
 			kfree_skb(skb);
-			goto out;
+			return NET_XMIT_DROP;
 		}
 
 		skb_pull(skb, sizeof(*ethh));
@@ -520,16 +518,14 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 	}
 
 	if (skb->protocol == htons(ETH_P_IPV6))
-		ret = ipvlan_process_v6_outbound(skb);
+		return ipvlan_process_v6_outbound(skb);
 	else if (skb->protocol == htons(ETH_P_IP))
-		ret = ipvlan_process_v4_outbound(skb);
-	else {
-		pr_warn_ratelimited("Dropped outbound packet type=%x\n",
-				    ntohs(skb->protocol));
-		kfree_skb(skb);
-	}
-out:
-	return ret;
+		return ipvlan_process_v4_outbound(skb);
+
+	pr_warn_ratelimited("Dropped outbound packet type=%x\n",
+			    ntohs(skb->protocol));
+	kfree_skb(skb);
+	return NET_XMIT_DROP;
 }
 
 static void ipvlan_multicast_enqueue(struct ipvl_port *port,
-- 
2.33.0

