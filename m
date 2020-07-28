Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E263F231567
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgG1WMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:2596 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbgG1WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:18 -0400
IronPort-SDR: ijKdXUamiY2MhNC481avl6k5LoPH/iZemYHTIkFg++0uR8ZUGEus68YEI6Hl8nh8no8I0gJQvU
 eYInG3bEFESQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342685"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342685"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:14 -0700
IronPort-SDR: BvNpT5eKdBjv7Rle4JusVrNndRyqBj6818MgyCYx2TbgG85pHryOqnzEXccE6yQoHDs+t6ttGj
 Qn6/Ge94FOaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468889"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 07/12] mptcp: Add helper to process acks of DATA_FIN
Date:   Tue, 28 Jul 2020 15:12:05 -0700
Message-Id: <20200728221210.92841-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After DATA_FIN has been sent, the peer will acknowledge it. An ack of
the relevant MPTCP-level sequence number will update the MPTCP
connection state appropriately.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 54 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 51370b69e30b..b3350830e14d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -143,6 +143,14 @@ static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	MPTCP_SKB_CB(skb)->offset = offset;
 }
 
+static void mptcp_stop_timer(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
+	mptcp_sk(sk)->timer_ival = 0;
+}
+
 /* both sockets must be locked */
 static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
 				    struct sock *ssk)
@@ -164,6 +172,42 @@ static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
 	return mptcp_subflow_data_available(ssk);
 }
 
+static void mptcp_check_data_fin_ack(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (__mptcp_check_fallback(msk))
+		return;
+
+	/* Look for an acknowledged DATA_FIN */
+	if (((1 << sk->sk_state) &
+	     (TCPF_FIN_WAIT1 | TCPF_CLOSING | TCPF_LAST_ACK)) &&
+	    msk->write_seq == atomic64_read(&msk->snd_una)) {
+		mptcp_stop_timer(sk);
+
+		WRITE_ONCE(msk->snd_data_fin_enable, 0);
+
+		switch (sk->sk_state) {
+		case TCP_FIN_WAIT1:
+			inet_sk_state_store(sk, TCP_FIN_WAIT2);
+			sk->sk_state_change(sk);
+			break;
+		case TCP_CLOSING:
+			fallthrough;
+		case TCP_LAST_ACK:
+			inet_sk_state_store(sk, TCP_CLOSE);
+			sk->sk_state_change(sk);
+			break;
+		}
+
+		if (sk->sk_shutdown == SHUTDOWN_MASK ||
+		    sk->sk_state == TCP_CLOSE)
+			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
+		else
+			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	}
+}
+
 static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -222,6 +266,8 @@ static void mptcp_check_data_fin(struct sock *sk)
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
 		sk->sk_shutdown |= RCV_SHUTDOWN;
+		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 
 		switch (sk->sk_state) {
 		case TCP_ESTABLISHED:
@@ -455,14 +501,6 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 	}
 }
 
-static void mptcp_stop_timer(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
-	mptcp_sk(sk)->timer_ival = 0;
-}
-
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 {
 	const struct sock *sk = (const struct sock *)msk;
-- 
2.28.0

