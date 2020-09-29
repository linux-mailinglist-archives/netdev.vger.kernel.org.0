Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75C727D9ED
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgI2VX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:23:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:53008 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729525AbgI2VXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:23:18 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNN5e-00076x-Uz; Tue, 29 Sep 2020 23:23:15 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH bpf-next v3 2/6] bpf, net: rework cookie generator as per-cpu one
Date:   Tue, 29 Sep 2020 23:23:02 +0200
Message-Id: <c7bb9920eee2f05df92bfd7c462b9059fb7ff26c.1601414174.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601414174.git.daniel@iogearbox.net>
References: <cover.1601414174.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With its use in BPF, the cookie generator can be called very frequently
in particular when used out of cgroup v2 hooks (e.g. connect / sendmsg)
and attached to the root cgroup, for example, when used in v1/v2 mixed
environments. In particular, when there's a high churn on sockets in the
system there can be many parallel requests to the bpf_get_socket_cookie()
and bpf_get_netns_cookie() helpers which then cause contention on the
atomic counter.

As similarly done in f991bd2e1421 ("fs: introduce a per-cpu last_ino
allocator"), add a small helper library that both can use for the 64 bit
counters. Given this can be called from different contexts, we also need
to deal with potential nested calls even though in practice they are
considered extremely rare. One idea as suggested by Eric Dumazet was
to use a reverse counter for this situation since we don't expect 64 bit
overflows anyways; that way, we can avoid bigger gaps in the 64 bit
counter space compared to just batch-wise increase. Even on machines
with small number of cores (e.g. 4) the cookie generation shrinks from
min/max/med/avg (ns) of 22/50/40/38.9 down to 10/35/14/17.3 when run
in parallel from multiple CPUs.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/cookie.h       | 51 ++++++++++++++++++++++++++++++++++++
 include/linux/sock_diag.h    | 14 +++++++++-
 include/net/net_namespace.h  |  2 +-
 kernel/bpf/reuseport_array.c |  2 +-
 net/core/filter.c            | 10 +++----
 net/core/net_namespace.c     |  9 ++++---
 net/core/sock_diag.c         |  9 ++++---
 net/core/sock_map.c          |  4 +--
 8 files changed, 83 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/cookie.h

diff --git a/include/linux/cookie.h b/include/linux/cookie.h
new file mode 100644
index 000000000000..0c159f585109
--- /dev/null
+++ b/include/linux/cookie.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_COOKIE_H
+#define __LINUX_COOKIE_H
+
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+#include <asm/local.h>
+
+struct pcpu_gen_cookie {
+	local_t nesting;
+	u64 last;
+} __aligned(16);
+
+struct gen_cookie {
+	struct pcpu_gen_cookie __percpu *local;
+	atomic64_t forward_last ____cacheline_aligned_in_smp;
+	atomic64_t reverse_last;
+};
+
+#define COOKIE_LOCAL_BATCH	4096
+
+#define DEFINE_COOKIE(name)						\
+	static DEFINE_PER_CPU(struct pcpu_gen_cookie, __##name);	\
+	static struct gen_cookie name = {				\
+		.local		= &__##name,				\
+		.forward_last	= ATOMIC64_INIT(0),			\
+		.reverse_last	= ATOMIC64_INIT(0),			\
+	}
+
+static __always_inline u64 gen_cookie_next(struct gen_cookie *gc)
+{
+	struct pcpu_gen_cookie *local = this_cpu_ptr(gc->local);
+	u64 val;
+
+	if (likely(local_inc_return(&local->nesting) == 1)) {
+		val = local->last;
+		if (__is_defined(CONFIG_SMP) &&
+		    unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
+			s64 next = atomic64_add_return(COOKIE_LOCAL_BATCH,
+						       &gc->forward_last);
+			val = next - COOKIE_LOCAL_BATCH;
+		}
+		local->last = ++val;
+	} else {
+		val = atomic64_dec_return(&gc->reverse_last);
+	}
+	local_dec(&local->nesting);
+	return val;
+}
+
+#endif /* __LINUX_COOKIE_H */
diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 15fe980a27ea..0b9ecd8cf979 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -25,7 +25,19 @@ void sock_diag_unregister(const struct sock_diag_handler *h);
 void sock_diag_register_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh));
 void sock_diag_unregister_inet_compat(int (*fn)(struct sk_buff *skb, struct nlmsghdr *nlh));
 
-u64 sock_gen_cookie(struct sock *sk);
+u64 __sock_gen_cookie(struct sock *sk);
+
+static inline u64 sock_gen_cookie(struct sock *sk)
+{
+	u64 cookie;
+
+	preempt_disable();
+	cookie = __sock_gen_cookie(sk);
+	preempt_enable();
+
+	return cookie;
+}
+
 int sock_diag_check_cookie(struct sock *sk, const __u32 *cookie);
 void sock_diag_save_cookie(struct sock *sk, __u32 *cookie);
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 2ee5901bec7a..22bc07f4b043 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -230,7 +230,7 @@ extern struct list_head net_namespace_list;
 struct net *get_net_ns_by_pid(pid_t pid);
 struct net *get_net_ns_by_fd(int fd);
 
-u64 net_gen_cookie(struct net *net);
+u64 __net_gen_cookie(struct net *net);
 
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 5a2ba1182493..a55cd542f2ce 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -191,7 +191,7 @@ int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
 	rcu_read_lock();
 	sk = reuseport_array_lookup_elem(map, key);
 	if (sk) {
-		*(u64 *)value = sock_gen_cookie(sk);
+		*(u64 *)value = __sock_gen_cookie(sk);
 		err = 0;
 	} else {
 		err = -ENOENT;
diff --git a/net/core/filter.c b/net/core/filter.c
index fa01c697977d..a0776e48dcc9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4232,7 +4232,7 @@ const struct bpf_func_proto bpf_xdp_output_proto = {
 
 BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
 {
-	return skb->sk ? sock_gen_cookie(skb->sk) : 0;
+	return skb->sk ? __sock_gen_cookie(skb->sk) : 0;
 }
 
 static const struct bpf_func_proto bpf_get_socket_cookie_proto = {
@@ -4244,7 +4244,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_proto = {
 
 BPF_CALL_1(bpf_get_socket_cookie_sock_addr, struct bpf_sock_addr_kern *, ctx)
 {
-	return sock_gen_cookie(ctx->sk);
+	return __sock_gen_cookie(ctx->sk);
 }
 
 static const struct bpf_func_proto bpf_get_socket_cookie_sock_addr_proto = {
@@ -4256,7 +4256,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_addr_proto = {
 
 BPF_CALL_1(bpf_get_socket_cookie_sock, struct sock *, ctx)
 {
-	return sock_gen_cookie(ctx);
+	return __sock_gen_cookie(ctx);
 }
 
 static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
@@ -4268,7 +4268,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_proto = {
 
 BPF_CALL_1(bpf_get_socket_cookie_sock_ops, struct bpf_sock_ops_kern *, ctx)
 {
-	return sock_gen_cookie(ctx->sk);
+	return __sock_gen_cookie(ctx->sk);
 }
 
 static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
@@ -4281,7 +4281,7 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 static u64 __bpf_get_netns_cookie(struct sock *sk)
 {
 #ifdef CONFIG_NET_NS
-	return net_gen_cookie(sk ? sk->sk_net.net : &init_net);
+	return __net_gen_cookie(sk ? sk->sk_net.net : &init_net);
 #else
 	return 0;
 #endif
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 944ab214e5ae..4dd3e0aa0e1f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -19,6 +19,7 @@
 #include <linux/net_namespace.h>
 #include <linux/sched/task.h>
 #include <linux/uidgid.h>
+#include <linux/cookie.h>
 
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -69,16 +70,16 @@ EXPORT_SYMBOL_GPL(pernet_ops_rwsem);
 
 static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
 
-static atomic64_t cookie_gen;
+DEFINE_COOKIE(net_cookie);
 
-u64 net_gen_cookie(struct net *net)
+u64 __net_gen_cookie(struct net *net)
 {
 	while (1) {
 		u64 res = atomic64_read(&net->net_cookie);
 
 		if (res)
 			return res;
-		res = atomic64_inc_return(&cookie_gen);
+		res = gen_cookie_next(&net_cookie);
 		atomic64_cmpxchg(&net->net_cookie, 0, res);
 	}
 }
@@ -1101,7 +1102,7 @@ static int __init net_ns_init(void)
 		panic("Could not allocate generic netns");
 
 	rcu_assign_pointer(init_net.gen, ng);
-	net_gen_cookie(&init_net);
+	__net_gen_cookie(&init_net);
 
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index c13ffbd33d8d..c9c45b935f99 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -11,7 +11,7 @@
 #include <linux/tcp.h>
 #include <linux/workqueue.h>
 #include <linux/nospec.h>
-
+#include <linux/cookie.h>
 #include <linux/inet_diag.h>
 #include <linux/sock_diag.h>
 
@@ -19,16 +19,17 @@ static const struct sock_diag_handler *sock_diag_handlers[AF_MAX];
 static int (*inet_rcv_compat)(struct sk_buff *skb, struct nlmsghdr *nlh);
 static DEFINE_MUTEX(sock_diag_table_mutex);
 static struct workqueue_struct *broadcast_wq;
-static atomic64_t cookie_gen;
 
-u64 sock_gen_cookie(struct sock *sk)
+DEFINE_COOKIE(sock_cookie);
+
+u64 __sock_gen_cookie(struct sock *sk)
 {
 	while (1) {
 		u64 res = atomic64_read(&sk->sk_cookie);
 
 		if (res)
 			return res;
-		res = atomic64_inc_return(&cookie_gen);
+		res = gen_cookie_next(&sock_cookie);
 		atomic64_cmpxchg(&sk->sk_cookie, 0, res);
 	}
 }
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 08bc86f51593..e83a80e8f13b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -401,7 +401,7 @@ static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
 	if (!sk)
 		return ERR_PTR(-ENOENT);
 
-	sock_gen_cookie(sk);
+	__sock_gen_cookie(sk);
 	return &sk->sk_cookie;
 }
 
@@ -1209,7 +1209,7 @@ static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
 	if (!sk)
 		return ERR_PTR(-ENOENT);
 
-	sock_gen_cookie(sk);
+	__sock_gen_cookie(sk);
 	return &sk->sk_cookie;
 }
 
-- 
2.21.0

