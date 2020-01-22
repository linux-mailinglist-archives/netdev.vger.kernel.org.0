Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4077E144A04
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAVCrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:47:08 -0500
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:34982 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgAVCrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:47:08 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0uwKL005654;
        Tue, 21 Jan 2020 16:57:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=FMHlFwyZHC+VJQsNTHiaDaN8n18YpYs+rMlbRatO2t0=;
 b=uWnsbkQJfSKHz/6obIOMOPrl7cDI7D+GqOf0fCOMshcpMe0Yz/fshvUkUZj1yWe2r3/w
 EPsIb+1mCkMA02ggRMWBLLiAbw37nNB9R9WJVy8DVjrNE8zO/vlf3PqrIuaRhiagn1UM
 aw87EDvv1Zxs16urp+FArAMBmkj8JYnzBmlGJmPavY5P8DKHesWtnu9LuKEHFMLoEK8J
 D5AoCN9CgdZyCenbDtt8jOH1OcMI0EbPAAx+cnwFDhLRqQvr9wasgGeKM75xYcFPU5jG
 ny/izamc8wFGJbTB2vHaDmoj8+evsQlcxOIDQ9yE5oNbSMI73lo3cnnTlAWCCqlGsRbi Xw== 
Received: from ma1-mtap-s02.corp.apple.com (ma1-mtap-s02.corp.apple.com [17.40.76.6])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 2xm1w0q03h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:09 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s02.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H0018HHB4F030@ma1-mtap-s02.corp.apple.com>; Tue,
 21 Jan 2020 16:57:05 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00500GU2WL00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:04 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: ebbfb81d12456f1536843673fe0e0127
X-Va-R-CD: 7d07059f566fcad1b63a8abe07cb6839
X-Va-CD: 0
X-Va-ID: 010af09e-cebe-4ee7-87fd-1aa9a976d568
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: ebbfb81d12456f1536843673fe0e0127
X-V-R-CD: 7d07059f566fcad1b63a8abe07cb6839
X-V-CD: 0
X-V-ID: 252a0f71-884d-4ef7-8c1b-f205c79bca70
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0012MHB14Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:01 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 19/19] mptcp: cope with later TCP fallback
Date:   Tue, 21 Jan 2020 16:56:33 -0800
Message-id: <20200122005633.21229-20-cpaasch@apple.com>
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

From: Paolo Abeni <pabeni@redhat.com>

With MPTCP v1, passive connections can fallback to TCP after the
subflow becomes established:

syn + MP_CAPABLE ->
               <- syn, ack + MP_CAPABLE

ack, seq = 3    ->
        // OoO packet is accepted because in-sequence
        // passive socket is created, is in ESTABLISHED
	// status and tentatively as MP_CAPABLE

ack, seq = 2     ->
        // no MP_CAPABLE opt, subflow should fallback to TCP

We can't use the 'subflow' socket fallback, as we don't have
it available for passive connection.

Instead, when the fallback is detected, replace the mptcp
socket with the underlying TCP subflow. Beyond covering
the above scenario, it makes a TCP fallback socket as efficient
as plain TCP ones.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/protocol.c | 119 ++++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h |   1 +
 2 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1b64dfaa5f63..ee916b3686fe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,6 +24,58 @@
 
 #define MPTCP_SAME_STATE TCP_MAX_STATES
 
+static void __mptcp_close(struct sock *sk, long timeout);
+
+static const struct proto_ops * tcp_proto_ops(struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		return &inet6_stream_ops;
+#endif
+	return &inet_stream_ops;
+}
+
+/* MP_CAPABLE handshake failed, convert msk to plain tcp, replacing
+ * socket->sk and stream ops and destroying msk
+ * return the msk socket, as we can't access msk anymore after this function
+ * completes
+ * Called with msk lock held, releases such lock before returning
+ */
+static struct socket *__mptcp_fallback_to_tcp(struct mptcp_sock *msk,
+					      struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct socket *sock;
+	struct sock *sk;
+
+	sk = (struct sock *)msk;
+	sock = sk->sk_socket;
+	subflow = mptcp_subflow_ctx(ssk);
+
+	/* detach the msk socket */
+	list_del_init(&subflow->node);
+	sock_orphan(sk);
+	sock->sk = NULL;
+
+	/* socket is now TCP */
+	lock_sock(ssk);
+	sock_graft(ssk, sock);
+	if (subflow->conn) {
+		/* We can't release the ULP data on a live socket,
+		 * restore the tcp callback
+		 */
+		mptcp_subflow_tcp_fallback(ssk, subflow);
+		sock_put(subflow->conn);
+		subflow->conn = NULL;
+	}
+	release_sock(ssk);
+	sock->ops = tcp_proto_ops(ssk);
+
+	/* destroy the left-over msk sock */
+	__mptcp_close(sk, 0);
+	return sock;
+}
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -36,25 +88,37 @@ static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
-/* if msk has a single subflow, and the mp_capable handshake is failed,
- * return it.
+static bool __mptcp_needs_tcp_fallback(const struct mptcp_sock *msk)
+{
+	return msk->first && !sk_is_mptcp(msk->first);
+}
+
+/* if the mp_capable handshake has failed, it fallbacks msk to plain TCP,
+ * releases the socket lock and returns a reference to the now TCP socket.
  * Otherwise returns NULL
  */
-static struct socket *__mptcp_tcp_fallback(const struct mptcp_sock *msk)
+static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
-	struct socket *ssock = __mptcp_nmpc_socket(msk);
-
 	sock_owned_by_me((const struct sock *)msk);
 
-	if (!ssock || sk_is_mptcp(ssock->sk))
+	if (likely(!__mptcp_needs_tcp_fallback(msk)))
 		return NULL;
 
-	return ssock;
+	if (msk->subflow) {
+		/* the first subflow is an active connection, discart the
+		 * paired socket
+		 */
+		msk->subflow->sk = NULL;
+		sock_release(msk->subflow);
+		msk->subflow = NULL;
+	}
+
+	return __mptcp_fallback_to_tcp(msk, msk->first);
 }
 
 static bool __mptcp_can_create_subflow(const struct mptcp_sock *msk)
 {
-	return ((struct sock *)msk)->sk_state == TCP_CLOSE;
+	return !msk->first;
 }
 
 static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
@@ -75,6 +139,7 @@ static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
 	if (err)
 		return ERR_PTR(err);
 
+	msk->first = ssock->sk;
 	msk->subflow = ssock;
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
@@ -154,6 +219,8 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		ret = sk_stream_wait_memory(ssk, timeo);
 		if (ret)
 			return ret;
+		if (unlikely(__mptcp_needs_tcp_fallback(msk)))
+			return 0;
 	}
 
 	/* compute copy limit */
@@ -265,11 +332,11 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 	ssock = __mptcp_tcp_fallback(msk);
-	if (ssock) {
+	if (unlikely(ssock)) {
+fallback:
 		pr_debug("fallback passthrough");
 		ret = sock_sendmsg(ssock, msg);
-		release_sock(sk);
-		return ret;
+		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
@@ -288,6 +355,11 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 					 &size_goal);
 		if (ret < 0)
 			break;
+		if (ret == 0 && unlikely(__mptcp_needs_tcp_fallback(msk))) {
+			release_sock(ssk);
+			ssock = __mptcp_tcp_fallback(msk);
+			goto fallback;
+		}
 
 		copied += ret;
 	}
@@ -368,11 +440,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	lock_sock(sk);
 	ssock = __mptcp_tcp_fallback(msk);
-	if (ssock) {
+	if (unlikely(ssock)) {
+fallback:
 		pr_debug("fallback-read subflow=%p",
 			 mptcp_subflow_ctx(ssock->sk));
 		copied = sock_recvmsg(ssock, msg, flags);
-		release_sock(sk);
 		return copied;
 	}
 
@@ -477,6 +549,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		pr_debug("block timeout %ld", timeo);
 		wait_data = true;
 		mptcp_wait_data(sk, &timeo);
+		if (unlikely(__mptcp_tcp_fallback(msk)))
+			goto fallback;
 	}
 
 	if (more_data_avail) {
@@ -529,6 +603,8 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->conn_list);
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 
+	msk->first = NULL;
+
 	return 0;
 }
 
@@ -563,7 +639,8 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 	release_sock(ssk);
 }
 
-static void mptcp_close(struct sock *sk, long timeout)
+/* Called with msk lock held, releases such lock before returning */
+static void __mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -571,8 +648,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	lock_sock(sk);
-
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -585,6 +660,12 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	lock_sock(sk);
+	__mptcp_close(sk, timeout);
+}
+
 static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -654,6 +735,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		msk->subflow = NULL;
+		msk->first = newsk;
 
 		mptcp_token_update_accept(newsk, new_mptcp_sock);
 
@@ -1007,8 +1089,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
-	const struct mptcp_sock *msk;
 	struct sock *sk = sock->sk;
+	struct mptcp_sock *msk;
 	struct socket *ssock;
 	__poll_t mask = 0;
 
@@ -1024,6 +1106,9 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	release_sock(sk);
 	sock_poll_wait(file, sock, wait);
 	lock_sock(sk);
+	ssock = __mptcp_tcp_fallback(msk);
+	if (unlikely(ssock))
+		return ssock->ops->poll(file, ssock, NULL);
 
 	if (test_bit(MPTCP_DATA_READY, &msk->flags))
 		mask = EPOLLIN | EPOLLRDNORM;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 10eaa7c7381b..8a99a2930284 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -73,6 +73,7 @@ struct mptcp_sock {
 	struct list_head conn_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
+	struct sock	*first;
 };
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
-- 
2.23.0

