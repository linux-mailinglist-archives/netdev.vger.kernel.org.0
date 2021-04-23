Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9672369740
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhDWQlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:13549 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDWQlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:15 -0400
IronPort-SDR: ixqW11+cw+TC1Wd5kkU5pbzgyYfNQX5UHdnA4KsQB+AdlhLo9oTRzwmJwxyUd6mvHXr/fo+zHS
 TPS3EsCkceqw==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218609"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218609"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:38 -0700
IronPort-SDR: d7JlwaUXzlGT1OH1nsvTSWRS05fVhKp+6GpOj8jQsHkNYNYf4rQYLVyI3528Y9o/l7y+ho6/eO
 Z+V7JpQChaGw==
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="428449394"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.72.13])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:38 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] mptcp: Retransmit DATA_FIN
Date:   Fri, 23 Apr 2021 09:40:33 -0700
Message-Id: <20210423164033.264095-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this change, the MPTCP-level retransmission timer is used to resend
DATA_FIN. The retranmit timer is not stopped while waiting for a
MPTCP-level ACK of DATA_FIN, and retransmitted DATA_FINs are sent on all
subflows. The retry interval starts at TCP_RTO_MIN and then doubles on
each attempt, up to TCP_RTO_MAX.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/146
Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4bde960e19dc..61329b8181ea 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -399,6 +399,14 @@ static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
 	return false;
 }
 
+static void mptcp_set_datafin_timeout(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	mptcp_sk(sk)->timer_ival = min(TCP_RTO_MAX,
+				       TCP_RTO_MIN << icsk->icsk_retransmits);
+}
+
 static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
 {
 	long tout = ssk && inet_csk(ssk)->icsk_pending ?
@@ -1052,7 +1060,7 @@ static void __mptcp_clean_una(struct sock *sk)
 	}
 
 	if (snd_una == READ_ONCE(msk->snd_nxt)) {
-		if (msk->timer_ival)
+		if (msk->timer_ival && !mptcp_data_fin_enabled(msk))
 			mptcp_stop_timer(sk);
 	} else {
 		mptcp_reset_timer(sk);
@@ -2276,8 +2284,19 @@ static void __mptcp_retrans(struct sock *sk)
 
 	__mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
-	if (!dfrag)
+	if (!dfrag) {
+		if (mptcp_data_fin_enabled(msk)) {
+			struct inet_connection_sock *icsk = inet_csk(sk);
+
+			icsk->icsk_retransmits++;
+			mptcp_set_datafin_timeout(sk);
+			mptcp_send_ack(msk);
+
+			goto reset_timer;
+		}
+
 		return;
+	}
 
 	ssk = mptcp_subflow_get_retrans(msk);
 	if (!ssk)
@@ -2460,6 +2479,8 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 			pr_debug("Sending DATA_FIN on subflow %p", ssk);
 			mptcp_set_timeout(sk, ssk);
 			tcp_send_ack(ssk);
+			if (!mptcp_timer_pending(sk))
+				mptcp_reset_timer(sk);
 		}
 		break;
 	}

base-commit: bb556de79f0a9e647e8febe15786ee68483fa67b
-- 
2.31.1

