Return-Path: <netdev+bounces-6911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2DC2718A4C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1282815A3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0A33C097;
	Wed, 31 May 2023 19:37:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE575200D6;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A964C433A1;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685561837;
	bh=RFv40zM9QJYJOLASIioGQHhhSNdv+fGArl5JAYjK2I0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Cv/MUpCEWmpI8YuBDior4T9GWiqMgMUeQasZLXhPt+Ei6NCzNGJNfxAeqXYvc/MS5
	 UhhVhVdIqHSduKzDPQIum5lUWjwP2+PD5LIlUnaMM880CWePi0oGuhj3fYeTJdjw66
	 1SH2XR8lHaAzkUve1XN+/X1QfwNCyMj2DN13sMaJgZGxQ706OyvtbT4R6PkuVqdQNh
	 RjXtzKL8UTbp/Iz6i8uF7Ni9n1OiVYucBmFywRh18W5BD5btFWI+a9D7yrXnoxMeh3
	 zP0v1NZ1NPs/QEtT1+8+uzqXzxfF3pkapy3OFKU9ZvyWTOfMSfMppO7qz6UvnRXiaa
	 QcnDzK2WHGC/w==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 31 May 2023 12:37:04 -0700
Subject: [PATCH net 2/6] mptcp: add annotations around msk->subflow
 accesses
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-send-net-20230531-v1-2-47750c420571@kernel.org>
References: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
In-Reply-To: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP can access the first subflow socket in a few spots
outside the socket lock scope. That is actually safe, as MPTCP
will delete the socket itself only after the msk sock close().

Still the such accesses causes a few KCSAN splats, as reported
by Christoph. Silence the harmless warning adding a few annotation
around the relevant accesses.

Fixes: 71ba088ce0aa ("mptcp: cleanup accept and poll")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/402
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 18 ++++++++++--------
 net/mptcp/protocol.h |  6 +++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9cafd3b89908..ce9de2c946b0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -91,7 +91,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 		return err;
 
 	msk->first = ssock->sk;
-	msk->subflow = ssock;
+	WRITE_ONCE(msk->subflow, ssock);
 	subflow = mptcp_subflow_ctx(ssock->sk);
 	list_add(&subflow->node, &msk->conn_list);
 	sock_hold(ssock->sk);
@@ -2282,7 +2282,7 @@ static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
 {
 	if (msk->subflow) {
 		iput(SOCK_INODE(msk->subflow));
-		msk->subflow = NULL;
+		WRITE_ONCE(msk->subflow, NULL);
 	}
 }
 
@@ -3136,7 +3136,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk = mptcp_sk(nsk);
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
-	msk->subflow = NULL;
+	WRITE_ONCE(msk->subflow, NULL);
 	msk->in_accept_queue = 1;
 	WRITE_ONCE(msk->fully_established, false);
 	if (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD)
@@ -3184,7 +3184,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	struct socket *listener;
 	struct sock *newsk;
 
-	listener = msk->subflow;
+	listener = READ_ONCE(msk->subflow);
 	if (WARN_ON_ONCE(!listener)) {
 		*err = -EINVAL;
 		return NULL;
@@ -3736,10 +3736,10 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 	pr_debug("msk=%p", msk);
 
-	/* buggy applications can call accept on socket states other then LISTEN
+	/* Buggy applications can call accept on socket states other then LISTEN
 	 * but no need to allocate the first subflow just to error out.
 	 */
-	ssock = msk->subflow;
+	ssock = READ_ONCE(msk->subflow);
 	if (!ssock)
 		return -EINVAL;
 
@@ -3813,10 +3813,12 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	state = inet_sk_state_load(sk);
 	pr_debug("msk=%p state=%d flags=%lx", msk, state, msk->flags);
 	if (state == TCP_LISTEN) {
-		if (WARN_ON_ONCE(!msk->subflow || !msk->subflow->sk))
+		struct socket *ssock = READ_ONCE(msk->subflow);
+
+		if (WARN_ON_ONCE(!ssock || !ssock->sk))
 			return 0;
 
-		return inet_csk_listen_poll(msk->subflow->sk);
+		return inet_csk_listen_poll(ssock->sk);
 	}
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index de4667dafe59..7a1a3c35470f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -305,7 +305,11 @@ struct mptcp_sock {
 	struct list_head rtx_queue;
 	struct mptcp_data_frag *first_pending;
 	struct list_head join_list;
-	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
+	struct socket	*subflow; /* outgoing connect/listener/!mp_capable
+				   * The mptcp ops can safely dereference, using suitable
+				   * ONCE annotation, the subflow outside the socket
+				   * lock as such sock is freed after close().
+				   */
 	struct sock	*first;
 	struct mptcp_pm_data	pm;
 	struct {

-- 
2.40.1


