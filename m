Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC5A2C628E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgK0KK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgK0KK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3RHiTMwd0SgPlmUK1eB5M+C42FeJB3iYbjoC4Gs2mU=;
        b=dqd7IS9U5aJFZP/RQkfQn2+FcNZIWM3fDaqi8kDoHHVIXE70VqZFfZ1v3pKC0k3f52IceS
        sp2CDWyUhht8S0M5Jxk8zYf3Ld/Iyao+AoLwd1eBgCMHh73LDjYXbnfDR2y4Q4nWTLrIvs
        XuCf7rYwdhAzcqBwtjlJlxirLOI/wwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-DwPlAuLtO2KJ_cCOmR77uQ-1; Fri, 27 Nov 2020 05:10:51 -0500
X-MC-Unique: DwPlAuLtO2KJ_cCOmR77uQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D08E8797E3;
        Fri, 27 Nov 2020 10:10:49 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3737810021B3;
        Fri, 27 Nov 2020 10:10:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 6/6] mptcp: use mptcp release_cb for delayed tasks
Date:   Fri, 27 Nov 2020 11:10:27 +0100
Message-Id: <b62cc1e06a7924ac60e9c320e6535e2ec9900065.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have some tasks triggered by the subflow receive path
which require to access the msk socket status, specifically:
mptcp_clean_una() and mptcp_push_pending()

We have almost everything in place to defer to the msk
release_cb such tasks when the msk sock is owned.

Since the worker is no more used to clean the acked data,
for fallback sockets we need to explicitly flush them.

As an added bonus we can move the wake-up code in __mptcp_clean_una(),
simplify a lot mptcp_poll() and move the timer update under
the data lock.

The worker is now used only to process and send DATA_FIN
packets and do the mptcp-level retransmissions.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  |  18 +++-
 net/mptcp/protocol.c | 250 ++++++++++++++++++++++++++-----------------
 net/mptcp/protocol.h |   3 +
 net/mptcp/subflow.c  |  14 +--
 4 files changed, 168 insertions(+), 117 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 3986454a0340..6b7b4b67f18c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -830,7 +830,7 @@ static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
 }
 
 static void ack_update_msk(struct mptcp_sock *msk,
-			   const struct sock *ssk,
+			   struct sock *ssk,
 			   struct mptcp_options_received *mp_opt)
 {
 	u64 new_wnd_end, new_snd_una, snd_nxt = READ_ONCE(msk->snd_nxt);
@@ -854,8 +854,7 @@ static void ack_update_msk(struct mptcp_sock *msk,
 
 	if (after64(new_wnd_end, msk->wnd_end)) {
 		msk->wnd_end = new_wnd_end;
-		if (mptcp_send_head(sk))
-			mptcp_schedule_work(sk);
+		__mptcp_wnd_updated(sk, ssk);
 	}
 
 	if (after64(new_snd_una, old_snd_una)) {
@@ -915,8 +914,19 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	struct mptcp_options_received mp_opt;
 	struct mptcp_ext *mpext;
 
-	if (__mptcp_check_fallback(msk))
+	if (__mptcp_check_fallback(msk)) {
+		/* Keep it simple and unconditionally trigger send data cleanup and
+		 * pending queue spooling. We will need to acquire the data lock
+		 * for more accurate checks, and once the lock is acquired, such
+		 * helpers are cheap.
+		 */
+		mptcp_data_lock(subflow->conn);
+		if (mptcp_send_head(subflow->conn))
+			__mptcp_wnd_updated(subflow->conn, sk);
+		__mptcp_data_acked(subflow->conn);
+		mptcp_data_unlock(subflow->conn);
 		return;
+	}
 
 	mptcp_get_options(skb, &mp_opt);
 	if (!check_fully_established(msk, sk, subflow, skb, &mp_opt))
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 51f92f3096bf..221f7cdd416b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -348,17 +348,22 @@ static void mptcp_close_wake_up(struct sock *sk)
 		sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 }
 
-static void mptcp_check_data_fin_ack(struct sock *sk)
+static bool mptcp_pending_data_fin_ack(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (__mptcp_check_fallback(msk))
-		return;
+	return !__mptcp_check_fallback(msk) &&
+	       ((1 << sk->sk_state) &
+		(TCPF_FIN_WAIT1 | TCPF_CLOSING | TCPF_LAST_ACK)) &&
+	       msk->write_seq == READ_ONCE(msk->snd_una);
+}
+
+static void mptcp_check_data_fin_ack(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* Look for an acknowledged DATA_FIN */
-	if (((1 << sk->sk_state) &
-	     (TCPF_FIN_WAIT1 | TCPF_CLOSING | TCPF_LAST_ACK)) &&
-	    msk->write_seq == READ_ONCE(msk->snd_una)) {
+	if (mptcp_pending_data_fin_ack(sk)) {
 		mptcp_stop_timer(sk);
 
 		WRITE_ONCE(msk->snd_data_fin_enable, 0);
@@ -764,16 +769,6 @@ bool mptcp_schedule_work(struct sock *sk)
 	return false;
 }
 
-void __mptcp_data_acked(struct sock *sk)
-{
-	mptcp_reset_timer(sk);
-
-	if ((test_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags) ||
-	     mptcp_send_head(sk) ||
-	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
-		mptcp_schedule_work(sk);
-}
-
 void mptcp_subflow_eof(struct sock *sk)
 {
 	if (!test_and_set_bit(MPTCP_WORK_EOF, &mptcp_sk(sk)->flags))
@@ -986,7 +981,7 @@ static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
 	put_page(dfrag->page);
 }
 
-static void mptcp_clean_una(struct sock *sk)
+static void __mptcp_clean_una(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
@@ -999,8 +994,6 @@ static void mptcp_clean_una(struct sock *sk)
 	if (__mptcp_check_fallback(msk))
 		msk->snd_una = READ_ONCE(msk->snd_nxt);
 
-
-	mptcp_data_lock(sk);
 	snd_una = msk->snd_una;
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
@@ -1029,21 +1022,25 @@ static void mptcp_clean_una(struct sock *sk)
 	}
 
 out:
-	if (cleaned && tcp_under_memory_pressure(sk))
-		sk_mem_reclaim_partial(sk);
-	mptcp_data_unlock(sk);
-}
-
-static void mptcp_clean_una_wakeup(struct sock *sk)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
+	if (cleaned) {
+		if (tcp_under_memory_pressure(sk)) {
+			__mptcp_update_wmem(sk);
+			sk_mem_reclaim_partial(sk);
+		}
 
-	mptcp_clean_una(sk);
+		if (sk_stream_is_writeable(sk)) {
+			/* pairs with memory barrier in mptcp_poll */
+			smp_mb();
+			if (test_and_clear_bit(MPTCP_NOSPACE, &msk->flags))
+				sk_stream_write_space(sk);
+		}
+	}
 
-	/* Only wake up writers if a subflow is ready */
-	if (sk_stream_is_writeable(sk)) {
-		clear_bit(MPTCP_NOSPACE, &msk->flags);
-		sk_stream_write_space(sk);
+	if (snd_una == READ_ONCE(msk->snd_nxt)) {
+		if (msk->timer_ival)
+			mptcp_stop_timer(sk);
+	} else {
+		mptcp_reset_timer(sk);
 	}
 }
 
@@ -1130,13 +1127,13 @@ static bool __mptcp_add_ext(struct sk_buff *skb, gfp_t gfp)
 	return true;
 }
 
-static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk)
+static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb_fclone(MAX_TCP_HEADER, sk->sk_allocation);
+	skb = alloc_skb_fclone(MAX_TCP_HEADER, gfp);
 	if (likely(skb)) {
-		if (likely(__mptcp_add_ext(skb, sk->sk_allocation))) {
+		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
 			skb->reserved_tailroom = skb->end - skb->tail;
 			return skb;
@@ -1168,7 +1165,7 @@ static bool mptcp_tx_cache_refill(struct sock *sk, int size,
 	}
 
 	while (space_needed > 0) {
-		skb = __mptcp_do_alloc_tx_skb(sk);
+		skb = __mptcp_do_alloc_tx_skb(sk, sk->sk_allocation);
 		if (unlikely(!skb)) {
 			/* under memory pressure, try to pass the caller a
 			 * single skb to allow forward progress
@@ -1187,7 +1184,7 @@ static bool mptcp_tx_cache_refill(struct sock *sk, int size,
 	return true;
 }
 
-static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
+static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, gfp_t gfp)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct sk_buff *skb;
@@ -1195,7 +1192,7 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
 	if (ssk->sk_tx_skb_cache) {
 		skb = ssk->sk_tx_skb_cache;
 		if (unlikely(!skb_ext_find(skb, SKB_EXT_MPTCP) &&
-			     !__mptcp_add_ext(skb, sk->sk_allocation)))
+			     !__mptcp_add_ext(skb, gfp)))
 			return false;
 		return true;
 	}
@@ -1216,7 +1213,7 @@ static bool __mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
 		return false;
 	}
 
-	skb = __mptcp_do_alloc_tx_skb(sk);
+	skb = __mptcp_do_alloc_tx_skb(sk, gfp);
 	if (!skb)
 		return false;
 
@@ -1239,7 +1236,7 @@ static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
 {
 	if (unlikely(mptcp_must_reclaim_memory(sk, ssk)))
 		mptcp_mem_reclaim_partial(sk);
-	return __mptcp_alloc_tx_skb(sk, ssk);
+	return __mptcp_alloc_tx_skb(sk, ssk, sk->sk_allocation);
 }
 
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
@@ -1340,31 +1337,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
-static void mptcp_nospace(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-
-	set_bit(MPTCP_NOSPACE, &msk->flags);
-	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
-
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool ssk_writeable = sk_stream_is_writeable(ssk);
-		struct socket *sock = READ_ONCE(ssk->sk_socket);
-
-		if (ssk_writeable || !sock)
-			continue;
-
-		/* enables ssk->write_space() callbacks */
-		set_bit(SOCK_NOSPACE, &sock->flags);
-	}
-
-	/* mptcp_data_acked() could run just before we set the NOSPACE bit,
-	 * so explicitly check for snd_una value
-	 */
-	mptcp_clean_una((struct sock *)msk);
-}
-
 #define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
 					 sizeof(struct tcphdr) - \
 					 MAX_TCP_OPTION_SPACE - \
@@ -1536,6 +1508,63 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 	}
 }
 
+static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_sendmsg_info info;
+	struct mptcp_data_frag *dfrag;
+	int len, copied = 0;
+
+	info.flags = 0;
+	while ((dfrag = mptcp_send_head(sk))) {
+		info.sent = dfrag->already_sent;
+		info.limit = dfrag->data_len;
+		len = dfrag->data_len - dfrag->already_sent;
+		while (len > 0) {
+			int ret = 0;
+
+			/* do auto tuning */
+			if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
+			    ssk->sk_sndbuf > READ_ONCE(sk->sk_sndbuf))
+				WRITE_ONCE(sk->sk_sndbuf, ssk->sk_sndbuf);
+
+			if (unlikely(mptcp_must_reclaim_memory(sk, ssk))) {
+				__mptcp_update_wmem(sk);
+				sk_mem_reclaim_partial(sk);
+			}
+			if (!__mptcp_alloc_tx_skb(sk, ssk, GFP_ATOMIC))
+				goto out;
+
+			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
+			if (ret <= 0)
+				goto out;
+
+			info.sent += ret;
+			dfrag->already_sent += ret;
+			msk->snd_nxt += ret;
+			msk->snd_burst -= ret;
+			msk->tx_pending_data -= ret;
+			copied += ret;
+			len -= ret;
+		}
+		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+	}
+
+out:
+	/* __mptcp_alloc_tx_skb could have released some wmem and we are
+	 * not going to flush it via release_sock()
+	 */
+	__mptcp_update_wmem(sk);
+	if (copied) {
+		mptcp_set_timeout(sk, ssk);
+		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
+			 info.size_goal);
+		if (msk->snd_data_fin_enable &&
+		    msk->snd_nxt + 1 == msk->write_seq)
+			mptcp_schedule_work(sk);
+	}
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1558,7 +1587,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	pfrag = sk_page_frag(sk);
-	mptcp_clean_una(sk);
 
 	while (msg_data_left(msg)) {
 		int total_ts, frag_truesize = 0;
@@ -1578,11 +1606,9 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		dfrag = mptcp_pending_tail(sk);
 		dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
 		if (!dfrag_collapsed) {
-			if (!sk_stream_memory_free(sk)) {
-				mptcp_push_pending(sk, msg->msg_flags);
-				if (!sk_stream_memory_free(sk))
-					goto wait_for_memory;
-			}
+			if (!sk_stream_memory_free(sk))
+				goto wait_for_memory;
+
 			if (!mptcp_page_frag_refill(sk, pfrag))
 				goto wait_for_memory;
 
@@ -1639,9 +1665,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		continue;
 
 wait_for_memory:
-		mptcp_nospace(msk);
-		if (mptcp_timer_pending(sk))
-			mptcp_reset_timer(sk);
+		set_bit(MPTCP_NOSPACE, &msk->flags);
+		mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
 			goto out;
@@ -2198,21 +2223,18 @@ static void mptcp_worker(struct work_struct *work)
 	if (unlikely(state == TCP_CLOSE))
 		goto unlock;
 
-	mptcp_clean_una_wakeup(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
 		__mptcp_close_subflow(msk);
 
-	if (mptcp_send_head(sk))
-		mptcp_push_pending(sk, 0);
-
 	if (msk->pm.status)
 		pm_work(msk);
 
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
 
+	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
 	/* if the msk data is completely acked, or the socket timedout,
@@ -2334,8 +2356,6 @@ static void __mptcp_clear_xmit(struct sock *sk)
 	struct mptcp_data_frag *dtmp, *dfrag;
 	struct sk_buff *skb;
 
-	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
-
 	WRITE_ONCE(msk->first_pending, NULL);
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
@@ -2477,7 +2497,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	spin_unlock_bh(&msk->join_list_lock);
 	list_splice_init(&msk->conn_list, &conn_list);
 
-	__mptcp_clear_xmit(sk);
+	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
 	sk_stop_timer(sk, &sk->sk_timer);
 	msk->pm.status = 0;
 
@@ -2709,6 +2729,8 @@ void mptcp_destroy_common(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 
+	__mptcp_clear_xmit(sk);
+
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
 
@@ -2835,6 +2857,28 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+void __mptcp_data_acked(struct sock *sk)
+{
+	if (!sock_owned_by_user(sk))
+		__mptcp_clean_una(sk);
+	else
+		set_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags);
+
+	if (mptcp_pending_data_fin_ack(sk))
+		mptcp_schedule_work(sk);
+}
+
+void __mptcp_wnd_updated(struct sock *sk, struct sock *ssk)
+{
+	if (!mptcp_send_head(sk))
+		return;
+
+	if (!sock_owned_by_user(sk))
+		__mptcp_subflow_push_pending(sk, ssk);
+	else
+		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+}
+
 #define MPTCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED)
 
 /* processes deferred events and flush wmem */
@@ -2842,6 +2886,25 @@ static void mptcp_release_cb(struct sock *sk)
 {
 	unsigned long flags, nflags;
 
+	/* push_pending may touch wmem_reserved, do it before the later
+	 * cleanup
+	 */
+	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
+		__mptcp_clean_una(sk);
+	if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags)) {
+		/* mptcp_push_pending() acquires the subflow socket lock
+		 *
+		 * 1) can't be invoked in atomic scope
+		 * 2) must avoid ABBA deadlock with msk socket spinlock: the RX
+		 *    datapath acquires the msk socket spinlock while helding
+		 *    the subflow socket lock
+		 */
+
+		spin_unlock_bh(&sk->sk_lock.slock);
+		mptcp_push_pending(sk, 0);
+		spin_lock_bh(&sk->sk_lock.slock);
+	}
+
 	/* clear any wmem reservation and errors */
 	__mptcp_update_wmem(sk);
 	__mptcp_update_rmem(sk);
@@ -3177,24 +3240,9 @@ static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
 	       0;
 }
 
-static bool __mptcp_check_writeable(struct mptcp_sock *msk)
-{
-	struct sock *sk = (struct sock *)msk;
-	bool mptcp_writable;
-
-	mptcp_clean_una(sk);
-	mptcp_writable = sk_stream_is_writeable(sk);
-	if (!mptcp_writable)
-		mptcp_nospace(msk);
-
-	return mptcp_writable;
-}
-
 static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
-	__poll_t ret = 0;
-	bool slow;
 
 	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
 		return 0;
@@ -3202,12 +3250,12 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
-	slow = lock_sock_fast(sk);
-	if (__mptcp_check_writeable(msk))
-		ret = EPOLLOUT | EPOLLWRNORM;
+	set_bit(MPTCP_NOSPACE, &msk->flags);
+	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
+	if (sk_stream_is_writeable(sk))
+		return EPOLLOUT | EPOLLWRNORM;
 
-	unlock_sock_fast(sk, slow);
-	return ret;
+	return 0;
 }
 
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3c07aafde10e..fc56e730fb35 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -91,6 +91,8 @@
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
+#define MPTCP_PUSH_PENDING	6
+#define MPTCP_CLEAN_UNA		7
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -495,6 +497,7 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
+void __mptcp_wnd_updated(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4d8abff1be18..e867ccf3adc0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -996,19 +996,9 @@ static void subflow_data_ready(struct sock *sk)
 		mptcp_data_ready(parent, sk);
 }
 
-static void subflow_write_space(struct sock *sk)
+static void subflow_write_space(struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	struct socket *sock = READ_ONCE(sk->sk_socket);
-	struct sock *parent = subflow->conn;
-
-	if (!sk_stream_is_writeable(sk))
-		return;
-
-	if (sock && sk_stream_is_writeable(parent))
-		clear_bit(SOCK_NOSPACE, &sock->flags);
-
-	sk_stream_write_space(parent);
+	/* we take action in __mptcp_clean_una() */
 }
 
 static struct inet_connection_sock_af_ops *
-- 
2.26.2

