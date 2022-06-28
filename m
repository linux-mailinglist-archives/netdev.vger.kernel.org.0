Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB955D1DD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiF1BDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbiF1BCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158E9222B4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378172; x=1687914172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SZMGGdom3UTaqSHVSKVxP0Y/R0YYJNQ8r6w/sDGPGSE=;
  b=RFSJGMQiMBm0BDMXVmFSoPWKmPQdL1UQIHj1hJk/4I1ERcDN1GF7Z+X7
   PRRXFYuMYm/fGHwntwyEdx+TH1qKKvVj/njn8vj77MYF1M9UJkARuVUl0
   U2hMsJ2w4UcaIF9BPytUmGGCEwIbsORmHpSwqJRQgpQKMlJBgcIskQxLQ
   xWrDt1Iic7UbOL4ncSKRdfHb6e20tsOA8S0jkd3W5D7ma+mJHDdM1Xzgh
   Dz81wgLW/vUtLj6rLo35UmR/CgfKYJ8bkbFlgWmFHhlKOwq41gVa2bu47
   eSXVvk0uKBlJHtcALb+48scU+nEy/im1vYzUjQLF6XLX5Q1yoHoYaUmjH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642446"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642446"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867373"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/9] mptcp: invoke MP_FAIL response when needed
Date:   Mon, 27 Jun 2022 18:02:37 -0700
Message-Id: <20220628010243.166605-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
References: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

mptcp_mp_fail_no_response shouldn't be invoked on each worker run, it
should be invoked only when MP_FAIL response timeout occurs.

This patch refactors the MP_FAIL response logic.

It leverages the fact that only the MPC/first subflow can gracefully
fail to avoid unneeded subflows traversal: the failing subflow can
be only msk->first.

A new 'fail_tout' field is added to the subflow context to record the
MP_FAIL response timeout and use such field to reliably share the
timeout timer between the MP_FAIL event and the MPTCP socket close
timeout.

Finally, a new ack is generated to send out MP_FAIL notification as soon
as we hit the relevant condition, instead of waiting a possibly unbound
time for the next data packet.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/281
Fixes: d9fb797046c5 ("mptcp: Do not traverse the subflow connection list without lock")
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       |  9 +++---
 net/mptcp/protocol.c | 77 +++++++++++++++++++++++++++-----------------
 net/mptcp/protocol.h |  3 +-
 net/mptcp/subflow.c  | 38 ++++++++++++++++------
 4 files changed, 82 insertions(+), 45 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 91a62b598de4..45e2a48397b9 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -299,22 +299,21 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	struct sock *s = (struct sock *)msk;
 
 	pr_debug("fail_seq=%llu", fail_seq);
 
 	if (!READ_ONCE(msk->allow_infinite_fallback))
 		return;
 
-	if (!READ_ONCE(subflow->mp_fail_response_expect)) {
+	if (!subflow->fail_tout) {
 		pr_debug("send MP_FAIL response and infinite map");
 
 		subflow->send_mp_fail = 1;
 		subflow->send_infinite_map = 1;
-	} else if (!sock_flag(sk, SOCK_DEAD)) {
+		tcp_send_ack(sk);
+	} else {
 		pr_debug("MP_FAIL response received");
-
-		sk_stop_timer(s, &s->sk_timer);
+		WRITE_ONCE(subflow->fail_tout, 0);
 	}
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 17e13396024a..e6fcb61443dd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -500,7 +500,7 @@ static void mptcp_set_timeout(struct sock *sk)
 	__mptcp_set_timeout(sk, tout);
 }
 
-static bool tcp_can_send_ack(const struct sock *ssk)
+static inline bool tcp_can_send_ack(const struct sock *ssk)
 {
 	return !((1 << inet_sk_state_load(ssk)) &
 	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE | TCPF_LISTEN));
@@ -2175,21 +2175,6 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
-static struct mptcp_subflow_context *
-mp_fail_response_expect_subflow(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow, *ret = NULL;
-
-	mptcp_for_each_subflow(msk, subflow) {
-		if (READ_ONCE(subflow->mp_fail_response_expect)) {
-			ret = subflow;
-			break;
-		}
-	}
-
-	return ret;
-}
-
 static void mptcp_timeout_timer(struct timer_list *t)
 {
 	struct sock *sk = from_timer(sk, t, sk_timer);
@@ -2518,27 +2503,50 @@ static void __mptcp_retrans(struct sock *sk)
 		mptcp_reset_timer(sk);
 }
 
+/* schedule the timeout timer for the relevant event: either close timeout
+ * or mp_fail timeout. The close timeout takes precedence on the mp_fail one
+ */
+void mptcp_reset_timeout(struct mptcp_sock *msk, unsigned long fail_tout)
+{
+	struct sock *sk = (struct sock *)msk;
+	unsigned long timeout, close_timeout;
+
+	if (!fail_tout && !sock_flag(sk, SOCK_DEAD))
+		return;
+
+	close_timeout = inet_csk(sk)->icsk_mtup.probe_timestamp - tcp_jiffies32 + jiffies + TCP_TIMEWAIT_LEN;
+
+	/* the close timeout takes precedence on the fail one, and here at least one of
+	 * them is active
+	 */
+	timeout = sock_flag(sk, SOCK_DEAD) ? close_timeout : fail_tout;
+
+	sk_reset_timer(sk, &sk->sk_timer, timeout);
+}
+
 static void mptcp_mp_fail_no_response(struct mptcp_sock *msk)
 {
-	struct mptcp_subflow_context *subflow;
-	struct sock *ssk;
+	struct sock *ssk = msk->first;
 	bool slow;
 
-	subflow = mp_fail_response_expect_subflow(msk);
-	if (subflow) {
-		pr_debug("MP_FAIL doesn't respond, reset the subflow");
+	if (!ssk)
+		return;
 
-		ssk = mptcp_subflow_tcp_sock(subflow);
-		slow = lock_sock_fast(ssk);
-		mptcp_subflow_reset(ssk);
-		unlock_sock_fast(ssk, slow);
-	}
+	pr_debug("MP_FAIL doesn't respond, reset the subflow");
+
+	slow = lock_sock_fast(ssk);
+	mptcp_subflow_reset(ssk);
+	WRITE_ONCE(mptcp_subflow_ctx(ssk)->fail_tout, 0);
+	unlock_sock_fast(ssk, slow);
+
+	mptcp_reset_timeout(msk, 0);
 }
 
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
 	struct sock *sk = &msk->sk.icsk_inet.sk;
+	unsigned long fail_tout;
 	int state;
 
 	lock_sock(sk);
@@ -2575,7 +2583,9 @@ static void mptcp_worker(struct work_struct *work)
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
-	mptcp_mp_fail_no_response(msk);
+	fail_tout = msk->first ? READ_ONCE(mptcp_subflow_ctx(msk->first)->fail_tout) : 0;
+	if (fail_tout && time_after(jiffies, fail_tout))
+		mptcp_mp_fail_no_response(msk);
 
 unlock:
 	release_sock(sk);
@@ -2822,6 +2832,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 	bool do_cancel_work = false;
 
 	lock_sock(sk);
@@ -2840,10 +2851,16 @@ static void mptcp_close(struct sock *sk, long timeout)
 cleanup:
 	/* orphan all the subflows */
 	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
-	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
+	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow = lock_sock_fast_nested(ssk);
 
+		/* since the close timeout takes precedence on the fail one,
+		 * cancel the latter
+		 */
+		if (ssk == msk->first)
+			subflow->fail_tout = 0;
+
 		sock_orphan(ssk);
 		unlock_sock_fast(ssk, slow);
 	}
@@ -2852,13 +2869,13 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
 	if (mptcp_sk(sk)->token)
-		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
+		mptcp_event(MPTCP_EVENT_CLOSED, msk, NULL, GFP_KERNEL);
 
 	if (sk->sk_state == TCP_CLOSE) {
 		__mptcp_destroy_sock(sk);
 		do_cancel_work = true;
 	} else {
-		sk_reset_timer(sk, &sk->sk_timer, jiffies + TCP_TIMEWAIT_LEN);
+		mptcp_reset_timeout(msk, 0);
 	}
 	release_sock(sk);
 	if (do_cancel_work)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 200f89f6d62f..1d2d71711872 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -468,7 +468,6 @@ struct mptcp_subflow_context {
 		local_id_valid : 1, /* local_id is correctly initialized */
 		valid_csum_seen : 1;        /* at least one csum validated */
 	enum mptcp_data_avail data_avail;
-	bool	mp_fail_response_expect;
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
@@ -482,6 +481,7 @@ struct mptcp_subflow_context {
 	u8	stale_count;
 
 	long	delegated_status;
+	unsigned long	fail_tout;
 
 	);
 
@@ -662,6 +662,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk);
 void __mptcp_set_connected(struct sock *sk);
+void mptcp_reset_timeout(struct mptcp_sock *msk, unsigned long fail_tout);
 static inline bool mptcp_is_fully_established(struct sock *sk)
 {
 	return inet_sk_state_load(sk) == TCP_ESTABLISHED &&
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 42a7c18a1c24..8dfea6a8a82f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -971,7 +971,6 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	bool csum_reqd = READ_ONCE(msk->csum_enabled);
-	struct sock *sk = (struct sock *)msk;
 	struct mptcp_ext *mpext;
 	struct sk_buff *skb;
 	u16 data_len;
@@ -1013,9 +1012,6 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		pr_debug("infinite mapping received");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		subflow->map_data_len = 0;
-		if (!sock_flag(ssk, SOCK_DEAD))
-			sk_stop_timer(sk, &sk->sk_timer);
-
 		return MAPPING_INVALID;
 	}
 
@@ -1162,6 +1158,33 @@ static bool subflow_can_fallback(struct mptcp_subflow_context *subflow)
 		return !subflow->fully_established;
 }
 
+static void mptcp_subflow_fail(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	unsigned long fail_tout;
+
+	/* greceful failure can happen only on the MPC subflow */
+	if (WARN_ON_ONCE(ssk != READ_ONCE(msk->first)))
+		return;
+
+	/* since the close timeout take precedence on the fail one,
+	 * no need to start the latter when the first is already set
+	 */
+	if (sock_flag((struct sock *)msk, SOCK_DEAD))
+		return;
+
+	/* we don't need extreme accuracy here, use a zero fail_tout as special
+	 * value meaning no fail timeout at all;
+	 */
+	fail_tout = jiffies + TCP_RTO_MAX;
+	if (!fail_tout)
+		fail_tout = 1;
+	WRITE_ONCE(subflow->fail_tout, fail_tout);
+	tcp_send_ack(ssk);
+
+	mptcp_reset_timeout(msk, subflow->fail_tout);
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -1236,11 +1259,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 				tcp_send_active_reset(ssk, GFP_ATOMIC);
 				while ((skb = skb_peek(&ssk->sk_receive_queue)))
 					sk_eat_skb(ssk, skb);
-			} else if (!sock_flag(ssk, SOCK_DEAD)) {
-				WRITE_ONCE(subflow->mp_fail_response_expect, true);
-				sk_reset_timer((struct sock *)msk,
-					       &((struct sock *)msk)->sk_timer,
-					       jiffies + TCP_RTO_MAX);
+			} else {
+				mptcp_subflow_fail(msk, ssk);
 			}
 			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 			return true;
-- 
2.37.0

