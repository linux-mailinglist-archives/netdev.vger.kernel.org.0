Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493D816FA62
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgBZJPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:07 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60760 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgBZJPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:07 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smX-0001MQ-8y; Wed, 26 Feb 2020 10:15:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/7] mptcp: add and use mptcp_data_ready helper
Date:   Wed, 26 Feb 2020 10:14:46 +0100
Message-Id: <20200226091452.1116-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

allows us to schedule the work queue to drain the ssk receive queue in
a followup patch.

This is needed to avoid sending all-to-pessimistic mptcp-level
acknowledgements.  At this time, the ack_seq is what was last read by
userspace instead of the highest in-sequence number queued for reading.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c |  8 ++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 14 ++++----------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e9aa6807b5be..1d55563e9aca 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -111,6 +111,14 @@ static struct sock *mptcp_subflow_get(const struct mptcp_sock *msk)
 	return NULL;
 }
 
+void mptcp_data_ready(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	set_bit(MPTCP_DATA_READY, &msk->flags);
+	sk->sk_data_ready(sk);
+}
+
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 {
 	if (!msk->cached_ext)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 9f8663b30456..67895a7c1e5b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -201,6 +201,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
 void mptcp_finish_connect(struct sock *sk);
+void mptcp_data_ready(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 65122edf60aa..3dad662840aa 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -554,11 +554,8 @@ static void subflow_data_ready(struct sock *sk)
 		return;
 	}
 
-	if (mptcp_subflow_data_available(sk)) {
-		set_bit(MPTCP_DATA_READY, &mptcp_sk(parent)->flags);
-
-		parent->sk_data_ready(parent);
-	}
+	if (mptcp_subflow_data_available(sk))
+		mptcp_data_ready(parent);
 }
 
 static void subflow_write_space(struct sock *sk)
@@ -690,11 +687,8 @@ static void subflow_state_change(struct sock *sk)
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.
 	 */
-	if (parent && subflow->mp_capable && mptcp_subflow_data_available(sk)) {
-		set_bit(MPTCP_DATA_READY, &mptcp_sk(parent)->flags);
-
-		parent->sk_data_ready(parent);
-	}
+	if (parent && subflow->mp_capable && mptcp_subflow_data_available(sk))
+		mptcp_data_ready(parent);
 
 	if (parent && !(parent->sk_shutdown & RCV_SHUTDOWN) &&
 	    !subflow->rx_eof && subflow_is_done(sk)) {
-- 
2.24.1

