Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2A3BCFF5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhGFLbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235686AbhGFLaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4805961DD4;
        Tue,  6 Jul 2021 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570496;
        bh=X5VYRLC82Hifsg3LO19C1G7qG1DG745BaS0WJN1+9YY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1la8Vs3PKnxjo8rZAMVoApEI7NDzCXXrRKA9d43unl2f/apQ+0nWoO6DJACkB0bR
         W+mKZhieVVEFUiNGm+/+TRANmEoTgLO8JwyW+TxQy3VQmk5nBmRGkbGs10cGxqoQEQ
         hRFNsj0ABcfCvwt39c2mijQ/Ga2Hmv+p6nF1uWeqG2rXLyk8ihAh0lUoyM0KLKdgoL
         S56TPbMR5dS9wfQjgCk9iDTElQVYeWAbTtmo/Qlo9KqcZhEDJXaGYgzL0FiNhmty9H
         wo2fJ/zZb4U9KCNC+VH3bE4obcGrsHJn8Op/h5QvgJ6iA+Fkli/0xegxnaCxvRBo4g
         rvhlgdnxRsZFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 140/160] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Tue,  6 Jul 2021 07:18:06 -0400
Message-Id: <20210706111827.2060499-140-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 3aab53beb4ea..3ec3b67c184f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1054,7 +1054,7 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
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
index ff4f9ebcf7f6..497974b4372a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1555,7 +1555,7 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int datalen;
 			unsigned int fraglen;
 			unsigned int fraggap;
-			unsigned int alloclen;
+			unsigned int alloclen, alloc_extra;
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
2.30.2

