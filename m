Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010FD2D6B8B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgLJXGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:06:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:9089 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392134AbgLJWcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:32:10 -0500
IronPort-SDR: hUoKinXAtqGMUERPz73bBPA21+3J2FPrn4hzDJPe/4+3fP51QQjgVOzbEdfkbeCuGi7lvU4r30
 x7PSwSutgtAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="171776489"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="171776489"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
IronPort-SDR: qNKJNKQEbEixEWJ6C/d0V4S6e3Z7BV2XD0xg/0b1F3Fqvi1lx1SPnwuuH3tBLsaFeQ7P95AYGN
 bqCk2u+Vc4Aw==
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="338703758"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.112.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 14:25:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/9] tcp: parse mptcp options contained in reset packets
Date:   Thu, 10 Dec 2020 14:25:03 -0800
Message-Id: <20201210222506.222251-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
References: <20201210222506.222251-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Because TCP-level resets only affect the subflow, there is a MPTCP
option to indicate that the MPTCP-level connection should be closed
immediately without a mptcp-level fin exchange.

This is the 'MPTCP fast close option'.  It can be carried on ack
segments or TCP resets.  In the latter case, its needed to parse mptcp
options also for reset packets so that MPTCP can act accordingly.

Next patch will add receive side fastclose support in MPTCP.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h        |  2 +-
 net/ipv4/tcp_input.c     | 13 ++++++++-----
 net/ipv4/tcp_minisocks.c |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a62fb7f8a1e3..b1a05f8b35f0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -611,7 +611,7 @@ void tcp_skb_collapse_tstamp(struct sk_buff *skb,
 /* tcp_input.c */
 void tcp_rearm_rto(struct sock *sk);
 void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
-void tcp_reset(struct sock *sk);
+void tcp_reset(struct sock *sk, struct sk_buff *skb);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9e8a6c1aa019..8b6d6ab5f28f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4217,10 +4217,13 @@ static inline bool tcp_sequence(const struct tcp_sock *tp, u32 seq, u32 end_seq)
 }
 
 /* When we get a reset we do this. */
-void tcp_reset(struct sock *sk)
+void tcp_reset(struct sock *sk, struct sk_buff *skb)
 {
 	trace_tcp_receive_reset(sk);
 
+	if (sk_is_mptcp(sk))
+		mptcp_incoming_options(sk, skb);
+
 	/* We want the right error as BSD sees it (and indeed as we do). */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
@@ -5603,7 +5606,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
 		} else if (tcp_reset_check(sk, skb)) {
-			tcp_reset(sk);
+			tcp_reset(sk, skb);
 		}
 		goto discard;
 	}
@@ -5639,7 +5642,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		}
 
 		if (rst_seq_match)
-			tcp_reset(sk);
+			tcp_reset(sk, skb);
 		else {
 			/* Disable TFO if RST is out-of-order
 			 * and no data has been received
@@ -6076,7 +6079,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 
 		if (th->rst) {
-			tcp_reset(sk);
+			tcp_reset(sk, skb);
 			goto discard;
 		}
 
@@ -6518,7 +6521,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
 			    after(TCP_SKB_CB(skb)->end_seq - th->fin, tp->rcv_nxt)) {
 				NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONDATA);
-				tcp_reset(sk);
+				tcp_reset(sk, skb);
 				return 1;
 			}
 		}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 495dda2449fe..0055ae0a3bf8 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -801,7 +801,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		req->rsk_ops->send_reset(sk, skb);
 	} else if (fastopen) { /* received a valid RST pkt */
 		reqsk_fastopen_remove(sk, req, true);
-		tcp_reset(sk);
+		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
 		inet_csk_reqsk_queue_drop(sk, req);
-- 
2.29.2

