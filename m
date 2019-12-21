Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE171287C9
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 07:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfLUG0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 01:26:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22376 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfLUG0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 01:26:16 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBL6QD4l013751
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=i1X0IhASjDK7bcsGKpOqcoOCSgruHOVgnJ5I/rLKNOg=;
 b=a/lmtwfMGrpVTlWSkHRzd+0oo0egR/KohxQmRP3oyO9p4NZU/jNqeD0CRT8NhiMiMgoU
 bnMAZOO0KbfrgXQWkqyQbQL8BHPHvRCWPzNszzAXv/p3i7K6COqACXpyH4r1Y5DJhKKx
 bbY0eQG+2Cv0/U4fSB9SGOfBrj3QTKoDnEk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x0s98df29-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 22:26:14 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Dec 2019 22:26:11 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3774F2946127; Fri, 20 Dec 2019 22:26:11 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 07/11] bpf: tcp: Support tcp_congestion_ops in bpf
Date:   Fri, 20 Dec 2019 22:26:11 -0800
Message-ID: <20191221062611.1183363-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191221062556.1182261-1-kafai@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-21_01:2019-12-17,2019-12-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 suspectscore=13
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912210054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes "struct tcp_congestion_ops" to be the first user
of BPF STRUCT_OPS.  It allows implementing a tcp_congestion_ops
in bpf.

The BPF implemented tcp_congestion_ops can be used like
regular kernel tcp-cc through sysctl and setsockopt.  e.g.
[root@arch-fb-vm1 bpf]# sysctl -a | egrep congestion
net.ipv4.tcp_allowed_congestion_control = reno cubic bpf_cubic
net.ipv4.tcp_available_congestion_control = reno bic cubic bpf_cubic
net.ipv4.tcp_congestion_control = bpf_cubic

There has been attempt to move the TCP CC to the user space
(e.g. CCP in TCP).   The common arguments are faster turn around,
get away from long-tail kernel versions in production...etc,
which are legit points.

BPF has been the continuous effort to join both kernel and
userspace upsides together (e.g. XDP to gain the performance
advantage without bypassing the kernel).  The recent BPF
advancements (in particular BTF-aware verifier, BPF trampoline,
BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
possible in BPF.  It allows a faster turnaround for testing algorithm
in the production while leveraging the existing (and continue growing)
BPF feature/framework instead of building one specifically for
userspace TCP CC.

This patch allows write access to a few fields in tcp-sock
(in bpf_tcp_ca_btf_struct_access()).

The optional "get_info" is unsupported now.  It can be added
later.  One possible way is to output the info with a btf-id
to describe the content.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h            |   2 +
 include/net/tcp.h                 |   1 +
 kernel/bpf/bpf_struct_ops_types.h |   7 +-
 net/core/filter.c                 |   2 +-
 net/ipv4/Makefile                 |   4 +
 net/ipv4/bpf_tcp_ca.c             | 226 ++++++++++++++++++++++++++++++
 net/ipv4/tcp_cong.c               |  14 +-
 net/ipv4/tcp_ipv4.c               |   6 +-
 net/ipv4/tcp_minisocks.c          |   4 +-
 net/ipv4/tcp_output.c             |   4 +-
 10 files changed, 255 insertions(+), 15 deletions(-)
 create mode 100644 net/ipv4/bpf_tcp_ca.c

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 69d6706fc889..6256511bbd6d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -843,6 +843,8 @@ int bpf_prog_create(struct bpf_prog **pfp, struct sock_fprog_kern *fprog);
 int bpf_prog_create_from_user(struct bpf_prog **pfp, struct sock_fprog *fprog,
 			      bpf_aux_classic_check_t trans, bool save_orig);
 void bpf_prog_destroy(struct bpf_prog *fp);
+const struct bpf_func_proto *
+bpf_base_func_proto(enum bpf_func_id func_id);
 
 int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk);
 int sk_attach_bpf(u32 ufd, struct sock *sk);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 86b9a8766648..fd87fa1df603 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1007,6 +1007,7 @@ enum tcp_ca_ack_event_flags {
 #define TCP_CONG_NON_RESTRICTED 0x1
 /* Requires ECN/ECT set on all packets */
 #define TCP_CONG_NEEDS_ECN	0x2
+#define TCP_CONG_MASK	(TCP_CONG_NON_RESTRICTED | TCP_CONG_NEEDS_ECN)
 
 union tcp_cc_info;
 
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 7bb13ff49ec2..066d83ea1c99 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* internal file - do not include directly */
 
-/* To be filled in a later patch */
+#ifdef CONFIG_BPF_JIT
+#ifdef CONFIG_INET
+#include <net/tcp.h>
+BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
+#endif
+#endif
diff --git a/net/core/filter.c b/net/core/filter.c
index 217af9974c86..63dcd0bdcb1f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5934,7 +5934,7 @@ bool bpf_helper_changes_pkt_data(void *func)
 	return false;
 }
 
-static const struct bpf_func_proto *
+const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
 	switch (func_id) {
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index d57ecfaf89d4..7360d9b3eaad 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -65,3 +65,7 @@ obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o xfrm4_protocol.o
+
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-$(CONFIG_BPF_JIT) += bpf_tcp_ca.o
+endif
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
new file mode 100644
index 000000000000..1114339ee57d
--- /dev/null
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook  */
+
+#include <linux/types.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/filter.h>
+#include <net/tcp.h>
+
+static u32 optional_ops[] = {
+	offsetof(struct tcp_congestion_ops, init),
+	offsetof(struct tcp_congestion_ops, release),
+	offsetof(struct tcp_congestion_ops, set_state),
+	offsetof(struct tcp_congestion_ops, cwnd_event),
+	offsetof(struct tcp_congestion_ops, in_ack_event),
+	offsetof(struct tcp_congestion_ops, pkts_acked),
+	offsetof(struct tcp_congestion_ops, min_tso_segs),
+	offsetof(struct tcp_congestion_ops, sndbuf_expand),
+	offsetof(struct tcp_congestion_ops, cong_control),
+};
+
+static u32 unsupported_ops[] = {
+	offsetof(struct tcp_congestion_ops, get_info),
+};
+
+static const struct btf_type *tcp_sock_type;
+static u32 tcp_sock_id, sock_id;
+
+static int bpf_tcp_ca_init(struct btf *_btf_vmlinux)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(_btf_vmlinux, "sock", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	sock_id = type_id;
+
+	type_id = btf_find_by_name_kind(_btf_vmlinux, "tcp_sock",
+					BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
+	tcp_sock_id = type_id;
+	tcp_sock_type = btf_type_by_id(_btf_vmlinux, tcp_sock_id);
+
+	return 0;
+}
+
+static bool check_optional(u32 member_offset)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(optional_ops); i++) {
+		if (member_offset == optional_ops[i])
+			return true;
+	}
+
+	return false;
+}
+
+static bool check_unsupported(u32 member_offset)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(unsupported_ops); i++) {
+		if (member_offset == unsupported_ops[i])
+			return true;
+	}
+
+	return false;
+}
+
+extern struct btf *btf_vmlinux;
+
+static bool bpf_tcp_ca_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
+		return false;
+
+	if (!btf_ctx_access(off, size, type, prog, info))
+		return false;
+
+	if (info->reg_type == PTR_TO_BTF_ID && info->btf_id == sock_id)
+		/* promote it to tcp_sock */
+		info->btf_id = tcp_sock_id;
+
+	return true;
+}
+
+static int bpf_tcp_ca_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf_type *t, int off,
+					int size, enum bpf_access_type atype,
+					u32 *next_btf_id)
+{
+	size_t end;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, t, off, size, atype, next_btf_id);
+
+	if (t != tcp_sock_type) {
+		bpf_log(log, "only read is supported\n");
+		return -EACCES;
+	}
+
+	switch (off) {
+	case bpf_ctx_range(struct inet_connection_sock, icsk_ca_priv):
+		end = offsetofend(struct inet_connection_sock, icsk_ca_priv);
+		break;
+	case offsetof(struct inet_connection_sock, icsk_ack.pending):
+		end = offsetofend(struct inet_connection_sock,
+				  icsk_ack.pending);
+		break;
+	case offsetof(struct tcp_sock, snd_cwnd):
+		end = offsetofend(struct tcp_sock, snd_cwnd);
+		break;
+	case offsetof(struct tcp_sock, snd_cwnd_cnt):
+		end = offsetofend(struct tcp_sock, snd_cwnd_cnt);
+		break;
+	case offsetof(struct tcp_sock, snd_ssthresh):
+		end = offsetofend(struct tcp_sock, snd_ssthresh);
+		break;
+	case offsetof(struct tcp_sock, ecn_flags):
+		end = offsetofend(struct tcp_sock, ecn_flags);
+		break;
+	default:
+		bpf_log(log, "no write support to tcp_sock at off %d\n", off);
+		return -EACCES;
+	}
+
+	if (off + size > end) {
+		bpf_log(log,
+			"write access at off %d with size %d beyond the member of tcp_sock ended at %zu\n",
+			off, size, end);
+		return -EACCES;
+	}
+
+	return NOT_INIT;
+}
+
+static const struct bpf_func_proto *
+bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
+			  const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
+	.get_func_proto		= bpf_tcp_ca_get_func_proto,
+	.is_valid_access	= bpf_tcp_ca_is_valid_access,
+	.btf_struct_access	= bpf_tcp_ca_btf_struct_access,
+};
+
+static int bpf_tcp_ca_init_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  void *kdata, const void *udata)
+{
+	const struct tcp_congestion_ops *utcp_ca;
+	struct tcp_congestion_ops *tcp_ca;
+	size_t tcp_ca_name_len;
+	int prog_fd;
+	u32 moff;
+
+	utcp_ca = (const struct tcp_congestion_ops *)udata;
+	tcp_ca = (struct tcp_congestion_ops *)kdata;
+
+	moff = btf_member_bit_offset(t, member) / 8;
+	switch (moff) {
+	case offsetof(struct tcp_congestion_ops, flags):
+		if (utcp_ca->flags & ~TCP_CONG_MASK)
+			return -EINVAL;
+		tcp_ca->flags = utcp_ca->flags;
+		return 1;
+	case offsetof(struct tcp_congestion_ops, name):
+		tcp_ca_name_len = strnlen(utcp_ca->name, sizeof(utcp_ca->name));
+		if (!tcp_ca_name_len ||
+		    tcp_ca_name_len == sizeof(utcp_ca->name))
+			return -EINVAL;
+		memcpy(tcp_ca->name, utcp_ca->name, sizeof(tcp_ca->name));
+		return 1;
+	}
+
+	if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type, NULL))
+		return 0;
+
+	/* Ensure bpf_prog is provided for compulsory func ptr */
+	prog_fd = (int)(*(unsigned long *)(udata + moff));
+	if (!prog_fd && !check_optional(moff) && !check_unsupported(moff))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int bpf_tcp_ca_check_member(const struct btf_type *t,
+				   const struct btf_member *member)
+{
+	if (check_unsupported(btf_member_bit_offset(t, member) / 8))
+		return -ENOTSUPP;
+	return 0;
+}
+
+static int bpf_tcp_ca_reg(void *kdata)
+{
+	return tcp_register_congestion_control(kdata);
+}
+
+static void bpf_tcp_ca_unreg(void *kdata)
+{
+	tcp_unregister_congestion_control(kdata);
+}
+
+struct bpf_struct_ops bpf_tcp_congestion_ops = {
+	.verifier_ops = &bpf_tcp_ca_verifier_ops,
+	.reg = bpf_tcp_ca_reg,
+	.unreg = bpf_tcp_ca_unreg,
+	.check_member = bpf_tcp_ca_check_member,
+	.init_member = bpf_tcp_ca_init_member,
+	.init = bpf_tcp_ca_init,
+	.name = "tcp_congestion_ops",
+};
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 3737ec096650..dc27f21bd815 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -162,7 +162,7 @@ void tcp_assign_congestion_control(struct sock *sk)
 
 	rcu_read_lock();
 	ca = rcu_dereference(net->ipv4.tcp_congestion_control);
-	if (unlikely(!try_module_get(ca->owner)))
+	if (unlikely(!bpf_try_module_get(ca, ca->owner)))
 		ca = &tcp_reno;
 	icsk->icsk_ca_ops = ca;
 	rcu_read_unlock();
@@ -208,7 +208,7 @@ void tcp_cleanup_congestion_control(struct sock *sk)
 
 	if (icsk->icsk_ca_ops->release)
 		icsk->icsk_ca_ops->release(sk);
-	module_put(icsk->icsk_ca_ops->owner);
+	bpf_module_put(icsk->icsk_ca_ops, icsk->icsk_ca_ops->owner);
 }
 
 /* Used by sysctl to change default congestion control */
@@ -222,12 +222,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(net, name);
 	if (!ca) {
 		ret = -ENOENT;
-	} else if (!try_module_get(ca->owner)) {
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
 		ret = -EBUSY;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-			module_put(prev->owner);
+			bpf_module_put(prev, prev->owner);
 
 		ca->flags |= TCP_CONG_NON_RESTRICTED;
 		ret = 0;
@@ -366,19 +366,19 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	} else if (!load) {
 		const struct tcp_congestion_ops *old_ca = icsk->icsk_ca_ops;
 
-		if (try_module_get(ca->owner)) {
+		if (bpf_try_module_get(ca, ca->owner)) {
 			if (reinit) {
 				tcp_reinit_congestion_control(sk, ca);
 			} else {
 				icsk->icsk_ca_ops = ca;
-				module_put(old_ca->owner);
+				bpf_module_put(old_ca, old_ca->owner);
 			}
 		} else {
 			err = -EBUSY;
 		}
 	} else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) || cap_net_admin)) {
 		err = -EPERM;
-	} else if (!try_module_get(ca->owner)) {
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
 		err = -EBUSY;
 	} else {
 		tcp_reinit_congestion_control(sk, ca);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 26637fce324d..45a88358168a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2619,7 +2619,8 @@ static void __net_exit tcp_sk_exit(struct net *net)
 	int cpu;
 
 	if (net->ipv4.tcp_congestion_control)
-		module_put(net->ipv4.tcp_congestion_control->owner);
+		bpf_module_put(net->ipv4.tcp_congestion_control,
+			       net->ipv4.tcp_congestion_control->owner);
 
 	for_each_possible_cpu(cpu)
 		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.tcp_sk, cpu));
@@ -2726,7 +2727,8 @@ static int __net_init tcp_sk_init(struct net *net)
 
 	/* Reno is always built in */
 	if (!net_eq(net, &init_net) &&
-	    try_module_get(init_net.ipv4.tcp_congestion_control->owner))
+	    bpf_try_module_get(init_net.ipv4.tcp_congestion_control,
+			       init_net.ipv4.tcp_congestion_control->owner))
 		net->ipv4.tcp_congestion_control = init_net.ipv4.tcp_congestion_control;
 	else
 		net->ipv4.tcp_congestion_control = &tcp_reno;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c802bc80c400..ad3b56d9fa71 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -414,7 +414,7 @@ void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
 
 		rcu_read_lock();
 		ca = tcp_ca_find_key(ca_key);
-		if (likely(ca && try_module_get(ca->owner))) {
+		if (likely(ca && bpf_try_module_get(ca, ca->owner))) {
 			icsk->icsk_ca_dst_locked = tcp_ca_dst_locked(dst);
 			icsk->icsk_ca_ops = ca;
 			ca_got_dst = true;
@@ -425,7 +425,7 @@ void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
 	/* If no valid choice made yet, assign current system default ca. */
 	if (!ca_got_dst &&
 	    (!icsk->icsk_ca_setsockopt ||
-	     !try_module_get(icsk->icsk_ca_ops->owner)))
+	     !bpf_try_module_get(icsk->icsk_ca_ops, icsk->icsk_ca_ops->owner)))
 		tcp_assign_congestion_control(sk);
 
 	tcp_set_ca_state(sk, TCP_CA_Open);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b184f03d7437..8e7187732ac1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3356,8 +3356,8 @@ static void tcp_ca_dst_init(struct sock *sk, const struct dst_entry *dst)
 
 	rcu_read_lock();
 	ca = tcp_ca_find_key(ca_key);
-	if (likely(ca && try_module_get(ca->owner))) {
-		module_put(icsk->icsk_ca_ops->owner);
+	if (likely(ca && bpf_try_module_get(ca, ca->owner))) {
+		bpf_module_put(icsk->icsk_ca_ops, icsk->icsk_ca_ops->owner);
 		icsk->icsk_ca_dst_locked = tcp_ca_dst_locked(dst);
 		icsk->icsk_ca_ops = ca;
 	}
-- 
2.17.1

