Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602FE43BDE0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbhJZXbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:31:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:24059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240286AbhJZXbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:31:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316242952"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316242952"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="597124829"
Received: from jdweinst-mobl2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.54.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/4] mptcp: allocate fwd memory separately on the rx and tx path
Date:   Tue, 26 Oct 2021 16:29:15 -0700
Message-Id: <20211026232916.179450-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
References: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

All the mptcp receive path is protected by the msk socket
spinlock. As consequences, the tx path has to play a few tricks to
allocate the forward memory without acquiring the spinlock multiple
times, making the overall TX path quite complex.

This patch tries to clean-up a bit the tx path, using completely
separated fwd memory allocation, for the rx and the tx path.

The forward memory allocated in the rx path is now accounted in
msk->rmem_fwd_alloc and is (still) protected by the msk socket spinlock.

To cope with the above we provide a few MPTCP-specific variants for
the helpers to charge, uncharge, reclaim and free the forward memory
in the receive path.

msk->sk_forward_alloc now accounts only the forward memory for the tx
path, we can use the plain core sock helper to manipulate it and drop
quite a bit of complexity.

On memory pressure, both rx and tx fwd memories are reclaimed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 225 ++++++++++++++++++-------------------------
 net/mptcp/protocol.h |  15 +--
 2 files changed, 95 insertions(+), 145 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cd6b11c9b54d..81ef592113a5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -126,6 +126,11 @@ static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
+static void mptcp_rmem_charge(struct sock *sk, int size)
+{
+	mptcp_sk(sk)->rmem_fwd_alloc -= size;
+}
+
 static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 			       struct sk_buff *from)
 {
@@ -142,7 +147,7 @@ static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 	MPTCP_SKB_CB(to)->end_seq = MPTCP_SKB_CB(from)->end_seq;
 	kfree_skb_partial(from, fragstolen);
 	atomic_add(delta, &sk->sk_rmem_alloc);
-	sk_mem_charge(sk, delta);
+	mptcp_rmem_charge(sk, delta);
 	return true;
 }
 
@@ -155,6 +160,44 @@ static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff *to,
 	return mptcp_try_coalesce((struct sock *)msk, to, from);
 }
 
+static void __mptcp_rmem_reclaim(struct sock *sk, int amount)
+{
+	amount >>= SK_MEM_QUANTUM_SHIFT;
+	mptcp_sk(sk)->rmem_fwd_alloc -= amount << SK_MEM_QUANTUM_SHIFT;
+	__sk_mem_reduce_allocated(sk, amount);
+}
+
+static void mptcp_rmem_uncharge(struct sock *sk, int size)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int reclaimable;
+
+	msk->rmem_fwd_alloc += size;
+	reclaimable = msk->rmem_fwd_alloc - sk_unused_reserved_mem(sk);
+
+	/* see sk_mem_uncharge() for the rationale behind the following schema */
+	if (unlikely(reclaimable >= SK_RECLAIM_THRESHOLD))
+		__mptcp_rmem_reclaim(sk, SK_RECLAIM_CHUNK);
+}
+
+static void mptcp_rfree(struct sk_buff *skb)
+{
+	unsigned int len = skb->truesize;
+	struct sock *sk = skb->sk;
+
+	atomic_sub(len, &sk->sk_rmem_alloc);
+	mptcp_rmem_uncharge(sk, len);
+}
+
+static void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk)
+{
+	skb_orphan(skb);
+	skb->sk = sk;
+	skb->destructor = mptcp_rfree;
+	atomic_add(skb->truesize, &sk->sk_rmem_alloc);
+	mptcp_rmem_charge(sk, skb->truesize);
+}
+
 /* "inspired" by tcp_data_queue_ofo(), main differences:
  * - use mptcp seqs
  * - don't cope with sacks
@@ -267,7 +310,29 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 
 end:
 	skb_condense(skb);
-	skb_set_owner_r(skb, sk);
+	mptcp_set_owner_r(skb, sk);
+}
+
+static bool mptcp_rmem_schedule(struct sock *sk, struct sock *ssk, int size)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int amt, amount;
+
+	if (size < msk->rmem_fwd_alloc)
+		return true;
+
+	amt = sk_mem_pages(size);
+	amount = amt << SK_MEM_QUANTUM_SHIFT;
+	msk->rmem_fwd_alloc += amount;
+	if (!__sk_mem_raise_allocated(sk, size, amt, SK_MEM_RECV)) {
+		if (ssk->sk_forward_alloc < amount) {
+			msk->rmem_fwd_alloc -= amount;
+			return false;
+		}
+
+		ssk->sk_forward_alloc -= amount;
+	}
+	return true;
 }
 
 static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
@@ -285,15 +350,8 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	skb_orphan(skb);
 
 	/* try to fetch required memory from subflow */
-	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		int amount = sk_mem_pages(skb->truesize) << SK_MEM_QUANTUM_SHIFT;
-
-		if (ssk->sk_forward_alloc < amount)
-			goto drop;
-
-		ssk->sk_forward_alloc -= amount;
-		sk->sk_forward_alloc += amount;
-	}
+	if (!mptcp_rmem_schedule(sk, ssk, skb->truesize))
+		goto drop;
 
 	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
 
@@ -313,7 +371,7 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 		if (tail && mptcp_try_coalesce(sk, tail, skb))
 			return true;
 
-		skb_set_owner_r(skb, sk);
+		mptcp_set_owner_r(skb, sk);
 		__skb_queue_tail(&sk->sk_receive_queue, skb);
 		return true;
 	} else if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq)) {
@@ -908,122 +966,20 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static int mptcp_wmem_with_overhead(int size)
-{
-	return size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
-}
-
-static void __mptcp_wmem_reserve(struct sock *sk, int size)
-{
-	int amount = mptcp_wmem_with_overhead(size);
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	WARN_ON_ONCE(msk->wmem_reserved);
-	if (WARN_ON_ONCE(amount < 0))
-		amount = 0;
-
-	if (amount <= sk->sk_forward_alloc)
-		goto reserve;
-
-	/* under memory pressure try to reserve at most a single page
-	 * otherwise try to reserve the full estimate and fallback
-	 * to a single page before entering the error path
-	 */
-	if ((tcp_under_memory_pressure(sk) && amount > PAGE_SIZE) ||
-	    !sk_wmem_schedule(sk, amount)) {
-		if (amount <= PAGE_SIZE)
-			goto nomem;
-
-		amount = PAGE_SIZE;
-		if (!sk_wmem_schedule(sk, amount))
-			goto nomem;
-	}
-
-reserve:
-	msk->wmem_reserved = amount;
-	sk->sk_forward_alloc -= amount;
-	return;
-
-nomem:
-	/* we will wait for memory on next allocation */
-	msk->wmem_reserved = -1;
-}
-
-static void __mptcp_update_wmem(struct sock *sk)
+static void __mptcp_mem_reclaim_partial(struct sock *sk)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
+	int reclaimable = mptcp_sk(sk)->rmem_fwd_alloc - sk_unused_reserved_mem(sk);
 
 	lockdep_assert_held_once(&sk->sk_lock.slock);
 
-	if (!msk->wmem_reserved)
-		return;
-
-	if (msk->wmem_reserved < 0)
-		msk->wmem_reserved = 0;
-	if (msk->wmem_reserved > 0) {
-		sk->sk_forward_alloc += msk->wmem_reserved;
-		msk->wmem_reserved = 0;
-	}
-}
-
-static bool mptcp_wmem_alloc(struct sock *sk, int size)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	/* check for pre-existing error condition */
-	if (msk->wmem_reserved < 0)
-		return false;
-
-	if (msk->wmem_reserved >= size)
-		goto account;
-
-	mptcp_data_lock(sk);
-	if (!sk_wmem_schedule(sk, size)) {
-		mptcp_data_unlock(sk);
-		return false;
-	}
-
-	sk->sk_forward_alloc -= size;
-	msk->wmem_reserved += size;
-	mptcp_data_unlock(sk);
-
-account:
-	msk->wmem_reserved -= size;
-	return true;
-}
-
-static void mptcp_wmem_uncharge(struct sock *sk, int size)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	if (msk->wmem_reserved < 0)
-		msk->wmem_reserved = 0;
-	msk->wmem_reserved += size;
-}
-
-static void __mptcp_mem_reclaim_partial(struct sock *sk)
-{
-	lockdep_assert_held_once(&sk->sk_lock.slock);
-	__mptcp_update_wmem(sk);
+	__mptcp_rmem_reclaim(sk, reclaimable - 1);
 	sk_mem_reclaim_partial(sk);
 }
 
 static void mptcp_mem_reclaim_partial(struct sock *sk)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	/* if we are experiencing a transint allocation error,
-	 * the forward allocation memory has been already
-	 * released
-	 */
-	if (msk->wmem_reserved < 0)
-		return;
-
 	mptcp_data_lock(sk);
-	sk->sk_forward_alloc += msk->wmem_reserved;
-	sk_mem_reclaim_partial(sk);
-	msk->wmem_reserved = sk->sk_forward_alloc;
-	sk->sk_forward_alloc = 0;
+	__mptcp_mem_reclaim_partial(sk);
 	mptcp_data_unlock(sk);
 }
 
@@ -1664,7 +1620,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 	/* __mptcp_alloc_tx_skb could have released some wmem and we are
 	 * not going to flush it via release_sock()
 	 */
-	__mptcp_update_wmem(sk);
 	if (copied) {
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
@@ -1701,7 +1656,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	/* silently ignore everything else */
 	msg->msg_flags &= MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL;
 
-	mptcp_lock_sock(sk, __mptcp_wmem_reserve(sk, min_t(size_t, 1 << 20, len)));
+	lock_sock(sk);
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
@@ -1749,17 +1704,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		psize = min_t(size_t, psize, msg_data_left(msg));
 		total_ts = psize + frag_truesize;
 
-		if (!mptcp_wmem_alloc(sk, total_ts))
+		if (!sk_wmem_schedule(sk, total_ts))
 			goto wait_for_memory;
 
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
-			mptcp_wmem_uncharge(sk, psize + frag_truesize);
 			ret = -EFAULT;
 			goto out;
 		}
 
 		/* data successfully copied into the write queue */
+		sk->sk_forward_alloc -= total_ts;
 		copied += psize;
 		dfrag->data_len += psize;
 		frag_truesize += psize;
@@ -1956,7 +1911,7 @@ static void __mptcp_update_rmem(struct sock *sk)
 		return;
 
 	atomic_sub(msk->rmem_released, &sk->sk_rmem_alloc);
-	sk_mem_uncharge(sk, msk->rmem_released);
+	mptcp_rmem_uncharge(sk, msk->rmem_released);
 	WRITE_ONCE(msk->rmem_released, 0);
 }
 
@@ -2024,7 +1979,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	mptcp_lock_sock(sk, __mptcp_splice_receive_queue(sk));
+	lock_sock(sk);
 	if (unlikely(sk->sk_state == TCP_LISTEN)) {
 		copied = -ENOTCONN;
 		goto out_err;
@@ -2504,7 +2459,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	__skb_queue_head_init(&msk->receive_queue);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
-	msk->wmem_reserved = 0;
+	msk->rmem_fwd_alloc = 0;
 	WRITE_ONCE(msk->rmem_released, 0);
 	msk->timer_ival = TCP_RTO_MIN;
 
@@ -2715,7 +2670,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
-	WARN_ON_ONCE(msk->wmem_reserved);
+	WARN_ON_ONCE(msk->rmem_fwd_alloc);
 	WARN_ON_ONCE(msk->rmem_released);
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
@@ -2948,8 +2903,14 @@ void mptcp_destroy_common(struct mptcp_sock *msk)
 
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
-
+	__skb_queue_purge(&sk->sk_receive_queue);
 	skb_rbtree_purge(&msk->out_of_order_queue);
+
+	/* move all the rx fwd alloc into the sk_mem_reclaim_final in
+	 * inet_sock_destruct() will dispose it
+	 */
+	sk->sk_forward_alloc += msk->rmem_fwd_alloc;
+	msk->rmem_fwd_alloc = 0;
 	mptcp_token_destroy(msk);
 	mptcp_pm_free_anno_list(msk);
 }
@@ -3031,10 +2992,6 @@ static void mptcp_release_cb(struct sock *sk)
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
 		__mptcp_error_report(sk);
 
-	/* push_pending may touch wmem_reserved, ensure we do the cleanup
-	 * later
-	 */
-	__mptcp_update_wmem(sk);
 	__mptcp_update_rmem(sk);
 }
 
@@ -3184,6 +3141,11 @@ static void mptcp_shutdown(struct sock *sk, int how)
 		__mptcp_wr_shutdown(sk);
 }
 
+static int mptcp_forward_alloc_get(const struct sock *sk)
+{
+	return sk->sk_forward_alloc + mptcp_sk(sk)->rmem_fwd_alloc;
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -3201,6 +3163,7 @@ static struct proto mptcp_prot = {
 	.hash		= mptcp_hash,
 	.unhash		= mptcp_unhash,
 	.get_port	= mptcp_get_port,
+	.forward_alloc_get	= mptcp_forward_alloc_get,
 	.sockets_allocated	= &mptcp_sockets_allocated,
 	.memory_allocated	= &tcp_memory_allocated,
 	.memory_pressure	= &tcp_memory_pressure,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 284fdcec067e..67a61ac48b20 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -227,7 +227,7 @@ struct mptcp_sock {
 	u64		ack_seq;
 	u64		rcv_wnd_sent;
 	u64		rcv_data_fin_seq;
-	int		wmem_reserved;
+	int		rmem_fwd_alloc;
 	struct sock	*last_snd;
 	int		snd_burst;
 	int		old_wspace;
@@ -272,19 +272,6 @@ struct mptcp_sock {
 	char		ca_name[TCP_CA_NAME_MAX];
 };
 
-#define mptcp_lock_sock(___sk, cb) do {					\
-	struct sock *__sk = (___sk); /* silence macro reuse warning */	\
-	might_sleep();							\
-	spin_lock_bh(&__sk->sk_lock.slock);				\
-	if (__sk->sk_lock.owned)					\
-		__lock_sock(__sk);					\
-	cb;								\
-	__sk->sk_lock.owned = 1;					\
-	spin_unlock(&__sk->sk_lock.slock);				\
-	mutex_acquire(&__sk->sk_lock.dep_map, 0, 0, _RET_IP_);		\
-	local_bh_enable();						\
-} while (0)
-
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
 #define mptcp_data_unlock(sk) spin_unlock_bh(&(sk)->sk_lock.slock)
 
-- 
2.33.1

