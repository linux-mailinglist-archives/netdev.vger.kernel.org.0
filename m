Return-Path: <netdev+bounces-6910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 429E3718A4B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECB422814FB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A9334CEF;
	Wed, 31 May 2023 19:37:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659AC21081;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77053C4339B;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685561837;
	bh=imyn8zDjERXaGf96kmA9Gc/k7y1YpLM9G8xtFvoKTUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tjfTPsYFfm5QRcQtJe0vXInklXz2FbXn0pxa9r7PyGs6t3J7WJZRBhShxUc9d8BL3
	 yOsDqZ2j7qzAX6O8EQKJkEZS3yD/CsSTDNga0Aykg08HsuSbV5z9uBcy3XOjhFAPP6
	 tgtUZVS7oGwIeEyKU1Tkfz9h/FurA5i8biw4mT1I7y9Vh7LKrFYFcJsW7R5jTGHQMP
	 9tNYvyzi88+Bc8a+vbCmwwOn2Tq7PFweJ25QIQaMoRsYyC5lf+QdpJynBFrwq4WQgS
	 E3sWbvIGCBmk9Jp9gWCWc/9jEUIbdNNfGQP7YcTgTB1Cf0QLre9AnkC3DytiXOzdQ2
	 edUFR4K4OrEIw==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 31 May 2023 12:37:05 -0700
Subject: [PATCH net 3/6] mptcp: consolidate passive msk socket
 initialization
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-send-net-20230531-v1-3-47750c420571@kernel.org>
References: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
In-Reply-To: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

When the msk socket is cloned at MPC handshake time, a few
fields are initialized in a racy way outside mptcp_sk_clone()
and the msk socket lock.

The above is due historical reasons: before commit a88d0092b24b
("mptcp: simplify subflow_syn_recv_sock()") as the first subflow socket
carrying all the needed date was not available yet at msk creation
time

We can now refactor the code moving the missing initialization bit
under the socket lock, removing the init race and avoiding some
code duplication.

This will also simplify the next patch, as all msk->first write
access are now under the msk socket lock.

Fixes: 0397c6d85f9c ("mptcp: keep unaccepted MPC subflow into join list")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 35 ++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h |  8 ++++----
 net/mptcp/subflow.c  | 28 +---------------------------
 3 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ce9de2c946b0..2ecd0117ab1b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3038,7 +3038,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sock_put(sk);
 }
 
-void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
+static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	const struct ipv6_pinfo *ssk6 = inet6_sk(ssk);
@@ -3115,9 +3115,10 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
 }
 #endif
 
-struct sock *mptcp_sk_clone(const struct sock *sk,
-			    const struct mptcp_options_received *mp_opt,
-			    struct request_sock *req)
+struct sock *mptcp_sk_clone_init(const struct sock *sk,
+				 const struct mptcp_options_received *mp_opt,
+				 struct sock *ssk,
+				 struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
@@ -3149,10 +3150,30 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 
 	sock_reset_flag(nsk, SOCK_RCU_FREE);
-	/* will be fully established after successful MPC subflow creation */
-	inet_sk_state_store(nsk, TCP_SYN_RECV);
-
 	security_inet_csk_clone(nsk, req);
+
+	/* this can't race with mptcp_close(), as the msk is
+	 * not yet exposted to user-space
+	 */
+	inet_sk_state_store(nsk, TCP_ESTABLISHED);
+
+	/* The msk maintain a ref to each subflow in the connections list */
+	WRITE_ONCE(msk->first, ssk);
+	list_add(&mptcp_subflow_ctx(ssk)->node, &msk->conn_list);
+	sock_hold(ssk);
+
+	/* new mpc subflow takes ownership of the newly
+	 * created mptcp socket
+	 */
+	mptcp_token_accept(subflow_req, msk);
+
+	/* set msk addresses early to ensure mptcp_pm_get_local_id()
+	 * uses the correct data
+	 */
+	mptcp_copy_inaddrs(nsk, ssk);
+	mptcp_propagate_sndbuf(nsk, ssk);
+
+	mptcp_rcv_space_init(msk, ssk);
 	bh_unlock_sock(nsk);
 
 	/* note: the newly allocated socket refcount is 2 now */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 7a1a3c35470f..c5255258bfb3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -616,7 +616,6 @@ int mptcp_is_checksum_enabled(const struct net *net);
 int mptcp_allow_join_id0(const struct net *net);
 unsigned int mptcp_stale_loss_cnt(const struct net *net);
 int mptcp_get_pm_type(const struct net *net);
-void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     const struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
@@ -686,9 +685,10 @@ void __init mptcp_proto_init(void);
 int __init mptcp_proto_v6_init(void);
 #endif
 
-struct sock *mptcp_sk_clone(const struct sock *sk,
-			    const struct mptcp_options_received *mp_opt,
-			    struct request_sock *req);
+struct sock *mptcp_sk_clone_init(const struct sock *sk,
+				 const struct mptcp_options_received *mp_opt,
+				 struct sock *ssk,
+				 struct request_sock *req);
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ba065b66551a..4688daa6b38b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -815,38 +815,12 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
-			ctx->conn = mptcp_sk_clone(listener->conn, &mp_opt, req);
+			ctx->conn = mptcp_sk_clone_init(listener->conn, &mp_opt, child, req);
 			if (!ctx->conn)
 				goto fallback;
 
 			owner = mptcp_sk(ctx->conn);
-
-			/* this can't race with mptcp_close(), as the msk is
-			 * not yet exposted to user-space
-			 */
-			inet_sk_state_store(ctx->conn, TCP_ESTABLISHED);
-
-			/* record the newly created socket as the first msk
-			 * subflow, but don't link it yet into conn_list
-			 */
-			WRITE_ONCE(owner->first, child);
-
-			/* new mpc subflow takes ownership of the newly
-			 * created mptcp socket
-			 */
-			owner->setsockopt_seq = ctx->setsockopt_seq;
 			mptcp_pm_new_connection(owner, child, 1);
-			mptcp_token_accept(subflow_req, owner);
-
-			/* set msk addresses early to ensure mptcp_pm_get_local_id()
-			 * uses the correct data
-			 */
-			mptcp_copy_inaddrs(ctx->conn, child);
-			mptcp_propagate_sndbuf(ctx->conn, child);
-
-			mptcp_rcv_space_init(owner, child);
-			list_add(&ctx->node, &owner->conn_list);
-			sock_hold(child);
 
 			/* with OoO packets we can reach here without ingress
 			 * mpc option

-- 
2.40.1


