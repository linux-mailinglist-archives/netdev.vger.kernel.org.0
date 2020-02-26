Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94C16FA66
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBZJPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:16 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60768 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbgBZJPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:16 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smf-0001Mp-Kf; Wed, 26 Feb 2020 10:15:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/7] mptcp: update mptcp ack sequence from work queue
Date:   Wed, 26 Feb 2020 10:14:48 +0100
Message-Id: <20200226091452.1116-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If userspace is not reading data, all the mptcp-level acks contain the
ack_seq from the last time userspace read data rather than the most
recent in-sequence value.

This causes pointless retransmissions for data that is already queued.

The reason for this is that all the mptcp protocol level processing
happens at mptcp_recv time.

This adds work queue to move skbs from the subflow sockets receive
queue on the mptcp socket receive queue (which was not used so far).

This allows us to announce the correct mptcp ack sequence in a timely
fashion, even when the application does not call recv() on the mptcp socket
for some time.

We still wake userspace tasks waiting for POLLIN immediately:
If the mptcp level receive queue is empty (because the work queue is
still pending) it can be filled from in-sequence subflow sockets at
recv time without a need to wait for the worker.

The skb_orphan when moving skbs from subflow to mptcp level is needed,
because the destructor (sock_rfree) relies on skb->sk (ssk!) lock
being taken.

A followup patch will add needed rmem accouting for the moved skbs.

Other problem: In case application behaves as expected, and calls
recv() as soon as mptcp socket becomes readable, the work queue will
only waste cpu cycles.  This will also be addressed in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 234 ++++++++++++++++++++++++++++++-------------
 1 file changed, 165 insertions(+), 69 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cbf184a71ed7..b4a8517d8eac 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -31,6 +31,12 @@ struct mptcp6_sock {
 };
 #endif
 
+struct mptcp_skb_cb {
+	u32 offset;
+};
+
+#define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -111,11 +117,88 @@ static struct sock *mptcp_subflow_get(const struct mptcp_sock *msk)
 	return NULL;
 }
 
+static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
+			     struct sk_buff *skb,
+			     unsigned int offset, size_t copy_len)
+{
+	struct sock *sk = (struct sock *)msk;
+
+	__skb_unlink(skb, &ssk->sk_receive_queue);
+	skb_orphan(skb);
+	__skb_queue_tail(&sk->sk_receive_queue, skb);
+
+	msk->ack_seq += copy_len;
+	MPTCP_SKB_CB(skb)->offset = offset;
+}
+
+static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
+					   struct sock *ssk,
+					   unsigned int *bytes)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	unsigned int moved = 0;
+	bool more_data_avail;
+	struct tcp_sock *tp;
+	bool done = false;
+
+	tp = tcp_sk(ssk);
+	do {
+		u32 map_remaining, offset;
+		u32 seq = tp->copied_seq;
+		struct sk_buff *skb;
+		bool fin;
+
+		/* try to move as much data as available */
+		map_remaining = subflow->map_data_len -
+				mptcp_subflow_get_map_offset(subflow);
+
+		skb = skb_peek(&ssk->sk_receive_queue);
+		if (!skb)
+			break;
+
+		offset = seq - TCP_SKB_CB(skb)->seq;
+		fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
+		if (fin) {
+			done = true;
+			seq++;
+		}
+
+		if (offset < skb->len) {
+			size_t len = skb->len - offset;
+
+			if (tp->urg_data)
+				done = true;
+
+			__mptcp_move_skb(msk, ssk, skb, offset, len);
+			seq += len;
+			moved += len;
+
+			if (WARN_ON_ONCE(map_remaining < len))
+				break;
+		} else {
+			WARN_ON_ONCE(!fin);
+			sk_eat_skb(ssk, skb);
+			done = true;
+		}
+
+		WRITE_ONCE(tp->copied_seq, seq);
+		more_data_avail = mptcp_subflow_data_available(ssk);
+	} while (more_data_avail);
+
+	*bytes = moved;
+
+	return done;
+}
+
 void mptcp_data_ready(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	set_bit(MPTCP_DATA_READY, &msk->flags);
+
+	if (schedule_work(&msk->work))
+		sock_hold((struct sock *)msk);
+
 	sk->sk_data_ready(sk);
 }
 
@@ -373,19 +456,68 @@ static void mptcp_wait_data(struct sock *sk, long *timeo)
 	remove_wait_queue(sk_sleep(sk), &wait);
 }
 
+static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
+				struct msghdr *msg,
+				size_t len)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct sk_buff *skb;
+	int copied = 0;
+
+	while ((skb = skb_peek(&sk->sk_receive_queue)) != NULL) {
+		u32 offset = MPTCP_SKB_CB(skb)->offset;
+		u32 data_len = skb->len - offset;
+		u32 count = min_t(size_t, len - copied, data_len);
+		int err;
+
+		err = skb_copy_datagram_msg(skb, offset, msg, count);
+		if (unlikely(err < 0)) {
+			if (!copied)
+				return err;
+			break;
+		}
+
+		copied += count;
+
+		if (count < data_len) {
+			MPTCP_SKB_CB(skb)->offset += count;
+			break;
+		}
+
+		__skb_unlink(skb, &sk->sk_receive_queue);
+		__kfree_skb(skb);
+
+		if (copied >= len)
+			break;
+	}
+
+	return copied;
+}
+
+static bool __mptcp_move_skbs(struct mptcp_sock *msk)
+{
+	unsigned int moved = 0;
+	bool done;
+
+	do {
+		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
+
+		if (!ssk)
+			break;
+
+		lock_sock(ssk);
+		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+		release_sock(ssk);
+	} while (!done);
+
+	return moved > 0;
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct mptcp_subflow_context *subflow;
-	bool more_data_avail = false;
-	struct mptcp_read_arg arg;
-	read_descriptor_t desc;
-	bool wait_data = false;
 	struct socket *ssock;
-	struct tcp_sock *tp;
-	bool done = false;
-	struct sock *ssk;
 	int copied = 0;
 	int target;
 	long timeo;
@@ -403,65 +535,26 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return copied;
 	}
 
-	arg.msg = msg;
-	desc.arg.data = &arg;
-	desc.error = 0;
-
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
-	while (!done) {
-		u32 map_remaining;
+	while (len > (size_t)copied) {
 		int bytes_read;
 
-		ssk = mptcp_subflow_recv_lookup(msk);
-		pr_debug("msk=%p ssk=%p", msk, ssk);
-		if (!ssk)
-			goto wait_for_data;
+		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied);
+		if (unlikely(bytes_read < 0)) {
+			if (!copied)
+				copied = bytes_read;
+			goto out_err;
+		}
 
-		subflow = mptcp_subflow_ctx(ssk);
-		tp = tcp_sk(ssk);
+		copied += bytes_read;
 
-		lock_sock(ssk);
-		do {
-			/* try to read as much data as available */
-			map_remaining = subflow->map_data_len -
-					mptcp_subflow_get_map_offset(subflow);
-			desc.count = min_t(size_t, len - copied, map_remaining);
-			pr_debug("reading %zu bytes, copied %d", desc.count,
-				 copied);
-			bytes_read = tcp_read_sock(ssk, &desc,
-						   mptcp_read_actor);
-			if (bytes_read < 0) {
-				if (!copied)
-					copied = bytes_read;
-				done = true;
-				goto next;
-			}
-
-			pr_debug("msk ack_seq=%llx -> %llx", msk->ack_seq,
-				 msk->ack_seq + bytes_read);
-			msk->ack_seq += bytes_read;
-			copied += bytes_read;
-			if (copied >= len) {
-				done = true;
-				goto next;
-			}
-			if (tp->urg_data && tp->urg_seq == tp->copied_seq) {
-				pr_err("Urgent data present, cannot proceed");
-				done = true;
-				goto next;
-			}
-next:
-			more_data_avail = mptcp_subflow_data_available(ssk);
-		} while (more_data_avail && !done);
-		release_sock(ssk);
-		continue;
-
-wait_for_data:
-		more_data_avail = false;
+		if (skb_queue_empty(&sk->sk_receive_queue) &&
+		    __mptcp_move_skbs(msk))
+			continue;
 
 		/* only the master socket status is relevant here. The exit
 		 * conditions mirror closely tcp_recvmsg()
@@ -502,26 +595,25 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 
 		pr_debug("block timeout %ld", timeo);
-		wait_data = true;
 		mptcp_wait_data(sk, &timeo);
 		if (unlikely(__mptcp_tcp_fallback(msk)))
 			goto fallback;
 	}
 
-	if (more_data_avail) {
-		if (!test_bit(MPTCP_DATA_READY, &msk->flags))
-			set_bit(MPTCP_DATA_READY, &msk->flags);
-	} else if (!wait_data) {
+	if (skb_queue_empty(&sk->sk_receive_queue)) {
+		/* entire backlog drained, clear DATA_READY. */
 		clear_bit(MPTCP_DATA_READY, &msk->flags);
 
-		/* .. race-breaker: ssk might get new data after last
-		 * data_available() returns false.
+		/* .. race-breaker: ssk might have gotten new data
+		 * after last __mptcp_move_skbs() returned false.
 		 */
-		ssk = mptcp_subflow_recv_lookup(msk);
-		if (unlikely(ssk))
+		if (unlikely(__mptcp_move_skbs(msk)))
 			set_bit(MPTCP_DATA_READY, &msk->flags);
+	} else if (unlikely(!test_bit(MPTCP_DATA_READY, &msk->flags))) {
+		/* data to read but mptcp_wait_data() cleared DATA_READY */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 	}
-
+out_err:
 	release_sock(sk);
 	return copied;
 }
@@ -557,7 +649,7 @@ static void mptcp_worker(struct work_struct *work)
 	struct sock *sk = &msk->sk.icsk_inet.sk;
 
 	lock_sock(sk);
-
+	__mptcp_move_skbs(msk);
 	release_sock(sk);
 	sock_put(sk);
 }
@@ -638,6 +730,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	mptcp_cancel_work(sk);
 
+	__skb_queue_purge(&sk->sk_receive_queue);
+
 	sk_common_release(sk);
 }
 
@@ -1204,6 +1298,8 @@ void mptcp_proto_init(void)
 		panic("Failed to register MPTCP proto.\n");
 
 	inet_register_protosw(&mptcp_protosw);
+
+	BUILD_BUG_ON(sizeof(struct mptcp_skb_cb) > sizeof_field(struct sk_buff, cb));
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-- 
2.24.1

