Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF4F3BD5D4
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241758AbhGFMZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236892AbhGFLfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3F261C27;
        Tue,  6 Jul 2021 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570678;
        bh=9MrIMMYsrdUVoHD7fJaIySMwIZD4V2nAg3wCypgUlzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzfud9sRTuWqUekKzZFbBMbyCvw2kTEcygkv2G1q3goq7LS4HoXkpFquitUpMYHU/
         RTW3bjbHgsh07lJs6aQt7v+x0fWjPZ4TIqqKsdHqMTcG6fPan2XzfFzzNKc8w277UR
         KXMktyVuYxnUwnuKQuhE3VUGjjccvEY+nhspRqeUTgUDXX8lXi1C60j3c9vUnY1taM
         cOqmIC05PVANrvfATeakHf3lGes6K+5+JT8CYfu9P+MMMXPACGLRFCQoPr6XBoYyZZ
         g9bsjSHksr7AJrPNfWx+S+7rMLMbq5HQJh8jEvL4R6VbleYna7LmuBAdPatFqJebOX
         zwoAxy0BhYTDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 119/137] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Tue,  6 Jul 2021 07:21:45 -0400
Message-Id: <20210706112203.2062605-119-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6d123b81ac615072a8525c13c6c41b695270a15d ]

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

Reported-by: Dave Jones <dsj@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c  | 32 ++++++++++++++++++--------------
 net/ipv6/ip6_output.c | 32 +++++++++++++++++---------------
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 97975bed491a..560d5dc43562 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1053,7 +1053,7 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
 alloc_new_skb:
@@ -1073,35 +1073,39 @@ static int __ip_append_data(struct sock *sk,
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
+				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
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
index 077d43af8226..e889655ca0e2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1554,7 +1554,7 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 alloc_new_skb:
 			/* There's no room in the current skb */
@@ -1581,17 +1581,28 @@ static int __ip6_append_data(struct sock *sk,
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
+				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
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
@@ -1601,30 +1612,21 @@ static int __ip6_append_data(struct sock *sk,
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
2.30.2

