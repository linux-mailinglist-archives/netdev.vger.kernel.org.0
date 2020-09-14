Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4682686B6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgINIBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:01:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726068AbgINIBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OYahyQwmyzH+Plf0ElS0PkRUHmzKDTWB5mBkiNsuwgI=;
        b=dJBORjB0n65Bsuvr2NIMpnmKFhfk6AyP8jsGVEJ6k83rKuIsxDh7zP2L5IcZNA2fPbciXI
        B1yj8AD8spGMjsB4onLiRwyCriCZHEY+aqTcG/GHQPDNiCF60qS1PDbZ8tHZUqmQRP4RRc
        k7dtPHKcSk6dG2wm7PVUNmoGk235e/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-KrS0_P81MWeDS4bp8XD-AA-1; Mon, 14 Sep 2020 04:01:39 -0400
X-MC-Unique: KrS0_P81MWeDS4bp8XD-AA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F94210BBEDA;
        Mon, 14 Sep 2020 08:01:38 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-96.ams2.redhat.com [10.36.112.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3049319C66;
        Mon, 14 Sep 2020 08:01:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next v2 01/13] mptcp: rethink 'is writable' conditional
Date:   Mon, 14 Sep 2020 10:01:07 +0200
Message-Id: <ae4a76d7e6c72044d63128689155643e9f888e74.1599854632.git.pabeni@redhat.com>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when checking for the 'msk is writable' condition, we
look at the individual subflows write space.
That works well while we send data via a single subflow, but will
not as soon as we will enable concurrent xmit on multiple subflows.

With this change msk becomes writable when the following conditions
hold:
- the socket has some free write space
- there is at least a subflow with write free space

Additionally we need to set the NOSPACE bit on all subflows
before blocking.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 71 ++++++++++++++++++++++++++++----------------
 net/mptcp/subflow.c  |  6 ++--
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 683196225f91..854a8b3b9ecd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -472,7 +472,7 @@ void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
-	if ((!sk_stream_is_writeable(sk) ||
+	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
 	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)) &&
 	    schedule_work(&mptcp_sk(sk)->work))
 		sock_hold(sk);
@@ -567,6 +567,20 @@ static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
 	put_page(dfrag->page);
 }
 
+static bool mptcp_is_writeable(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	if (!sk_stream_is_writeable((struct sock *)msk))
+		return false;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		if (sk_stream_is_writeable(subflow->tcp_sock))
+			return true;
+	}
+	return false;
+}
+
 static void mptcp_clean_una(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -609,8 +623,15 @@ static void mptcp_clean_una(struct sock *sk)
 		sk_mem_reclaim_partial(sk);
 
 		/* Only wake up writers if a subflow is ready */
-		if (test_bit(MPTCP_SEND_SPACE, &msk->flags))
+		if (mptcp_is_writeable(msk)) {
+			set_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags);
+			smp_mb__after_atomic();
+
+			/* set SEND_SPACE before sk_stream_write_space clears
+			 * NOSPACE
+			 */
 			sk_stream_write_space(sk);
+		}
 	}
 }
 
@@ -801,21 +822,31 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
-static void mptcp_nospace(struct mptcp_sock *msk, struct socket *sock)
+static void mptcp_nospace(struct mptcp_sock *msk)
 {
+	struct mptcp_subflow_context *subflow;
+
 	clear_bit(MPTCP_SEND_SPACE, &msk->flags);
 	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
 
-	/* enables sk->write_space() callbacks */
-	set_bit(SOCK_NOSPACE, &sock->flags);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		struct socket *sock = READ_ONCE(ssk->sk_socket);
+
+		/* enables ssk->write_space() callbacks */
+		if (sock)
+			set_bit(SOCK_NOSPACE, &sock->flags);
+	}
 }
 
 static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
 	struct sock *backup = NULL;
+	bool free;
 
-	sock_owned_by_me((const struct sock *)msk);
+	sock_owned_by_me(sk);
 
 	if (!mptcp_ext_cache_refill(msk))
 		return NULL;
@@ -823,12 +854,9 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		if (!sk_stream_memory_free(ssk)) {
-			struct socket *sock = ssk->sk_socket;
-
-			if (sock)
-				mptcp_nospace(msk, sock);
-
+		free = sk_stream_is_writeable(subflow->tcp_sock);
+		if (!free) {
+			mptcp_nospace(msk);
 			return NULL;
 		}
 
@@ -845,16 +873,10 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	return backup;
 }
 
-static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
+static void ssk_check_wmem(struct mptcp_sock *msk)
 {
-	struct socket *sock;
-
-	if (likely(sk_stream_is_writeable(ssk)))
-		return;
-
-	sock = READ_ONCE(ssk->sk_socket);
-	if (sock)
-		mptcp_nospace(msk, sock);
+	if (unlikely(!mptcp_is_writeable(msk)))
+		mptcp_nospace(msk);
 }
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
@@ -907,6 +929,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 				mptcp_reset_timer(sk);
 		}
 
+		mptcp_nospace(msk);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
 			goto out;
@@ -945,7 +968,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (!sk_stream_memory_free(ssk) ||
 		    !mptcp_page_frag_refill(ssk, pfrag) ||
 		    !mptcp_ext_cache_refill(msk)) {
-			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			tcp_push(ssk, msg->msg_flags, mss_now,
 				 tcp_sk(ssk)->nonagle, size_goal);
 			mptcp_set_timeout(sk, ssk);
@@ -993,9 +1015,9 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			mptcp_reset_timer(sk);
 	}
 
-	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
 out:
+	ssk_check_wmem(msk);
 	release_sock(sk);
 	return copied ? : ret;
 }
@@ -2291,8 +2313,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
-		if (sk_stream_is_writeable(sk) &&
-		    test_bit(MPTCP_SEND_SPACE, &msk->flags))
+		if (test_bit(MPTCP_SEND_SPACE, &msk->flags))
 			mask |= EPOLLOUT | EPOLLWRNORM;
 	}
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e8cac2655c82..7ae1d3604047 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -996,8 +996,10 @@ static void subflow_write_space(struct sock *sk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct sock *parent = subflow->conn;
 
-	sk_stream_write_space(sk);
-	if (sk_stream_is_writeable(sk)) {
+	if (!sk_stream_is_writeable(sk))
+		return;
+
+	if (sk_stream_is_writeable(parent)) {
 		set_bit(MPTCP_SEND_SPACE, &mptcp_sk(parent)->flags);
 		smp_mb__after_atomic();
 		/* set SEND_SPACE before sk_stream_write_space clears NOSPACE */
-- 
2.26.2

