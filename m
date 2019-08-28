Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0729FB78
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfH1HW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:22:59 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:47024 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfH1HW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:22:59 -0400
Received: by mail-lf1-f67.google.com with SMTP id n19so1201537lfe.13
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQAJlhM2/o1EAhWxKBlXD0djLS38RxpAB/AQVyekaEI=;
        b=moABVPmZ5N1PtnGHPXQh72PA/wNK2s+S9fvLIpV/0JikWA/Ijnv4NuD9sUqpn1cJ6p
         sOOWQ+pSIHCecDpY0CP/PN2IIOOdoD0h7KABk7rshT2V7liIbg69i5aABbLJ2MoE09YU
         i0JtOMezl6EWfEZ1sZJrRxDeGxyYqu2L6fCdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQAJlhM2/o1EAhWxKBlXD0djLS38RxpAB/AQVyekaEI=;
        b=bCWooUc6zT6S05odAh7JHyvfMgdjQovKgDzpWNfQKVBhKYRAt2+lC5VSqxR2JY5Qum
         AhamttI7QGhqh5u/B38dpsppafpP5s40cR2dftc0AqR8Ao8nlORmkdPBmAhNeYSFdBF5
         8LBCQY9Z86UpXxHfmrIOQBN5u5EbE2M2beHSIzyytLFlQ1xa7Q8q8aORaJ8jtFCWFH0C
         Qrj8gQj2R56jaK/IX5anxg/PBQwoppkq5SygZbuxWcaGGunOHz246Yx74Q9J47pwRdWM
         WaNO2xUaAgjCz9p28ZoI8uoxBVB0kNyM4BI3oe6PUX5PmTk2LwvT0+5XIbuI2T35ey9b
         zPWw==
X-Gm-Message-State: APjAAAV6wTclwa2mX1n5FKVoNjRhEv4AlqIOgl/qOBEWqqQyDB+HQHf6
        c6NGJ7s6mvUVRIABVKE3Qj7LYg==
X-Google-Smtp-Source: APXvYqww7DHCVL3/Yop1Dc7nZD36o/VgwmklwASt18RdT/+Lw3iILYm28Avrv1+3gxr2AV2pww0Vhg==
X-Received: by 2002:a05:6512:24a:: with SMTP id b10mr1627277lfo.3.1566976976071;
        Wed, 28 Aug 2019 00:22:56 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id c197sm579556lfg.46.2019.08.28.00.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:22:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 02/12] bpf: Introduce inet_lookup program type for redirecting socket lookup
Date:   Wed, 28 Aug 2019 09:22:40 +0200
Message-Id: <20190828072250.29828-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new program type for redirecting the listening/bound socket lookup
from BPF. The program attaches to a network namespace. It is allowed to
select a socket from a SOCKARRAY, which will be used as a result of socket
lookup.

This provides a mechanism for programming the mapping between
local (address, port) pairs and listening/receiving sockets.

The program receives the 4-tuple, as well as the IP version and L4
protocol, of the packet that triggered the lookup as its context for making
a decision.

The netns-attached program is not called anywhere yet. Following patches
hook it up to ipv4 and ipv6 stacks.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf_types.h   |   1 +
 include/linux/filter.h      |  18 +++
 include/net/net_namespace.h |   2 +
 include/uapi/linux/bpf.h    |  58 ++++++++-
 kernel/bpf/syscall.c        |  10 ++
 kernel/bpf/verifier.c       |   7 +-
 net/core/filter.c           | 231 ++++++++++++++++++++++++++++++++++++
 7 files changed, 325 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 36a9c2325176..cc5c4ece748a 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -37,6 +37,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #endif
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
+BPF_PROG_TYPE(BPF_PROG_TYPE_INET_LOOKUP, inet_lookup)
 #endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 92c6e31fb008..5b1b3b754c28 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1229,4 +1229,22 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
+struct bpf_inet_lookup_kern {
+	unsigned short	family;
+	u8		protocol;
+	__be32		saddr;
+	struct in6_addr	saddr6;
+	__be16		sport;
+	__be32		daddr;
+	struct in6_addr	daddr6;
+	unsigned short	hnum;
+	struct sock	*redir_sk;
+};
+
+int inet_lookup_bpf_prog_attach(const union bpf_attr *attr,
+				struct bpf_prog *prog);
+int inet_lookup_bpf_prog_detach(const union bpf_attr *attr);
+int inet_lookup_bpf_prog_query(const union bpf_attr *attr,
+			       union bpf_attr __user *uattr);
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 4a9da951a794..bd01147cc064 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -171,6 +171,8 @@ struct net {
 #ifdef CONFIG_XDP_SOCKETS
 	struct netns_xdp	xdp;
 #endif
+	struct bpf_prog __rcu	*inet_lookup_prog;
+
 	struct sock		*diag_nlsk;
 	atomic_t		fnhe_genid;
 } __randomize_layout;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b5889257cc33..639abfa96779 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_INET_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_INET_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -2747,6 +2749,33 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * int bpf_redirect_lookup(struct bpf_inet_lookup *ctx, struct bpf_map *sockarray, void *key, u64 flags)
+ *	Description
+ *		Select a socket referenced by *map* (of type
+ *		**BPF_MAP_TYPE_REUSEPORT_SOCKARRAY**) at index *key* to use as a
+ *		result of listening (TCP) or bound (UDP) socket lookup.
+ *
+ *		The IP family and L4 protocol in *ctx* object, populated from
+ *		the packet that triggered the lookup, must match the selected
+ *		socket's family and protocol. IP6_V6ONLY socket option is
+ *		honored.
+ *
+ *		To be used by **BPF_INET_LOOKUP** programs attached to the
+ *		network namespace. Program needs to return **BPF_REDIRECT**, the
+ *		helper's success return value, for the selected socket to be
+ *		actually used.
+ *
+ *	Return
+ *		**BPF_REDIRECT** on success, if the socket at index *key* was selected.
+ *
+ *		**-EINVAL** if *flags* are invalid (not zero).
+ *
+ *		**-ENOENT** if there is no socket at index *key*.
+ *
+ *		**-EPROTOTYPE** if *ctx->protocol* does not match the socket protocol.
+ *
+ *		**-EAFNOSUPPORT** if socket does not accept IP version in *ctx->family*.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2859,7 +2888,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),		\
+	FN(redirect_lookup),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3116,6 +3146,32 @@ struct bpf_tcp_sock {
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
 };
 
+/* User accessible data for inet_lookup programs.
+ * New fields must be added at the end.
+ */
+struct bpf_inet_lookup {
+	__u32 family;		/* AF_INET, AF_INET6 */
+	__u32 protocol;		/* IPROTO_TCP, IPPROTO_UDP */
+	__u32 remote_ip4;	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_ip6[4];	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip6[4];	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_port;	/* Allows 4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_port;	/* Allows 4-byte read and write.
+				 * Stored in host byte order.
+				 */
+};
+
 struct bpf_sock_tuple {
 	union {
 		struct {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c0f62fd67c6b..763f2352ff7f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1935,6 +1935,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_SETSOCKOPT:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
 		break;
+	case BPF_INET_LOOKUP:
+		ptype = BPF_PROG_TYPE_INET_LOOKUP;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1959,6 +1962,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_INET_LOOKUP:
+		ret = inet_lookup_bpf_prog_attach(attr, prog);
+		break;
 	default:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 	}
@@ -2022,6 +2028,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_CGROUP_SETSOCKOPT:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
 		break;
+	case BPF_INET_LOOKUP:
+		return inet_lookup_bpf_prog_detach(attr);
 	default:
 		return -EINVAL;
 	}
@@ -2065,6 +2073,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
 		return skb_flow_dissector_prog_query(attr, uattr);
+	case BPF_INET_LOOKUP:
+		return inet_lookup_bpf_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 10c0ff93f52b..5717dd10cc4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3494,7 +3494,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 			goto error;
 		break;
 	case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
-		if (func_id != BPF_FUNC_sk_select_reuseport)
+		if (func_id != BPF_FUNC_sk_select_reuseport &&
+		    func_id != BPF_FUNC_redirect_lookup)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_QUEUE:
@@ -3578,6 +3579,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
 			goto error;
 		break;
+	case BPF_FUNC_redirect_lookup:
+		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
+			goto error;
+		break;
 	default:
 		break;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index a498fbaa2d50..d9375a7e60f5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9007,4 +9007,235 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
+
 #endif /* CONFIG_INET */
+
+static DEFINE_MUTEX(inet_lookup_prog_mutex);
+
+BPF_CALL_4(redirect_lookup, struct bpf_inet_lookup_kern *, ctx,
+	   struct bpf_map *, map, void *, key, u64, flags)
+{
+	struct sock_reuseport *reuse;
+	struct sock *redir_sk;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	/* Lookup socket in the map */
+	redir_sk = map->ops->map_lookup_elem(map, key);
+	if (!redir_sk)
+		return -ENOENT;
+
+	/* Check if socket got unhashed from sockets table, e.g. by
+	 * close(), after the above map_lookup_elem(). Treat it as
+	 * removed from the map.
+	 */
+	reuse = rcu_dereference(redir_sk->sk_reuseport_cb);
+	if (!reuse)
+		return -ENOENT;
+
+	/* Check protocol & family are a match */
+	if (ctx->protocol != redir_sk->sk_protocol)
+		return -EPROTOTYPE;
+	if (ctx->family != redir_sk->sk_family &&
+	    (redir_sk->sk_family == AF_INET || ipv6_only_sock(redir_sk)))
+		return -EAFNOSUPPORT;
+
+	/* Store socket in context */
+	ctx->redir_sk = redir_sk;
+
+	/* Signal redirect action */
+	return BPF_REDIRECT;
+}
+
+static const struct bpf_func_proto bpf_redirect_lookup_proto = {
+	.func		= redirect_lookup,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_PTR_TO_MAP_KEY,
+	.arg4_type	= ARG_ANYTHING,
+};
+
+static const struct bpf_func_proto *
+inet_lookup_func_proto(enum bpf_func_id func_id,
+		       const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_redirect_lookup:
+		return &bpf_redirect_lookup_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+int inet_lookup_bpf_prog_attach(const union bpf_attr *attr,
+				struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+
+	return bpf_prog_attach_one(&net->inet_lookup_prog,
+				   &inet_lookup_prog_mutex, prog,
+				   attr->attach_flags);
+}
+
+int inet_lookup_bpf_prog_detach(const union bpf_attr *attr)
+{
+	struct net *net = current->nsproxy->net_ns;
+
+	return bpf_prog_detach_one(&net->inet_lookup_prog,
+				   &inet_lookup_prog_mutex);
+}
+
+int inet_lookup_bpf_prog_query(const union bpf_attr *attr,
+			       union bpf_attr __user *uattr)
+{
+	struct net *net;
+	int ret;
+
+	net = get_net_ns_by_fd(attr->query.target_fd);
+	if (IS_ERR(net))
+		return PTR_ERR(net);
+
+	ret = bpf_prog_query_one(&net->inet_lookup_prog, attr, uattr);
+
+	put_net(net);
+	return ret;
+}
+
+static bool inet_lookup_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	const int size_default = sizeof(__u32);
+
+	if (off < 0 || off >= sizeof(struct bpf_inet_lookup))
+		return false;
+	if (off % size != 0)
+		return false;
+	if (type != BPF_READ)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range(struct bpf_inet_lookup, remote_ip4):
+	case bpf_ctx_range(struct bpf_inet_lookup, local_ip4):
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				remote_ip6[0], remote_ip6[3]):
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				local_ip6[0], local_ip6[3]):
+		if (!bpf_ctx_narrow_access_ok(off, size, size_default))
+			return false;
+		bpf_ctx_record_field_size(info, size_default);
+		break;
+
+	case bpf_ctx_range(struct bpf_inet_lookup, family):
+	case bpf_ctx_range(struct bpf_inet_lookup, protocol):
+	case bpf_ctx_range(struct bpf_inet_lookup, remote_port):
+	case bpf_ctx_range(struct bpf_inet_lookup, local_port):
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
+#define LOAD_FIELD_SIZE_OFF(TYPE, FIELD, SIZE, OFF) ({			\
+	*insn++ = BPF_LDX_MEM(SIZE, si->dst_reg, si->src_reg,		\
+			      bpf_target_off(TYPE, FIELD,		\
+					     FIELD_SIZEOF(TYPE, FIELD),	\
+					     target_size) + (OFF));	\
+})
+
+#define LOAD_FIELD_SIZE(TYPE, FIELD, SIZE) \
+	LOAD_FIELD_SIZE_OFF(TYPE, FIELD, SIZE, 0)
+
+#define LOAD_FIELD(TYPE, FIELD) \
+	LOAD_FIELD_SIZE(TYPE, FIELD, BPF_FIELD_SIZEOF(TYPE, FIELD))
+
+static u32 inet_lookup_convert_ctx_access(enum bpf_access_type type,
+					  const struct bpf_insn *si,
+					  struct bpf_insn *insn_buf,
+					  struct bpf_prog *prog,
+					  u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+	int off;
+
+	switch (si->off) {
+	case offsetof(struct bpf_inet_lookup, family):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, family);
+		break;
+
+	case offsetof(struct bpf_inet_lookup, protocol):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, protocol);
+		break;
+
+	case offsetof(struct bpf_inet_lookup, remote_ip4):
+		LOAD_FIELD_SIZE(struct bpf_inet_lookup_kern, saddr,
+				BPF_SIZE(si->code));
+		break;
+
+	case offsetof(struct bpf_inet_lookup, local_ip4):
+		LOAD_FIELD_SIZE(struct bpf_inet_lookup_kern, daddr,
+				BPF_SIZE(si->code));
+
+		break;
+
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				remote_ip6[0], remote_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		off = si->off;
+		off -= offsetof(struct bpf_inet_lookup, remote_ip6[0]);
+
+		LOAD_FIELD_SIZE_OFF(struct bpf_inet_lookup_kern,
+				    saddr6.s6_addr32[0],
+				    BPF_SIZE(si->code), off);
+#else
+		(void)off;
+
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				local_ip6[0], local_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		off = si->off;
+		off -= offsetof(struct bpf_inet_lookup, local_ip6[0]);
+
+		LOAD_FIELD_SIZE_OFF(struct bpf_inet_lookup_kern,
+				    daddr6.s6_addr32[0],
+				    BPF_SIZE(si->code), off);
+#else
+		(void)off;
+
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case offsetof(struct bpf_inet_lookup, remote_port):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, sport);
+		break;
+
+	case offsetof(struct bpf_inet_lookup, local_port):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, hnum);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+const struct bpf_prog_ops inet_lookup_prog_ops = {
+};
+
+const struct bpf_verifier_ops inet_lookup_verifier_ops = {
+	.get_func_proto		= inet_lookup_func_proto,
+	.is_valid_access	= inet_lookup_is_valid_access,
+	.convert_ctx_access	= inet_lookup_convert_ctx_access,
+};
-- 
2.20.1

