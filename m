Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB06B52F9D2
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354777AbiEUHpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354778AbiEUHpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6E57185431
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653119135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9/cPJX43GileJuor9/D/okxrgKUclDLl9Ubycp4TMs=;
        b=H1BPa2TW4lO+4SSskWQYjSNZUpOHE9ur+ZFbdecGX1oFyZwWc1cwVcY1pKRFifzxslHZt/
        mWOp6OmPAbG4fZ9LJN4YBCkbBYLioMYQA45OxqVHH0dR4v1gIgT9H4MdSq3vtrMknBvdSk
        jn3xO+wFoIgZYwCwrf++NB+GlMQg9wc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-MmwmN6LfPmqOn6aPSuxepQ-1; Sat, 21 May 2022 03:45:30 -0400
X-MC-Unique: MmwmN6LfPmqOn6aPSuxepQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4217138035A0;
        Sat, 21 May 2022 07:45:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 891C6492C14;
        Sat, 21 May 2022 07:45:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 3/7] rxrpc: Fix locking issue
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 21 May 2022 08:45:28 +0100
Message-ID: <165311912886.245906.15826699370961509183.stgit@warthog.procyon.org.uk>
In-Reply-To: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
References: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a locking issue with the per-netns list of calls in rxrpc.  The
pieces of code that add and remove a call from the list use write_lock()
and the calls procfile uses read_lock() to access it.  However, the timer
callback function may trigger a removal by trying to queue a call for
processing and finding that it's already queued - at which point it has a
spare refcount that it has to do something with.  Unfortunately, if it puts
the call and this reduces the refcount to 0, the call will be removed from
the list.  Unfortunately, since the _bh variants of the locking functions
aren't used, this can deadlock.

================================
WARNING: inconsistent lock state
5.18.0-rc3-build4+ #10 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
ksoftirqd/2/25 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888107ac4038 (&rxnet->call_lock){+.?.}-{2:2}, at: rxrpc_put_call+0x103/0x14b
{SOFTIRQ-ON-W} state was registered at:
...
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rxnet->call_lock);
  <Interrupt>
    lock(&rxnet->call_lock);

 *** DEADLOCK ***

1 lock held by ksoftirqd/2/25:
 #0: ffff8881008ffdb0 ((&call->timer)){+.-.}-{0:0}, at: call_timer_fn+0x5/0x23d

Changes
=======
ver #2)
 - Changed to using list_next_rcu() rather than rcu_dereference() directly.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 fs/seq_file.c            |   32 ++++++++++++++++++++++++++++++++
 include/linux/list.h     |   10 ++++++++++
 include/linux/seq_file.h |    4 ++++
 net/rxrpc/ar-internal.h  |    2 +-
 net/rxrpc/call_accept.c  |    6 +++---
 net/rxrpc/call_object.c  |   18 +++++++++---------
 net/rxrpc/net_ns.c       |    2 +-
 net/rxrpc/proc.c         |   10 ++--------
 8 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 7ab8a58c29b6..9456a2032224 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -931,6 +931,38 @@ struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
 }
 EXPORT_SYMBOL(seq_list_next);
 
+struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	list_for_each_rcu(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+EXPORT_SYMBOL(seq_list_start_rcu);
+
+struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start_rcu(head, pos - 1);
+}
+EXPORT_SYMBOL(seq_list_start_head_rcu);
+
+struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
+				    loff_t *ppos)
+{
+	struct list_head *lh;
+
+	lh = list_next_rcu((struct list_head *)v);
+	++*ppos;
+	return lh == head ? NULL : lh;
+}
+EXPORT_SYMBOL(seq_list_next_rcu);
+
 /**
  * seq_hlist_start - start an iteration of a hlist
  * @head: the head of the hlist
diff --git a/include/linux/list.h b/include/linux/list.h
index c147eeb2d39d..57e8b559cdf6 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -605,6 +605,16 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each(pos, head) \
 	for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
 
+/**
+ * list_for_each_rcu - Iterate over a list in an RCU-safe fashion
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ */
+#define list_for_each_rcu(pos, head)		  \
+	for (pos = rcu_dereference((head)->next); \
+	     !list_is_head(pos, (head)); \
+	     pos = rcu_dereference(pos->next))
+
 /**
  * list_for_each_continue - continue iteration over a list
  * @pos:	the &struct list_head to use as a loop cursor.
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 60820ab511d2..bd023dd38ae6 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -277,6 +277,10 @@ extern struct list_head *seq_list_start_head(struct list_head *head,
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+extern struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos);
+extern struct list_head *seq_list_next_rcu(void *v, struct list_head *head, loff_t *ppos);
+
 /*
  * Helpers for iteration over hlist_head-s in seq_files
  */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 52a23d03d694..dcc0ec0bf3de 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -60,7 +60,7 @@ struct rxrpc_net {
 	struct proc_dir_entry	*proc_net;	/* Subdir in /proc/net */
 	u32			epoch;		/* Local epoch for detecting local-end reset */
 	struct list_head	calls;		/* List of calls active in this namespace */
-	rwlock_t		call_lock;	/* Lock for ->calls */
+	spinlock_t		call_lock;	/* Lock for ->calls */
 	atomic_t		nr_calls;	/* Count of allocated calls */
 
 	atomic_t		nr_conns;
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8ae59edc2551..99e10eea3732 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -140,9 +140,9 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	b->call_backlog[call_head] = call;
 	smp_store_release(&b->call_backlog_head, (call_head + 1) & (size - 1));
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 8764a4f19c03..84d0a4109645 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -337,9 +337,9 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	write_unlock(&rx->call_lock);
 
 	rxnet = call->rxnet;
-	write_lock(&rxnet->call_lock);
-	list_add_tail(&call->link, &rxnet->calls);
-	write_unlock(&rxnet->call_lock);
+	spin_lock_bh(&rxnet->call_lock);
+	list_add_tail_rcu(&call->link, &rxnet->calls);
+	spin_unlock_bh(&rxnet->call_lock);
 
 	/* From this point on, the call is protected by its own lock. */
 	release_sock(&rx->sk);
@@ -633,9 +633,9 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 			list_del_init(&call->link);
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 		}
 
 		rxrpc_cleanup_call(call);
@@ -707,7 +707,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 	_enter("");
 
 	if (!list_empty(&rxnet->calls)) {
-		write_lock(&rxnet->call_lock);
+		spin_lock_bh(&rxnet->call_lock);
 
 		while (!list_empty(&rxnet->calls)) {
 			call = list_entry(rxnet->calls.next,
@@ -722,12 +722,12 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 			       rxrpc_call_states[call->state],
 			       call->flags, call->events);
 
-			write_unlock(&rxnet->call_lock);
+			spin_unlock_bh(&rxnet->call_lock);
 			cond_resched();
-			write_lock(&rxnet->call_lock);
+			spin_lock_bh(&rxnet->call_lock);
 		}
 
-		write_unlock(&rxnet->call_lock);
+		spin_unlock_bh(&rxnet->call_lock);
 	}
 
 	atomic_dec(&rxnet->nr_calls);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 34f389975a7d..bb4c25d6df64 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -50,7 +50,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	rxnet->epoch |= RXRPC_RANDOM_EPOCH;
 
 	INIT_LIST_HEAD(&rxnet->calls);
-	rwlock_init(&rxnet->call_lock);
+	spin_lock_init(&rxnet->call_lock);
 	atomic_set(&rxnet->nr_calls, 1);
 
 	atomic_set(&rxnet->nr_conns, 1);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 8967201fd8e5..245418943e01 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -26,29 +26,23 @@ static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
  */
 static void *rxrpc_call_seq_start(struct seq_file *seq, loff_t *_pos)
 	__acquires(rcu)
-	__acquires(rxnet->call_lock)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
 	rcu_read_lock();
-	read_lock(&rxnet->call_lock);
-	return seq_list_start_head(&rxnet->calls, *_pos);
+	return seq_list_start_head_rcu(&rxnet->calls, *_pos);
 }
 
 static void *rxrpc_call_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 
-	return seq_list_next(v, &rxnet->calls, pos);
+	return seq_list_next_rcu(v, &rxnet->calls, pos);
 }
 
 static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
-	__releases(rxnet->call_lock)
 	__releases(rcu)
 {
-	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
-
-	read_unlock(&rxnet->call_lock);
 	rcu_read_unlock();
 }
 


