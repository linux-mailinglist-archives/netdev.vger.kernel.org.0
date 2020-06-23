Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D5320570A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733071AbgFWQSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733036AbgFWQSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NG6CAK011481
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=V/0MbfT5ZHE3J9X/9itkxJ4xCRMnYfkQ0hvEz5cnPtM=;
 b=Zgk3PSJMH0OxSZG8AXwsVOps4TBoEdY06n89azQQf2sSanS73+27BQ3istbI5qd3zygx
 ymlihAWCXpWm4K6SruWMSeHMPeUvOtiWr/ua7EH0lPDCBI9D3aLm9BoTFiek1UzoxA7l
 SCBMrJdtgrr8jfjRUAiOoiSMSwWWoD7njCQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2r0pxc-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:28 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:17:57 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 30423370330A; Tue, 23 Jun 2020 09:17:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 05/15] bpf: add bpf_skc_to_tcp6_sock() helper
Date:   Tue, 23 Jun 2020 09:17:56 -0700
Message-ID: <20200623161756.2500736-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=29 phishscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper is used in tracing programs to cast a socket
pointer to a tcp6_sock pointer.
The return value could be NULL if the casting is illegal.

A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
so the verifier is able to deduce proper return types for the helper.

Different from the previous BTF_ID based helpers,
the bpf_skc_to_tcp6_sock() argument can be several possible
btf_ids. More specifically, all possible socket data structures
with sock_common appearing in the first in the memory layout.
This patch only added socket types related to tcp and udp.

All possible argument btf_id and return value btf_id
for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
cached. In the future, it is even possible to precompute
these btf_id's at kernel build time.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h            | 12 +++++
 include/uapi/linux/bpf.h       |  9 +++-
 kernel/bpf/btf.c               |  1 +
 kernel/bpf/verifier.c          | 43 +++++++++++++-----
 kernel/trace/bpf_trace.c       |  2 +
 net/core/filter.c              | 82 ++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 +
 tools/include/uapi/linux/bpf.h |  9 +++-
 8 files changed, 148 insertions(+), 12 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1e1501ee53ce..c0e38ad07848 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -265,6 +265,7 @@ enum bpf_return_type {
 	RET_PTR_TO_TCP_SOCK_OR_NULL,	/* returns a pointer to a tcp_sock or NULL=
 */
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common o=
r NULL */
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically alloc=
ated memory or NULL */
+	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
 };
=20
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF=
 programs
@@ -287,6 +288,12 @@ struct bpf_func_proto {
 		enum bpf_arg_type arg_type[5];
 	};
 	int *btf_id; /* BTF ids of arguments */
+	bool (*check_btf_id)(u32 btf_id, u32 arg); /* if the argument btf_id is
+						    * valid. Often used if more
+						    * than one btf id is permitted
+						    * for this argument.
+						    */
+	int *ret_btf_id; /* return value btf_id */
 };
=20
 /* bpf_context is intentionally undefined structure. Pointer to bpf_cont=
ext is
@@ -1524,6 +1531,7 @@ static inline bool bpf_map_is_dev_bound(struct bpf_=
map *map)
=20
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
+void init_btf_sock_ids(struct btf *btf);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1549,6 +1557,9 @@ static inline struct bpf_map *bpf_map_offload_map_a=
lloc(union bpf_attr *attr)
 static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
+static inline void init_btf_sock_ids(struct btf *btf)
+{
+}
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
=20
 #if defined(CONFIG_BPF_STREAM_PARSER)
@@ -1638,6 +1649,7 @@ extern const struct bpf_func_proto bpf_ringbuf_rese=
rve_proto;
 extern const struct bpf_func_proto bpf_ringbuf_submit_proto;
 extern const struct bpf_func_proto bpf_ringbuf_discard_proto;
 extern const struct bpf_func_proto bpf_ringbuf_query_proto;
+extern const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto;
=20
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19684813faae..394fcba27b6a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3252,6 +3252,12 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * struct tcp6_sock *bpf_skc_to_tcp6_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *tcp6_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or NULL otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3395,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(skc_to_tcp6_sock),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e377d1981730..4c3007f428b1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3674,6 +3674,7 @@ struct btf *btf_parse_vmlinux(void)
 		goto errout;
=20
 	bpf_struct_ops_init(btf, log);
+	init_btf_sock_ids(btf);
=20
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7460f967cb75..7de98906ddf4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3800,12 +3800,14 @@ static int int_ptr_type_to_size(enum bpf_arg_type=
 type)
 	return -EINVAL;
 }
=20
-static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
-			  enum bpf_arg_type arg_type,
-			  struct bpf_call_arg_meta *meta)
+static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
+			  struct bpf_call_arg_meta *meta,
+			  const struct bpf_func_proto *fn)
 {
+	u32 regno =3D BPF_REG_1 + arg;
 	struct bpf_reg_state *regs =3D cur_regs(env), *reg =3D &regs[regno];
 	enum bpf_reg_type expected_type, type =3D reg->type;
+	enum bpf_arg_type arg_type =3D fn->arg_type[arg];
 	int err =3D 0;
=20
 	if (arg_type =3D=3D ARG_DONTCARE)
@@ -3885,9 +3887,16 @@ static int check_func_arg(struct bpf_verifier_env =
*env, u32 regno,
 		expected_type =3D PTR_TO_BTF_ID;
 		if (type !=3D expected_type)
 			goto err_type;
-		if (reg->btf_id !=3D meta->btf_id) {
-			verbose(env, "Helper has type %s got %s in R%d\n",
-				kernel_type_name(meta->btf_id),
+		if (!fn->check_btf_id) {
+			if (reg->btf_id !=3D meta->btf_id) {
+				verbose(env, "Helper has type %s got %s in R%d\n",
+					kernel_type_name(meta->btf_id),
+					kernel_type_name(reg->btf_id), regno);
+
+				return -EACCES;
+			}
+		} else if (!fn->check_btf_id(reg->btf_id, arg)) {
+			verbose(env, "Helper does not support %s in R%d\n",
 				kernel_type_name(reg->btf_id), regno);
=20
 			return -EACCES;
@@ -4709,10 +4718,12 @@ static int check_helper_call(struct bpf_verifier_=
env *env, int func_id, int insn
 	meta.func_id =3D func_id;
 	/* check args */
 	for (i =3D 0; i < 5; i++) {
-		err =3D btf_resolve_helper_id(&env->log, fn, i);
-		if (err > 0)
-			meta.btf_id =3D err;
-		err =3D check_func_arg(env, BPF_REG_1 + i, fn->arg_type[i], &meta);
+		if (!fn->check_btf_id) {
+			err =3D btf_resolve_helper_id(&env->log, fn, i);
+			if (err > 0)
+				meta.btf_id =3D err;
+		}
+		err =3D check_func_arg(env, i, &meta, fn);
 		if (err)
 			return err;
 	}
@@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, int func_id, int insn
 		regs[BPF_REG_0].type =3D PTR_TO_MEM_OR_NULL;
 		regs[BPF_REG_0].id =3D ++env->id_gen;
 		regs[BPF_REG_0].mem_size =3D meta.mem_size;
+	} else if (fn->ret_type =3D=3D RET_PTR_TO_BTF_ID_OR_NULL) {
+		int ret_btf_id;
+
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type =3D PTR_TO_BTF_ID_OR_NULL;
+		ret_btf_id =3D *fn->ret_btf_id;
+		if (ret_btf_id =3D=3D 0) {
+			verbose(env, "invalid return type %d of func %s#%d\n",
+				fn->ret_type, func_id_name(func_id), func_id);
+			return -EINVAL;
+		}
+		regs[BPF_REG_0].btf_id =3D ret_btf_id;
 	} else {
 		verbose(env, "unknown return type %d of func %s#%d\n",
 			fn->ret_type, func_id_name(func_id), func_id);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index afaec7e082d9..478c10d1ec33 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1515,6 +1515,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
 		return &bpf_skb_output_proto;
 	case BPF_FUNC_xdp_output:
 		return &bpf_xdp_output_proto;
+	case BPF_FUNC_skc_to_tcp6_sock:
+		return &bpf_skc_to_tcp6_sock_proto;
 #endif
 	case BPF_FUNC_seq_printf:
 		return prog->expected_attach_type =3D=3D BPF_TRACE_ITER ?
diff --git a/net/core/filter.c b/net/core/filter.c
index 73395384afe2..cdcc62f4e2eb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -47,6 +47,7 @@
 #include <linux/seccomp.h>
 #include <linux/if_vlan.h>
 #include <linux/bpf.h>
+#include <linux/btf.h>
 #include <net/sch_generic.h>
 #include <net/cls_cgroup.h>
 #include <net/dst_metadata.h>
@@ -9191,3 +9192,84 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_pro=
g, struct bpf_prog *prog)
 {
 	bpf_dispatcher_change_prog(BPF_DISPATCHER_PTR(xdp), prev_prog, prog);
 }
+
+/* Define a list of socket types which can be the argument for
+ * skc_to_*_sock() helpers. All these sockets should have
+ * sock_common as the first argument in its memory layout.
+ */
+#define BTF_SOCK_TYPE_xxx \
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, "inet_sock")			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, "inet_connection_sock")	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, "inet_request_sock")	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, "inet_timewait_sock")	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, "request_sock")		\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, "sock")			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, "sock_common")		\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, "tcp_sock")			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, "tcp_request_sock")	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, "tcp_timewait_sock")	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, "tcp6_sock")			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, "udp_sock")			\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, "udp6_sock")
+
+enum {
+#define BTF_SOCK_TYPE(name, str) name,
+BTF_SOCK_TYPE_xxx
+#undef BTF_SOCK_TYPE
+MAX_BTF_SOCK_TYPE,
+};
+
+static int btf_sock_ids[MAX_BTF_SOCK_TYPE];
+
+#ifdef CONFIG_BPF_SYSCALL
+static const char *bpf_sock_types[] =3D {
+#define BTF_SOCK_TYPE(name, str) str,
+BTF_SOCK_TYPE_xxx
+#undef BTF_SOCK_TYPE
+};
+
+void init_btf_sock_ids(struct btf *btf)
+{
+	int i, btf_id;
+
+	for (i =3D 0; i < MAX_BTF_SOCK_TYPE; i++) {
+		btf_id =3D btf_find_by_name_kind(btf, bpf_sock_types[i],
+					       BTF_KIND_STRUCT);
+		if (btf_id > 0)
+			btf_sock_ids[i] =3D btf_id;
+	}
+}
+#endif
+
+static bool check_arg_btf_id(u32 btf_id, u32 arg)
+{
+	int i;
+
+	/* only one argument, no need to check arg */
+	for (i =3D 0; i < MAX_BTF_SOCK_TYPE; i++)
+		if (btf_sock_ids[i] =3D=3D btf_id)
+			return true;
+	return false;
+}
+
+BPF_CALL_1(bpf_skc_to_tcp6_sock, struct sock *, sk)
+{
+	/* tcp6_sock type is not generated in dwarf and hence btf,
+	 * trigger an explicit type generation here.
+	 */
+	BTF_TYPE_EMIT(struct tcp6_sock);
+	if (sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP &&
+	    sk->sk_family =3D=3D AF_INET6)
+		return (unsigned long)sk;
+
+	return (unsigned long)NULL;
+}
+
+const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto =3D {
+	.func			=3D bpf_skc_to_tcp6_sock,
+	.gpl_only		=3D false,
+	.ret_type		=3D RET_PTR_TO_BTF_ID_OR_NULL,
+	.arg1_type		=3D ARG_PTR_TO_BTF_ID,
+	.check_btf_id		=3D check_arg_btf_id,
+	.ret_btf_id		=3D &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
+};
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 91fa668fa860..6c2f64118651 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -421,6 +421,7 @@ class PrinterHelpers(Printer):
             'struct sockaddr',
             'struct tcphdr',
             'struct seq_file',
+            'struct tcp6_sock',
=20
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -458,6 +459,7 @@ class PrinterHelpers(Printer):
             'struct sockaddr',
             'struct tcphdr',
             'struct seq_file',
+            'struct tcp6_sock',
     }
     mapped_types =3D {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 19684813faae..394fcba27b6a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3252,6 +3252,12 @@ union bpf_attr {
  * 		case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
  * 		is returned or the error code -EACCES in case the skb is not
  * 		subject to CHECKSUM_UNNECESSARY.
+ *
+ * struct tcp6_sock *bpf_skc_to_tcp6_sock(void *sk)
+ *	Description
+ *		Dynamically cast a *sk* pointer to a *tcp6_sock* pointer.
+ *	Return
+ *		*sk* if casting is valid, or NULL otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3389,7 +3395,8 @@ union bpf_attr {
 	FN(ringbuf_submit),		\
 	FN(ringbuf_discard),		\
 	FN(ringbuf_query),		\
-	FN(csum_level),
+	FN(csum_level),			\
+	FN(skc_to_tcp6_sock),
=20
 /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
  * function eBPF program intends to call
--=20
2.24.1

