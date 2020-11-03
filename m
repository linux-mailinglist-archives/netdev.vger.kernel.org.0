Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2E2A4FAB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgKCTF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:05:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:49621 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbgKCTFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:05:24 -0500
IronPort-SDR: saDp3cF9fsJe2S7edEN/Yf0E5XFFd7JP18/X6JfOpkor09W3b1fNuJq5C8s3mnZHrgoVA7YWYt
 oL6B+jIs/s6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="148386930"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="148386930"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
IronPort-SDR: Bgf/zByUg7q5fMIfeWLYSji5O1uv/Z0kJvIqnST5eecVr0EPmUp8vEhkE+mrC9tm68oeLubtiE
 XB1t3fOiX1+Q==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="352430146"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.18.188])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 11:05:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        kuba@kernel.org, davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 1/7] mptcp: adjust mptcp receive buffer limit if subflow has larger one
Date:   Tue,  3 Nov 2020 11:05:03 -0800
Message-Id: <20201103190509.27416-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
References: <20201103190509.27416-1-mathew.j.martineau@linux.intel.com>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
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

