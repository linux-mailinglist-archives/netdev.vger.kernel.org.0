Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0165432DBDB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbhCDVea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:34:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:46776 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239582AbhCDVeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:34:10 -0500
IronPort-SDR: Yb/TwRVysytJ54325umC6d6agRuzH1i8hXP6SU5GTywY7vDTYm2mQmI7ffCXodT/ar6cAhmHtm
 wAS/NKOUnzVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187566593"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="187566593"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
IronPort-SDR: M8Pvzce1roZ4Hh6DmKTbhFZoSawbSXesrf/Sn9j1Q9jRoTblqAHpINwk0yzDWnBnqQz372Q+on
 mIx7Wo6mSivg==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329487"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 6/9] mptcp: factor out __mptcp_retrans helper()
Date:   Thu,  4 Mar 2021 13:32:13 -0800
Message-Id: <20210304213216.205472-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Will simplify the following patch, no functional change
intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 93 ++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3dcb564b03ad..67aaf7154dca 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2261,59 +2261,23 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 	mptcp_close_wake_up(sk);
 }
 
-static void mptcp_worker(struct work_struct *work)
+static void __mptcp_retrans(struct sock *sk)
 {
-	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
-	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_sendmsg_info info = {};
 	struct mptcp_data_frag *dfrag;
 	size_t copied = 0;
-	int state, ret;
-
-	lock_sock(sk);
-	state = sk->sk_state;
-	if (unlikely(state == TCP_CLOSE))
-		goto unlock;
-
-	mptcp_check_data_fin_ack(sk);
-	__mptcp_flush_join_list(msk);
-
-	mptcp_check_fastclose(msk);
-
-	if (msk->pm.status)
-		mptcp_pm_nl_work(msk);
-
-	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
-		mptcp_check_for_eof(msk);
-
-	__mptcp_check_send_data_fin(sk);
-	mptcp_check_data_fin(sk);
-
-	/* There is no point in keeping around an orphaned sk timedout or
-	 * closed, but we need the msk around to reply to incoming DATA_FIN,
-	 * even if it is orphaned and in FIN_WAIT2 state
-	 */
-	if (sock_flag(sk, SOCK_DEAD) &&
-	    (mptcp_check_close_timeout(sk) || sk->sk_state == TCP_CLOSE)) {
-		inet_sk_state_store(sk, TCP_CLOSE);
-		__mptcp_destroy_sock(sk);
-		goto unlock;
-	}
-
-	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		__mptcp_close_subflow(msk);
-
-	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
-		goto unlock;
+	struct sock *ssk;
+	int ret;
 
 	__mptcp_clean_una(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag)
-		goto unlock;
+		return;
 
 	ssk = mptcp_subflow_get_retrans(msk);
 	if (!ssk)
-		goto reset_unlock;
+		goto reset_timer;
 
 	lock_sock(ssk);
 
@@ -2339,9 +2303,52 @@ static void mptcp_worker(struct work_struct *work)
 	mptcp_set_timeout(sk, ssk);
 	release_sock(ssk);
 
-reset_unlock:
+reset_timer:
 	if (!mptcp_timer_pending(sk))
 		mptcp_reset_timer(sk);
+}
+
+static void mptcp_worker(struct work_struct *work)
+{
+	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+	int state;
+
+	lock_sock(sk);
+	state = sk->sk_state;
+	if (unlikely(state == TCP_CLOSE))
+		goto unlock;
+
+	mptcp_check_data_fin_ack(sk);
+	__mptcp_flush_join_list(msk);
+
+	mptcp_check_fastclose(msk);
+
+	if (msk->pm.status)
+		mptcp_pm_nl_work(msk);
+
+	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
+		mptcp_check_for_eof(msk);
+
+	__mptcp_check_send_data_fin(sk);
+	mptcp_check_data_fin(sk);
+
+	/* There is no point in keeping around an orphaned sk timedout or
+	 * closed, but we need the msk around to reply to incoming DATA_FIN,
+	 * even if it is orphaned and in FIN_WAIT2 state
+	 */
+	if (sock_flag(sk, SOCK_DEAD) &&
+	    (mptcp_check_close_timeout(sk) || sk->sk_state == TCP_CLOSE)) {
+		inet_sk_state_store(sk, TCP_CLOSE);
+		__mptcp_destroy_sock(sk);
+		goto unlock;
+	}
+
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(msk);
+
+	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
+		__mptcp_retrans(sk);
 
 unlock:
 	release_sock(sk);
-- 
2.30.1

