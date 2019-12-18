Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC91125265
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfLRTze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:2229 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727533AbfLRTzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019944"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 05/15] mptcp: Create SUBFLOW socket for incoming connections
Date:   Wed, 18 Dec 2019 11:55:00 -0800
Message-Id: <20191218195510.7782-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add subflow_request_sock type that extends tcp_request_sock
and add an is_mptcp flag to tcp_request_sock distinguish them.

Override the listen() and accept() methods of the MPTCP
socket proto_ops so they may act on the subflow socket.

Override the conn_request() and syn_recv_sock() handlers
in the inet_connection_sock to handle incoming MPTCP
SYNs and the ACK to the response SYN.

Add handling in tcp_output.c to add MP_CAPABLE to an outgoing
SYN-ACK response for a subflow_request_sock.

Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 238 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 233 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8bb3ecf87ee5..70e28cc0dbe0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -14,6 +14,9 @@
 #include <net/inet_hashtables.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+#include <net/transp_v6.h>
+#endif
 #include <net/mptcp.h>
 #include "protocol.h"
 
@@ -213,6 +216,92 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
+static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
+{
+	const struct ipv6_pinfo *ssk6 = inet6_sk(ssk);
+	struct ipv6_pinfo *msk6 = inet6_sk(msk);
+
+	inet_sk(msk)->inet_num = inet_sk(ssk)->inet_num;
+	inet_sk(msk)->inet_dport = inet_sk(ssk)->inet_dport;
+	inet_sk(msk)->inet_sport = inet_sk(ssk)->inet_sport;
+	inet_sk(msk)->inet_daddr = inet_sk(ssk)->inet_daddr;
+	inet_sk(msk)->inet_saddr = inet_sk(ssk)->inet_saddr;
+	inet_sk(msk)->inet_rcv_saddr = inet_sk(ssk)->inet_rcv_saddr;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	msk->sk_v6_daddr = ssk->sk_v6_daddr;
+	msk->sk_v6_rcv_saddr = ssk->sk_v6_rcv_saddr;
+
+	if (msk6 && ssk6) {
+		msk6->saddr = ssk6->saddr;
+		msk6->flow_label = ssk6->flow_label;
+	}
+#endif
+}
+
+static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
+				 bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	struct socket *listener;
+	struct sock *newsk;
+
+	listener = __mptcp_nmpc_socket(msk);
+	if (WARN_ON_ONCE(!listener)) {
+		*err = -EINVAL;
+		return NULL;
+	}
+
+	pr_debug("msk=%p, listener=%p", msk, mptcp_subflow_ctx(listener->sk));
+	newsk = inet_csk_accept(listener->sk, flags, err, kern);
+	if (!newsk)
+		return NULL;
+
+	subflow = mptcp_subflow_ctx(newsk);
+	pr_debug("msk=%p, new subflow=%p, ", msk, subflow);
+
+	if (subflow->mp_capable) {
+		struct sock *new_mptcp_sock;
+		struct sock *ssk = newsk;
+
+		lock_sock(sk);
+
+		local_bh_disable();
+		new_mptcp_sock = sk_clone_lock(sk, GFP_ATOMIC);
+		if (!new_mptcp_sock) {
+			*err = -ENOBUFS;
+			local_bh_enable();
+			release_sock(sk);
+			tcp_close(newsk, 0);
+			return NULL;
+		}
+
+		mptcp_init_sock(new_mptcp_sock);
+
+		msk = mptcp_sk(new_mptcp_sock);
+		msk->remote_key = subflow->remote_key;
+		msk->local_key = subflow->local_key;
+		msk->subflow = NULL;
+
+		newsk = new_mptcp_sock;
+		mptcp_copy_inaddrs(newsk, ssk);
+		list_add(&subflow->node, &msk->conn_list);
+
+		/* will be fully established at mptcp_stream_accept()
+		 * completion.
+		 */
+		inet_sk_state_store(new_mptcp_sock, TCP_SYN_RECV);
+		bh_unlock_sock(new_mptcp_sock);
+		local_bh_enable();
+		release_sock(sk);
+	} else {
+		tcp_sk(newsk)->is_mptcp = 0;
+	}
+
+	return newsk;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -247,12 +336,21 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->local_key, subflow->local_key);
 }
 
+static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
+{
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(sk->sk_wq, &parent->wq);
+	sk_set_socket(sk, parent);
+	sk->sk_uid = SOCK_INODE(parent)->i_uid;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
-	.accept		= inet_csk_accept,
+	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
@@ -267,10 +365,7 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct socket *ssock;
-	int err = -ENOTSUPP;
-
-	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
-		return err;
+	int err;
 
 	lock_sock(sock->sk);
 	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
@@ -280,6 +375,8 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	}
 
 	err = ssock->ops->bind(ssock, uaddr, addr_len);
+	if (!err)
+		mptcp_copy_inaddrs(sock->sk, ssock->sk);
 
 unlock:
 	release_sock(sock->sk);
@@ -300,14 +397,139 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto unlock;
 	}
 
+#ifdef CONFIG_TCP_MD5SIG
+	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
+	 * TCP option space.
+	 */
+	if (rcu_access_pointer(tcp_sk(ssock->sk)->md5sig_info))
+		mptcp_subflow_ctx(ssock->sk)->request_mptcp = 0;
+#endif
+
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
 	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
+	mptcp_copy_inaddrs(sock->sk, ssock->sk);
+
+unlock:
+	release_sock(sock->sk);
+	return err;
+}
+
+static int mptcp_v4_getname(struct socket *sock, struct sockaddr *uaddr,
+			    int peer)
+{
+	if (sock->sk->sk_prot == &tcp_prot) {
+		/* we are being invoked from __sys_accept4, after
+		 * mptcp_accept() has just accepted a non-mp-capable
+		 * flow: sk is a tcp_sk, not an mptcp one.
+		 *
+		 * Hand the socket over to tcp so all further socket ops
+		 * bypass mptcp.
+		 */
+		sock->ops = &inet_stream_ops;
+	}
+
+	return inet_getname(sock, uaddr, peer);
+}
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static int mptcp_v6_getname(struct socket *sock, struct sockaddr *uaddr,
+			    int peer)
+{
+	if (sock->sk->sk_prot == &tcpv6_prot) {
+		/* we are being invoked from __sys_accept4 after
+		 * mptcp_accept() has accepted a non-mp-capable
+		 * subflow: sk is a tcp_sk, not mptcp.
+		 *
+		 * Hand the socket over to tcp so all further
+		 * socket ops bypass mptcp.
+		 */
+		sock->ops = &inet6_stream_ops;
+	}
+
+	return inet6_getname(sock, uaddr, peer);
+}
+#endif
+
+static int mptcp_listen(struct socket *sock, int backlog)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	int err;
+
+	pr_debug("msk=%p", msk);
+
+	lock_sock(sock->sk);
+	ssock = __mptcp_socket_create(msk, TCP_LISTEN);
+	if (IS_ERR(ssock)) {
+		err = PTR_ERR(ssock);
+		goto unlock;
+	}
+
+	err = ssock->ops->listen(ssock, backlog);
+	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
+	if (!err)
+		mptcp_copy_inaddrs(sock->sk, ssock->sk);
 
 unlock:
 	release_sock(sock->sk);
 	return err;
 }
 
+static bool is_tcp_proto(const struct proto *p)
+{
+#ifdef CONFIG_MPTCP_IPV6
+	return p == &tcp_prot || p == &tcpv6_prot;
+#else
+	return p == &tcp_prot;
+#endif
+}
+
+static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
+			       int flags, bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	int err;
+
+	pr_debug("msk=%p", msk);
+
+	lock_sock(sock->sk);
+	if (sock->sk->sk_state != TCP_LISTEN)
+		goto unlock_fail;
+
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock)
+		goto unlock_fail;
+
+	sock_hold(ssock->sk);
+	release_sock(sock->sk);
+
+	err = ssock->ops->accept(sock, newsock, flags, kern);
+	if (err == 0 && !is_tcp_proto(newsock->sk->sk_prot)) {
+		struct mptcp_sock *msk = mptcp_sk(newsock->sk);
+		struct mptcp_subflow_context *subflow;
+
+		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
+		 * This is needed so NOSPACE flag can be set from tcp stack.
+		 */
+		list_for_each_entry(subflow, &msk->conn_list, node) {
+			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+			if (!ssk->sk_socket)
+				mptcp_sock_graft(ssk, newsock);
+		}
+
+		inet_sk_state_store(newsock->sk, TCP_ESTABLISHED);
+	}
+
+	sock_put(ssock->sk);
+	return err;
+
+unlock_fail:
+	release_sock(sock->sk);
+	return -EINVAL;
+}
+
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
@@ -333,6 +555,9 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
 	mptcp_stream_ops.poll = mptcp_poll;
+	mptcp_stream_ops.accept = mptcp_stream_accept;
+	mptcp_stream_ops.getname = mptcp_v4_getname;
+	mptcp_stream_ops.listen = mptcp_listen;
 
 	mptcp_subflow_init();
 
@@ -372,6 +597,9 @@ int mptcpv6_init(void)
 	mptcp_v6_stream_ops.bind = mptcp_bind;
 	mptcp_v6_stream_ops.connect = mptcp_stream_connect;
 	mptcp_v6_stream_ops.poll = mptcp_poll;
+	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
+	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
+	mptcp_v6_stream_ops.listen = mptcp_listen;
 
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
-- 
2.24.1

