Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00D32664F4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIKQsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:48:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgIKPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599836821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+TtbgBTAVGzYjYMB80XGZMy2FcFqxaPfC0HGZU+TL0=;
        b=ZnwLwJfXPwBYfntY16X4nJziMDALMv6kU4A+e1AXMYlvmtcsXiZL36lTIxn8thwA7USGa6
        f+n/mULo2WxLvzNKO4ZtZfe5Up4F0kFyUhBkO/Prce9WvhPZ0N1MMF0O+bDIOYk8xO8xHS
        wNxqGNY3foq8MNDtX7frZtzvGN2DGxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419--UJdzLveOxqVtPqUNsnlFA-1; Fri, 11 Sep 2020 09:52:33 -0400
X-MC-Unique: -UJdzLveOxqVtPqUNsnlFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8C011017DCF;
        Fri, 11 Sep 2020 13:52:31 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-214.ams2.redhat.com [10.36.114.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C45B5C1BD;
        Fri, 11 Sep 2020 13:52:30 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 03/13] mptcp: trigger msk processing even for OoO data
Date:   Fri, 11 Sep 2020 15:51:58 +0200
Message-Id: <10d123b243cb850962982ae7d46eeac49ca63332.1599832097.git.pabeni@redhat.com>
In-Reply-To: <cover.1599832097.git.pabeni@redhat.com>
References: <cover.1599832097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a prerequisite to allow receiving data from multiple
subflows without re-injection.

Instead of dropping the OoO - "future" data in
subflow_check_data_avail(), call into __mptcp_move_skbs()
and let the msk drop that.

To avoid code duplication factor out the mptcp_subflow_discard_data()
helper.

Note that __mptcp_move_skbs() can now find multiple subflows
with data avail (comprising to-be-discarded data), so must
update the byte counter incrementally.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 33 +++++++++++++++----
 net/mptcp/protocol.h |  9 ++++-
 net/mptcp/subflow.c  | 78 ++++++++++++++++++++++++--------------------
 3 files changed, 78 insertions(+), 42 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 854a8b3b9ecd..95573c6f7762 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -167,7 +167,8 @@ static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
 		return true;
 
 	subflow->data_avail = 0;
-	return mptcp_subflow_data_available(ssk);
+	mptcp_subflow_data_available(ssk);
+	return subflow->data_avail == MPTCP_SUBFLOW_DATA_AVAIL;
 }
 
 static void mptcp_check_data_fin_ack(struct sock *sk)
@@ -313,11 +314,18 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	struct tcp_sock *tp;
 	bool done = false;
 
-	if (!mptcp_subflow_dsn_valid(msk, ssk)) {
-		*bytes = 0;
+	pr_debug("msk=%p ssk=%p data avail=%d valid=%d empty=%d",
+		 msk, ssk, subflow->data_avail,
+		 mptcp_subflow_dsn_valid(msk, ssk),
+		 !skb_peek(&ssk->sk_receive_queue));
+	if (subflow->data_avail == MPTCP_SUBFLOW_OOO_DATA) {
+		mptcp_subflow_discard_data(ssk, subflow->map_data_len);
 		return false;
 	}
 
+	if (!mptcp_subflow_dsn_valid(msk, ssk))
+		return false;
+
 	tp = tcp_sk(ssk);
 	do {
 		u32 map_remaining, offset;
@@ -376,7 +384,7 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		}
 	} while (more_data_avail);
 
-	*bytes = moved;
+	*bytes += moved;
 
 	/* If the moves have caught up with the DATA_FIN sequence number
 	 * it's time to ack the DATA_FIN and change socket state, but
@@ -415,9 +423,17 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 
 void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool wake;
 
-	set_bit(MPTCP_DATA_READY, &msk->flags);
+	/* move_skbs_to_msk below can legitly clear the data_avail flag,
+	 * but we will need later to properly woke the reader, cache its
+	 * value
+	 */
+	wake = subflow->data_avail == MPTCP_SUBFLOW_DATA_AVAIL;
+	if (wake)
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 
 	if (atomic_read(&sk->sk_rmem_alloc) < READ_ONCE(sk->sk_rcvbuf) &&
 	    move_skbs_to_msk(msk, ssk))
@@ -438,7 +454,8 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 		move_skbs_to_msk(msk, ssk);
 	}
 wake:
-	sk->sk_data_ready(sk);
+	if (wake)
+		sk->sk_data_ready(sk);
 }
 
 static void __mptcp_flush_join_list(struct mptcp_sock *msk)
@@ -1281,6 +1298,9 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 	}
 out_err:
+	pr_debug("msk=%p data_ready=%d rx queue empty=%d copied=%d",
+		 msk, test_bit(MPTCP_DATA_READY, &msk->flags),
+		 skb_queue_empty(&sk->sk_receive_queue), copied);
 	mptcp_rcv_space_adjust(msk, copied);
 
 	release_sock(sk);
@@ -2308,6 +2328,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	sock_poll_wait(file, sock, wait);
 
 	state = inet_sk_state_load(sk);
+	pr_debug("msk=%p state=%d flags=%lx", msk, state, msk->flags);
 	if (state == TCP_LISTEN)
 		return mptcp_check_readable(msk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 60b27d44c184..981e395abb46 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -268,6 +268,12 @@ mptcp_subflow_rsk(const struct request_sock *rsk)
 	return (struct mptcp_subflow_request_sock *)rsk;
 }
 
+enum mptcp_data_avail {
+	MPTCP_SUBFLOW_NODATA,
+	MPTCP_SUBFLOW_DATA_AVAIL,
+	MPTCP_SUBFLOW_OOO_DATA
+};
+
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
@@ -292,10 +298,10 @@ struct mptcp_subflow_context {
 		map_valid : 1,
 		mpc_map : 1,
 		backup : 1,
-		data_avail : 1,
 		rx_eof : 1,
 		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
+	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
@@ -347,6 +353,7 @@ int mptcp_is_enabled(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
+int mptcp_subflow_discard_data(struct sock *sk, unsigned limit);
 void __init mptcp_subflow_init(void);
 
 /* called with sk socket lock held */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 53b455c3c229..a983beb8e6a6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -816,6 +816,40 @@ static int subflow_read_actor(read_descriptor_t *desc,
 	return copy_len;
 }
 
+int mptcp_subflow_discard_data(struct sock *ssk, unsigned limit)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	u32 map_remaining;
+	size_t delta;
+
+	map_remaining = subflow->map_data_len -
+			mptcp_subflow_get_map_offset(subflow);
+	delta = min_t(size_t, limit, map_remaining);
+
+	/* discard mapped data */
+	pr_debug("discarding %zu bytes, current map len=%d", delta,
+		 map_remaining);
+	if (delta) {
+		read_descriptor_t desc = {
+			.count = delta,
+		};
+		int ret;
+
+		ret = tcp_read_sock(ssk, &desc, subflow_read_actor);
+		if (ret < 0) {
+			ssk->sk_err = -ret;
+			return ret;
+		}
+		if (ret < delta)
+			return 0;
+		if (delta == map_remaining) {
+			subflow->data_avail = 0;
+			subflow->map_valid = 0;
+		}
+	}
+	return 0;
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -832,8 +866,6 @@ static bool subflow_check_data_avail(struct sock *ssk)
 
 	msk = mptcp_sk(subflow->conn);
 	for (;;) {
-		u32 map_remaining;
-		size_t delta;
 		u64 ack_seq;
 		u64 old_ack;
 
@@ -851,7 +883,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 			subflow->map_data_len = skb->len;
 			subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq -
 						   subflow->ssn_offset;
-			subflow->data_avail = 1;
+			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
 			return true;
 		}
 
@@ -880,43 +912,19 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
 			 ack_seq);
 		if (ack_seq == old_ack) {
-			subflow->data_avail = 1;
+			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
+			break;
+		} else if (after64(ack_seq, old_ack)) {
+			subflow->data_avail = MPTCP_SUBFLOW_OOO_DATA;
 			break;
 		}
 
 		/* only accept in-sequence mapping. Old values are spurious
-		 * retransmission; we can hit "future" values on active backup
-		 * subflow switch, we relay on retransmissions to get
-		 * in-sequence data.
-		 * Cuncurrent subflows support will require subflow data
-		 * reordering
+		 * retransmission
 		 */
-		map_remaining = subflow->map_data_len -
-				mptcp_subflow_get_map_offset(subflow);
-		if (before64(ack_seq, old_ack))
-			delta = min_t(size_t, old_ack - ack_seq, map_remaining);
-		else
-			delta = min_t(size_t, ack_seq - old_ack, map_remaining);
-
-		/* discard mapped data */
-		pr_debug("discarding %zu bytes, current map len=%d", delta,
-			 map_remaining);
-		if (delta) {
-			read_descriptor_t desc = {
-				.count = delta,
-			};
-			int ret;
-
-			ret = tcp_read_sock(ssk, &desc, subflow_read_actor);
-			if (ret < 0) {
-				ssk->sk_err = -ret;
-				goto fatal;
-			}
-			if (ret < delta)
-				return false;
-			if (delta == map_remaining)
-				subflow->map_valid = 0;
-		}
+		if (mptcp_subflow_discard_data(ssk, old_ack - ack_seq))
+			goto fatal;
+		return false;
 	}
 	return true;
 
-- 
2.26.2

