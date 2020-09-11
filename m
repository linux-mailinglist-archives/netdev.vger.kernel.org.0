Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31BF266501
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIKQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:50:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59812 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726177AbgIKPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwknB12ZngXM3ass+Mnw8INfsDCdQd1GnwYLKGgZ+xI=;
        b=Z+Jt5khy11MLnrt85MOy2HCVcLMEwb4ICn9wbrpBvefkXHoEbusCeQwEfoybhme0wjhP+Z
        MTijx15la5NSr32lbaUGqZjJafkLB/Am9/aduE4bkh9AWWRqFFxezMaT6pToecYGAgOt/p
        iqtWKBWROYRrfjhOPXj3YosLTAtLz1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-h7vJKMs0MTKy_2WmwRMOGw-1; Fri, 11 Sep 2020 09:52:37 -0400
X-MC-Unique: h7vJKMs0MTKy_2WmwRMOGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D5D6AF201;
        Fri, 11 Sep 2020 13:52:36 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 511F55C22B;
        Fri, 11 Sep 2020 13:52:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 06/13] mptcp: move ooo skbs into msk out of order queue.
Date:   Fri, 11 Sep 2020 15:52:01 +0200
Message-Id: <906a26a2292583b90dc82e955d85fa1e0f3fddce.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an RB-tree to cope with OoO (at MPTCP level) data.
__mptcp_move_skb() insert into the RB tree "future"
data, eventually coalescing skb as allowed by the
MPTCP DSN.

To simplify sequence accounting, move the DSN inside
the cb.

After successfully enqueuing in sequence data, check
if we can use any data from the RB tree.

Additionally move the data_fin check after spooling
data from the OoO tree, otherwise we could miss shutdown
events.

The RB tree code is copied as verbatim as possible
from tcp_data_queue_ofo(), with a few simplifications
due to the fact that MPTCP doesn't need to cope with
sacks. All bugs here are added by me.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 264 ++++++++++++++++++++++++++++++++++---------
 net/mptcp/protocol.h |   2 +
 net/mptcp/subflow.c  |   1 +
 3 files changed, 211 insertions(+), 56 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5a2ff333e426..6fbfbab51660 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -32,6 +32,8 @@ struct mptcp6_sock {
 #endif
 
 struct mptcp_skb_cb {
+	u64 map_seq;
+	u64 end_seq;
 	u32 offset;
 };
 
@@ -110,6 +112,12 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	return 0;
 }
 
+static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
+{
+	sk_drops_add(sk, skb);
+	__kfree_skb(skb);
+}
+
 static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 			       struct sk_buff *from)
 {
@@ -120,16 +128,127 @@ static bool mptcp_try_coalesce(struct sock *sk, struct sk_buff *to,
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 
+	MPTCP_SKB_CB(to)->end_seq = MPTCP_SKB_CB(from)->end_seq;
 	kfree_skb_partial(from, fragstolen);
 	atomic_add(delta, &sk->sk_rmem_alloc);
 	sk_mem_charge(sk, delta);
 	return true;
 }
 
-static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
-			     struct sk_buff *skb,
-			     unsigned int offset, size_t copy_len)
+static bool mptcp_ooo_try_coalesce(struct mptcp_sock *msk, struct sk_buff *to,
+				   struct sk_buff *from)
+{
+	if (MPTCP_SKB_CB(from)->map_seq != MPTCP_SKB_CB(to)->end_seq)
+		return false;
+
+	return mptcp_try_coalesce((struct sock *)msk, to, from);
+}
+
+/* "inspired" by tcp_data_queue_ofo(), main differences:
+ * - use mptcp seqs
+ * - don't cope with sacks
+ */
+static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 {
+	struct sock *sk = (struct sock *)msk;
+	struct rb_node **p, *parent;
+	u64 seq, end_seq, max_seq;
+	struct sk_buff *skb1;
+
+	seq = MPTCP_SKB_CB(skb)->map_seq;
+	end_seq = MPTCP_SKB_CB(skb)->end_seq;
+	max_seq = tcp_space(sk);
+	max_seq = max_seq > 0 ? max_seq + msk->ack_seq : msk->ack_seq;
+
+	if (after64(seq, max_seq)) {
+		/* out of window */
+		mptcp_drop(sk, skb);
+		return;
+	}
+
+	p = &msk->out_of_order_queue.rb_node;
+	if (RB_EMPTY_ROOT(&msk->out_of_order_queue)) {
+		rb_link_node(&skb->rbnode, NULL, p);
+		rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
+		msk->ooo_last_skb = skb;
+		goto end;
+	}
+
+	/* with 2 subflows, adding at end of ooo queue is quite likely
+	 * Use of ooo_last_skb avoids the O(Log(N)) rbtree lookup.
+	 */
+	if (mptcp_ooo_try_coalesce(msk, msk->ooo_last_skb, skb))
+		return;
+
+	/* Can avoid an rbtree lookup if we are adding skb after ooo_last_skb */
+	if (!before64(seq, MPTCP_SKB_CB(msk->ooo_last_skb)->end_seq)) {
+		parent = &msk->ooo_last_skb->rbnode;
+		p = &parent->rb_right;
+		goto insert;
+	}
+
+	/* Find place to insert this segment. Handle overlaps on the way. */
+	parent = NULL;
+	while (*p) {
+		parent = *p;
+		skb1 = rb_to_skb(parent);
+		if (before64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
+			p = &parent->rb_left;
+			continue;
+		}
+		if (before64(seq, MPTCP_SKB_CB(skb1)->end_seq)) {
+			if (!after64(end_seq, MPTCP_SKB_CB(skb1)->end_seq)) {
+				/* All the bits are present. Drop. */
+				mptcp_drop(sk, skb);
+				return;
+			}
+			if (after64(seq, MPTCP_SKB_CB(skb1)->map_seq)) {
+				/* partial overlap:
+				 *     |     skb      |
+				 *  |     skb1    |
+				 * continue traversing
+				 */
+			} else {
+				/* skb's seq == skb1's seq and skb covers skb1.
+				 * Replace skb1 with skb.
+				 */
+				rb_replace_node(&skb1->rbnode, &skb->rbnode,
+						&msk->out_of_order_queue);
+				mptcp_drop(sk, skb1);
+				goto merge_right;
+			}
+		} else if (mptcp_ooo_try_coalesce(msk, skb1, skb)) {
+			return;
+		}
+		p = &parent->rb_right;
+	}
+insert:
+	/* Insert segment into RB tree. */
+	rb_link_node(&skb->rbnode, parent, p);
+	rb_insert_color(&skb->rbnode, &msk->out_of_order_queue);
+
+merge_right:
+	/* Remove other segments covered by skb. */
+	while ((skb1 = skb_rb_next(skb)) != NULL) {
+		if (before64(end_seq, MPTCP_SKB_CB(skb1)->end_seq))
+			break;
+		rb_erase(&skb1->rbnode, &msk->out_of_order_queue);
+		mptcp_drop(sk, skb1);
+	}
+	/* If there is no skb after us, we are the last_skb ! */
+	if (!skb1)
+		msk->ooo_last_skb = skb;
+
+end:
+	skb_condense(skb);
+	skb_set_owner_r(skb, sk);
+}
+
+static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
+			     struct sk_buff *skb, unsigned int offset,
+			     size_t copy_len)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = (struct sock *)msk;
 	struct sk_buff *tail;
 
@@ -137,15 +256,35 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 
 	skb_ext_reset(skb);
 	skb_orphan(skb);
+
+	/* the skb map_seq accounts for the skb offset:
+	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
+	 * value
+	 */
+	MPTCP_SKB_CB(skb)->map_seq = mptcp_subflow_get_mapped_dsn(subflow);
+	MPTCP_SKB_CB(skb)->end_seq = MPTCP_SKB_CB(skb)->map_seq + copy_len;
 	MPTCP_SKB_CB(skb)->offset = offset;
-	msk->ack_seq += copy_len;
 
-	tail = skb_peek_tail(&sk->sk_receive_queue);
-	if (tail && mptcp_try_coalesce(sk, tail, skb))
-		return;
+	if (MPTCP_SKB_CB(skb)->map_seq == msk->ack_seq) {
+		/* in sequence */
+		msk->ack_seq += copy_len;
+		tail = skb_peek_tail(&sk->sk_receive_queue);
+		if (tail && mptcp_try_coalesce(sk, tail, skb))
+			return true;
 
-	skb_set_owner_r(skb, sk);
-	__skb_queue_tail(&sk->sk_receive_queue, skb);
+		skb_set_owner_r(skb, sk);
+		__skb_queue_tail(&sk->sk_receive_queue, skb);
+		return true;
+	} else if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq)) {
+		mptcp_data_queue_ofo(msk, skb);
+		return false;
+	}
+
+	/* old data, keep it simple and drop the whole pkt, sender
+	 * will retransmit as needed, if needed.
+	 */
+	mptcp_drop(sk, skb);
+	return false;
 }
 
 static void mptcp_stop_timer(struct sock *sk)
@@ -156,28 +295,6 @@ static void mptcp_stop_timer(struct sock *sk)
 	mptcp_sk(sk)->timer_ival = 0;
 }
 
-/* both sockets must be locked */
-static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
-				    struct sock *ssk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
-	u64 dsn = mptcp_subflow_get_mapped_dsn(subflow);
-
-	/* revalidate data sequence number.
-	 *
-	 * mptcp_subflow_data_available() is usually called
-	 * without msk lock.  Its unlikely (but possible)
-	 * that msk->ack_seq has been advanced since the last
-	 * call found in-sequence data.
-	 */
-	if (likely(dsn == msk->ack_seq))
-		return true;
-
-	subflow->data_avail = 0;
-	mptcp_subflow_data_available(ssk);
-	return subflow->data_avail == MPTCP_SUBFLOW_DATA_AVAIL;
-}
-
 static void mptcp_check_data_fin_ack(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -321,18 +438,7 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	struct tcp_sock *tp;
 	bool done = false;
 
-	pr_debug("msk=%p ssk=%p data avail=%d valid=%d empty=%d",
-		 msk, ssk, subflow->data_avail,
-		 mptcp_subflow_dsn_valid(msk, ssk),
-		 !skb_peek(&ssk->sk_receive_queue));
-	if (subflow->data_avail == MPTCP_SUBFLOW_OOO_DATA) {
-		mptcp_subflow_discard_data(ssk, subflow->map_data_len);
-		return false;
-	}
-
-	if (!mptcp_subflow_dsn_valid(msk, ssk))
-		return false;
-
+	pr_debug("msk=%p ssk=%p", msk, ssk);
 	tp = tcp_sk(ssk);
 	do {
 		u32 map_remaining, offset;
@@ -370,9 +476,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 			if (tp->urg_data)
 				done = true;
 
-			__mptcp_move_skb(msk, ssk, skb, offset, len);
+			if (__mptcp_move_skb(msk, ssk, skb, offset, len))
+				moved += len;
 			seq += len;
-			moved += len;
 
 			if (WARN_ON_ONCE(map_remaining < len))
 				break;
@@ -393,18 +499,47 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 	*bytes += moved;
 
-	/* If the moves have caught up with the DATA_FIN sequence number
-	 * it's time to ack the DATA_FIN and change socket state, but
-	 * this is not a good place to change state. Let the workqueue
-	 * do it.
-	 */
-	if (mptcp_pending_data_fin(sk, NULL) &&
-	    schedule_work(&msk->work))
-		sock_hold(sk);
-
 	return done;
 }
 
+static bool mptcp_ofo_queue(struct mptcp_sock *msk)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct sk_buff *skb, *tail;
+	bool moved = false;
+	struct rb_node *p;
+	u64 end_seq;
+
+	p = rb_first(&msk->out_of_order_queue);
+	while (p) {
+		skb = rb_to_skb(p);
+		if (after64(MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq))
+			break;
+
+		p = rb_next(p);
+		rb_erase(&skb->rbnode, &msk->out_of_order_queue);
+
+		if (unlikely(!after64(MPTCP_SKB_CB(skb)->end_seq,
+				      msk->ack_seq))) {
+			mptcp_drop(sk, skb);
+			continue;
+		}
+
+		end_seq = MPTCP_SKB_CB(skb)->end_seq;
+		tail = skb_peek_tail(&sk->sk_receive_queue);
+		if (!tail || !mptcp_ooo_try_coalesce(msk, tail, skb)) {
+			int delta = msk->ack_seq - MPTCP_SKB_CB(skb)->map_seq;
+
+			/* skip overlapping data, if any */
+			MPTCP_SKB_CB(skb)->offset += delta;
+			__skb_queue_tail(&sk->sk_receive_queue, skb);
+		}
+		msk->ack_seq = end_seq;
+		moved = true;
+	}
+	return moved;
+}
+
 /* In most cases we will be able to lock the mptcp socket.  If its already
  * owned, we need to defer to the work queue to avoid ABBA deadlock.
  */
@@ -420,8 +555,19 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 		return false;
 
 	/* must re-check after taking the lock */
-	if (!READ_ONCE(sk->sk_lock.owned))
+	if (!READ_ONCE(sk->sk_lock.owned)) {
 		__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+		mptcp_ofo_queue(msk);
+
+		/* If the moves have caught up with the DATA_FIN sequence number
+		 * it's time to ack the DATA_FIN and change socket state, but
+		 * this is not a good place to change state. Let the workqueue
+		 * do it.
+		 */
+		if (mptcp_pending_data_fin(sk, NULL) &&
+		    schedule_work(&msk->work))
+			sock_hold(sk);
+	}
 
 	spin_unlock_bh(&sk->sk_lock.slock);
 
@@ -1218,7 +1364,11 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 		release_sock(ssk);
 	} while (!done);
 
-	return moved > 0;
+	if (mptcp_ofo_queue(msk) || moved > 0) {
+		mptcp_check_data_fin((struct sock *)msk);
+		return true;
+	}
+	return false;
 }
 
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
@@ -1530,6 +1680,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->rtx_queue);
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 	INIT_WORK(&msk->work, mptcp_worker);
+	msk->out_of_order_queue = RB_ROOT;
 
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
@@ -1869,6 +2020,7 @@ static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	skb_rbtree_purge(&msk->out_of_order_queue);
 	mptcp_token_destroy(msk);
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 981e395abb46..e20154a33fa7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -204,6 +204,8 @@ struct mptcp_sock {
 	bool		snd_data_fin_enable;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
+	struct sk_buff  *ooo_last_skb;
+	struct rb_root  out_of_order_queue;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct list_head join_list;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a983beb8e6a6..1f048a5bf120 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -434,6 +434,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
+	skb_rbtree_purge(&mptcp_sk(sk)->out_of_order_queue);
 	mptcp_token_destroy(mptcp_sk(sk));
 	inet_sock_destruct(sk);
 }
-- 
2.26.2

