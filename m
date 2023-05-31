Return-Path: <netdev+bounces-6913-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B51718A51
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41F1E1C20F7B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4769C3C0B2;
	Wed, 31 May 2023 19:37:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAFB24EAB;
	Wed, 31 May 2023 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D761C433A0;
	Wed, 31 May 2023 19:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685561838;
	bh=iceGuZ6feTsVTw2tdu2sArnr6g+xi9crr8yJSJGCfJs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ag93+kB4q2m9Z1r7ay861w439xgR2KTUUToA+qhghMfokAEkmXg+BukGjBll66mVb
	 QphOohNdQ04MMgM+1Uoy7UCVY2O4JEtYQe+qt+0C7t+9OCYOMVc2exPhZHc3L/Hsjp
	 8ySUDJt7PUx/3+KJHIO7NNzk+oTKB+latzuLT7kf40LOk6FT1VVni05QNCbcy9gipU
	 IwOEj2Zk6Xey+b/s35msDs62jyRroB6mwGRQBeh55fMGIHZZ0b18t2ugcp0uq/WTvB
	 5EpA4sOlwUjNcfWd54Zc+lP4pRCZZysKsN8C+663KVv+LUvX2mZjmWv5K4TUe4ZEHO
	 AiEJYD0oCTprg==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 31 May 2023 12:37:07 -0700
Subject: [PATCH net 5/6] mptcp: add annotations around sk->sk_shutdown
 accesses
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-send-net-20230531-v1-5-47750c420571@kernel.org>
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

Christoph reported the mptcp variant of a recently addressed plain
TCP issue. Similar to commit e14cadfd80d7 ("tcp: add annotations around
sk->sk_shutdown accesses") add READ/WRITE ONCE annotations to silence
KCSAN reports around lockless sk_shutdown access.

Fixes: 71ba088ce0aa ("mptcp: cleanup accept and poll")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/401
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a7dd7d8c9af2..af54a878ac27 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -603,7 +603,7 @@ static bool mptcp_check_data_fin(struct sock *sk)
 		WRITE_ONCE(msk->ack_seq, msk->ack_seq + 1);
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
-		sk->sk_shutdown |= RCV_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 
 		switch (sk->sk_state) {
@@ -910,7 +910,7 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		/* hopefully temporary hack: propagate shutdown status
 		 * to msk, when all subflows agree on it
 		 */
-		sk->sk_shutdown |= RCV_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 
 		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 		sk->sk_data_ready(sk);
@@ -2526,7 +2526,7 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	}
 
 	inet_sk_state_store(sk, TCP_CLOSE);
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
 
@@ -2958,7 +2958,7 @@ bool __mptcp_close(struct sock *sk, long timeout)
 	bool do_cancel_work = false;
 	int subflows_alive = 0;
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE)) {
 		mptcp_listen_inuse_dec(sk);
@@ -3101,7 +3101,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	mptcp_pm_data_reset(msk);
 	mptcp_ca_reset(sk);
 
-	sk->sk_shutdown = 0;
+	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);
 	return 0;
 }
@@ -3806,9 +3806,6 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 
-	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
-		return EPOLLOUT | EPOLLWRNORM;
-
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
@@ -3826,6 +3823,7 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct mptcp_sock *msk;
 	__poll_t mask = 0;
+	u8 shutdown;
 	int state;
 
 	msk = mptcp_sk(sk);
@@ -3842,17 +3840,22 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 		return inet_csk_listen_poll(ssock->sk);
 	}
 
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+		mask |= EPOLLHUP;
+	if (shutdown & RCV_SHUTDOWN)
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
-		mask |= mptcp_check_writeable(msk);
+		if (shutdown & SEND_SHUTDOWN)
+			mask |= EPOLLOUT | EPOLLWRNORM;
+		else
+			mask |= mptcp_check_writeable(msk);
 	} else if (state == TCP_SYN_SENT && inet_sk(sk)->defer_connect) {
 		/* cf tcp_poll() note about TFO */
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	}
-	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
-		mask |= EPOLLHUP;
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
-		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
 	/* This barrier is coupled with smp_wmb() in __mptcp_error_report() */
 	smp_rmb();

-- 
2.40.1


