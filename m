Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4CF50C1D5
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 00:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiDVWF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiDVWFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:05:35 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201321F47A6
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:49:02 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-e67799d278so6032722fac.11
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MottAINveZ7gBjrASZW9+blyJYQxWbQ586QR8g/aZnU=;
        b=oh19L9xId/pgJW4uFwrBvAOllnzEXfQnhXjBhDH3azSk7R+TJvyJwi4en2R0gAVybE
         RJbM5pVJy/lD6G2xu4hqIJjAfPsrzRmjtxH9v3BtislhQcbytZhsct8DKTo15NIvyWOo
         gTx/lLmAjCSq0/K9Gk1vBS2PlN3gnUyJgIDHS8zRo8BzSWev29+9SQCbTNdRIlNhXAJh
         MDJq7KBCyZQbEHZpEtsQ5oUMigTbzPMr1HkUb8dhtsjIQDoqLZ5hmJlYXIx8U5rKY4QN
         zZOkQZrRYebqzTJ4l5jDzKIGR+rQWzSD/e4jKLrCkpvSB+CpqYl5FYH4M1bwwYxutfL3
         EhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MottAINveZ7gBjrASZW9+blyJYQxWbQ586QR8g/aZnU=;
        b=PYRR/PhzBGrrw2nP4Hz787owTZ6fHKb3z5Z6jKpGvt20iQUwNU100CObUMc1gAg6fE
         IvPmiOa8Tefqb5G24MAnL1dlSL06Y6ND02sLfIXlR925YPSYoYV9Y+gCX7Sncn4ETskO
         dlmGZgUPI3KNq3PFnuStzocv9leB93vMfpHQ8sznDXEOHGdazHxkLlVrocqFutnL30+s
         ocXKgI5AJTdAsJkXeWrAaTB10gDYKaurlS83yOY2iIjw6tHUau3y9x9EcxNpRQ5hVIsu
         WDkEDZFsQhJBDdBU5jltkMzqGeBg7/DJzhepmN94R7tcB+DGbq9Vt9/8m2bda7gDpfOq
         SyRQ==
X-Gm-Message-State: AOAM532JckGnB79VsByr62/RokXQ0LtnE8NxowMymQ8PAmMjX0QCKl+U
        +MGHYhG5hW+OSNb8/6MGEjDOrSyvc9U=
X-Google-Smtp-Source: ABdhPJyyuR2RuSC5GsRfwrUV5FdfPJlYV5cmlml3qE8YYUaBxkj6KzBdDjKL1z26RwWbsXrCah8A1g==
X-Received: by 2002:a17:90b:1e4d:b0:1d2:a91e:24cc with SMTP id pi13-20020a17090b1e4d00b001d2a91e24ccmr7255051pjb.99.1650658361638;
        Fri, 22 Apr 2022 13:12:41 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5dfd:d2c2:9be4:8d3])
        by smtp.gmail.com with ESMTPSA id l4-20020a056a0016c400b004f79504ef9csm3630686pfc.3.2022.04.22.13.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 13:12:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] net: generalize skb freeing deferral to per-cpu lists
Date:   Fri, 22 Apr 2022 13:12:37 -0700
Message-Id: <20220422201237.416238-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Logic added in commit f35f821935d8 ("tcp: defer skb freeing after socket
lock is released") helped bulk TCP flows to move the cost of skbs
frees outside of critical section where socket lock was held.

But for RPC traffic, or hosts with RFS enabled, the solution is far from
being ideal.

For RPC traffic, recvmsg() has to return to user space right after
skb payload has been consumed, meaning that BH handler has no chance
to pick the skb before recvmsg() thread. This issue is more visible
with BIG TCP, as more RPC fit one skb.

For RFS, even if BH handler picks the skbs, they are still picked
from the cpu on which user thread is running.

Ideally, it is better to free the skbs (and associated page frags)
on the cpu that originally allocated them.

This patch removes the per socket anchor (sk->defer_list) and
instead uses a per-cpu list, which will hold more skbs per round.

This new per-cpu list is drained at the end of net_action_rx(),
after incoming packets have been processed, to lower latencies.

In normal conditions, skbs are added to the per-cpu list with
no further action. In the (unlikely) cases where the cpu does not
run net_action_rx() handler fast enough, we use an IPI to raise
NET_RX_SOFTIRQ on the remote cpu.

Also, we do not bother draining the per-cpu list from dev_cpu_dead()
This is because skbs in this list have no requirement on how fast
they should be freed.

Note that we can add in the future a small per-cpu cache
if we see any contention on sd->defer_lock.

Tested on a pair of hosts with 100Gbit NIC, RFS enabled,
and /proc/sys/net/ipv4/tcp_rmem[2] tuned to 16MB to work around
page recycling strategy used by NIC driver (its page pool capacity
being too small compared to number of skbs/pages held in sockets
receive queues)

Note that this tuning was only done to demonstrate worse
conditions for skb freeing for this particular test.
These conditions can happen in more general production workload.

10 runs of one TCP_STREAM flow

Before:
Average throughput: 49685 Mbit.

Kernel profiles on cpu running user thread recvmsg() show high cost for
skb freeing related functions (*)

    57.81%  [kernel]       [k] copy_user_enhanced_fast_string
(*) 12.87%  [kernel]       [k] skb_release_data
(*)  4.25%  [kernel]       [k] __free_one_page
(*)  3.57%  [kernel]       [k] __list_del_entry_valid
     1.85%  [kernel]       [k] __netif_receive_skb_core
     1.60%  [kernel]       [k] __skb_datagram_iter
(*)  1.59%  [kernel]       [k] free_unref_page_commit
(*)  1.16%  [kernel]       [k] __slab_free
     1.16%  [kernel]       [k] _copy_to_iter
(*)  1.01%  [kernel]       [k] kfree
(*)  0.88%  [kernel]       [k] free_unref_page
     0.57%  [kernel]       [k] ip6_rcv_core
     0.55%  [kernel]       [k] ip6t_do_table
     0.54%  [kernel]       [k] flush_smp_call_function_queue
(*)  0.54%  [kernel]       [k] free_pcppages_bulk
     0.51%  [kernel]       [k] llist_reverse_order
     0.38%  [kernel]       [k] process_backlog
(*)  0.38%  [kernel]       [k] free_pcp_prepare
     0.37%  [kernel]       [k] tcp_recvmsg_locked
(*)  0.37%  [kernel]       [k] __list_add_valid
     0.34%  [kernel]       [k] sock_rfree
     0.34%  [kernel]       [k] _raw_spin_lock_irq
(*)  0.33%  [kernel]       [k] __page_cache_release
     0.33%  [kernel]       [k] tcp_v6_rcv
(*)  0.33%  [kernel]       [k] __put_page
(*)  0.29%  [kernel]       [k] __mod_zone_page_state
     0.27%  [kernel]       [k] _raw_spin_lock

After patch:
Average throughput: 73076 Mbit.

Kernel profiles on cpu running user thread recvmsg() looks better:

    81.35%  [kernel]       [k] copy_user_enhanced_fast_string
     1.95%  [kernel]       [k] _copy_to_iter
     1.95%  [kernel]       [k] __skb_datagram_iter
     1.27%  [kernel]       [k] __netif_receive_skb_core
     1.03%  [kernel]       [k] ip6t_do_table
     0.60%  [kernel]       [k] sock_rfree
     0.50%  [kernel]       [k] tcp_v6_rcv
     0.47%  [kernel]       [k] ip6_rcv_core
     0.45%  [kernel]       [k] read_tsc
     0.44%  [kernel]       [k] _raw_spin_lock_irqsave
     0.37%  [kernel]       [k] _raw_spin_lock
     0.37%  [kernel]       [k] native_irq_return_iret
     0.33%  [kernel]       [k] __inet6_lookup_established
     0.31%  [kernel]       [k] ip6_protocol_deliver_rcu
     0.29%  [kernel]       [k] tcp_rcv_established
     0.29%  [kernel]       [k] llist_reverse_order

v2: kdoc issue (kernel bots)
    do not defer if (alloc_cpu == smp_processor_id()) (Paolo)
    replace the sk_buff_head with a single-linked list (Jakub)
    add a READ_ONCE()/WRITE_ONCE() for the lockless read of sd->defer_list

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  5 ++++
 include/linux/skbuff.h    |  3 +++
 include/net/sock.h        |  2 --
 include/net/tcp.h         | 12 ---------
 net/core/dev.c            | 31 ++++++++++++++++++++++++
 net/core/skbuff.c         | 51 ++++++++++++++++++++++++++++++++++++++-
 net/core/sock.c           |  3 ---
 net/ipv4/tcp.c            | 25 +------------------
 net/ipv4/tcp_ipv4.c       |  1 -
 net/ipv6/tcp_ipv6.c       |  1 -
 net/tls/tls_sw.c          |  2 --
 11 files changed, 90 insertions(+), 46 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7dccbfd1bf5635c27514c70b4a06d3e6f74395dd..ac8a5f71220a999aebabd73d8df2c8e2b1325ad4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3081,6 +3081,11 @@ struct softnet_data {
 	struct sk_buff_head	input_pkt_queue;
 	struct napi_struct	backlog;
 
+	/* Another possibly contended cache line */
+	spinlock_t		defer_lock ____cacheline_aligned_in_smp;
+	int			defer_count;
+	struct sk_buff		*defer_list;
+	call_single_data_t	defer_csd;
 };
 
 static inline void input_queue_head_incr(struct softnet_data *sd)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 84d78df60453955a8eaf05847f6e2145176a727a..5cbc184ca685d886306ccff70b82cd409082c229 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -888,6 +888,7 @@ typedef unsigned char *sk_buff_data_t;
  *		delivery_time at egress.
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
+ *	@alloc_cpu: CPU which did the skb allocation.
  *	@secmark: security marking
  *	@mark: Generic packet mark
  *	@reserved_tailroom: (aka @mark) number of bytes of free space available
@@ -1080,6 +1081,7 @@ struct sk_buff {
 		unsigned int	sender_cpu;
 	};
 #endif
+	u16			alloc_cpu;
 #ifdef CONFIG_NETWORK_SECMARK
 	__u32		secmark;
 #endif
@@ -1321,6 +1323,7 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size);
 struct sk_buff *build_skb(void *data, unsigned int frag_size);
 struct sk_buff *build_skb_around(struct sk_buff *skb,
 				 void *data, unsigned int frag_size);
+void skb_attempt_defer_free(struct sk_buff *skb);
 
 struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
 
diff --git a/include/net/sock.h b/include/net/sock.h
index a01d6c421aa2caad4032167284eed9565d4bd545..f9f8ecae0f8decb3e0e74c6efaff5b890e3685ea 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -292,7 +292,6 @@ struct sk_filter;
   *	@sk_pacing_shift: scaling factor for TCP Small Queues
   *	@sk_lingertime: %SO_LINGER l_linger setting
   *	@sk_backlog: always used with the per-socket spinlock held
-  *	@defer_list: head of llist storing skbs to be freed
   *	@sk_callback_lock: used with the callbacks in the end of this struct
   *	@sk_error_queue: rarely used
   *	@sk_prot_creator: sk_prot of original sock creator (see ipv6_setsockopt,
@@ -417,7 +416,6 @@ struct sock {
 		struct sk_buff	*head;
 		struct sk_buff	*tail;
 	} sk_backlog;
-	struct llist_head defer_list;
 
 #define sk_rmem_alloc sk_backlog.rmem_alloc
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 679b1964d49414fcb1c361778fd0ac664e8c8ea5..94a52ad1101c12e13c2957e8b028b697742c451f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1375,18 +1375,6 @@ static inline bool tcp_checksum_complete(struct sk_buff *skb)
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
 		     enum skb_drop_reason *reason);
 
-#ifdef CONFIG_INET
-void __sk_defer_free_flush(struct sock *sk);
-
-static inline void sk_defer_free_flush(struct sock *sk)
-{
-	if (llist_empty(&sk->defer_list))
-		return;
-	__sk_defer_free_flush(sk);
-}
-#else
-static inline void sk_defer_free_flush(struct sock *sk) {}
-#endif
 
 int tcp_filter(struct sock *sk, struct sk_buff *skb);
 void tcp_set_state(struct sock *sk, int state);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4a77ebda4fb155581a5f761a864446a046987f51..611bd719706412723561c27753150b27e1dc4e7a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4545,6 +4545,12 @@ static void rps_trigger_softirq(void *data)
 
 #endif /* CONFIG_RPS */
 
+/* Called from hardirq (IPI) context */
+static void trigger_rx_softirq(void *data __always_unused)
+{
+	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+}
+
 /*
  * Check if this softnet_data structure is another cpu one
  * If yes, queue it to our IPI list and return 1
@@ -6571,6 +6577,28 @@ static int napi_threaded_poll(void *data)
 	return 0;
 }
 
+static void skb_defer_free_flush(struct softnet_data *sd)
+{
+	struct sk_buff *skb, *next;
+	unsigned long flags;
+
+	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
+	if (!READ_ONCE(sd->defer_list))
+		return;
+
+	spin_lock_irqsave(&sd->defer_lock, flags);
+	skb = sd->defer_list;
+	sd->defer_list = NULL;
+	sd->defer_count = 0;
+	spin_unlock_irqrestore(&sd->defer_lock, flags);
+
+	while (skb != NULL) {
+		next = skb->next;
+		__kfree_skb(skb);
+		skb = next;
+	}
+}
+
 static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
@@ -6616,6 +6644,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 
 	net_rps_action_and_irq_enable(sd);
+	skb_defer_free_flush(sd);
 }
 
 struct netdev_adjacent {
@@ -11326,6 +11355,8 @@ static int __init net_dev_init(void)
 		INIT_CSD(&sd->csd, rps_trigger_softirq, sd);
 		sd->cpu = i;
 #endif
+		INIT_CSD(&sd->defer_csd, trigger_rx_softirq, NULL);
+		spin_lock_init(&sd->defer_lock);
 
 		init_gro_hash(&sd->backlog);
 		sd->backlog.poll = process_backlog;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2e9be30bdefdc61f70f989c345bbf..028a280fbabd5b69770ddd6bf0e00eae7651bbf1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -204,7 +204,7 @@ static void __build_skb_around(struct sk_buff *skb, void *data,
 	skb_set_end_offset(skb, size);
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 	skb->transport_header = (typeof(skb->transport_header))~0U;
-
+	skb->alloc_cpu = raw_smp_processor_id();
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
@@ -1037,6 +1037,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	CHECK_SKB_FIELD(napi_id);
 #endif
+	CHECK_SKB_FIELD(alloc_cpu);
 #ifdef CONFIG_XPS
 	CHECK_SKB_FIELD(sender_cpu);
 #endif
@@ -6486,3 +6487,51 @@ void __skb_ext_put(struct skb_ext *ext)
 }
 EXPORT_SYMBOL(__skb_ext_put);
 #endif /* CONFIG_SKB_EXTENSIONS */
+
+/**
+ * skb_attempt_defer_free - queue skb for remote freeing
+ * @skb: buffer
+ *
+ * Put @skb in a per-cpu list, using the cpu which
+ * allocated the skb/pages to reduce false sharing
+ * and memory zone spinlock contention.
+ */
+void skb_attempt_defer_free(struct sk_buff *skb)
+{
+	int cpu = skb->alloc_cpu;
+	struct softnet_data *sd;
+	unsigned long flags;
+	bool kick;
+
+	if (WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
+	    !cpu_online(cpu) ||
+	    cpu == raw_smp_processor_id()) {
+		__kfree_skb(skb);
+		return;
+	}
+
+	sd = &per_cpu(softnet_data, cpu);
+	/* We do not send an IPI or any signal.
+	 * Remote cpu will eventually call skb_defer_free_flush()
+	 */
+	spin_lock_irqsave(&sd->defer_lock, flags);
+	skb->next = sd->defer_list;
+	/* Paired with READ_ONCE() in skb_defer_free_flush() */
+	WRITE_ONCE(sd->defer_list, skb);
+	sd->defer_count++;
+
+	/* kick every time queue length reaches 128.
+	 * This should avoid blocking in smp_call_function_single_async().
+	 * This condition should hardly be bit under normal conditions,
+	 * unless cpu suddenly stopped to receive NIC interrupts.
+	 */
+	kick = sd->defer_count == 128;
+
+	spin_unlock_irqrestore(&sd->defer_lock, flags);
+
+	/* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
+	 * if we are unlucky enough (this seems very unlikely).
+	 */
+	if (unlikely(kick))
+		smp_call_function_single_async(cpu, &sd->defer_csd);
+}
diff --git a/net/core/sock.c b/net/core/sock.c
index 29abec3eabd8905f2671e0b5789878a129453ef6..a0f3989de3d62456665e8b6382a4681fba17d60c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2082,9 +2082,6 @@ void sk_destruct(struct sock *sk)
 {
 	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
 
-	WARN_ON_ONCE(!llist_empty(&sk->defer_list));
-	sk_defer_free_flush(sk);
-
 	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
 		reuseport_detach_sock(sk);
 		use_call_rcu = true;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e20b87b3bf907a9b04b7531936129fb729e96c52..db55af9eb37b56bf0ec3b47212240c0302b86a1f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -843,7 +843,6 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 	}
 
 	release_sock(sk);
-	sk_defer_free_flush(sk);
 
 	if (spliced)
 		return spliced;
@@ -1589,20 +1588,6 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		tcp_send_ack(sk);
 }
 
-void __sk_defer_free_flush(struct sock *sk)
-{
-	struct llist_node *head;
-	struct sk_buff *skb, *n;
-
-	head = llist_del_all(&sk->defer_list);
-	llist_for_each_entry_safe(skb, n, head, ll_node) {
-		prefetch(n);
-		skb_mark_not_on_list(skb);
-		__kfree_skb(skb);
-	}
-}
-EXPORT_SYMBOL(__sk_defer_free_flush);
-
 static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);
@@ -1610,11 +1595,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 		sock_rfree(skb);
 		skb->destructor = NULL;
 		skb->sk = NULL;
-		if (!skb_queue_empty(&sk->sk_receive_queue) ||
-		    !llist_empty(&sk->defer_list)) {
-			llist_add(&skb->ll_node, &sk->defer_list);
-			return;
-		}
+		return skb_attempt_defer_free(skb);
 	}
 	__kfree_skb(skb);
 }
@@ -2453,7 +2434,6 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			__sk_flush_backlog(sk);
 		} else {
 			tcp_cleanup_rbuf(sk, copied);
-			sk_defer_free_flush(sk);
 			sk_wait_data(sk, &timeo, last);
 		}
 
@@ -2571,7 +2551,6 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	lock_sock(sk);
 	ret = tcp_recvmsg_locked(sk, msg, len, flags, &tss, &cmsg_flags);
 	release_sock(sk);
-	sk_defer_free_flush(sk);
 
 	if (cmsg_flags && ret >= 0) {
 		if (cmsg_flags & TCP_CMSG_TS)
@@ -3096,7 +3075,6 @@ int tcp_disconnect(struct sock *sk, int flags)
 		sk->sk_frag.page = NULL;
 		sk->sk_frag.offset = 0;
 	}
-	sk_defer_free_flush(sk);
 	sk_error_report(sk);
 	return 0;
 }
@@ -4225,7 +4203,6 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
 							  &zc, &len, err);
 		release_sock(sk);
-		sk_defer_free_flush(sk);
 		if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
 			goto zerocopy_rcv_cmsg;
 		switch (len) {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2c2d421425557c188c4bcf3dc113baea62e915c7..918816ec5dd49abe321f0179a2a64ca9a989a01c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2065,7 +2065,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	sk_incoming_cpu_update(sk);
 
-	sk_defer_free_flush(sk);
 	bh_lock_sock_nested(sk);
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 54277de7474b78f1fea033b7978acebc0647f3ad..60bdec257ba7220d6c05b48208a587c7be2b4087 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1728,7 +1728,6 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	sk_incoming_cpu_update(sk);
 
-	sk_defer_free_flush(sk);
 	bh_lock_sock_nested(sk);
 	tcp_segs_in(tcp_sk(sk), skb);
 	ret = 0;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ddbe05ec5489dd352dee832e038884339f338b43..bc54f6c5b1a4cabbfe1e3eff1768128b2730c730 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1911,7 +1911,6 @@ int tls_sw_recvmsg(struct sock *sk,
 
 end:
 	release_sock(sk);
-	sk_defer_free_flush(sk);
 	if (psock)
 		sk_psock_put(sk, psock);
 	return copied ? : err;
@@ -1983,7 +1982,6 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 splice_read_end:
 	release_sock(sk);
-	sk_defer_free_flush(sk);
 	return copied ? : err;
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

