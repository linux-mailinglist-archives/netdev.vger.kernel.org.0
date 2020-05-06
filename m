Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF52C1C70EB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgEFMzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728669AbgEFMzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:21 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F23C061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v4so4888891wme.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSvpwAKu+Pv0LQlBXodTxzFd8+99cboJacc6FDFMyBQ=;
        b=HNHner6hlBN6D7ZbqcVjZHOnpxbKp6AW0NHOWoRB6Nop08NExk06/ItoXPx5DnGdrG
         N/OvDL76BEOCrmWmdU3igYzhc1Cflq7bUOm+Qn/uaUum2mePvM7A28C6rpN0a9yFOCwo
         IVr/uGSdijJhGQznCodBYBrQjYpGd45KQbATc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSvpwAKu+Pv0LQlBXodTxzFd8+99cboJacc6FDFMyBQ=;
        b=HoDgePtDZchBdiEfdhrMAnwROZ9MAT00/QfMQuo/LvA8ME2+UwLMgChOI4MpWaMqQw
         gINLJpxoTe0KUoadk+kBuYC0cS9OGXXbryVJuOOwZkkFs1igOCd2tFHg1k4FVH0mySet
         wsF6bh2GCe3so/wg8z0BVAAGfrwIu0E5Ox/yRjFT9Henr14+iQR38VpF7/lUzKewh6lp
         EIZKsJovz0oUeTasNPKdU38QjNHicqMq/vcB7mk4So83STShDs+vWK75TetAJYHawhnS
         fsgdJYYcqUosnJlPAqQBjZgUeZTkwBqu0fZLn6oWg7ekYxfhFtXfcbSzmWNC6k49X2ud
         ezjQ==
X-Gm-Message-State: AGi0PubQQtBWcTzMcFpohnjS/PuSrru/Bll/pSj379JyfPDX5Ts7w2wl
        QtKMwsfeAyuMyfxQfI3lAWUkOooiv9w=
X-Google-Smtp-Source: APiQypIibcDaQiaQxIyxHRSlBMxxVtcU4AfHTbchC23javNSTiTSR95rcRRqgvcPGHrc+WPwqiDCJw==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr4193125wmj.3.1588769718843;
        Wed, 06 May 2020 05:55:18 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d27sm2799144wra.30.2020.05.06.05.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:18 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
Date:   Wed,  6 May 2020 14:54:58 +0200
Message-Id: <20200506125514.1020829-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new program type BPF_PROG_TYPE_SK_LOOKUP and a dedicated attach type
called BPF_SK_LOOKUP. The new program kind is to be invoked by the
transport layer when looking up a socket for a received packet.

When called, SK_LOOKUP program can select a socket that will receive the
packet. This serves as a mechanism to overcome the limits of what bind()
API allows to express. Two use-cases driving this work are:

 (1) steer packets destined to an IP range, fixed port to a socket

     192.0.2.0/24, port 80 -> NGINX socket

 (2) steer packets destined to an IP address, any port to a socket

     198.51.100.1, any port -> L7 proxy socket

In its run-time context, program receives information about the packet that
triggered the socket lookup. Namely IP version, L4 protocol identifier, and
address 4-tuple. Context can be further extended to include ingress
interface identifier.

To select a socket BPF program fetches it from a map holding socket
references, like SOCKMAP or SOCKHASH, and calls bpf_sk_assign(ctx, sk, ...)
helper to record the selection. Transport layer then uses the selected
socket as a result of socket lookup.

This patch only enables the user to attach an SK_LOOKUP program to a
network namespace. Subsequent patches hook it up to run on local delivery
path in ipv4 and ipv6 stacks.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf_types.h   |   2 +
 include/linux/filter.h      |  23 ++++
 include/net/net_namespace.h |   1 +
 include/uapi/linux/bpf.h    |  53 ++++++++
 kernel/bpf/syscall.c        |   9 ++
 net/core/filter.c           | 247 ++++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py  |   9 +-
 7 files changed, 343 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 8345cdf553b8..08c2aef674ac 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -64,6 +64,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
 	      struct sk_reuseport_md, struct sk_reuseport_kern)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SK_LOOKUP, sk_lookup,
+	      struct bpf_sk_lookup, struct bpf_sk_lookup_kern)
 #endif
 #if defined(CONFIG_BPF_JIT)
 BPF_PROG_TYPE(BPF_PROG_TYPE_STRUCT_OPS, bpf_struct_ops,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index af37318bb1c5..33254e840c8d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1280,4 +1280,27 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
+struct bpf_sk_lookup_kern {
+	unsigned short	family;
+	u16		protocol;
+	union {
+		struct {
+			__be32 saddr;
+			__be32 daddr;
+		} v4;
+		struct {
+			struct in6_addr saddr;
+			struct in6_addr daddr;
+		} v6;
+	};
+	__be16		sport;
+	u16		dport;
+	struct sock	*selected_sk;
+};
+
+int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog);
+int sk_lookup_prog_detach(const union bpf_attr *attr);
+int sk_lookup_prog_query(const union bpf_attr *attr,
+			 union bpf_attr __user *uattr);
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ab96fb59131c..70bf4888c94d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -163,6 +163,7 @@ struct net {
 	struct net_generic __rcu	*gen;
 
 	struct bpf_prog __rcu	*flow_dissector_prog;
+	struct bpf_prog __rcu	*sk_lookup_prog;
 
 	/* Note : following structs are cache line aligned */
 #ifdef CONFIG_XFRM
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b3643e27e264..e4c61b63d4bc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -187,6 +187,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -218,6 +219,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3041,6 +3043,10 @@ union bpf_attr {
  *
  * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
  *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
+ *		**BPF_PROG_TYPE_SCHED_ACT** programs.
+ *
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
  *		will cause *skb* to be delivered to the specified socket.
@@ -3061,6 +3067,39 @@ union bpf_attr {
  *					call from outside of TC ingress.
  *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
  *
+ * int bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
+ *
+ *		Select the *sk* as a result of a socket lookup.
+ *
+ *		For the operation to succeed passed socket must be compatible
+ *		with the packet description provided by the *ctx* object.
+ *
+ *		L4 protocol (*IPPROTO_TCP* or *IPPROTO_UDP*) must be an exact
+ *		match. While IP family (*AF_INET* or *AF_INET6*) must be
+ *		compatible, that is IPv6 sockets that are not v6-only can be
+ *		selected for IPv4 packets.
+ *
+ *		Only full sockets can be selected. However, there is no need to
+ *		call bpf_fullsock() before passing a socket as an argument to
+ *		this helper.
+ *
+ *		The *flags* argument must be zero.
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		**-EAFNOSUPPORT** is socket family (*sk->family*) is not
+ *		compatible with packet family (*ctx->family*).
+ *
+ *		**-EINVAL** if unsupported flags were specified.
+ *
+ *		**-EPROTOTYPE** if socket L4 protocol (*sk->protocol*) doesn't
+ *		match packet protocol (*ctx->protocol*).
+ *
+ *		**-ESOCKTNOSUPPORT** if socket is not a full socket.
+ *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
@@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
+struct bpf_sk_lookup {
+	__u32 family;		/* AF_INET, AF_INET6 */
+	__u32 protocol;		/* IPPROTO_TCP, IPPROTO_UDP */
+	/* IP addresses allows 1, 2, and 4 bytes access */
+	__u32 src_ip4;
+	__u32 src_ip6[4];
+	__u32 src_port;		/* network byte order */
+	__u32 dst_ip4;
+	__u32 dst_ip6[4];
+	__u32 dst_port;		/* host byte order */
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index bb1ab7da6103..26d643c171fd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2729,6 +2729,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
+	case BPF_SK_LOOKUP:
+		return BPF_PROG_TYPE_SK_LOOKUP;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -2778,6 +2780,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		ret = sk_lookup_prog_attach(attr, prog);
+		break;
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
@@ -2818,6 +2823,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 		return lirc_prog_detach(attr);
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		return skb_flow_dissector_bpf_prog_detach(attr);
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		return sk_lookup_prog_detach(attr);
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
@@ -2867,6 +2874,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
 		return skb_flow_dissector_prog_query(attr, uattr);
+	case BPF_SK_LOOKUP:
+		return sk_lookup_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index bc25bb1085b1..a00bdc70041c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9054,6 +9054,253 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
+
+static DEFINE_MUTEX(sk_lookup_prog_mutex);
+
+int sk_lookup_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+	int ret;
+
+	if (unlikely(attr->attach_flags))
+		return -EINVAL;
+
+	mutex_lock(&sk_lookup_prog_mutex);
+	ret = bpf_prog_attach_one(&net->sk_lookup_prog,
+				  &sk_lookup_prog_mutex, prog,
+				  attr->attach_flags);
+	mutex_unlock(&sk_lookup_prog_mutex);
+
+	return ret;
+}
+
+int sk_lookup_prog_detach(const union bpf_attr *attr)
+{
+	struct net *net = current->nsproxy->net_ns;
+	int ret;
+
+	if (unlikely(attr->attach_flags))
+		return -EINVAL;
+
+	mutex_lock(&sk_lookup_prog_mutex);
+	ret = bpf_prog_detach_one(&net->sk_lookup_prog,
+				  &sk_lookup_prog_mutex);
+	mutex_unlock(&sk_lookup_prog_mutex);
+
+	return ret;
+}
+
+int sk_lookup_prog_query(const union bpf_attr *attr,
+			 union bpf_attr __user *uattr)
+{
+	struct net *net;
+	int ret;
+
+	net = get_net_ns_by_fd(attr->query.target_fd);
+	if (IS_ERR(net))
+		return PTR_ERR(net);
+
+	ret = bpf_prog_query_one(&net->sk_lookup_prog, attr, uattr);
+
+	put_net(net);
+	return ret;
+}
+
+BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
+	   struct sock *, sk, u64, flags)
+{
+	if (unlikely(flags != 0))
+		return -EINVAL;
+	if (unlikely(!sk_fullsock(sk)))
+		return -ESOCKTNOSUPPORT;
+
+	/* Check if socket is suitable for packet L3/L4 protocol */
+	if (sk->sk_protocol != ctx->protocol)
+		return -EPROTOTYPE;
+	if (sk->sk_family != ctx->family &&
+	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
+		return -EAFNOSUPPORT;
+
+	/* Select socket as lookup result */
+	ctx->selected_sk = sk;
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sk_lookup_assign_proto = {
+	.func		= bpf_sk_lookup_assign,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_SOCK_COMMON,
+	.arg3_type	= ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto *
+sk_lookup_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_sk_assign:
+		return &bpf_sk_lookup_assign_proto;
+	case BPF_FUNC_sk_release:
+		return &bpf_sk_release_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+static bool sk_lookup_is_valid_access(int off, int size,
+				      enum bpf_access_type type,
+				      const struct bpf_prog *prog,
+				      struct bpf_insn_access_aux *info)
+{
+	const int size_default = sizeof(__u32);
+
+	if (off < 0 || off >= sizeof(struct bpf_sk_lookup))
+		return false;
+	if (off % size != 0)
+		return false;
+	if (type != BPF_READ)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range(struct bpf_sk_lookup, src_ip4):
+	case bpf_ctx_range(struct bpf_sk_lookup, dst_ip4):
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				src_ip6[0], src_ip6[3]):
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				dst_ip6[0], dst_ip6[3]):
+		if (!bpf_ctx_narrow_access_ok(off, size, size_default))
+			return false;
+		bpf_ctx_record_field_size(info, size_default);
+		break;
+
+	case bpf_ctx_range(struct bpf_sk_lookup, family):
+	case bpf_ctx_range(struct bpf_sk_lookup, protocol):
+	case bpf_ctx_range(struct bpf_sk_lookup, src_port):
+	case bpf_ctx_range(struct bpf_sk_lookup, dst_port):
+		if (size != size_default)
+			return false;
+		break;
+
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+#define CHECK_FIELD_SIZE(BPF_TYPE, BPF_FIELD, KERN_TYPE, KERN_FIELD)	\
+	BUILD_BUG_ON(sizeof_field(BPF_TYPE, BPF_FIELD) <		\
+		     sizeof_field(KERN_TYPE, KERN_FIELD))
+
+#define LOAD_FIELD_SIZE_OFF(TYPE, FIELD, SIZE, OFF)			\
+	BPF_LDX_MEM(SIZE, si->dst_reg, si->src_reg,			\
+		    bpf_target_off(TYPE, FIELD,				\
+				   sizeof_field(TYPE, FIELD),		\
+				   target_size) + (OFF))
+
+#define LOAD_FIELD_SIZE(TYPE, FIELD, SIZE) \
+	LOAD_FIELD_SIZE_OFF(TYPE, FIELD, SIZE, 0)
+
+#define LOAD_FIELD(TYPE, FIELD) \
+	LOAD_FIELD_SIZE(TYPE, FIELD, BPF_FIELD_SIZEOF(TYPE, FIELD))
+
+static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
+					const struct bpf_insn *si,
+					struct bpf_insn *insn_buf,
+					struct bpf_prog *prog,
+					u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+	int off;
+
+	switch (si->off) {
+	case offsetof(struct bpf_sk_lookup, family):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, family,
+				 struct bpf_sk_lookup_kern, family);
+		*insn++ = LOAD_FIELD(struct bpf_sk_lookup_kern, family);
+		break;
+
+	case offsetof(struct bpf_sk_lookup, protocol):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, protocol,
+				 struct bpf_sk_lookup_kern, protocol);
+		*insn++ = LOAD_FIELD(struct bpf_sk_lookup_kern, protocol);
+		break;
+
+	case offsetof(struct bpf_sk_lookup, src_ip4):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, src_ip4,
+				 struct bpf_sk_lookup_kern, v4.saddr);
+		*insn++ = LOAD_FIELD_SIZE(struct bpf_sk_lookup_kern, v4.saddr,
+					  BPF_SIZE(si->code));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, dst_ip4):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, dst_ip4,
+				 struct bpf_sk_lookup_kern, v4.daddr);
+		*insn++ = LOAD_FIELD_SIZE(struct bpf_sk_lookup_kern, v4.daddr,
+					  BPF_SIZE(si->code));
+
+		break;
+
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				src_ip6[0], src_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, src_ip6[0],
+				 struct bpf_sk_lookup_kern,
+				 v6.saddr.s6_addr32[0]);
+		off = si->off;
+		off -= offsetof(struct bpf_sk_lookup, src_ip6[0]);
+		*insn++ = LOAD_FIELD_SIZE_OFF(struct bpf_sk_lookup_kern,
+					      v6.saddr.s6_addr32[0],
+					      BPF_SIZE(si->code), off);
+#else
+		(void)off;
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				dst_ip6[0], dst_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, dst_ip6[0],
+				 struct bpf_sk_lookup_kern,
+				 v6.daddr.s6_addr32[0]);
+		off = si->off;
+		off -= offsetof(struct bpf_sk_lookup, dst_ip6[0]);
+		*insn++ = LOAD_FIELD_SIZE_OFF(struct bpf_sk_lookup_kern,
+					      v6.daddr.s6_addr32[0],
+					      BPF_SIZE(si->code), off);
+#else
+		(void)off;
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case offsetof(struct bpf_sk_lookup, src_port):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, src_port,
+				 struct bpf_sk_lookup_kern, sport);
+		*insn++ = LOAD_FIELD(struct bpf_sk_lookup_kern, sport);
+		break;
+
+	case offsetof(struct bpf_sk_lookup, dst_port):
+		CHECK_FIELD_SIZE(struct bpf_sk_lookup, dst_port,
+				 struct bpf_sk_lookup_kern, dport);
+		*insn++ = LOAD_FIELD(struct bpf_sk_lookup_kern, dport);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+const struct bpf_prog_ops sk_lookup_prog_ops = {
+};
+
+const struct bpf_verifier_ops sk_lookup_verifier_ops = {
+	.get_func_proto		= sk_lookup_func_proto,
+	.is_valid_access	= sk_lookup_is_valid_access,
+	.convert_ctx_access	= sk_lookup_convert_ctx_access,
+};
+
 #endif /* CONFIG_INET */
 
 DEFINE_BPF_DISPATCHER(xdp)
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index f43d193aff3a..70b1b033c721 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -398,6 +398,7 @@ class PrinterHelpers(Printer):
 
     type_fwds = [
             'struct bpf_fib_lookup',
+            'struct bpf_sk_lookup',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
@@ -437,6 +438,7 @@ class PrinterHelpers(Printer):
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
+            'struct bpf_sk_lookup',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
@@ -467,6 +469,11 @@ class PrinterHelpers(Printer):
             'struct sk_msg_buff': 'struct sk_msg_md',
             'struct xdp_buff': 'struct xdp_md',
     }
+    # Helpers overloaded for different context types.
+    overloaded_helpers = [
+        'bpf_get_socket_cookie',
+        'bpf_sk_assign',
+    ]
 
     def print_header(self):
         header = '''\
@@ -523,7 +530,7 @@ class PrinterHelpers(Printer):
         for i, a in enumerate(proto['args']):
             t = a['type']
             n = a['name']
-            if proto['name'] == 'bpf_get_socket_cookie' and i == 0:
+            if proto['name'] in self.overloaded_helpers and i == 0:
                     t = 'void'
                     n = 'ctx'
             one_arg = '{}{}'.format(comma, self.map_type(t))
-- 
2.25.3

