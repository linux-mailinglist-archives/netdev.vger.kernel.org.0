Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BADDFCE56
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKNS55 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727276AbfKNS5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:54 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEIhOdu030164
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:54 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8qj9e1d7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:54 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 10:57:52 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 979F076071B; Thu, 14 Nov 2019 10:57:51 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Date:   Thu, 14 Nov 2019 10:57:15 -0800
Message-ID: <20191114185720.1641606-16-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1034 mlxlogscore=999 suspectscore=3 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Annotate BPF program context types with program-side type and kernel-side type.
This type information is used by the verifier. btf_get_prog_ctx_type() is
used in the later patches to verify that BTF type of ctx in BPF program matches to
kernel expected ctx type. For example, the XDP program type is:
BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp, struct xdp_md, struct xdp_buff)
That means that XDP program should be written as:
int xdp_prog(struct xdp_md *ctx) { ... }

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h       |  11 +++-
 include/linux/bpf_types.h |  78 +++++++++++++++++---------
 kernel/bpf/btf.c          | 114 +++++++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c      |   4 +-
 kernel/bpf/verifier.c     |   2 +-
 net/core/filter.c         |  10 ----
 6 files changed, 176 insertions(+), 43 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cb5a356381f5..9c48f11fe56e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -747,7 +747,7 @@ DECLARE_PER_CPU(int, bpf_prog_active);
 extern const struct file_operations bpf_map_fops;
 extern const struct file_operations bpf_prog_fops;
 
-#define BPF_PROG_TYPE(_id, _name) \
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	extern const struct bpf_prog_ops _name ## _prog_ops; \
 	extern const struct bpf_verifier_ops _name ## _verifier_ops;
 #define BPF_MAP_TYPE(_id, _ops) \
@@ -1213,6 +1213,15 @@ static inline u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 #endif
 
 #ifdef CONFIG_INET
+struct sk_reuseport_kern {
+	struct sk_buff *skb;
+	struct sock *sk;
+	struct sock *selected_sk;
+	void *data_end;
+	u32 hash;
+	u32 reuseport_id;
+	bool bind_inany;
+};
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info);
 
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index de14872b01ba..93740b3614d7 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -2,42 +2,68 @@
 /* internal file - do not include directly */
 
 #ifdef CONFIG_NET
-BPF_PROG_TYPE(BPF_PROG_TYPE_SOCKET_FILTER, sk_filter)
-BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_CLS, tc_cls_act)
-BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_ACT, tc_cls_act)
-BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SOCKET_FILTER, sk_filter,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_CLS, tc_cls_act,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SCHED_ACT, tc_cls_act,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp,
+	      struct xdp_md, struct xdp_buff)
 #ifdef CONFIG_CGROUP_BPF
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SKB, cg_skb)
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCK, cg_sock)
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCK_ADDR, cg_sock_addr)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SKB, cg_skb,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCK, cg_sock,
+	      struct bpf_sock, struct sock)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCK_ADDR, cg_sock_addr,
+	      struct bpf_sock_addr, struct bpf_sock_addr_kern)
 #endif
-BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_IN, lwt_in)
-BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_OUT, lwt_out)
-BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_XMIT, lwt_xmit)
-BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_SEG6LOCAL, lwt_seg6local)
-BPF_PROG_TYPE(BPF_PROG_TYPE_SOCK_OPS, sock_ops)
-BPF_PROG_TYPE(BPF_PROG_TYPE_SK_SKB, sk_skb)
-BPF_PROG_TYPE(BPF_PROG_TYPE_SK_MSG, sk_msg)
-BPF_PROG_TYPE(BPF_PROG_TYPE_FLOW_DISSECTOR, flow_dissector)
+BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_IN, lwt_in,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_OUT, lwt_out,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_XMIT, lwt_xmit,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_LWT_SEG6LOCAL, lwt_seg6local,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SOCK_OPS, sock_ops,
+	      struct bpf_sock_ops, struct bpf_sock_ops_kern)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SK_SKB, sk_skb,
+	      struct __sk_buff, struct sk_buff)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SK_MSG, sk_msg,
+	      struct sk_msg_md, struct sk_msg)
+BPF_PROG_TYPE(BPF_PROG_TYPE_FLOW_DISSECTOR, flow_dissector,
+	      struct __sk_buff, struct bpf_flow_dissector)
 #endif
 #ifdef CONFIG_BPF_EVENTS
-BPF_PROG_TYPE(BPF_PROG_TYPE_KPROBE, kprobe)
-BPF_PROG_TYPE(BPF_PROG_TYPE_TRACEPOINT, tracepoint)
-BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event)
-BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
-BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
-BPF_PROG_TYPE(BPF_PROG_TYPE_TRACING, tracing)
+BPF_PROG_TYPE(BPF_PROG_TYPE_KPROBE, kprobe,
+	      bpf_user_pt_regs_t, struct pt_regs)
+BPF_PROG_TYPE(BPF_PROG_TYPE_TRACEPOINT, tracepoint,
+	      __u64, u64)
+BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event,
+	      struct bpf_perf_event_data, struct bpf_perf_event_data_kern)
+BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint,
+	      struct bpf_raw_tracepoint_args, u64)
+BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable,
+	      struct bpf_raw_tracepoint_args, u64)
+BPF_PROG_TYPE(BPF_PROG_TYPE_TRACING, tracing,
+	      void *, void *)
 #endif
 #ifdef CONFIG_CGROUP_BPF
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
-BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev,
+	      struct bpf_cgroup_dev_ctx, struct bpf_cgroup_dev_ctx)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl,
+	      struct bpf_sysctl, struct bpf_sysctl_kern)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt,
+	      struct bpf_sockopt, struct bpf_sockopt_kern)
 #endif
 #ifdef CONFIG_BPF_LIRC_MODE2
-BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
+BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
+	      __u32, u32)
 #endif
 #ifdef CONFIG_INET
-BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
+BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport,
+	      struct sk_reuseport_md, struct sk_reuseport_kern)
 #endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 033d071eb59c..4b7c8bd423d6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2018 Facebook */
 
 #include <uapi/linux/btf.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/bpf_perf_event.h>
 #include <uapi/linux/types.h>
 #include <linux/seq_file.h>
 #include <linux/compiler.h>
@@ -16,6 +18,9 @@
 #include <linux/sort.h>
 #include <linux/bpf_verifier.h>
 #include <linux/btf.h>
+#include <linux/skmsg.h>
+#include <linux/perf_event.h>
+#include <net/sock.h>
 
 /* BTF (BPF Type Format) is the meta data format which describes
  * the data types of BPF program/map.  Hence, it basically focus
@@ -3439,13 +3444,98 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 
 extern char __weak _binary__btf_vmlinux_bin_start[];
 extern char __weak _binary__btf_vmlinux_bin_end[];
+extern struct btf *btf_vmlinux;
+
+#define BPF_MAP_TYPE(_id, _ops)
+static union {
+	struct bpf_ctx_convert {
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
+	prog_ctx_type _id##_prog; \
+	kern_ctx_type _id##_kern;
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+	} *__t;
+	/* 't' is written once under lock. Read many times. */
+	const struct btf_type *t;
+} bpf_ctx_convert;
+enum {
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
+	__ctx_convert##_id,
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+};
+static u8 bpf_ctx_convert_map[] = {
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
+	[_id] = __ctx_convert##_id,
+#include <linux/bpf_types.h>
+#undef BPF_PROG_TYPE
+};
+#undef BPF_MAP_TYPE
+
+static const struct btf_member *
+btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
+		      const struct btf_type *t, enum bpf_prog_type prog_type)
+{
+	const struct btf_type *conv_struct;
+	const struct btf_type *ctx_struct;
+	const struct btf_member *ctx_type;
+	const char *tname, *ctx_tname;
+
+	conv_struct = bpf_ctx_convert.t;
+	if (!conv_struct) {
+		bpf_log(log, "btf_vmlinux is malformed\n");
+		return NULL;
+	}
+	t = btf_type_by_id(btf, t->type);
+	while (btf_type_is_modifier(t))
+		t = btf_type_by_id(btf, t->type);
+	if (!btf_type_is_struct(t)) {
+		/* Only pointer to struct is supported for now.
+		 * That means that BPF_PROG_TYPE_TRACEPOINT with BTF
+		 * is not supported yet.
+		 * BPF_PROG_TYPE_RAW_TRACEPOINT is fine.
+		 */
+		bpf_log(log, "BPF program ctx type is not a struct\n");
+		return NULL;
+	}
+	tname = btf_name_by_offset(btf, t->name_off);
+	if (!tname) {
+		bpf_log(log, "BPF program ctx struct doesn't have a name\n");
+		return NULL;
+	}
+	/* prog_type is valid bpf program type. No need for bounds check. */
+	ctx_type = btf_type_member(conv_struct) + bpf_ctx_convert_map[prog_type] * 2;
+	/* ctx_struct is a pointer to prog_ctx_type in vmlinux.
+	 * Like 'struct __sk_buff'
+	 */
+	ctx_struct = btf_type_by_id(btf_vmlinux, ctx_type->type);
+	if (!ctx_struct)
+		/* should not happen */
+		return NULL;
+	ctx_tname = btf_name_by_offset(btf_vmlinux, ctx_struct->name_off);
+	if (!ctx_tname) {
+		/* should not happen */
+		bpf_log(log, "Please fix kernel include/linux/bpf_types.h\n");
+		return NULL;
+	}
+	/* only compare that prog's ctx type name is the same as
+	 * kernel expects. No need to compare field by field.
+	 * It's ok for bpf prog to do:
+	 * struct __sk_buff {};
+	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
+	 * { // no fields of skb are ever used }
+	 */
+	if (strcmp(ctx_tname, tname))
+		return NULL;
+	return ctx_type;
+}
 
 struct btf *btf_parse_vmlinux(void)
 {
 	struct btf_verifier_env *env = NULL;
 	struct bpf_verifier_log *log;
 	struct btf *btf = NULL;
-	int err;
+	int err, i;
 
 	env = kzalloc(sizeof(*env), GFP_KERNEL | __GFP_NOWARN);
 	if (!env)
@@ -3479,6 +3569,26 @@ struct btf *btf_parse_vmlinux(void)
 	if (err)
 		goto errout;
 
+	/* find struct bpf_ctx_convert for type checking later */
+	for (i = 1; i <= btf->nr_types; i++) {
+		const struct btf_type *t;
+		const char *tname;
+
+		t = btf_type_by_id(btf, i);
+		if (!__btf_type_is_struct(t))
+			continue;
+		tname = __btf_name_by_offset(btf, t->name_off);
+		if (!strcmp(tname, "bpf_ctx_convert")) {
+			/* btf_parse_vmlinux() runs under bpf_verifier_lock */
+			bpf_ctx_convert.t = t;
+			break;
+		}
+	}
+	if (i > btf->nr_types) {
+		err = -ENOENT;
+		goto errout;
+	}
+
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
 	return btf;
@@ -3492,8 +3602,6 @@ struct btf *btf_parse_vmlinux(void)
 	return ERR_PTR(err);
 }
 
-extern struct btf *btf_vmlinux;
-
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e2e37bea86bc..05a0ee75eca0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -43,7 +43,7 @@ static DEFINE_SPINLOCK(map_idr_lock);
 int sysctl_unprivileged_bpf_disabled __read_mostly;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
-#define BPF_PROG_TYPE(_id, _ops)
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
 #define BPF_MAP_TYPE(_id, _ops) \
 	[_id] = &_ops,
 #include <linux/bpf_types.h>
@@ -1189,7 +1189,7 @@ static int map_freeze(const union bpf_attr *attr)
 }
 
 static const struct bpf_prog_ops * const bpf_prog_types[] = {
-#define BPF_PROG_TYPE(_id, _name) \
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] = & _name ## _prog_ops,
 #define BPF_MAP_TYPE(_id, _ops)
 #include <linux/bpf_types.h>
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e78ec7990767..7395d6bebefd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23,7 +23,7 @@
 #include "disasm.h"
 
 static const struct bpf_verifier_ops * const bpf_verifier_ops[] = {
-#define BPF_PROG_TYPE(_id, _name) \
+#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
 	[_id] = & _name ## _verifier_ops,
 #define BPF_MAP_TYPE(_id, _ops)
 #include <linux/bpf_types.h>
diff --git a/net/core/filter.c b/net/core/filter.c
index f72face90659..49ded4a7588a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8684,16 +8684,6 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 }
 
 #ifdef CONFIG_INET
-struct sk_reuseport_kern {
-	struct sk_buff *skb;
-	struct sock *sk;
-	struct sock *selected_sk;
-	void *data_end;
-	u32 hash;
-	u32 reuseport_id;
-	bool bind_inany;
-};
-
 static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 				    struct sock_reuseport *reuse,
 				    struct sock *sk, struct sk_buff *skb,
-- 
2.23.0

