Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0F7C94E7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfJBXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfJBXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862587"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 08/45] tcp: Expose tcp struct and routine for MPTCP
Date:   Wed,  2 Oct 2019 16:36:18 -0700
Message-Id: <20191002233655.24323-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

tcp_request_sock_ipv4_ops and tcp_v4_init_sock().

This function is needed for MPTCP subflow initialization.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/net/tcp.h   | 3 +++
 net/ipv4/tcp_ipv4.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 382e245a7909..509b5539d3d1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -445,6 +445,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb);
 int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int tcp_connect(struct sock *sk);
+int tcp_v4_init_sock(struct sock *sk);
 enum tcp_synack_type {
 	TCP_SYNACK_NORMAL,
 	TCP_SYNACK_FASTOPEN,
@@ -1975,6 +1976,8 @@ struct tcp_request_sock_ops {
 			   enum tcp_synack_type synack_type);
 };
 
+extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
+
 #ifdef CONFIG_SYN_COOKIES
 static inline __u32 cookie_init_sequence(const struct tcp_request_sock_ops *ops,
 					 const struct sock *sk, struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2ee45e3755e9..e3f86dd2d2ec 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1371,7 +1371,7 @@ struct request_sock_ops tcp_request_sock_ops __read_mostly = {
 	.syn_ack_timeout =	tcp_syn_ack_timeout,
 };
 
-static const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
+const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.mss_clamp	=	TCP_MSS_DEFAULT,
 #ifdef CONFIG_TCP_MD5SIG
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
@@ -2072,7 +2072,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 /* NOTE: A lot of things set to zero explicitly by call to
  *       sk_alloc() so need not be done here.
  */
-static int tcp_v4_init_sock(struct sock *sk)
+int tcp_v4_init_sock(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-- 
2.23.0

