Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBDB31A88A
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhBMAD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:03:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:22720 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231613AbhBMADU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:03:20 -0500
IronPort-SDR: m+SQi4f1/E1MI4E/mcXbpWC6kYKHKAR4fuWA2I59KoU+N7VZ2oJPirEZ7ntGDLK3JWD4TnVFox
 rPFhpGBFLfdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="243981690"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="243981690"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:13 -0800
IronPort-SDR: QNY0zyzSca+hJMswB6ztPHpEXAeUiVYO+pMVH33zjHMa4/x68OFi+0BoIea2SDT7MrGigFOKuo
 D2mcWCmMwLng==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="423381126"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 16:00:12 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/8] mptcp: schedule worker when subflow is closed
Date:   Fri, 12 Feb 2021 15:59:56 -0800
Message-Id: <20210213000001.379332-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When remote side closes a subflow we should schedule the worker to
dispose of the subflow in a timely manner.

Otherwise, SF_CLOSED event won't be generated until the mptcp
socket itself is closing or local side is closing another subflow.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  4 ++++
 net/mptcp/subflow.c  | 25 +++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3fd8aef979a3..267c5521692d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2170,6 +2170,10 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (inet_sk_state_load(ssk) != TCP_CLOSE)
 			continue;
 
+		/* 'subflow_data_ready' will re-sched once rx queue is empty */
+		if (!skb_queue_empty_lockless(&ssk->sk_receive_queue))
+			continue;
+
 		mptcp_close_ssk((struct sock *)msk, ssk, subflow);
 	}
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 280da418d60b..36b15726f851 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -953,6 +953,22 @@ static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
 		subflow->map_valid = 0;
 }
 
+/* sched mptcp worker to remove the subflow if no more data is pending */
+static void subflow_sched_work_if_closed(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct sock *sk = (struct sock *)msk;
+
+	if (likely(ssk->sk_state != TCP_CLOSE))
+		return;
+
+	if (skb_queue_empty(&ssk->sk_receive_queue) &&
+	    !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags)) {
+		sock_hold(sk);
+		if (!schedule_work(&msk->work))
+			sock_put(sk);
+	}
+}
+
 static bool subflow_check_data_avail(struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
@@ -991,11 +1007,11 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		}
 
 		if (status != MAPPING_OK)
-			return false;
+			goto no_data;
 
 		skb = skb_peek(&ssk->sk_receive_queue);
 		if (WARN_ON_ONCE(!skb))
-			return false;
+			goto no_data;
 
 		/* if msk lacks the remote key, this subflow must provide an
 		 * MP_CAPABLE-based mapping
@@ -1029,6 +1045,9 @@ static bool subflow_check_data_avail(struct sock *ssk)
 	}
 	return true;
 
+no_data:
+	subflow_sched_work_if_closed(msk, ssk);
+	return false;
 fatal:
 	/* fatal protocol error, close the socket */
 	/* This barrier is coupled with smp_rmb() in tcp_poll() */
@@ -1413,6 +1432,8 @@ static void subflow_state_change(struct sock *sk)
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
 
+	subflow_sched_work_if_closed(mptcp_sk(parent), sk);
+
 	if (__mptcp_check_fallback(mptcp_sk(parent)) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
 		subflow->rx_eof = 1;
-- 
2.30.1

