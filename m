Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294A449599
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfFQW73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbfFQW6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:51 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 21/33] mptcp: add and use mptcp_subflow_hold
Date:   Mon, 17 Jun 2019 15:57:56 -0700
Message-Id: <20190617225808.665-22-mathew.j.martineau@linux.intel.com>
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

subflow sockets already have lifetime managed by RCU, so we can
switch to atomic_inc_not_zero and skip/pretend we did not find
such socket in the mptcp subflow list.

This is required to get rid of synchronize_rcu() from mptcp_close().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 104 +++++++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 38 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c00e837a1766..0db4099d9c13 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,14 +24,35 @@ static inline bool before64(__u64 seq1, __u64 seq2)
 
 #define after64(seq2, seq1)	before64(seq1, seq2)
 
+static bool mptcp_subflow_hold(struct subflow_context *subflow)
+{
+	struct sock *sk = mptcp_subflow_tcp_socket(subflow)->sk;
+
+	return refcount_inc_not_zero(&sk->sk_refcnt);
+}
+
+static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
+{
+	struct subflow_context *subflow;
+
+	rcu_read_lock();
+	mptcp_for_each_subflow(msk, subflow) {
+		if (mptcp_subflow_hold(subflow)) {
+			rcu_read_unlock();
+			return mptcp_subflow_tcp_socket(subflow)->sk;
+		}
+	}
+
+	rcu_read_unlock();
+	return NULL;
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int mss_now, size_goal, poffset, ret;
 	struct mptcp_ext *mpext = NULL;
-	struct subflow_context *subflow;
 	struct page *page = NULL;
-	struct hlist_node *node;
 	struct sk_buff *skb;
 	struct sock *ssk;
 	size_t psize;
@@ -42,20 +63,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return sock_sendmsg(msk->subflow, msg);
 	}
 
-	rcu_read_lock();
-	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
-	subflow = hlist_entry(node, struct subflow_context, node);
-	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
-	sock_hold(ssk);
-	rcu_read_unlock();
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk)
+		return -ENOTCONN;
 
 	if (!msg_data_left(msg)) {
 		pr_debug("empty send");
-		ret = sock_sendmsg(mptcp_subflow_tcp_socket(subflow), msg);
+		ret = sock_sendmsg(ssk->sk_socket, msg);
 		goto put_out;
 	}
 
-	pr_debug("conn_list->subflow=%p", subflow);
+	pr_debug("conn_list->subflow=%p", ssk);
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL)) {
 		ret = -ENOTSUPP;
@@ -293,7 +311,6 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct subflow_context *subflow;
 	struct mptcp_read_arg arg;
-	struct hlist_node *node;
 	read_descriptor_t desc;
 	struct tcp_sock *tp;
 	struct sock *ssk;
@@ -306,13 +323,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return sock_recvmsg(msk->subflow, msg, flags);
 	}
 
-	rcu_read_lock();
-	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
-	subflow = hlist_entry(node, struct subflow_context, node);
-	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
-	sock_hold(ssk);
-	rcu_read_unlock();
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk)
+		return -ENOTCONN;
 
+	subflow = subflow_ctx(ssk);
 	tp = tcp_sk(ssk);
 
 	lock_sock(sk);
@@ -778,8 +793,6 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 			 int peer)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
-	struct subflow_context *subflow;
-	struct hlist_node *node;
 	struct sock *ssk;
 	int ret;
 
@@ -794,14 +807,11 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 	 * is connected and there are multiple subflows is not defined.
 	 * For now just use the first subflow on the list.
 	 */
-	rcu_read_lock();
-	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
-	subflow = hlist_entry(node, struct subflow_context, node);
-	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
-	sock_hold(ssk);
-	rcu_read_unlock();
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk)
+		return -ENOTCONN;
 
-	ret = inet_getname(mptcp_subflow_tcp_socket(subflow), uaddr, peer);
+	ret = inet_getname(ssk->sk_socket, uaddr, peer);
 	sock_put(ssk);
 	return ret;
 }
@@ -837,26 +847,44 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
-	const struct mptcp_sock *msk;
 	struct subflow_context *subflow;
+	const struct mptcp_sock *msk;
 	struct sock *sk = sock->sk;
-	struct hlist_node *node;
-	struct sock *ssk;
-	__poll_t ret;
+	__poll_t ret = 0;
+	unsigned int i;
 
 	msk = mptcp_sk(sk);
 	if (msk->subflow)
 		return tcp_poll(file, msk->subflow, wait);
 
-	rcu_read_lock();
-	node = rcu_dereference(hlist_first_rcu(&msk->conn_list));
-	subflow = hlist_entry(node, struct subflow_context, node);
-	ssk = mptcp_subflow_tcp_socket(subflow)->sk;
-	sock_hold(ssk);
-	rcu_read_unlock();
+	i = 0;
+	for (;;) {
+		struct subflow_context *tmp = NULL;
+		int j = 0;
+
+		rcu_read_lock();
+		mptcp_for_each_subflow(msk, subflow) {
+			if (j < i) {
+				j++;
+				continue;
+			}
+
+			if (!mptcp_subflow_hold(subflow))
+				continue;
+
+			tmp = subflow;
+			i++;
+			break;
+		}
+		rcu_read_unlock();
+
+		if (!tmp)
+			break;
+
+		ret |= tcp_poll(file, mptcp_subflow_tcp_socket(tmp), wait);
+		sock_put(mptcp_subflow_tcp_socket(tmp)->sk);
+	}
 
-	ret = tcp_poll(file, ssk->sk_socket, wait);
-	sock_put(ssk);
 	return ret;
 }
 
-- 
2.22.0

