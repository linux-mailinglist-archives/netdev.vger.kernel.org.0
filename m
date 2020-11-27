Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3544A2C628B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgK0KKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgK0KKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57THPnnEiX5E0xAZIXHKQyCFoce7d86aO6JQpBGb9ak=;
        b=fFJOoV2Pou2AURw5t8/+DRmkI+ROOzJchc6dVtYS7upwUG41CmXQOKyhTXH5DSUJl9ANzH
        1SmoD0PVIlQzj7D8kNw7DO8MEbFngGqDnyYlgjgJFn5sgixI3XLlS59utSupilXcJqR4ou
        YN5fvyUWu2+Xjen2aRN8o67qkcTwr0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-0LLDbuW_M1S4Y1TYgLTrPA-1; Fri, 27 Nov 2020 05:10:46 -0500
X-MC-Unique: 0LLDbuW_M1S4Y1TYgLTrPA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD579185E4A2;
        Fri, 27 Nov 2020 10:10:44 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6A561000320;
        Fri, 27 Nov 2020 10:10:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 3/6] mptcp: protect the rx path with the msk socket spinlock
Date:   Fri, 27 Nov 2020 11:10:24 +0100
Message-Id: <fec6667a994d79f2511619dd034b85d425e1e2dc.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Such spinlock is currently used only to protect the 'owned'
flag inside the socket lock itself. With this patch, we extend
its scope to protect the whole msk receive path and
sk_forward_memory.

Given the above, we can always move data into the msk receive
queue (and OoO queue) from the subflow.

We leverage the previous commit, so that we need to acquire the
spinlock in the tx path only when moving fwd memory.

recvmsg() must now explicitly acquire the socket spinlock
when moving skbs out of sk_receive_queue. To reduce the number of
lock operations required we use a second rx queue and splice the
first into the latter in mptcp_lock_sock(). Additionally rmem
allocated memory is bulk-freed via release_cb()

Acked-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 149 +++++++++++++++++++++++++++++--------------
 net/mptcp/protocol.h |   5 ++
 2 files changed, 107 insertions(+), 47 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 07fe484eefd1..2f40882c4279 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -453,15 +453,15 @@ static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 
 static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
 {
+	struct sock *ack_hint = READ_ONCE(msk->ack_hint);
 	struct mptcp_subflow_context *subflow;
 
 	/* if the hinted ssk is still active, try to use it */
-	if (likely(msk->ack_hint)) {
+	if (likely(ack_hint)) {
 		mptcp_for_each_subflow(msk, subflow) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-			if (msk->ack_hint == ssk &&
-			    mptcp_subflow_cleanup_rbuf(ssk))
+			if (ack_hint == ssk && mptcp_subflow_cleanup_rbuf(ssk))
 				return;
 		}
 	}
@@ -614,13 +614,13 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 			break;
 		}
 	} while (more_data_avail);
-	msk->ack_hint = ssk;
+	WRITE_ONCE(msk->ack_hint, ssk);
 
 	*bytes += moved;
 	return done;
 }
 
-static bool mptcp_ofo_queue(struct mptcp_sock *msk)
+static bool __mptcp_ofo_queue(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct sk_buff *skb, *tail;
@@ -666,34 +666,27 @@ static bool mptcp_ofo_queue(struct mptcp_sock *msk)
 /* In most cases we will be able to lock the mptcp socket.  If its already
  * owned, we need to defer to the work queue to avoid ABBA deadlock.
  */
-static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
+static void move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
 
-	if (READ_ONCE(sk->sk_lock.owned))
-		return false;
-
-	if (unlikely(!spin_trylock_bh(&sk->sk_lock.slock)))
-		return false;
-
-	/* must re-check after taking the lock */
-	if (!READ_ONCE(sk->sk_lock.owned)) {
-		__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
-		mptcp_ofo_queue(msk);
+	if (inet_sk_state_load(sk) == TCP_CLOSE)
+		return;
 
-		/* If the moves have caught up with the DATA_FIN sequence number
-		 * it's time to ack the DATA_FIN and change socket state, but
-		 * this is not a good place to change state. Let the workqueue
-		 * do it.
-		 */
-		if (mptcp_pending_data_fin(sk, NULL))
-			mptcp_schedule_work(sk);
-	}
+	mptcp_data_lock(sk);
 
-	spin_unlock_bh(&sk->sk_lock.slock);
+	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+	__mptcp_ofo_queue(msk);
 
-	return moved > 0;
+	/* If the moves have caught up with the DATA_FIN sequence number
+	 * it's time to ack the DATA_FIN and change socket state, but
+	 * this is not a good place to change state. Let the workqueue
+	 * do it.
+	 */
+	if (mptcp_pending_data_fin(sk, NULL))
+		mptcp_schedule_work(sk);
+	mptcp_data_unlock(sk);
 }
 
 void mptcp_data_ready(struct sock *sk, struct sock *ssk)
@@ -937,17 +930,30 @@ static bool mptcp_wmem_alloc(struct sock *sk, int size)
 	if (msk->wmem_reserved >= size)
 		goto account;
 
-	if (!sk_wmem_schedule(sk, size))
+	mptcp_data_lock(sk);
+	if (!sk_wmem_schedule(sk, size)) {
+		mptcp_data_unlock(sk);
 		return false;
+	}
 
 	sk->sk_forward_alloc -= size;
 	msk->wmem_reserved += size;
+	mptcp_data_unlock(sk);
 
 account:
 	msk->wmem_reserved -= size;
 	return true;
 }
 
+static void mptcp_wmem_uncharge(struct sock *sk, int size)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (msk->wmem_reserved < 0)
+		msk->wmem_reserved = 0;
+	msk->wmem_reserved += size;
+}
+
 static void dfrag_uncharge(struct sock *sk, int len)
 {
 	sk_mem_uncharge(sk, len);
@@ -976,6 +982,7 @@ static void mptcp_clean_una(struct sock *sk)
 	if (__mptcp_check_fallback(msk))
 		atomic64_set(&msk->snd_una, msk->snd_nxt);
 
+	mptcp_data_lock(sk);
 	snd_una = atomic64_read(&msk->snd_una);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
@@ -1007,6 +1014,7 @@ static void mptcp_clean_una(struct sock *sk)
 out:
 	if (cleaned && tcp_under_memory_pressure(sk))
 		sk_mem_reclaim_partial(sk);
+	mptcp_data_unlock(sk);
 }
 
 static void mptcp_clean_una_wakeup(struct sock *sk)
@@ -1436,7 +1444,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
-			msk->wmem_reserved += psize + frag_truesize;
+			mptcp_wmem_uncharge(sk, psize + frag_truesize);
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1502,11 +1510,10 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
 				size_t len)
 {
-	struct sock *sk = (struct sock *)msk;
 	struct sk_buff *skb;
 	int copied = 0;
 
-	while ((skb = skb_peek(&sk->sk_receive_queue)) != NULL) {
+	while ((skb = skb_peek(&msk->receive_queue)) != NULL) {
 		u32 offset = MPTCP_SKB_CB(skb)->offset;
 		u32 data_len = skb->len - offset;
 		u32 count = min_t(size_t, len - copied, data_len);
@@ -1526,7 +1533,10 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 			break;
 		}
 
-		__skb_unlink(skb, &sk->sk_receive_queue);
+		/* we will bulk release the skb memory later */
+		skb->destructor = NULL;
+		msk->rmem_released += skb->truesize;
+		__skb_unlink(skb, &msk->receive_queue);
 		__kfree_skb(skb);
 
 		if (copied >= len)
@@ -1634,25 +1644,47 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	msk->rcvq_space.time = mstamp;
 }
 
+static void __mptcp_update_rmem(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (!msk->rmem_released)
+		return;
+
+	atomic_sub(msk->rmem_released, &sk->sk_rmem_alloc);
+	sk_mem_uncharge(sk, msk->rmem_released);
+	msk->rmem_released = 0;
+}
+
+static void __mptcp_splice_receive_queue(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	skb_queue_splice_tail_init(&sk->sk_receive_queue, &msk->receive_queue);
+}
+
 static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
 {
+	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
-	bool done;
-
-	/* avoid looping forever below on racing close */
-	if (((struct sock *)msk)->sk_state == TCP_CLOSE)
-		return false;
+	bool ret, done;
 
 	__mptcp_flush_join_list(msk);
 	do {
 		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
 		bool slowpath;
 
-		if (!ssk)
+		/* we can have data pending in the subflows only if the msk
+		 * receive buffer was full at subflow_data_ready() time,
+		 * that is an unlikely slow path.
+		 */
+		if (likely(!ssk))
 			break;
 
 		slowpath = lock_sock_fast(ssk);
+		mptcp_data_lock(sk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+		mptcp_data_unlock(sk);
 		if (moved && rcv) {
 			WRITE_ONCE(msk->rmem_pending, min(rcv, moved));
 			tcp_cleanup_rbuf(ssk, 1);
@@ -1661,11 +1693,19 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
-	if (mptcp_ofo_queue(msk) || moved > 0) {
-		mptcp_check_data_fin((struct sock *)msk);
-		return true;
+	/* acquire the data lock only if some input data is pending */
+	ret = moved > 0;
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue) ||
+	    !skb_queue_empty_lockless(&sk->sk_receive_queue)) {
+		mptcp_data_lock(sk);
+		__mptcp_update_rmem(sk);
+		ret |= __mptcp_ofo_queue(msk);
+		__mptcp_splice_receive_queue(sk);
+		mptcp_data_unlock(sk);
 	}
-	return false;
+	if (ret)
+		mptcp_check_data_fin((struct sock *)msk);
+	return !skb_queue_empty(&msk->receive_queue);
 }
 
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
@@ -1679,7 +1719,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (msg->msg_flags & ~(MSG_WAITALL | MSG_DONTWAIT))
 		return -EOPNOTSUPP;
 
-	lock_sock(sk);
+	mptcp_lock_sock(sk, __mptcp_splice_receive_queue(sk));
 	if (unlikely(sk->sk_state == TCP_LISTEN)) {
 		copied = -ENOTCONN;
 		goto out_err;
@@ -1689,7 +1729,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-	__mptcp_flush_join_list(msk);
 
 	for (;;) {
 		int bytes_read, old_space;
@@ -1703,7 +1742,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		copied += bytes_read;
 
-		if (skb_queue_empty(&sk->sk_receive_queue) &&
+		if (skb_queue_empty(&msk->receive_queue) &&
 		    __mptcp_move_skbs(msk, len - copied))
 			continue;
 
@@ -1734,8 +1773,14 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 				mptcp_check_for_eof(msk);
 
-			if (sk->sk_shutdown & RCV_SHUTDOWN)
+			if (sk->sk_shutdown & RCV_SHUTDOWN) {
+				/* race breaker: the shutdown could be after the
+				 * previous receive queue check
+				 */
+				if (__mptcp_move_skbs(msk, len - copied))
+					continue;
 				break;
+			}
 
 			if (sk->sk_state == TCP_CLOSE) {
 				copied = -ENOTCONN;
@@ -1757,7 +1802,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		mptcp_wait_data(sk, &timeo);
 	}
 
-	if (skb_queue_empty(&sk->sk_receive_queue)) {
+	if (skb_queue_empty_lockless(&sk->sk_receive_queue) &&
+	    skb_queue_empty(&msk->receive_queue)) {
 		/* entire backlog drained, clear DATA_READY. */
 		clear_bit(MPTCP_DATA_READY, &msk->flags);
 
@@ -1773,7 +1819,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 out_err:
 	pr_debug("msk=%p data_ready=%d rx queue empty=%d copied=%d",
 		 msk, test_bit(MPTCP_DATA_READY, &msk->flags),
-		 skb_queue_empty(&sk->sk_receive_queue), copied);
+		 skb_queue_empty_lockless(&sk->sk_receive_queue), copied);
 	mptcp_rcv_space_adjust(msk, copied);
 
 	release_sock(sk);
@@ -2076,9 +2122,11 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->join_list);
 	INIT_LIST_HEAD(&msk->rtx_queue);
 	INIT_WORK(&msk->work, mptcp_worker);
+	__skb_queue_head_init(&msk->receive_queue);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
 	msk->wmem_reserved = 0;
+	msk->rmem_released = 0;
 
 	msk->ack_hint = NULL;
 	msk->first = NULL;
@@ -2274,6 +2322,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sk->sk_prot->destroy(sk);
 
 	WARN_ON_ONCE(msk->wmem_reserved);
+	WARN_ON_ONCE(msk->rmem_released);
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 	sk_refcnt_debug_release(sk);
@@ -2491,6 +2540,11 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 
 void mptcp_destroy_common(struct mptcp_sock *msk)
 {
+	struct sock *sk = (struct sock *)msk;
+
+	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
+	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
+
 	skb_rbtree_purge(&msk->out_of_order_queue);
 	mptcp_token_destroy(msk);
 	mptcp_pm_free_anno_list(msk);
@@ -2626,6 +2680,7 @@ static void mptcp_release_cb(struct sock *sk)
 
 	/* clear any wmem reservation and errors */
 	__mptcp_update_wmem(sk);
+	__mptcp_update_rmem(sk);
 
 	do {
 		flags = sk->sk_tsq_flags;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4cf355076e35..fe2efd923c5c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -227,6 +227,7 @@ struct mptcp_sock {
 	unsigned long	timer_ival;
 	u32		token;
 	int		rmem_pending;
+	int		rmem_released;
 	unsigned long	flags;
 	bool		can_ack;
 	bool		fully_established;
@@ -238,6 +239,7 @@ struct mptcp_sock {
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
+	struct sk_buff_head receive_queue;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
@@ -267,6 +269,9 @@ struct mptcp_sock {
 	local_bh_enable();						\
 } while (0)
 
+#define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
+#define mptcp_data_unlock(sk) spin_unlock_bh(&(sk)->sk_lock.slock)
+
 #define mptcp_for_each_subflow(__msk, __subflow)			\
 	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
 
-- 
2.26.2

