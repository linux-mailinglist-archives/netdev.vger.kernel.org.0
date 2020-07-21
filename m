Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D4228A09
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgGUUh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:37:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33376C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:37:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jxz0t-0003w8-QW; Tue, 21 Jul 2020 22:37:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     mathew.j.martineau@linux.intel.com, edumazet@google.com,
        mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Florian Westphal <fw@strlen.de>
Subject: [RFC v2 mptcp-next 06/12] tcp: remove sk_listener const qualifier from req_init function
Date:   Tue, 21 Jul 2020 22:36:36 +0200
Message-Id: <20200721203642.32753-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721203642.32753-1-fw@strlen.de>
References: <20200721203642.32753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In MPTCP case, we may want to add the request sock to the listner
backlog even when syncookies are in use in order to handle MPTCP
JOIN requests.

This will push the request queue past its limit, but is subject to other
checks:

1. The (32bit) token resolves to a established MPTCP connection.
2. The MPTCP connection can still accept another subflow.

Without this, the mptcp req_init function needs to use a cast such as
 foo((void *)sk_listener);

to suppress a compiler warning.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This isn't nice given this is only for MPTCP syncookies.

 Possible alternatives are:

  1. Give up on JOIN support in cookie mode and toss this patch.
  2. live with a cast and toss this patch.
  3. Allow ->init_req() to cancel syncookie mode and do the
     add of rsk to sk_listener in the caller/tcp stack.
  4. Do not store the request socket but some more minimal state
     (peers nonce, connid, our nonce, ...)
  I'd rather avoid that since it won't resolve the fundamental issue
  of storing information, also needs to reinvent several things e.g.
  timeouts and so on.

 include/net/tcp.h   | 2 +-
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv6/tcp_ipv6.c | 2 +-
 net/mptcp/subflow.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9f7f7c0c1104..74c0b37584ef 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2018,7 +2018,7 @@ struct tcp_request_sock_ops {
 					  const struct sk_buff *skb);
 #endif
 	void (*init_req)(struct request_sock *req,
-			 const struct sock *sk_listener,
+			 struct sock *sk_listener,
 			 struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index cd81b6e04efb..f0b01d09d5ad 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1420,7 +1420,7 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 }
 
 static void tcp_v4_init_req(struct request_sock *req,
-			    const struct sock *sk_listener,
+			    struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c34b7834fd84..1c7bf70660e8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -792,7 +792,7 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 }
 
 static void tcp_v6_init_req(struct request_sock *req,
-			    const struct sock *sk_listener,
+			    struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
 	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6b1d88332a2d..55a19f8ed8ec 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -175,7 +175,7 @@ static void subflow_init_req(struct request_sock *req,
 }
 
 static void subflow_v4_init_req(struct request_sock *req,
-				const struct sock *sk_listener,
+				struct sock *sk_listener,
 				struct sk_buff *skb)
 {
 	tcp_rsk(req)->is_mptcp = 1;
@@ -187,7 +187,7 @@ static void subflow_v4_init_req(struct request_sock *req,
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static void subflow_v6_init_req(struct request_sock *req,
-				const struct sock *sk_listener,
+				struct sock *sk_listener,
 				struct sk_buff *skb)
 {
 	tcp_rsk(req)->is_mptcp = 1;
-- 
2.26.2

