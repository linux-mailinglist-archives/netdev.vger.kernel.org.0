Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9996E4958F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfFQW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfFQW65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:51 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 20/33] mptcp: Make connection_list a real list of subflows
Date:   Mon, 17 Jun 2019 15:57:55 -0700
Message-Id: <20190617225808.665-21-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Use the MPTCP socket lock to mutually exclude shutdown and close
execution.

Since mptcp_close() is the only code path that removes entries from
conn_list, we can safely traverse the list while interrupting the RCU
critical section.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 222 ++++++++++++++++++++++++++++++++-----------
 net/mptcp/protocol.h |   9 +-
 2 files changed, 172 insertions(+), 59 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2e76b7450ce2..c00e837a1766 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -29,34 +29,48 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int mss_now, size_goal, poffset, ret;
 	struct mptcp_ext *mpext = NULL;
+	struct subflow_context *subflow;
 	struct page *page = NULL;
+	struct hlist_node *node;
 	struct sk_buff *skb;
 	struct sock *ssk;
 	size_t psize;
 
 	pr_debug("msk=%p", msk);
-	if (!msk->connection_list && msk->subflow) {
+	if (msk->subflow) {
 		pr_debug("fallback passthrough");
 		return sock_sendmsg(msk->subflow, msg);
 	}
 
+	rcu_read_lock();
+	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
+	subflow = hlist_entry(node, struct subflow_context, node);
+	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
+	sock_hold(ssk);
+	rcu_read_unlock();
+
 	if (!msg_data_left(msg)) {
 		pr_debug("empty send");
-		return sock_sendmsg(msk->connection_list, msg);
+		ret = sock_sendmsg(mptcp_subflow_tcp_socket(subflow), msg);
+		goto put_out;
 	}
 
-	ssk = msk->connection_list->sk;
+	pr_debug("conn_list->subflow=%p", subflow);
 
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
-		return -ENOTSUPP;
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL)) {
+		ret = -ENOTSUPP;
+		goto put_out;
+	}
 
 	/* Initial experiment: new page per send.  Real code will
 	 * maintain list of active pages and DSS mappings, append to the
 	 * end and honor zerocopy
 	 */
 	page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
+	if (!page) {
+		ret = -ENOMEM;
+		goto put_out;
+	}
 
 	/* Copy to page */
 	poffset = 0;
@@ -68,8 +82,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	pr_debug("left=%zu", msg_data_left(msg));
 
 	if (!psize) {
-		put_page(page);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_out;
 	}
 
 	lock_sock(sk);
@@ -87,9 +101,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	ret = do_tcp_sendpages(ssk, page, poffset, min_t(int, size_goal, psize),
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
-	put_page(page);
 	if (ret <= 0)
-		goto error_out;
+		goto release_out;
 
 	if (skb == tcp_write_queue_tail(ssk))
 		pr_err("no new skb %p/%p", sk, ssk);
@@ -117,10 +130,15 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
 
-error_out:
+release_out:
 	release_sock(ssk);
 	release_sock(sk);
 
+put_out:
+	if (page)
+		put_page(page);
+
+	sock_put(ssk);
 	return ret;
 }
 
@@ -275,20 +293,26 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct subflow_context *subflow;
 	struct mptcp_read_arg arg;
+	struct hlist_node *node;
 	read_descriptor_t desc;
 	struct tcp_sock *tp;
 	struct sock *ssk;
 	int copied = 0;
 	long timeo;
 
-	if (!msk->connection_list) {
+	if (msk->subflow) {
 		pr_debug("fallback-read subflow=%p",
 			 subflow_ctx(msk->subflow->sk));
 		return sock_recvmsg(msk->subflow, msg, flags);
 	}
 
-	ssk = msk->connection_list->sk;
-	subflow = subflow_ctx(ssk);
+	rcu_read_lock();
+	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
+	subflow = hlist_entry(node, struct subflow_context, node);
+	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
+	sock_hold(ssk);
+	rcu_read_unlock();
+
 	tp = tcp_sk(ssk);
 
 	lock_sock(sk);
@@ -450,6 +474,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	release_sock(ssk);
 	release_sock(sk);
 
+	sock_put(ssk);
+
 	return copied;
 }
 
@@ -459,24 +485,56 @@ static int mptcp_init_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
+	INIT_LIST_HEAD_RCU(&msk->conn_list);
+	spin_lock_init(&msk->conn_list_lock);
+
 	return 0;
 }
 
+static void mptcp_flush_conn_list(struct sock *sk, struct list_head *list)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	INIT_LIST_HEAD_RCU(list);
+	spin_lock_bh(&msk->conn_list_lock);
+	list_splice_init(&msk->conn_list, list);
+	spin_unlock_bh(&msk->conn_list_lock);
+
+	if (!list_empty(list))
+		synchronize_rcu();
+}
+
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct subflow_context *subflow, *tmp;
+	struct socket *ssk = NULL;
+	struct list_head list;
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
+	spin_lock_bh(&msk->conn_list_lock);
 	if (msk->subflow) {
-		pr_debug("subflow=%p", subflow_ctx(msk->subflow->sk));
-		sock_release(msk->subflow);
+		ssk = msk->subflow;
+		msk->subflow = NULL;
 	}
+	spin_unlock_bh(&msk->conn_list_lock);
+	if (ssk) {
+		pr_debug("subflow=%p", ssk->sk);
+		sock_release(ssk);
+	}
+
+	/* this is the only place where we can remove any entry from the
+	 * conn_list. Additionally acquiring the socket lock here
+	 * allows for mutual exclusion with mptcp_shutdown().
+	 */
+	lock_sock(sk);
+	mptcp_flush_conn_list(sk, &list);
+	release_sock(sk);
 
-	if (msk->connection_list) {
-		pr_debug("conn_list->subflow=%p",
-			 subflow_ctx(msk->connection_list->sk));
-		sock_release(msk->connection_list);
+	list_for_each_entry_safe(subflow, tmp, &list, node) {
+		pr_debug("conn_list->subflow=%p", subflow);
+		sock_release(mptcp_subflow_tcp_socket(subflow));
 	}
 
 	sock_orphan(sk);
@@ -518,7 +576,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		token_update_accept(new_sock->sk, new_mptcp_sock->sk);
-		msk->connection_list = new_sock;
+		spin_lock_bh(&msk->conn_list_lock);
+		list_add_rcu(&subflow->node, &msk->conn_list);
+		msk->subflow = NULL;
+		spin_unlock_bh(&msk->conn_list_lock);
 
 		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
@@ -550,46 +611,46 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    char __user *uoptval, unsigned int optlen)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow;
 	char __kernel *optval;
 
-	pr_debug("msk=%p", msk);
-	if (msk->connection_list) {
-		subflow = msk->connection_list;
-		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
-	} else {
-		subflow = msk->subflow;
-		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
-	}
-
 	/* will be treated as __user in tcp_setsockopt */
 	optval = (char __kernel __force *)uoptval;
 
-	return kernel_setsockopt(subflow, level, optname, optval, optlen);
+	pr_debug("msk=%p", msk);
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		return kernel_setsockopt(msk->subflow, level, optname, optval,
+					 optlen);
+	}
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	return 0;
 }
 
 static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *uoptval, int __user *uoption)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow;
 	char __kernel *optval;
 	int __kernel *option;
 
-	pr_debug("msk=%p", msk);
-	if (msk->connection_list) {
-		subflow = msk->connection_list;
-		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
-	} else {
-		subflow = msk->subflow;
-		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
-	}
-
 	/* will be treated as __user in tcp_getsockopt */
 	optval = (char __kernel __force *)uoptval;
 	option = (int __kernel __force *)uoption;
 
-	return kernel_getsockopt(subflow, level, optname, optval, option);
+	pr_debug("msk=%p", msk);
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		return kernel_getsockopt(msk->subflow, level, optname, optval,
+					 option);
+	}
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	return 0;
 }
 
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
@@ -613,8 +674,10 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		pr_debug("msk=%p, token=%u", msk, msk->token);
-		msk->connection_list = msk->subflow;
+		spin_lock_bh(&msk->conn_list_lock);
+		list_add_rcu(&subflow->node, &msk->conn_list);
 		msk->subflow = NULL;
+		spin_unlock_bh(&msk->conn_list_lock);
 
 		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
@@ -715,17 +778,32 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 			 int peer)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
-	struct socket *subflow;
-	int err = -EPERM;
+	struct subflow_context *subflow;
+	struct hlist_node *node;
+	struct sock *ssk;
+	int ret;
 
-	if (msk->connection_list)
-		subflow = msk->connection_list;
-	else
-		subflow = msk->subflow;
+	pr_debug("msk=%p", msk);
 
-	err = inet_getname(subflow, uaddr, peer);
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		return inet_getname(msk->subflow, uaddr, peer);
+	}
 
-	return err;
+	/* @@ the meaning of getname() for the remote peer when the socket
+	 * is connected and there are multiple subflows is not defined.
+	 * For now just use the first subflow on the list.
+	 */
+	rcu_read_lock();
+	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
+	subflow = hlist_entry(node, struct subflow_context, node);
+	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
+	sock_hold(ssk);
+	rcu_read_unlock();
+
+	ret = inet_getname(mptcp_subflow_tcp_socket(subflow), uaddr, peer);
+	sock_put(ssk);
+	return ret;
 }
 
 static int mptcp_listen(struct socket *sock, int backlog)
@@ -760,31 +838,59 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
 	const struct mptcp_sock *msk;
+	struct subflow_context *subflow;
 	struct sock *sk = sock->sk;
+	struct hlist_node *node;
+	struct sock *ssk;
+	__poll_t ret;
 
 	msk = mptcp_sk(sk);
 	if (msk->subflow)
 		return tcp_poll(file, msk->subflow, wait);
 
-	return tcp_poll(file, msk->connection_list, wait);
+	rcu_read_lock();
+	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
+	subflow = hlist_entry(node, struct subflow_context, node);
+	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
+	sock_hold(ssk);
+	rcu_read_unlock();
+
+	ret = tcp_poll(file, ssk->sk_socket, wait);
+	sock_put(ssk);
+	return ret;
 }
 
 static int mptcp_shutdown(struct socket *sock, int how)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct subflow_context *subflow;
 	int ret = 0;
 
 	pr_debug("sk=%p, how=%d", msk, how);
 
 	if (msk->subflow) {
 		pr_debug("subflow=%p", msk->subflow->sk);
-		ret = kernel_sock_shutdown(msk->subflow, how);
+		return kernel_sock_shutdown(msk->subflow, how);
 	}
 
-	if (msk->connection_list) {
-		pr_debug("conn_list->subflow=%p", msk->connection_list->sk);
-		ret = kernel_sock_shutdown(msk->connection_list, how);
+	/* protect against concurrent mptcp_close(), so that nobody can
+	 * remove entries from the conn list and walking the list breaking
+	 * the RCU critical section is still safe. We need to release the
+	 * RCU lock to call the blocking kernel_sock_shutdown() primitive
+	 * Note: we can't use MPTCP socket lock to protect conn_list changes,
+	 * as we need to update it from the BH via the mptcp_finish_connect()
+	 */
+	lock_sock(sock->sk);
+	rcu_read_lock();
+	list_for_each_entry_rcu(subflow, &msk->conn_list, node) {
+		pr_debug("conn_list->subflow=%p", subflow);
+		rcu_read_unlock();
+		ret = kernel_sock_shutdown(mptcp_subflow_tcp_socket(subflow),
+					   how);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
+	release_sock(sock->sk);
 
 	return ret;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5c840f76a9b9..a1bf093bb37e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,8 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+#include <linux/spinlock.h>
+
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
 #define MPTCPOPT_MP_JOIN	1
@@ -52,10 +54,14 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u32		token;
-	struct socket	*connection_list; /* @@ needs to be a list */
+	spinlock_t	conn_list_lock;
+	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
 
+#define mptcp_for_each_subflow(__msk, __subflow)			\
+	list_for_each_entry_rcu(__subflow, &((__msk)->conn_list), node)
+
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 {
 	return (struct mptcp_sock *)sk;
@@ -83,6 +89,7 @@ struct subflow_request_sock *subflow_rsk(const struct request_sock *rsk)
 
 /* MPTCP subflow context */
 struct subflow_context {
+	struct	list_head node;/* conn_list of subflows */
 	u64	local_key;
 	u64	remote_key;
 	u32	token;
-- 
2.22.0

