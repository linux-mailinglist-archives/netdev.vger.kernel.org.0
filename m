Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04F49593
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfFQW7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbfFQW64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:52 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 30/33] mptcp: switch sublist to mptcp socket lock protection
Date:   Mon, 17 Jun 2019 15:58:05 -0700
Message-Id: <20190617225808.665-31-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The mptcp sublist is currently guarded by rcu, but this comes with
several artifacts that make little sense.

1. There is a synchronize_rcu after stealing the subflow list on
   each mptcp socket close.

   synchronize_rcu() is a very expensive call, and should not be
   needed.

2. There is a extra spinlock to guard the list, ey we can't use
   the lock in some cases because we need to call functions that
   might sleep.

3. There is a 'mptcp_subflow_hold()' function that uses
   an 'atomic_inc_not_zero' call.  This wasn't needed even with
   current code:  The owning mptcp socket holds references on its
   subflows, so a subflow socket that is still found on the list
   will always have a nonzero reference count.

This changes the subflow list to always be guarded by the owning
mptcp socket lock.  This is safe as long as no code path that holds
a mptcp subflow tcp socket lock will try to lock the owning mptcp
sockets lock.

The inverse -- locking the tcp subflow lock while holding the
mptcp lock -- is fine.

mptcp_subflow_get_ref() will have to be altered later when we
support multiple subflows so it will pick a 'preferred' subflow
rather than the first one in the list.

v4: - remove all sk_state changes added in v2/v3, they do not
    belong here -- it should be done as a separate change.
    - prefer mptcp_for_each_subflow rather than list_for_each_entry.

v3: use BH locking scheme in mptcp_finish_connect, there is no
    guarantee we are always called from backlog processing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 159 +++++++++++++++++++------------------------
 net/mptcp/protocol.h |   3 +-
 2 files changed, 72 insertions(+), 90 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8c7b0f39394e..d4ffa47f53ef 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,26 +24,20 @@ static inline bool before64(__u64 seq1, __u64 seq2)
 
 #define after64(seq2, seq1)	before64(seq1, seq2)
 
-static bool mptcp_subflow_hold(struct subflow_context *subflow)
-{
-	struct sock *sk = mptcp_subflow_tcp_socket(subflow)->sk;
-
-	return refcount_inc_not_zero(&sk->sk_refcnt);
-}
-
 static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
 {
 	struct subflow_context *subflow;
 
-	rcu_read_lock();
+	sock_owned_by_me((const struct sock *)msk);
+
 	mptcp_for_each_subflow(msk, subflow) {
-		if (mptcp_subflow_hold(subflow)) {
-			rcu_read_unlock();
-			return mptcp_subflow_tcp_socket(subflow)->sk;
-		}
+		struct sock *sk;
+
+		sk = mptcp_subflow_tcp_socket(subflow)->sk;
+		sock_hold(sk);
+		return sk;
 	}
 
-	rcu_read_unlock();
 	return NULL;
 }
 
@@ -174,9 +168,12 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return sock_sendmsg(msk->subflow, msg);
 	}
 
+	lock_sock(sk);
 	ssk = mptcp_subflow_get_ref(msk);
-	if (!ssk)
+	if (!ssk) {
+		release_sock(sk);
 		return -ENOTCONN;
+	}
 
 	if (!msg_data_left(msg)) {
 		pr_debug("empty send");
@@ -191,7 +188,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto put_out;
 	}
 
-	lock_sock(sk);
 	lock_sock(ssk);
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	while (msg_data_left(msg)) {
@@ -209,9 +205,9 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	release_sock(ssk);
-	release_sock(sk);
 
 put_out:
+	release_sock(sk);
 	sock_put(ssk);
 	return ret;
 }
@@ -379,14 +375,16 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return sock_recvmsg(msk->subflow, msg, flags);
 	}
 
+	lock_sock(sk);
 	ssk = mptcp_subflow_get_ref(msk);
-	if (!ssk)
+	if (!ssk) {
+		release_sock(sk);
 		return -ENOTCONN;
+	}
 
 	subflow = subflow_ctx(ssk);
 	tp = tcp_sk(ssk);
 
-	lock_sock(sk);
 	lock_sock(ssk);
 
 	desc.arg.data = &arg;
@@ -556,57 +554,36 @@ static int mptcp_init_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
-	INIT_LIST_HEAD_RCU(&msk->conn_list);
-	spin_lock_init(&msk->conn_list_lock);
+	INIT_LIST_HEAD(&msk->conn_list);
 
 	return 0;
 }
 
-static void mptcp_flush_conn_list(struct sock *sk, struct list_head *list)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	INIT_LIST_HEAD_RCU(list);
-	spin_lock_bh(&msk->conn_list_lock);
-	list_splice_init(&msk->conn_list, list);
-	spin_unlock_bh(&msk->conn_list_lock);
-
-	if (!list_empty(list))
-		synchronize_rcu();
-}
-
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct subflow_context *subflow, *tmp;
 	struct socket *ssk = NULL;
-	struct list_head list;
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	spin_lock_bh(&msk->conn_list_lock);
+	lock_sock(sk);
+
 	if (msk->subflow) {
 		ssk = msk->subflow;
 		msk->subflow = NULL;
 	}
-	spin_unlock_bh(&msk->conn_list_lock);
+
 	if (ssk) {
 		pr_debug("subflow=%p", ssk->sk);
 		sock_release(ssk);
 	}
 
-	/* this is the only place where we can remove any entry from the
-	 * conn_list. Additionally acquiring the socket lock here
-	 * allows for mutual exclusion with mptcp_shutdown().
-	 */
-	lock_sock(sk);
-	mptcp_flush_conn_list(sk, &list);
-	release_sock(sk);
-
-	list_for_each_entry_safe(subflow, tmp, &list, node) {
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		pr_debug("conn_list->subflow=%p", subflow);
 		sock_release(mptcp_subflow_tcp_socket(subflow));
 	}
+	release_sock(sk);
 
 	sock_orphan(sk);
 	sock_put(sk);
@@ -633,11 +610,14 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		struct sock *new_mptcp_sock;
 		u64 ack_seq;
 
+		lock_sock(sk);
+
 		local_bh_disable();
 		new_mptcp_sock = sk_clone_lock(sk, GFP_ATOMIC);
 		if (!new_mptcp_sock) {
 			*err = -ENOBUFS;
 			local_bh_enable();
+			release_sock(sk);
 			kernel_sock_shutdown(new_sock, SHUT_RDWR);
 			sock_release(new_sock);
 			return NULL;
@@ -650,10 +630,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		token_update_accept(new_sock->sk, new_mptcp_sock);
-		spin_lock(&msk->conn_list_lock);
-		list_add_rcu(&subflow->node, &msk->conn_list);
 		msk->subflow = NULL;
-		spin_unlock(&msk->conn_list_lock);
 
 		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
@@ -665,9 +642,11 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		subflow->tcp_sock = new_sock;
 		newsk = new_mptcp_sock;
 		subflow->conn = new_mptcp_sock;
+		list_add(&subflow->node, &msk->conn_list);
 		bh_unlock_sock(new_mptcp_sock);
 		local_bh_enable();
 		inet_sk_state_store(newsk, TCP_ESTABLISHED);
+		release_sock(sk);
 	} else {
 		newsk = new_sock->sk;
 		tcp_sk(newsk)->is_mptcp = 0;
@@ -750,14 +729,33 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	if (mp_capable) {
 		u64 ack_seq;
 
+		/* sk (new subflow socket) is already locked, but we need
+		 * to lock the parent (mptcp) socket now to add the tcp socket
+		 * to the subflow list.
+		 *
+		 * From lockdep point of view, this creates an ABBA type
+		 * deadlock: Normally (sendmsg, recvmsg, ..), we lock the mptcp
+		 * socket, then acquire a subflow lock.
+		 * Here we do the reverse: "subflow lock, then mptcp lock".
+		 *
+		 * Its alright to do this here, because this subflow is not yet
+		 * on the mptcp sockets subflow list.
+		 *
+		 * IOW, if another CPU has this mptcp socket locked, it cannot
+		 * acquire this particular subflow, because subflow->sk isn't
+		 * on msk->conn_list.
+		 *
+		 * This function can be called either from backlog processing
+		 * (BH will be enabled) or from softirq, so we need to use BH
+		 * locking scheme.
+		 */
+		local_bh_disable();
+		bh_lock_sock_nested(sk);
+
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		pr_debug("msk=%p, token=%u", msk, msk->token);
-		spin_lock_bh(&msk->conn_list_lock);
-		list_add_rcu(&subflow->node, &msk->conn_list);
-		msk->subflow = NULL;
-		spin_unlock_bh(&msk->conn_list_lock);
 
 		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
@@ -766,6 +764,11 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 		subflow->map_seq = ack_seq;
 		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
+
+		list_add(&subflow->node, &msk->conn_list);
+		msk->subflow = NULL;
+		bh_unlock_sock(sk);
+		local_bh_enable();
 	}
 	inet_sk_state_store(sk, TCP_ESTABLISHED);
 }
@@ -884,11 +887,15 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 	 * is connected and there are multiple subflows is not defined.
 	 * For now just use the first subflow on the list.
 	 */
+	lock_sock(sock->sk);
 	ssk = mptcp_subflow_get_ref(msk);
-	if (!ssk)
+	if (!ssk) {
+		release_sock(sock->sk);
 		return -ENOTCONN;
+	}
 
 	ret = inet_getname(ssk->sk_socket, uaddr, peer);
+	release_sock(sock->sk);
 	sock_put(ssk);
 	return ret;
 }
@@ -928,39 +935,19 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	const struct mptcp_sock *msk;
 	struct sock *sk = sock->sk;
 	__poll_t ret = 0;
-	unsigned int i;
 
 	msk = mptcp_sk(sk);
 	if (msk->subflow)
 		return tcp_poll(file, msk->subflow, wait);
 
-	i = 0;
-	for (;;) {
-		struct subflow_context *tmp = NULL;
-		int j = 0;
-
-		rcu_read_lock();
-		mptcp_for_each_subflow(msk, subflow) {
-			if (j < i) {
-				j++;
-				continue;
-			}
-
-			if (!mptcp_subflow_hold(subflow))
-				continue;
-
-			tmp = subflow;
-			i++;
-			break;
-		}
-		rcu_read_unlock();
-
-		if (!tmp)
-			break;
+	lock_sock(sk);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct socket *tcp_sock;
 
-		ret |= tcp_poll(file, mptcp_subflow_tcp_socket(tmp), wait);
-		sock_put(mptcp_subflow_tcp_socket(tmp)->sk);
+		tcp_sock = mptcp_subflow_tcp_socket(subflow);
+		ret |= tcp_poll(file, tcp_sock, wait);
 	}
+	release_sock(sk);
 
 	return ret;
 }
@@ -979,24 +966,20 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	}
 
 	/* protect against concurrent mptcp_close(), so that nobody can
-	 * remove entries from the conn list and walking the list breaking
-	 * the RCU critical section is still safe. We need to release the
-	 * RCU lock to call the blocking kernel_sock_shutdown() primitive
-	 * Note: we can't use MPTCP socket lock to protect conn_list changes,
+	 * remove entries from the conn list and walking the list
+	 * is still safe.
+	 *
+	 * We can't use MPTCP socket lock to protect conn_list changes,
 	 * as we need to update it from the BH via the mptcp_finish_connect()
 	 */
 	lock_sock(sock->sk);
-	rcu_read_lock();
-	list_for_each_entry_rcu(subflow, &msk->conn_list, node) {
+	mptcp_for_each_subflow(msk, subflow) {
 		struct socket *tcp_socket;
 
 		tcp_socket = mptcp_subflow_tcp_socket(subflow);
-		rcu_read_unlock();
 		pr_debug("conn_list->subflow=%p", subflow);
 		ret = kernel_sock_shutdown(tcp_socket, how);
-		rcu_read_lock();
 	}
-	rcu_read_unlock();
 	release_sock(sock->sk);
 
 	return ret;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a1bf093bb37e..556981f9e5fd 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -54,13 +54,12 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u32		token;
-	spinlock_t	conn_list_lock;
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
-	list_for_each_entry_rcu(__subflow, &((__msk)->conn_list), node)
+	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
 
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 {
-- 
2.22.0

