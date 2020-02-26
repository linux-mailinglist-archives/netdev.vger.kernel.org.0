Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1219416FA67
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgBZJPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:20 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60770 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727744AbgBZJPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smj-0001Mw-V1; Wed, 26 Feb 2020 10:15:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/7] mptcp: add rmem queue accounting
Date:   Wed, 26 Feb 2020 10:14:49 +0100
Message-Id: <20200226091452.1116-5-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If userspace never drains the receive buffers we must stop draining
the subflow socket(s) at some point.

This adds the needed rmem accouting for this.
If the threshold is reached, we stop draining the subflows.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b4a8517d8eac..381d5647a95b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -124,7 +124,7 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	struct sock *sk = (struct sock *)msk;
 
 	__skb_unlink(skb, &ssk->sk_receive_queue);
-	skb_orphan(skb);
+	skb_set_owner_r(skb, sk);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 
 	msk->ack_seq += copy_len;
@@ -136,10 +136,16 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 					   unsigned int *bytes)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
 	bool more_data_avail;
 	struct tcp_sock *tp;
 	bool done = false;
+	int rcvbuf;
+
+	rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
+	if (rcvbuf > sk->sk_rcvbuf)
+		sk->sk_rcvbuf = rcvbuf;
 
 	tp = tcp_sk(ssk);
 	do {
@@ -183,6 +189,11 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 		WRITE_ONCE(tp->copied_seq, seq);
 		more_data_avail = mptcp_subflow_data_available(ssk);
+
+		if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf)) {
+			done = true;
+			break;
+		}
 	} while (more_data_avail);
 
 	*bytes = moved;
@@ -196,9 +207,14 @@ void mptcp_data_ready(struct sock *sk)
 
 	set_bit(MPTCP_DATA_READY, &msk->flags);
 
+	/* don't schedule if mptcp sk is (still) over limit */
+	if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf))
+		goto wake;
+
 	if (schedule_work(&msk->work))
 		sock_hold((struct sock *)msk);
 
+wake:
 	sk->sk_data_ready(sk);
 }
 
-- 
2.24.1

