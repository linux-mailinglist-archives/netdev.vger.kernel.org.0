Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500B02A1111
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgJ3WpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:45:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:45959 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgJ3WpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 18:45:14 -0400
IronPort-SDR: dbkSNhSiWfreoCaA98m8vtHNyu8Yph1NKCX7oq5vO6AeC8uR0PvixsyWVUHmb+SoDnHg0Usanc
 PYdF2VMMmaHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165177395"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165177395"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:14 -0700
IronPort-SDR: zyh2+/nDjWOvorFNOopKsYG8uNkMCuGemac7Oiqwbzs5BteZoI+2eiG9nmpbb7A37rEeoJFjWm
 /dyzXBhNUCeg==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="361983934"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.102.227])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 15:45:12 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/6] mptcp: adjust mptcp receive buffer limit if subflow has larger one
Date:   Fri, 30 Oct 2020 15:45:01 -0700
Message-Id: <20201030224506.108377-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
References: <20201030224506.108377-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In addition to tcp autotuning during read, it may also increase the
receive buffer in tcp_clamp_window().

In this case, mptcp should adjust its receive buffer size as well so
it can move all pending skbs from the subflow socket to the mptcp socket.

At this time, TCP can have more skbs ready for processing than what the
mptcp receive buffer size allows.

In the mptcp case, the receive window announced is based on the free
space of the mptcp parent socket instead of the individual subflows.

Following the subflow allows mptcp to grow its receive buffer.

This is especially noticeable for loopback traffic where two skbs are
enough to fill the initial receive window.

In mptcp_data_ready() we do not hold the mptcp socket lock, so modifying
mptcp_sk->sk_rcvbuf is racy.  Do it when moving skbs from subflow to
mptcp socket, both sockets are locked in this case.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e7419fd15d84..e010ef7585bf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -466,6 +466,18 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	struct tcp_sock *tp;
 	u32 old_copied_seq;
 	bool done = false;
+	int sk_rbuf;
+
+	sk_rbuf = READ_ONCE(sk->sk_rcvbuf);
+
+	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+		int ssk_rbuf = READ_ONCE(ssk->sk_rcvbuf);
+
+		if (unlikely(ssk_rbuf > sk_rbuf)) {
+			WRITE_ONCE(sk->sk_rcvbuf, ssk_rbuf);
+			sk_rbuf = ssk_rbuf;
+		}
+	}
 
 	pr_debug("msk=%p ssk=%p", msk, ssk);
 	tp = tcp_sk(ssk);
@@ -528,7 +540,7 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		WRITE_ONCE(tp->copied_seq, seq);
 		more_data_avail = mptcp_subflow_data_available(ssk);
 
-		if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf)) {
+		if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf) {
 			done = true;
 			break;
 		}
@@ -622,6 +634,7 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	int sk_rbuf, ssk_rbuf;
 	bool wake;
 
 	/* move_skbs_to_msk below can legitly clear the data_avail flag,
@@ -632,12 +645,16 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	if (wake)
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 
-	if (atomic_read(&sk->sk_rmem_alloc) < READ_ONCE(sk->sk_rcvbuf) &&
-	    move_skbs_to_msk(msk, ssk))
+	ssk_rbuf = READ_ONCE(ssk->sk_rcvbuf);
+	sk_rbuf = READ_ONCE(sk->sk_rcvbuf);
+	if (unlikely(ssk_rbuf > sk_rbuf))
+		sk_rbuf = ssk_rbuf;
+
+	/* over limit? can't append more skbs to msk */
+	if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf)
 		goto wake;
 
-	/* don't schedule if mptcp sk is (still) over limit */
-	if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf))
+	if (move_skbs_to_msk(msk, ssk))
 		goto wake;
 
 	/* mptcp socket is owned, release_cb should retry */
-- 
2.29.2

