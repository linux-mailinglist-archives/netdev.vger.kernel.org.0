Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF27C495A4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfFQW7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbfFQW6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 09/33] tcp, ulp: Add clone operation to tcp_ulp_ops
Date:   Mon, 17 Jun 2019 15:57:44 -0700
Message-Id: <20190617225808.665-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
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
index cdbc2a6d9d9a..23995f8c11fa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2108,6 +2108,9 @@ struct tcp_ulp_ops {
 	int (*init)(struct sock *sk);
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
+	/* clone ulp */
+	void (*clone)(const struct request_sock *req, struct sock *newsk,
+		      const gfp_t priority);
 
 	char		name[TCP_ULP_NAME_MAX];
 	struct module	*owner;
@@ -2117,6 +2120,8 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
 int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
+void tcp_clone_ulp(const struct request_sock *req,
+		   struct sock *newsk, const gfp_t priority);
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fb0b4b0994ec..386df6f227d8 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -814,6 +814,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
 
+		tcp_clone_ulp(req, newsk, priority);
+
 		security_inet_csk_clone(newsk, req);
 	}
 	return newsk;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 3d8a1d835471..d6e8ba0035e8 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -114,6 +114,18 @@ void tcp_cleanup_ulp(struct sock *sk)
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
2.22.0

