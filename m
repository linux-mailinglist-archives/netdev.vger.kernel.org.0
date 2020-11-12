Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A252B0317
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgKLKtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728002AbgKLKtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lVLqVJZ3+gp+dSIDnT02ShvfJuIOWWxtEtt1J50/Qlg=;
        b=eURBCFRzfLeXtYRWQiqNc92w3l/6YRMyp8jjGJlj42exctfZhdALxsN1U6tm+/gl84RkEJ
        Bs6g1vpAX74pwDPIhKV4tMhMQ7j9T11fCTfbJFsytP5gjSFQ3GIsUDLZ7BrZaMHQVmwS/h
        vCcH+G+iufnlg8swtrLLhDnqR5NvyNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-ZRjuMCqVP_eYAu9aW48jgg-1; Thu, 12 Nov 2020 05:49:14 -0500
X-MC-Unique: ZRjuMCqVP_eYAu9aW48jgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84C521087D87;
        Thu, 12 Nov 2020 10:49:13 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 558CB5C3E1;
        Thu, 12 Nov 2020 10:49:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/13] mptcp: rework poll+nospace handling
Date:   Thu, 12 Nov 2020 11:48:09 +0100
Message-Id: <61e7462aa9ecfefd71888277134e9a5f9fd6946c.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

MPTCP maintains a status bit, MPTCP_SEND_SPACE, that is set when at
least one subflow and the mptcp socket itself are writeable.

mptcp_poll returns EPOLLOUT if the bit is set.

mptcp_sendmsg makes sure MPTCP_SEND_SPACE gets cleared when last write
has used up all subflows or the mptcp socket wmem.

This reworks nospace handling as follows:

MPTCP_SEND_SPACE is replaced with MPTCP_NOSPACE, i.e. inverted meaning.
This bit is set when the mptcp socket is not writeable.
The mptcp-level ack path schedule will then schedule the mptcp worker
to allow it to free already-acked data (and reduce wmem usage).

This will then wake userspace processes that wait for a POLLOUT event.

sendmsg will set MPTCP_NOSPACE only when it has to wait for more
wmem (blocking I/O case).

poll path will set MPTCP_NOSPACE in case the mptcp socket is
not writeable.

Normal tcp-level notification (SOCK_NOSPACE) is only enabled
in case the subflow socket has no available wmem.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 92 +++++++++++++++++++++++---------------------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  | 11 +++---
 3 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 86b4b6e2afbc..05b8112050b9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -730,7 +730,7 @@ void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
-	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
+	if ((test_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags) ||
 	     mptcp_send_head(sk) ||
 	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		mptcp_schedule_work(sk);
@@ -830,20 +830,6 @@ static void dfrag_clear(struct sock *sk, struct mptcp_data_frag *dfrag)
 	put_page(dfrag->page);
 }
 
-static bool mptcp_is_writeable(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-
-	if (!sk_stream_is_writeable((struct sock *)msk))
-		return false;
-
-	mptcp_for_each_subflow(msk, subflow) {
-		if (sk_stream_is_writeable(subflow->tcp_sock))
-			return true;
-	}
-	return false;
-}
-
 static void mptcp_clean_una(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -896,13 +882,8 @@ static void mptcp_clean_una_wakeup(struct sock *sk)
 	mptcp_clean_una(sk);
 
 	/* Only wake up writers if a subflow is ready */
-	if (mptcp_is_writeable(msk)) {
-		set_bit(MPTCP_SEND_SPACE, &msk->flags);
-		smp_mb__after_atomic();
-
-		/* set SEND_SPACE before sk_stream_write_space clears
-		 * NOSPACE
-		 */
+	if (sk_stream_is_writeable(sk)) {
+		clear_bit(MPTCP_NOSPACE, &msk->flags);
 		sk_stream_write_space(sk);
 	}
 }
@@ -1036,17 +1017,25 @@ static void mptcp_nospace(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
-	clear_bit(MPTCP_SEND_SPACE, &msk->flags);
+	set_bit(MPTCP_NOSPACE, &msk->flags);
 	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool ssk_writeable = sk_stream_is_writeable(ssk);
 		struct socket *sock = READ_ONCE(ssk->sk_socket);
 
+		if (ssk_writeable || !sock)
+			continue;
+
 		/* enables ssk->write_space() callbacks */
-		if (sock)
-			set_bit(SOCK_NOSPACE, &sock->flags);
+		set_bit(SOCK_NOSPACE, &sock->flags);
 	}
+
+	/* mptcp_data_acked() could run just before we set the NOSPACE bit,
+	 * so explicitly check for snd_una value
+	 */
+	mptcp_clean_una((struct sock *)msk);
 }
 
 static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
@@ -1150,12 +1139,6 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk,
 	return NULL;
 }
 
-static void ssk_check_wmem(struct mptcp_sock *msk)
-{
-	if (unlikely(!mptcp_is_writeable(msk)))
-		mptcp_nospace(msk);
-}
-
 static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 			       struct mptcp_sendmsg_info *info)
 {
@@ -1327,7 +1310,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 wait_for_memory:
 		mptcp_nospace(msk);
-		mptcp_clean_una(sk);
 		if (mptcp_timer_pending(sk))
 			mptcp_reset_timer(sk);
 		ret = sk_stream_wait_memory(sk, &timeo);
@@ -1339,7 +1321,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		mptcp_push_pending(sk, msg->msg_flags);
 
 out:
-	ssk_check_wmem(msk);
 	release_sock(sk);
 	return copied ? : ret;
 }
@@ -1916,7 +1897,6 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->conn_list);
 	INIT_LIST_HEAD(&msk->join_list);
 	INIT_LIST_HEAD(&msk->rtx_queue);
-	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 	INIT_WORK(&msk->work, mptcp_worker);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
@@ -2612,13 +2592,6 @@ bool mptcp_finish_join(struct sock *ssk)
 	return true;
 }
 
-static bool mptcp_memory_free(const struct sock *sk, int wake)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	return wake ? test_bit(MPTCP_SEND_SPACE, &msk->flags) : true;
-}
-
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -2639,7 +2612,6 @@ static struct proto mptcp_prot = {
 	.sockets_allocated	= &mptcp_sockets_allocated,
 	.memory_allocated	= &tcp_memory_allocated,
 	.memory_pressure	= &tcp_memory_pressure,
-	.stream_memory_free	= mptcp_memory_free,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
 	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
@@ -2812,6 +2784,39 @@ static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
 	       0;
 }
 
+static bool __mptcp_check_writeable(struct mptcp_sock *msk)
+{
+	struct sock *sk = (struct sock *)msk;
+	bool mptcp_writable;
+
+	mptcp_clean_una(sk);
+	mptcp_writable = sk_stream_is_writeable(sk);
+	if (!mptcp_writable)
+		mptcp_nospace(msk);
+
+	return mptcp_writable;
+}
+
+static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
+{
+	struct sock *sk = (struct sock *)msk;
+	__poll_t ret = 0;
+	bool slow;
+
+	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
+		return 0;
+
+	if (sk_stream_is_writeable(sk))
+		return EPOLLOUT | EPOLLWRNORM;
+
+	slow = lock_sock_fast(sk);
+	if (__mptcp_check_writeable(msk))
+		ret = EPOLLOUT | EPOLLWRNORM;
+
+	unlock_sock_fast(sk, slow);
+	return ret;
+}
+
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
@@ -2830,8 +2835,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
-		if (test_bit(MPTCP_SEND_SPACE, &msk->flags))
-			mask |= EPOLLOUT | EPOLLWRNORM;
+		mask |= mptcp_check_writeable(msk);
 	}
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fd9c666aed7f..8345011fc0ba 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -86,7 +86,7 @@
 
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	0
-#define MPTCP_SEND_SPACE	1
+#define MPTCP_NOSPACE		1
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 42581ffb0c7e..794259789194 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -997,17 +997,16 @@ static void subflow_data_ready(struct sock *sk)
 static void subflow_write_space(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct socket *sock = READ_ONCE(sk->sk_socket);
 	struct sock *parent = subflow->conn;
 
 	if (!sk_stream_is_writeable(sk))
 		return;
 
-	if (sk_stream_is_writeable(parent)) {
-		set_bit(MPTCP_SEND_SPACE, &mptcp_sk(parent)->flags);
-		smp_mb__after_atomic();
-		/* set SEND_SPACE before sk_stream_write_space clears NOSPACE */
-		sk_stream_write_space(parent);
-	}
+	if (sock && sk_stream_is_writeable(parent))
+		clear_bit(SOCK_NOSPACE, &sock->flags);
+
+	sk_stream_write_space(parent);
 }
 
 static struct inet_connection_sock_af_ops *
-- 
2.26.2

