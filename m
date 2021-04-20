Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2DC365C6F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhDTPo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:44:57 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:60957 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbhDTPot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1618933459; x=1650469459;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ace2/yQjy3YabkwxzWoQwnwDO/gFnCB+2fW1JZYyE8g=;
  b=cGnLnR4L8dqWvagb9N22orgYCCSV37L6bMRPMM6u935cxtVVC3HWTV7P
   XpoNOAcJC1o0o6YeZdg4x1NwWN8qIsvsiW7WPpifNzEDksXnzk1bnD0ye
   p8q1vAUyq1Ex7lF366reHpZ3R8qak80mQhRRky5/JH4w586WB99t69JcZ
   M=;
X-IronPort-AV: E=Sophos;i="5.82,237,1613433600"; 
   d="scan'208";a="108636730"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 20 Apr 2021 15:44:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 78D53A1C2A;
        Tue, 20 Apr 2021 15:44:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:44:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:44:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 bpf-next 05/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Wed, 21 Apr 2021 00:41:34 +0900
Message-ID: <20210420154140.80034-6-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420154140.80034-1-kuniyu@amazon.co.jp>
References: <20210420154140.80034-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.41]
X-ClientProxiedBy: EX13P01UWB001.ant.amazon.com (10.43.161.59) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we call close() or shutdown() for listening sockets, each child socket
in the accept queue are freed at inet_csk_listen_stop(). If we can get a
new listener by reuseport_migrate_sock() and clone the request by
reqsk_clone(), we try to add it into the new listener's accept queue by
inet_csk_reqsk_queue_add(). If it fails, we have to call __reqsk_free() to
call sock_put() for its listener and free the cloned request.

After putting the full socket into ehash, tcp_v[46]_syn_recv_sock() sets
NULL to ireq_opt/pktopts in struct inet_request_sock, but ipv6_opt can be
non-NULL. So, we have to set NULL to ipv6_opt of the old request to avoid
double free.

Note that we do not update req->rsk_listener and instead clone the req to
migrate because another path may reference the original request. If we
protected it by RCU, we would need to add rcu_read_lock() in many places.

Link: https://lore.kernel.org/netdev/20201209030903.hhow5r53l6fmozjn@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/request_sock.h      |  2 ++
 net/core/request_sock.c         | 37 +++++++++++++++++++++++++++++++++
 net/ipv4/inet_connection_sock.c | 31 ++++++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 29e41ff3ec93..c6d6cfd3c93b 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -190,6 +190,8 @@ void reqsk_queue_alloc(struct request_sock_queue *queue);
 void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
 			   bool reset);
 
+struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk);
+
 static inline bool reqsk_queue_empty(const struct request_sock_queue *queue)
 {
 	return READ_ONCE(queue->rskq_accept_head) == NULL;
diff --git a/net/core/request_sock.c b/net/core/request_sock.c
index f35c2e998406..82cf9fbe2668 100644
--- a/net/core/request_sock.c
+++ b/net/core/request_sock.c
@@ -130,3 +130,40 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
 out:
 	spin_unlock_bh(&fastopenq->lock);
 }
+
+struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk)
+{
+	struct sock *req_sk, *nreq_sk;
+	struct request_sock *nreq;
+
+	nreq = kmem_cache_alloc(req->rsk_ops->slab, GFP_ATOMIC | __GFP_NOWARN);
+	if (!nreq) {
+		/* paired with refcount_inc_not_zero() in reuseport_migrate_sock() */
+		sock_put(sk);
+		return NULL;
+	}
+
+	req_sk = req_to_sk(req);
+	nreq_sk = req_to_sk(nreq);
+
+	memcpy(nreq_sk, req_sk,
+	       offsetof(struct sock, sk_dontcopy_begin));
+	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
+	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
+
+	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
+#ifdef CONFIG_XPS
+	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
+#endif
+	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
+
+	nreq->rsk_listener = sk;
+
+	/* We need not acquire fastopenq->lock
+	 * because the child socket is locked in inet_csk_listen_stop().
+	 */
+	if (tcp_rsk(nreq)->tfo_listener)
+		rcu_assign_pointer(tcp_sk(nreq->sk)->fastopen_rsk, nreq);
+
+	return nreq;
+}
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fa806e9167ec..851992405826 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -695,6 +695,13 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
 }
 EXPORT_SYMBOL(inet_rtx_syn_ack);
 
+static void reqsk_migrate_reset(struct request_sock *req)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	inet_rsk(req)->ipv6_opt = NULL;
+#endif
+}
+
 /* return true if req was found in the ehash table */
 static bool reqsk_queue_unlink(struct request_sock *req)
 {
@@ -1036,14 +1043,36 @@ void inet_csk_listen_stop(struct sock *sk)
 	 * of the variants now.			--ANK
 	 */
 	while ((req = reqsk_queue_remove(queue, sk)) != NULL) {
-		struct sock *child = req->sk;
+		struct sock *child = req->sk, *nsk;
+		struct request_sock *nreq;
 
 		local_bh_disable();
 		bh_lock_sock(child);
 		WARN_ON(sock_owned_by_user(child));
 		sock_hold(child);
 
+		nsk = reuseport_migrate_sock(sk, child, NULL);
+		if (nsk) {
+			nreq = reqsk_clone(req, nsk);
+			if (nreq) {
+				refcount_set(&nreq->rsk_refcnt, 1);
+
+				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
+					reqsk_migrate_reset(req);
+				} else {
+					reqsk_migrate_reset(nreq);
+					__reqsk_free(nreq);
+				}
+
+				/* inet_csk_reqsk_queue_add() has already
+				 * called inet_child_forget() on failure case.
+				 */
+				goto skip_child_forget;
+			}
+		}
+
 		inet_child_forget(sk, req, child);
+skip_child_forget:
 		reqsk_put(req);
 		bh_unlock_sock(child);
 		local_bh_enable();
-- 
2.30.2

