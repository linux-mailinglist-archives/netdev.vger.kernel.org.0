Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26232B403C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgKPJsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgKPJsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7jE/otI8IyvUc4pM1PE3GVRurDY8fR05oF0yEKaGGY=;
        b=a1iIgXmffjk0SDl+eliLYSAwX6/8qkoOyCll4amkFsVaK493KbH40sFjnLMaG7/YtnYfaY
        2YRgKJTKwXZI1qP+R0/cGhwep7/u1n4/hbBejiPrGZQfxFYi5PF3jhou3oULL4cLo6X22/
        /FNTTbPpaPZB0mQtIzQd2rjedAt2QgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-QQexqUMyNTO8eJnAaDcn1w-1; Mon, 16 Nov 2020 04:48:43 -0500
X-MC-Unique: QQexqUMyNTO8eJnAaDcn1w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F6CF6D584;
        Mon, 16 Nov 2020 09:48:41 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 272601002C1B;
        Mon, 16 Nov 2020 09:48:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 08/13] mptcp: refactor shutdown and close
Date:   Mon, 16 Nov 2020 10:48:09 +0100
Message-Id: <a5452c64e0f6d9703ade29ff24fb1b3704053f59.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We must not close the subflows before all the MPTCP level
data, comprising the DATA_FIN has been acked at the MPTCP
level, otherwise we could be unable to retransmit as needed.

__mptcp_wr_shutdown() shutdown is responsible to check for the
correct status and close all subflows. Is called by the output
path after spooling any data and at shutdown/close time.

In a similar way, __mptcp_destroy_sock() is responsible to clean-up
the MPTCP level status, and is called when the msk transition
to TCP_CLOSE.

The protocol level close() does not force anymore the TCP_CLOSE
status, but orphan the msk socket and all the subflows.
Orphaned msk sockets are forciby closed after a timeout or
when all MPTCP-level data is acked.

There is a caveat about keeping the orphaned subflows around:
the TCP stack can asynchronusly call tcp_cleanup_ulp() on them via
tcp_close(). To prevent accessing freed memory on later MPTCP
level operations, the msk acquires a reference to each subflow
socket and prevent subflow_ulp_release() from releasing the
subflow context before __mptcp_destroy_sock().

The additional subflow references are released by __mptcp_done()
and the async ULP release is detected checking ULP ops. If such
field has been already cleared by the ULP release path, the
dangling context is freed directly by __mptcp_done().

Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v2 -> v3:
 - fixed some issue in fallback socket state tracking
---
 net/mptcp/options.c    |   2 +-
 net/mptcp/pm_netlink.c |   6 +-
 net/mptcp/protocol.c   | 340 +++++++++++++++++++++++++++++------------
 net/mptcp/protocol.h   |  13 +-
 net/mptcp/subflow.c    |  22 ++-
 5 files changed, 273 insertions(+), 110 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a6b57021b6d0..1be272d2bd95 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -492,7 +492,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 	bool ret = false;
 
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
-	snd_data_fin_enable = READ_ONCE(msk->snd_data_fin_enable);
+	snd_data_fin_enable = mptcp_data_fin_enabled(msk);
 
 	if (!skb || (mpext && mpext->use_map) || snd_data_fin_enable) {
 		unsigned int map_size;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 446ef8f07734..f8a9d82a0ea8 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -416,14 +416,13 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
-		long timeout = 0;
 
 		if (msk->pm.rm_id != subflow->remote_id)
 			continue;
 
 		spin_unlock_bh(&msk->pm.lock);
 		mptcp_subflow_shutdown(sk, ssk, how);
-		__mptcp_close_ssk(sk, ssk, subflow, timeout);
+		__mptcp_close_ssk(sk, ssk, subflow);
 		spin_lock_bh(&msk->pm.lock);
 
 		msk->pm.add_addr_accepted--;
@@ -452,14 +451,13 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
-		long timeout = 0;
 
 		if (rm_id != subflow->local_id)
 			continue;
 
 		spin_unlock_bh(&msk->pm.lock);
 		mptcp_subflow_shutdown(sk, ssk, how);
-		__mptcp_close_ssk(sk, ssk, subflow, timeout);
+		__mptcp_close_ssk(sk, ssk, subflow);
 		spin_lock_bh(&msk->pm.lock);
 
 		msk->pm.local_addr_used--;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2b0fd08b03f9..daa51e657db8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -21,6 +21,7 @@
 #include <net/transp_v6.h>
 #endif
 #include <net/mptcp.h>
+#include <net/xfrm.h>
 #include "protocol.h"
 #include "mib.h"
 
@@ -41,6 +42,8 @@ struct mptcp_skb_cb {
 
 static struct percpu_counter mptcp_sockets_allocated;
 
+static void __mptcp_destroy_sock(struct sock *sk);
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -102,6 +105,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	msk->subflow = ssock;
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
+	sock_hold(ssock->sk);
 	subflow->request_mptcp = 1;
 
 	/* accept() will wait on first subflow sk_wq, and we always wakes up
@@ -323,6 +327,19 @@ static void mptcp_stop_timer(struct sock *sk)
 	mptcp_sk(sk)->timer_ival = 0;
 }
 
+static void mptcp_close_wake_up(struct sock *sk)
+{
+	if (sock_flag(sk, SOCK_DEAD))
+		return;
+
+	sk->sk_state_change(sk);
+	if (sk->sk_shutdown == SHUTDOWN_MASK ||
+	    sk->sk_state == TCP_CLOSE)
+		sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
+	else
+		sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+}
+
 static void mptcp_check_data_fin_ack(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -341,20 +358,14 @@ static void mptcp_check_data_fin_ack(struct sock *sk)
 		switch (sk->sk_state) {
 		case TCP_FIN_WAIT1:
 			inet_sk_state_store(sk, TCP_FIN_WAIT2);
-			sk->sk_state_change(sk);
 			break;
 		case TCP_CLOSING:
 		case TCP_LAST_ACK:
 			inet_sk_state_store(sk, TCP_CLOSE);
-			sk->sk_state_change(sk);
 			break;
 		}
 
-		if (sk->sk_shutdown == SHUTDOWN_MASK ||
-		    sk->sk_state == TCP_CLOSE)
-			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
-		else
-			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+		mptcp_close_wake_up(sk);
 	}
 }
 
@@ -428,7 +439,6 @@ static void mptcp_check_data_fin(struct sock *sk)
 			break;
 		case TCP_FIN_WAIT2:
 			inet_sk_state_store(sk, TCP_CLOSE);
-			// @@ Close subflows now?
 			break;
 		default:
 			/* Other states not expected */
@@ -445,13 +455,7 @@ static void mptcp_check_data_fin(struct sock *sk)
 			release_sock(ssk);
 		}
 
-		sk->sk_state_change(sk);
-
-		if (sk->sk_shutdown == SHUTDOWN_MASK ||
-		    sk->sk_state == TCP_CLOSE)
-			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
-		else
-			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+		mptcp_close_wake_up(sk);
 	}
 }
 
@@ -691,6 +695,10 @@ static void mptcp_reset_timer(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	unsigned long tout;
 
+	/* prevent rescheduling on close */
+	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+		return;
+
 	/* should never be called with mptcp level timer cleared */
 	tout = READ_ONCE(mptcp_sk(sk)->timer_ival);
 	if (WARN_ON_ONCE(!tout))
@@ -734,8 +742,10 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 
 	mptcp_for_each_subflow(msk, subflow)
 		receivers += !subflow->rx_eof;
+	if (receivers)
+		return;
 
-	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
+	if (!(sk->sk_shutdown & RCV_SHUTDOWN)) {
 		/* hopefully temporary hack: propagate shutdown status
 		 * to msk, when all subflows agree on it
 		 */
@@ -745,6 +755,19 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 		sk->sk_data_ready(sk);
 	}
+
+	switch (sk->sk_state) {
+	case TCP_ESTABLISHED:
+		inet_sk_state_store(sk, TCP_CLOSE_WAIT);
+		break;
+	case TCP_FIN_WAIT1:
+		/* fallback sockets skip TCP_CLOSING - TCP will take care */
+		inet_sk_state_store(sk, TCP_CLOSE);
+		break;
+	default:
+		return;
+	}
+	mptcp_close_wake_up(sk);
 }
 
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
@@ -1657,6 +1680,13 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
+static void mptcp_timeout_timer(struct timer_list *t)
+{
+	struct sock *sk = from_timer(sk, t, sk_timer);
+
+	mptcp_schedule_work(sk);
+}
+
 /* Find an idle subflow.  Return NULL if there is unacked data at tcp
  * level.
  *
@@ -1703,20 +1733,43 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
  * parent socket.
  */
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-		       struct mptcp_subflow_context *subflow,
-		       long timeout)
+		       struct mptcp_subflow_context *subflow)
 {
-	struct socket *sock = READ_ONCE(ssk->sk_socket);
+	bool dispose_socket = false;
+	struct socket *sock;
 
 	list_del(&subflow->node);
 
-	if (sock && sock != sk->sk_socket) {
-		/* outgoing subflow */
-		sock_release(sock);
+	lock_sock(ssk);
+
+	/* if we are invoked by the msk cleanup code, the subflow is
+	 * already orphaned
+	 */
+	sock = ssk->sk_socket;
+	if (sock) {
+		dispose_socket = sock != sk->sk_socket;
+		sock_orphan(ssk);
+	}
+
+	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
+	 * the ssk has been already destroyed, we just need to release the
+	 * reference owned by msk;
+	 */
+	if (!inet_csk(ssk)->icsk_ulp_ops) {
+		kfree_rcu(subflow, rcu);
 	} else {
-		/* incoming subflow */
-		tcp_close(ssk, timeout);
+		/* otherwise ask tcp do dispose of ssk and subflow ctx */
+		subflow->disposable = 1;
+		__tcp_close(ssk, 0);
+
+		/* close acquired an extra ref */
+		__sock_put(ssk);
 	}
+	release_sock(ssk);
+	if (dispose_socket)
+		iput(SOCK_INODE(sock));
+
+	sock_put(ssk);
 }
 
 static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
@@ -1761,10 +1814,29 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (inet_sk_state_load(ssk) != TCP_CLOSE)
 			continue;
 
-		__mptcp_close_ssk((struct sock *)msk, ssk, subflow, 0);
+		__mptcp_close_ssk((struct sock *)msk, ssk, subflow);
 	}
 }
 
+static bool mptcp_check_close_timeout(const struct sock *sk)
+{
+	s32 delta = tcp_jiffies32 - inet_csk(sk)->icsk_mtup.probe_timestamp;
+	struct mptcp_subflow_context *subflow;
+
+	if (delta >= TCP_TIMEWAIT_LEN)
+		return true;
+
+	/* if all subflows are in closed status don't bother with additional
+	 * timeout
+	 */
+	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
+		if (inet_sk_state_load(mptcp_subflow_tcp_sock(subflow)) !=
+		    TCP_CLOSE)
+			return false;
+	}
+	return true;
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -1777,9 +1849,14 @@ static void mptcp_worker(struct work_struct *work)
 	struct msghdr msg = {
 		.msg_flags = MSG_DONTWAIT,
 	};
-	int ret;
+	int state, ret;
 
 	lock_sock(sk);
+	set_bit(MPTCP_WORKER_RUNNING, &msk->flags);
+	state = sk->sk_state;
+	if (unlikely(state == TCP_CLOSE))
+		goto unlock;
+
 	mptcp_clean_una_wakeup(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
@@ -1796,6 +1873,18 @@ static void mptcp_worker(struct work_struct *work)
 
 	mptcp_check_data_fin(sk);
 
+	/* if the msk data is completely acked, or the socket timedout,
+	 * there is no point in keeping around an orphaned sk
+	 */
+	if (sock_flag(sk, SOCK_DEAD) &&
+	    (mptcp_check_close_timeout(sk) ||
+	    (state != sk->sk_state &&
+	    ((1 << inet_sk_state_load(sk)) & (TCPF_CLOSE | TCPF_FIN_WAIT2))))) {
+		inet_sk_state_store(sk, TCP_CLOSE);
+		__mptcp_destroy_sock(sk);
+		goto unlock;
+	}
+
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
@@ -1844,6 +1933,7 @@ static void mptcp_worker(struct work_struct *work)
 		mptcp_reset_timer(sk);
 
 unlock:
+	clear_bit(MPTCP_WORKER_RUNNING, &msk->flags);
 	release_sock(sk);
 	sock_put(sk);
 }
@@ -1869,7 +1959,7 @@ static int __mptcp_init_sock(struct sock *sk)
 
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
-
+	timer_setup(&sk->sk_timer, mptcp_timeout_timer, 0);
 	return 0;
 }
 
@@ -1914,8 +2004,12 @@ static void mptcp_cancel_work(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (cancel_work_sync(&msk->work))
-		sock_put(sk);
+	/* if called by the work itself, do not try to cancel the work, or
+	 * we will hang.
+	 */
+	if (!test_bit(MPTCP_WORKER_RUNNING, &msk->flags) &&
+	    cancel_work_sync(&msk->work))
+		__sock_put(sk);
 }
 
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
@@ -1973,42 +2067,61 @@ static int mptcp_close_state(struct sock *sk)
 	return next & TCP_ACTION_FIN;
 }
 
-static void mptcp_close(struct sock *sk, long timeout)
+static void __mptcp_check_send_data_fin(struct sock *sk)
 {
-	struct mptcp_subflow_context *subflow, *tmp;
+	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	LIST_HEAD(conn_list);
 
-	lock_sock(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	pr_debug("msk=%p snd_data_fin_enable=%d pending=%d snd_nxt=%llu write_seq=%llu",
+		 msk, msk->snd_data_fin_enable, !!mptcp_send_head(sk),
+		 msk->snd_nxt, msk->write_seq);
 
-	if (sk->sk_state == TCP_LISTEN) {
+	/* we still need to enqueue subflows or not really shutting down,
+	 * skip this
+	 */
+	if (!msk->snd_data_fin_enable || msk->snd_nxt + 1 != msk->write_seq ||
+	    mptcp_send_head(sk))
+		return;
+
+	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
+
+	/* fallback socket will not get data_fin/ack, can move to close now */
+	if (__mptcp_check_fallback(msk) && sk->sk_state == TCP_LAST_ACK) {
 		inet_sk_state_store(sk, TCP_CLOSE);
-		goto cleanup;
-	} else if (sk->sk_state == TCP_CLOSE) {
-		goto cleanup;
+		mptcp_close_wake_up(sk);
 	}
 
-	if (__mptcp_check_fallback(msk)) {
-		goto update_state;
-	} else if (mptcp_close_state(sk)) {
-		pr_debug("Sending DATA_FIN sk=%p", sk);
-		WRITE_ONCE(msk->write_seq, msk->write_seq + 1);
-		WRITE_ONCE(msk->snd_data_fin_enable, 1);
-
-		mptcp_for_each_subflow(msk, subflow) {
-			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+	__mptcp_flush_join_list(msk);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
-			mptcp_subflow_shutdown(sk, tcp_sk, SHUTDOWN_MASK);
-		}
+		mptcp_subflow_shutdown(sk, tcp_sk, SEND_SHUTDOWN);
 	}
+}
 
-	sk_stream_wait_close(sk, timeout);
+static void __mptcp_wr_shutdown(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
-update_state:
-	inet_sk_state_store(sk, TCP_CLOSE);
+	pr_debug("msk=%p snd_data_fin_enable=%d shutdown=%x state=%d pending=%d",
+		 msk, msk->snd_data_fin_enable, sk->sk_shutdown, sk->sk_state,
+		 !!mptcp_send_head(sk));
+
+	/* will be ignored by fallback sockets */
+	WRITE_ONCE(msk->write_seq, msk->write_seq + 1);
+	WRITE_ONCE(msk->snd_data_fin_enable, 1);
+
+	__mptcp_check_send_data_fin(sk);
+}
+
+static void __mptcp_destroy_sock(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	LIST_HEAD(conn_list);
+
+	pr_debug("msk=%p", msk);
 
-cleanup:
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -2018,19 +2131,74 @@ static void mptcp_close(struct sock *sk, long timeout)
 	list_splice_init(&msk->conn_list, &conn_list);
 
 	__mptcp_clear_xmit(sk);
-
-	release_sock(sk);
+	sk_stop_timer(sk, &sk->sk_timer);
+	msk->pm.status = 0;
 
 	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		__mptcp_close_ssk(sk, ssk, subflow, timeout);
+		__mptcp_close_ssk(sk, ssk, subflow);
 	}
 
-	mptcp_cancel_work(sk);
+	sk->sk_prot->destroy(sk);
 
-	__skb_queue_purge(&sk->sk_receive_queue);
+	sk_stream_kill_queues(sk);
+	xfrm_sk_free_policy(sk);
+	sk_refcnt_debug_release(sk);
+	sock_put(sk);
+}
+
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	struct mptcp_subflow_context *subflow;
+	bool do_cancel_work = false;
+
+	lock_sock(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+
+	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
+		inet_sk_state_store(sk, TCP_CLOSE);
+		goto cleanup;
+	}
 
-	sk_common_release(sk);
+	if (mptcp_close_state(sk))
+		__mptcp_wr_shutdown(sk);
+
+	sk_stream_wait_close(sk, timeout);
+
+cleanup:
+	/* orphan all the subflows */
+	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
+	list_for_each_entry(subflow, &mptcp_sk(sk)->conn_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow, dispose_socket;
+		struct socket *sock;
+
+		slow = lock_sock_fast(ssk);
+		sock = ssk->sk_socket;
+		dispose_socket = sock && sock != sk->sk_socket;
+		sock_orphan(ssk);
+		unlock_sock_fast(ssk, slow);
+
+		/* for the outgoing subflows we additionally need to free
+		 * the associated socket
+		 */
+		if (dispose_socket)
+			iput(SOCK_INODE(sock));
+	}
+	sock_orphan(sk);
+
+	sock_hold(sk);
+	pr_debug("msk=%p state=%d", sk, sk->sk_state);
+	if (sk->sk_state == TCP_CLOSE) {
+		__mptcp_destroy_sock(sk);
+		do_cancel_work = true;
+	} else {
+		sk_reset_timer(sk, &sk->sk_timer, jiffies + TCP_TIMEWAIT_LEN);
+	}
+	release_sock(sk);
+	if (do_cancel_work)
+		mptcp_cancel_work(sk);
+	sock_put(sk);
 }
 
 static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
@@ -2183,6 +2351,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
+		sock_hold(ssk);
 
 		mptcp_rcv_space_init(msk, ssk);
 		bh_unlock_sock(new_mptcp_sock);
@@ -2430,9 +2599,9 @@ static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-bool mptcp_finish_join(struct sock *sk)
+bool mptcp_finish_join(struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct sock *parent = (void *)msk;
 	struct socket *parent_sock;
@@ -2453,12 +2622,14 @@ bool mptcp_finish_join(struct sock *sk)
 	/* active connections are already on conn_list, and we can't acquire
 	 * msk lock here.
 	 * use the join list lock as synchronization point and double-check
-	 * msk status to avoid racing with mptcp_close()
+	 * msk status to avoid racing with __mptcp_destroy_sock()
 	 */
 	spin_lock_bh(&msk->join_list_lock);
 	ret = inet_sk_state_load(parent) == TCP_ESTABLISHED;
-	if (ret && !WARN_ON_ONCE(!list_empty(&subflow->node)))
+	if (ret && !WARN_ON_ONCE(!list_empty(&subflow->node))) {
 		list_add_tail(&subflow->node, &msk->join_list);
+		sock_hold(ssk);
+	}
 	spin_unlock_bh(&msk->join_list_lock);
 	if (!ret)
 		return false;
@@ -2467,8 +2638,8 @@ bool mptcp_finish_join(struct sock *sk)
 	 * at close time
 	 */
 	parent_sock = READ_ONCE(parent->sk_socket);
-	if (parent_sock && !sk->sk_socket)
-		mptcp_sock_graft(sk, parent_sock);
+	if (parent_sock && !ssk->sk_socket)
+		mptcp_sock_graft(ssk, parent_sock);
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	return true;
 }
@@ -2704,12 +2875,12 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 static int mptcp_shutdown(struct socket *sock, int how)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
-	struct mptcp_subflow_context *subflow;
+	struct sock *sk = sock->sk;
 	int ret = 0;
 
 	pr_debug("sk=%p, how=%d", msk, how);
 
-	lock_sock(sock->sk);
+	lock_sock(sk);
 
 	how++;
 	if ((how & ~SHUTDOWN_MASK) || !how) {
@@ -2718,45 +2889,22 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	}
 
 	if (sock->state == SS_CONNECTING) {
-		if ((1 << sock->sk->sk_state) &
+		if ((1 << sk->sk_state) &
 		    (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_CLOSE))
 			sock->state = SS_DISCONNECTING;
 		else
 			sock->state = SS_CONNECTED;
 	}
 
-	/* If we've already sent a FIN, or it's a closed state, skip this. */
-	if (__mptcp_check_fallback(msk)) {
-		if (how == SHUT_WR || how == SHUT_RDWR)
-			inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
-
-		mptcp_for_each_subflow(msk, subflow) {
-			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
-
-			mptcp_subflow_shutdown(sock->sk, tcp_sk, how);
-		}
-	} else if ((how & SEND_SHUTDOWN) &&
-		   ((1 << sock->sk->sk_state) &
-		    (TCPF_ESTABLISHED | TCPF_SYN_SENT |
-		     TCPF_SYN_RECV | TCPF_CLOSE_WAIT)) &&
-		   mptcp_close_state(sock->sk)) {
-		__mptcp_flush_join_list(msk);
-
-		WRITE_ONCE(msk->write_seq, msk->write_seq + 1);
-		WRITE_ONCE(msk->snd_data_fin_enable, 1);
-
-		mptcp_for_each_subflow(msk, subflow) {
-			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
-
-			mptcp_subflow_shutdown(sock->sk, tcp_sk, how);
-		}
-	}
+	sk->sk_shutdown |= how;
+	if ((how & SEND_SHUTDOWN) && mptcp_close_state(sk))
+		__mptcp_wr_shutdown(sk);
 
 	/* Wake up anyone sleeping in poll. */
-	sock->sk->sk_state_change(sock->sk);
+	sk->sk_state_change(sk);
 
 out_unlock:
-	release_sock(sock->sk);
+	release_sock(sk);
 
 	return ret;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 946319cf9cca..fd9c666aed7f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -91,6 +91,7 @@
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
+#define MPTCP_WORKER_RUNNING	6
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -352,7 +353,8 @@ struct mptcp_subflow_context {
 		mpc_map : 1,
 		backup : 1,
 		rx_eof : 1,
-		can_ack : 1;	    /* only after processing the remote a key */
+		can_ack : 1,        /* only after processing the remote a key */
+		disposable : 1;	    /* ctx can be free at ulp release time */
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;
@@ -409,8 +411,7 @@ bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-		       struct mptcp_subflow_context *subflow,
-		       long timeout);
+		       struct mptcp_subflow_context *subflow);
 void mptcp_subflow_reset(struct sock *ssk);
 
 /* called with sk socket lock held */
@@ -452,6 +453,12 @@ bool mptcp_schedule_work(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
+static inline bool mptcp_data_fin_enabled(const struct mptcp_sock *msk)
+{
+	return READ_ONCE(msk->snd_data_fin_enable) &&
+	       READ_ONCE(msk->write_seq) == READ_ONCE(msk->snd_nxt);
+}
+
 void mptcp_destroy_common(struct mptcp_sock *msk);
 
 void __init mptcp_token_init(void);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ac4a1fe3550b..42581ffb0c7e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1125,6 +1125,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (err && err != -EINPROGRESS)
 		goto failed;
 
+	sock_hold(ssk);
 	spin_lock_bh(&msk->join_list_lock);
 	list_add_tail(&subflow->node, &msk->join_list);
 	spin_unlock_bh(&msk->join_list_lock);
@@ -1132,6 +1133,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	return err;
 
 failed:
+	subflow->disposable = 1;
 	sock_release(sf);
 	return err;
 }
@@ -1254,7 +1256,6 @@ static void subflow_state_change(struct sock *sk)
 		mptcp_data_ready(parent, sk);
 
 	if (__mptcp_check_fallback(mptcp_sk(parent)) &&
-	    !(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
 		subflow->rx_eof = 1;
 		mptcp_subflow_eof(parent);
@@ -1297,17 +1298,26 @@ static int subflow_ulp_init(struct sock *sk)
 	return err;
 }
 
-static void subflow_ulp_release(struct sock *sk)
+static void subflow_ulp_release(struct sock *ssk)
 {
-	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(ssk);
+	bool release = true;
+	struct sock *sk;
 
 	if (!ctx)
 		return;
 
-	if (ctx->conn)
-		sock_put(ctx->conn);
+	sk = ctx->conn;
+	if (sk) {
+		/* if the msk has been orphaned, keep the ctx
+		 * alive, will be freed by mptcp_done()
+		 */
+		release = ctx->disposable;
+		sock_put(sk);
+	}
 
-	kfree_rcu(ctx, rcu);
+	if (release)
+		kfree_rcu(ctx, rcu);
 }
 
 static void subflow_ulp_clone(const struct request_sock *req,
-- 
2.26.2

