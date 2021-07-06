Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB93BD28F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhGFLnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237431AbhGFLgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E04EA61D97;
        Tue,  6 Jul 2021 11:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570859;
        bh=hYvTJFirkRNFXaUuLPNqdqCUs/4BEb1omZSphSlYTA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwtijNBFgMGA3np8nIGq+QyORjPx4ywUG3M/eBLgRiXLwnEJmp4TMFzqJ/Xncr/xt
         a78LWCbm4NHJfrv9k0HyaYLfsKsnrHM1IrIzkHaKP2JqD81N3tZUIkBPHFfqfmfhHX
         H25cr6z1C8YUqopwJU+VaogCM8WghDrlppnvTfcrwjs9rPS0Ivutl46tsGIWYb4U65
         x++uukdhqHk3mHRDnvi2pbS9y71Q7DVNCQ228qXTLM5DyqGtvPdqP+lWP1+oDl5OIY
         oD0Lc6Fq3po0hAKJGSdFSMLxoYV5wg/CTmJux9VgyLJ2LYB5AsaazuiJaxqZnMC3CI
         DFgrhxw7LooXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 48/55] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Tue,  6 Jul 2021 07:26:31 -0400
Message-Id: <20210706112638.2065023-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index e411c42d8428..e63905f7f6f9 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -940,7 +940,7 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
 alloc_new_skb:
@@ -960,35 +960,39 @@ static int __ip_append_data(struct sock *sk,
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
index e1bb7db88483..aa8f19f852cc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1394,7 +1394,7 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
 			unsigned int pagedlen;
 alloc_new_skb:
 			/* There's no room in the current skb */
@@ -1421,17 +1421,28 @@ static int __ip6_append_data(struct sock *sk,
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
@@ -1441,30 +1452,21 @@ static int __ip6_append_data(struct sock *sk,
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

