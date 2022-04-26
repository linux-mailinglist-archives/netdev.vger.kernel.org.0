Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F2D510B9A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 23:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355598AbiDZWAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355601AbiDZWAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:00:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D84B41F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 14:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651010246; x=1682546246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YVHyLHCsb3hF5WWwDRxMNM4YLf+lLPKzKCx6qIJuhX8=;
  b=AJBHdFqwh/YUUspBsvTBcJObKdCtH5yuly+Jx2THkcC+0Dg3QysmnFmq
   1Z5F1bzDr4p96PHcWvAXsVI80dAXcNGB5SaVIZMpmybv7pDy4N2XEsYCA
   SaMoEohSsSu7jymtoFIkXFDYkK0UjoS4pqTHLlwH9pLUI+WcSdznnOpLe
   lN/Q8bW1LJuIBynJ0C5AD2F6xDciohQbSC4IElRUjJlbo/VTDzYVvlPFy
   fLiJXo15ol3iOQdJfjMQGRgDZGKfJGUh4e/RgpyEKiK+L37YlLM3iOtHo
   k2iDILEc+yWZrKp8PLvcGd8NoXfXQ9cGPwCmgINRmHS15vU7ueO8bujrJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="352172425"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="352172425"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 14:57:23 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="532878098"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.10.176])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 14:57:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] mptcp: reset subflow when MP_FAIL doesn't respond
Date:   Tue, 26 Apr 2022 14:57:15 -0700
Message-Id: <20220426215717.129506-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426215717.129506-1-mathew.j.martineau@linux.intel.com>
References: <20220426215717.129506-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds a new msk->flags bit MPTCP_FAIL_NO_RESPONSE, then reuses
sk_timer to trigger a check if we have not received a response from the
peer after sending MP_FAIL. If the peer doesn't respond properly, reset
the subflow.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       |  8 ++++++++
 net/mptcp/protocol.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 11 ++++++++++
 4 files changed, 68 insertions(+)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 971e843a304c..14f448d82bb2 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -287,6 +287,7 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct sock *s = (struct sock *)msk;
 
 	pr_debug("fail_seq=%llu", fail_seq);
 
@@ -299,6 +300,13 @@ void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
 		subflow->send_mp_fail = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPFAILTX);
 		subflow->send_infinite_map = 1;
+	} else if (s && inet_sk_state_load(s) != TCP_CLOSE) {
+		pr_debug("MP_FAIL response received");
+
+		mptcp_data_lock(s);
+		if (inet_sk_state_load(s) != TCP_CLOSE)
+			sk_stop_timer(s, &s->sk_timer);
+		mptcp_data_unlock(s);
 	}
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ea74122065f1..a5d466e6b538 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2169,10 +2169,38 @@ static void mptcp_retransmit_timer(struct timer_list *t)
 	sock_put(sk);
 }
 
+static struct mptcp_subflow_context *
+mp_fail_response_expect_subflow(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow, *ret = NULL;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		if (READ_ONCE(subflow->mp_fail_response_expect)) {
+			ret = subflow;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void mptcp_check_mp_fail_response(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+
+	bh_lock_sock(sk);
+	subflow = mp_fail_response_expect_subflow(msk);
+	if (subflow)
+		__set_bit(MPTCP_FAIL_NO_RESPONSE, &msk->flags);
+	bh_unlock_sock(sk);
+}
+
 static void mptcp_timeout_timer(struct timer_list *t)
 {
 	struct sock *sk = from_timer(sk, t, sk_timer);
 
+	mptcp_check_mp_fail_response(mptcp_sk(sk));
 	mptcp_schedule_work(sk);
 	sock_put(sk);
 }
@@ -2499,6 +2527,23 @@ static void __mptcp_retrans(struct sock *sk)
 	mptcp_data_unlock(sk);
 }
 
+static void mptcp_mp_fail_no_response(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *ssk;
+	bool slow;
+
+	subflow = mp_fail_response_expect_subflow(msk);
+	if (subflow) {
+		pr_debug("MP_FAIL doesn't respond, reset the subflow");
+
+		ssk = mptcp_subflow_tcp_sock(subflow);
+		slow = lock_sock_fast(ssk);
+		mptcp_subflow_reset(ssk);
+		unlock_sock_fast(ssk, slow);
+	}
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -2539,6 +2584,9 @@ static void mptcp_worker(struct work_struct *work)
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
+	if (test_and_clear_bit(MPTCP_FAIL_NO_RESPONSE, &msk->flags))
+		mptcp_mp_fail_no_response(msk);
+
 unlock:
 	release_sock(sk);
 	sock_put(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index cc66c81a8fab..3a8740fef918 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -116,6 +116,7 @@
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
+#define MPTCP_FAIL_NO_RESPONSE	6
 
 /* MPTCP socket release cb flags */
 #define MPTCP_PUSH_PENDING	1
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ca2352ad20d4..75c824b67ca9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -968,6 +968,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	bool csum_reqd = READ_ONCE(msk->csum_enabled);
+	struct sock *sk = (struct sock *)msk;
 	struct mptcp_ext *mpext;
 	struct sk_buff *skb;
 	u16 data_len;
@@ -1009,6 +1010,12 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 		pr_debug("infinite mapping received");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		subflow->map_data_len = 0;
+		if (sk && inet_sk_state_load(sk) != TCP_CLOSE) {
+			mptcp_data_lock(sk);
+			if (inet_sk_state_load(sk) != TCP_CLOSE)
+				sk_stop_timer(sk, &sk->sk_timer);
+			mptcp_data_unlock(sk);
+		}
 		return MAPPING_INVALID;
 	}
 
@@ -1219,6 +1226,10 @@ static bool subflow_check_data_avail(struct sock *ssk)
 					sk_eat_skb(ssk, skb);
 			} else {
 				WRITE_ONCE(subflow->mp_fail_response_expect, true);
+				/* The data lock is acquired in __mptcp_move_skbs() */
+				sk_reset_timer((struct sock *)msk,
+					       &((struct sock *)msk)->sk_timer,
+					       jiffies + TCP_RTO_MAX);
 			}
 			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
 			return true;
-- 
2.36.0

