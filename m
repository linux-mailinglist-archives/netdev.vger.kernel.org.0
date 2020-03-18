Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139C9189DB3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgCROTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:19:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59594 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbgCROTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 10:19:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jEZXd-0005OL-KB; Wed, 18 Mar 2020 15:19:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC mptcp-next] tcp: mptcp: use mptcp receive buffer space to select rcv window
Date:   Wed, 18 Mar 2020 15:19:17 +0100
Message-Id: <20200318141917.2612-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In MPTCP, the receive windo is shared across all subflows, because it
refers to the mptcp-level sequence space.

This commit doesn't change choice of initial window for passive or active
connections.
While it would be possible to change those as well, this adds complexity
(especially when handling MP_JOIN requests).

However, the MPTCP RFC specifically says that a MPTCP sender
'MUST NOT use the RCV.WND field of a TCP segment at the connection level if
it does not also carry a DSS option with a Data ACK field.'

SYN/SYNACK packets do not carry a DSS option with a Data ACK field.

CC: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This patch would add additional direct call in __tcp_select_window().

 I looked at mptcp option writing to check if it could be done there but
 that seemed worse.

 include/net/mptcp.h   |  3 +++
 net/ipv4/tcp_output.c |  5 +++++
 net/mptcp/subflow.c   | 17 +++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 7489f9267640..1ef4520f45c3 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -66,6 +66,8 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return tcp_rsk(req)->is_mptcp;
 }
 
+void mptcp_space(const struct sock *ssk, int *space, int *full_space);
+
 void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
 			int opsize, struct tcp_options_received *opt_rx);
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
@@ -195,6 +197,7 @@ static inline bool mptcp_sk_is_subflow(const struct sock *sk)
 	return false;
 }
 
+static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
 static inline void mptcp_seq_show(struct seq_file *seq) { }
 #endif /* CONFIG_MPTCP */
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 306e25d743e8..1a829536a115 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2771,6 +2771,11 @@ u32 __tcp_select_window(struct sock *sk)
 	int full_space = min_t(int, tp->window_clamp, allowed_space);
 	int window;
 
+	if (sk_is_mptcp(sk)) {
+		mptcp_space(sk, &free_space, &allowed_space);
+		full_space = min_t(int, tp->window_clamp, allowed_space);
+	}
+
 	if (unlikely(mss > full_space)) {
 		mss = full_space;
 		if (mss <= 0)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 40ad7995b13b..aefcbb8bb737 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -745,6 +745,23 @@ bool mptcp_subflow_data_available(struct sock *sk)
 	return subflow->data_avail;
 }
 
+/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
+ * not the ssk one.
+ *
+ * In mptcp, rwin is about the mptcp-level connection data.
+ *
+ * Data that is still on the ssk rx queue can thus be ignored,
+ * as far as mptcp peer is concerened that data is still inflight.
+ */
+void mptcp_space(const struct sock *ssk, int *space, int *full_space)
+{
+	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	const struct sock *sk = READ_ONCE(subflow->conn);
+
+	*space = tcp_space(sk);
+	*full_space = tcp_full_space(sk);
+}
+
 static void subflow_data_ready(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-- 
2.24.1

