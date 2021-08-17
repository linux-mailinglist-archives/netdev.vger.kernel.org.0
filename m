Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18D13EF2BD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhHQTkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhHQTkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 15:40:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A32C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 12:40:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o3-20020a2541030000b0290557cf3415f8so276005yba.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 12:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Zhmz4tSi4Rbh2SiW1zcs8JSYVEpkkiLZgOLqRwEHjaU=;
        b=fbexivHCjvntQgkjo3I+gEVgsP4V9hqh6tDCH83I0jXI1pcqmMZlp/LyD9rLT4X7cg
         via0sfB3W+qysZ4h+voLgsl9vzTNGHXf4DWk/StmX65YobTQbDo8uN4xar8WA11xbz+W
         05gI76lN3+KuCLWiTU1LOtl/mM+kJ39pia0WIy/6oTgLMuvAdgeQy4xxz/Z4/b6q3czq
         Pyaod5Bz7PJpvnHGOcCPVZH+FZOfR8Pn3f2GDGq2bjxnW0LnK9dpZKL6mYRixxjzCzZJ
         D4C6xl6IQrgBLWvU2s6GzY+DFuThP/K8CZ0NBsAAKvlM40xdaqL2vS8yb9AiEKMRx5r8
         +1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Zhmz4tSi4Rbh2SiW1zcs8JSYVEpkkiLZgOLqRwEHjaU=;
        b=fEEcHMH6W3uV/O4u/SVshl7Cw5qyakHEouH5t7NSsAszNdJ8DfB45Hkt+76O2dNvvS
         ytuVtIM81YC5ybSXraVR0y0E4paQHMp1smxWK1VbD4I02VvdYJOn2qBzyCo79j5uQcha
         IqC6x34xPglEU+sjEoRI8q8pnOdzO2zbWk1gLIph2cYjK8ueqXNdIl/SXbpwtUU1xCPh
         SHPThA60OlaqpCXS4wckKS9fOboVCyVN00QfZeeDCf1hvTWU1GWbcjulFQHRqY5TKU2j
         g/Cho6OsUff2+fW0P1KAcPa0YY4rn9NUex2of9U5oBgDFTwIZ3vS3yybPuTyKrZqgBsC
         n7Ag==
X-Gm-Message-State: AOAM531M38QKij0Kg9k9mbtv2X4Rpxe6TrXef130EZUlVFwXFjA+bugE
        9ERhhMw/TPBgnhk7hTXjerkonjW+bpwwstkf9+gpgHw43EHL+TOKN9Tg1HBclSgTs6vWbq2Baf7
        wbYybSYNOksLUvQIZS8bAd5oSkMroRDwlIwTDZIOQWH7VhWs40BM8GQOlNMoWQA==
X-Google-Smtp-Source: ABdhPJzbIZL390hrvi8eavJF1sdqv/zqhJbfwZzHdC1o04WbVIqWvEX0yP6xtZUlb7MTycbQGwseSBQ5Bow=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:7b40:a358:5395:95a8])
 (user=weiwan job=sendgmr) by 2002:a25:7354:: with SMTP id o81mr6239011ybc.195.1629229206243;
 Tue, 17 Aug 2021 12:40:06 -0700 (PDT)
Date:   Tue, 17 Aug 2021 12:40:03 -0700
Message-Id: <20210817194003.2102381-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
From:   Wei Wang <weiwan@google.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Roman Gushchin <guro@fb.com>, Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
to give more control to the networking stack and enable it to change
memcg charging behavior. In the future, the networking stack may decide
to avoid oom-kills when fallbacks are more appropriate.

One behavior change in mem_cgroup_charge_skmem() by this patch is to
avoid force charging by default and let the caller decide when and if
force charging is needed through the presence or absence of
__GFP_NOFAIL.

Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/memcontrol.h      |  3 ++-
 include/net/sock.h              |  5 +++++
 mm/memcontrol.c                 | 24 +++++++++++-------------
 net/core/sock.c                 | 16 ++++++++++++----
 net/ipv4/inet_connection_sock.c |  3 ++-
 net/ipv4/tcp_output.c           |  3 ++-
 6 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bfe5c486f4ad..f0ee30881ca9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1581,7 +1581,8 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
+bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			     gfp_t gfp_mask);
 void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
diff --git a/include/net/sock.h b/include/net/sock.h
index 6e761451c927..95b25777b53e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2400,6 +2400,11 @@ static inline gfp_t gfp_any(void)
 	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
+static inline gfp_t gfp_memcg_charge(void)
+{
+	return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
+}
+
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
 {
 	return noblock ? 0 : sk->sk_rcvtimeo;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8ef06f9e0db1..be585ceaba98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7048,14 +7048,14 @@ void mem_cgroup_sk_free(struct sock *sk)
  * mem_cgroup_charge_skmem - charge socket memory
  * @memcg: memcg to charge
  * @nr_pages: number of pages to charge
+ * @gfp_mask: reclaim mode
  *
  * Charges @nr_pages to @memcg. Returns %true if the charge fit within
- * @memcg's configured limit, %false if the charge had to be forced.
+ * @memcg's configured limit, %false if it doesn't.
  */
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
+			     gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = GFP_KERNEL;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *fail;
 
@@ -7063,21 +7063,19 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 			memcg->tcpmem_pressure = 0;
 			return true;
 		}
-		page_counter_charge(&memcg->tcpmem, nr_pages);
 		memcg->tcpmem_pressure = 1;
+		if (gfp_mask & __GFP_NOFAIL) {
+			page_counter_charge(&memcg->tcpmem, nr_pages);
+			return true;
+		}
 		return false;
 	}
 
-	/* Don't block in the packet receive path */
-	if (in_softirq())
-		gfp_mask = GFP_NOWAIT;
-
-	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
-
-	if (try_charge(memcg, gfp_mask, nr_pages) == 0)
+	if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
+		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
+	}
 
-	try_charge(memcg, gfp_mask|__GFP_NOFAIL, nr_pages);
 	return false;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index aada649e07e8..950f1e70dbf5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2728,10 +2728,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	struct proto *prot = sk->sk_prot;
 	long allocated = sk_memory_allocated_add(sk, amt);
+	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
 	bool charged = true;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
+	if (memcg_charge &&
+	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+						gfp_memcg_charge())))
 		goto suppress_allocation;
 
 	/* Under limit. */
@@ -2785,8 +2787,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		/* Fail only if socket is _under_ its sndbuf.
 		 * In this case we cannot block, so that we have to fail.
 		 */
-		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf)
+		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf) {
+			/* Force charge with __GFP_NOFAIL */
+			if (memcg_charge && !charged) {
+				mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+					gfp_memcg_charge() | __GFP_NOFAIL);
+			}
 			return 1;
+		}
 	}
 
 	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
@@ -2794,7 +2802,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (memcg_charge && charged)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amt);
 
 	return 0;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 754013fa393b..f25d02ad4a8a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -534,7 +534,8 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 				   atomic_read(&newsk->sk_rmem_alloc));
 		mem_cgroup_sk_alloc(newsk);
 		if (newsk->sk_memcg && amt)
-			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
+			mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
+						GFP_KERNEL | __GFP_NOFAIL);
 
 		release_sock(newsk);
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 29553fce8502..6d72f3ea48c4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3373,7 +3373,8 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
-		mem_cgroup_charge_skmem(sk->sk_memcg, amt);
+		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+					gfp_memcg_charge() | __GFP_NOFAIL);
 }
 
 /* Send a FIN. The caller locks the socket for us.
-- 
2.33.0.rc1.237.g0d66db33f3-goog

