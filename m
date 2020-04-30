Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595251BF8BA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgD3NCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726692AbgD3NCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTrMpurUCKBSs4W49z+s4LZutZ+7PnP4o51vC53MXPU=;
        b=MJyUf6Y98JmtW5TsAqHY8GXwOoaWkoHDQfD5w1e3rNhntA4dWLxdJEEhzEQZeCQVFlcBoO
        PCEd3PfNWKFfKxoQhvt82sy5ak3DaK9+ThZ5vTzdHahBe70Hlw88vIWpMuqpWViqK769gv
        yuSWsN+uWJ6N4jBTg2v6Lrmlm30b1Ag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-SA_wtbf3MXOLXtJnzEAbIw-1; Thu, 30 Apr 2020 09:02:14 -0400
X-MC-Unique: SA_wtbf3MXOLXtJnzEAbIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 634EF80B70C;
        Thu, 30 Apr 2020 13:02:12 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF56C6606F;
        Thu, 30 Apr 2020 13:02:09 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 1/5] mptcp: consolidate synack processing.
Date:   Thu, 30 Apr 2020 15:01:51 +0200
Message-Id: <06a22affdce8d1913122029aeba41f94ab24e4b5.1588243786.git.pabeni@redhat.com>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the MPTCP code uses 2 hooks to process syn-ack
packets, mptcp_rcv_synsent() and the sk_rx_dst_set()
callback.

We can drop the first, moving the relevant code into the
latter, reducing the hooking into the TCP code. This is
also needed by the next patch.

v1 -> v2:
 - use local tcp sock ptr instead of casting the sk variable
   several times - DaveM

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/mptcp.h  |  1 -
 net/ipv4/tcp_input.c |  3 ---
 net/mptcp/options.c  | 22 ----------------------
 net/mptcp/subflow.c  | 27 ++++++++++++++++++++++++---
 4 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0e7c5471010b..4ecfa7d5e0c7 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -72,7 +72,6 @@ void mptcp_parse_option(const struct sk_buff *skb, cons=
t unsigned char *ptr,
 			int opsize, struct tcp_options_received *opt_rx);
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 		       unsigned int *size, struct mptcp_out_options *opts);
-void mptcp_rcv_synsent(struct sock *sk);
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *=
size,
 			  struct mptcp_out_options *opts);
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bf4ced9273e8..81425542da44 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5990,9 +5990,6 @@ static int tcp_rcv_synsent_state_process(struct soc=
k *sk, struct sk_buff *skb,
 		tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		tcp_initialize_rcv_mss(sk);
=20
-		if (sk_is_mptcp(sk))
-			mptcp_rcv_synsent(sk);
-
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4a7c467b99db..8fea686a5562 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -344,28 +344,6 @@ bool mptcp_syn_options(struct sock *sk, const struct=
 sk_buff *skb,
 	return false;
 }
=20
-void mptcp_rcv_synsent(struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
-	struct tcp_sock *tp =3D tcp_sk(sk);
-
-	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
-		subflow->mp_capable =3D 1;
-		subflow->can_ack =3D 1;
-		subflow->remote_key =3D tp->rx_opt.mptcp.sndr_key;
-		pr_debug("subflow=3D%p, remote_key=3D%llu", subflow,
-			 subflow->remote_key);
-	} else if (subflow->request_join && tp->rx_opt.mptcp.mp_join) {
-		subflow->mp_join =3D 1;
-		subflow->thmac =3D tp->rx_opt.mptcp.thmac;
-		subflow->remote_nonce =3D tp->rx_opt.mptcp.nonce;
-		pr_debug("subflow=3D%p, thmac=3D%llu, remote_nonce=3D%u", subflow,
-			 subflow->thmac, subflow->remote_nonce);
-	} else if (subflow->request_mptcp) {
-		tcp_sk(sk)->is_mptcp =3D 0;
-	}
-}
-
 /* MP_JOIN client subflow must wait for 4th ack before sending any data:
  * TCP can't schedule delack timer before the subflow is fully establish=
ed.
  * MPTCP uses the delack timer to do 3rd ack retransmissions
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 71256f03707f..84f6408594c9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -222,6 +222,7 @@ static void subflow_finish_connect(struct sock *sk, c=
onst struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
 	struct sock *parent =3D subflow->conn;
+	struct tcp_sock *tp =3D tcp_sk(sk);
=20
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
=20
@@ -230,14 +231,35 @@ static void subflow_finish_connect(struct sock *sk,=
 const struct sk_buff *skb)
 		parent->sk_state_change(parent);
 	}
=20
-	if (subflow->conn_finished || !tcp_sk(sk)->is_mptcp)
+	/* be sure no special action on any packet other than syn-ack */
+	if (subflow->conn_finished)
+		return;
+
+	subflow->conn_finished =3D 1;
+
+	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
+		subflow->mp_capable =3D 1;
+		subflow->can_ack =3D 1;
+		subflow->remote_key =3D tp->rx_opt.mptcp.sndr_key;
+		pr_debug("subflow=3D%p, remote_key=3D%llu", subflow,
+			 subflow->remote_key);
+	} else if (subflow->request_join && tp->rx_opt.mptcp.mp_join) {
+		subflow->mp_join =3D 1;
+		subflow->thmac =3D tp->rx_opt.mptcp.thmac;
+		subflow->remote_nonce =3D tp->rx_opt.mptcp.nonce;
+		pr_debug("subflow=3D%p, thmac=3D%llu, remote_nonce=3D%u", subflow,
+			 subflow->thmac, subflow->remote_nonce);
+	} else if (subflow->request_mptcp) {
+		tp->is_mptcp =3D 0;
+	}
+
+	if (!tp->is_mptcp)
 		return;
=20
 	if (subflow->mp_capable) {
 		pr_debug("subflow=3D%p, remote_key=3D%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
 		mptcp_finish_connect(sk);
-		subflow->conn_finished =3D 1;
=20
 		if (skb) {
 			pr_debug("synack seq=3D%u", TCP_SKB_CB(skb)->seq);
@@ -264,7 +286,6 @@ static void subflow_finish_connect(struct sock *sk, c=
onst struct sk_buff *skb)
 		if (!mptcp_finish_join(sk))
 			goto do_reset;
=20
-		subflow->conn_finished =3D 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
 	} else {
 do_reset:
--=20
2.21.1

