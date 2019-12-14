Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3111F089
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLNGEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:24722 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfLNGEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855228"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 12/15] mptcp: recvmsg() can drain data from multiple subflows
Date:   Fri, 13 Dec 2019 22:04:14 -0800
Message-Id: <20191214060417.2870-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

With the previous patch in place, the msk can detect which subflow
has the current map with a simple walk, let's update the main
loop to always select the 'current' subflow. The exit conditions now
closely mirror tcp_recvmsg() to get expected timeout and signal
behavior.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 178 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 168 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 44e6f0d1070c..fd89075bd1c9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/sched/signal.h>
+#include <linux/atomic.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -106,6 +108,21 @@ static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 	return !!msk->cached_ext;
 }
 
+static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct mptcp_subflow_context *subflow;
+
+	sock_owned_by_me(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		if (subflow->data_avail)
+			return mptcp_subflow_tcp_sock(subflow);
+	}
+
+	return NULL;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct msghdr *msg, long *timeo)
 {
@@ -271,13 +288,37 @@ int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
 	return copy_len;
 }
 
+static void mptcp_wait_data(struct sock *sk, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	sk_wait_event(sk, timeo,
+		      test_and_clear_bit(MPTCP_DATA_READY, &msk->flags), &wait);
+
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	bool more_data_avail = false;
+	struct mptcp_read_arg arg;
+	read_descriptor_t desc;
+	bool wait_data = false;
 	struct socket *ssock;
+	struct tcp_sock *tp;
+	bool done = false;
 	struct sock *ssk;
 	int copied = 0;
+	int target;
+	long timeo;
 
 	lock_sock(sk);
 	ssock = __mptcp_tcp_fallback(msk);
@@ -289,16 +330,124 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return copied;
 	}
 
-	ssk = mptcp_subflow_get(msk);
-	if (!ssk) {
-		release_sock(sk);
-		return -ENOTCONN;
+	arg.msg = msg;
+	desc.arg.data = &arg;
+	desc.error = 0;
+
+	timeo = sock_rcvtimeo(sk, nonblock);
+
+	len = min_t(size_t, len, INT_MAX);
+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+
+	while (!done) {
+		u32 map_remaining;
+		int bytes_read;
+
+		ssk = mptcp_subflow_recv_lookup(msk);
+		pr_debug("msk=%p ssk=%p", msk, ssk);
+		if (!ssk)
+			goto wait_for_data;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		tp = tcp_sk(ssk);
+
+		lock_sock(ssk);
+		do {
+			/* try to read as much data as available */
+			map_remaining = subflow->map_data_len -
+					mptcp_subflow_get_map_offset(subflow);
+			desc.count = min_t(size_t, len - copied, map_remaining);
+			pr_debug("reading %zu bytes, copied %d", desc.count,
+				 copied);
+			bytes_read = tcp_read_sock(ssk, &desc,
+						   mptcp_read_actor);
+			if (bytes_read < 0) {
+				if (!copied)
+					copied = bytes_read;
+				done = true;
+				goto next;
+			}
+
+			pr_debug("msk ack_seq=%llx -> %llx", msk->ack_seq,
+				 msk->ack_seq + bytes_read);
+			msk->ack_seq += bytes_read;
+			copied += bytes_read;
+			if (copied >= len) {
+				done = true;
+				goto next;
+			}
+			if (tp->urg_data && tp->urg_seq == tp->copied_seq) {
+				pr_err("Urgent data present, cannot proceed");
+				done = true;
+				goto next;
+			}
+next:
+			more_data_avail = mptcp_subflow_data_available(ssk);
+		} while (more_data_avail && !done);
+		release_sock(ssk);
+		continue;
+
+wait_for_data:
+		more_data_avail = false;
+
+		/* only the master socket status is relevant here. The exit
+		 * conditions mirror closely tcp_recvmsg()
+		 */
+		if (copied >= target)
+			break;
+
+		if (copied) {
+			if (sk->sk_err ||
+			    sk->sk_state == TCP_CLOSE ||
+			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+			    !timeo ||
+			    signal_pending(current))
+				break;
+		} else {
+			if (sk->sk_err) {
+				copied = sock_error(sk);
+				break;
+			}
+
+			if (sk->sk_shutdown & RCV_SHUTDOWN)
+				break;
+
+			if (sk->sk_state == TCP_CLOSE) {
+				copied = -ENOTCONN;
+				break;
+			}
+
+			if (!timeo) {
+				copied = -EAGAIN;
+				break;
+			}
+
+			if (signal_pending(current)) {
+				copied = sock_intr_errno(timeo);
+				break;
+			}
+		}
+
+		pr_debug("block timeout %ld", timeo);
+		wait_data = true;
+		mptcp_wait_data(sk, &timeo);
 	}
 
-	copied = sock_recvmsg(ssk->sk_socket, msg, flags);
+	if (more_data_avail) {
+		if (!test_bit(MPTCP_DATA_READY, &msk->flags))
+			set_bit(MPTCP_DATA_READY, &msk->flags);
+	} else if (!wait_data) {
+		clear_bit(MPTCP_DATA_READY, &msk->flags);
 
-	release_sock(sk);
+		/* .. race-breaker: ssk might get new data after last
+		 * data_available() returns false.
+		 */
+		ssk = mptcp_subflow_recv_lookup(msk);
+		if (unlikely(ssk))
+			set_bit(MPTCP_DATA_READY, &msk->flags);
+	}
 
+	release_sock(sk);
 	return copied;
 }
 
@@ -459,10 +608,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->write_seq = subflow->idsn + 1;
 		ack_seq++;
 		msk->ack_seq = ack_seq;
-		subflow->map_seq = ack_seq;
-		subflow->map_subflow_seq = 1;
-		subflow->rel_write_seq = 1;
-		subflow->tcp_sock = ssk;
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -474,6 +619,19 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		bh_unlock_sock(new_mptcp_sock);
 		local_bh_enable();
 		release_sock(sk);
+
+		/* the subflow can already receive packet, avoid racing with
+		 * the receive path and process the pending ones
+		 */
+		lock_sock(ssk);
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
+		subflow->rel_write_seq = 1;
+		subflow->tcp_sock = ssk;
+		subflow->conn = new_mptcp_sock;
+		if (unlikely(!skb_queue_empty(&ssk->sk_receive_queue)))
+			mptcp_subflow_data_available(ssk);
+		release_sock(ssk);
 	} else {
 		tcp_sk(newsk)->is_mptcp = 0;
 	}
-- 
2.24.1

