Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86192C94FC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfJBXhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729201AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862637"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 40/45] mptcp: implement and use MPTCP-level retransmission
Date:   Wed,  2 Oct 2019 16:36:50 -0700
Message-Id: <20191002233655.24323-41-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

On timeout event, schedule a work queue to do the retransmission.
Retransmission code resemple closely sendmsg() implementation and
re-uses mptcp_sendmsg_frag, providing a dummy msghdr - for flags'
sake - and peeking the relevant dfrag from the rtx head.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 81 ++++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h | 11 ++++++
 2 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6366dfd65aa8..b54fecf528b9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -759,10 +759,12 @@ static void mptcp_retransmit_handler(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (atomic64_read(&msk->snd_una) == msk->write_seq)
+	if (atomic64_read(&msk->snd_una) == msk->write_seq) {
 		mptcp_stop_timer(sk);
-	else
-		mptcp_reset_timer(sk);
+	} else {
+		if (schedule_work(&msk->rtx_work))
+			sock_hold(sk);
+	}
 }
 
 static void mptcp_retransmit_timer(struct timer_list *t)
@@ -784,6 +786,66 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
+static void mptcp_retransmit(struct work_struct *work)
+{
+	int orig_len, orig_offset, ret, mss_now = 0, size_goal = 0;
+	struct mptcp_data_frag *dfrag;
+	struct sock *ssk, *sk;
+	struct mptcp_sock *msk;
+	u64 orig_write_seq;
+	size_t copied = 0;
+	struct msghdr msg;
+	long timeo = 0;
+
+	msk = container_of(work, struct mptcp_sock, rtx_work);
+	sk = &msk->sk.icsk_inet.sk;
+
+	lock_sock(sk);
+	mptcp_clean_una(sk);
+	dfrag = mptcp_rtx_head(sk);
+	if (!dfrag)
+		goto unlock;
+
+	ssk = mptcp_subflow_get_ref(msk);
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
+	sock_put(ssk);
+
+reset_unlock:
+	if (!mptcp_timer_pending(sk))
+		mptcp_reset_timer(sk);
+
+unlock:
+	release_sock(sk);
+	sock_put(sk);
+}
+
 static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -791,6 +853,8 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->conn_list);
 	INIT_LIST_HEAD(&msk->rtx_queue);
 
+	INIT_WORK(&msk->rtx_work, mptcp_retransmit);
+
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
 
@@ -823,6 +887,14 @@ static void __mptcp_clear_xmit(struct sock *sk)
 		dfrag_clear(sk, dfrag);
 }
 
+static void mptcp_cancel_rtx_work(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (cancel_work_sync(&msk->rtx_work))
+		sock_put(sk);
+}
+
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
@@ -852,6 +924,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 	__mptcp_clear_xmit(sk);
 	release_sock(sk);
 
+	mptcp_cancel_rtx_work(sk);
+
 	sk_common_release(sk);
 }
 
@@ -860,6 +934,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	lock_sock(sk);
 	__mptcp_clear_xmit(sk);
 	release_sock(sk);
+	mptcp_cancel_rtx_work(sk);
 	return tcp_disconnect(sk, flags);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ef35d0aa8eb7..0c6bc8617cf4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -133,6 +133,7 @@ struct mptcp_sock {
 	u32		token;
 	unsigned long	flags;
 	u16		dport;
+	struct work_struct rtx_work;
 	struct list_head conn_list;
 	struct list_head rtx_queue;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
@@ -158,6 +159,16 @@ static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
+static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (list_empty(&msk->rtx_queue))
+		return NULL;
+
+	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
+}
+
 struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u8	mp_capable : 1,
-- 
2.23.0

