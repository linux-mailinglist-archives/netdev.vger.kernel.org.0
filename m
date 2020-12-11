Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC552D82CD
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 00:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437390AbgLKXfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 18:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437383AbgLKXfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 18:35:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0EFC06138C
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id kk4so3242139pjb.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 15:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C5GRxECZMSAf9dCnY0cH/nYiIjSrdOWOHdN7BXATNyw=;
        b=Sx+p6f2+gq+Kdb4ohqFEnhQL+OWLM+Y3KCDTByYTlOqjisNR8gdz9Re64WWVyRflP/
         QI9esAqrkUZz5a2XFGeX9HZf0mBeI3rsC0NdINzu/gmL3Kf3Xa7LIX2duwGZJGY0hGe2
         LTj2aWm9XswFcXWR9pDLUVXzNnJbI2HKGrwrOQ5dmX8ztYwT3t4sNC/ZU1cJBFyjgBZ4
         oNqYbSCjAkRc3naqdyX6wP6fDhKdYdEANMNgRwnUCHokS6dj8ZWzFhIWckfyLqGjWEDN
         r1s2ZjN0FFCwmlxOHAq5q7fdh4VHCGa07wYME5cBikzFxhsUm200E/qpvCEGmH4Zvx6S
         k6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C5GRxECZMSAf9dCnY0cH/nYiIjSrdOWOHdN7BXATNyw=;
        b=ZmYY2IO90X2T3KPN/WvX1+bnqm4cHVT2M+KbSBIzo+N1F8TwPgdFH51FCVVCm2InBz
         OuIDhEO8vwFY/Q0BJqy7Fo18cNjdH20ERn6qbXc/w0WFvbWKilRcvl3bY0rpPa9/STba
         3xXWC9ctB6mPlMu6rNOhCDEVIWY0MQaDjLyIFv3m0Fzl9p0pkbIilJBZFdp4NZgq4oHT
         h3P/oz3xKOU/xoCih24ZYO5Vgon+7qPBEo5LpmGgJDxXdYiCjuDZC4tIlC2sD1BYfOCg
         J+WBEaEkt16ZjjNpSXJ8fTT1lAB/NkFgT/IFGV8e8/B3VwaLUBvbGEqeuXz+iL3X4TTY
         E0lA==
X-Gm-Message-State: AOAM533xrofyZt0+mrqag8EwoOPEkPEn7RlRYx+8ciwFbmHbpvYvPUnK
        8F0DI6QWZ6tZC90vbzPoIFJxFYDqkpgr
X-Google-Smtp-Source: ABdhPJxV3EV2QyfOizvoCaAO1ytJsY4LnegfD8I67yilNq9ECFb2TPZSL+tyC13s11HWJ58Qf+C0vGuC+Z7r
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:8a82:: with SMTP id
 x2mr15080767pjn.107.1607729630321; Fri, 11 Dec 2020 15:33:50 -0800 (PST)
Date:   Fri, 11 Dec 2020 23:33:40 +0000
In-Reply-To: <20201211233340.1503242-1-brianvv@google.com>
Message-Id: <20201211233340.1503242-5-brianvv@google.com>
Mime-Version: 1.0
References: <20201211233340.1503242-1-brianvv@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v2 4/4] net: indirect call helpers for ipv4/ipv6
 dst_check functions
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: brianvv <brianvv@google.com>

This patch avoids the indirect call for the common case:
ip6_dst_check and ipv4_dst_check

Signed-off-by: brianvv <brianvv@google.com>
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
index 4fd7e785f177..753b831a9d70 100644
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
index af2338294598..aba5061024c7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1646,6 +1646,8 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
 	return mss;
 }
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
@@ -1665,7 +1667,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
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
index 22caee290b6c..e074fb5964e2 100644
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
index 1a1510513739..9e61e4fda03e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1417,6 +1417,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	return NULL;
 }
 
+INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
+							   u32));
 /* The socket must have it's spinlock held when we get
  * here, unless it is a TCP_LISTEN socket.
  *
@@ -1470,7 +1472,8 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
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
2.29.2.576.ga3fc446d84-goog

