Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDB621DEFE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgGMRrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbgGMRrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:01 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73324C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:01 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y13so9600602lfe.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7bIusmK25t+OvYXtTDBqMTp8M1en4/Qe8ODN3kY6Mb8=;
        b=Xsqfq1e+xdTAC0c7tjEdwIoCDSwNjUjQiZzfj0P6IJ14XNdwt0UwEL1dF0+LQMypNk
         9iZ5neOOyUKN0qQaeMDuegpTgeCtj1bN3c2RUM8aoEQGF0euFboqc/k61tdvvnmIgM1d
         B0lD5ELrlJrpzMzsw3Bo4PsCn4uNO/lkrbnMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bIusmK25t+OvYXtTDBqMTp8M1en4/Qe8ODN3kY6Mb8=;
        b=mM2oMAmKNy7vAT5mDeYVKGwUHLfS3tmyGyGyT/b0mulCRB7UudPOR3zvyD/bQUxRyF
         FlJTR0qRv+2HEjJDKyqhLYmiOkO6QASvqMG+LLIzxY3k2d2zyCm5yFGveeK1rKzrzr/F
         pOjomLRduvNeA9NvFl+O6s4s/gqA5eegbN9lYQQwo8mc4Q4jU4KAxpkQa96CVbw1UsRP
         HMy1/y//yoGeOvi3NtLqxv6MOdEqbmOuAdELNLnfA6V8macxyMCdclRemIOGHgpvi/lU
         oj/Tz9la1pz5IGIvzya84HzzWHtanD1FAzjzaiYr2JQh1mqeV46aUwv9nw4vErX92vrg
         hLHA==
X-Gm-Message-State: AOAM531V0MflPd8mXOZKai42omIWiLMBLIx1Kv9kqyNCAh3/owusEpkY
        hcBHN5jAlMA/RyO6q2+fq0Ly+w==
X-Google-Smtp-Source: ABdhPJwPwJD4cu+xD/Sj8sDOFsFTEzkAzA2g43TxEErlWhmNsfUR23wSTG+ESF8oyNEE4pQvBl5lww==
X-Received: by 2002:a19:c886:: with SMTP id y128mr170115lff.98.1594662419713;
        Mon, 13 Jul 2020 10:46:59 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z16sm4162112ljg.68.2020.07.13.10.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:46:59 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v4 02/16] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
Date:   Mon, 13 Jul 2020 19:46:40 +0200
Message-Id: <20200713174654.642628-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new program type BPF_PROG_TYPE_SK_LOOKUP with a dedicated attach type
BPF_SK_LOOKUP. The new program kind is to be invoked by the transport layer
when looking up a listening socket for a new connection request for
connection oriented protocols, or when looking up an unconnected socket for
a packet for connection-less protocols.

When called, SK_LOOKUP BPF program can select a socket that will receive
the packet. This serves as a mechanism to overcome the limits of what
bind() API allows to express. Two use-cases driving this work are:

 (1) steer packets destined to an IP range, on fixed port to a socket

     192.0.2.0/24, port 80 -> NGINX socket

 (2) steer packets destined to an IP address, on any port to a socket

     198.51.100.1, any port -> L7 proxy socket

In its run-time context program receives information about the packet that
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
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Reintroduce narrow load support for most BPF context fields. (Yonghong)
    - Fix null-ptr-deref in BPF context access when IPv6 address not set.
    - Unpack v4/v6 IP address union in bpf_sk_lookup context type.
    - Add verifier support for ARG_PTR_TO_SOCKET_OR_NULL.
    - Allow resetting socket selection with bpf_sk_assign(ctx, NULL).
    - Document that bpf_sk_assign accepts a NULL socket.
    
    v3:
    - Allow bpf_sk_assign helper to replace previously selected socket only
      when BPF_SK_LOOKUP_F_REPLACE flag is set, as a precaution for multiple
      programs running in series to accidentally override each other's verdict.
    - Let BPF program decide that load-balancing within a reuseport socket group
      should be skipped for the socket selected with bpf_sk_assign() by passing
      BPF_SK_LOOKUP_F_NO_REUSEPORT flag. (Martin)
    - Extend struct bpf_sk_lookup program context with an 'sk' field containing
      the selected socket with an intention for multiple attached program
      running in series to see each other's choices. However, currently the
      verifier doesn't allow checking if pointer is set.
    - Use bpf-netns infra for link-based multi-program attachment. (Alexei)
    - Get rid of macros in convert_ctx_access to make it easier to read.
    - Disallow 1-,2-byte access to context fields containing IP addresses.
    
    v2:
    - Make bpf_sk_assign reject sockets that don't use RCU freeing.
      Update bpf_sk_assign docs accordingly. (Martin)
    - Change bpf_sk_assign proto to take PTR_TO_SOCKET as argument. (Martin)
    - Fix broken build when CONFIG_INET is not selected. (Martin)
    - Rename bpf_sk_lookup{} src_/dst_* fields remote_/local_*. (Martin)
    - Enforce BPF_SK_LOOKUP attach point on load & attach. (Martin)

 include/linux/bpf-netns.h  |   3 +
 include/linux/bpf.h        |   1 +
 include/linux/bpf_types.h  |   2 +
 include/linux/filter.h     |  17 ++++
 include/uapi/linux/bpf.h   |  77 ++++++++++++++++
 kernel/bpf/net_namespace.c |   5 ++
 kernel/bpf/syscall.c       |   9 ++
 kernel/bpf/verifier.c      |  10 ++-
 net/core/filter.c          | 179 +++++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py |   9 +-
 10 files changed, 308 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
index 4052d649f36d..cb1d849c5d4f 100644
--- a/include/linux/bpf-netns.h
+++ b/include/linux/bpf-netns.h
@@ -8,6 +8,7 @@
 enum netns_bpf_attach_type {
 	NETNS_BPF_INVALID = -1,
 	NETNS_BPF_FLOW_DISSECTOR = 0,
+	NETNS_BPF_SK_LOOKUP,
 	MAX_NETNS_BPF_ATTACH_TYPE
 };
 
@@ -17,6 +18,8 @@ to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
 	switch (attach_type) {
 	case BPF_FLOW_DISSECTOR:
 		return NETNS_BPF_FLOW_DISSECTOR;
+	case BPF_SK_LOOKUP:
+		return NETNS_BPF_SK_LOOKUP;
 	default:
 		return NETNS_BPF_INVALID;
 	}
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ad9c61ae8640..f092d13bdd08 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -249,6 +249,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_INT,		/* pointer to int */
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
+	ARG_PTR_TO_SOCKET_OR_NULL,	/* pointer to bpf_sock (fullsock) or NULL */
 	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
 	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
 	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index a18ae82a298a..a52a5688418e 100644
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
index 259377723603..380746f47fa1 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1278,4 +1278,21 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
+struct bpf_sk_lookup_kern {
+	u16		family;
+	u16		protocol;
+	struct {
+		__be32 saddr;
+		__be32 daddr;
+	} v4;
+	struct {
+		const struct in6_addr *saddr;
+		const struct in6_addr *daddr;
+	} v6;
+	__be16		sport;
+	u16		dport;
+	struct sock	*selected_sk;
+	bool		no_reuseport;
+};
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 548a749aebb3..e2ffeb150d0f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -189,6 +189,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -227,6 +228,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
 	BPF_CGROUP_INET_SOCK_RELEASE,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3068,6 +3070,10 @@ union bpf_attr {
  *
  * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
  *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SCHED_CLS** and
+ *		**BPF_PROG_TYPE_SCHED_ACT** programs.
+ *
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
  *		will cause *skb* to be delivered to the specified socket.
@@ -3093,6 +3099,56 @@ union bpf_attr {
  *		**-ESOCKTNOSUPPORT** if the socket type is not supported
  *		(reuseport).
  *
+ * long bpf_sk_assign(struct bpf_sk_lookup *ctx, struct bpf_sock *sk, u64 flags)
+ *	Description
+ *		Helper is overloaded depending on BPF program type. This
+ *		description applies to **BPF_PROG_TYPE_SK_LOOKUP** programs.
+ *
+ *		Select the *sk* as a result of a socket lookup.
+ *
+ *		For the operation to succeed passed socket must be compatible
+ *		with the packet description provided by the *ctx* object.
+ *
+ *		L4 protocol (**IPPROTO_TCP** or **IPPROTO_UDP**) must
+ *		be an exact match. While IP family (**AF_INET** or
+ *		**AF_INET6**) must be compatible, that is IPv6 sockets
+ *		that are not v6-only can be selected for IPv4 packets.
+ *
+ *		Only TCP listeners and UDP unconnected sockets can be
+ *		selected. *sk* can also be NULL to reset any previous
+ *		selection.
+ *
+ *		*flags* argument can combination of following values:
+ *
+ *		* **BPF_SK_LOOKUP_F_REPLACE** to override the previous
+ *		  socket selection, potentially done by a BPF program
+ *		  that ran before us.
+ *
+ *		* **BPF_SK_LOOKUP_F_NO_REUSEPORT** to skip
+ *		  load-balancing within reuseport group for the socket
+ *		  being selected.
+ *
+ *		On success *ctx->sk* will point to the selected socket.
+ *
+ *	Return
+ *		0 on success, or a negative errno in case of failure.
+ *
+ *		* **-EAFNOSUPPORT** if socket family (*sk->family*) is
+ *		  not compatible with packet family (*ctx->family*).
+ *
+ *		* **-EEXIST** if socket has been already selected,
+ *		  potentially by another program, and
+ *		  **BPF_SK_LOOKUP_F_REPLACE** flag was not specified.
+ *
+ *		* **-EINVAL** if unsupported flags were specified.
+ *
+ *		* **-EPROTOTYPE** if socket L4 protocol
+ *		  (*sk->protocol*) doesn't match packet protocol
+ *		  (*ctx->protocol*).
+ *
+ *		* **-ESOCKTNOSUPPORT** if socket is not in allowed
+ *		  state (TCP listening or UDP unconnected).
+ *
  * u64 bpf_ktime_get_boot_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
@@ -3605,6 +3661,12 @@ enum {
 	BPF_RINGBUF_HDR_SZ		= 8,
 };
 
+/* BPF_FUNC_sk_assign flags in bpf_sk_lookup context. */
+enum {
+	BPF_SK_LOOKUP_F_REPLACE		= (1ULL << 0),
+	BPF_SK_LOOKUP_F_NO_REUSEPORT	= (1ULL << 1),
+};
+
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
 	BPF_ADJ_ROOM_NET,
@@ -4334,4 +4396,19 @@ struct bpf_pidns_info {
 	__u32 pid;
 	__u32 tgid;
 };
+
+/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
+struct bpf_sk_lookup {
+	__bpf_md_ptr(struct bpf_sock *, sk); /* Selected socket */
+
+	__u32 family;		/* Protocol family (AF_INET, AF_INET6) */
+	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
+	__u32 remote_ip4;	/* Network byte order */
+	__u32 remote_ip6[4];	/* Network byte order */
+	__u32 remote_port;	/* Network byte order */
+	__u32 local_ip4;	/* Network byte order */
+	__u32 local_ip6[4];	/* Network byte order */
+	__u32 local_port;	/* Host byte order */
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 988c2766ec97..596c30b963f3 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -359,6 +359,8 @@ static int netns_bpf_max_progs(enum netns_bpf_attach_type type)
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
 		return 1;
+	case NETNS_BPF_SK_LOOKUP:
+		return 64;
 	default:
 		return 0;
 	}
@@ -389,6 +391,9 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	case NETNS_BPF_FLOW_DISSECTOR:
 		err = flow_dissector_bpf_prog_attach_check(net, link->prog);
 		break;
+	case NETNS_BPF_SK_LOOKUP:
+		err = 0; /* nothing to check */
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 156f51ffada2..945975a14582 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2022,6 +2022,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		if (expected_attach_type == BPF_SK_LOOKUP)
+			return 0;
+		return -EINVAL;
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
 			return -EINVAL;
@@ -2756,6 +2760,7 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_SK_LOOKUP:
 		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		if (!capable(CAP_NET_ADMIN))
@@ -2817,6 +2822,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
 		return BPF_PROG_TYPE_TRACING;
+	case BPF_SK_LOOKUP:
+		return BPF_PROG_TYPE_SK_LOOKUP;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -2955,6 +2962,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
+	case BPF_SK_LOOKUP:
 		return netns_bpf_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
@@ -3888,6 +3896,7 @@ static int link_create(union bpf_attr *attr)
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_SK_LOOKUP:
 		ret = netns_bpf_link_create(attr, prog);
 		break;
 	default:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2196523c9716..cc6cc92c19e2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3879,10 +3879,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			}
 			meta->ref_obj_id = reg->ref_obj_id;
 		}
-	} else if (arg_type == ARG_PTR_TO_SOCKET) {
+	} else if (arg_type == ARG_PTR_TO_SOCKET ||
+		   arg_type == ARG_PTR_TO_SOCKET_OR_NULL) {
 		expected_type = PTR_TO_SOCKET;
-		if (type != expected_type)
-			goto err_type;
+		if (!(register_is_null(reg) &&
+		      arg_type == ARG_PTR_TO_SOCKET_OR_NULL)) {
+			if (type != expected_type)
+				goto err_type;
+		}
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
diff --git a/net/core/filter.c b/net/core/filter.c
index ddcc0d6209e1..81c462881133 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9220,6 +9220,185 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
+
+BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
+	   struct sock *, sk, u64, flags)
+{
+	if (unlikely(flags & ~(BPF_SK_LOOKUP_F_REPLACE |
+			       BPF_SK_LOOKUP_F_NO_REUSEPORT)))
+		return -EINVAL;
+	if (unlikely(sk && sk_is_refcounted(sk)))
+		return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
+	if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
+		return -ESOCKTNOSUPPORT; /* reject connected sockets */
+
+	/* Check if socket is suitable for packet L3/L4 protocol */
+	if (sk && sk->sk_protocol != ctx->protocol)
+		return -EPROTOTYPE;
+	if (sk && sk->sk_family != ctx->family &&
+	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
+		return -EAFNOSUPPORT;
+
+	if (ctx->selected_sk && !(flags & BPF_SK_LOOKUP_F_REPLACE))
+		return -EEXIST;
+
+	/* Select socket as lookup result */
+	ctx->selected_sk = sk;
+	ctx->no_reuseport = flags & BPF_SK_LOOKUP_F_NO_REUSEPORT;
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sk_lookup_assign_proto = {
+	.func		= bpf_sk_lookup_assign,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_SOCKET_OR_NULL,
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
+	if (off < 0 || off >= sizeof(struct bpf_sk_lookup))
+		return false;
+	if (off % size != 0)
+		return false;
+	if (type != BPF_READ)
+		return false;
+
+	switch (off) {
+	case offsetof(struct bpf_sk_lookup, sk):
+		info->reg_type = PTR_TO_SOCKET_OR_NULL;
+		return size == sizeof(__u64);
+
+	case bpf_ctx_range(struct bpf_sk_lookup, family):
+	case bpf_ctx_range(struct bpf_sk_lookup, protocol):
+	case bpf_ctx_range(struct bpf_sk_lookup, remote_ip4):
+	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
+	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
+	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
+	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
+		bpf_ctx_record_field_size(info, sizeof(__u32));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
+
+	default:
+		return false;
+	}
+}
+
+static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
+					const struct bpf_insn *si,
+					struct bpf_insn *insn_buf,
+					struct bpf_prog *prog,
+					u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+#if IS_ENABLED(CONFIG_IPV6)
+	int off;
+#endif
+
+	switch (si->off) {
+	case offsetof(struct bpf_sk_lookup, sk):
+		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sk_lookup_kern, selected_sk));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, family):
+		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     family, 2, target_size));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, protocol):
+		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     protocol, 2, target_size));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, remote_ip4):
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     v4.saddr, 4, target_size));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, local_ip4):
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     v4.daddr, 4, target_size));
+		break;
+
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				remote_ip6[0], remote_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		off = si->off;
+		off -= offsetof(struct bpf_sk_lookup, remote_ip6[0]);
+		off += bpf_target_off(struct in6_addr, s6_addr32[0], 4, target_size);
+		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sk_lookup_kern, v6.saddr));
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
+#else
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				local_ip6[0], local_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		off = si->off;
+		off -= offsetof(struct bpf_sk_lookup, local_ip6[0]);
+		off += bpf_target_off(struct in6_addr, s6_addr32[0], 4, target_size);
+		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg, si->src_reg,
+				      offsetof(struct bpf_sk_lookup_kern, v6.daddr));
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg, off);
+#else
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case offsetof(struct bpf_sk_lookup, remote_port):
+		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     sport, 2, target_size));
+		break;
+
+	case offsetof(struct bpf_sk_lookup, local_port):
+		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
+				      bpf_target_off(struct bpf_sk_lookup_kern,
+						     dport, 2, target_size));
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
index 6843376733df..5bfa448b4704 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -404,6 +404,7 @@ class PrinterHelpers(Printer):
 
     type_fwds = [
             'struct bpf_fib_lookup',
+            'struct bpf_sk_lookup',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
@@ -450,6 +451,7 @@ class PrinterHelpers(Printer):
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
+            'struct bpf_sk_lookup',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
@@ -487,6 +489,11 @@ class PrinterHelpers(Printer):
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
@@ -543,7 +550,7 @@ class PrinterHelpers(Printer):
         for i, a in enumerate(proto['args']):
             t = a['type']
             n = a['name']
-            if proto['name'] == 'bpf_get_socket_cookie' and i == 0:
+            if proto['name'] in self.overloaded_helpers and i == 0:
                     t = 'void'
                     n = 'ctx'
             one_arg = '{}{}'.format(comma, self.map_type(t))
-- 
2.25.4

