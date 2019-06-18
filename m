Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B44A155
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfFRNA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:00:57 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35434 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFRNA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:00:56 -0400
Received: by mail-lj1-f196.google.com with SMTP id x25so3440411ljh.2
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NO0kNLFRwXEdeJH8dwknA9A2F4vZ/ldyZLNuu9mlmKw=;
        b=xiuwKYTNf48dhMiX0fICdvka1sbFK4qu4dFPOMEs+GOlMliudAgzdZOrJ9w0KjhSbJ
         yw5Q2lPsDUr3c5gemU+Gwd4Thd9qMfznacVPNlUAQ96aa7bViPI/c56NvQNTODs2lgW9
         LbuXKvQUdmtYSXYVQV91o8QUNTtzZGP/BBy34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NO0kNLFRwXEdeJH8dwknA9A2F4vZ/ldyZLNuu9mlmKw=;
        b=lwDt047Bue3JbdVB01fZgMJlCP4fZRO8aKf5q62iGOT/Ijy5ued56Qdq//z1vnV/B/
         7SMmNdfHOoDSAwrWTpdba8TzFcfB3RTUUSaJD8RkprbjvDf94NnitTuspyLMl7dgNAQR
         DTDVKjVsvtZIh43OG7rBiQ8Bho2/cnq6nHbgDPl2KfJjz210+IwDYTtZ16ZSyVUUgZ48
         QqY+ioBsRBpa9nn8HgMP3reBifmTl6H7qFN0J8hkWAPAVkCvEQjKgpSBEWU8wS9hWQQw
         tLWc7b/2KXM9mNhm0vbuO9es3PLtmHBT9Eg0Nb3XrEbPVowgtO/NSmCDAy4aZy7YTBQp
         Wz+A==
X-Gm-Message-State: APjAAAWJGarKByG7Xk+m+hV+W0Aiyx8E/Sz1y2Mf3/NpjU7ELHuE0K6M
        YNMWiMf0Fcylf03jyDZSuK+ajunIEZaoFg==
X-Google-Smtp-Source: APXvYqxBDE+/M8Su3PELgt+zO+2LBj7hmraH2fyxgZ0ZLCwxRzOaqD1b6UF3DDy7DxjLlS1iiXYPyQ==
X-Received: by 2002:a2e:98f:: with SMTP id 137mr15570625ljj.232.1560862853293;
        Tue, 18 Jun 2019 06:00:53 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id r17sm1398558ljb.77.2019.06.18.06.00.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:52 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: [RFC bpf-next 1/7] bpf: Introduce inet_lookup program type
Date:   Tue, 18 Jun 2019 15:00:44 +0200
Message-Id: <20190618130050.8344-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new BPF program type that attaches to the network namespace.  Its
purpose is to run before the listening socket lookup so that we can
override the destination IP and/or port from BPF.

The inet_lookup program receives the lookup 4-tuple via context as input
for making a decision. It is allowed to overwrite the local IP & port that
are used for looking up a listening socket.

The program is not called anywhere yet. We hook it up to ipv4 and ipv6
stacks in subsequent patches.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf_types.h   |   1 +
 include/linux/filter.h      |  17 +++
 include/net/net_namespace.h |   3 +
 include/uapi/linux/bpf.h    |  27 +++++
 kernel/bpf/syscall.c        |  10 ++
 net/core/filter.c           | 216 ++++++++++++++++++++++++++++++++++++
 6 files changed, 274 insertions(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 5a9975678d6f..9f1424146de8 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -36,6 +36,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #endif
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
+BPF_PROG_TYPE(BPF_PROG_TYPE_INET_LOOKUP, inet_lookup)
 #endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 43b45d6db36d..f826fca6cc1c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1199,4 +1199,21 @@ struct bpf_sysctl_kern {
 	u64 tmp_reg;
 };
 
+#ifdef CONFIG_INET
+struct bpf_inet_lookup_kern {
+	unsigned short	family;
+	__be32		saddr;
+	struct in6_addr	saddr6;
+	__be16		sport;
+	__be32		daddr;
+	struct in6_addr	daddr6;
+	unsigned short	hnum;
+};
+
+int inet_lookup_attach_bpf(const union bpf_attr *attr, struct bpf_prog *prog);
+int inet_lookup_detach_bpf(const union bpf_attr *attr);
+int inet_lookup_query_bpf(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr);
+#endif
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index abb4f92456e1..6f2e5ecc8b08 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -167,6 +167,9 @@ struct net {
 #endif
 #ifdef CONFIG_XDP_SOCKETS
 	struct netns_xdp	xdp;
+#endif
+#ifdef CONFIG_BPF_SYSCALL
+	struct bpf_prog __rcu	*inet_lookup_prog;
 #endif
 	struct sock		*diag_nlsk;
 	atomic_t		fnhe_genid;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d0a23476f887..7776f36a43d1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_INET_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -192,6 +193,7 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_INET_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3066,6 +3068,31 @@ struct bpf_tcp_sock {
 				 */
 };
 
+/* User accessible data for inet_lookup programs.
+ * New fields must be added at the end.
+ */
+struct bpf_inet_lookup {
+	__u32 family;
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
index 4c53cbd3329d..57813c539a41 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1916,6 +1916,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_SYSCTL:
 		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
 		break;
+	case BPF_INET_LOOKUP:
+		ptype = BPF_PROG_TYPE_INET_LOOKUP;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1940,6 +1943,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_INET_LOOKUP:
+		ret = inet_lookup_attach_bpf(attr, prog);
+		break;
 	default:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 	}
@@ -1997,6 +2003,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_CGROUP_SYSCTL:
 		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
 		break;
+	case BPF_INET_LOOKUP:
+		return inet_lookup_detach_bpf(attr);
 	default:
 		return -EINVAL;
 	}
@@ -2036,6 +2044,8 @@ static int bpf_prog_query(const union bpf_attr *attr,
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
 		return skb_flow_dissector_prog_query(attr, uattr);
+	case BPF_INET_LOOKUP:
+		return inet_lookup_query_bpf(attr, uattr);
 	default:
 		return -EINVAL;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 8c18f2781afa..439e8eccb018 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8716,4 +8716,220 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
+
+static DEFINE_MUTEX(inet_lookup_prog_mutex);
+
+int inet_lookup_attach_bpf(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct bpf_prog *attached;
+
+	mutex_lock(&inet_lookup_prog_mutex);
+	attached = rcu_dereference_protected(net->inet_lookup_prog,
+					     lockdep_is_held(&inet_lookup_prog_mutex));
+	if (attached) {
+		/* Only one BPF program can be attached at a time */
+		mutex_unlock(&inet_lookup_prog_mutex);
+		return -EEXIST;
+	}
+	rcu_assign_pointer(net->inet_lookup_prog, prog);
+	mutex_unlock(&inet_lookup_prog_mutex);
+	return 0;
+}
+
+int inet_lookup_detach_bpf(const union bpf_attr *attr)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct bpf_prog *attached;
+
+	mutex_lock(&inet_lookup_prog_mutex);
+	attached = rcu_dereference_protected(net->inet_lookup_prog,
+					     lockdep_is_held(&inet_lookup_prog_mutex));
+	if (!attached) {
+		mutex_unlock(&inet_lookup_prog_mutex);
+		return -ENOENT;
+	}
+	bpf_prog_put(attached);
+	RCU_INIT_POINTER(net->inet_lookup_prog, NULL);
+	mutex_unlock(&inet_lookup_prog_mutex);
+
+	return 0;
+}
+
+int inet_lookup_query_bpf(const union bpf_attr *attr,
+			  union bpf_attr __user *uattr)
+{
+	return -EOPNOTSUPP;	/* TODO: Not implemented. */
+}
+
+static const struct bpf_func_proto *
+inet_lookup_func_proto(enum bpf_func_id func_id,
+		       const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
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
+
+	switch (off) {
+	case bpf_ctx_range(struct bpf_inet_lookup, remote_ip4):
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				remote_ip6[0], remote_ip6[3]):
+		if (type != BPF_READ)
+			return false;
+		if (!bpf_ctx_narrow_access_ok(off, size, size_default))
+			return false;
+		bpf_ctx_record_field_size(info, size_default);
+		break;
+
+	case bpf_ctx_range(struct bpf_inet_lookup, local_ip4):
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				local_ip6[0], local_ip6[3]):
+		if (type == BPF_READ) {
+			if (!bpf_ctx_narrow_access_ok(off, size, size_default))
+				return false;
+			bpf_ctx_record_field_size(info, size_default);
+		} else {
+			if (size != size_default)
+				return false;
+		}
+		break;
+
+	case bpf_ctx_range(struct bpf_inet_lookup, family):
+	case bpf_ctx_range(struct bpf_inet_lookup, remote_port):
+		if (type != BPF_READ)
+			return false;
+		if (size != size_default)
+			return false;
+		break;
+
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
+#define LOAD_FIELD_OFF(STRUCT, FIELD, OFF) ({				\
+	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(STRUCT, FIELD),		\
+			      si->dst_reg, si->src_reg,			\
+			      bpf_target_off(STRUCT, FIELD,		\
+					     FIELD_SIZEOF(STRUCT,	\
+							  FIELD),	\
+					     target_size) + (OFF));	\
+})
+
+#define LOAD_FIELD(STRUCT, FIELD) LOAD_FIELD_OFF(STRUCT, FIELD, 0)
+
+#define STORE_FIELD_OFF(STRUCT, FIELD, OFF) ({				\
+	*insn++ = BPF_STX_MEM(BPF_FIELD_SIZEOF(STRUCT, FIELD),		\
+			      si->dst_reg, si->src_reg,			\
+			      bpf_target_off(STRUCT, FIELD,		\
+					     FIELD_SIZEOF(STRUCT,	\
+							  FIELD),	\
+					     target_size) + (OFF));	\
+})
+
+#define STORE_FIELD(STRUCT, FIELD) STORE_FIELD_OFF(STRUCT, FIELD, 0)
+
+/* TODO: Handle 1,2-byte reads from {local,remote}_ip[46]. */
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
+	case offsetof(struct bpf_inet_lookup, remote_ip4):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, saddr);
+		break;
+
+	case offsetof(struct bpf_inet_lookup, local_ip4):
+		if (type == BPF_READ)
+			LOAD_FIELD(struct bpf_inet_lookup_kern, daddr);
+		else
+			STORE_FIELD(struct bpf_inet_lookup_kern, daddr);
+		break;
+
+	case bpf_ctx_range_till(struct bpf_inet_lookup,
+				remote_ip6[0], remote_ip6[3]):
+#if IS_ENABLED(CONFIG_IPV6)
+		off = si->off;
+		off -= offsetof(struct bpf_inet_lookup, remote_ip6[0]);
+
+		LOAD_FIELD_OFF(struct bpf_inet_lookup_kern,
+			       saddr6.s6_addr32[0], off);
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
+		if (type == BPF_READ)
+			LOAD_FIELD_OFF(struct bpf_inet_lookup_kern,
+				       daddr6.s6_addr32[0], off);
+		else
+			STORE_FIELD_OFF(struct bpf_inet_lookup_kern,
+					daddr6.s6_addr32[0], off);
+#else
+		(void)off;
+
+		if (type == BPF_READ)
+			*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case offsetof(struct bpf_inet_lookup, remote_port):
+		LOAD_FIELD(struct bpf_inet_lookup_kern, sport);
+		break;
+
+	case offsetof(struct bpf_inet_lookup, local_port):
+		if (type == BPF_READ)
+			LOAD_FIELD(struct bpf_inet_lookup_kern, hnum);
+		else
+			STORE_FIELD(struct bpf_inet_lookup_kern, hnum);
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
+
 #endif /* CONFIG_INET */
-- 
2.20.1

