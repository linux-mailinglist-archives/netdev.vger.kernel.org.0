Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7C30AE3A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhBARnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhBARm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:42:27 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBBFC06178C
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:41:46 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id e10so11751418qvp.22
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cXK7SOSHSWz/+0eLFQjIQxVg658ZjSoqITQtma3KYAw=;
        b=Xk5Z3fAM6BVGuq3NzPLCoOYudS4i4Tw3xcOXUAauGIFhFe+ggsWb3IE96fDzlMNMPd
         Yx2tP4+WvbChpyFoKaf+AhD6zdNdnm96v+a3+T5cARdPdB+eA0DkkdNJlTzRb7QicMUL
         HewpAN6EjXCSa1SNo12sApaP3Zb8jEL4EiL5wQXQn7p7zFkOIKq/aqMAfxld4yF4BLeo
         iuLFkL7N8X+qvR1ffPZbfGiLl2Rc9hKeDaY3yobQHFNvaQnCnDnzCQeHCtaeddZuuEb5
         gY6wwpjsoG4NrXHhaO/5u0MGZaSnH2OvMVoN442jSQbJ7QuoXnbbegITaYl0wkps1giW
         ZNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cXK7SOSHSWz/+0eLFQjIQxVg658ZjSoqITQtma3KYAw=;
        b=FW7n99MFGk7rLzRebCnn6n7hdRmVILOHRdEjChzk8bYZrQkv5EmVQXLXkiC0meWYIM
         0p5MKIEAvyG3kWEy0P/S/P90wXhYul24xAF9e3aMlmbDx5yi8h3jdfIwNI2ZFBw1M9m7
         QUzpp5tZxPgcegDJPx0apzZXvCjsh/DWdIGhsr2OPlnulDvRJ7ycBwETtfajAOFHzGIP
         RrhjXx4TZ6Pd/I//ifdyGTUnNW/ZaqDKJeGu2/TeY9xB73b3yr0y8uAwBp6xg+vVQNd/
         a2T7akl4J0aqiiixvt0RFwMkUc4JCr0obUO4/6vlJL/YGZpSpLETLXsVSS0J1y/HhgLL
         fApQ==
X-Gm-Message-State: AOAM530co/I4WwOs/vbakOn/GP92dAM92k4gWIEF2VQFGkvsSLzo0peJ
        mJW8a/2OQmzEC5MldVKxhe4I/zCwC9zZ
X-Google-Smtp-Source: ABdhPJyP4BTE4JJHvXxXqv+Db2JyQ/6VoEFBe5E3xA70hybh6G07w/PAtq7KJracpdCNkIo2wGQOQem8Bv4Q
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:ad4:4d10:: with SMTP id
 l16mr16164255qvl.45.1612201306082; Mon, 01 Feb 2021 09:41:46 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:41:32 +0000
In-Reply-To: <20210201174132.3534118-1-brianvv@google.com>
Message-Id: <20210201174132.3534118-5-brianvv@google.com>
Mime-Version: 1.0
References: <20210201174132.3534118-1-brianvv@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v3 4/4] net: indirect call helpers for ipv4/ipv6
 dst_check functions
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch avoids the indirect call for the common case:
ip6_dst_check and ipv4_dst_check

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/net/dst.h   |  7 ++++++-
 net/core/sock.c     | 12 ++++++++++--
 net/ipv4/route.c    |  7 +++++--
 net/ipv4/tcp_ipv4.c |  5 ++++-
 net/ipv6/route.c    |  7 +++++--
 net/ipv6/tcp_ipv6.c |  5 ++++-
 6 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 9f474a79ed7d..26f134ad3a25 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -459,10 +459,15 @@ static inline int dst_input(struct sk_buff *skb)
 				  ip6_input, ip_local_deliver, skb);
 }
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ip6_dst_check(struct dst_entry *,
+							  u32));
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 static inline struct dst_entry *dst_check(struct dst_entry *dst, u32 cookie)
 {
 	if (dst->obsolete)
-		dst = dst->ops->check(dst, cookie);
+		dst = INDIRECT_CALL_INET(dst->ops->check, ip6_dst_check,
+					 ipv4_dst_check, dst, cookie);
 	return dst;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 648a5cb46209..0ed98f20448a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -526,11 +526,17 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(__sk_receive_skb);
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ip6_dst_check(struct dst_entry *,
+							  u32));
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 {
 	struct dst_entry *dst = __sk_dst_get(sk);
 
-	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+	if (dst && dst->obsolete &&
+	    INDIRECT_CALL_INET(dst->ops->check, ip6_dst_check, ipv4_dst_check,
+			       dst, cookie) == NULL) {
 		sk_tx_queue_clear(sk);
 		sk->sk_dst_pending_confirm = 0;
 		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
@@ -546,7 +552,9 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie)
 {
 	struct dst_entry *dst = sk_dst_get(sk);
 
-	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
+	if (dst && dst->obsolete &&
+	    INDIRECT_CALL_INET(dst->ops->check, ip6_dst_check, ipv4_dst_check,
+			       dst, cookie) == NULL) {
 		sk_dst_reset(sk);
 		dst_release(dst);
 		return NULL;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4fac91f8bd6c..9e6537709794 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -133,7 +133,8 @@ static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
  *	Interface to generic destination cache.
  */
 
-static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie);
+INDIRECT_CALLABLE_SCOPE
+struct dst_entry	*ipv4_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ipv4_default_advmss(const struct dst_entry *dst);
 INDIRECT_CALLABLE_SCOPE
 unsigned int		ipv4_mtu(const struct dst_entry *dst);
@@ -1188,7 +1189,8 @@ void ipv4_sk_redirect(struct sk_buff *skb, struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(ipv4_sk_redirect);
 
-static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
+INDIRECT_CALLABLE_SCOPE struct dst_entry *ipv4_dst_check(struct dst_entry *dst,
+							 u32 cookie)
 {
 	struct rtable *rt = (struct rtable *) dst;
 
@@ -1204,6 +1206,7 @@ static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
 		return NULL;
 	return dst;
 }
+EXPORT_SYMBOL(ipv4_dst_check);
 
 static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 777306b5bc22..611039207d30 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1649,6 +1649,8 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
 	return mss;
 }
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
@@ -1668,7 +1670,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
 			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
-			    !dst->ops->check(dst, 0)) {
+			    !INDIRECT_CALL_1(dst->ops->check, ipv4_dst_check,
+					     dst, 0)) {
 				dst_release(dst);
 				sk->sk_rx_dst = NULL;
 			}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4d83700d5602..f447f82e6819 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -81,7 +81,8 @@ enum rt6_nud_state {
 	RT6_NUD_SUCCEED = 1
 };
 
-static struct dst_entry	*ip6_dst_check(struct dst_entry *dst, u32 cookie);
+INDIRECT_CALLABLE_SCOPE
+struct dst_entry	*ip6_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ip6_default_advmss(const struct dst_entry *dst);
 INDIRECT_CALLABLE_SCOPE
 unsigned int		ip6_mtu(const struct dst_entry *dst);
@@ -2612,7 +2613,8 @@ static struct dst_entry *rt6_dst_from_check(struct rt6_info *rt,
 		return NULL;
 }
 
-static struct dst_entry *ip6_dst_check(struct dst_entry *dst, u32 cookie)
+INDIRECT_CALLABLE_SCOPE struct dst_entry *ip6_dst_check(struct dst_entry *dst,
+							u32 cookie)
 {
 	struct dst_entry *dst_ret;
 	struct fib6_info *from;
@@ -2642,6 +2644,7 @@ static struct dst_entry *ip6_dst_check(struct dst_entry *dst, u32 cookie)
 
 	return dst_ret;
 }
+EXPORT_SYMBOL(ip6_dst_check);
 
 static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0e1509b02cb3..d093ef3ef060 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1420,6 +1420,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	return NULL;
 }
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
@@ -1473,7 +1475,8 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
 			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
-			    dst->ops->check(dst, np->rx_dst_cookie) == NULL) {
+			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
+					    dst, np->rx_dst_cookie) == NULL) {
 				dst_release(dst);
 				sk->sk_rx_dst = NULL;
 			}
-- 
2.30.0.365.g02bc693789-goog

