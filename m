Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7182FCEFF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbhATLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387731AbhATKmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/PDwD1GtNCXXaDUTqen/gOJl4kreWkuuY9/KI+K0o4=;
        b=ecoQOROkdjjEw8EtgccWHJRpCCEemicyPJECn/HgLa+gnFIDu4D8+CNjze84Mh8saxFm44
        mzJ/FhTc7IdjCaPN5b8ISRz7PvNX+nqlmRxLDLYuWMqb6n+rkqdCtrqJxjDj6uNBtd86yb
        2OP1BDCUJMWrhzWKxiPiUUMj98+Qu6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Z7AO4wjPNJyJpKMcXx-4Qw-1; Wed, 20 Jan 2021 05:41:15 -0500
X-MC-Unique: Z7AO4wjPNJyJpKMcXx-4Qw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB9E88066E7;
        Wed, 20 Jan 2021 10:41:13 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B49E460C6A;
        Wed, 20 Jan 2021 10:41:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 1/5] mptcp: always graft subflow socket to parent
Date:   Wed, 20 Jan 2021 11:40:36 +0100
Message-Id: <780e7379d283ede184814cf75c4a6ac889a4728d.1610991949.git.pabeni@redhat.com>
In-Reply-To: <cover.1610991949.git.pabeni@redhat.com>
References: <cover.1610991949.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, incoming subflows link to the parent socket,
while outgoing ones link to a per subflow socket. The latter
is not really needed, except at the initial connect() time and
for the first subflow.

Always graft the outgoing subflow to the parent socket and
free the unneeded ones early.

This allows some code cleanup, reduces the amount of memory
used and will simplify the next patch

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 36 ++++++++++--------------------------
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  3 +++
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f998a077c7dd0..c5c80f9253832 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -114,11 +114,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	list_add(&subflow->node, &msk->conn_list);
 	sock_hold(ssock->sk);
 	subflow->request_mptcp = 1;
-
-	/* accept() will wait on first subflow sk_wq, and we always wakes up
-	 * via msk->sk_socket
-	 */
-	RCU_INIT_POINTER(msk->first->sk_wq, &sk->sk_socket->wq);
+	mptcp_sock_graft(msk->first, sk->sk_socket);
 
 	return 0;
 }
@@ -2116,9 +2112,6 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow)
 {
-	bool dispose_socket = false;
-	struct socket *sock;
-
 	list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
@@ -2126,11 +2119,8 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	/* if we are invoked by the msk cleanup code, the subflow is
 	 * already orphaned
 	 */
-	sock = ssk->sk_socket;
-	if (sock) {
-		dispose_socket = sock != sk->sk_socket;
+	if (ssk->sk_socket)
 		sock_orphan(ssk);
-	}
 
 	subflow->disposable = 1;
 
@@ -2148,8 +2138,6 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		__sock_put(ssk);
 	}
 	release_sock(ssk);
-	if (dispose_socket)
-		iput(SOCK_INODE(sock));
 
 	sock_put(ssk);
 }
@@ -2536,6 +2524,12 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
+	/* dispose the ancillatory tcp socket, if any */
+	if (msk->subflow) {
+		iput(SOCK_INODE(msk->subflow));
+		msk->subflow = NULL;
+	}
+
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -2586,20 +2580,10 @@ static void mptcp_close(struct sock *sk, long timeout)
 	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
 	list_for_each_entry(subflow, &mptcp_sk(sk)->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow, dispose_socket;
-		struct socket *sock;
+		bool slow = lock_sock_fast(ssk);
 
-		slow = lock_sock_fast(ssk);
-		sock = ssk->sk_socket;
-		dispose_socket = sock && sock != sk->sk_socket;
 		sock_orphan(ssk);
 		unlock_sock_fast(ssk, slow);
-
-		/* for the outgoing subflows we additionally need to free
-		 * the associated socket
-		 */
-		if (dispose_socket)
-			iput(SOCK_INODE(sock));
 	}
 	sock_orphan(sk);
 
@@ -3041,7 +3025,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	mptcp_rcv_space_init(msk, ssk);
 }
 
-static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
+void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 {
 	write_lock_bh(&sk->sk_callback_lock);
 	rcu_assign_pointer(sk->sk_wq, &parent->wq);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d6400ad2d6156..65d200a1072bf 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -473,6 +473,7 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		       struct mptcp_subflow_context *subflow);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 278cbe3e539ea..22313710d7696 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1159,6 +1159,9 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (err && err != -EINPROGRESS)
 		goto failed_unlink;
 
+	/* discard the subflow socket */
+	mptcp_sock_graft(ssk, sk->sk_socket);
+	iput(SOCK_INODE(sf));
 	return err;
 
 failed_unlink:
-- 
2.26.2

