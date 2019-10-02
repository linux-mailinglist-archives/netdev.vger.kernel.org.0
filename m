Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D60C950E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfJBXih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbfJBXhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862594"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 11/45] tcp, ulp: Add clone operation to tcp_ulp_ops
Date:   Wed,  2 Oct 2019 16:36:21 -0700
Message-Id: <20191002233655.24323-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
copied when the listener is cloned. Sometimes the clone is immediately
deleted, which will invoke the release op on the clone and likely
corrupt the listening socket's icsk_ulp_data.

The clone operation is invoked immediately after the clone is copied and
gives the ULP type an opportunity to set up the clone socket and its
icsk_ulp_data.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h               |  5 +++++
 net/ipv4/inet_connection_sock.c |  2 ++
 net/ipv4/tcp_ulp.c              | 12 ++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 509b5539d3d1..907fd214ff1e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2129,6 +2129,9 @@ struct tcp_ulp_ops {
 	/* diagnostic */
 	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
 	size_t (*get_info_size)(const struct sock *sk);
+	/* clone ulp */
+	void (*clone)(const struct request_sock *req, struct sock *newsk,
+		      const gfp_t priority);
 
 	char		name[TCP_ULP_NAME_MAX];
 	struct module	*owner;
@@ -2139,6 +2142,8 @@ int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
 void tcp_update_ulp(struct sock *sk, struct proto *p);
+void tcp_clone_ulp(const struct request_sock *req,
+		   struct sock *newsk, const gfp_t priority);
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a9183543ca30..64857672e0b5 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -810,6 +810,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
 
+		tcp_clone_ulp(req, newsk, priority);
+
 		security_inet_csk_clone(newsk, req);
 	}
 	return newsk;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 4849edb62d52..27f949846450 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -127,6 +127,18 @@ void tcp_cleanup_ulp(struct sock *sk)
 	icsk->icsk_ulp_ops = NULL;
 }
 
+void tcp_clone_ulp(const struct request_sock *req, struct sock *newsk,
+		   const gfp_t priority)
+{
+	struct inet_connection_sock *icsk = inet_csk(newsk);
+
+	if (!icsk->icsk_ulp_ops)
+		return;
+
+	if (icsk->icsk_ulp_ops->clone)
+		icsk->icsk_ulp_ops->clone(req, newsk, priority);
+}
+
 static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-- 
2.23.0

