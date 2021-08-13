Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E7A3EBE30
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhHMWQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:29030 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhHMWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520895"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520895"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320452"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:54 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/8] mptcp: less aggressive retransmission strategy
Date:   Fri, 13 Aug 2021 15:15:42 -0700
Message-Id: <20210813221548.111990-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The current mptcp re-inject strategy is very aggressive,
we have mptcp-level retransmissions even on single subflow
connection, if the link in-use is lossy.

Let's be a little more conservative: we do retransmit
only if at least a subflow has write and rtx queue empty.

Additionally use the backup subflows only if the active
subflows are stale - no progresses in at least an rtx period
and ignore stale subflows for rtx timeout update

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/207
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       | 17 +++++++++++++++++
 net/mptcp/protocol.c | 25 ++++++++++++++++---------
 net/mptcp/protocol.h |  5 ++++-
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 639271e09604..9ff17c5205ce 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -308,6 +308,23 @@ int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	return mptcp_pm_nl_get_local_id(msk, skc);
 }
 
+void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	u32 rcv_tstamp = READ_ONCE(tcp_sk(ssk)->rcv_tstamp);
+
+	/* keep track of rtx periods with no progress */
+	if (!subflow->stale_count) {
+		subflow->stale_rcv_tstamp = rcv_tstamp;
+		subflow->stale_count++;
+	} else if (subflow->stale_rcv_tstamp == rcv_tstamp) {
+		if (subflow->stale_count < U8_MAX)
+			subflow->stale_count++;
+	} else {
+		subflow->stale_count = 0;
+	}
+}
+
 void mptcp_pm_data_init(struct mptcp_sock *msk)
 {
 	msk->pm.add_addr_signaled = 0;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 08fa2c73a7e5..decbb4295ae1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -420,7 +420,8 @@ static long mptcp_timeout_from_subflow(const struct mptcp_subflow_context *subfl
 {
 	const struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-	return inet_csk(ssk)->icsk_pending ? inet_csk(ssk)->icsk_timeout - jiffies : 0;
+	return inet_csk(ssk)->icsk_pending && !subflow->stale_count ?
+	       inet_csk(ssk)->icsk_timeout - jiffies : 0;
 }
 
 static void mptcp_set_timeout(struct sock *sk)
@@ -2100,8 +2101,9 @@ static void mptcp_timeout_timer(struct timer_list *t)
  */
 static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 {
+	struct sock *backup = NULL, *pick = NULL;
 	struct mptcp_subflow_context *subflow;
-	struct sock *backup = NULL;
+	int min_stale_count = INT_MAX;
 
 	sock_owned_by_me((const struct sock *)msk);
 
@@ -2114,11 +2116,11 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 		if (!mptcp_subflow_active(subflow))
 			continue;
 
-		/* still data outstanding at TCP level?  Don't retransmit. */
-		if (!tcp_write_queue_empty(ssk)) {
-			if (inet_csk(ssk)->icsk_ca_state >= TCP_CA_Loss)
-				continue;
-			return NULL;
+		/* still data outstanding at TCP level? skip this */
+		if (!tcp_rtx_and_write_queues_empty(ssk)) {
+			mptcp_pm_subflow_chk_stale(msk, ssk);
+			min_stale_count = min_t(int, min_stale_count, subflow->stale_count);
+			continue;
 		}
 
 		if (subflow->backup) {
@@ -2127,10 +2129,15 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 			continue;
 		}
 
-		return ssk;
+		if (!pick)
+			pick = ssk;
 	}
 
-	return backup;
+	if (pick)
+		return pick;
+
+	/* use backup only if there are no progresses anywhere */
+	return min_stale_count > 1 ? backup : NULL;
 }
 
 static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0f0c026c5f8b..6a3cbdb597e2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -439,11 +439,13 @@ struct mptcp_subflow_context {
 	u8	reset_seen:1;
 	u8	reset_transient:1;
 	u8	reset_reason:4;
+	u8	stale_count;
 
 	long	delegated_status;
 	struct	list_head delegated_node;   /* link into delegated_action, protected by local BH */
 
-	u32 setsockopt_seq;
+	u32	setsockopt_seq;
+	u32	stale_rcv_tstamp;
 
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
@@ -690,6 +692,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
+void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);
 void mptcp_pm_fully_established(struct mptcp_sock *msk, const struct sock *ssk, gfp_t gfp);
 bool mptcp_pm_allow_new_subflow(struct mptcp_sock *msk);
-- 
2.32.0

