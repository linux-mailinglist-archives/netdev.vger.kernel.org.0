Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E85144A09
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAVCtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:49:17 -0500
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:44090 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgAVCtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:49:17 -0500
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v2eF020009;
        Tue, 21 Jan 2020 16:57:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=TsTeoBmuWyStiALMY2D/lGyttqvbvt4CgCxbwE6mUg0=;
 b=mOoytJQhy0kaJubL1C6Iykb+iidDsrCLRFrd3HgbR2A+b0MR8BPNhmFzNcGoVEzfWD3Y
 +xRSSVkDNo7j+0eAZzBwarGLV9ejmN5/3nv5QPFBr51JK6WwbN9k4w6YVkqQh4a/arR8
 Maw69jh8jTpUqsT/QHIp0nIrEeoOVBcrlk9RdW4h5HOofb25Dn7ToSrQlNxMX4I1vUHr
 odpCnqWh3GPLjc2YahyDHPVnVGc1KvhGqLDq9rFoIJTWyE4fn+OfXubH+1xeL0jAxTgy
 A71mZTVbhR9Ogn6TxZOs/Qwmrxlm5Uwdd7YOliOawNM7c1PaSELyuQM9HQMwwuKDEDOu 1g== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2xkyfq8e4a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:03 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00064HAZD600@ma1-mtap-s03.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: c3a95c48df57998eb91288aafc2efb36
X-Va-R-CD: baea9a46c402a2695110c874d5435c96
X-Va-CD: 0
X-Va-ID: ee7c28f0-e8e4-458f-9b26-765dd371cbc6
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: c3a95c48df57998eb91288aafc2efb36
X-V-R-CD: baea9a46c402a2695110c874d5435c96
X-V-CD: 0
X-V-ID: 257ac40d-f07b-49cb-810e-5aa818a2b79c
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0011VHAZ4Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 05/19] mptcp: Create SUBFLOW socket for incoming
 connections
Date:   Tue, 21 Jan 2020 16:56:19 -0800
Message-id: <20200122005633.21229-6-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
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
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 236 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 231 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index bdd58da1e4f6..e08a25eabcd5 100644
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
 
@@ -212,6 +215,90 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
+static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
+{
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	const struct ipv6_pinfo *ssk6 = inet6_sk(ssk);
+	struct ipv6_pinfo *msk6 = inet6_sk(msk);
+
+	msk->sk_v6_daddr = ssk->sk_v6_daddr;
+	msk->sk_v6_rcv_saddr = ssk->sk_v6_rcv_saddr;
+
+	if (msk6 && ssk6) {
+		msk6->saddr = ssk6->saddr;
+		msk6->flow_label = ssk6->flow_label;
+	}
+#endif
+
+	inet_sk(msk)->inet_num = inet_sk(ssk)->inet_num;
+	inet_sk(msk)->inet_dport = inet_sk(ssk)->inet_dport;
+	inet_sk(msk)->inet_sport = inet_sk(ssk)->inet_sport;
+	inet_sk(msk)->inet_daddr = inet_sk(ssk)->inet_daddr;
+	inet_sk(msk)->inet_saddr = inet_sk(ssk)->inet_saddr;
+	inet_sk(msk)->inet_rcv_saddr = inet_sk(ssk)->inet_rcv_saddr;
+}
+
+static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
+				 bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
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
+	pr_debug("msk=%p, subflow is mptcp=%d", msk, sk_is_mptcp(newsk));
+
+	if (sk_is_mptcp(newsk)) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *new_mptcp_sock;
+		struct sock *ssk = newsk;
+
+		subflow = mptcp_subflow_ctx(newsk);
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
+	}
+
+	return newsk;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -246,12 +333,21 @@ void mptcp_finish_connect(struct sock *ssk)
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
@@ -266,10 +362,7 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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
@@ -279,6 +372,8 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	}
 
 	err = ssock->ops->bind(ssock, uaddr, addr_len);
+	if (!err)
+		mptcp_copy_inaddrs(sock->sk, ssock->sk);
 
 unlock:
 	release_sock(sock->sk);
@@ -299,14 +394,139 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
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
 
 unlock:
 	release_sock(sock->sk);
 	return err;
 }
 
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
+
+unlock:
+	release_sock(sock->sk);
+	return err;
+}
+
+static bool is_tcp_proto(const struct proto *p)
+{
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
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
@@ -332,6 +552,9 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
 	mptcp_stream_ops.poll = mptcp_poll;
+	mptcp_stream_ops.accept = mptcp_stream_accept;
+	mptcp_stream_ops.getname = mptcp_v4_getname;
+	mptcp_stream_ops.listen = mptcp_listen;
 
 	mptcp_subflow_init();
 
@@ -371,6 +594,9 @@ int mptcpv6_init(void)
 	mptcp_v6_stream_ops.bind = mptcp_bind;
 	mptcp_v6_stream_ops.connect = mptcp_stream_connect;
 	mptcp_v6_stream_ops.poll = mptcp_poll;
+	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
+	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
+	mptcp_v6_stream_ops.listen = mptcp_listen;
 
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
-- 
2.23.0

