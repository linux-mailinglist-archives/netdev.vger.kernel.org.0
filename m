Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45773AF90A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 01:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhFUXPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 19:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhFUXPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 19:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE1E861042;
        Mon, 21 Jun 2021 23:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624317190;
        bh=btuPMqoKcrDBB8Ce8USSEHHKtXEzB+bsKREajriCGIE=;
        h=From:To:Cc:Subject:Date:From;
        b=WWoiXRoer/9OTk301LQxM7vURKbIZZP8zQOpBkY+GBEw8PBubYgjMcUWRTVXAK9H0
         cvK+yLIygKmK/IIZKCeesvzO4u5Alot0MoyazAnBaziThOymSoyjc22T71N6KHUF5X
         IdgMRLMfUawZKmswlR0VmG4wfb2M2IDA9UiXL5O65w834jWCalMp719NTjhdW9biIl
         vYAOOiT02MO8SugZAA8HmACjxfCFVORVW4BNv7SjPD+q6zOvO6AljfxeGbEAnTUEpX
         SL3i9ZON/LEP4qeiRwIYcdM93ow1FyNuFuFHG8eQNpwwDZx6bgozxhWVOknILdRriI
         tzxL2S7P+B3Ww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>
Subject: [PATCH net-next] ip: avoid OOM kills with large UDP sends over loopback
Date:   Mon, 21 Jun 2021 16:13:07 -0700
Message-Id: <20210621231307.1917413-1-kuba@kernel.org>
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

This is entirely avoidable, we can use an skb with frags.

The scenario is unlikely and always using frags requires
an extra allocation so opt for using fallback, rather
then always using frag'ed/paged skb when payload is large.

Note that the size heuristic (header_len > PAGE_SIZE)
is not entirely accurate, __alloc_skb() will add ~400B
to size. Occasional order-1 allocation should be fine,
though, we are primarily concerned with order-3.

Reported-by: Dave Jones <dsj@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sock.h    | 11 +++++++++++
 net/ipv4/ip_output.c  | 19 +++++++++++++++++--
 net/ipv6/ip6_output.c | 19 +++++++++++++++++--
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7a7058f4f265..4134fb718b97 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -924,6 +924,17 @@ static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
 	return gfp_mask | (sk->sk_allocation & __GFP_MEMALLOC);
 }
 
+static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
+{
+	*old = sk->sk_allocation;
+	sk->sk_allocation |= flag;
+}
+
+static inline void sk_allocation_pop(struct sock *sk, gfp_t old)
+{
+	sk->sk_allocation = old;
+}
+
 static inline void sk_acceptq_removed(struct sock *sk)
 {
 	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3efc7d658f6..a300c2c65d57 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
 				alloclen += rt->dst.trailer_len;
 
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk,
-						alloclen + hh_len + 15,
+				size_t header_len = alloclen + hh_len + 15;
+				gfp_t sk_allocation;
+
+				if (header_len > PAGE_SIZE)
+					sk_allocation_push(sk, __GFP_NORETRY,
+							   &sk_allocation);
+				skb = sock_alloc_send_skb(sk, header_len,
 						(flags & MSG_DONTWAIT), &err);
+				if (header_len > PAGE_SIZE) {
+					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
+
+					sk_allocation_pop(sk, sk_allocation);
+					if (unlikely(!skb) && !paged &&
+					    rt->dst.dev->features & NETIF_F_SG) {
+						paged = true;
+						goto alloc_new_skb;
+					}
+				}
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..9fd167db07e4 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1618,9 +1618,24 @@ static int __ip6_append_data(struct sock *sk,
 				goto error;
 			}
 			if (transhdrlen) {
-				skb = sock_alloc_send_skb(sk,
-						alloclen + hh_len,
+				size_t header_len = alloclen + hh_len;
+				gfp_t sk_allocation;
+
+				if (header_len > PAGE_SIZE)
+					sk_allocation_push(sk, __GFP_NORETRY,
+							   &sk_allocation);
+				skb = sock_alloc_send_skb(sk, header_len,
 						(flags & MSG_DONTWAIT), &err);
+				if (header_len > PAGE_SIZE) {
+					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
+
+					sk_allocation_pop(sk, sk_allocation);
+					if (unlikely(!skb) && !paged &&
+					    rt->dst.dev->features & NETIF_F_SG) {
+						paged = true;
+						goto alloc_new_skb;
+					}
+				}
 			} else {
 				skb = NULL;
 				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
-- 
2.31.1

