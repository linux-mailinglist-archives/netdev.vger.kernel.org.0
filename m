Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73B843BDDF
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbhJZXbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:31:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:24059 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240283AbhJZXbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:31:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316242949"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316242949"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="597124828"
Received: from jdweinst-mobl2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.54.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 16:29:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/4] net: introduce sk_forward_alloc_get()
Date:   Tue, 26 Oct 2021 16:29:14 -0700
Message-Id: <20211026232916.179450-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
References: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

A later patch will change the MPTCP memory accounting schema
in such a way that MPTCP sockets will encode the total amount of
forward allocated memory in two separate fields (one for tx and
one for rx).

MPTCP sockets will use their own helper to provide the accurate
amount of fwd allocated memory.

To allow the above, this patch adds a new, optional, sk method to
fetch the fwd memory, wrap the call in a new helper and use it
where it is appropriate.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/sock.h   | 11 +++++++++++
 net/ipv4/af_inet.c   |  2 +-
 net/ipv4/inet_diag.c |  2 +-
 net/sched/em_meta.c  |  2 +-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index df0e0efb1882..4f0280ad6c23 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1210,6 +1210,8 @@ struct proto {
 	unsigned int		inuse_idx;
 #endif
 
+	int			(*forward_alloc_get)(const struct sock *sk);
+
 	bool			(*stream_memory_free)(const struct sock *sk, int wake);
 	bool			(*stream_memory_read)(const struct sock *sk);
 	/* Memory pressure */
@@ -1217,6 +1219,7 @@ struct proto {
 	void			(*leave_memory_pressure)(struct sock *sk);
 	atomic_long_t		*memory_allocated;	/* Current allocated memory. */
 	struct percpu_counter	*sockets_allocated;	/* Current number of sockets. */
+
 	/*
 	 * Pressure flag: try to collapse.
 	 * Technical note: it is used by multiple contexts non atomically.
@@ -1294,6 +1297,14 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 
 INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
 
+static inline int sk_forward_alloc_get(const struct sock *sk)
+{
+	if (!sk->sk_prot->forward_alloc_get)
+		return sk->sk_forward_alloc;
+
+	return sk->sk_prot->forward_alloc_get(sk);
+}
+
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
 	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8eb428387bac..c517d5c227f7 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -150,7 +150,7 @@ void inet_sock_destruct(struct sock *sk)
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
 	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
+	WARN_ON(sk_forward_alloc_get(sk));
 
 	kfree(rcu_dereference_protected(inet->inet_opt, 1));
 	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index ef7897226f08..c8fa6e7f7d12 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -271,7 +271,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		struct inet_diag_meminfo minfo = {
 			.idiag_rmem = sk_rmem_alloc_get(sk),
 			.idiag_wmem = READ_ONCE(sk->sk_wmem_queued),
-			.idiag_fmem = sk->sk_forward_alloc,
+			.idiag_fmem = sk_forward_alloc_get(sk),
 			.idiag_tmem = sk_wmem_alloc_get(sk),
 		};
 
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 46254968d390..0a04468b7314 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -457,7 +457,7 @@ META_COLLECTOR(int_sk_fwd_alloc)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_forward_alloc;
+	dst->value = sk_forward_alloc_get(sk);
 }
 
 META_COLLECTOR(int_sk_sndbuf)
-- 
2.33.1

