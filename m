Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33B32338F4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgG3T0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAA2C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1EC5-0003WJ-E1; Thu, 30 Jul 2020 21:26:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 4/9] mptcp: rename and export mptcp_subflow_request_sock_ops
Date:   Thu, 30 Jul 2020 21:25:53 +0200
Message-Id: <20200730192558.25697-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syncookie code path needs to create an mptcp request sock.

Prepare for this and add mptcp prefix plus needed export of ops struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/mptcp.h |  1 +
 net/mptcp/subflow.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 02158c257bd4..76eb915bf91c 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -58,6 +58,7 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
+extern struct request_sock_ops mptcp_subflow_request_sock_ops;
 
 void mptcp_init(void);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 091e305a81c8..9b11d2b6ff4d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -284,7 +284,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	tcp_done(sk);
 }
 
-static struct request_sock_ops subflow_request_sock_ops;
+struct request_sock_ops mptcp_subflow_request_sock_ops;
+EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -297,7 +298,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -322,7 +323,7 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
-	return tcp_conn_request(&subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
@@ -1311,8 +1312,8 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 
 void __init mptcp_subflow_init(void)
 {
-	subflow_request_sock_ops = tcp_request_sock_ops;
-	if (subflow_ops_init(&subflow_request_sock_ops) != 0)
+	mptcp_subflow_request_sock_ops = tcp_request_sock_ops;
+	if (subflow_ops_init(&mptcp_subflow_request_sock_ops) != 0)
 		panic("MPTCP: failed to init subflow request sock ops\n");
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
-- 
2.26.2

