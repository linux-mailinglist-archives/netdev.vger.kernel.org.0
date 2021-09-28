Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9395641B999
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhI1Vs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242556AbhI1Vs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 17:48:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14385C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso633786ybq.10
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 14:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3cXNsNOjcfE/nCmwonP8h/HYpTsOObliFungylaBWO4=;
        b=Mrljl0+vPVoTe1wFjthqq0Ty+D0+LTOxQsTu7uQYa40AgH1Teerf9M4nyIjXAVbNoL
         mN8zJc9tE9IXPgKzEWrISqnEDAvKq0pvUZIsCSeYf5p+cWLilGNiiK60CUA2hQendbYj
         +P2cyebyZ1IC8bCuMau6eWL8a5Ow7Dl+vhCYSQXUYYmP7lh29kL4M+RRwxGmVhStr36S
         gKgARv7ztV6iC/QGEZEjm2/Qk25Oq/MVdrPwxxet+/eGZlVqZH5aaVlK8sMaIglGIamG
         oZvm06bDJAU+/4AFzBDCnKv20PscqyBnzu0wKOxbQUCn9WEMfgcQVjRDZpJKgwG48Ac1
         n3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3cXNsNOjcfE/nCmwonP8h/HYpTsOObliFungylaBWO4=;
        b=VlTKS+afJt009YwSUC2M9FxWBu8uOLRsuJetn4KtI1kG14UYLiJie9CcamLfMjtDbo
         kDILnMgnWChO0r+zKHgvQg/CmGcTI7DdFqSMti3ebbYGYNaNf5+5yAAbAuEgmoD8Ou/v
         /HfEWITAOyRVPpLtd/xRLGkNvVgIyCq1OKtSfkIvP6clv9MQnY+f4w9n/cnuzfaw6zx3
         h9W4IXTuEPDVEl2eIGA6YHRNB35/yolNWZeHiXDaPHu39Sdv8t++g5W/2f3eyG3wdFAs
         bIJhsPnk06c1Pr1IGZPVyBzjh9w1ypQaWOtByRzc8zz0Qgz+wAHBY0jypl0UlUJnWuy+
         kn8g==
X-Gm-Message-State: AOAM532C3p4tHq0MggWoNAOBdDIK4KnyNE743zzFr9ysD4ME9wIsWMek
        nRjBqsa0nV2o5wPF3L2MaMd5QsQe+Dw=
X-Google-Smtp-Source: ABdhPJwNJ5OtIt2hjpz84UPAjQRDeat7S5G/RYM0Trmfj6zqFsth+OFAnqqBxYqqrF8dliiw1IEeVrqyjZM=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:5d42:81b8:4b7f:efe2])
 (user=weiwan job=sendgmr) by 2002:a25:2c97:: with SMTP id s145mr1307923ybs.463.1632865608180;
 Tue, 28 Sep 2021 14:46:48 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:46:41 -0700
In-Reply-To: <20210928214643.3300692-1-weiwan@google.com>
Message-Id: <20210928214643.3300692-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210928214643.3300692-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 net-next 1/3] net: add new socket option SO_RESERVE_MEM
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "'David S . Miller'" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This socket option provides a mechanism for users to reserve a certain
amount of memory for the socket to use. When this option is set, kernel
charges the user specified amount of memory to memcg, as well as
sk_forward_alloc. This amount of memory is not reclaimable and is
available in sk_forward_alloc for this socket.
With this socket option set, the networking stack spends less cycles
doing forward alloc and reclaim, which should lead to better system
performance, with the cost of an amount of pre-allocated and
unreclaimable memory, even under memory pressure.

Note:
This socket option is only available when memory cgroup is enabled and we
require this reserved memory to be charged to the user's memcg. We hope
this could avoid mis-behaving users to abused this feature to reserve a
large amount on certain sockets and cause unfairness for others.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/sock.h                | 43 ++++++++++++++++---
 include/uapi/asm-generic/socket.h |  2 +
 net/core/sock.c                   | 69 +++++++++++++++++++++++++++++++
 net/core/stream.c                 |  2 +-
 net/ipv4/af_inet.c                |  2 +-
 5 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 879980de3dcd..0feb37c7f534 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -409,6 +409,7 @@ struct sock {
 #define sk_rmem_alloc sk_backlog.rmem_alloc
 
 	int			sk_forward_alloc;
+	u32			sk_reserved_mem;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	unsigned int		sk_ll_usec;
 	/* ===== mostly read cache line ===== */
@@ -1511,20 +1512,49 @@ sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 		skb_pfmemalloc(skb);
 }
 
+static inline int sk_unused_reserved_mem(const struct sock *sk)
+{
+	int unused_mem;
+
+	if (likely(!sk->sk_reserved_mem))
+		return 0;
+
+	unused_mem = sk->sk_reserved_mem - sk->sk_wmem_queued -
+			atomic_read(&sk->sk_rmem_alloc);
+
+	return unused_mem > 0 ? unused_mem : 0;
+}
+
 static inline void sk_mem_reclaim(struct sock *sk)
 {
+	int reclaimable;
+
 	if (!sk_has_account(sk))
 		return;
-	if (sk->sk_forward_alloc >= SK_MEM_QUANTUM)
-		__sk_mem_reclaim(sk, sk->sk_forward_alloc);
+
+	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
+
+	if (reclaimable >= SK_MEM_QUANTUM)
+		__sk_mem_reclaim(sk, reclaimable);
+}
+
+static inline void sk_mem_reclaim_final(struct sock *sk)
+{
+	sk->sk_reserved_mem = 0;
+	sk_mem_reclaim(sk);
 }
 
 static inline void sk_mem_reclaim_partial(struct sock *sk)
 {
+	int reclaimable;
+
 	if (!sk_has_account(sk))
 		return;
-	if (sk->sk_forward_alloc > SK_MEM_QUANTUM)
-		__sk_mem_reclaim(sk, sk->sk_forward_alloc - 1);
+
+	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
+
+	if (reclaimable > SK_MEM_QUANTUM)
+		__sk_mem_reclaim(sk, reclaimable - 1);
 }
 
 static inline void sk_mem_charge(struct sock *sk, int size)
@@ -1536,9 +1566,12 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
+	int reclaimable;
+
 	if (!sk_has_account(sk))
 		return;
 	sk->sk_forward_alloc += size;
+	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
 
 	/* Avoid a possible overflow.
 	 * TCP send queues can make this happen, if sk_mem_reclaim()
@@ -1547,7 +1580,7 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 	 * If we reach 2 MBytes, reclaim 1 MBytes right now, there is
 	 * no need to hold that much forward allocation anyway.
 	 */
-	if (unlikely(sk->sk_forward_alloc >= 1 << 21))
+	if (unlikely(reclaimable >= 1 << 21))
 		__sk_mem_reclaim(sk, 1 << 20);
 }
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 1f0a2b4864e4..c77a1313b3b0 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -126,6 +126,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_RESERVE_MEM		73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 512e629f9780..0ecb8590e043 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -947,6 +947,53 @@ void sock_set_mark(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(sock_set_mark);
 
+static void sock_release_reserved_memory(struct sock *sk, int bytes)
+{
+	/* Round down bytes to multiple of pages */
+	bytes &= ~(SK_MEM_QUANTUM - 1);
+
+	WARN_ON(bytes > sk->sk_reserved_mem);
+	sk->sk_reserved_mem -= bytes;
+	sk_mem_reclaim(sk);
+}
+
+static int sock_reserve_memory(struct sock *sk, int bytes)
+{
+	long allocated;
+	bool charged;
+	int pages;
+
+	if (!mem_cgroup_sockets_enabled || !sk->sk_memcg)
+		return -EOPNOTSUPP;
+
+	if (!bytes)
+		return 0;
+
+	pages = sk_mem_pages(bytes);
+
+	/* pre-charge to memcg */
+	charged = mem_cgroup_charge_skmem(sk->sk_memcg, pages,
+					  GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	if (!charged)
+		return -ENOMEM;
+
+	/* pre-charge to forward_alloc */
+	allocated = sk_memory_allocated_add(sk, pages);
+	/* If the system goes into memory pressure with this
+	 * precharge, give up and return error.
+	 */
+	if (allocated > sk_prot_mem_limits(sk, 1)) {
+		sk_memory_allocated_sub(sk, pages);
+		mem_cgroup_uncharge_skmem(sk->sk_memcg, pages);
+		return -ENOMEM;
+	}
+	sk->sk_forward_alloc += pages << SK_MEM_QUANTUM_SHIFT;
+
+	sk->sk_reserved_mem += pages << SK_MEM_QUANTUM_SHIFT;
+
+	return 0;
+}
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -1367,6 +1414,23 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 					  ~SOCK_BUF_LOCK_MASK);
 		break;
 
+	case SO_RESERVE_MEM:
+	{
+		int delta;
+
+		if (val < 0) {
+			ret = -EINVAL;
+			break;
+		}
+
+		delta = val - sk->sk_reserved_mem;
+		if (delta < 0)
+			sock_release_reserved_memory(sk, -delta);
+		else
+			ret = sock_reserve_memory(sk, delta);
+		break;
+	}
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1733,6 +1797,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
 		break;
 
+	case SO_RESERVE_MEM:
+		v.val = sk->sk_reserved_mem;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
@@ -2045,6 +2113,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_dst_pending_confirm = 0;
 	newsk->sk_wmem_queued	= 0;
 	newsk->sk_forward_alloc = 0;
+	newsk->sk_reserved_mem  = 0;
 	atomic_set(&newsk->sk_drops, 0);
 	newsk->sk_send_head	= NULL;
 	newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
diff --git a/net/core/stream.c b/net/core/stream.c
index 4f1d4aa5fb38..e09ffd410685 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -202,7 +202,7 @@ void sk_stream_kill_queues(struct sock *sk)
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
 
 	/* Account for returned memory. */
-	sk_mem_reclaim(sk);
+	sk_mem_reclaim_final(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
 	WARN_ON(sk->sk_forward_alloc);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 40558033f857..2fc6074583a4 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -135,7 +135,7 @@ void inet_sock_destruct(struct sock *sk)
 	__skb_queue_purge(&sk->sk_receive_queue);
 	__skb_queue_purge(&sk->sk_error_queue);
 
-	sk_mem_reclaim(sk);
+	sk_mem_reclaim_final(sk);
 
 	if (sk->sk_type == SOCK_STREAM && sk->sk_state != TCP_CLOSE) {
 		pr_err("Attempt to release TCP socket in state %d %p\n",
-- 
2.33.0.685.g46640cef36-goog

