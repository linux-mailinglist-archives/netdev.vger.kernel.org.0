Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA27A1B0E46
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgDTO0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:26:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725784AbgDTO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587392768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2fbC7D3tJPvs2sbV48a+cFCka5Kcx6J6vdZbd4PhiA=;
        b=RCRoKbuiHA0QYWJMTnTrWOZekQ1gu3OzTjfwLHeGcUEiqMl+gax0Rluv+UmvH/rHgL0BAk
        rWws3/EkHArs9DnpUbIkvi9oK2U0P8Itd3TAiSynoS0vBB5QX3EVzTAloZPyOLpMda3oc7
        zcx4FBcuN5rVsElLdJKvaBoOnJRi4BE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-tfsq7WMEPm2KcpGiWDu7fg-1; Mon, 20 Apr 2020 10:26:02 -0400
X-MC-Unique: tfsq7WMEPm2KcpGiWDu7fg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C81A210102C6;
        Mon, 20 Apr 2020 14:25:41 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-142.ams2.redhat.com [10.36.114.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5E4327BD9;
        Mon, 20 Apr 2020 14:25:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 3/3] mptcp: drop req socket remote_key* fields
Date:   Mon, 20 Apr 2020 16:25:06 +0200
Message-Id: <0fc5ffc1b598e18e6c488331b0a756e45205f64b.1587389294.git.pabeni@redhat.com>
In-Reply-To: <cover.1587389294.git.pabeni@redhat.com>
References: <cover.1587389294.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need them, as we can use the current ingress opt
data instead. Setting them in syn_recv_sock() may causes
inconsistent mptcp socket status, as per previous commit.

Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according t=
o v1 spec")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c |  8 +++++---
 net/mptcp/protocol.h |  8 ++++----
 net/mptcp/subflow.c  | 20 ++++++++++----------
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index d275c1e827fe..58ad03fc1bbc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1345,7 +1345,9 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const stru=
ct sock *sk)
 }
 #endif
=20
-struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *=
req)
+struct sock *mptcp_sk_clone(const struct sock *sk,
+			    const struct tcp_options_received *opt_rx,
+			    struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req =3D mptcp_subflow_rsk(re=
q);
 	struct sock *nsk =3D sk_clone_lock(sk, GFP_ATOMIC);
@@ -1383,9 +1385,9 @@ struct sock *mptcp_sk_clone(const struct sock *sk, =
struct request_sock *req)
=20
 	msk->write_seq =3D subflow_req->idsn + 1;
 	atomic64_set(&msk->snd_una, msk->write_seq);
-	if (subflow_req->remote_key_valid) {
+	if (opt_rx->mptcp.mp_capable) {
 		msk->can_ack =3D true;
-		msk->remote_key =3D subflow_req->remote_key;
+		msk->remote_key =3D opt_rx->mptcp.sndr_key;
 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
 		ack_seq++;
 		msk->ack_seq =3D ack_seq;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67448002a2d7..a2b3048037d0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -206,12 +206,10 @@ struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u16	mp_capable : 1,
 		mp_join : 1,
-		backup : 1,
-		remote_key_valid : 1;
+		backup : 1;
 	u8	local_id;
 	u8	remote_id;
 	u64	local_key;
-	u64	remote_key;
 	u64	idsn;
 	u32	token;
 	u32	ssn_offset;
@@ -332,7 +330,9 @@ void mptcp_proto_init(void);
 int mptcp_proto_v6_init(void);
 #endif
=20
-struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *=
req);
+struct sock *mptcp_sk_clone(const struct sock *sk,
+			    const struct tcp_options_received *opt_rx,
+			    struct request_sock *req);
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
=20
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 10090ca3d3e0..87c094702d63 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -133,7 +133,6 @@ static void subflow_init_req(struct request_sock *req=
,
=20
 	subflow_req->mp_capable =3D 0;
 	subflow_req->mp_join =3D 0;
-	subflow_req->remote_key_valid =3D 0;
=20
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -404,6 +403,7 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
=20
 	pr_debug("listener=3D%p, req=3D%p, conn=3D%p", listener, req, listener-=
>conn);
=20
+	opt_rx.mptcp.mp_capable =3D 0;
 	if (tcp_rsk(req)->is_mptcp =3D=3D 0)
 		goto create_child;
=20
@@ -418,18 +418,14 @@ static struct sock *subflow_syn_recv_sock(const str=
uct sock *sk,
 			goto create_msk;
 		}
=20
-		opt_rx.mptcp.mp_capable =3D 0;
 		mptcp_get_options(skb, &opt_rx);
-		if (opt_rx.mptcp.mp_capable) {
-			subflow_req->remote_key =3D opt_rx.mptcp.sndr_key;
-			subflow_req->remote_key_valid =3D 1;
-		} else {
+		if (!opt_rx.mptcp.mp_capable) {
 			fallback =3D true;
 			goto create_child;
 		}
=20
 create_msk:
-		new_msk =3D mptcp_sk_clone(listener->conn, req);
+		new_msk =3D mptcp_sk_clone(listener->conn, &opt_rx, req);
 		if (!new_msk)
 			fallback =3D true;
 	} else if (subflow_req->mp_join) {
@@ -473,6 +469,13 @@ static struct sock *subflow_syn_recv_sock(const stru=
ct sock *sk,
 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
 			ctx->conn =3D new_msk;
 			new_msk =3D NULL;
+
+			/* with OoO packets we can reach here without ingress
+			 * mpc option
+			 */
+			ctx->remote_key =3D opt_rx.mptcp.sndr_key;
+			ctx->fully_established =3D opt_rx.mptcp.mp_capable;
+			ctx->can_ack =3D opt_rx.mptcp.mp_capable;
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
=20
@@ -1152,9 +1155,6 @@ static void subflow_ulp_clone(const struct request_=
sock *req,
 		 * is fully established only after we receive the remote key
 		 */
 		new_ctx->mp_capable =3D 1;
-		new_ctx->fully_established =3D subflow_req->remote_key_valid;
-		new_ctx->can_ack =3D subflow_req->remote_key_valid;
-		new_ctx->remote_key =3D subflow_req->remote_key;
 		new_ctx->local_key =3D subflow_req->local_key;
 		new_ctx->token =3D subflow_req->token;
 		new_ctx->ssn_offset =3D subflow_req->ssn_offset;
--=20
2.21.1

