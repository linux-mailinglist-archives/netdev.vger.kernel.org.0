Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FDC479792
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhLQXhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:37:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:5665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhLQXhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 18:37:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="326146288"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="326146288"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="683556053"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.7.225])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:06 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/3] mptcp: enforce HoL-blocking estimation
Date:   Fri, 17 Dec 2021 15:37:00 -0800
Message-Id: <20211217233702.299461-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
References: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP packet scheduler has sub-optimal behavior with asymmetric
subflows: if the faster subflow-level cwin is closed, the packet
scheduler can enqueue "too much" data on a slower subflow.

When all the data on the faster subflow is acked, if the mptcp-level
cwin is closed, and link utilization becomes suboptimal.

The solution is implementing blest-like[1] HoL-blocking estimation,
transmitting only on the subflow with the shorter estimated time to
flush the queued memory. If such subflows cwin is closed, we wait
even if other subflows are available.

This is quite simpler than the original blest implementation, as we
leverage the pacing rate provided by the TCP socket. To get a more
accurate estimation for the subflow linger-time, we maintain a
per-subflow weighted average of such info.

Additionally drop magic numbers usage in favor of newly defined
macros and use more meaningful names for status variable.

[1] http://dl.ifip.org/db/conf/networking/networking2016/1570234725.pdf

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/137
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 72 +++++++++++++++++++++++++++++---------------
 net/mptcp/protocol.h |  1 +
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3e549f6190c0..df5a0cf431c1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1372,7 +1372,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 struct subflow_send_info {
 	struct sock *ssk;
-	u64 ratio;
+	u64 linger_time;
 };
 
 void mptcp_subflow_set_active(struct mptcp_subflow_context *subflow)
@@ -1397,20 +1397,24 @@ bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 	return __mptcp_subflow_active(subflow);
 }
 
+#define SSK_MODE_ACTIVE	0
+#define SSK_MODE_BACKUP	1
+#define SSK_MODE_MAX	2
+
 /* implement the mptcp packet scheduler;
  * returns the subflow that will transmit the next DSS
  * additionally updates the rtx timeout
  */
 static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 {
-	struct subflow_send_info send_info[2];
+	struct subflow_send_info send_info[SSK_MODE_MAX];
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
+	u32 pace, burst, wmem;
 	int i, nr_active = 0;
 	struct sock *ssk;
+	u64 linger_time;
 	long tout = 0;
-	u64 ratio;
-	u32 pace;
 
 	sock_owned_by_me(sk);
 
@@ -1429,10 +1433,11 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	}
 
 	/* pick the subflow with the lower wmem/wspace ratio */
-	for (i = 0; i < 2; ++i) {
+	for (i = 0; i < SSK_MODE_MAX; ++i) {
 		send_info[i].ssk = NULL;
-		send_info[i].ratio = -1;
+		send_info[i].linger_time = -1;
 	}
+
 	mptcp_for_each_subflow(msk, subflow) {
 		trace_mptcp_subflow_get_send(subflow);
 		ssk =  mptcp_subflow_tcp_sock(subflow);
@@ -1441,34 +1446,51 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 
 		tout = max(tout, mptcp_timeout_from_subflow(subflow));
 		nr_active += !subflow->backup;
-		if (!sk_stream_memory_free(subflow->tcp_sock) || !tcp_sk(ssk)->snd_wnd)
-			continue;
-
-		pace = READ_ONCE(ssk->sk_pacing_rate);
-		if (!pace)
-			continue;
+		pace = subflow->avg_pacing_rate;
+		if (unlikely(!pace)) {
+			/* init pacing rate from socket */
+			subflow->avg_pacing_rate = READ_ONCE(ssk->sk_pacing_rate);
+			pace = subflow->avg_pacing_rate;
+			if (!pace)
+				continue;
+		}
 
-		ratio = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32,
-				pace);
-		if (ratio < send_info[subflow->backup].ratio) {
+		linger_time = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32, pace);
+		if (linger_time < send_info[subflow->backup].linger_time) {
 			send_info[subflow->backup].ssk = ssk;
-			send_info[subflow->backup].ratio = ratio;
+			send_info[subflow->backup].linger_time = linger_time;
 		}
 	}
 	__mptcp_set_timeout(sk, tout);
 
 	/* pick the best backup if no other subflow is active */
 	if (!nr_active)
-		send_info[0].ssk = send_info[1].ssk;
-
-	if (send_info[0].ssk) {
-		msk->last_snd = send_info[0].ssk;
-		msk->snd_burst = min_t(int, MPTCP_SEND_BURST_SIZE,
-				       tcp_sk(msk->last_snd)->snd_wnd);
-		return msk->last_snd;
-	}
+		send_info[SSK_MODE_ACTIVE].ssk = send_info[SSK_MODE_BACKUP].ssk;
+
+	/* According to the blest algorithm, to avoid HoL blocking for the
+	 * faster flow, we need to:
+	 * - estimate the faster flow linger time
+	 * - use the above to estimate the amount of byte transferred
+	 *   by the faster flow
+	 * - check that the amount of queued data is greter than the above,
+	 *   otherwise do not use the picked, slower, subflow
+	 * We select the subflow with the shorter estimated time to flush
+	 * the queued mem, which basically ensure the above. We just need
+	 * to check that subflow has a non empty cwin.
+	 */
+	ssk = send_info[SSK_MODE_ACTIVE].ssk;
+	if (!ssk || !sk_stream_memory_free(ssk) || !tcp_sk(ssk)->snd_wnd)
+		return NULL;
 
-	return NULL;
+	burst = min_t(int, MPTCP_SEND_BURST_SIZE, tcp_sk(ssk)->snd_wnd);
+	wmem = READ_ONCE(ssk->sk_wmem_queued);
+	subflow = mptcp_subflow_ctx(ssk);
+	subflow->avg_pacing_rate = div_u64((u64)subflow->avg_pacing_rate * wmem +
+					   READ_ONCE(ssk->sk_pacing_rate) * burst,
+					   burst + wmem);
+	msk->last_snd = ssk;
+	msk->snd_burst = burst;
+	return ssk;
 }
 
 static void mptcp_push_release(struct sock *ssk, struct mptcp_sendmsg_info *info)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e1469155fb15..0486c9f5b38b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -395,6 +395,7 @@ DECLARE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
+	unsigned long avg_pacing_rate; /* protected by msk socket lock */
 	u64	local_key;
 	u64	remote_key;
 	u64	idsn;
-- 
2.34.1

