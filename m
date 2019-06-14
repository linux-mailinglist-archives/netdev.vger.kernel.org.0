Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81DAF46CCD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfFNXWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:38 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:43685 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNXWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:38 -0400
Received: by mail-pf1-f201.google.com with SMTP id j7so2783428pfn.10
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O0DjybUunHOj9t2UEUrYQgLa63XXSt0XDtG7sCo6WeU=;
        b=c2m//nQlmyIncskpDoEZl67brXon8xY3vs4tZcsN9gS4zaw25NByoj6TxHnNM2Gl2Y
         Hj73BVZvbFt7lIFXvj5xEzqZ/FOAi6tIT0fshKYwHzgExbmCLgf+OQDRf78jzhVv0JtI
         0HHK+8aKn5BJxZ94k2uaiKI3EueILgJrO8lGPSpasoj+fe9mYExBluKZ1+U5SGVWVM3y
         uFNoTQKxrJm10z276iBur+z41XgtpRxy3Dj8LDw8ASF10p4SVrD6aKnU2TPBMLXtz7fD
         i9preQmmfYS0VFVUbGA4V8f6UUaTof0OwP77GEuOCD77GzyIhFNaHSLJvwMoBQqeHtho
         iQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O0DjybUunHOj9t2UEUrYQgLa63XXSt0XDtG7sCo6WeU=;
        b=goaUp1Wrl6orQtqxi6BvVS7mghfpTCPzJtVPyTKd6ZsCa6xiJ2/GLiHOqt3jVuVXR/
         u/V0pVnQekdEKsOsDVg/dPvbt+GP3EqLMoIr4Fgrnp0xi64NH6w9l9Tng0OuhnbRabFm
         Wb9NHnsIXbQO66MrPOY/CScfP92NbL5YnouGmeJln/7o4lr3UWwNeWF1wO6k2AQ0KxxR
         ZvpUm3Vu2tDXU3waRO7q566hn6CkQtuAlA8sbV4vJZAUc7x0ZzCJFkYd7C8JhM4LKuSe
         TLFYZycCJIdmcJcs+sIdDbKb8pU3F46WKjN08GhLBbXO7sTGZkwBi1/4jaLjBKfim21L
         xNbg==
X-Gm-Message-State: APjAAAW5nwSZVKMQuKZOl/BLnFceNbIgy6ziUDKKLpFXkG6M/IyFHIRH
        55VkP0uAkE1ySfbBXzbrnpTFHHig/e4zNQ==
X-Google-Smtp-Source: APXvYqzTbAhEu2D1xd9lQt++kIwBergkvtZuIqoWhaaTqITOcWDuw7aXZ6qxcf+1zgzqdVAOemGtxAN2igQxwg==
X-Received: by 2002:a63:8dc4:: with SMTP id z187mr38394459pgd.337.1560554556640;
 Fri, 14 Jun 2019 16:22:36 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:22:20 -0700
In-Reply-To: <20190614232221.248392-1-edumazet@google.com>
Message-Id: <20190614232221.248392-4-edumazet@google.com>
Mime-Version: 1.0
References: <20190614232221.248392-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 3/4] tcp: add tcp_tx_skb_cache sysctl
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Feng Tang reported a performance regression after introduction
of per TCP socket tx/rx caches, for TCP over loopback (netperf)

There is high chance the regression is caused by a change on
how well the 32 KB per-thread page (current->task_frag) can
be recycled, and lack of pcp caches for order-3 pages.

I could not reproduce the regression myself, cpus all being
spinning on the mm spinlocks for page allocs/freeing, regardless
of enabling or disabling the per tcp socket caches.

It seems best to disable the feature by default, and let
admins enabling it.

MM layer either needs to provide scalable order-3 pages
allocations, or could attempt a trylock on zone->lock if
the caller only attempts to get a high-order page and is
able to fallback to order-0 ones in case of pressure.

Tests run on a 56 cores host (112 hyper threads)

-	35.49%	netperf 		 [kernel.vmlinux]	  [k] queued_spin_lock_slowpath
   - 35.49% queued_spin_lock_slowpath
	  - 18.18% get_page_from_freelist
		 - __alloc_pages_nodemask
			- 18.18% alloc_pages_current
				 skb_page_frag_refill
				 sk_page_frag_refill
				 tcp_sendmsg_locked
				 tcp_sendmsg
				 inet_sendmsg
				 sock_sendmsg
				 __sys_sendto
				 __x64_sys_sendto
				 do_syscall_64
				 entry_SYSCALL_64_after_hwframe
				 __libc_send
	  + 17.31% __free_pages_ok
+	31.43%	swapper 		 [kernel.vmlinux]	  [k] intel_idle
+	 9.12%	netperf 		 [kernel.vmlinux]	  [k] copy_user_enhanced_fast_string
+	 6.53%	netserver		 [kernel.vmlinux]	  [k] copy_user_enhanced_fast_string
+	 0.69%	netserver		 [kernel.vmlinux]	  [k] queued_spin_lock_slowpath
+	 0.68%	netperf 		 [kernel.vmlinux]	  [k] skb_release_data
+	 0.52%	netperf 		 [kernel.vmlinux]	  [k] tcp_sendmsg_locked
	 0.46%	netperf 		 [kernel.vmlinux]	  [k] _raw_spin_lock_irqsave

Fixes: 472c2e07eef0 ("tcp: add one skb cache for tx")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Feng Tang <feng.tang@intel.com>
---
 include/net/sock.h         | 4 +++-
 net/ipv4/sysctl_net_ipv4.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b02645e2dfad722769c1455bcde76e46da9fc5ac..7d7f4ce63bb2aae7c87a9445d11339b6e6b19724 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1463,12 +1463,14 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 		__sk_mem_reclaim(sk, 1 << 20);
 }
 
+DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	sk->sk_wmem_queued -= skb->truesize;
 	sk_mem_uncharge(sk, skb->truesize);
-	if (!sk->sk_tx_skb_cache && !skb_cloned(skb)) {
+	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
+	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
 		skb_zcopy_clear(skb, true);
 		sk->sk_tx_skb_cache = skb;
 		return;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 886b58d31351df44725bdc34081e798bcb89ecf0..08a428a7b2749c4f2a03aa6352e44c053596ef75 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -54,6 +54,8 @@ static int one_day_secs = 24 * 3600;
 DEFINE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 EXPORT_SYMBOL(tcp_rx_skb_cache_key);
 
+DEFINE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
+
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
 
@@ -568,6 +570,12 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_static_key,
 	},
+	{
+		.procname	= "tcp_tx_skb_cache",
+		.data		= &tcp_tx_skb_cache_key.key,
+		.mode		= 0644,
+		.proc_handler	= proc_do_static_key,
+	},
 	{ }
 };
 
-- 
2.22.0.410.gd8fdbe21b5-goog

