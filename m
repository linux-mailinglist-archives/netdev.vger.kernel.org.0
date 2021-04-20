Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1309365C85
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhDTPqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:46:01 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:57942 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbhDTPpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1618933523; x=1650469523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3be/W7iSic+4drq35svGwHrLpQvuX2k0t+uns/7wj7s=;
  b=Asw+5NG1yQRIvJHXl83XOv9X9NzBaDWRx0zDFaqgfXWThaoBudp7dV2Q
   Vi44jHRX/cWcv3lldaZl7QIZDxpyA5ho0ZOXyvHeCVpiaHtaYsUbiEgwU
   kiR1QclxC5rn8xL1vc5+05uB0zOy4tdbivqsUgVIdyM++Pue2bpS6DSHB
   w=;
X-IronPort-AV: E=Sophos;i="5.82,237,1613433600"; 
   d="scan'208";a="107202537"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 20 Apr 2021 15:45:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 4A84DA25BD;
        Tue, 20 Apr 2021 15:45:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:45:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 20 Apr 2021 15:45:07 +0000
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
Subject: [PATCH v3 bpf-next 09/11] bpf: Support socket migration by eBPF.
Date:   Wed, 21 Apr 2021 00:41:38 +0900
Message-ID: <20210420154140.80034-10-kuniyu@amazon.co.jp>
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

This patch introduces a new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT
to check if the attached eBPF program is capable of migrating sockets. When
the eBPF program is attached, we run it for socket migration if the
expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE or
net.ipv4.tcp_migrate_req is enabled.

Ccurrently, the expected_attach_type is not enforced for the
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
index c9b7a876b0c8..40b9f074a929 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2014,6 +2014,7 @@ struct sk_reuseport_kern {
 	struct sk_buff *skb;
 	struct sock *sk;
 	struct sock *selected_sk;
+	struct sock *migrating_sk;
 	void *data_end;
 	u32 hash;
 	u32 reuseport_id;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9a09547bc7ba..226f76c0b974 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -995,11 +995,13 @@ void bpf_warn_invalid_xdp_action(u32 act);
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
index ab8584701334..3888641c0d39 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -958,6 +958,8 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -5299,7 +5301,20 @@ struct sk_reuseport_md {
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
index 6428634da57e..b5f5dbd16f89 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1931,6 +1931,11 @@ static void bpf_prog_load_fixup_attach_type(union bpf_attr *attr)
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
 
@@ -2014,6 +2019,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
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
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
 			return -EINVAL;
diff --git a/net/core/filter.c b/net/core/filter.c
index 3d0f989f5d38..1dfe2f820950 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10007,11 +10007,13 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
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
@@ -10020,12 +10022,13 @@ static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 
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
@@ -10170,6 +10173,10 @@ sk_reuseport_is_valid_access(int off, int size,
 		info->reg_type = ARG_PTR_TO_SOCKET;
 		return size == sizeof(__u64);
 
+	case offsetof(struct sk_reuseport_md, migrating_sk):
+		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
+		return size == sizeof(__u64);
+
 	/* Fields that allow narrowing */
 	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
 		if (size < sizeof_field(struct sk_buff, protocol))
@@ -10246,6 +10253,10 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
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
index a2bca39ec0e3..d35c8f51ab72 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -378,13 +378,17 @@ void reuseport_stop_listen_sock(struct sock *sk)
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
@@ -489,7 +493,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
 			goto select_by_hash;
 
 		if (prog->type == BPF_PROG_TYPE_SK_REUSEPORT)
-			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, hash);
+			sk2 = bpf_run_sk_reuseport(reuse, sk, prog, skb, NULL, hash);
 		else
 			sk2 = run_bpf_filter(reuse, socks, prog, skb, hdr_len);
 
@@ -520,6 +524,8 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 {
 	struct sock_reuseport *reuse;
 	struct sock *nsk = NULL;
+	bool allocated = false;
+	struct bpf_prog *prog;
 	u16 socks;
 	u32 hash;
 
@@ -537,10 +543,30 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
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
index 5fd94d632792..449ca2f4ab65 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -958,6 +958,8 @@ enum bpf_attach_type {
 	BPF_SK_LOOKUP,
 	BPF_XDP,
 	BPF_SK_SKB_VERDICT,
+	BPF_SK_REUSEPORT_SELECT,
+	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -5293,7 +5295,20 @@ struct sk_reuseport_md {
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

