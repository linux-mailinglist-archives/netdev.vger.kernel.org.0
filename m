Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633A6228A07
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgGUUhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC41CC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0s-0003vz-LA; Tue, 21 Jul 2020 22:37:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 05/12] mptcp: rename and export mptcp_subflow_request_sock_ops
Date:   Tue, 21 Jul 2020 22:36:35 +0200
Message-Id: <20200721203642.32753-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
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
index 800e7d472dcd..6b1d88332a2d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -293,7 +293,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	tcp_done(sk);
 }
 
-static struct request_sock_ops subflow_request_sock_ops;
+struct request_sock_ops mptcp_subflow_request_sock_ops;
+EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -306,7 +307,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -331,7 +332,7 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (!ipv6_unicast_destination(skb))
 		goto drop;
 
-	return tcp_conn_request(&subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
@@ -1310,8 +1311,8 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 
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

