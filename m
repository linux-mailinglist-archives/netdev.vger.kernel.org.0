Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6841A1B0E47
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgDTO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:26:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgDTO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587392763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlNxOrS0FW1oa1+/Zmxtegc0iVIoOwb3wKK5iHwv0jA=;
        b=U4yI9VZ+ybY/1xLsTgzvEpg2e5B6JCPlGyLRqBKDYreMhpC6aO9zrHydB8xn/Fzr3LoYnD
        WHT2eS3qWHDakQmmXNZGY1sfckg+7gvWBuVuGPXu/pklsnrF02AAVf4lsn8JzM0NvTPitj
        5H1JMEbePwKNB+XQqvR40bC5yBy0y0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-7Ybxu2eFMd6vVD6iX4QXOg-1; Mon, 20 Apr 2020 10:26:01 -0400
X-MC-Unique: 7Ybxu2eFMd6vVD6iX4QXOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F50BA3486D;
        Mon, 20 Apr 2020 14:25:39 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-142.ams2.redhat.com [10.36.114.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9306227BDA;
        Mon, 20 Apr 2020 14:25:37 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/3] mptcp: avoid flipping mp_capable field in syn_recv_sock()
Date:   Mon, 20 Apr 2020 16:25:05 +0200
Message-Id: <beeba536c07241eb6a7aeb4e844d1888363c34fa.1587389294.git.pabeni@redhat.com>
In-Reply-To: <cover.1587389294.git.pabeni@redhat.com>
References: <cover.1587389294.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If multiple CPUs races on the same req_sock in syn_recv_sock(),
flipping such field can cause inconsistent child socket status.

When racing, the CPU losing the req ownership may still change
the mptcp request socket mp_capable flag while the CPU owning
the request is cloning the socket, leaving the child socket with
'is_mptcp' set but no 'mp_capable' flag.

Such socket will stay with 'conn' field cleared, heading to oops
in later mptcp callback.

Address the issue tracking the fallback status in a local variable.

Fixes: 58b09919626b ("mptcp: create msk early")
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 46 +++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3a94f859347a..10090ca3d3e0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -376,6 +376,17 @@ static void mptcp_force_close(struct sock *sk)
 	sk_common_release(sk);
 }
=20
+static void subflow_ulp_fallback(struct sock *sk,
+				 struct mptcp_subflow_context *old_ctx)
+{
+	struct inet_connection_sock *icsk =3D inet_csk(sk);
+
+	mptcp_subflow_tcp_fallback(sk, old_ctx);
+	icsk->icsk_ulp_ops =3D NULL;
+	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
+	tcp_sk(sk)->is_mptcp =3D 0;
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -388,6 +399,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 	struct tcp_options_received opt_rx;
 	bool fallback_is_fatal =3D false;
 	struct sock *new_msk =3D NULL;
+	bool fallback =3D false;
 	struct sock *child;
=20
 	pr_debug("listener=3D%p, req=3D%p, conn=3D%p", listener, req, listener-=
>conn);
@@ -412,14 +424,14 @@ static struct sock *subflow_syn_recv_sock(const str=
uct sock *sk,
 			subflow_req->remote_key =3D opt_rx.mptcp.sndr_key;
 			subflow_req->remote_key_valid =3D 1;
 		} else {
-			subflow_req->mp_capable =3D 0;
+			fallback =3D true;
 			goto create_child;
 		}
=20
 create_msk:
 		new_msk =3D mptcp_sk_clone(listener->conn, req);
 		if (!new_msk)
-			subflow_req->mp_capable =3D 0;
+			fallback =3D true;
 	} else if (subflow_req->mp_join) {
 		fallback_is_fatal =3D true;
 		opt_rx.mptcp.mp_join =3D 0;
@@ -438,12 +450,18 @@ static struct sock *subflow_syn_recv_sock(const str=
uct sock *sk,
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx =3D mptcp_subflow_ctx(child);
=20
-		/* we have null ctx on TCP fallback, which is fatal on
-		 * MPJ handshake
+		/* we need to fallback on ctx allocation failure and on pre-reqs
+		 * checking above. In the latter scenario we additionally need
+		 * to reset the context to non MPTCP status.
 		 */
-		if (!ctx) {
+		if (!ctx || fallback) {
 			if (fallback_is_fatal)
 				goto close_child;
+
+			if (ctx) {
+				subflow_ulp_fallback(child, ctx);
+				kfree_rcu(ctx, rcu);
+			}
 			goto out;
 		}
=20
@@ -474,6 +492,13 @@ static struct sock *subflow_syn_recv_sock(const stru=
ct sock *sk,
 	/* dispose of the left over mptcp master, if any */
 	if (unlikely(new_msk))
 		mptcp_force_close(new_msk);
+
+	/* check for expected invariant - should never trigger, just help
+	 * catching eariler subtle bugs
+	 */
+	WARN_ON_ONCE(*own_req && child && tcp_sk(child)->is_mptcp &&
+		     (!mptcp_subflow_ctx(child) ||
+		      !mptcp_subflow_ctx(child)->conn));
 	return child;
=20
 close_child:
@@ -1094,17 +1119,6 @@ static void subflow_ulp_release(struct sock *sk)
 	kfree_rcu(ctx, rcu);
 }
=20
-static void subflow_ulp_fallback(struct sock *sk,
-				 struct mptcp_subflow_context *old_ctx)
-{
-	struct inet_connection_sock *icsk =3D inet_csk(sk);
-
-	mptcp_subflow_tcp_fallback(sk, old_ctx);
-	icsk->icsk_ulp_ops =3D NULL;
-	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
-	tcp_sk(sk)->is_mptcp =3D 0;
-}
-
 static void subflow_ulp_clone(const struct request_sock *req,
 			      struct sock *newsk,
 			      const gfp_t priority)
--=20
2.21.1

