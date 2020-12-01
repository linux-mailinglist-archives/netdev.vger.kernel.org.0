Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC862CA647
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404049AbgLAOsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:48:12 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:63105 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404026AbgLAOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834092; x=1638370092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=L3BDjC4r+KlsYF9bVtRPpv4evDg4B9zvwuwACl+vsMQ=;
  b=vWyY2DKGcYFohSyYJaYvhI62sUUUbqHilbziB0cFZT58M2SjHUCRfnQV
   mQxPkBkvYNjxffA9OIpsMakKDjx6wdd6M0gsoQ7uUctsMdoogQW8Sgj+S
   8k+u0CiIBiRaIm3IrerkdZugCeNbP7AnLS55JNxNcMFM4XZFm9VOmAKFS
   c=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="68318988"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 01 Dec 2020 14:47:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id A5B4BA1EBA;
        Tue,  1 Dec 2020 14:47:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:27 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:23 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 10/11] bpf: Call bpf_run_sk_reuseport() for socket migration.
Date:   Tue, 1 Dec 2020 23:44:17 +0900
Message-ID: <20201201144418.35045-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201201144418.35045-1-kuniyu@amazon.co.jp>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
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
BPF_FUNC_skb_load_bytes_relative()). So, we allocate an empty skb
temporarily before running the eBPF program. The second is that we do not
have struct request_sock in unhash path, and the sk_hash of the listener is
always zero. Thus, we pass zero as hash to bpf_run_sk_reuseport().

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/filter.c          | 19 +++++++++++++++++++
 net/core/sock_reuseport.c  | 19 ++++++++++---------
 net/ipv4/inet_hashtables.c |  2 +-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1059d31847ef..2f2fb77cdb72 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9871,10 +9871,29 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
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
index 96d65b4c6974..6b475897b496 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -247,8 +247,15 @@ struct sock *reuseport_detach_sock(struct sock *sk)
 		prog = rcu_dereference(reuse->prog);
 
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
 			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
@@ -342,15 +349,9 @@ struct sock *__reuseport_select_sock(struct sock *sk, u32 hash,
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

