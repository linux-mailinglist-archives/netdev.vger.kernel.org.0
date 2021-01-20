Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E55B2FD31B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbhATOoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390736AbhATOlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611153578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWWxbfhMSythF7bI50UjZNQ/S1UP7s+OBUALVuJcfFg=;
        b=bscB0CSIYhTMifU8H2MJj4gdiyXcawlidqBponnLHsFar4LqUhly5qtdKbZ5zVoKIXEvA1
        elP1lce2Kwuhqu9PV67KhyhEUnwOyPDEbd9Zp9Y1kBZJS2/AutY6qfj5kQfLcpBPD5Qndg
        VvJaPmcp1xFgJjw1KqiUXRmgZrg61b0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-ln73f0wnPvyQMe5S-kb4bw-1; Wed, 20 Jan 2021 09:39:34 -0500
X-MC-Unique: ln73f0wnPvyQMe5S-kb4bw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5C9C8066E5;
        Wed, 20 Jan 2021 14:39:32 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEA9C5D9C2;
        Wed, 20 Jan 2021 14:39:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH v2 net-next 2/5] mptcp: re-enable sndbuf autotune
Date:   Wed, 20 Jan 2021 15:39:11 +0100
Message-Id: <fca26fe2e7d130ff878c14cb0242b33267c2617e.1611153172.git.pabeni@redhat.com>
In-Reply-To: <cover.1611153172.git.pabeni@redhat.com>
References: <cover.1611153172.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 6e628cd3a8f7 ("mptcp: use mptcp release_cb for
delayed tasks"), MPTCP never sets the flag bit SOCK_NOSPACE
on its subflow. As a side effect, autotune never takes place,
as it happens inside tcp_new_space(), which in turn is called
only when the mentioned bit is set.

Let's sendmsg() set the subflows NOSPACE bit when looking for
more memory and use the subflow write_space callback to propagate
the snd buf update and wake-up the user-space.

Additionally, this allows dropping a bunch of duplicate code and
makes the SNDBUF_LIMITED chrono relevant again for MPTCP subflows.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 52 +++++++++++++++++---------------------------
 net/mptcp/protocol.h | 19 ++++++++++++++++
 net/mptcp/subflow.c  |  7 +++++-
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c5c80f9253832..d07e60330df56 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -730,10 +730,14 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 
 void __mptcp_flush_join_list(struct mptcp_sock *msk)
 {
+	struct mptcp_subflow_context *subflow;
+
 	if (likely(list_empty(&msk->join_list)))
 		return;
 
 	spin_lock_bh(&msk->join_list_lock);
+	list_for_each_entry(subflow, &msk->join_list, node)
+		mptcp_propagate_sndbuf((struct sock *)msk, mptcp_subflow_tcp_sock(subflow));
 	list_splice_tail_init(&msk->join_list, &msk->conn_list);
 	spin_unlock_bh(&msk->join_list_lock);
 }
@@ -1033,13 +1037,6 @@ static void __mptcp_clean_una(struct sock *sk)
 			__mptcp_update_wmem(sk);
 			sk_mem_reclaim_partial(sk);
 		}
-
-		if (sk_stream_is_writeable(sk)) {
-			/* pairs with memory barrier in mptcp_poll */
-			smp_mb();
-			if (test_and_clear_bit(MPTCP_NOSPACE, &msk->flags))
-				sk_stream_write_space(sk);
-		}
 	}
 
 	if (snd_una == READ_ONCE(msk->snd_nxt)) {
@@ -1358,8 +1355,7 @@ struct subflow_send_info {
 	u64 ratio;
 };
 
-static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
-					   u32 *sndbuf)
+static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 {
 	struct subflow_send_info send_info[2];
 	struct mptcp_subflow_context *subflow;
@@ -1370,24 +1366,17 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 
 	sock_owned_by_me((struct sock *)msk);
 
-	*sndbuf = 0;
 	if (__mptcp_check_fallback(msk)) {
 		if (!msk->first)
 			return NULL;
-		*sndbuf = msk->first->sk_sndbuf;
 		return sk_stream_memory_free(msk->first) ? msk->first : NULL;
 	}
 
 	/* re-use last subflow, if the burst allow that */
 	if (msk->last_snd && msk->snd_burst > 0 &&
 	    sk_stream_memory_free(msk->last_snd) &&
-	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd))) {
-		mptcp_for_each_subflow(msk, subflow) {
-			ssk =  mptcp_subflow_tcp_sock(subflow);
-			*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
-		}
+	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd)))
 		return msk->last_snd;
-	}
 
 	/* pick the subflow with the lower wmem/wspace ratio */
 	for (i = 0; i < 2; ++i) {
@@ -1400,7 +1389,6 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 			continue;
 
 		nr_active += !subflow->backup;
-		*sndbuf = max(tcp_sk(ssk)->snd_wnd, *sndbuf);
 		if (!sk_stream_memory_free(subflow->tcp_sock))
 			continue;
 
@@ -1430,6 +1418,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 				       sk_stream_wspace(msk->last_snd));
 		return msk->last_snd;
 	}
+
 	return NULL;
 }
 
@@ -1450,7 +1439,6 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 	};
 	struct mptcp_data_frag *dfrag;
 	int len, copied = 0;
-	u32 sndbuf;
 
 	while ((dfrag = mptcp_send_head(sk))) {
 		info.sent = dfrag->already_sent;
@@ -1461,12 +1449,7 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 
 			prev_ssk = ssk;
 			__mptcp_flush_join_list(msk);
-			ssk = mptcp_subflow_get_send(msk, &sndbuf);
-
-			/* do auto tuning */
-			if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
-			    sndbuf > READ_ONCE(sk->sk_sndbuf))
-				WRITE_ONCE(sk->sk_sndbuf, sndbuf);
+			ssk = mptcp_subflow_get_send(msk);
 
 			/* try to keep the subflow socket lock across
 			 * consecutive xmit on the same socket
@@ -1533,11 +1516,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 		while (len > 0) {
 			int ret = 0;
 
-			/* do auto tuning */
-			if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK) &&
-			    ssk->sk_sndbuf > READ_ONCE(sk->sk_sndbuf))
-				WRITE_ONCE(sk->sk_sndbuf, ssk->sk_sndbuf);
-
 			if (unlikely(mptcp_must_reclaim_memory(sk, ssk))) {
 				__mptcp_update_wmem(sk);
 				sk_mem_reclaim_partial(sk);
@@ -1575,6 +1553,15 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 	}
 }
 
+static void mptcp_set_nospace(struct sock *sk)
+{
+	/* enable autotune */
+	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+
+	/* will be cleared on avail space */
+	set_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags);
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1676,7 +1663,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		continue;
 
 wait_for_memory:
-		set_bit(MPTCP_NOSPACE, &msk->flags);
+		mptcp_set_nospace(sk);
 		mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
@@ -3268,6 +3255,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 		mptcp_copy_inaddrs(newsk, msk->first);
 		mptcp_rcv_space_init(msk, msk->first);
+		mptcp_propagate_sndbuf(newsk, msk->first);
 
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
@@ -3308,7 +3296,7 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
-	set_bit(MPTCP_NOSPACE, &msk->flags);
+	mptcp_set_nospace(sk);
 	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 65d200a1072bf..871534df6140f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -522,6 +522,25 @@ static inline bool mptcp_data_fin_enabled(const struct mptcp_sock *msk)
 	       READ_ONCE(msk->write_seq) == READ_ONCE(msk->snd_nxt);
 }
 
+static inline bool mptcp_propagate_sndbuf(struct sock *sk, struct sock *ssk)
+{
+	if ((sk->sk_userlocks & SOCK_SNDBUF_LOCK) || ssk->sk_sndbuf <= READ_ONCE(sk->sk_sndbuf))
+		return false;
+
+	WRITE_ONCE(sk->sk_sndbuf, ssk->sk_sndbuf);
+	return true;
+}
+
+static inline void mptcp_write_space(struct sock *sk)
+{
+	if (sk_stream_is_writeable(sk)) {
+		/* pairs with memory barrier in mptcp_poll */
+		smp_mb();
+		if (test_and_clear_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags))
+			sk_stream_write_space(sk);
+	}
+}
+
 void mptcp_destroy_common(struct mptcp_sock *msk);
 
 void __init mptcp_token_init(void);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 22313710d7696..1ca0c82b0dbde 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -343,6 +343,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	if (subflow->conn_finished)
 		return;
 
+	mptcp_propagate_sndbuf(parent, sk);
 	subflow->rel_write_seq = 1;
 	subflow->conn_finished = 1;
 	subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
@@ -1040,7 +1041,10 @@ static void subflow_data_ready(struct sock *sk)
 
 static void subflow_write_space(struct sock *ssk)
 {
-	/* we take action in __mptcp_clean_una() */
+	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
+
+	mptcp_propagate_sndbuf(sk, ssk);
+	mptcp_write_space(sk);
 }
 
 static struct inet_connection_sock_af_ops *
@@ -1302,6 +1306,7 @@ static void subflow_state_change(struct sock *sk)
 	__subflow_state_change(sk);
 
 	if (subflow_simultaneous_connect(sk)) {
+		mptcp_propagate_sndbuf(parent, sk);
 		mptcp_do_fallback(sk);
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 		pr_fallback(mptcp_sk(parent));
-- 
2.26.2

