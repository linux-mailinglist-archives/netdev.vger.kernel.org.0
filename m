Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C62D11F6
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgLGN1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:27:50 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:54862 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgLGN1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347668; x=1638883668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8XO3oMJuYMRpRokryS+5ntczUSPA08sfPz93Ikz0YFA=;
  b=Eg8fFMZGZpF8L4Ew3FHMEfzwuz+BjVFz5O7J4myJiQonD2cM+qMxrhen
   lep+rUc/4jlTOi1ZkrxCg2oCTkbSUhxSkNEVe38ki3vvzlCjGcGtKjGDL
   hzTkd2M+fBSyNoobrFXHPKvHDiWh52ZtaQ+nR2dADJMjGDykTp3bMpqiS
   c=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="901121995"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 13:27:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 5ACA1A188D;
        Mon,  7 Dec 2020 13:27:04 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:27:03 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:58 +0000
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
Subject: [PATCH v2 bpf-next 06/13] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Mon, 7 Dec 2020 22:24:49 +0900
Message-ID: <20201207132456.65472-7-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207132456.65472-1-kuniyu@amazon.co.jp>
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch lets reuseport_detach_sock() return a pointer of struct sock,
which is used only by inet_unhash(). If it is not NULL,
inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
sockets from the closing listener to the selected one.

By default, the kernel selects a new listener randomly. In order to pick
out a different socket every time, we select the last element of socks[] as
the new listener. This behaviour is based on how the kernel moves sockets
in socks[]. (See also [1])

Basically, in order to redistribute sockets evenly, we have to use an eBPF
program called in the later commit, but as the side effect of such default
selection, the kernel can redistribute old requests evenly to new listeners
for a specific case where the application replaces listeners by
generations.

For example, we call listen() for four sockets (A, B, C, D), and close()
the first two by turns. The sockets move in socks[] like below.

  socks[0] : A <-.      socks[0] : D          socks[0] : D
  socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
  socks[2] : C   |      socks[2] : C --'
  socks[3] : D --'

Then, if C and D have newer settings than A and B, and each socket has a
request (a, b, c, d) in their accept queue, we can redistribute old
requests evenly to new listeners.

  socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
  socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
  socks[2] : C (c)   |      socks[2] : C (c) --'
  socks[3] : D (d) --'

Here, (A, D), or (B, C) can have different application settings, but they
MUST have the same settings at the socket API level; otherwise, unexpected
error may happen. For instance, if only the new listeners have
TCP_SAVE_SYN, old requests do not hold SYN data, so the application will
face inconsistency and cause an error.

Therefore, if there are different kinds of sockets, we must attach an eBPF
program described in later commits.

Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/sock_reuseport.h |  2 +-
 net/core/sock_reuseport.c    | 16 +++++++++++++---
 net/ipv4/inet_hashtables.c   |  9 +++++++--
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 0e558ca7afbf..09a1b1539d4c 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -31,7 +31,7 @@ struct sock_reuseport {
 extern int reuseport_alloc(struct sock *sk, bool bind_inany);
 extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
 			      bool bind_inany);
-extern void reuseport_detach_sock(struct sock *sk);
+extern struct sock *reuseport_detach_sock(struct sock *sk);
 extern struct sock *reuseport_select_sock(struct sock *sk,
 					  u32 hash,
 					  struct sk_buff *skb,
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index c26f4256ff41..2de42f8103ea 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -184,9 +184,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 }
 EXPORT_SYMBOL(reuseport_add_sock);
 
-void reuseport_detach_sock(struct sock *sk)
+struct sock *reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
+	struct bpf_prog *prog;
+	struct sock *nsk = NULL;
 	int i;
 
 	spin_lock_bh(&reuseport_lock);
@@ -215,17 +217,25 @@ void reuseport_detach_sock(struct sock *sk)
 
 		reuse->num_socks--;
 		reuse->socks[i] = reuse->socks[reuse->num_socks];
+		prog = rcu_dereference_protected(reuse->prog,
+						 lockdep_is_held(&reuseport_lock));
+
+		if (sk->sk_protocol == IPPROTO_TCP) {
+			if (reuse->num_socks && !prog)
+				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
 
-		if (sk->sk_protocol == IPPROTO_TCP)
 			reuse->num_closed_socks++;
-		else
+		} else {
 			rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
+		}
 	}
 
 	if (reuse->num_socks + reuse->num_closed_socks == 0)
 		call_rcu(&reuse->rcu, reuseport_free_rcu);
 
 	spin_unlock_bh(&reuseport_lock);
+
+	return nsk;
 }
 EXPORT_SYMBOL(reuseport_detach_sock);
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 45fb450b4522..545538a6bfac 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -681,6 +681,7 @@ void inet_unhash(struct sock *sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct inet_listen_hashbucket *ilb = NULL;
+	struct sock *nsk;
 	spinlock_t *lock;
 
 	if (sk_unhashed(sk))
@@ -696,8 +697,12 @@ void inet_unhash(struct sock *sk)
 	if (sk_unhashed(sk))
 		goto unlock;
 
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
+	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+		nsk = reuseport_detach_sock(sk);
+		if (nsk)
+			inet_csk_reqsk_queue_migrate(sk, nsk);
+	}
+
 	if (ilb) {
 		inet_unhash2(hashinfo, sk);
 		ilb->count--;
-- 
2.17.2 (Apple Git-113)

