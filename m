Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A941960A8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgC0VtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:49:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:25804 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgC0VtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:49:13 -0400
IronPort-SDR: U9psBYhy/WW+/3VKhC4Jhkp0R9z0Z7A9LJGYB00khpp+2JXvZnQhESxf3+PnNcHZmw57RfeX9q
 zWDeokqZh4Gg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:49:10 -0700
IronPort-SDR: w3iHJp1lwbxtD5kO5jIx73v9agzUXHxX8twm8LgdJ7aLLt7bCvGCHwDtEXIuMBjUS8PSTCdrZt
 yDkEjPFQAmiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="271713476"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.7.195])
  by fmsmga004.fm.intel.com with ESMTP; 27 Mar 2020 14:49:10 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v3 12/17] mptcp: implement and use MPTCP-level retransmission
Date:   Fri, 27 Mar 2020 14:48:48 -0700
Message-Id: <20200327214853.140669-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

On timeout event, schedule a work queue to do the retransmission.
Retransmission code closely resembles the sendmsg() implementation and
re-uses mptcp_sendmsg_frag, providing a dummy msghdr - for flags'
sake - and peeking the relevant dfrag from the rtx head.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 98 ++++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |  1 +
 2 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b785d4a3766c..8d2777092390 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -283,6 +283,10 @@ static void mptcp_reset_timer(struct sock *sk)
 void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
+
+	if (!sk_stream_is_writeable(sk) &&
+	    schedule_work(&mptcp_sk(sk)->work))
+		sock_hold(sk);
 }
 
 static void mptcp_stop_timer(struct sock *sk)
@@ -900,10 +904,13 @@ static void mptcp_retransmit_handler(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (atomic64_read(&msk->snd_una) == msk->write_seq)
+	if (atomic64_read(&msk->snd_una) == msk->write_seq) {
 		mptcp_stop_timer(sk);
-	else
-		mptcp_reset_timer(sk);
+	} else {
+		set_bit(MPTCP_WORK_RTX, &msk->flags);
+		if (schedule_work(&msk->work))
+			sock_hold(sk);
+	}
 }
 
 static void mptcp_retransmit_timer(struct timer_list *t)
@@ -925,6 +932,37 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
+/* Find an idle subflow.  Return NULL if there is unacked data at tcp
+ * level.
+ *
+ * A backup subflow is returned only if that is the only kind available.
+ */
+static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *backup = NULL;
+
+	sock_owned_by_me((const struct sock *)msk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		/* still data outstanding at TCP level?  Don't retransmit. */
+		if (!tcp_write_queue_empty(ssk))
+			return NULL;
+
+		if (subflow->backup) {
+			if (!backup)
+				backup = ssk;
+			continue;
+		}
+
+		return ssk;
+	}
+
+	return backup;
+}
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -958,11 +996,62 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
-	struct sock *sk = &msk->sk.icsk_inet.sk;
+	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
+	int orig_len, orig_offset, ret, mss_now = 0, size_goal = 0;
+	struct mptcp_data_frag *dfrag;
+	u64 orig_write_seq;
+	size_t copied = 0;
+	struct msghdr msg;
+	long timeo = 0;
 
 	lock_sock(sk);
+	mptcp_clean_una(sk);
 	__mptcp_flush_join_list(msk);
 	__mptcp_move_skbs(msk);
+
+	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
+		goto unlock;
+
+	dfrag = mptcp_rtx_head(sk);
+	if (!dfrag)
+		goto unlock;
+
+	ssk = mptcp_subflow_get_retrans(msk);
+	if (!ssk)
+		goto reset_unlock;
+
+	lock_sock(ssk);
+
+	msg.msg_flags = MSG_DONTWAIT;
+	orig_len = dfrag->data_len;
+	orig_offset = dfrag->offset;
+	orig_write_seq = dfrag->data_seq;
+	while (dfrag->data_len > 0) {
+		ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &timeo, &mss_now,
+					 &size_goal);
+		if (ret < 0)
+			break;
+
+		copied += ret;
+		dfrag->data_len -= ret;
+		dfrag->offset += ret;
+	}
+	if (copied)
+		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
+			 size_goal);
+
+	dfrag->data_seq = orig_write_seq;
+	dfrag->offset = orig_offset;
+	dfrag->data_len = orig_len;
+
+	mptcp_set_timeout(sk, ssk);
+	release_sock(ssk);
+
+reset_unlock:
+	if (!mptcp_timer_pending(sk))
+		mptcp_reset_timer(sk);
+
+unlock:
 	release_sock(sk);
 	sock_put(sk);
 }
@@ -1124,6 +1213,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	lock_sock(sk);
 	__mptcp_clear_xmit(sk);
 	release_sock(sk);
+	mptcp_cancel_work(sk);
 	return tcp_disconnect(sk, flags);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f855c954a8ff..e9d4a852c7f1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -88,6 +88,7 @@
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	0
 #define MPTCP_SEND_SPACE	1
+#define MPTCP_WORK_RTX		2
 
 static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 {
-- 
2.26.0

