Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C602C628C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgK0KKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgK0KKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YhAHvRTYUrOTiQCePLSVfym1rr9YOwOTfGCRWwST9h4=;
        b=DcS9k+XhTENtll9UdUyu37A38pad5n75tGdVzmEpYnCEd2E16La2OoRPNusRHUmq4Yon7h
        VlJTzuJHkq8OYUGMyodRSt3XTCf5kdAQyzxG1tUjPSsrs/qA10ZRwZpKjOpaQzCZqAPQTn
        1BXrDMc0k7Q1P/lnVnfUP4no3PxRIgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-4voZr58vP2myHKG1W6tAqw-1; Fri, 27 Nov 2020 05:10:47 -0500
X-MC-Unique: 4voZr58vP2myHKG1W6tAqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58D26100747E;
        Fri, 27 Nov 2020 10:10:46 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30BB21002393;
        Fri, 27 Nov 2020 10:10:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 4/6] mptcp: allocate TX skbs in msk context
Date:   Fri, 27 Nov 2020 11:10:25 +0100
Message-Id: <2c4eacb182281d8e65cf4cf521e05141e6b011c8.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the TX skbs allocation in mptcp_sendmsg() scope,
and tentatively pre-allocate a skbs number proportional
to the sendmsg() length.

Use the ssk tx skb cache to prevent the subflow allocation.

This allows removing the msk skb extension cache and will
make possible the later patches.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 248 ++++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h |   4 +-
 2 files changed, 210 insertions(+), 42 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2f40882c4279..75b4c4c50dbb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -818,16 +818,6 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 	mptcp_close_wake_up(sk);
 }
 
-static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
-{
-	const struct sock *sk = (const struct sock *)msk;
-
-	if (!msk->cached_ext)
-		msk->cached_ext = __skb_ext_alloc(sk->sk_allocation);
-
-	return !!msk->cached_ext;
-}
-
 static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -866,14 +856,22 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
-static int mptcp_wmem_with_overhead(int size)
+static int mptcp_wmem_with_overhead(struct sock *sk, int size)
 {
-	return size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int ret, skbs;
+
+	ret = size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
+	skbs = (msk->tx_pending_data + size) / msk->size_goal_cache;
+	if (skbs < msk->skb_tx_cache.qlen)
+		return ret;
+
+	return ret + (skbs - msk->skb_tx_cache.qlen) * SKB_TRUESIZE(MAX_TCP_HEADER);
 }
 
 static void __mptcp_wmem_reserve(struct sock *sk, int size)
 {
-	int amount = mptcp_wmem_with_overhead(size);
+	int amount = mptcp_wmem_with_overhead(sk, size);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	WARN_ON_ONCE(msk->wmem_reserved);
@@ -954,6 +952,25 @@ static void mptcp_wmem_uncharge(struct sock *sk, int size)
 	msk->wmem_reserved += size;
 }
 
+static void mptcp_mem_reclaim_partial(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	/* if we are experiencing a transint allocation error,
+	 * the forward allocation memory has been already
+	 * released
+	 */
+	if (msk->wmem_reserved < 0)
+		return;
+
+	mptcp_data_lock(sk);
+	sk->sk_forward_alloc += msk->wmem_reserved;
+	sk_mem_reclaim_partial(sk);
+	msk->wmem_reserved = sk->sk_forward_alloc;
+	sk->sk_forward_alloc = 0;
+	mptcp_data_unlock(sk);
+}
+
 static void dfrag_uncharge(struct sock *sk, int len)
 {
 	sk_mem_uncharge(sk, len);
@@ -1030,19 +1047,12 @@ static void mptcp_clean_una_wakeup(struct sock *sk)
 	}
 }
 
-/* ensure we get enough memory for the frag hdr, beyond some minimal amount of
- * data
- */
-static bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
+static void mptcp_enter_memory_pressure(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool first = true;
 
-	if (likely(skb_page_frag_refill(32U + sizeof(struct mptcp_data_frag),
-					pfrag, sk->sk_allocation)))
-		return true;
-
 	sk_stream_moderate_sndbuf(sk);
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
@@ -1052,6 +1062,18 @@ static bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 		sk_stream_moderate_sndbuf(ssk);
 		first = false;
 	}
+}
+
+/* ensure we get enough memory for the frag hdr, beyond some minimal amount of
+ * data
+ */
+static bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
+{
+	if (likely(skb_page_frag_refill(32U + sizeof(struct mptcp_data_frag),
+					pfrag, sk->sk_allocation)))
+		return true;
+
+	mptcp_enter_memory_pressure(sk);
 	return false;
 }
 
@@ -1098,6 +1120,128 @@ static int mptcp_check_allowed_size(struct mptcp_sock *msk, u64 data_seq,
 	return avail_size;
 }
 
+static bool __mptcp_add_ext(struct sk_buff *skb, gfp_t gfp)
+{
+	struct skb_ext *mpext = __skb_ext_alloc(gfp);
+
+	if (!mpext)
+		return false;
+	__skb_ext_set(skb, SKB_EXT_MPTCP, mpext);
+	return true;
+}
+
+static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb_fclone(MAX_TCP_HEADER, sk->sk_allocation);
+	if (likely(skb)) {
+		if (likely(__mptcp_add_ext(skb, sk->sk_allocation))) {
+			skb_reserve(skb, MAX_TCP_HEADER);
+			skb->reserved_tailroom = skb->end - skb->tail;
+			return skb;
+		}
+		__kfree_skb(skb);
+	} else {
+		mptcp_enter_memory_pressure(sk);
+	}
+	return NULL;
+}
+
+static bool mptcp_tx_cache_refill(struct sock *sk, int size,
+				  struct sk_buff_head *skbs, int *total_ts)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sk_buff *skb;
+	int space_needed;
+
+	if (unlikely(tcp_under_memory_pressure(sk))) {
+		mptcp_mem_reclaim_partial(sk);
+
+		/* under pressure pre-allocate at most a single skb */
+		if (msk->skb_tx_cache.qlen)
+			return true;
+		space_needed = msk->size_goal_cache;
+	} else {
+		space_needed = msk->tx_pending_data + size -
+			       msk->skb_tx_cache.qlen * msk->size_goal_cache;
+	}
+
+	while (space_needed > 0) {
+		skb = __mptcp_do_alloc_tx_skb(sk);
+		if (unlikely(!skb)) {
+			/* under memory pressure, try to pass the caller a
+			 * single skb to allow forward progress
+			 */
+			while (skbs->qlen > 1) {
+				skb = __skb_dequeue_tail(skbs);
+				__kfree_skb(skb);
+			}
+			return skbs->qlen > 0;
+		}
+
+		*total_ts += skb->truesize;
+		__skb_queue_tail(skbs, skb);
+		space_needed -= msk->size_goal_cache;
+	}
+	return true;
+}
+
+static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sk_buff *skb;
+
+	if (ssk->sk_tx_skb_cache) {
+		skb = ssk->sk_tx_skb_cache;
+		if (unlikely(!skb_ext_find(skb, SKB_EXT_MPTCP) &&
+			     !__mptcp_add_ext(skb, sk->sk_allocation)))
+			return false;
+		return true;
+	}
+
+	skb = skb_peek(&msk->skb_tx_cache);
+	if (skb) {
+		if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
+			skb = __skb_dequeue(&msk->skb_tx_cache);
+			if (WARN_ON_ONCE(!skb))
+				return false;
+
+			mptcp_wmem_uncharge(sk, skb->truesize);
+			ssk->sk_tx_skb_cache = skb;
+			return true;
+		}
+
+		/* over memory limit, no point to try to allocate a new skb */
+		return false;
+	}
+
+	skb = __mptcp_do_alloc_tx_skb(sk);
+	if (!skb)
+		return false;
+
+	if (likely(sk_wmem_schedule(ssk, skb->truesize))) {
+		ssk->sk_tx_skb_cache = skb;
+		return true;
+	}
+	kfree_skb(skb);
+	return false;
+}
+
+static bool mptcp_must_reclaim_memory(struct sock *sk, struct sock *ssk)
+{
+	return !ssk->sk_tx_skb_cache &&
+	       !skb_peek(&mptcp_sk(sk)->skb_tx_cache) &&
+	       tcp_under_memory_pressure(sk);
+}
+
+static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
+{
+	if (unlikely(mptcp_must_reclaim_memory(sk, ssk)))
+		mptcp_mem_reclaim_partial(sk);
+	return __mptcp_alloc_tx_skb(sk, ssk);
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_data_frag *dfrag,
 			      struct mptcp_sendmsg_info *info)
@@ -1109,7 +1253,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	struct sk_buff *skb, *tail;
 	bool can_collapse = false;
 	int avail_size;
-	size_t ret;
+	size_t ret = 0;
 
 	pr_debug("msk=%p ssk=%p sending dfrag at seq=%lld len=%d already sent=%d",
 		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
@@ -1117,6 +1261,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	/* compute send limit */
 	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
 	avail_size = info->size_goal;
+	msk->size_goal_cache = info->size_goal;
 	skb = tcp_write_queue_tail(ssk);
 	if (skb) {
 		/* Limit the write to the size available in the
@@ -1165,8 +1310,11 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		goto out;
 	}
 
-	mpext = __skb_ext_set(tail, SKB_EXT_MPTCP, msk->cached_ext);
-	msk->cached_ext = NULL;
+	mpext = skb_ext_find(tail, SKB_EXT_MPTCP);
+	if (WARN_ON_ONCE(!mpext)) {
+		/* should never reach here, stream corrupted */
+		return -EINVAL;
+	}
 
 	memset(mpext, 0, sizeof(*mpext));
 	mpext->data_seq = data_seq;
@@ -1239,9 +1387,6 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 	sock_owned_by_me((struct sock *)msk);
 
 	*sndbuf = 0;
-	if (!mptcp_ext_cache_refill(msk))
-		return NULL;
-
 	if (__mptcp_check_fallback(msk)) {
 		if (!msk->first)
 			return NULL;
@@ -1350,6 +1495,15 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 			if (ssk != prev_ssk || !prev_ssk)
 				lock_sock(ssk);
 
+			/* keep it simple and always provide a new skb for the
+			 * subflow, even if we will not use it when collapsing
+			 * on the pending one
+			 */
+			if (!mptcp_alloc_tx_skb(sk, ssk)) {
+				mptcp_push_release(sk, ssk, &info);
+				goto out;
+			}
+
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0) {
 				mptcp_push_release(sk, ssk, &info);
@@ -1360,6 +1514,7 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 			dfrag->already_sent += ret;
 			msk->snd_nxt += ret;
 			msk->snd_burst -= ret;
+			msk->tx_pending_data -= ret;
 			copied += ret;
 			len -= ret;
 		}
@@ -1404,8 +1559,9 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	mptcp_clean_una(sk);
 
 	while (msg_data_left(msg)) {
+		int total_ts, frag_truesize = 0;
 		struct mptcp_data_frag *dfrag;
-		int frag_truesize = 0;
+		struct sk_buff_head skbs;
 		bool dfrag_collapsed;
 		size_t psize, offset;
 
@@ -1439,9 +1595,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		offset = dfrag->offset + dfrag->data_len;
 		psize = pfrag->size - offset;
 		psize = min_t(size_t, psize, msg_data_left(msg));
-		if (!mptcp_wmem_alloc(sk, psize + frag_truesize))
+		total_ts = psize + frag_truesize;
+		__skb_queue_head_init(&skbs);
+		if (!mptcp_tx_cache_refill(sk, psize, &skbs, &total_ts))
 			goto wait_for_memory;
 
+		if (!mptcp_wmem_alloc(sk, total_ts)) {
+			__skb_queue_purge(&skbs);
+			goto wait_for_memory;
+		}
+
+		skb_queue_splice_tail(&skbs, &msk->skb_tx_cache);
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
 			mptcp_wmem_uncharge(sk, psize + frag_truesize);
@@ -1470,8 +1634,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			 dfrag->data_seq, dfrag->data_len, dfrag->already_sent,
 			 !dfrag_collapsed);
 
-		if (!mptcp_ext_cache_refill(msk))
-			goto wait_for_memory;
 		continue;
 
 wait_for_memory:
@@ -1483,8 +1645,10 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto out;
 	}
 
-	if (copied)
+	if (copied) {
+		msk->tx_pending_data += copied;
 		mptcp_push_pending(sk, msg->msg_flags);
+	}
 
 out:
 	release_sock(sk);
@@ -2072,9 +2236,6 @@ static void mptcp_worker(struct work_struct *work)
 	if (!dfrag)
 		goto unlock;
 
-	if (!mptcp_ext_cache_refill(msk))
-		goto reset_unlock;
-
 	ssk = mptcp_subflow_get_retrans(msk);
 	if (!ssk)
 		goto reset_unlock;
@@ -2085,6 +2246,9 @@ static void mptcp_worker(struct work_struct *work)
 	info.sent = 0;
 	info.limit = dfrag->already_sent;
 	while (info.sent < dfrag->already_sent) {
+		if (!mptcp_alloc_tx_skb(sk, ssk))
+			break;
+
 		ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 		if (ret <= 0)
 			break;
@@ -2092,9 +2256,6 @@ static void mptcp_worker(struct work_struct *work)
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RETRANSSEGS);
 		copied += ret;
 		info.sent += ret;
-
-		if (!mptcp_ext_cache_refill(msk))
-			break;
 	}
 	if (copied)
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
@@ -2123,10 +2284,13 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->rtx_queue);
 	INIT_WORK(&msk->work, mptcp_worker);
 	__skb_queue_head_init(&msk->receive_queue);
+	__skb_queue_head_init(&msk->skb_tx_cache);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
 	msk->wmem_reserved = 0;
 	msk->rmem_released = 0;
+	msk->tx_pending_data = 0;
+	msk->size_goal_cache = TCP_BASE_MSS;
 
 	msk->ack_hint = NULL;
 	msk->first = NULL;
@@ -2170,12 +2334,17 @@ static void __mptcp_clear_xmit(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
+	struct sk_buff *skb;
 
 	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
 
 	WRITE_ONCE(msk->first_pending, NULL);
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
+	while ((skb = __skb_dequeue(&msk->skb_tx_cache)) != NULL) {
+		sk->sk_forward_alloc += skb->truesize;
+		kfree_skb(skb);
+	}
 }
 
 static void mptcp_cancel_work(struct sock *sk)
@@ -2554,9 +2723,6 @@ static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (msk->cached_ext)
-		__skb_ext_put(msk->cached_ext);
-
 	mptcp_destroy_common(msk);
 	sk_sockets_allocated_dec(sk);
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fe2efd923c5c..97c1e5dcb3e2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -240,11 +240,13 @@ struct mptcp_sock {
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
 	struct sk_buff_head receive_queue;
+	struct sk_buff_head skb_tx_cache;	/* this is wmem accounted */
+	int		tx_pending_data;
+	int		size_goal_cache;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
 	struct list_head join_list;
-	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct sock	*first;
 	struct mptcp_pm_data	pm;
-- 
2.26.2

