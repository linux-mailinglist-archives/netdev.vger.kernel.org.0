Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2217213385D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 02:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgAHBTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 20:19:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:16780 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgAHBTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 20:19:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 17:19:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,408,1571727600"; 
   d="scan'208";a="422760153"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.8.166])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 17:19:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v6 05/11] tcp, ulp: Add clone operation to tcp_ulp_ops
Date:   Tue,  7 Jan 2020 17:19:15 -0800
Message-Id: <20200108011921.28942-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108011921.28942-1-mathew.j.martineau@linux.intel.com>
References: <20200108011921.28942-1-mathew.j.martineau@linux.intel.com>
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

The MPTCP ULP clone will silently fallback to plain TCP on allocation
failure, so 'clone()' does not need to return an error code.

v5 -> v6:
 - clarified MPTCP clone usage in commit message

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/tcp.h               |  5 +++++
 net/ipv4/inet_connection_sock.c |  2 ++
 net/ipv4/tcp_ulp.c              | 12 ++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 85f1d7ff6e8b..82879718d35a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2154,6 +2154,9 @@ struct tcp_ulp_ops {
 	/* diagnostic */
 	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
 	size_t (*get_info_size)(const struct sock *sk);
+	/* clone ulp */
+	void (*clone)(const struct request_sock *req, struct sock *newsk,
+		      const gfp_t priority);
 
 	char		name[TCP_ULP_NAME_MAX];
 	struct module	*owner;
@@ -2164,6 +2167,8 @@ int tcp_set_ulp(struct sock *sk, const char *name);
 void tcp_get_available_ulp(char *buf, size_t len);
 void tcp_cleanup_ulp(struct sock *sk);
 void tcp_update_ulp(struct sock *sk, struct proto *p);
+void tcp_clone_ulp(const struct request_sock *req,
+		   struct sock *newsk, const gfp_t priority);
 
 #define MODULE_ALIAS_TCP_ULP(name)				\
 	__MODULE_INFO(alias, alias_userspace, name);		\
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 18c0d5bffe12..bf53a722923a 100644
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
index 12ab5db2b71c..e7a2589d69ee 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -130,6 +130,18 @@ void tcp_cleanup_ulp(struct sock *sk)
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
2.24.1

