Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F912B5C06
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgKQJml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:42:41 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8939 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgKQJml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:42:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606160; x=1637142160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=wrzdg6wvKa1DnV7c+HpDFpqsfyVbRJIGt6M+PZA79cU=;
  b=BEvJLRk+ioOn5ZQI/dX/CUV6bfTvWEev1cmCGBLrTjlofkav57c8qFx/
   iprLIDWFFSxbQ96iHok6cQKi9LuI0MxY17QdBzc1pYy7M219S7vo9YRF0
   0gyoEQ1iyqp+alXvG3ruGXicLABsRx0hVo+ug1NqZxvOQLLlR2vMC+MiN
   c=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="65440717"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 17 Nov 2020 09:42:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 9998DA182C;
        Tue, 17 Nov 2020 09:42:37 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:36 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH bpf-next 7/8] bpf: Call bpf_run_sk_reuseport() for socket migration.
Date:   Tue, 17 Nov 2020 18:40:22 +0900
Message-ID: <20201117094023.3685-8-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes it possible to select a new listener for socket migration
by eBPF.

The noteworthy point is that we select a listening socket in
reuseport_detach_sock() and reuseport_select_sock(), but we do not have
struct skb in the unhash path.

Since we cannot pass skb to the eBPF program, we run only the
BPF_PROG_TYPE_SK_REUSEPORT program by calling bpf_run_sk_reuseport() with
skb NULL. So, some fields derived from skb are also NULL in the eBPF
program.

Moreover, we can cancel migration by returning SK_DROP. This feature is
useful when listeners have different settings at the socket API level or
when we want to free resources as soon as possible.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/core/filter.c          | 26 +++++++++++++++++++++-----
 net/core/sock_reuseport.c  | 23 ++++++++++++++++++++---
 net/ipv4/inet_hashtables.c |  2 +-
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 01e28f283962..ffc4591878b8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8914,6 +8914,22 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 	SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(S, NS, F, NF,		       \
 					     BPF_FIELD_SIZEOF(NS, NF), 0)
 
+#define SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF_OR_NULL(S, NS, F, NF, SIZE, OFF)	\
+	do {									\
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), si->dst_reg,	\
+				      si->src_reg, offsetof(S, F));		\
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);		\
+		*insn++ = BPF_LDX_MEM(						\
+			SIZE, si->dst_reg, si->dst_reg,				\
+			bpf_target_off(NS, NF, sizeof_field(NS, NF),		\
+				       target_size)				\
+			+ OFF);							\
+	} while (0)
+
+#define SOCK_ADDR_LOAD_NESTED_FIELD_OR_NULL(S, NS, F, NF)			\
+	SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF_OR_NULL(S, NS, F, NF,		\
+						     BPF_FIELD_SIZEOF(NS, NF), 0)
+
 /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
  * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
  *
@@ -9858,7 +9874,7 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 	reuse_kern->skb = skb;
 	reuse_kern->sk = sk;
 	reuse_kern->selected_sk = NULL;
-	reuse_kern->data_end = skb->data + skb_headlen(skb);
+	reuse_kern->data_end = skb ? skb->data + skb_headlen(skb) : NULL;
 	reuse_kern->hash = hash;
 	reuse_kern->reuseport_id = reuse->reuseport_id;
 	reuse_kern->bind_inany = reuse->bind_inany;
@@ -10039,10 +10055,10 @@ sk_reuseport_is_valid_access(int off, int size,
 	})
 
 #define SK_REUSEPORT_LOAD_SKB_FIELD(SKB_FIELD)				\
-	SOCK_ADDR_LOAD_NESTED_FIELD(struct sk_reuseport_kern,		\
-				    struct sk_buff,			\
-				    skb,				\
-				    SKB_FIELD)
+	SOCK_ADDR_LOAD_NESTED_FIELD_OR_NULL(struct sk_reuseport_kern,	\
+					    struct sk_buff,		\
+					    skb,			\
+					    SKB_FIELD)
 
 #define SK_REUSEPORT_LOAD_SK_FIELD(SK_FIELD)				\
 	SOCK_ADDR_LOAD_NESTED_FIELD(struct sk_reuseport_kern,		\
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 74a46197854b..903f78ab35c3 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -224,6 +224,7 @@ struct sock *reuseport_detach_sock(struct sock *sk)
 {
 	struct sock_reuseport *reuse;
 	struct sock *nsk = NULL;
+	struct bpf_prog *prog;
 	int i;
 
 	spin_lock_bh(&reuseport_lock);
@@ -249,8 +250,16 @@ struct sock *reuseport_detach_sock(struct sock *sk)
 		reuse->socks[i] = reuse->socks[reuse->num_socks];
 
 		if (reuse->migrate_req) {
-			if (reuse->num_socks)
-				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
+			if (reuse->num_socks) {
+				prog = rcu_dereference(reuse->prog);
+				if (prog && prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
+					nsk = bpf_run_sk_reuseport(reuse, sk, prog,
+								   NULL, sk->sk_hash);
+
+				if (!nsk)
+					nsk = i == reuse->num_socks ?
+						reuse->socks[i - 1] : reuse->socks[i];
+			}
 
 			reuse->num_closed_socks++;
 			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
@@ -340,8 +349,16 @@ struct sock *reuseport_select_sock(struct sock *sk,
 		/* paired with smp_wmb() in reuseport_add_sock() */
 		smp_rmb();
 
-		if (!prog || !skb)
+		if (!prog)
+			goto select_by_hash;
+
+		if (!skb) {
+			if (reuse->migrate_req &&
+			    prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
+				sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
+
 			goto select_by_hash;
+		}
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
 			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index f35c76cf3365..d981e4876679 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -647,7 +647,7 @@ void inet_unhash(struct sock *sk)
 
 	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
 		nsk = reuseport_detach_sock(sk);
-		if (nsk)
+		if (!IS_ERR_OR_NULL(nsk))
 			inet_csk_reqsk_queue_migrate(sk, nsk);
 	}
 
-- 
2.17.2 (Apple Git-113)

