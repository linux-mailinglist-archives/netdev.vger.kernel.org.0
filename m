Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2F6195A70
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 16:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgC0P7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 11:59:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:50920 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgC0P7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 11:59:16 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHrO5-0007n8-0Z; Fri, 27 Mar 2020 16:59:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     m@lambda.lt, joe@wand.net.nz, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 3/7] bpf: add netns cookie and enable it for bpf cgroup hooks
Date:   Fri, 27 Mar 2020 16:58:52 +0100
Message-Id: <c47d2346982693a9cf9da0e12690453aded4c788.1585323121.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1585323121.git.daniel@iogearbox.net>
References: <cover.1585323121.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Cilium we're mainly using BPF cgroup hooks today in order to implement
kube-proxy free Kubernetes service translation for ClusterIP, NodePort (*),
ExternalIP, and LoadBalancer as well as HostPort mapping [0] for all traffic
between Cilium managed nodes. While this works in its current shape and avoids
packet-level NAT for inter Cilium managed node traffic, there is one major
limitation we're facing today, that is, lack of netns awareness.

In Kubernetes, the concept of Pods (which hold one or multiple containers)
has been built around network namespaces, so while we can use the global scope
of attaching to root BPF cgroup hooks also to our advantage (e.g. for exposing
NodePort ports on loopback addresses), we also have the need to differentiate
between initial network namespaces and non-initial one. For example, ExternalIP
services mandate that non-local service IPs are not to be translated from the
host (initial) network namespace as one example. Right now, we have an ugly
work-around in place where non-local service IPs for ExternalIP services are
not xlated from connect() and friends BPF hooks but instead via less efficient
packet-level NAT on the veth tc ingress hook for Pod traffic.

On top of determining whether we're in initial or non-initial network namespace
we also have a need for a socket-cookie like mechanism for network namespaces
scope. Socket cookies have the nice property that they can be combined as part
of the key structure e.g. for BPF LRU maps without having to worry that the
cookie could be recycled. We are planning to use this for our sessionAffinity
implementation for services. Therefore, add a new bpf_get_netns_cookie() helper
which would resolve both use cases at once: bpf_get_netns_cookie(NULL) would
provide the cookie for the initial network namespace while passing the context
instead of NULL would provide the cookie from the application's network namespace.
We're using a hole, so no size increase; the assignment happens only once.
Therefore this allows for a comparison on initial namespace as well as regular
cookie usage as we have today with socket cookies. We could later on enable
this helper for other program types as well as we would see need.

  (*) Both externalTrafficPolicy={Local|Cluster} types
  [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/bpf.h            |  1 +
 include/net/net_namespace.h    | 10 +++++++++
 include/uapi/linux/bpf.h       | 16 ++++++++++++++-
 kernel/bpf/verifier.c          | 16 +++++++++------
 net/core/filter.c              | 37 ++++++++++++++++++++++++++++++++++
 net/core/net_namespace.c       | 15 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 16 ++++++++++++++-
 7 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb981c204fa..78046c570596 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -233,6 +233,7 @@ enum bpf_arg_type {
 	ARG_CONST_SIZE_OR_ZERO,	/* number of bytes accessed from memory or 0 */
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
+	ARG_PTR_TO_CTX_OR_NULL,	/* pointer to context or NULL */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 854d39ef1ca3..1c6edfdb9a2c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -168,6 +168,9 @@ struct net {
 #ifdef CONFIG_XFRM
 	struct netns_xfrm	xfrm;
 #endif
+
+	atomic64_t		net_cookie; /* written once */
+
 #if IS_ENABLED(CONFIG_IP_VS)
 	struct netns_ipvs	*ipvs;
 #endif
@@ -273,6 +276,8 @@ static inline int check_net(const struct net *net)
 
 void net_drop_ns(void *);
 
+u64 net_gen_cookie(struct net *net);
+
 #else
 
 static inline struct net *get_net(struct net *net)
@@ -300,6 +305,11 @@ static inline int check_net(const struct net *net)
 	return 1;
 }
 
+static inline u64 net_gen_cookie(struct net *net)
+{
+	return 0;
+}
+
 #define net_drop_ns NULL
 #endif
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5d01c5c7e598..bd81c4555206 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2950,6 +2950,19 @@ union bpf_attr {
  *		restricted to raw_tracepoint bpf programs.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_get_netns_cookie(void *ctx)
+ * 	Description
+ * 		Retrieve the cookie (generated by the kernel) of the network
+ * 		namespace the input *ctx* is associated with. The network
+ * 		namespace cookie remains stable for its lifetime and provides
+ * 		a global identifier that can be assumed unique. If *ctx* is
+ * 		NULL, then the helper returns the cookie for the initial
+ * 		network namespace. The cookie itself is very similar to that
+ * 		of bpf_get_socket_cookie() helper, but for network namespaces
+ * 		instead of sockets.
+ * 	Return
+ * 		A 8-byte long opaque number.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3073,7 +3086,8 @@ union bpf_attr {
 	FN(jiffies64),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
-	FN(xdp_output),
+	FN(xdp_output),			\
+	FN(get_netns_cookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 745f3cfdf3b2..cb30b34d1466 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3461,13 +3461,17 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = CONST_PTR_TO_MAP;
 		if (type != expected_type)
 			goto err_type;
-	} else if (arg_type == ARG_PTR_TO_CTX) {
+	} else if (arg_type == ARG_PTR_TO_CTX ||
+		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
 		expected_type = PTR_TO_CTX;
-		if (type != expected_type)
-			goto err_type;
-		err = check_ctx_reg(env, reg, regno);
-		if (err < 0)
-			return err;
+		if (!(register_is_null(reg) &&
+		      arg_type == ARG_PTR_TO_CTX_OR_NULL)) {
+			if (type != expected_type)
+				goto err_type;
+			err = check_ctx_reg(env, reg, regno);
+			if (err < 0)
+				return err;
+		}
 	} else if (arg_type == ARG_PTR_TO_SOCK_COMMON) {
 		expected_type = PTR_TO_SOCK_COMMON;
 		/* Any sk pointer can be ARG_PTR_TO_SOCK_COMMON */
diff --git a/net/core/filter.c b/net/core/filter.c
index 6cb7e0e24473..e249a499cbe5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4141,6 +4141,39 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+static u64 __bpf_get_netns_cookie(struct sock *sk)
+{
+#ifdef CONFIG_NET_NS
+	return net_gen_cookie(sk ? sk->sk_net.net : &init_net);
+#else
+	return 0;
+#endif
+}
+
+BPF_CALL_1(bpf_get_netns_cookie_sock, struct sock *, ctx)
+{
+	return __bpf_get_netns_cookie(ctx);
+}
+
+static const struct bpf_func_proto bpf_get_netns_cookie_sock_proto = {
+	.func		= bpf_get_netns_cookie_sock,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
+};
+
+BPF_CALL_1(bpf_get_netns_cookie_sock_addr, struct bpf_sock_addr_kern *, ctx)
+{
+	return __bpf_get_netns_cookie(ctx ? ctx->sk : NULL);
+}
+
+static const struct bpf_func_proto bpf_get_netns_cookie_sock_addr_proto = {
+	.func		= bpf_get_netns_cookie_sock_addr,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX_OR_NULL,
+};
+
 BPF_CALL_1(bpf_get_socket_uid, struct sk_buff *, skb)
 {
 	struct sock *sk = sk_to_full_sk(skb->sk);
@@ -5968,6 +6001,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_cookie_sock_proto;
+	case BPF_FUNC_get_netns_cookie:
+		return &bpf_get_netns_cookie_sock_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_event_output_data_proto;
 	default:
@@ -5994,6 +6029,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		}
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_cookie_sock_addr_proto;
+	case BPF_FUNC_get_netns_cookie:
+		return &bpf_get_netns_cookie_sock_addr_proto;
 	case BPF_FUNC_get_local_storage:
 		return &bpf_get_local_storage_proto;
 	case BPF_FUNC_perf_event_output:
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 757cc1d084e7..190ca66a383b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -69,6 +69,20 @@ EXPORT_SYMBOL_GPL(pernet_ops_rwsem);
 
 static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
 
+static atomic64_t cookie_gen;
+
+u64 net_gen_cookie(struct net *net)
+{
+	while (1) {
+		u64 res = atomic64_read(&net->net_cookie);
+
+		if (res)
+			return res;
+		res = atomic64_inc_return(&cookie_gen);
+		atomic64_cmpxchg(&net->net_cookie, 0, res);
+	}
+}
+
 static struct net_generic *net_alloc_generic(void)
 {
 	struct net_generic *ng;
@@ -1087,6 +1101,7 @@ static int __init net_ns_init(void)
 		panic("Could not allocate generic netns");
 
 	rcu_assign_pointer(init_net.gen, ng);
+	net_gen_cookie(&init_net);
 
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5d01c5c7e598..bd81c4555206 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2950,6 +2950,19 @@ union bpf_attr {
  *		restricted to raw_tracepoint bpf programs.
  *	Return
  *		0 on success, or a negative error in case of failure.
+ *
+ * u64 bpf_get_netns_cookie(void *ctx)
+ * 	Description
+ * 		Retrieve the cookie (generated by the kernel) of the network
+ * 		namespace the input *ctx* is associated with. The network
+ * 		namespace cookie remains stable for its lifetime and provides
+ * 		a global identifier that can be assumed unique. If *ctx* is
+ * 		NULL, then the helper returns the cookie for the initial
+ * 		network namespace. The cookie itself is very similar to that
+ * 		of bpf_get_socket_cookie() helper, but for network namespaces
+ * 		instead of sockets.
+ * 	Return
+ * 		A 8-byte long opaque number.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3073,7 +3086,8 @@ union bpf_attr {
 	FN(jiffies64),			\
 	FN(read_branch_records),	\
 	FN(get_ns_current_pid_tgid),	\
-	FN(xdp_output),
+	FN(xdp_output),			\
+	FN(get_netns_cookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.21.0

