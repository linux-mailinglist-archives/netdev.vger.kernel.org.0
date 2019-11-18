Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E8E100E46
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKRVti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:38 -0500
Received: from correo.us.es ([193.147.175.20]:45762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbfKRVth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8013DEBAC0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 715E8B8001
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6712AB7FF6; Mon, 18 Nov 2019 22:49:32 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9162DA7B6;
        Mon, 18 Nov 2019 22:49:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AC2CE42EE38F;
        Mon, 18 Nov 2019 22:49:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/18] netfilter: Support iif matches in POSTROUTING
Date:   Mon, 18 Nov 2019 22:49:07 +0100
Message-Id: <20191118214914.142794-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Instead of generally passing NULL to NF_HOOK_COND() for input device,
pass skb->dev which contains input device for routed skbs.

Note that iptables (both legacy and nft) reject rules with input
interface match from being added to POSTROUTING chains, but nftables
allows this.

Cc: Eric Garver <eric@garver.life>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/ip_output.c    | 4 ++--
 net/ipv4/xfrm4_output.c | 2 +-
 net/ipv6/ip6_output.c   | 4 ++--
 net/ipv6/xfrm6_output.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3d8baaaf7086..9d83cb320dcb 100644
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
index ecff3fce9807..89ba7c87de5d 100644
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
index 71827b56c006..945508a7cb0f 100644
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
index eecac1b7148e..fbe51d40bd7e 100644
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
2.11.0

