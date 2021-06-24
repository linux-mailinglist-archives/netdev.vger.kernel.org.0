Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20FF3B3514
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhFXR7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXR7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 13:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F6B613C7;
        Thu, 24 Jun 2021 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624557449;
        bh=shjoEaIpxajR0ULCSg3wpffIS9sW/kE2I1+V7I+a19I=;
        h=From:To:Cc:Subject:Date:From;
        b=rfuxVCNunRfpuFXiOUF5V/2b4f7LlCBs87FL6fwiFI57JEy/FoaIR/X5lORegsQ82
         KK/pmuXjWmyxnSs8PLuYncJzDxtgT2BB8KMvZh67pwsXMAoBcutdSsl916f2cshkBb
         iWV0c3THvhFgEsADtl83caFOpF5+7HZXhSzqS5M7vX1kAoQ8Kmb+oJeDPLfOeUDxmx
         P4QiR+DG1c2phhD4kmSdDrf4k00e0k1rAg5thxWhvRPen/EHbkLbec+NEt78p3pFzj
         kzp7sEmYZ6H77lNUNMU79Gq/RDqpLCgPynXro1yUDUZX0+ytyl+m2Y9oKB9nVv2XD2
         MBtqafnkZq8GA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, brouer@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>
Subject: [PATCH net-next v5] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Thu, 24 Jun 2021 10:57:24 -0700
Message-Id: <20210624175724.2389359-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave observed number of machines hitting OOM on the UDP send
path. The workload seems to be sending large UDP packets over
loopback. Since loopback has MTU of 64k kernel will try to
allocate an skb with up to 64k of head space. This has a good
chance of failing under memory pressure. What's worse if
the message length is <32k the allocation may trigger an
OOM killer.

This is entirely avoidable, we can use an skb with page frags.

af_unix solves a similar problem by limiting the head
length to SKB_MAX_ALLOC. This seems like a good and simple
approach. It means that UDP messages > 16kB will now
use fragments if underlying device supports SG, if extra
allocator pressure causes regressions in real workloads
we can switch to trying the large allocation first and
falling back.

v4: pre-calculate all the additions to alloclen so
    we can be sure it won't go over order-2
v5: s/< MAX/<= MAX/ ; reorder variable declaration

Reported-by: Dave Jones <dsj@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/ip_output.c  | 32 ++++++++++++++++++--------------
 net/ipv6/ip6_output.c | 32 +++++++++++++++++---------------
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d658f6..f5c398036efa 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1050,11 +1050,11 @@ static int __ip_append_data(struct sock *sk,
 		if (copy < length)
 			copy = maxfraglen - skb->len;
 		if (copy <= 0) {
+			unsigned int alloclen, alloc_extra;
 			char *data;
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
 			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
 alloc_new_skb:
@@ -1074,35 +1074,39 @@ static int __ip_append_data(struct sock *sk,
 			fraglen = datalen + fragheaderlen;
 			pagedlen = 0;
 
+			alloc_extra = hh_len + 15;
+			alloc_extra += exthdrlen;
+
+			/* The last fragment gets additional space at tail.
+			 * Note, with MSG_MORE we overallocate on fragments,
+			 * because we have no idea what fragment will be
+			 * the last.
+			 */
+			if (datalen == length + fraggap)
+				alloc_extra += rt->dst.trailer_len;
+
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged &&
+				 (fraglen + alloc_extra <= SKB_MAX_ALLOC ||
+				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
 			}
 
-			alloclen += exthdrlen;
-
-			/* The last fragment gets additional space at tail.
-			 * Note, with MSG_MORE we overallocate on fragments,
-			 * because we have no idea what fragment will be
-			 * the last.
-			 */
-			if (datalen == length + fraggap)
-				alloclen += rt->dst.trailer_len;
+			alloclen += alloc_extra;
 
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk,
-						alloclen + hh_len + 15,
+				skb = sock_alloc_send_skb(sk, alloclen,
 						(flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
-					skb = alloc_skb(alloclen + hh_len + 15,
+					skb = alloc_skb(alloclen,
 							sk->sk_allocation);
 				if (unlikely(!skb))
 					err = -ENOBUFS;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..afe887dd5e35 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1551,11 +1551,11 @@ static int __ip6_append_data(struct sock *sk,
 			copy = maxfraglen - skb->len;
 
 		if (copy <= 0) {
+			unsigned int alloclen, alloc_extra;
 			char *data;
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
 			unsigned int pagedlen;
 alloc_new_skb:
 			/* There's no room in the current skb */
@@ -1582,17 +1582,28 @@ static int __ip6_append_data(struct sock *sk,
 			fraglen = datalen + fragheaderlen;
 			pagedlen = 0;
 
+			alloc_extra = hh_len;
+			alloc_extra += dst_exthdrlen;
+			alloc_extra += rt->dst.trailer_len;
+
+			/* We just reserve space for fragment header.
+			 * Note: this may be overallocation if the message
+			 * (without MSG_MORE) fits into the MTU.
+			 */
+			alloc_extra += sizeof(struct frag_hdr);
+
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged &&
+				 (fraglen + alloc_extra <= SKB_MAX_ALLOC ||
+				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
 			}
-
-			alloclen += dst_exthdrlen;
+			alloclen += alloc_extra;
 
 			if (datalen != length + fraggap) {
 				/*
@@ -1602,30 +1613,21 @@ static int __ip6_append_data(struct sock *sk,
 				datalen += rt->dst.trailer_len;
 			}
 
-			alloclen += rt->dst.trailer_len;
 			fraglen = datalen + fragheaderlen;
 
-			/*
-			 * We just reserve space for fragment header.
-			 * Note: this may be overallocation if the message
-			 * (without MSG_MORE) fits into the MTU.
-			 */
-			alloclen += sizeof(struct frag_hdr);
-
 			copy = datalen - transhdrlen - fraggap - pagedlen;
 			if (copy < 0) {
 				err = -EINVAL;
 				goto error;
 			}
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk,
-						alloclen + hh_len,
+				skb = sock_alloc_send_skb(sk, alloclen,
 						(flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
 				    2 * sk->sk_sndbuf)
-					skb = alloc_skb(alloclen + hh_len,
+					skb = alloc_skb(alloclen,
 							sk->sk_allocation);
 				if (unlikely(!skb))
 					err = -ENOBUFS;
-- 
2.31.1

