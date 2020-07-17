Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A70223964
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQKft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgGQKfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33462C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:43 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h22so12028953lji.9
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fIPQnbw2wbHehQCZ7xITYvuj9wO0lxCjZPd5KX1ZzJk=;
        b=A0Qeq/vk4jRkacRVy7Tap+CtoW1tZwuHDVOapefwZkWh7MuJ/Q7pjtz+dlzn2LvZTU
         pKwMsrf7YMrTPubXThBAHlJJ92w9DGRqIuOhKbpx4glZm2G+dXjQ+n92Qm25v40Cx4cj
         zS8IOlFE6jl9JBrFYg7TpOvyJlH1UOq3i+sT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fIPQnbw2wbHehQCZ7xITYvuj9wO0lxCjZPd5KX1ZzJk=;
        b=MbaRXAWaTKZC30B2I2r3zWD+ArbeOXugulVwpZ8xqylh6LywPLLjlCmU4/rQIhxrJj
         20HRwtOb5gqxL9arPdONvpGVW6WHX3wRaThJfvINZ2Rmqf60Okt2Z2j+RMC65VaXtEld
         lU5J0XaesRUvuTNNczN4aKHjn249Eff8SwHYitUJ264LhKEQtz2OHXParz/HaJlwdeiN
         mp5udHJix03Wv5UTruf2oQRA6Mk7cJ9SNaOL9rzAKTrEin4y3O7p46KMs4fd5CdkPsFW
         Gp7Kj2OW9dmTmIdunTG8Gnu0N6gKxU1p5eIkc/wtxV1yFJV7vrTcKyzxW4SIe0UuYv7C
         JxPQ==
X-Gm-Message-State: AOAM531lv4v1GqhZwapyuZ6FOOIOLfjKmqZoHZvZYsEqTExC06FaGkeJ
        aNf+ouwPYP3qo/lljQj03JMslw==
X-Google-Smtp-Source: ABdhPJwl+So8vfkObg83r5KbeOUW878f07y7f33nxhyk62UPbC86QFYpUo9jWMnt7Ej7B2M4IWUIPw==
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr4368574ljj.312.1594982141333;
        Fri, 17 Jul 2020 03:35:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p4sm1066246lfk.0.2020.07.17.03.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:40 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v5 02/15] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
Date:   Fri, 17 Jul 2020 12:35:23 +0200
Message-Id: <20200717103536.397595-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
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

In its basic form, SK_LOOKUP acts as a filter and hence must return either
SK_PASS or SK_DROP. If the program returns with SK_PASS, transport should
look for a socket to receive the packet, or use the one selected by the
program if available, while SK_DROP informs the transport layer that the
lookup should fail.

This patch only enables the user to attach an SK_LOOKUP program to a
network namespace. Subsequent patches hook it up to run on local delivery
path in ipv4 and ipv6 stacks.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v5:
    - Enforce that return value is either SK_PASS or SK_DROP. (Andrii)
    - Use a case {} block avoid a conditional variable declaration. (Andrii)
    - Enable bpf_perf_event_output from the start. (Andrii)
    
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
 kernel/bpf/verifier.c      |  13 ++-
 net/core/filter.c          | 180 +++++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py |   9 +-
 10 files changed, 312 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
index 47d5b0c708c9..722f799c1a2e 100644
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
index c8c9eabcd106..adb16bdc5f0a 100644
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
index 0b0144752d78..fa1ea12ad2cd 100644
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
index 7ac3992dacfe..54d0c886e3ba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -189,6 +189,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_STRUCT_OPS,
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
+	BPF_PROG_TYPE_SK_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -228,6 +229,7 @@ enum bpf_attach_type {
 	BPF_XDP_DEVMAP,
 	BPF_CGROUP_INET_SOCK_RELEASE,
 	BPF_XDP_CPUMAP,
+	BPF_SK_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3069,6 +3071,10 @@ union bpf_attr {
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
@@ -3094,6 +3100,56 @@ union bpf_attr {
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
@@ -3607,6 +3663,12 @@ enum {
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
@@ -4349,4 +4411,19 @@ struct bpf_pidns_info {
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
index e9c8e26ac8f2..38b368bccda2 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -373,6 +373,8 @@ static int netns_bpf_max_progs(enum netns_bpf_attach_type type)
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
 		return 1;
+	case NETNS_BPF_SK_LOOKUP:
+		return 64;
 	default:
 		return 0;
 	}
@@ -403,6 +405,9 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
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
index 7ea9dfbebd8c..d07417d17712 100644
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
@@ -2953,6 +2960,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
+	case BPF_SK_LOOKUP:
 		return netns_bpf_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
@@ -3891,6 +3899,7 @@ static int link_create(union bpf_attr *attr)
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_SK_LOOKUP:
 		ret = netns_bpf_link_create(attr, prog);
 		break;
 	default:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..9a6703bc3f36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3878,10 +3878,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
@@ -7354,6 +7358,9 @@ static int check_return_code(struct bpf_verifier_env *env)
 			return -ENOTSUPP;
 		}
 		break;
+	case BPF_PROG_TYPE_SK_LOOKUP:
+		range = tnum_range(SK_DROP, SK_PASS);
+		break;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
diff --git a/net/core/filter.c b/net/core/filter.c
index bdd2382e655d..d099436b3ff5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9229,6 +9229,186 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
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
+	case BPF_FUNC_perf_event_output:
+		return &bpf_event_output_data_proto;
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
+				remote_ip6[0], remote_ip6[3]): {
+#if IS_ENABLED(CONFIG_IPV6)
+		int off = si->off;
+
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
+	}
+	case bpf_ctx_range_till(struct bpf_sk_lookup,
+				local_ip6[0], local_ip6[3]): {
+#if IS_ENABLED(CONFIG_IPV6)
+		int off = si->off;
+
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
+	}
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

