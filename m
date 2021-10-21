Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA893436790
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhJUQZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhJUQZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:18 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D518BC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:02 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y4so816674plb.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n4DFkZiSDkuY8LbQ+kBZUgsfQPRpZGjgSaDuH9UynNY=;
        b=Gu04siatcl5ZuMLvFWD3M6PWm6wRUDWhhFt352/yQ1mkJpDIVcP2zp4UgfLzcf6gwQ
         i8YI/EQUXlBBKfCA/I4v1Sq0LLQFD59tdtKLLc7agJPIoImAoUX0AM8Xgy/BovtbFnoF
         LkBXj30Y2erFTivlhWZ9Oag1+fbvlPsdQD+dvOq1gn4kU6Ira1mlH6TqLxIdU7omE5zy
         PmWPw7i537eK7XYrNzIs4nvp60IE+dZK5sc260UccGgsPQ0lfSUylVvvO+CAX11FUCqA
         d+7Zd7yLOsRXB2TWanZ29fT/ysRmjqeDks5yGpfViv5mqst3lGBkFispNd6kaRDMCp96
         Ym1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n4DFkZiSDkuY8LbQ+kBZUgsfQPRpZGjgSaDuH9UynNY=;
        b=msxvaif5fmvO9j6DY3YXOVCLZJHYksEZC+97k/e7kgEJUKTrd3drOXsp2lW/hDrwF6
         sJqF5NO6gEiykkA7Q1kYGdB5TS6030HbIQiObxucqGQmYYnaKKaKDYB+HZJ3UFPpT5yy
         rUPHfO26T+K3uXM+S2Js43CyOlg0DHAK4+dbsnA//DrAUYC83m6PCp4Fcu/Nd5V4kEGQ
         NFzmdM7d+RSRuj1O4wVEbNjGyvNWVEK7owSyzWwInA1/NfG5YyLZKqDlkeYxLzzv/QYI
         /rOyp8nEJ0eZsO1IQ2Re4XlXSqXOejm+HPkofn8mCiHmb1fFfUY8rJd0D6mBSD/Fjvpm
         TwhQ==
X-Gm-Message-State: AOAM53150oAbuDzplezZtAuVIri0hi8xh/RucH65n2+QX2i4YHiqVzLq
        5O8shnmRp2XMGkbyUcwVxzI=
X-Google-Smtp-Source: ABdhPJw6zuzarHkGJTh1iPZ8SXW7NLr/kqpoOtWWZyrXcTR1064QM4RFvRKMTMjc62IB4fVySFJfzw==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr7918563pjb.12.1634833382391;
        Thu, 21 Oct 2021 09:23:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 1/9] tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
Date:   Thu, 21 Oct 2021 09:22:44 -0700
Message-Id: <20211021162253.333616-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Increase cache locality by moving rx_dst_ifindex next to sk->sk_rx_dst

This is part of an effort to reduce cache line misses in TCP fast path.

This removes one cache line miss in early demux.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_sock.h | 3 +--
 include/net/sock.h      | 3 +++
 net/ipv4/tcp_ipv4.c     | 6 +++---
 net/ipv6/tcp_ipv6.c     | 6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 89163ef8cf4be2aaf99d09806749911a121a56e0..9e1111f5915bd03b6ec5e2e4a74ea0079ede8263 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -207,11 +207,10 @@ struct inet_sock {
 	__be32			inet_saddr;
 	__s16			uc_ttl;
 	__u16			cmsg_flags;
+	struct ip_options_rcu __rcu	*inet_opt;
 	__be16			inet_sport;
 	__u16			inet_id;
 
-	struct ip_options_rcu __rcu	*inet_opt;
-	int			rx_dst_ifindex;
 	__u8			tos;
 	__u8			min_ttl;
 	__u8			mc_ttl;
diff --git a/include/net/sock.h b/include/net/sock.h
index 596ba85611bc786affed2bf2b18e455b015f3774..0bfb3f138bdab01bd97498e1126d111743000c8c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -259,6 +259,7 @@ struct bpf_local_storage;
   *	@sk_rcvbuf: size of receive buffer in bytes
   *	@sk_wq: sock wait queue and async head
   *	@sk_rx_dst: receive input route used by early demux
+  *	@sk_rx_dst_ifindex: ifindex for @sk_rx_dst
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
@@ -430,6 +431,8 @@ struct sock {
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
 	struct dst_entry	*sk_rx_dst;
+	int			sk_rx_dst_ifindex;
+
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
 	int			sk_sndbuf;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 29a57bd159f0aa99e892bac56b75961c107f803a..e8ca8539b436cf8a8af5b53645a25923003afc41 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1684,7 +1684,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    !INDIRECT_CALL_1(dst->ops->check, ipv4_dst_check,
 					     dst, 0)) {
 				dst_release(dst);
@@ -1769,7 +1769,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 			if (dst)
 				dst = dst_check(dst, 0);
 			if (dst &&
-			    inet_sk(sk)->rx_dst_ifindex == skb->skb_iif)
+			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
@@ -2176,7 +2176,7 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 	if (dst && dst_hold_safe(dst)) {
 		sk->sk_rx_dst = dst;
-		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
+		sk->sk_rx_dst_ifindex = skb->skb_iif;
 	}
 }
 EXPORT_SYMBOL(inet_sk_rx_dst_set);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8cf5ff2e95043ec1a2b27661aae884eb13dcf9eb..833b5ca8cc83798e5303542fc7522a86d97518ae 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -108,7 +108,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
 		sk->sk_rx_dst = dst;
-		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
+		sk->sk_rx_dst_ifindex = skb->skb_iif;
 		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
@@ -1506,7 +1506,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
 					    dst, np->rx_dst_cookie) == NULL) {
 				dst_release(dst);
@@ -1871,7 +1871,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 			if (dst)
 				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
 			if (dst &&
-			    inet_sk(sk)->rx_dst_ifindex == skb->skb_iif)
+			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
-- 
2.33.0.1079.g6e70778dc9-goog

