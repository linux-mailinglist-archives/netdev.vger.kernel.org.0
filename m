Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F6439C04
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhJYQuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbhJYQuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75784C061220
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a26so474502pfr.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yvoFbHItcgmslFM0wRmjTR9AgHVL2RK29yZdl/SUDVI=;
        b=R3grmXXwTy+pul1i48HY4pqUZj/2+StvPob/eYswt7B2nUPL8snThwJEAYiH8FpDIi
         Hbo3vXJsPN5nWnA94cevhvmkxh+VhfpFy9kS7yYb6CVE4WHqFz3mgC2oMxrARn7besQH
         b40viDIAcy2OUTGh5dvV3ou+N/F5dsGTwSX6mJKjPm6X6SXm0S80O6k9IMUYCB9P2/rl
         RKkOFNQyEEeii0iQfm1fsbb59EuhGx2e1MO09qCB+MDz/AQRoD2r1L706duuGvNaFZaI
         9R3GLSdnJaZ76ldJeN7kH57Lz3NnxeGtZLH1EjQjnZSBvqREj9sQ+43cNCzd1ZqIo1Yw
         bAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yvoFbHItcgmslFM0wRmjTR9AgHVL2RK29yZdl/SUDVI=;
        b=qPB+4wtOfc+btN42rmRf4EnjOOWUhHuExro8R6SWNG4sa9uV73Y9gA1bMsCXH14FWe
         3DLQGdai9Q842y2zrFUX4lSJlS3xEBDVgMos4FIjZxZ4Kul0ebwalo9hdNw9WGbI9m+0
         duafL+KndIPqJBEoIq6I69CJZFCZggwqWKLdpTIVn8HxfS//e+btzYRe90SdlJJ5+3FV
         KVFBKfwDUb9RvTJdiRrE/G8qtzskkHPbYYZ0v0vfg4jGyuDfHdaut4UVHpVyFKDB9rEX
         0YN75yU5D1TBfsRZzdlayDFM1SgtBBIt9yIroQMwu0WaMx+jguQIA9Mq8bPbZSG3ANP2
         Ao+g==
X-Gm-Message-State: AOAM530KUl3MQ7cgbC22tuY0gEUPL+mxtl4siB643U9yvE5L6jdpsnAI
        90YycdWBSOlc6n+JZAqeB84=
X-Google-Smtp-Source: ABdhPJygYzLQaYR1I06Oe1yIVeMGp33pacXe8/rZt/MjL5co+sYoPnY59cRF7+/OWBs2irnEJR264A==
X-Received: by 2002:a62:7c0b:0:b0:47b:df8d:816 with SMTP id x11-20020a627c0b000000b0047bdf8d0816mr14458376pfc.11.1635180509941;
        Mon, 25 Oct 2021 09:48:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 01/10] tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
Date:   Mon, 25 Oct 2021 09:48:16 -0700
Message-Id: <20211025164825.259415-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
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
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
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
index 5e6d8cb82ce5d8897ec33bf9113d94c42b55bb34..2bdc32c1afb65bb123a27444d9f6e4d01a188074 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1703,7 +1703,7 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    !INDIRECT_CALL_1(dst->ops->check, ipv4_dst_check,
 					     dst, 0)) {
 				dst_release(dst);
@@ -1788,7 +1788,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 			if (dst)
 				dst = dst_check(dst, 0);
 			if (dst &&
-			    inet_sk(sk)->rx_dst_ifindex == skb->skb_iif)
+			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
 		}
 	}
@@ -2195,7 +2195,7 @@ void inet_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 	if (dst && dst_hold_safe(dst)) {
 		sk->sk_rx_dst = dst;
-		inet_sk(sk)->rx_dst_ifindex = skb->skb_iif;
+		sk->sk_rx_dst_ifindex = skb->skb_iif;
 	}
 }
 EXPORT_SYMBOL(inet_sk_rx_dst_set);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1ef27cd7dbff713a22835fc13b57e2eca529f87e..3e8669b6d636c2971f2afc0abf0f2ef51ca6e2d4 100644
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
@@ -1509,7 +1509,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		sock_rps_save_rxhash(sk, skb);
 		sk_mark_napi_id(sk, skb);
 		if (dst) {
-			if (inet_sk(sk)->rx_dst_ifindex != skb->skb_iif ||
+			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
 					    dst, np->rx_dst_cookie) == NULL) {
 				dst_release(dst);
@@ -1874,7 +1874,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
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

