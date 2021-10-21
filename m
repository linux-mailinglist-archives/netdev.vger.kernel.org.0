Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD63436791
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhJUQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhJUQZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32138C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y4so816720plb.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rOil8ym42aNEoVie1dS9OFZdqUr5P1OG10M6EXwsAtU=;
        b=CbEUW/qmnNc4Z/xuiDkKie58q904IslfgS2waKR6juc1E0YHmMO5hYYD0QRmUIo4Kw
         rrVpkqm6RbTSNEBoNFEJ9jRYqHRDpZrxWjih9bUygUNsSdahYveIb+FikIih1/kP1Uk/
         l6JZQL+B9gad7D4j+51Trkxu5Dw9qxtV6K2pxC1G+JEyyXGIJ9yxYOMy2HE3w2AAyqoJ
         TdJYV+eAsqboYdqPUctfJmELIf6zzNS6G4M5yvGih3lcw1+ZCDaSfIOMhha9IATCvmVC
         xUWqkU6BJKOGar0DYHULU2GGObYK7DnA95NeDRG0mvHi29IDX3a4ehmTPmf8ndZaQ8/2
         Ulug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rOil8ym42aNEoVie1dS9OFZdqUr5P1OG10M6EXwsAtU=;
        b=TJOZZtccd372nIqzUG0AfT923mZ0FLDm7LAFhZmembK/2s2Go9ZD/3SevuiuexZCZ5
         /47i1w4KbM/uieOC9WC3avbT0IY5LwOtk3kEz+QtwaPBc2kYsZLp35cids2/ohDNioWT
         WkTM4FaCw8ct0EZEPGA4AbLbQO4EDc9RDYxkFRhkT9oAO5qm6HBZMjTENnSOGskaTIMx
         9TGUohClFLCtny+dvDiXIZyPWNCK7Tdzj0v2v5HQo+erik3+NtwnDw9fGfIK2vyJNY7f
         /hgt6ikmIY5WSmFKFuiw9OtTz836AEBYAQwetT5Hy5Fyuu+5HXHXsetHkVB5iTl/GYXr
         +0oQ==
X-Gm-Message-State: AOAM5327b3wjCBYw4GgbPhdUqSBX9+4oLb7cU/U0AQBrJ15BG4ZEydbm
        drrhsgEQLnlOpuCEhXzxqE4=
X-Google-Smtp-Source: ABdhPJy/f2GO5nfAVhppzyvNl28lNwTrfIMmLnYlrOvsn37RCOrsbdaVqPjuD+ahxpwOkwInhhzB6g==
X-Received: by 2002:a17:90a:8a8c:: with SMTP id x12mr7720352pjn.44.1634833383659;
        Thu, 21 Oct 2021 09:23:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 2/9] ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
Date:   Thu, 21 Oct 2021 09:22:45 -0700
Message-Id: <20211021162253.333616-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Increase cache locality by moving rx_dst_coookie next to sk->sk_rx_dst

This removes one or two cache line misses in IPv6 early demux (TCP/UDP)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ipv6.h | 1 -
 include/net/sock.h   | 2 ++
 net/ipv6/tcp_ipv6.c  | 6 +++---
 net/ipv6/udp.c       | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ef4a69865737cee82a72c35f3421a535b607c7a6..c383630d3f0658908eac65c030daf97b0a0d0c7c 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -282,7 +282,6 @@ struct ipv6_pinfo {
 	__be32			rcv_flowinfo;
 
 	__u32			dst_cookie;
-	__u32			rx_dst_cookie;
 
 	struct ipv6_mc_socklist	__rcu *ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
diff --git a/include/net/sock.h b/include/net/sock.h
index 0bfb3f138bdab01bd97498e1126d111743000c8c..99c4194cb61add848e3a35db0f952c4193f5ea1f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -260,6 +260,7 @@ struct bpf_local_storage;
   *	@sk_wq: sock wait queue and async head
   *	@sk_rx_dst: receive input route used by early demux
   *	@sk_rx_dst_ifindex: ifindex for @sk_rx_dst
+  *	@sk_rx_dst_cookie: cookie for @sk_rx_dst
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
@@ -432,6 +433,7 @@ struct sock {
 #endif
 	struct dst_entry	*sk_rx_dst;
 	int			sk_rx_dst_ifindex;
+	u32			sk_rx_dst_cookie;
 
 	struct dst_entry __rcu	*sk_dst_cache;
 	atomic_t		sk_omem_alloc;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 833b5ca8cc83798e5303542fc7522a86d97518ae..360c79c8e3099e54d125d454b7f5eb406678c91f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -109,7 +109,7 @@ static void inet6_sk_rx_dst_set(struct sock *sk, const struct sk_buff *skb)
 
 		sk->sk_rx_dst = dst;
 		sk->sk_rx_dst_ifindex = skb->skb_iif;
-		tcp_inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1508,7 +1508,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (dst) {
 			if (sk->sk_rx_dst_ifindex != skb->skb_iif ||
 			    INDIRECT_CALL_1(dst->ops->check, ip6_dst_check,
-					    dst, np->rx_dst_cookie) == NULL) {
+					    dst, sk->sk_rx_dst_cookie) == NULL) {
 				dst_release(dst);
 				sk->sk_rx_dst = NULL;
 			}
@@ -1869,7 +1869,7 @@ INDIRECT_CALLABLE_SCOPE void tcp_v6_early_demux(struct sk_buff *skb)
 			struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
 
 			if (dst)
-				dst = dst_check(dst, tcp_inet6_sk(sk)->rx_dst_cookie);
+				dst = dst_check(dst, sk->sk_rx_dst_cookie);
 			if (dst &&
 			    sk->sk_rx_dst_ifindex == skb->skb_iif)
 				skb_dst_set_noref(skb, dst);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8d785232b4796b7cafe14a35dedcbb0aaa2c37c2..14a94cddcf0bcf63d8351c66b94a08770694a9c8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -884,7 +884,7 @@ static void udp6_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst)
 	if (udp_sk_rx_dst_set(sk, dst)) {
 		const struct rt6_info *rt = (const struct rt6_info *)dst;
 
-		inet6_sk(sk)->rx_dst_cookie = rt6_get_cookie(rt);
+		sk->sk_rx_dst_cookie = rt6_get_cookie(rt);
 	}
 }
 
@@ -1073,7 +1073,7 @@ INDIRECT_CALLABLE_SCOPE void udp_v6_early_demux(struct sk_buff *skb)
 	dst = READ_ONCE(sk->sk_rx_dst);
 
 	if (dst)
-		dst = dst_check(dst, inet6_sk(sk)->rx_dst_cookie);
+		dst = dst_check(dst, sk->sk_rx_dst_cookie);
 	if (dst) {
 		/* set noref for now.
 		 * any place which wants to hold dst has to call
-- 
2.33.0.1079.g6e70778dc9-goog

