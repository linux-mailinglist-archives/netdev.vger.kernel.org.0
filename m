Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C073A4EC6
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFLMg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:36:59 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:43027 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhFLMg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623501299; x=1655037299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kRQ9cU5Z7H3VXnRZcYjE3aW0FLeIiI7P4sX8NyqfjYQ=;
  b=u/S5gW4TUK+ZEooLS3W8V02IDxcLBWR8ePcXdbAOpodtLSVQ/bHjhkKq
   lSEHPcOj9d8ZMW8ngjMJAuugQ34MtvzgI6bbJFKKs2z0Fhfg7GlqCdAhV
   28uumWNc6kFCFAhTb+KDxdHfuIGpKtcAUhlBqDO3TbsYS0uzfWKeD2/lW
   0=;
X-IronPort-AV: E=Sophos;i="5.83,268,1616457600"; 
   d="scan'208";a="139820326"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 12 Jun 2021 12:34:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 1C9CCA1C21;
        Sat, 12 Jun 2021 12:34:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:34:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.55) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 12 Jun 2021 12:34:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 bpf-next 09/11] bpf: Support socket migration by eBPF.
Date:   Sat, 12 Jun 2021 21:32:22 +0900
Message-ID: <20210612123224.12525-10-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT
to check if the attached eBPF program is capable of migrating sockets. When
the eBPF program is attached, we run it for socket migration if the
expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE or
net.ipv4.tcp_migrate_req is enabled.

Currently, the expected_attach_type is not enforced for the
BPF_PROG_TYPE_SK_REUSEPORT type of program. Thus, this commit follows the
earlier idea in the commit aac3fc320d94 ("bpf: Post-hooks for sys_bind") to
fix up the zero expected_attach_type in bpf_prog_load_fixup_attach_type().

Moreover, this patch adds a new field (migrating_sk) to sk_reuseport_md to
select a new listener based on the child socket. migrating_sk varies
depending on if it is migrating a request in the accept queue or during
3WHS.

  - accept_queue : sock (ESTABLISHED/SYN_RECV)
  - 3WHS         : request_sock (NEW_SYN_RECV)

In the eBPF program, we can select a new listener by
BPF_FUNC_sk_select_reuseport(). Also, we can cancel migration by returning
SK_DROP. This feature is useful when listeners have different settings at
the socket API level or when we want to free resources as soon as possible.

  - SK_PASS with selected_sk, select it as a new listener
  - SK_PASS with selected_sk NULL, fallbacks to the random selection
  - SK_DROP, cancel the migration.

There is a noteworthy point. We select a listening socket in three places,
but we do not have struct skb at closing a listener or retransmitting a
SYN+ACK. On the other hand, some helper functions do not expect skb is NULL
(e.g. skb_header_pointer() in BPF_FUNC_skb_load_bytes(), skb_tail_pointer()
in BPF_FUNC_skb_load_bytes_relative()). So we allocate an empty skb
temporarily before running the eBPF program.

Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
Link: https://lore.kernel.org/netdev/20201203042402.6cskdlit5f3mw4ru@kafai-mbp.dhcp.thefacebook.com/
Link: https://lore.kernel.org/netdev/20201209030903.hhow5r53l6fmozjn@kafai-mbp.dhcp.thefacebook.com/
Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/linux/filter.h         |  2 ++
 include/uapi/linux/bpf.h       | 15 +++++++++++++++
 kernel/bpf/syscall.c           | 13 +++++++++++++
 net/core/filter.c              | 13 ++++++++++++-
 net/core/sock_reuseport.c      | 34 ++++++++++++++++++++++++++++++----
 tools/include/uapi/linux/bpf.h | 15 +++++++++++++++
 7 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 86dec5001ae2..f309fc1509f2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2048,6 +2048,7 @@ struct sk_reuseport_kern {
 	struct sk_buff *skb;
 	struct sock *sk;
 	struct sock *selected_sk;
+	struct sock *migrating_sk;
 	void *data_end;
 	u32 hash;
 	u32 reuseport_id;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index c5ad7df029ed..688856e0b28a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -996,11 +996,13 @@ void bpf_warn_invalid_xdp_action(u32 act);
 #ifdef CONFIG_INET
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 				  struct bpf_prog *prog, struct sk_buff *skb,
+				  struct sock *migrating_sk,
 				  u32 hash);
 #else
 static inline struct sock *
 bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 		     struct bpf_prog *prog, struct sk_buff *skb,
+		     struct sock *migrating_sk,
 		     u32 hash)
 {
 	return NULL;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f3b72588442b..bf9252c7381e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -994,6 +994,8 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -5416,7 +5418,20 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	/* When reuse->migrating_sk is NULL, it is selecting a sk for the
+	 * new incoming connection request (e.g. selecting a listen sk for
+	 * the received SYN in the TCP case).  reuse->sk is one of the sk
+	 * in the reuseport group. The bpf prog can use reuse->sk to learn
+	 * the local listening ip/port without looking into the skb.
+	 *
+	 * When reuse->migrating_sk is not NULL, reuse->sk is closed and
+	 * reuse->migrating_sk is the socket that needs to be migrated
+	 * to another listening socket.  migrating_sk could be a fullsock
+	 * sk that is fully established or a reqsk that is in-the-middle
+	 * of 3-way handshake.
+	 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(struct bpf_sock *, migrating_sk);
 };
 
 #define BPF_TAG_SIZE	8
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..dbbc5342f221 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1972,6 +1972,11 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
 			attr->expected_attach_type =
 				BPF_CGROUP_INET_SOCK_CREATE;
 		break;
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+		if (!attr->expected_attach_type)
+			attr->expected_attach_type =
+				BPF_SK_REUSEPORT_SELECT;
+		break;
 	}
 }
 
@@ -2055,6 +2060,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		if (expected_attach_type == BPF_SK_LOOKUP)
 			return 0;
 		return -EINVAL;
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+		switch (expected_attach_type) {
+		case BPF_SK_REUSEPORT_SELECT:
+		case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
+			return 0;
+		default:
+			return -EINVAL;
+		}
 	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
diff --git a/net/core/filter.c b/net/core/filter.c
index f753ab550525..5b86e47ef079 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10044,11 +10044,13 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 				    struct sock_reuseport *reuse,
 				    struct sock *sk, struct sk_buff *skb,
+				    struct sock *migrating_sk,
 				    u32 hash)
 {
 	reuse_kern->skb = skb;
 	reuse_kern->sk = sk;
 	reuse_kern->selected_sk = NULL;
+	reuse_kern->migrating_sk = migrating_sk;
 	reuse_kern->data_end = skb->data + skb_headlen(skb);
 	reuse_kern->hash = hash;
 	reuse_kern->reuseport_id = reuse->reuseport_id;
@@ -10057,12 +10059,13 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 
 struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 				  struct bpf_prog *prog, struct sk_buff *skb,
+				  struct sock *migrating_sk,
 				  u32 hash)
 {
 	struct sk_reuseport_kern reuse_kern;
 	enum sk_action action;
 
-	bpf_init_reuseport_kern(&reuse_kern, reuse, sk, skb, hash);
+	bpf_init_reuseport_kern(&reuse_kern, reuse, sk, skb, migrating_sk, hash);
 	action = BPF_PROG_RUN(prog, &reuse_kern);
 
 	if (action == SK_PASS)
@@ -10207,6 +10210,10 @@ sk_reuseport_is_valid_access(int off, int size,
 		info->reg_type = PTR_TO_SOCKET;
 		return size == sizeof(__u64);
 
+	case offsetof(struct sk_reuseport_md, migrating_sk):
+		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10283,6 +10290,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct sk_reuseport_md, sk):
 		SK_REUSEPORT_LOAD_FIELD(sk);
 		break;
+
+	case offsetof(struct sk_reuseport_md, migrating_sk):
+		SK_REUSEPORT_LOAD_FIELD(migrating_sk);
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index b239f8cd9d39..de5ee3ae86d5 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -377,13 +377,17 @@ void reuseport_stop_listen_sock(struct sock *sk)
 {
 	if (sk->sk_protocol == IPPROTO_TCP) {
 		struct sock_reuseport *reuse;
+		struct bpf_prog *prog;
 
 		spin_lock_bh(&reuseport_lock);
 
 		reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 						  lockdep_is_held(&reuseport_lock));
+		prog = rcu_dereference_protected(reuse->prog,
+						 lockdep_is_held(&reuseport_lock));
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req) {
+		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req ||
+		    (prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
 			/* Migration capable, move sk from the listening section
 			 * to the closed section.
 			 */
@@ -488,7 +492,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
 			goto select_by_hash;
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
-			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
+			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, NULL, hash);
 		else
 			sk2 = run_bpf_filter(reuse, socks, prog, skb, hdr_len);
 
@@ -519,6 +523,8 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 {
 	struct sock_reuseport *reuse;
 	struct sock *nsk = NULL;
+	bool allocated = false;
+	struct bpf_prog *prog;
 	u16 socks;
 	u32 hash;
 
@@ -536,10 +542,30 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	smp_rmb();
 
 	hash = migrating_sk->sk_hash;
-	if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+	prog = rcu_dereference(reuse->prog);
+	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
+		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+			goto select_by_hash;
+		goto out;
+	}
+
+	if (!skb) {
+		skb = alloc_skb(0, GFP_ATOMIC);
+		if (!skb)
+			goto out;
+		allocated = true;
+	}
+
+	nsk = bpf_run_sk_reuseport(reuse, sk, prog, skb, migrating_sk, hash);
+
+	if (allocated)
+		kfree_skb(skb);
+
+select_by_hash:
+	if (!nsk)
 		nsk = reuseport_select_sock_by_hash(reuse, hash, socks);
 
-	if (nsk && unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt)))
+	if (IS_ERR_OR_NULL(nsk) || unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt)))
 		nsk = NULL;
 
 out:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f3b72588442b..bf9252c7381e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -994,6 +994,8 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -5416,7 +5418,20 @@ struct sk_reuseport_md {
 	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
 	__u32 bind_inany;	/* Is sock bound to an INANY address? */
 	__u32 hash;		/* A hash of the packet 4 tuples */
+	/* When reuse->migrating_sk is NULL, it is selecting a sk for the
+	 * new incoming connection request (e.g. selecting a listen sk for
+	 * the received SYN in the TCP case).  reuse->sk is one of the sk
+	 * in the reuseport group. The bpf prog can use reuse->sk to learn
+	 * the local listening ip/port without looking into the skb.
+	 *
+	 * When reuse->migrating_sk is not NULL, reuse->sk is closed and
+	 * reuse->migrating_sk is the socket that needs to be migrated
+	 * to another listening socket.  migrating_sk could be a fullsock
+	 * sk that is fully established or a reqsk that is in-the-middle
+	 * of 3-way handshake.
+	 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(struct bpf_sock *, migrating_sk);
 };
 
 #define BPF_TAG_SIZE	8
-- 
2.30.2

