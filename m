Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446E9F954A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLQOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:14:45 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48224 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLQOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 11:14:45 -0500
Received: from localhost ([::1]:33080 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iUYoU-0002Zr-5Q; Tue, 12 Nov 2019 17:14:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Garver <eric@garver.life>
Subject: [nf-next PATCH] net: netfilter: Support iif matches in POSTROUTING
Date:   Tue, 12 Nov 2019 17:14:37 +0100
Message-Id: <20191112161437.19511-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of generally passing NULL to NF_HOOK_COND() for input device,
pass skb->dev which contains input device for routed skbs.

Note that iptables (both legacy and nft) reject rules with input
interface match from being added to POSTROUTING chains, but nftables
allows this.

Cc: Eric Garver <eric@garver.life>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/ipv4/ip_output.c    | 4 ++--
 net/ipv4/xfrm4_output.c | 2 +-
 net/ipv6/ip6_output.c   | 4 ++--
 net/ipv6/xfrm6_output.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3d8baaaf7086d..9d83cb320dcb7 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -422,7 +422,7 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct net_device *dev = skb_dst(skb)->dev;
+	struct net_device *dev = skb_dst(skb)->dev, *indev = skb->dev;
 
 	IP_UPD_PO_STATS(net, IPSTATS_MIB_OUT, skb->len);
 
@@ -430,7 +430,7 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IP);
 
 	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, dev,
+			    net, sk, skb, indev, dev,
 			    ip_finish_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index ecff3fce98073..89ba7c87de5df 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -92,7 +92,7 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, skb_dst(skb)->dev,
+			    net, sk, skb, skb->dev, skb_dst(skb)->dev,
 			    __xfrm4_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 71827b56c0063..945508a7cb0f1 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -160,7 +160,7 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 
 int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct net_device *dev = skb_dst(skb)->dev;
+	struct net_device *dev = skb_dst(skb)->dev, *indev = skb->dev;
 	struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
 	skb->protocol = htons(ETH_P_IPV6);
@@ -173,7 +173,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	}
 
 	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
-			    net, sk, skb, NULL, dev,
+			    net, sk, skb, indev, dev,
 			    ip6_finish_output,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index eecac1b7148e5..fbe51d40bd7e9 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -187,7 +187,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
-			    net, sk, skb,  NULL, skb_dst(skb)->dev,
+			    net, sk, skb,  skb->dev, skb_dst(skb)->dev,
 			    __xfrm6_output,
 			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
-- 
2.24.0

