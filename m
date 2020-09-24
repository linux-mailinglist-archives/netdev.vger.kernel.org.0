Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F02277C4B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIXXXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXXXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 19:23:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17724C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 16:23:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kLaZx-0001E5-5J; Fri, 25 Sep 2020 01:23:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] net: tcp: drop unused function argument from mptcp_incoming_options
Date:   Fri, 25 Sep 2020 01:23:02 +0200
Message-Id: <20200924232302.22939-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit cfde141ea3faa30e ("mptcp: move option parsing into
mptcp_incoming_options()"), the 3rd function argument is no longer used.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/mptcp.h  | 6 ++----
 net/ipv4/tcp_input.c | 4 ++--
 net/mptcp/options.c  | 3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 3525d2822abe..753ba7e755d6 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -85,8 +85,7 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts);
-void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
-			    struct tcp_options_received *opt_rx);
+void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb);
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
@@ -185,8 +184,7 @@ static inline bool mptcp_established_options(struct sock *sk,
 }
 
 static inline void mptcp_incoming_options(struct sock *sk,
-					  struct sk_buff *skb,
-					  struct tcp_options_received *opt_rx)
+					  struct sk_buff *skb)
 {
 }
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 02d0e2fb77c0..748980862a09 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4908,7 +4908,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	int eaten;
 
 	if (sk_is_mptcp(sk))
-		mptcp_incoming_options(sk, skb, &tp->rx_opt);
+		mptcp_incoming_options(sk, skb);
 
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		__kfree_skb(skb);
@@ -6489,7 +6489,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_LAST_ACK:
 		if (!before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
 			if (sk_is_mptcp(sk))
-				mptcp_incoming_options(sk, skb, &tp->rx_opt);
+				mptcp_incoming_options(sk, skb);
 			break;
 		}
 		fallthrough;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7fa822b55c34..a64102b17f52 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -824,8 +824,7 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 	return hmac == mp_opt->ahmac;
 }
 
-void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
-			    struct tcp_options_received *opt_rx)
+void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-- 
2.26.2

