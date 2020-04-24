Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68B51B7206
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgDXKcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgDXKcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 06:32:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EED8C09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:32:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jRvcq-0001wu-4o; Fri, 24 Apr 2020 12:32:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] tcp: mptcp: use mptcp receive buffer space to select rcv window
Date:   Fri, 24 Apr 2020 12:31:50 +0200
Message-Id: <20200424103150.334-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In MPTCP, the receive window is shared across all subflows, because it
refers to the mptcp-level sequence space.

MPTCP receivers already place incoming packets on the mptcp socket
receive queue and will charge it to the mptcp socket rcvbuf until
userspace consumes the data.

Update __tcp_select_window to use the occupancy of the parent/mptcp
socket instead of the subflow socket in case the tcp socket is part
of a logical mptcp connection.

This commit doesn't change choice of initial window for passive or active
connections.
While it would be possible to change those as well, this adds complexity
(especially when handling MP_JOIN requests).  Furthermore, the MPTCP RFC
specifically says that a MPTCP sender 'MUST NOT use the RCV.WND field
of a TCP segment at the connection level if it does not also carry a DSS
option with a Data ACK field.'

SYN/SYNACK packets do not carry a DSS option with a Data ACK field.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/mptcp.h   |  3 +++
 net/ipv4/tcp_output.c |  8 ++++++--
 net/mptcp/subflow.c   | 18 ++++++++++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0e7c5471010b..5288fba56e55 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -68,6 +68,8 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
 	return tcp_rsk(req)->is_mptcp;
 }
 
+void mptcp_space(const struct sock *ssk, int *space, int *full_space);
+
 void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
 			int opsize, struct tcp_options_received *opt_rx);
 bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
@@ -197,6 +199,7 @@ static inline bool mptcp_sk_is_subflow(const struct sock *sk)
 	return false;
 }
 
+static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
 static inline void mptcp_seq_show(struct seq_file *seq) { }
 #endif /* CONFIG_MPTCP */
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2f45cde168c4..ba4482130f08 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2772,8 +2772,12 @@ u32 __tcp_select_window(struct sock *sk)
 	int mss = icsk->icsk_ack.rcv_mss;
 	int free_space = tcp_space(sk);
 	int allowed_space = tcp_full_space(sk);
-	int full_space = min_t(int, tp->window_clamp, allowed_space);
-	int window;
+	int full_space, window;
+
+	if (sk_is_mptcp(sk))
+		mptcp_space(sk, &free_space, &allowed_space);
+
+	full_space = min_t(int, tp->window_clamp, allowed_space);
 
 	if (unlikely(mss > full_space)) {
 		mss = full_space;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 50a8bea987c6..47f901b712f9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -764,6 +764,24 @@ bool mptcp_subflow_data_available(struct sock *sk)
 	return subflow->data_avail;
 }
 
+/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
+ * not the ssk one.
+ *
+ * In mptcp, rwin is about the mptcp-level connection data.
+ *
+ * Data that is still on the ssk rx queue can thus be ignored,
+ * as far as mptcp peer is concerened that data is still inflight.
+ * DSS ACK is updated when skb is moved to the mptcp rx queue.
+ */
+void mptcp_space(const struct sock *ssk, int *space, int *full_space)
+{
+	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	const struct sock *sk = subflow->conn;
+
+	*space = tcp_space(sk);
+	*full_space = tcp_full_space(sk);
+}
+
 static void subflow_data_ready(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-- 
2.26.2

