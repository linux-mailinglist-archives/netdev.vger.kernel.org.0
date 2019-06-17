Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C7649594
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfFQW7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbfFQW64 (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [RFC PATCH net-next 29/33] mptcp: accept: don't leak mptcp socket structure
Date:   Mon, 17 Jun 2019 15:58:04 -0700
Message-Id: <20190617225808.665-30-mathew.j.martineau@linux.intel.com>
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

accept() is supposed to prepare and return a 'struct sock'.

The caller holds a new inode/socket, and will associate the
returned sock with it.

mptcp_accept however will allocate it via 'struct socket', then
returns socket->sk.
This then leaks the outer socket struct inode returned by sock_create():

unreferenced object 0xffff88810512e8c0 (size 936):
  comm "mptcp_connect", [..]
  backtrace:
    [<00000000872561ba>] alloc_inode+0x35/0xe0
    [<00000000646e04ed>] new_inode_pseudo+0x12/0x80
    [<00000000e2e77036>] sock_alloc+0x26/0x100
    [<00000000870a8688>] __sock_create+0x8f/0x3c0
    [<000000000558b3fa>] mptcp_accept+0x140/0x530
    [<0000000044718d60>] inet_accept+0xac/0x470
    [<00000000da8f3979>] mptcp_stream_accept+0x62/0xa0
    [<00000000c9010499>] __sys_accept4+0x228/0x3c0

To fix this, make several (unfortunately, intrusive) changes:

1. Instead of allocating a new mptcp socket, clone the
   mptcp listen socket socket->sk.

   This gives us a mptcp sock without the inode container.
   We return this sock struct to the caller, the caller will then
   complete creation of the mptcp socket.

2. For the 'compat' (old tcp, not mp capable) case, return the
   tcp socket directly and release the socket coming from
   kernel_accept().

   We can use mptcp_getname() to override the socket->ops to
   tcp.  This will make mptcp_accept work like tcp accept, and
   mptcp won't be involved anymore for the particular socket.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 69 +++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3fb0f3163743..8c7b0f39394e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -617,9 +617,9 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *listener = msk->subflow;
-	struct socket *new_sock;
-	struct socket *new_mptcp_sock;
 	struct subflow_context *subflow;
+	struct socket *new_sock;
+	struct sock *newsk;
 
 	pr_debug("msk=%p, listener=%p", msk, subflow_ctx(listener->sk));
 	*err = kernel_accept(listener, &new_sock, flags);
@@ -629,28 +629,31 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	subflow = subflow_ctx(new_sock->sk);
 	pr_debug("msk=%p, new subflow=%p, ", msk, subflow);
 
-	*err = sock_create(PF_INET, SOCK_STREAM, IPPROTO_MPTCP,
-			   &new_mptcp_sock);
-	if (*err < 0) {
-		kernel_sock_shutdown(new_sock, SHUT_RDWR);
-		sock_release(new_sock);
-		return NULL;
-	}
-
-	msk = mptcp_sk(new_mptcp_sock->sk);
-	pr_debug("new msk=%p", msk);
-
 	if (subflow->mp_capable) {
+		struct sock *new_mptcp_sock;
 		u64 ack_seq;
 
+		local_bh_disable();
+		new_mptcp_sock = sk_clone_lock(sk, GFP_ATOMIC);
+		if (!new_mptcp_sock) {
+			*err = -ENOBUFS;
+			local_bh_enable();
+			kernel_sock_shutdown(new_sock, SHUT_RDWR);
+			sock_release(new_sock);
+			return NULL;
+		}
+
+		mptcp_init_sock(new_mptcp_sock);
+
+		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
-		token_update_accept(new_sock->sk, new_mptcp_sock->sk);
-		spin_lock_bh(&msk->conn_list_lock);
+		token_update_accept(new_sock->sk, new_mptcp_sock);
+		spin_lock(&msk->conn_list_lock);
 		list_add_rcu(&subflow->node, &msk->conn_list);
 		msk->subflow = NULL;
-		spin_unlock_bh(&msk->conn_list_lock);
+		spin_unlock(&msk->conn_list_lock);
 
 		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
@@ -659,14 +662,20 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		subflow->map_seq = ack_seq;
 		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
-		subflow->conn = new_mptcp_sock->sk;
 		subflow->tcp_sock = new_sock;
+		newsk = new_mptcp_sock;
+		subflow->conn = new_mptcp_sock;
+		bh_unlock_sock(new_mptcp_sock);
+		local_bh_enable();
+		inet_sk_state_store(newsk, TCP_ESTABLISHED);
 	} else {
-		msk->subflow = new_sock;
+		newsk = new_sock->sk;
+		tcp_sk(newsk)->is_mptcp = 0;
+		new_sock->sk = NULL;
+		sock_release(new_sock);
 	}
-	inet_sk_state_store(new_mptcp_sock->sk, TCP_ESTABLISHED);
 
-	return new_mptcp_sock->sk;
+	return newsk;
 }
 
 static void mptcp_destroy(struct sock *sk)
@@ -854,6 +863,18 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 
 	pr_debug("msk=%p", msk);
 
+	if (sock->sk->sk_prot == &tcp_prot) {
+		/* we are being invoked from __sys_accept4, after
+		 * mptcp_accept() has just accepted a non-mp-capable
+		 * flow: sk is a tcp_sk, not an mptcp one.
+		 *
+		 * Hand the socket over to tcp so all further socket ops
+		 * bypass mptcp.
+		 */
+		sock->ops = &inet_stream_ops;
+		return inet_getname(sock, uaddr, peer);
+	}
+
 	if (msk->subflow) {
 		pr_debug("subflow=%p", msk->subflow->sk);
 		return inet_getname(msk->subflow, uaddr, peer);
@@ -967,10 +988,12 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	lock_sock(sock->sk);
 	rcu_read_lock();
 	list_for_each_entry_rcu(subflow, &msk->conn_list, node) {
-		pr_debug("conn_list->subflow=%p", subflow);
+		struct socket *tcp_socket;
+
+		tcp_socket = mptcp_subflow_tcp_socket(subflow);
 		rcu_read_unlock();
-		ret = kernel_sock_shutdown(mptcp_subflow_tcp_socket(subflow),
-					   how);
+		pr_debug("conn_list->subflow=%p", subflow);
+		ret = kernel_sock_shutdown(tcp_socket, how);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.22.0

