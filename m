Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436FA3A3783
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFJXBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:01:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:55163 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhFJXBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 19:01:48 -0400
IronPort-SDR: QSg44j4lDQRj9VB1+Op4meadVtCD8+5toK+zBAuWYhqH6JStbY4rk07kjLTJa4EhwaUGC0N7md
 1AIsjksCWALg==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="205383803"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="205383803"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
IronPort-SDR: Fd31XJANbNGZT/ji+QPMMpkdboAfRF/i9e6XSCrgpzpxu7jZHRjNoP3RSwaivnmFvKktuVtC1k
 PBdFEA3ZPvSg==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="441387026"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.70.185])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, dcaratti@redhat.com,
        fw@strlen.de, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/5] mptcp: wake-up readers only for in sequence data
Date:   Thu, 10 Jun 2021 15:59:41 -0700
Message-Id: <20210610225944.351224-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
References: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently we rely on the subflow->data_avail field, which is subject to
races:

	ssk1
		skb len = 500 DSS(seq=1, len=1000, off=0)
		# data_avail == MPTCP_SUBFLOW_DATA_AVAIL

	ssk2
		skb len = 500 DSS(seq = 501, len=1000)
		# data_avail == MPTCP_SUBFLOW_DATA_AVAIL

	ssk1
		skb len = 500 DSS(seq = 1, len=1000, off =500)
		# still data_avail == MPTCP_SUBFLOW_DATA_AVAIL,
		# as the skb is covered by a pre-existing map,
		# which was in-sequence at reception time.

Instead we can explicitly check if some has been received in-sequence,
propagating the info from __mptcp_move_skbs_from_subflow().

Additionally add the 'ONCE' annotation to the 'data_avail' memory
access, as msk will read it outside the subflow socket lock.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 33 ++++++++++++---------------------
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 23 +++++++++--------------
 3 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 534cf500521d..f6e62a6dc9fb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -670,15 +670,13 @@ static bool __mptcp_ofo_queue(struct mptcp_sock *msk)
 /* In most cases we will be able to lock the mptcp socket.  If its already
  * owned, we need to defer to the work queue to avoid ABBA deadlock.
  */
-static void move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
+static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
 
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
-
-	mptcp_data_lock(sk);
+		return false;
 
 	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 	__mptcp_ofo_queue(msk);
@@ -690,7 +688,7 @@ static void move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 	 */
 	if (mptcp_pending_data_fin(sk, NULL))
 		mptcp_schedule_work(sk);
-	mptcp_data_unlock(sk);
+	return moved > 0;
 }
 
 void mptcp_data_ready(struct sock *sk, struct sock *ssk)
@@ -698,7 +696,6 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	int sk_rbuf, ssk_rbuf;
-	bool wake;
 
 	/* The peer can send data while we are shutting down this
 	 * subflow at msk destruction time, but we must avoid enqueuing
@@ -707,28 +704,22 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	if (unlikely(subflow->disposable))
 		return;
 
-	/* move_skbs_to_msk below can legitly clear the data_avail flag,
-	 * but we will need later to properly woke the reader, cache its
-	 * value
-	 */
-	wake = subflow->data_avail == MPTCP_SUBFLOW_DATA_AVAIL;
-	if (wake)
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-
 	ssk_rbuf = READ_ONCE(ssk->sk_rcvbuf);
 	sk_rbuf = READ_ONCE(sk->sk_rcvbuf);
 	if (unlikely(ssk_rbuf > sk_rbuf))
 		sk_rbuf = ssk_rbuf;
 
-	/* over limit? can't append more skbs to msk */
+	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
 	if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf)
-		goto wake;
-
-	move_skbs_to_msk(msk, ssk);
+		return;
 
-wake:
-	if (wake)
+	/* Wake-up the reader only for in-sequence data */
+	mptcp_data_lock(sk);
+	if (move_skbs_to_msk(msk, ssk)) {
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 		sk->sk_data_ready(sk);
+	}
+	mptcp_data_unlock(sk);
 }
 
 static bool mptcp_do_flush_join_list(struct mptcp_sock *msk)
@@ -860,7 +851,7 @@ static struct sock *mptcp_subflow_recv_lookup(const struct mptcp_sock *msk)
 	sock_owned_by_me(sk);
 
 	mptcp_for_each_subflow(msk, subflow) {
-		if (subflow->data_avail)
+		if (READ_ONCE(subflow->data_avail))
 			return mptcp_subflow_tcp_sock(subflow);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0c6f99c67345..385796f0ef19 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -362,7 +362,6 @@ mptcp_subflow_rsk(const struct request_sock *rsk)
 enum mptcp_data_avail {
 	MPTCP_SUBFLOW_NODATA,
 	MPTCP_SUBFLOW_DATA_AVAIL,
-	MPTCP_SUBFLOW_OOO_DATA
 };
 
 struct mptcp_delegated_action {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ef3d037f984a..ebb898acd65a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1000,7 +1000,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	struct sk_buff *skb;
 
 	if (!skb_peek(&ssk->sk_receive_queue))
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 	if (subflow->data_avail)
 		return true;
 
@@ -1039,18 +1039,13 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
 		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
 			 ack_seq);
-		if (ack_seq == old_ack) {
-			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
-			break;
-		} else if (after64(ack_seq, old_ack)) {
-			subflow->data_avail = MPTCP_SUBFLOW_OOO_DATA;
-			break;
+		if (unlikely(before64(ack_seq, old_ack))) {
+			mptcp_subflow_discard_data(ssk, skb, old_ack - ack_seq);
+			continue;
 		}
 
-		/* only accept in-sequence mapping. Old values are spurious
-		 * retransmission
-		 */
-		mptcp_subflow_discard_data(ssk, skb, old_ack - ack_seq);
+		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
+		break;
 	}
 	return true;
 
@@ -1070,7 +1065,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		subflow->reset_transient = 0;
 		subflow->reset_reason = MPTCP_RST_EMPTCP;
 		tcp_send_active_reset(ssk, GFP_ATOMIC);
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 		return false;
 	}
 
@@ -1080,7 +1075,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	subflow->map_data_len = skb->len;
 	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
-	subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
+	WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
 	return true;
 }
 
@@ -1092,7 +1087,7 @@ bool mptcp_subflow_data_available(struct sock *sk)
 	if (subflow->map_valid &&
 	    mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len) {
 		subflow->map_valid = 0;
-		subflow->data_avail = 0;
+		WRITE_ONCE(subflow->data_avail, 0);
 
 		pr_debug("Done with mapping: seq=%u data_len=%u",
 			 subflow->map_subflow_seq,
-- 
2.32.0

