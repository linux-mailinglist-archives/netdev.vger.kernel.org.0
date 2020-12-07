Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6282D1209
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLGN3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:29:30 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9822 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLGN3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347768; x=1638883768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jIfxzUB2+17RMJxfEDisRHBPm7+z8TJ3VAqSHs38L00=;
  b=gxDhuIFNojiIvTngYDueMbPZD2ltUr2Q6bZapFbjMHlpFIayvQ+2SRHt
   eZNqucKhE6kjn/rIj5Duecym9bRfxG/yHkR3fOOh8H5NJBtXE5fDuW2fX
   6Br5uxH1unA7FnyOtC4cuvqC9HM+sRQeYqJkrZgjfi0qHnjYGYO/E2xeT
   k=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67966355"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Dec 2020 13:28:47 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id CB581A071C;
        Mon,  7 Dec 2020 13:28:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:43 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:39 +0000
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
Subject: [PATCH v2 bpf-next 12/13] bpf: Call bpf_run_sk_reuseport() for socket migration.
Date:   Mon, 7 Dec 2020 22:24:55 +0900
Message-ID: <20201207132456.65472-13-kuniyu@amazon.co.jp>
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

This patch supports socket migration by eBPF. If the attached type is
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, we can select a new listener by
BPF_FUNC_sk_select_reuseport(). Also, we can cancel migration by returning
SK_DROP. This feature is useful when listeners have different settings at
the socket API level or when we want to free resources as soon as possible.

There are two noteworthy points. The first is that we select a listening
socket in reuseport_detach_sock() and __reuseport_select_sock(), but we do
not have struct skb at closing a listener or retransmitting a SYN+ACK.
However, some helper functions do not expect skb is NULL (e.g.
skb_header_pointer() in BPF_FUNC_skb_load_bytes(), skb_tail_pointer() in
BPF_FUNC_skb_load_bytes_relative()). So we allocate an empty skb
temporarily before running the eBPF program. The second is that we do not
have struct request_sock in unhash path, and the sk_hash of the listener is
always zero. So we pass zero as hash to bpf_run_sk_reuseport().

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/filter.c          | 19 +++++++++++++++++++
 net/core/sock_reuseport.c  | 21 +++++++++++----------
 net/ipv4/inet_hashtables.c |  2 +-
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9f7018e3f545..53fa3bcbf00f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9890,10 +9890,29 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 {
 	struct sk_reuseport_kern reuse_kern;
 	enum sk_action action;
+	bool allocated = false;
+
+	if (migration) {
+		/* cancel migration for possibly incapable eBPF program */
+		if (prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)
+			return ERR_PTR(-ENOTSUPP);
+
+		if (!skb) {
+			allocated = true;
+			skb = alloc_skb(0, GFP_ATOMIC);
+			if (!skb)
+				return ERR_PTR(-ENOMEM);
+		}
+	} else if (!skb) {
+		return NULL; /* fall back to select by hash */
+	}
 
 	bpf_init_reuseport_kern(&reuse_kern, reuse, sk, skb, hash, migration);
 	action = BPF_PROG_RUN(prog, &reuse_kern);
 
+	if (allocated)
+		kfree_skb(skb);
+
 	if (action == SK_PASS)
 		return reuse_kern.selected_sk;
 	else
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b877c8e552d2..2358e8896199 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -221,8 +221,15 @@ struct sock *reuseport_detach_sock(struct sock *sk)
 						 lockdep_is_held(&reuseport_lock));
 
 		if (sk->sk_protocol == IPPROTO_TCP) {
-			if (reuse->num_socks && !prog)
-				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
+			if (reuse->num_socks) {
+				if (prog)
+					nsk = bpf_run_sk_reuseport(reuse, sk, prog, NULL, 0,
+								   BPF_SK_REUSEPORT_MIGRATE_QUEUE);
+
+				if (!nsk)
+					nsk = i == reuse->num_socks ?
+						reuse->socks[i - 1] : reuse->socks[i];
+			}
 
 			reuse->num_closed_socks++;
 		} else {
@@ -306,15 +313,9 @@ static struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
 		if (!prog)
 			goto select_by_hash;
 
-		if (migration)
-			goto out;
-
-		if (!skb)
-			goto select_by_hash;
-
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
 			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash, migration);
-		else
+		else if (!skb)
 			sk2 = run_bpf_filter(reuse, socks, prog, skb, hdr_len);
 
 select_by_hash:
@@ -352,7 +353,7 @@ struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
 	struct sock *nsk;
 
 	nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
-	if (nsk && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
+	if (!IS_ERR_OR_NULL(nsk) && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
 		return nsk;
 
 	return NULL;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 545538a6bfac..59f58740c20d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -699,7 +699,7 @@ void inet_unhash(struct sock *sk)
 
 	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
 		nsk = reuseport_detach_sock(sk);
-		if (nsk)
+		if (!IS_ERR_OR_NULL(nsk))
 			inet_csk_reqsk_queue_migrate(sk, nsk);
 	}
 
-- 
2.17.2 (Apple Git-113)

