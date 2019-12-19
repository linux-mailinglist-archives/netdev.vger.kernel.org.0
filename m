Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E958E12705C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLSWGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:06:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:44252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfLSWGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:06:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 14:06:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="298841752"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by orsmga001.jf.intel.com with ESMTP; 19 Dec 2019 14:06:30 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Subject: [PATCH net-next v4 08/11] tcp: Export TCP functions and ops struct
Date:   Thu, 19 Dec 2019 14:05:54 -0800
Message-Id: <20191219220557.17823-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219220557.17823-1-mathew.j.martineau@linux.intel.com>
References: <20191219220557.17823-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP will make use of tcp_send_mss() and tcp_push() when sending
data to specific TCP subflows.

tcp_request_sock_ipvX_ops and ipvX_specific will be referenced
during TCP subflow creation.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h   | 8 ++++++++
 net/ipv4/tcp.c      | 6 +++---
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv6/tcp_ipv6.c | 6 +++---
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f4cddd42d52a..0a3533c019c6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -330,6 +330,9 @@ int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags);
+int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
+void tcp_push(struct sock *sk, int flags, int mss_now, int nonagle,
+	      int size_goal);
 void tcp_release_cb(struct sock *sk);
 void tcp_wfree(struct sk_buff *skb);
 void tcp_write_timer_handler(struct sock *sk);
@@ -2002,6 +2005,11 @@ struct tcp_request_sock_ops {
 			   enum tcp_synack_type synack_type);
 };
 
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
+#if IS_ENABLED(CONFIG_IPV6)
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops;
+#endif
+
 #ifdef CONFIG_SYN_COOKIES
 static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
 					 const struct sock *sk, struct sk_buff *skb,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 93fe77c5b02d..dc9bd27f4222 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -690,8 +690,8 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
 
-static void tcp_push(struct sock *sk, int flags, int mss_now,
-		     int nonagle, int size_goal)
+void tcp_push(struct sock *sk, int flags, int mss_now,
+	      int nonagle, int size_goal)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
@@ -925,7 +925,7 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
 	return max(size_goal, mss_now);
 }
 
-static int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
+int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
 {
 	int mss_now;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 26637fce324d..c3b91789de65 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1372,7 +1372,7 @@ struct request_sock_ops tcp_request_sock_ops __read_mostly = {
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.mss_clamp	=	TCP_MSS_DEFAULT,
 #ifdef CONFIG_TCP_MD5SIG
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index df5fd9109696..30dceac8a608 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -75,7 +75,7 @@ static void	tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 static int	tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
 
 static const struct inet_connection_sock_af_ops ipv6_mapped;
-static const struct inet_connection_sock_af_ops ipv6_specific;
+const struct inet_connection_sock_af_ops ipv6_specific;
 #ifdef CONFIG_TCP_MD5SIG
 static const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
 static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
@@ -785,7 +785,7 @@ struct request_sock_ops tcp6_request_sock_ops __read_mostly = {
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.mss_clamp	=	IPV6_MIN_MTU - sizeof(struct tcphdr) -
 				sizeof(struct ipv6hdr),
 #ifdef CONFIG_TCP_MD5SIG
@@ -1739,7 +1739,7 @@ static struct timewait_sock_ops tcp6_timewait_sock_ops = {
 	.twsk_destructor = tcp_twsk_destructor,
 };
 
-static const struct inet_connection_sock_af_ops ipv6_specific = {
+const struct inet_connection_sock_af_ops ipv6_specific = {
 	.queue_xmit	   = inet6_csk_xmit,
 	.send_check	   = tcp_v6_send_check,
 	.rebuild_header	   = inet6_sk_rebuild_header,
-- 
2.24.1

