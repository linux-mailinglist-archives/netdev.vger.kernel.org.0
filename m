Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4439183432
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 16:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgCLPNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 11:13:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58425 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727467AbgCLPNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 11:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584026028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NshfKRW36EWJ5m/5kzwrA7xkhxbHAT5OKWyiHQXsW8=;
        b=Kae0y96zVEHmGcuCaUKLWvw/OCSCxIsafycKeYrjtU78QbRXAAJaaSsUDe69NBNn2y8/D2
        aGhV9hnHIjT9prTygg1JLwj9n9aA8kJze4gGcwaP+cXYm5/CQb+St3OFp6gwqo/JtDMkI9
        7HOYyAzhWGwBEbBn0DRZqxRPKPasehk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-TdIiwVqjOAa34wZFc859Jw-1; Thu, 12 Mar 2020 11:13:45 -0400
X-MC-Unique: TdIiwVqjOAa34wZFc859Jw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF660108442E;
        Thu, 12 Mar 2020 15:13:43 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-153.ams2.redhat.com [10.36.117.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B786B19C6A;
        Thu, 12 Mar 2020 15:13:42 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/2] mptcp: create msk early
Date:   Thu, 12 Mar 2020 16:13:21 +0100
Message-Id: <127d7868d32f9db36a61f572d0160d73057149ac.1584006115.git.pabeni@redhat.com>
In-Reply-To: <cover.1584006115.git.pabeni@redhat.com>
References: <cover.1584006115.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change move the mptcp socket allocation from mptcp_accept() to
subflow_syn_recv_sock(), so that subflow->conn is now always set
for the non fallback scenario.

It allows cleaning up a bit mptcp_accept() reducing the additional
locking and will allow fourther cleanup in later patch

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 83 ++++++++++++++++++++++++--------------------
 net/mptcp/protocol.h |  4 +--
 net/mptcp/subflow.c  | 32 +++++++++++------
 net/mptcp/token.c    | 31 ++---------------
 4 files changed, 70 insertions(+), 80 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c0cef07f4382..04c3caed92df 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -820,9 +820,12 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const struc=
t sock *sk)
 }
 #endif
=20
-static struct sock *mptcp_sk_clone_lock(const struct sock *sk)
+struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *=
req)
 {
+	struct mptcp_subflow_request_sock *subflow_req =3D mptcp_subflow_rsk(re=
q);
 	struct sock *nsk =3D sk_clone_lock(sk, GFP_ATOMIC);
+	struct mptcp_sock *msk;
+	u64 ack_seq;
=20
 	if (!nsk)
 		return NULL;
@@ -832,6 +835,36 @@ static struct sock *mptcp_sk_clone_lock(const struct=
 sock *sk)
 		inet_sk(nsk)->pinet6 =3D mptcp_inet6_sk(nsk);
 #endif
=20
+	__mptcp_init_sock(nsk);
+
+	msk =3D mptcp_sk(nsk);
+	msk->local_key =3D subflow_req->local_key;
+	msk->token =3D subflow_req->token;
+	msk->subflow =3D NULL;
+
+	if (unlikely(mptcp_token_new_accept(subflow_req->token, nsk))) {
+		bh_unlock_sock(nsk);
+
+		/* we can't call into mptcp_close() here - possible BH context
+		 * free the sock directly
+		 */
+		nsk->sk_prot->destroy(nsk);
+		sk_free(nsk);
+		return NULL;
+	}
+
+	msk->write_seq =3D subflow_req->idsn + 1;
+	if (subflow_req->remote_key_valid) {
+		msk->can_ack =3D true;
+		msk->remote_key =3D subflow_req->remote_key;
+		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
+		ack_seq++;
+		msk->ack_seq =3D ack_seq;
+	}
+	bh_unlock_sock(nsk);
+
+	/* keep a single reference */
+	__sock_put(nsk);
 	return nsk;
 }
=20
@@ -859,40 +892,26 @@ static struct sock *mptcp_accept(struct sock *sk, i=
nt flags, int *err,
 		struct mptcp_subflow_context *subflow;
 		struct sock *new_mptcp_sock;
 		struct sock *ssk =3D newsk;
-		u64 ack_seq;
=20
 		subflow =3D mptcp_subflow_ctx(newsk);
-		lock_sock(sk);
+		new_mptcp_sock =3D subflow->conn;
=20
-		local_bh_disable();
-		new_mptcp_sock =3D mptcp_sk_clone_lock(sk);
-		if (!new_mptcp_sock) {
-			*err =3D -ENOBUFS;
-			local_bh_enable();
-			release_sock(sk);
-			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1, 0, 0);
-			tcp_close(newsk, 0);
-			return NULL;
+		/* is_mptcp should be false if subflow->conn is missing, see
+		 * subflow_syn_recv_sock()
+		 */
+		if (WARN_ON_ONCE(!new_mptcp_sock)) {
+			tcp_sk(newsk)->is_mptcp =3D 0;
+			return newsk;
 		}
=20
-		__mptcp_init_sock(new_mptcp_sock);
+		/* acquire the 2nd reference for the owning socket */
+		sock_hold(new_mptcp_sock);
=20
+		local_bh_disable();
+		bh_lock_sock(new_mptcp_sock);
 		msk =3D mptcp_sk(new_mptcp_sock);
-		msk->local_key =3D subflow->local_key;
-		msk->token =3D subflow->token;
-		msk->subflow =3D NULL;
 		msk->first =3D newsk;
=20
-		mptcp_token_update_accept(newsk, new_mptcp_sock);
-
-		msk->write_seq =3D subflow->idsn + 1;
-		if (subflow->can_ack) {
-			msk->can_ack =3D true;
-			msk->remote_key =3D subflow->remote_key;
-			mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
-			ack_seq++;
-			msk->ack_seq =3D ack_seq;
-		}
 		newsk =3D new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -903,18 +922,6 @@ static struct sock *mptcp_accept(struct sock *sk, in=
t flags, int *err,
 		inet_sk_state_store(new_mptcp_sock, TCP_SYN_RECV);
 		bh_unlock_sock(new_mptcp_sock);
 		local_bh_enable();
-		release_sock(sk);
-
-		/* the subflow can already receive packet, avoid racing with
-		 * the receive path and process the pending ones
-		 */
-		lock_sock(ssk);
-		subflow->rel_write_seq =3D 1;
-		subflow->tcp_sock =3D ssk;
-		subflow->conn =3D new_mptcp_sock;
-		if (unlikely(!skb_queue_empty(&ssk->sk_receive_queue)))
-			mptcp_subflow_data_available(ssk);
-		release_sock(ssk);
 	}
=20
 	return newsk;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 313558fa8185..9baf6fcba914 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -193,6 +193,7 @@ void mptcp_proto_init(void);
 int mptcp_proto_v6_init(void);
 #endif
=20
+struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *=
req);
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
=20
@@ -202,8 +203,7 @@ void mptcp_data_ready(struct sock *sk, struct sock *s=
sk);
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
 int mptcp_token_new_connect(struct sock *sk);
-int mptcp_token_new_accept(u32 token);
-void mptcp_token_update_accept(struct sock *sk, struct sock *conn);
+int mptcp_token_new_accept(u32 token, struct sock *conn);
 void mptcp_token_destroy(u32 token);
=20
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 0de2a44bdaa0..047b088e4617 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -182,6 +182,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 	struct mptcp_subflow_context *listener =3D mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
 	struct tcp_options_received opt_rx;
+	struct sock *new_msk =3D NULL;
 	struct sock *child;
=20
 	pr_debug("listener=3D%p, req=3D%p, conn=3D%p", listener, req, listener-=
>conn);
@@ -197,7 +198,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 			 * out-of-order pkt, which will not carry the MP_CAPABLE
 			 * opt even on mptcp enabled paths
 			 */
-			goto create_child;
+			goto create_msk;
 		}
=20
 		opt_rx.mptcp.mp_capable =3D 0;
@@ -207,7 +208,13 @@ static struct sock *subflow_syn_recv_sock(const stru=
ct sock *sk,
 			subflow_req->remote_key_valid =3D 1;
 		} else {
 			subflow_req->mp_capable =3D 0;
+			goto create_child;
 		}
+
+create_msk:
+		new_msk =3D mptcp_sk_clone(listener->conn, req);
+		if (!new_msk)
+			subflow_req->mp_capable =3D 0;
 	}
=20
 create_child:
@@ -221,22 +228,22 @@ static struct sock *subflow_syn_recv_sock(const str=
uct sock *sk,
 		 * handshake
 		 */
 		if (!ctx)
-			return child;
+			goto out;
=20
 		if (ctx->mp_capable) {
-			if (mptcp_token_new_accept(ctx->token))
-				goto close_child;
+			/* new mpc subflow takes ownership of the newly
+			 * created mptcp socket
+			 */
+			ctx->conn =3D new_msk;
+			new_msk =3D NULL;
 		}
 	}
=20
+out:
+	/* dispose of the left over mptcp master, if any */
+	if (unlikely(new_msk))
+		sock_put(new_msk);
 	return child;
-
-close_child:
-	pr_debug("closing child socket");
-	tcp_send_active_reset(child, GFP_ATOMIC);
-	inet_csk_prepare_forced_close(child);
-	tcp_done(child);
-	return NULL;
 }
=20
 static struct inet_connection_sock_af_ops subflow_specific;
@@ -793,6 +800,9 @@ static void subflow_ulp_clone(const struct request_so=
ck *req,
 	new_ctx->tcp_data_ready =3D old_ctx->tcp_data_ready;
 	new_ctx->tcp_state_change =3D old_ctx->tcp_state_change;
 	new_ctx->tcp_write_space =3D old_ctx->tcp_write_space;
+	new_ctx->rel_write_seq =3D 1;
+	new_ctx->tcp_sock =3D newsk;
+
 	new_ctx->mp_capable =3D 1;
 	new_ctx->fourth_ack =3D subflow_req->remote_key_valid;
 	new_ctx->can_ack =3D subflow_req->remote_key_valid;
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 84d887806090..b71b53c0ac8d 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -128,45 +128,18 @@ int mptcp_token_new_connect(struct sock *sk)
  *
  * Called when a SYN packet creates a new logical connection, i.e.
  * is not a join request.
- *
- * We don't have an mptcp socket yet at that point.
- * This is paired with mptcp_token_update_accept, called on accept().
  */
-int mptcp_token_new_accept(u32 token)
+int mptcp_token_new_accept(u32 token, struct sock *conn)
 {
 	int err;
=20
 	spin_lock_bh(&token_tree_lock);
-	err =3D radix_tree_insert(&token_tree, token, &token_used);
+	err =3D radix_tree_insert(&token_tree, token, conn);
 	spin_unlock_bh(&token_tree_lock);
=20
 	return err;
 }
=20
-/**
- * mptcp_token_update_accept - update token to map to mptcp socket
- * @conn: the new struct mptcp_sock
- * @sk: the initial subflow for this mptcp socket
- *
- * Called when the first mptcp socket is created on accept to
- * refresh the dummy mapping (done to reserve the token) with
- * the mptcp_socket structure that wasn't allocated before.
- */
-void mptcp_token_update_accept(struct sock *sk, struct sock *conn)
-{
-	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
-	void __rcu **slot;
-
-	spin_lock_bh(&token_tree_lock);
-	slot =3D radix_tree_lookup_slot(&token_tree, subflow->token);
-	WARN_ON_ONCE(!slot);
-	if (slot) {
-		WARN_ON_ONCE(rcu_access_pointer(*slot) !=3D &token_used);
-		radix_tree_replace_slot(&token_tree, slot, conn);
-	}
-	spin_unlock_bh(&token_tree_lock);
-}
-
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
  * @token - token of mptcp connection to remove
--=20
2.21.1

