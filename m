Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8ADA2E6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405633AbfJQBBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:01:03 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35182 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJQBBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:01:03 -0400
Received: by mail-pl1-f202.google.com with SMTP id o12so344114pll.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CEPjJxI+MjVw2J6HNNCTgkSed8Fk7zUEYcRSIwDUujY=;
        b=cg0lnhi0oSeDA+bBYmT8O4GSJuoQqr9JjSX1ExYtuTF72myAkZpRztKs7fY6crBp24
         U/q3D9EdhBdunxb79ouimsXQ3TH2EEsDNQXsA8VJwYiVYkxZMIC2ZsgwPlHnOSDWywOD
         75IJ5dbnp0UG/aQ7hi33NVdFBy8E3E+S5kTCujcfsKqDo/s4fio9Kup4zdXUvmpBgr5S
         btzfz05gZm+QvGpgkGd402voKNNSxnaBEHs+vYrNKIe0ay4+kxaCjj/O+SWhoIBIXvdS
         EBdFDCC0U3gCtIE/j7DC8Re6Vxlb/tjwhSYVSbEEeghLwrs2FSue//1eMpYN74TSnFHf
         PQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CEPjJxI+MjVw2J6HNNCTgkSed8Fk7zUEYcRSIwDUujY=;
        b=gkSk+ltCMxlW8bY1ZbVow4Fi+YKeM29qjkMjF73hi4ZvMvpSAmli2OCu2jGGYEQZBs
         Tl9eS2LsOKzQnD1nWzjbG+vv7V0PNxLeBo75UoWwlqy8tjqugsZo62/ifgivcMkp8Ist
         7ny+o5GPZ99mc4PWpAfF54lLtzD7lntONa7kUx61eYjYWq19KguwX/YKc72SU77nO6yw
         22l6NFVGvBL5wIYXsWrLpNPgcNJBBpwqw1g3AFxm7GfwuNQN64jXIJtRy42kggUX7xKT
         yPYFULgRBNfT5xeCSx4Ol4WL0PjlJNXTuVakIIzl51PC2ZFf+OoULJUquZXsnrJqI07w
         0iEQ==
X-Gm-Message-State: APjAAAWTPZhrCr1QSlgKHcvyskXBoQuz3CuoWcumsYedGchx9uS2sM1B
        IZeYb4S8FNtmi5x5+ODULLrqCkIM1OAZiw==
X-Google-Smtp-Source: APXvYqy/P1ShqAKKLkRc8zoeol92uZJvZAPm2vKyouKAHMRp5k4tDloqVVFdafneQ+eoVcT2OLVHgrNyIWtqwA==
X-Received: by 2002:a63:c045:: with SMTP id z5mr1083676pgi.69.1571274060335;
 Wed, 16 Oct 2019 18:01:00 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:00:56 -0700
Message-Id: <20191017010056.58021-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] net: ensure correct skb->tstamp in various fragmenters
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Bartschies <Thomas.Bartschies@cvk.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas found that some forwarded packets would be stuck
in FQ packet scheduler because their skb->tstamp contained
timestamps far in the future.

We thought we addressed this point in commit 8203e2d844d3
("net: clear skb->tstamp in forwarding paths") but there
is still an issue when/if a packet needs to be fragmented.

In order to meet EDT requirements, we have to make sure all
fragments get the original skb->tstamp.

Note that this original skb->tstamp should be zero in
forwarding path, but might have a non zero value in
output path if user decided so.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thomas Bartschies <Thomas.Bartschies@cvk.de>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 3 +++
 net/ipv4/ip_output.c                       | 3 +++
 net/ipv6/ip6_output.c                      | 3 +++
 net/ipv6/netfilter.c                       | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8842798c29e636ac2dbfe01f0bf2ba2f2d398c44..506d6141e44eea67ccc34123ad4250a19bcc7ab7 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -33,6 +33,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
 	unsigned int hlen, ll_rs, mtu;
+	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	struct iphdr *iph;
 	int err;
@@ -80,6 +81,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 			if (iter.frag)
 				ip_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -104,6 +106,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 			goto blackhole;
 		}
 
+		skb2->tstamp = tstamp;
 		err = output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 28fca408812c5576fc4ea957c1c4dec97ec8faf3..814b9b8882a0237bffd869cb13739e03af227f30 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -771,6 +771,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct rtable *rt = skb_rtable(skb);
 	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
+	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	int err = 0;
 
@@ -846,6 +847,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 				ip_fraglist_prepare(skb, &iter);
 			}
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, skb);
 
 			if (!err)
@@ -900,6 +902,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
+		skb2->tstamp = tstamp;
 		err = output(net, sk, skb2);
 		if (err)
 			goto fail;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index edadee4a7e76105f737d705052db8f5bbc6c0152..71827b56c0063b56bcfbef4bd8910ddcec035824 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -768,6 +768,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 				inet6_sk(skb->sk) : NULL;
 	struct ip6_frag_state state;
 	unsigned int mtu, hlen, nexthdr_offset;
+	ktime_t tstamp = skb->tstamp;
 	int hroom, err = 0;
 	__be32 frag_id;
 	u8 *prevhdr, nexthdr = 0;
@@ -855,6 +856,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, skb);
 			if (!err)
 				IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
@@ -913,6 +915,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
+		frag->tstamp = tstamp;
 		err = output(net, sk, frag);
 		if (err)
 			goto fail;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a9bff556d3b2ddd5334d20a63210bad0dfa6cd2d..409e79b84a830dd22ffe7728f45d9dc65ec01df4 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -119,6 +119,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 				  struct sk_buff *))
 {
 	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+	ktime_t tstamp = skb->tstamp;
 	struct ip6_frag_state state;
 	u8 *prevhdr, nexthdr = 0;
 	unsigned int mtu, hlen;
@@ -183,6 +184,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
 
+			skb->tstamp = tstamp;
 			err = output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -215,6 +217,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			goto blackhole;
 		}
 
+		skb2->tstamp = tstamp;
 		err = output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;
-- 
2.23.0.700.g56cf767bdb-goog

