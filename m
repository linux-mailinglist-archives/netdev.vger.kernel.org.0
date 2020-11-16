Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F332B403A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgKPJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728708AbgKPJst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTSBwQXiC13Etl9BnDTpIDjHC71fur5JT2ezOV9lA4k=;
        b=Be8K7+FXflRf2Fy+W1e9hTBm0Gs+Itkaq/j+DrCaMMRyL9vJ6zcwtg9Yzl8F8IsuK9g/ra
        XrMvp0vusl1aZROz9m7D7ooS1V0pqxpp8Bt/yBXbqoxZ3hQrsNkLlcpaqgqyBNYrJJva0S
        5KE/ZmluVOUkjYqI740uh6yz12Nf7mA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-pXI9quPXOWStPYaHOVA88A-1; Mon, 16 Nov 2020 04:48:44 -0500
X-MC-Unique: pXI9quPXOWStPYaHOVA88A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 637DC1018749;
        Mon, 16 Nov 2020 09:48:43 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02F3F1002C1B;
        Mon, 16 Nov 2020 09:48:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 09/13] mptcp: move page frag allocation in mptcp_sendmsg()
Date:   Mon, 16 Nov 2020 10:48:10 +0100
Message-Id: <6a8432957c7969587efe44146f24eccb0b4bf9f8.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_sendmsg() is refactored so that first it copies
the data provided from user space into the send queue,
and then tries to spool the send queue via sendmsg_frag.

There a subtle change in the mptcp level collapsing on
consecutive data fragment: we now allow that only on unsent
data.

The latter don't need to deal with msghdr data anymore
and can be simplified in a relevant way.

snd_nxt and write_seq are now tracked independently.

Overall this allows some relevant cleanup and will
allow sending pending mptcp data on msk una update in
later patch.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 406 ++++++++++++++++++++-----------------------
 1 file changed, 189 insertions(+), 217 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index daa51e657db8..9b30c4b39159 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -43,6 +43,7 @@ struct mptcp_skb_cb {
 static struct percpu_counter mptcp_sockets_allocated;
 
 static void __mptcp_destroy_sock(struct sock *sk);
+static void __mptcp_check_send_data_fin(struct sock *sk);
 
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
@@ -814,6 +815,7 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 				       const struct mptcp_data_frag *df)
 {
 	return df && pfrag->page == df->page &&
+		pfrag->size - pfrag->offset > 0 &&
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
@@ -864,6 +866,8 @@ static void mptcp_clean_una(struct sock *sk)
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
 			break;
 
+		if (WARN_ON_ONCE(dfrag == msk->first_pending))
+			break;
 		dfrag_clear(sk, dfrag);
 		cleaned = true;
 	}
@@ -872,12 +876,13 @@ static void mptcp_clean_una(struct sock *sk)
 	if (dfrag && after64(snd_una, dfrag->data_seq)) {
 		u64 delta = snd_una - dfrag->data_seq;
 
-		if (WARN_ON_ONCE(delta > dfrag->data_len))
+		if (WARN_ON_ONCE(delta > dfrag->already_sent))
 			goto out;
 
 		dfrag->data_seq += delta;
 		dfrag->offset += delta;
 		dfrag->data_len -= delta;
+		dfrag->already_sent -= delta;
 
 		dfrag_uncharge(sk, delta);
 		cleaned = true;
@@ -911,12 +916,23 @@ static void mptcp_clean_una_wakeup(struct sock *sk)
  */
 static bool mptcp_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 {
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool first = true;
+
 	if (likely(skb_page_frag_refill(32U + sizeof(struct mptcp_data_frag),
 					pfrag, sk->sk_allocation)))
 		return true;
 
-	sk->sk_prot->enter_memory_pressure(sk);
 	sk_stream_moderate_sndbuf(sk);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		if (first)
+			tcp_enter_memory_pressure(ssk);
+		sk_stream_moderate_sndbuf(ssk);
+		first = false;
+	}
 	return false;
 }
 
@@ -932,6 +948,7 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 	dfrag->data_seq = msk->write_seq;
 	dfrag->overhead = offset - orig_offset + sizeof(struct mptcp_data_frag);
 	dfrag->offset = offset + sizeof(struct mptcp_data_frag);
+	dfrag->already_sent = 0;
 	dfrag->page = pfrag->page;
 
 	return dfrag;
@@ -940,121 +957,58 @@ mptcp_carve_data_frag(const struct mptcp_sock *msk, struct page_frag *pfrag,
 struct mptcp_sendmsg_info {
 	int mss_now;
 	int size_goal;
+	u16 limit;
+	u16 sent;
+	unsigned int flags;
 };
 
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
-			      struct msghdr *msg, struct mptcp_data_frag *dfrag,
+			      struct mptcp_data_frag *dfrag,
 			      struct mptcp_sendmsg_info *info)
 {
-	int avail_size, offset, ret, frag_truesize = 0;
-	bool dfrag_collapsed, can_collapse = false;
+	u64 data_seq = dfrag->data_seq + info->sent;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_ext *mpext = NULL;
-	bool retransmission = !!dfrag;
 	struct sk_buff *skb, *tail;
-	struct page_frag *pfrag;
-	struct page *page;
-	u64 *write_seq;
-	size_t psize;
-
-	/* use the mptcp page cache so that we can easily move the data
-	 * from one substream to another, but do per subflow memory accounting
-	 * Note: pfrag is used only !retransmission, but the compiler if
-	 * fooled into a warning if we don't init here
-	 */
-	pfrag = sk_page_frag(sk);
-	if (!retransmission) {
-		write_seq = &msk->write_seq;
-		page = pfrag->page;
-	} else {
-		write_seq = &dfrag->data_seq;
-		page = dfrag->page;
-	}
+	bool can_collapse = false;
+	int avail_size;
+	size_t ret;
 
-	/* compute copy limit */
-	info->mss_now = tcp_send_mss(ssk, &info->size_goal, msg->msg_flags);
+	pr_debug("msk=%p ssk=%p sending dfrag at seq=%lld len=%d already sent=%d",
+		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
+
+	/* compute send limit */
+	info->mss_now = tcp_send_mss(ssk, &info->size_goal, info->flags);
 	avail_size = info->size_goal;
 	skb = tcp_write_queue_tail(ssk);
 	if (skb) {
-		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
-
 		/* Limit the write to the size available in the
 		 * current skb, if any, so that we create at most a new skb.
 		 * Explicitly tells TCP internals to avoid collapsing on later
 		 * queue management operation, to avoid breaking the ext <->
 		 * SSN association set here
 		 */
+		mpext = skb_ext_find(skb, SKB_EXT_MPTCP);
 		can_collapse = (info->size_goal - skb->len > 0) &&
-			      mptcp_skb_can_collapse_to(*write_seq, skb, mpext);
+			 mptcp_skb_can_collapse_to(data_seq, skb, mpext);
 		if (!can_collapse)
 			TCP_SKB_CB(skb)->eor = 1;
 		else
 			avail_size = info->size_goal - skb->len;
 	}
 
-	if (!retransmission) {
-		/* reuse tail pfrag, if possible, or carve a new one from the
-		 * page allocator
-		 */
-		dfrag = mptcp_rtx_tail(sk);
-		offset = pfrag->offset;
-		dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
-		if (!dfrag_collapsed) {
-			dfrag = mptcp_carve_data_frag(msk, pfrag, offset);
-			offset = dfrag->offset;
-			frag_truesize = dfrag->overhead;
-		}
-		psize = min_t(size_t, pfrag->size - offset, avail_size);
-
-		/* Copy to page */
-		pr_debug("left=%zu", msg_data_left(msg));
-		psize = copy_page_from_iter(pfrag->page, offset,
-					    min_t(size_t, msg_data_left(msg),
-						  psize),
-					    &msg->msg_iter);
-		pr_debug("left=%zu", msg_data_left(msg));
-		if (!psize)
-			return -EINVAL;
+	if (WARN_ON_ONCE(info->sent > info->limit ||
+			 info->limit > dfrag->data_len))
+		return 0;
 
-		if (!sk_wmem_schedule(sk, psize + dfrag->overhead)) {
-			iov_iter_revert(&msg->msg_iter, psize);
-			return -ENOMEM;
-		}
-	} else {
-		offset = dfrag->offset;
-		psize = min_t(size_t, dfrag->data_len, avail_size);
-	}
-
-	tail = tcp_build_frag(ssk, psize, msg->msg_flags, page, offset, &psize);
+	ret = info->limit - info->sent;
+	tail = tcp_build_frag(ssk, avail_size, info->flags, dfrag->page,
+			      dfrag->offset + info->sent, &ret);
 	if (!tail) {
 		tcp_remove_empty_skb(sk, tcp_write_queue_tail(ssk));
 		return -ENOMEM;
 	}
 
-	ret = psize;
-	frag_truesize += ret;
-	if (!retransmission) {
-		if (unlikely(ret < psize))
-			iov_iter_revert(&msg->msg_iter, psize - ret);
-
-		/* send successful, keep track of sent data for mptcp-level
-		 * retransmission
-		 */
-		dfrag->data_len += ret;
-		if (!dfrag_collapsed) {
-			get_page(dfrag->page);
-			list_add_tail(&dfrag->list, &msk->rtx_queue);
-			sk_wmem_queued_add(sk, frag_truesize);
-		} else {
-			sk_wmem_queued_add(sk, ret);
-		}
-
-		/* charge data on mptcp rtx queue to the master socket
-		 * Note: we charge such data both to sk and ssk
-		 */
-		sk->sk_forward_alloc -= frag_truesize;
-	}
-
 	/* if the tail skb is still the cached one, collapsing really happened.
 	 */
 	if (skb == tail) {
@@ -1067,7 +1021,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	msk->cached_ext = NULL;
 
 	memset(mpext, 0, sizeof(*mpext));
-	mpext->data_seq = *write_seq;
+	mpext->data_seq = data_seq;
 	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
 	mpext->data_len = ret;
 	mpext->use_map = 1;
@@ -1078,11 +1032,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->dsn64);
 
 out:
-	if (!retransmission)
-		pfrag->offset += frag_truesize;
-	WRITE_ONCE(*write_seq, *write_seq + ret);
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
-
 	return ret;
 }
 
@@ -1210,19 +1160,86 @@ static void ssk_check_wmem(struct mptcp_sock *msk)
 		mptcp_nospace(msk);
 }
 
-static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+static void mptcp_push_release(struct sock *sk, struct sock *ssk,
+			       struct mptcp_sendmsg_info *info)
+{
+	mptcp_set_timeout(sk, ssk);
+	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
+	release_sock(ssk);
+}
+
+static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
+	struct sock *prev_ssk = NULL, *ssk = NULL;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_sendmsg_info info = {
-		.mss_now = 0,
-		.size_goal = 0,
+				.flags = flags,
 	};
+	struct mptcp_data_frag *dfrag;
+	int len, copied = 0;
+	u32 sndbuf;
+
+	while ((dfrag = mptcp_send_head(sk))) {
+		info.sent = dfrag->already_sent;
+		info.limit = dfrag->data_len;
+		len = dfrag->data_len - dfrag->already_sent;
+		while (len > 0) {
+			int ret = 0;
+
+			prev_ssk = ssk;
+			__mptcp_flush_join_list(msk);
+			ssk = mptcp_subflow_get_send(msk, &sndbuf);
+
+			/* do auto tuning */
+			if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
+			    sndbuf > READ_ONCE(sk->sk_sndbuf))
+				WRITE_ONCE(sk->sk_sndbuf, sndbuf);
+
+			/* try to keep the subflow socket lock across
+			 * consecutive xmit on the same socket
+			 */
+			if (ssk != prev_ssk && prev_ssk)
+				mptcp_push_release(sk, prev_ssk, &info);
+			if (!ssk)
+				goto out;
+
+			if (ssk != prev_ssk || !prev_ssk)
+				lock_sock(ssk);
+
+			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
+			if (ret <= 0) {
+				mptcp_push_release(sk, ssk, &info);
+				goto out;
+			}
+
+			info.sent += ret;
+			dfrag->already_sent += ret;
+			msk->snd_nxt += ret;
+			msk->snd_burst -= ret;
+			copied += ret;
+			len -= ret;
+		}
+		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+	}
+
+	/* at this point we held the socket lock for the last subflow we used */
+	if (ssk)
+		mptcp_push_release(sk, ssk, &info);
+
+out:
+	/* start the timer, if it's not pending */
+	if (!mptcp_timer_pending(sk))
+		mptcp_reset_timer(sk);
+	if (copied)
+		__mptcp_check_send_data_fin(sk);
+}
+
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct page_frag *pfrag;
 	size_t copied = 0;
-	struct sock *ssk;
 	int ret = 0;
-	u32 sndbuf;
-	bool tx_ok;
 	long timeo;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
@@ -1239,129 +1256,93 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	pfrag = sk_page_frag(sk);
-restart:
 	mptcp_clean_una(sk);
 
-	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN)) {
-		ret = -EPIPE;
-		goto out;
-	}
-
-	__mptcp_flush_join_list(msk);
-	ssk = mptcp_subflow_get_send(msk, &sndbuf);
-	while (!sk_stream_memory_free(sk) ||
-	       !ssk ||
-	       !mptcp_page_frag_refill(ssk, pfrag)) {
-		if (ssk) {
-			/* make sure retransmit timer is
-			 * running before we wait for memory.
-			 *
-			 * The retransmit timer might be needed
-			 * to make the peer send an up-to-date
-			 * MPTCP Ack.
-			 */
-			mptcp_set_timeout(sk, ssk);
-			if (!mptcp_timer_pending(sk))
-				mptcp_reset_timer(sk);
-		}
-
-		mptcp_nospace(msk);
-		ret = sk_stream_wait_memory(sk, &timeo);
-		if (ret)
-			goto out;
-
-		mptcp_clean_una(sk);
+	while (msg_data_left(msg)) {
+		struct mptcp_data_frag *dfrag;
+		int frag_truesize = 0;
+		bool dfrag_collapsed;
+		size_t psize, offset;
 
-		ssk = mptcp_subflow_get_send(msk, &sndbuf);
-		if (list_empty(&msk->conn_list)) {
-			ret = -ENOTCONN;
+		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN)) {
+			ret = -EPIPE;
 			goto out;
 		}
-	}
 
-	/* do auto tuning */
-	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
-	    sndbuf > READ_ONCE(sk->sk_sndbuf))
-		WRITE_ONCE(sk->sk_sndbuf, sndbuf);
-
-	pr_debug("conn_list->subflow=%p", ssk);
-
-	lock_sock(ssk);
-	tx_ok = msg_data_left(msg);
-	while (tx_ok) {
-		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &info);
-		if (ret < 0) {
-			if (ret == -EAGAIN && timeo > 0) {
-				mptcp_set_timeout(sk, ssk);
-				release_sock(ssk);
-				goto restart;
+		/* reuse tail pfrag, if possible, or carve a new one from the
+		 * page allocator
+		 */
+		dfrag = mptcp_pending_tail(sk);
+		dfrag_collapsed = mptcp_frag_can_collapse_to(msk, pfrag, dfrag);
+		if (!dfrag_collapsed) {
+			if (!sk_stream_memory_free(sk)) {
+				mptcp_push_pending(sk, msg->msg_flags);
+				if (!sk_stream_memory_free(sk))
+					goto wait_for_memory;
 			}
-			break;
+			if (!mptcp_page_frag_refill(sk, pfrag))
+				goto wait_for_memory;
+
+			dfrag = mptcp_carve_data_frag(msk, pfrag, pfrag->offset);
+			frag_truesize = dfrag->overhead;
 		}
 
-		/* burst can be negative, we will try move to the next subflow
-		 * at selection time, if possible.
+		/* we do not bound vs wspace, to allow a single packet.
+		 * memory accounting will prevent execessive memory usage
+		 * anyway
 		 */
-		msk->snd_burst -= ret;
-		copied += ret;
-
-		tx_ok = msg_data_left(msg);
-		if (!tx_ok)
-			break;
-
-		if (!sk_stream_memory_free(ssk) ||
-		    !mptcp_page_frag_refill(ssk, pfrag) ||
-		    !mptcp_ext_cache_refill(msk)) {
-			tcp_push(ssk, msg->msg_flags, info.mss_now,
-				 tcp_sk(ssk)->nonagle, info.size_goal);
-			mptcp_set_timeout(sk, ssk);
-			release_sock(ssk);
-			goto restart;
+		offset = dfrag->offset + dfrag->data_len;
+		psize = pfrag->size - offset;
+		psize = min_t(size_t, psize, msg_data_left(msg));
+		if (!sk_wmem_schedule(sk, psize + frag_truesize))
+			goto wait_for_memory;
+
+		if (copy_page_from_iter(dfrag->page, offset, psize,
+					&msg->msg_iter) != psize) {
+			ret = -EFAULT;
+			goto out;
 		}
 
-		/* memory is charged to mptcp level socket as well, i.e.
-		 * if msg is very large, mptcp socket may run out of buffer
-		 * space.  mptcp_clean_una() will release data that has
-		 * been acked at mptcp level in the mean time, so there is
-		 * a good chance we can continue sending data right away.
-		 *
-		 * Normally, when the tcp subflow can accept more data, then
-		 * so can the MPTCP socket.  However, we need to cope with
-		 * peers that might lag behind in their MPTCP-level
-		 * acknowledgements, i.e.  data might have been acked at
-		 * tcp level only.  So, we must also check the MPTCP socket
-		 * limits before we send more data.
+		/* data successfully copied into the write queue */
+		copied += psize;
+		dfrag->data_len += psize;
+		frag_truesize += psize;
+		pfrag->offset += frag_truesize;
+		WRITE_ONCE(msk->write_seq, msk->write_seq + psize);
+
+		/* charge data on mptcp pending queue to the msk socket
+		 * Note: we charge such data both to sk and ssk
 		 */
-		if (unlikely(!sk_stream_memory_free(sk))) {
-			tcp_push(ssk, msg->msg_flags, info.mss_now,
-				 tcp_sk(ssk)->nonagle, info.size_goal);
-			mptcp_clean_una(sk);
-			if (!sk_stream_memory_free(sk)) {
-				/* can't send more for now, need to wait for
-				 * MPTCP-level ACKs from peer.
-				 *
-				 * Wakeup will happen via mptcp_clean_una().
-				 */
-				mptcp_set_timeout(sk, ssk);
-				release_sock(ssk);
-				goto restart;
-			}
+		sk_wmem_queued_add(sk, frag_truesize);
+		sk->sk_forward_alloc -= frag_truesize;
+		if (!dfrag_collapsed) {
+			get_page(dfrag->page);
+			list_add_tail(&dfrag->list, &msk->rtx_queue);
+			if (!msk->first_pending)
+				WRITE_ONCE(msk->first_pending, dfrag);
 		}
-	}
+		pr_debug("msk=%p dfrag at seq=%lld len=%d sent=%d new=%d", msk,
+			 dfrag->data_seq, dfrag->data_len, dfrag->already_sent,
+			 !dfrag_collapsed);
 
-	mptcp_set_timeout(sk, ssk);
-	if (copied) {
-		tcp_push(ssk, msg->msg_flags, info.mss_now,
-			 tcp_sk(ssk)->nonagle, info.size_goal);
+		if (!mptcp_ext_cache_refill(msk))
+			goto wait_for_memory;
+		continue;
 
-		/* start the timer, if it's not pending */
-		if (!mptcp_timer_pending(sk))
+wait_for_memory:
+		mptcp_nospace(msk);
+		mptcp_clean_una(sk);
+		if (mptcp_timer_pending(sk))
 			mptcp_reset_timer(sk);
+		ret = sk_stream_wait_memory(sk, &timeo);
+		if (ret)
+			goto out;
 	}
 
-	release_sock(ssk);
+	if (copied)
+		mptcp_push_pending(sk, msg->msg_flags);
+
 out:
-	msk->snd_nxt = msk->write_seq;
 	ssk_check_wmem(msk);
 	release_sock(sk);
 	return copied ? : ret;
@@ -1700,7 +1681,7 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 	sock_owned_by_me((const struct sock *)msk);
 
 	if (__mptcp_check_fallback(msk))
-		return msk->first;
+		return NULL;
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
@@ -1843,12 +1824,7 @@ static void mptcp_worker(struct work_struct *work)
 	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
 	struct mptcp_sendmsg_info info = {};
 	struct mptcp_data_frag *dfrag;
-	int orig_len, orig_offset;
-	u64 orig_write_seq;
 	size_t copied = 0;
-	struct msghdr msg = {
-		.msg_flags = MSG_DONTWAIT,
-	};
 	int state, ret;
 
 	lock_sock(sk);
@@ -1901,18 +1877,17 @@ static void mptcp_worker(struct work_struct *work)
 
 	lock_sock(ssk);
 
-	orig_len = dfrag->data_len;
-	orig_offset = dfrag->offset;
-	orig_write_seq = dfrag->data_seq;
-	while (dfrag->data_len > 0) {
-		ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &info);
+	/* limit retransmission to the bytes already sent on some subflows */
+	info.sent = 0;
+	info.limit = dfrag->already_sent;
+	while (info.sent < dfrag->already_sent) {
+		ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 		if (ret < 0)
 			break;
 
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RETRANSSEGS);
 		copied += ret;
-		dfrag->data_len -= ret;
-		dfrag->offset += ret;
+		info.sent += ret;
 
 		if (!mptcp_ext_cache_refill(msk))
 			break;
@@ -1921,10 +1896,6 @@ static void mptcp_worker(struct work_struct *work)
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
 
-	dfrag->data_seq = orig_write_seq;
-	dfrag->offset = orig_offset;
-	dfrag->data_len = orig_len;
-
 	mptcp_set_timeout(sk, ssk);
 	release_sock(ssk);
 
@@ -1996,6 +1967,7 @@ static void __mptcp_clear_xmit(struct sock *sk)
 
 	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
 
+	WRITE_ONCE(msk->first_pending, NULL);
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
 }
-- 
2.26.2

